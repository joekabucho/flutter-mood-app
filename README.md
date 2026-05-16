# Mood Tracker

A single-screen **Flutter web** app for logging how you feel. Moods are represented by faces drawn on the canvas with `CustomPainter` — no emoji, images, or icon fonts.

## Features

### Mood logging
- Tap **Happy**, **Neutral**, or **Sad** to record your current mood
- A floating snackbar confirms each log
- Entries are stored in memory for the session (newest first)

### Timeline (past week)
- Displays your **last 7** mood entries in a **horizontal scrollable** list
- Each card shows:
  - **Date** (weekday + month/day, e.g. `Fri` / `5/15`)
  - A **hand-drawn face** matching the mood
  - A **color accent** bar and left border tinted to that mood

### CustomPainter faces
Three visually distinct expressions, built from basic drawing primitives:

| Mood | Eyes | Eyebrows | Mouth | Extras |
|------|------|----------|-------|--------|
| **Happy** | Filled circles | Upward arcs | Upward smile arc | Blush circles |
| **Neutral** | Horizontal lines | Flat lines | Straight line (curves slightly when animated) | — |
| **Sad** | Droopy arcs | Downward slant | Downward frown arc | Tear shape (`drawPath`) |

Primitives used: `drawCircle`, `drawArc`, `drawLine`, `drawPath`.

### Animations
- **Picker (top):** Idle blink every few seconds; tap plays a blink + expression pulse; hover lifts the card and subtly morphs the face (web)
- **Timeline cards:** Hover lifts the card, strengthens shadow/border, and gently morphs the face (web); tap triggers card bounce/wiggle plus a full face reaction
- All face motion is driven by `blink` and `reaction` values passed into `MoodFacePainter` from `AnimationController`s

### State management
- App data lives in `MoodTrackerScreen` as a `List<MoodEntry>` updated via `setState`
- No Provider, Riverpod, or backend — intentional for a single-screen scope
- UI animation state stays in child widgets (`MoodFace`, `TimelineEntryCard`, `MoodPicker`)

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel, SDK `>=3.2.0`)
- Chrome (recommended for web) or another Flutter-supported browser/device

Check your setup:

```bash
flutter doctor
```

Enable web if needed:

```bash
flutter config --enable-web
```

## Getting started

### 1. Clone the repository

```bash
git clone https://github.com/joekabucho/flutter-mood-app.git
cd flutter-mood-app
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the app

**Web (recommended):**

```bash
flutter run -d chrome
```

**Other targets:**

```bash
# List available devices
flutter devices

# Example: run on a connected device or emulator
flutter run
```

### 4. Run tests

```bash
flutter test
```

### 5. Analyze code

```bash
flutter analyze
```

## Project structure

```
lib/
  main.dart                    # App entry + theme
  models/
    mood.dart                  # Mood enum, colors, labels
    mood_entry.dart            # Single log entry (mood + timestamp)
  painters/
    mood_face_painter.dart     # Canvas drawing for all faces
  screens/
    mood_tracker_screen.dart   # Main screen + entry list state
  widgets/
    mood_face.dart             # Animated CustomPaint wrapper
    mood_picker.dart           # Top mood selection cards
    mood_timeline.dart         # Horizontal timeline list
    timeline_entry_card.dart   # Timeline card (hover + tap)
web/                           # Web entry (index.html, manifest)
test/                          # Widget tests
```

## Usage

1. Open the app in your browser or device.
2. Tap a mood at the top to log how you feel.
3. Scroll the **Past week** timeline to review recent entries.
4. On web, **hover** a timeline card for a preview animation; **click** for a stronger reaction.

> **Note:** Mood history is held in memory only. Refreshing the page clears entries. Persistence (e.g. `shared_preferences`) is a natural next step if you extend the app.

## Tech stack

- Flutter (Material 3)
- Dart 3.2+
- Target: **Web** (also runnable on mobile/desktop with Flutter)

## License

This project is for demonstration purposes. Add a license file if you plan to distribute it.
