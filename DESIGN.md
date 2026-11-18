---
version: alpha
name: Body2Fit -Master Your Bodyweight, Transform Your Health."
description: >-
  Body2Fit adalah aplikasi panduan calisthenics dan pemantau kesehatan tubuh yang dirancang untuk membantumu membangun
  kekuatan, fleksibilitas, dan kebugaran dari mana saja—tanpa perlu alat gym. Dilengkapi panduan gerakan visual dan
  pelacak progres harian yang praktis.
logo:
  src: https://workoutapi.com/favicons/favicon.svg?v=1
  srcDark: https://workoutapi.com/favicons/favicon.svg?v=1
colors:
  surface: '#0d1017'
  surface-dim: '#0a0d13'
  surface-bright: '#292e3a'
  surface-container-lowest: '#080a0f'
  surface-container-low: '#111520'
  surface-container: '#1a1e28'
  surface-container-high: '#292e3a'
  surface-container-highest: '#3f3f46'
  on-surface: '#f5f5f7'
  on-surface-variant: '#a1a1aa'
  inverse-surface: '#f5f5f7'
  inverse-on-surface: '#1a1e28'
  outline: '#71717a'
  outline-variant: '#3f3f46'
  surface-tint: '#ff5d68'
  primary: '#ff5d68'
  on-primary: '#1a0507'
  primary-container: '#b91c1c'
  on-primary-container: '#fee2e2'
  inverse-primary: '#b91c1c'
  secondary: '#155dfc'
  on-secondary: '#ffffff'
  secondary-container: '#1e3a6e'
  on-secondary-container: '#dbe7ff'
  tertiary: '#6a7282'
  on-tertiary: '#ffffff'
  tertiary-container: '#292e3a'
  on-tertiary-container: '#d4d4d8'
  error: '#ff5d68'
  on-error: '#1a0507'
  error-container: '#991b1b'
  on-error-container: '#fee2e2'
  primary-fixed: '#ffb3b8'
  primary-fixed-dim: '#ff5d68'
  on-primary-fixed: '#1a0507'
  on-primary-fixed-variant: '#991b1b'
  secondary-fixed: '#bfd4ff'
  secondary-fixed-dim: '#155dfc'
  on-secondary-fixed: '#0b1d40'
  on-secondary-fixed-variant: '#1e3a6e'
  tertiary-fixed: '#d4d4d8'
  tertiary-fixed-dim: '#6a7282'
  on-tertiary-fixed: '#18181b'
  on-tertiary-fixed-variant: '#3f3f46'
  background: '#0d1017'
  on-background: '#f5f5f7'
  surface-variant: '#1a1e28'
typography:
  display:
    fontFamily: Comfortaa
    fontSize: 60px
    fontWeight: 700
    lineHeight: 75px
    letterSpacing: '-1.5px'
  headline-lg:
    fontFamily: InterVariable
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 37.76px
    letterSpacing: '-0.025em'
  headline-md:
    fontFamily: InterVariable
    fontSize: 32px
    fontWeight: 600
    lineHeight: 37.76px
    letterSpacing: '-0.8px'
  title-lg:
    fontFamily: InterVariable
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 26px
  body-lg:
    fontFamily: InterVariable
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: InterVariable
    fontSize: 16px
    fontWeight: 400
    lineHeight: 25.6px
  label-md:
    fontFamily: InterVariable
    fontSize: 16px
    fontWeight: 400
    lineHeight: 25.6px
  label-sm:
    fontFamily: InterVariable
    fontSize: 10px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.05em
rounded:
  sm: 4px
  DEFAULT: 12px
  md: 12px
  lg: 18.4px
  xl: 18.4px
  full: 9999px
spacing:
  unit: 4px
  xs: 4px
  sm: 8px
  md: 12px
  lg: 16px
  xl: 24px
  gutter: 24px
  container-max: 1300px
elevation:
  sm: 0 1px 2px rgba(0,0,0,0.25)
  md: 0 4px 12px rgba(0,0,0,0.35)
  lg: 0 20px 40px rgba(0,0,0,0.45)
layout:
  containerMaxWidth: 1300px
  gridColumns: 12
components:
  button-primary:
    backgroundColor: '{colors.primary}'
    textColor: '{colors.on-primary}'
    typography: '{typography.label-md}'
    rounded: '{rounded.DEFAULT}'
    padding: 10px 12px
    height: 48px
  button-primary-hover:
    backgroundColor: '{colors.primary-fixed}'
    textColor: '{colors.on-primary-fixed}'
  button-secondary:
    backgroundColor: transparent
    textColor: '{colors.on-surface}'
    typography: '{typography.label-md}'
    rounded: '{rounded.DEFAULT}'
    padding: 10px 12px
    height: 48px
  button-secondary-hover:
    backgroundColor: '{colors.surface-container-high}'
    textColor: '{colors.on-surface}'
  card:
    backgroundColor: '{colors.surface-container}'
    textColor: '{colors.on-surface}'
    rounded: '{rounded.lg}'
    padding: '{spacing.lg}'
  card-hover:
    backgroundColor: '{colors.surface-container-high}'
  program-exercise-card:
    backgroundColor: '{colors.surface-container-low}'
    textColor: '{colors.on-surface}'
    rounded: '{rounded.lg}'
    padding: '{spacing.md}'
  program-exercise-card-active:
    backgroundColor: '{colors.surface-container}'
    textColor: '{colors.on-surface}'
  input-field:
    backgroundColor: '{colors.surface-container-low}'
    textColor: '{colors.on-surface}'
    typography: '{typography.body-md}'
    rounded: '{rounded.DEFAULT}'
    padding: '{spacing.sm}'
  nav-link:
    backgroundColor: transparent
    textColor: '{colors.on-surface-variant}'
    typography: '{typography.body-md}'
    rounded: '{rounded.DEFAULT}'
    padding: 6px 16px
  nav-link-hover:
    backgroundColor: transparent
    textColor: '{colors.on-surface}'
  list-item:
    backgroundColor: transparent
    rounded: '{rounded.md}'
    padding: '{spacing.sm}'
  list-item-hover:
    backgroundColor: '{colors.surface-container-high}'
    textColor: '{colors.primary}'
  badge:
    backgroundColor: rgba(255,93,104,0.15)
    textColor: '{colors.primary}'
    typography: '{typography.label-sm}'
    rounded: '{rounded.full}'
    padding: '{spacing.sm}'
