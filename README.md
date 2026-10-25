# Crown Control for macOS

A tiny, source-visible, dependency-free menu bar app that asks Apple Music to quit whenever macOS launches or activates it. This prevents Apple Music staying open when pressing the AirPods Max Digital Crown with no playback active.

## Build on your Mac

1. Inspect `CrownControl.swift` and `build.command` in TextEdit or your preferred code editor.
2. Install Apple's Xcode Command Line Tools if needed: open Terminal and run `xcode-select --install`.
3. In Finder, right-click `build.command` and choose Open (or run `./build.command` in Terminal in this folder).
4. It creates `Crown Control.app` beside the source files. Move it to `/Applications` and launch it.
5. Look for the **♛** menu bar icon. Use its menu to turn protection on/off or quit.
6. Optional: macOS System Settings > General > Login Items & Extensions > Open at Login; add Crown Control.

No Accessibility, Bluetooth, microphone, Input Monitoring, automation, network access or full disk access is needed.

## Behaviour and limitations

- Spotify keeps using the crown's normal media play/pause functionality.
- The app does **not** intercept or remap the crown. It responds to Apple Music launches/activations by requesting Apple Music quit.
- It will also quit Music when you deliberately open Music; disable protection if you ever need it.
- If Music has an unsaved operation or refuses termination, the normal quit request may be ignored. The app does not force quit.
- Menu bar icon may appear as a crown-style glyph depending on installed fonts.
- `codesign --sign -` is local ad-hoc signing, **not** Apple Developer ID signing or notarization.
- The app has not been compiled/tested here because this environment is not macOS.

## Security

The entire application logic is in `CrownControl.swift`. It uses built-in Apple AppKit APIs, contains no downloaded libraries, performs no networking, stores no data, and requires no extra permissions. Review the source and build script before running them.
