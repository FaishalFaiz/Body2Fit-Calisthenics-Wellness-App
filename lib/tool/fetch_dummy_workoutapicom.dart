// tool/fetch_home_exercises.dart
//
// Fetch latihan dari WorkoutAPI.com, simpan JSON dan unduh gambar statis (PNG) + animasi (GIF).
//
// Setup (sekali):   dart pub add http
// Jalankan:         WORKOUT_API_KEY=xxxx
//                   dart run lib\tool\fetch_dummy_workoutapicom.dart
//
// Opsi:
//   --count=15         jumlah latihan
//   --lang=en-US       en-US | fr-FR | es-ES
//   --full-visuals     unduh semua kombinasi gambar statis
//                      (basic+muscles x concentric+eccentric).
//                      Tanpa opsi ini hanya basic + concentric (untuk card).
//
// Hasil:
//   assets/data/exercises.json
//   assets/exercises/images/<id>_<variant>_<phase>.png   (card: basic_concentric)
//   assets/exercises/basic/<id>.gif
//   assets/exercises/muscles/<id>.gif

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;

const baseUrl = 'https://api.workoutapi.com';

/// Path endpoint gambar statis (dikonfirmasi dari contoh curl di dokumentasi).
/// Jika dikosongkan, skrip akan mencoba kandidat di bawah.
const String visualPathOverride = '/exercises/:id/image';

const visualPathCandidates = [
  '/exercises/:id/illustration',
  '/exercises/:id/image',
  '/exercises/:id/visual',
  '/exercises/:id/illustrations',
];

const searchTerms = [
  'press', 'squat', 'curl', 'row', 'pull', 'push', 'deadlift', 'lunge',
  'raise', 'extension', 'fly', 'plank', 'crunch', 'dip', 'shrug',
];