---

## Overview

Workout API is a developer toolkit that lets fitness product teams ship structured exercise data, personalized program generation, embeddable exercise views, program sharing, and PDF export without building a training engine in-house. The interface presents the API as a living product: a generated workout card floats over a dark, faintly gridded canvas that glows coral from the lower-left, so the developer sees the output before reading the docs. The emotional response is calm competence, with the glow adding warmth to what is otherwise a technical surface.

The voice is direct, instructional, and unhyped. Copy leads with the verb and the object ("Add structured exercise data", "Try the generator") and qualifies friction explicitly ("No sign-up required to try the live demo"). Vocabulary is drawn from training practice (sets, reps, rest, hypertrophy) rather than marketing abstraction, which signals that the product is built by people who understand the domain. Example sentence: "Day 1 — Upper Body: four exercises, 60 minutes, rest intervals set per lift."

## Colors

Primary (#ff5d68) is the signature accent, used exclusively on the hero CTA "Try the generator" (filled, 12px radius), active program rows, eyebrow labels such as "Generated program", and the underline on the secondary "View API docs" link. Its deep counterpart #b91c1c is reserved for pressed or container states and never for body text. Secondary (#155dfc) is a restrained cobalt used only for informational highlights and focus rings, never on large surfaces. Tertiary (#6a7282) is a cool slate for metadata lines such as "INTERMEDIATE · 60 MIN" and secondary captions.

The surface stack runs from #0d1017 (page base) through #1a1e28 (cards) to #292e3a (hover and raised rows). The hero adds a radial gradient from #1a1e28 to #0d1017 with a red bloom at the lower-left edge; use it only behind th

## Typography

The type system pairs Comfortaa, a rounded geometric display face used only for the wordmark and H1 at 60px/75px with -1.5px tracking, with InterVariable for everything else. The rounded display face gives the brand a friendly, athletic softness; Inter carries the technical load of documentation and code-adjacent UI. Headlines (32px, weight 600) use -0.8px tracking so they read tight but legible; body copy stays at 16px/25.6px for line lengths near 60 characters. Apply font-weight 600 and uppercase at 10px with letter-spacing 0.05em for eyebrow labels, and keep weight 400 for all paragraph text.

## Layout

The grid is fluid up to a fixed container of 1300px with 24px horizontal padding at xl breakpoints (1280px) and 16px below, yielding a 12-column model inside the container. The hero splits roughly 45/55 between headline copy and the product mock; the mock is pinned to a 360px-wide card with 16px internal padding. Section separation uses the xl spacing token (24px) between blocks and a 1px bottom border in surface-container-high for feature rows. White space is generous around the hero and tight inside cards, where the lg (16px) and md (12px) steps keep exercise rows dense and scannable.

## Elevation & Depth

Hierarchy is conveyed mostly by tonal layering rather than shadow. Level 1 (page): #0d1017 with the grid texture at 40px spacing and 1px lines at rgba(255,255,255,0.04). Level 2 (cards and program container): #1a1e28 background, 1px border rgba(255,255,255,0.08), and box-shadow 0 20px 40px rgba(0,0,0,0.45). Level 3 (active or hovered rows): #292e3a background with the md shadow 0 4px 12px rgba(0,0,0,0.35). The drop-shadow-md utility applied to the navigation dropdown uses the same family at a smaller offset.

## Shapes

The shape language is soft-technical. Buttons and nav dropdown items use a 12px radius, cards and program containers use 18.4px, and pills, badges and the status dot use full rounding. Inputs follow the 12px default so that form controls sit visually between buttons and cards. Radii increase with container size, which keeps small interactive elements crisp while larger surfaces feel approachable.

## Components

### Action Elements
The primary button is a filled coral pill-rectangle at 48px height, 12px radius and 10px 12px padding, with label-md text in on-primary. On hover it shifts to primary-fixed (#ffb3b8) over 150ms ease-out. The secondary button is text-led: transparent background, on-surface label, and a 2px underline in primary that animates in over 200ms.

### Containers & Surfaces
Cards use surface-container with an 18.4px radius, 16px padding and a 1px border of rgba(255,255,255,0.08). The generated-program container stacks exercise rows at 12px vertical gap; each row is surface-container-low with an 18.4px radius, and the active row gains a 1px primary border. Hover lifts the card background to surface-container-high over 200ms.

### Inputs & Interaction
Input fields sit on surface-co

## Do's and Don'ts

**Do**
- Do reserve #ff5d68 for CTAs, active states and eyebrow labels so the accent keeps its meaning.
- Do pair Comfortaa display headlines only with InterVariable body copy.
- Do keep exercise rows at 12px vertical gap and 16px internal padding for dense, scannable lists.
- Do layer surfaces tonally (#0d1017 → #1a1e28 → #292e3a) before reaching for shadows.

**Don't**
- Don't fill large surfaces with the coral accent; it is a signal color, not a background.
- Don't apply the red radial bloom inside cards, where it will reduce text contrast.
- Don't mix more than one radius inside a single component group.
- Don't use Comfortaa for body copy, labels or code samples.
