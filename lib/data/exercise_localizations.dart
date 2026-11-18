/// Terjemahan konten latihan ke Bahasa Indonesia.
///
/// Data asli (`assets/exercises.json`) berbahasa Inggris dan tidak diubah.
/// Terjemahan diterapkan saat repository memuat data, dipetakan lewat `code`.
class ExerciseLocalization {
  const ExerciseLocalization({required this.name, required this.description});

  final String name;
  final String description;
}

const Map<String, ExerciseLocalization> kExerciseLocalizationsId = {
  'BACK_EXTENSIONS': ExerciseLocalization(
    name: 'Ekstensi Punggung',
    description:
        'Posisikan tubuh pada mesin back extension, kunci kaki, lalu atur bantalan '
        'tepat di bawah pinggul. Mulai dengan tubuh bagian atas lurus sejajar kaki. '
        'Turunkan torso dengan menekuk pinggul, jaga punggung tetap rata dan turun '
        'sejauh mobilitas memungkinkan. Balikkan gerakan dengan mengencangkan otot '
        'punggung bawah untuk mengangkat torso hingga tubuh kembali lurus, tanpa '
        'hiperekstensi. Untuk menambah beban, kamu bisa memegang plat beban di dada.',
  ),
  'LEG_EXTENSION': ExerciseLocalization(
    name: 'Ekstensi Kaki',
    description:
        'Duduk di mesin dengan punggung menempel rata pada bantalan. Letakkan kaki di '
        'bawah bantalan sehingga menyentuh area pergelangan kaki. Kencangkan otot paha '
        'depan untuk mengangkat bantalan hingga tungkai lurus penuh. Kemudian turunkan '
        'kembali secara terkontrol ke posisi awal dan ulangi. Latihan ini juga bisa '
        'dilakukan satu kaki bergantian.',
  ),
  'BARBELL_SHOULDER_PRESS': ExerciseLocalization(
    name: 'Press Bahu Barbel',
    description:
        'Berdiri tegap dengan kaki selebar bahu dan barbel berada di ketinggian bahu, '
        'telapak tangan menghadap depan, siku sedikit di depan bar. Aktifkan otot inti '
        'dan tarik tulang belikat ke belakang. Dorong barbel lurus ke atas hingga lengan '
        'lurus di atas kepala tanpa mengunci siku. Di posisi atas, posisikan bar sedikit '
        'di belakang kepala agar sejajar. Turunkan barbel kembali ke ketinggian bahu '
        'dengan terkontrol. Jaga torso tetap tegak sepanjang gerakan dan hindari '
        'condong ke belakang.',
  ),
  'LYING_BARBELL_EXTENSIONS': ExerciseLocalization(
    name: 'Ekstensi Barbel Berbaring',
    description:
        'Duduk di bangku datar dengan barbel bertumpu di paha, pegang dengan grip '
        'overhand yang sempit. Berbaring dan luruskan lengan sehingga barbel tepat di '
        'atas dada, tegak lurus terhadap torso. Dengan siku rapat dan tidak bergerak, '
        'turunkan barbel ke arah dahi hanya dengan menekuk siku. Setelah bar mendekati '
        'dahi, luruskan kembali lengan ke posisi awal tanpa mengunci siku. Hanya lengan '
        'bawah yang bergerak selama latihan.',
  ),
  'INCLINE_BARBELL_BENCH_PRESS': ExerciseLocalization(
    name: 'Bench Press Barbel Incline',
    description:
        'Berbaring di bangku incline dengan kaki menapak kuat di lantai. Pegang barbel '
        'sedikit lebih lebar dari bahu. Lepas bar dari rak dan posisikan tepat di atas '
        'dada bagian atas. Turunkan bar secara terkontrol dengan menekuk siku hingga '
        'menyentuh dada bagian atas. Dorong kembali bar ke atas dengan meluruskan lengan, '
        'berhenti sebelum siku terkunci. Jaga punggung rata pada bangku, pertahankan '
        'simetri, dan hindari lengkungan berlebihan. Kembalikan bar ke rak dengan aman '
        'setelah satu set selesai.',
  ),
  'INCLINE_CHEST_PRESS_MACHINE': ExerciseLocalization(
    name: 'Chest Press Mesin Incline',
    description:
        'Atur ketinggian kursi agar handle sejajar dengan dada bagian atas. Duduk dengan '
        'punggung menempel pada bantalan dan kaki rata di lantai. Pegang handle dengan '
        'kuat dan dorong ke atas sedikit ke depan dengan meluruskan lengan, tanpa '
        'mengunci siku di posisi atas. Turunkan handle kembali secara perlahan dan '
        'terkontrol ke posisi awal. Jaga dada tetap aktif dan punggung tersangga '
        'sepanjang gerakan.',
  ),
  'BARBELL_BENCH_PRESS': ExerciseLocalization(
    name: 'Bench Press Barbel',
    description:
        'Berbaring datar di bangku dengan kaki menapak kuat di lantai. Pegang barbel '
        'sedikit lebih lebar dari bahu, pergelangan tangan sejajar dengan siku. Lepas '
        'bar dari rak dan posisikan di atas dada. Turunkan bar secara terkontrol dengan '
        'menekuk siku hingga ke tengah dada, siku membentuk sudut sekitar 45 derajat '
        'dari torso. Dorong bar ke atas hingga lengan lurus tanpa mengunci siku. Jaga '
        'simetri kedua lengan dan hindari lengkungan berlebihan pada punggung bawah. '
        'Di akhir set, kembalikan bar ke rak dengan hati-hati.',
  ),
  'DUMBBELL_SHOULDER_PRESS': ExerciseLocalization(
    name: 'Press Bahu Dumbbell',
    description:
        'Duduk di bangku dengan sandaran punggung, pegang satu dumbbell di tiap tangan '
        'dan letakkan di paha. Gunakan kaki untuk membantu mengangkat dumbbell ke '
        'ketinggian bahu, siku tertekuk dan telapak menghadap depan. Dorong dumbbell ke '
        'atas hingga lengan lurus di atas kepala, dekatkan sedikit beban di posisi atas '
        'tanpa mengunci siku. Turunkan dumbbell secara terkontrol kembali ke ketinggian '
        'bahu. Jaga otot inti tetap kencang dan hindari melengkungkan punggung. Latihan '
        'ini juga bisa dilakukan sambil berdiri, tetapi membutuhkan postur dan '
        'keterlibatan inti yang ketat.',
  ),
  'PLANK': ExerciseLocalization(
    name: 'Plank',
    description:
        'Berlutut, lalu letakkan siku di matras dan luruskan kaki sehingga beban terbagi '
        'antara ujung kaki dan lengan bawah. Punggung harus tetap lurus selama tahanan. '
        'Kencangkan otot perut untuk mempertahankan posisi selama durasi set, lalu '
        'rileks.',
  ),
  'DECLINE_DUMBBELL_BENCH_PRESS': ExerciseLocalization(
    name: 'Bench Press Dumbbell Decline',
    description:
        'Duduk di bangku decline dengan satu dumbbell di tiap tangan menggunakan grip '
        'netral atau standar. Berbaring dan kunci kaki di bawah bantalan penopang. Bawa '
        'dumbbell ke ketinggian dada lalu dorong ke atas hingga lengan hampir lurus, '
        'dekatkan beban di posisi atas. Turunkan dumbbell perlahan secara terkontrol '
        'membentuk busur ke arah dada bagian bawah dengan menekuk siku. Hindari mengunci '
        'siku di posisi atas. Jaga kontrol dan simetri kedua lengan, tetap bersandar pada '
        'bangku, dan hindari lengkungan berlebihan.',
  ),
  'ROPE_TRICEPS_EXTENSION': ExerciseLocalization(
    name: 'Ekstensi Trisep Tali',
    description:
        'Pasang handle tali pada katrol tinggi dan berdiri menghadap mesin kabel. Pegang '
        'tali dengan grip netral, siku rapat ke tubuh, dan lengan bawah sejajar lantai. '
        'Luruskan lengan ke bawah, dorong tali ke arah paha sambil sedikit memisahkan '
        'ujung tali di bagian bawah gerakan. Kencangkan trisep di akhir, lalu perlahan '
        'kembali ke posisi awal dengan menekuk siku. Hanya lengan bawah yang bergerak '
        'selama latihan.',
  ),
  'CLOSE_GRIP_PUSH_UPS': ExerciseLocalization(
    name: 'Push-Up Grip Sempit',
    description:
        'Ambil posisi berlutut lalu letakkan tangan di lantai berdekatan, tepat di bawah '
        'dada. Luruskan kaki ke belakang membentuk plank dengan tumpuan ujung kaki. Jaga '
        'tubuh lurus dan aktifkan otot inti. Turunkan dada ke arah lantai dengan menekuk '
        'siku tetap rapat ke torso. Hindari siku melebar keluar. Setelah dada hampir '
        'menyentuh lantai, dorong melalui telapak tangan untuk kembali ke posisi awal. '
        'Jaga punggung tetap lurus dan gerakan tetap terkontrol.',
  ),
  'STIFF_LEG_DEADLIFT': ExerciseLocalization(
    name: 'Deadlift Kaki Kaku',
    description:
        'Berdiri di depan barbel yang diletakkan di lantai. Bungkukkan tubuh dengan '
        'punggung tetap lurus dan lutut sedikit tertekuk untuk memegang bar dengan grip '
        'pronasi (telapak menghadapmu). Aktifkan punggung bawah untuk mengangkat torso, '
        'jaga kaki hampir lurus. Tahan sebentar di posisi atas, lalu turunkan bar kembali '
        'ke lantai dengan punggung tetap lurus. Jaga bahu tetap ditarik ke belakang '
        'sepanjang gerakan.',
  ),
  'LEG_PRESS_CALF_RAISES': ExerciseLocalization(
    name: 'Calf Raise Leg Press',
    description:
        'Duduk dengan punggung menempel kuat pada sandaran. Letakkan ujung kaki di bagian '
        'bawah platform, selebar bahu. Buka kunci leg press menggunakan handle, lalu '
        'luruskan kaki tanpa mengunci lutut. Dorong melalui otot betis untuk mengangkat '
        'tumit dan berdiri di ujung kaki. Turunkan tumit perlahan kembali ke posisi awal. '
        'Pastikan punggung dan bokong tetap menempel pada kursi sepanjang waktu.',
  ),
  'PUSH_UPS': ExerciseLocalization(
    name: 'Push-Up',
    description:
        'Mulai dari posisi merangkak, letakkan tangan selebar bahu atau sedikit lebih '
        'lebar, dan kaki lurus ke belakang dengan ujung kaki menapak. Jaga tubuh lurus '
        'dari kepala hingga tumit dengan mengaktifkan otot inti dan bokong. Turunkan dada '
        'ke arah lantai dengan menekuk siku tetap dekat dengan sisi tubuh. Saat dada '
        'hampir menyentuh lantai, dorong melalui telapak tangan untuk meluruskan lengan '
        'dan kembali ke posisi awal. Jaga tulang punggung tetap lurus dan hindari pinggul '
        'turun atau naik selama gerakan.',
  ),
};