Future<void> main(List<String> args) async {
  final apiKey = Platform.environment['WORKOUT_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    stderr.writeln('WORKOUT_API_KEY belum di-set. Lihat petunjuk di bagian atas file.');
    exit(1);
  }

  String? opt(String name) {
    for (final a in args) {
      if (a.startsWith('--$name=')) return a.substring(name.length + 3);
    }
    return null;
  }

  final count = int.tryParse(opt('count') ?? '') ?? 15;
  final lang = opt('lang') ?? 'en-US';
  final fullVisuals = args.contains('--full-visuals');
  final rng = Random();

  // 1) Kumpulkan pool lewat beberapa kata kunci acak (hemat kuota),
  //    lalu ambil `count` latihan secara acak dari pool.
  final terms = [...searchTerms]..shuffle(rng);
  final pool = <String, Map<String, dynamic>>{};

  for (final term in terms) {
    if (pool.length >= count * 2) break;
    final uri = Uri.parse('$baseUrl/exercises/search')
        .replace(queryParameters: {'q': term});
    final res = await _get(uri, {
      'Accept': 'application/json',
      'Accept-Language': lang,
      'x-api-key': apiKey,
    });
    if (res == null) continue;

    final list = jsonDecode(utf8.decode(res.bodyBytes));
    if (list is! List) continue;
    for (final item in list) {
      if (item is Map<String, dynamic> && item['id'] is String) {
        pool.putIfAbsent(item['id'] as String, () => item);
      }
    }
    stdout.writeln('"$term" -> pool: ${pool.length}');
  }

  if (pool.isEmpty) {
    stderr.writeln('Tidak ada data didapat. Periksa API key dan koneksi.');
    exit(1);
  }
  if (pool.length < count) {
    stderr.writeln('Pool hanya ${pool.length}, kurang dari $count. Lanjut dengan yang ada.');
  }

  final picked = (pool.values.toList()..shuffle(rng)).take(count).toList();

  // 2) Simpan JSON.
  final dataFile = File('assets/data/exercises.json');
  await dataFile.create(recursive: true);
  await dataFile.writeAsString(
    const JsonEncoder.withIndent('  ').convert(picked),
  );
  stdout.writeln('Tersimpan ${picked.length} latihan -> ${dataFile.path}');

  // 3) Unduh gambar statis (PNG).
  final combos = fullVisuals
      ? [
          for (final v in ['basic', 'muscles'])
            for (final p in ['concentric', 'eccentric']) (v, p)
        ]
      : [('basic', 'concentric')];

  String? visualPath =
      visualPathOverride.isNotEmpty ? visualPathOverride : null;

  for (final ex in picked) {
    final id = ex['id'] as String;
    for (final (variant, phase) in combos) {
      final out = File('assets/exercises/images/${id}_${variant}_$phase.png');
      final params = {'format': 'png', 'variant': variant, 'phase': phase};
      final imgHeaders = {'Accept': 'image/png', 'x-api-key': apiKey};

      http.Response? res;
      if (visualPath == null) {
        // Deteksi path yang benar pada permintaan pertama.
        for (final candidate in visualPathCandidates) {
          final uri = _visualUri(candidate, id, params);
          final r = await _tryGet(uri, imgHeaders);
          if (r != null && _isImage(r)) {
            visualPath = candidate;
            res = r;
            stdout.writeln('Path gambar statis terdeteksi: $candidate');
            break;
          }
        }
        if (visualPath == null) {
          stderr.writeln(
            'Gagal menemukan path gambar statis. Isi visualPathOverride di '
            'skrip dengan path dari dokumentasi, lalu jalankan ulang.',
          );
          break;
        }
      } else {
        res = await _get(_visualUri(visualPath, id, params), imgHeaders);
      }

      if (res == null) continue;
      await out.create(recursive: true);
      await out.writeAsBytes(res.bodyBytes);
      stdout.writeln('PNG $variant/$phase: ${ex['name']}');
    }
    if (visualPath == null) break;
  }

  // 4) Unduh GIF (basic + muscles) untuk halaman detail.
  for (final ex in picked) {
    final id = ex['id'] as String;
    for (final variant in ['basic', 'muscles']) {
      final uri = Uri.parse('$baseUrl/exercises/$id/animation')
          .replace(queryParameters: {'variant': variant});
      final res = await _get(uri, {
        'Accept': 'image/gif',
        'x-api-key': apiKey,
      });
      if (res == null) continue;
      final out = File('assets/exercises/$variant/$id.gif');
      await out.create(recursive: true);
      await out.writeAsBytes(res.bodyBytes);
      stdout.writeln('GIF $variant: ${ex['name']}');
    }
  }

  stdout.writeln('Selesai.');
}

Uri _visualUri(String path, String id, Map<String, String> params) =>
    Uri.parse('$baseUrl${path.replaceFirst(':id', id)}')
        .replace(queryParameters: params);

bool _isImage(http.Response r) =>
    (r.headers['content-type'] ?? '').toLowerCase().startsWith('image/');

/// Satu kali coba tanpa retry/exit, dipakai untuk mendeteksi path.
Future<http.Response?> _tryGet(Uri uri, Map<String, String> headers) async {
  try {
    final res = await http.get(uri, headers: headers);
    await Future.delayed(const Duration(milliseconds: 300));
    if (res.statusCode == 401 || res.statusCode == 403) {
      stderr.writeln('${res.statusCode}: periksa API key. ${res.body}');
      exit(1);
    }
    return res.statusCode == 200 ? res : null;
  } catch (_) {
    return null;
  }
}

/// GET dengan jeda ringan, backoff saat 429/5xx, berhenti jika 401/403.
Future<http.Response?> _get(Uri uri, Map<String, String> headers) async {
  for (var attempt = 1; attempt <= 4; attempt++) {
    final res = await http.get(uri, headers: headers);
    await Future.delayed(const Duration(milliseconds: 300));

    if (res.statusCode == 200) return res;

    if (res.statusCode == 429 || res.statusCode >= 500) {
      final wait = Duration(seconds: 2 * attempt * attempt);
      stderr.writeln('${res.statusCode} di $uri, tunggu ${wait.inSeconds}s');
      await Future.delayed(wait);
      continue;
    }

    stderr.writeln('${res.statusCode} di $uri: ${res.body}');
    if (res.statusCode == 401 || res.statusCode == 403) exit(1);
    return null;
  }
  return null;
}