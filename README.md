# GuessKaro

A kid-friendly, charades-style guessing game built with Flutter. Players hold the phone to their forehead; others give clues. Tilting the phone down marks a word correct, tilting up passes to the next clue. This early iteration targets ages 7–12 with curated, age-appropriate word lists.

## Current status
- Project scaffold with navigation routes and placeholder screens for Home, Setup, Play, and Summary flows.
- Shared state wired for game configuration and round tracking.
- Static word lists bundled for core kid-friendly categories.

## Local development
> Flutter is not installed in this environment. Install Flutter 3.16+ locally to run and build the app.

1. Install Flutter: <https://docs.flutter.dev/get-started/install>
2. Get dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```
4. Run format and static analysis:
   ```bash
   flutter format .
   flutter analyze
   ```

## Project structure
```
lib/
  app.dart          # Theme and app shell
  routes.dart       # Centralized GoRouter configuration
  main.dart         # Entry point
  models/           # Data models (config, round result)
  state/            # Providers and state containers
  screens/          # UI screens (home, setup, play, summary)
assets/words/       # Bundled JSON word lists per category
```

## Gameplay outline
1. Select one or more categories on Home.
2. Configure the round (timer, round count) on Setup.
3. Tilt-driven gameplay on Play: down = correct, up = pass. Timer counts down.
4. Summary shows correct/passed words and offers to replay.

## Accessibility
- High-contrast theme toggle
- Large text option
- Mute/haptics controls (planned wiring in settings section)

## Next steps
- Hook up sensors for tilt detection
- Add audio/haptic feedback and settings persistence
- Flesh out animations and timer visuals on the Play screen
