# Tap the Dot

A simple, fun Flutter game for Android. Tap the colored dot as fast as you can before it disappears! Tracks your score, reaction time, and high score offline.

## Game Mechanics
- A colored dot appears randomly on the screen.
- Tap the dot before it vanishes (~1.5s) to score!
- Miss a dot, and you'll see a brief 'Miss' animation.
- Game lasts 20 rounds. High scores saved on your device.
- View your score, last reaction time, and try to beat your record.

## How to Run
1. Ensure you have Flutter installed for Android.
2. Clone/download this repo.
3. In terminal, run:

```shell
flutter clean && flutter pub get && flutter run -d emulator-5554
```

This runs the app on the default Android emulator.

## Features
- Smooth animations & clean, colorful UI
- Local state management with Riverpod
- Fun score transitions
- High score persistence (no online connectivity needed)
- All icons and sounds are included locally (see /assets)

## Optional Features
- [ ] Difficulty scaling
- [ ] Sound effects for hits/misses (assets included if you want to use them)
- [ ] Timer mode, local leaderboard (community contributions welcome)

---
**Made with Flutter**
