# App Assets

This directory contains app assets like icons and images.

## Required Files

### App Icon

Place the following files for the app icon:

| File | Size | Description |
|------|------|-------------|
| `icon/app_icon.png` | 1024x1024 | Main app icon |
| `icon/app_icon_foreground.png` | 512x512 | Android adaptive icon foreground |

## Generating Icons

After placing the icon files, run:

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

## Design Guidelines

The app uses a **Brutalist** design style:

- Primary color: `#CCFF00` (fluorescent yellow)
- Background: `#000000` (black)
- Danger: `#FF3333` (red)

The icon should reflect this style with:
- Bold, high-contrast design
- Simple geometric shapes
- Black background with yellow/white elements
