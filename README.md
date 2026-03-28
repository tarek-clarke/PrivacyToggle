# PrivacyToggle

A lightweight macOS menu bar app that instantly hides desktop clutter for clean, distraction-free screen sharing.

---

## Features

- **One-click privacy mode** -toggle from the menu bar in one click or with the `P` keyboard shortcut
- **Desktop icon overlay** -covers all Finder desktop icons with your current wallpaper, so nothing personal is visible behind your active window
- **Hides inactive windows** -automatically sends all background apps to hide, leaving only your frontmost app visible
- **Multi-monitor support** -the overlay spans every connected display simultaneously
- **Fully restores on disable** -all hidden apps and windows come back exactly as they were
- **No Dock icon** -runs silently as a menu bar agent, out of your way
- **Zero networking** -the app makes no outbound connections of any kind; fully air-gapped by the macOS sandbox
- **Mac App Store sandbox compliant** -no private APIs, no accessibility permissions, no screen recording required

---

## Requirements

- macOS 13 Ventura or later
- Apple Silicon or Intel Mac

---

## Installation

### Homebrew (recommended)

```bash
brew tap tarek-clarke/privacytoggle
brew install --cask privacytoggle
```

> **First launch note:** Because the app is not yet notarized, macOS Gatekeeper will show a warning the first time you open it. Right-click → **Open** to bypass it -you won't be prompted again.

### Manual

1. Download `PrivacyToggle.dmg` from the [latest release](https://github.com/tarek-clarke/PrivacyToggle/releases/latest)
2. Open the DMG and drag **PrivacyToggle.app** to your Applications folder
3. Launch the app -the `👁` icon will appear in your menu bar

---

## Usage

| Action | How |
|---|---|
| Enable privacy mode | Click the menu bar icon → **Enable Privacy Mode**, or press `P` |
| Disable privacy mode | Click the menu bar icon → **Disable Privacy Mode**, or press `P` |
| Quit | Click the menu bar icon → **Quit PrivacyToggle**, or press `Q` |

When privacy mode is **on**, the menu bar icon switches from `eye.slash` to `eye` so you always know the current state at a glance.

---

## How It Works

1. **Desktop overlay** -a borderless, full-screen `NSWindow` is placed just above the Finder desktop icon layer (`kCGDesktopIconWindowLevel + 1`). It renders your current wallpaper where readable, falling back to a neutral solid colour. Normal application windows sit above it, so your active app is always fully visible.

2. **Window hiding** -`NSRunningApplication.hide()` is called on every regular app that is not the current frontmost app. When you disable privacy mode, `unhide()` restores them all.

---

## Building from Source

```bash
git clone https://github.com/tarek-clarke/PrivacyToggle.git
cd PrivacyToggle
open PrivacyToggle.xcodeproj
```

Then **Product → Run** in Xcode, or from the terminal:

```bash
xcodebuild -scheme PrivacyToggle -configuration Release build
```

---

## Privacy & Security

- No network entitlements -`com.apple.security.network.client` and `.network.server` are absent from the sandbox, blocking all TCP/UDP at the OS level
- `NSAllowsArbitraryLoads = false` in `Info.plist` as an additional ATS layer
- No Accessibility, Screen Recording, or any other sensitive permission is requested
- Full source is available in this repository for audit

---

## License

MIT
