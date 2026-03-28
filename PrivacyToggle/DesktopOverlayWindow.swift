import AppKit

/// A borderless, full-screen window that sits just above the Finder desktop
/// icon layer to hide desktop icons without covering normal application windows.
/// The window mimics the current desktop wallpaper where readable, falling back
/// to a solid system-tinted colour otherwise.
final class DesktopOverlayWindow: NSWindow {

    init(screen: NSScreen) {
        super.init(
            contentRect: screen.frame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false,
            screen: screen
        )
        configure(for: screen)
    }

    // MARK: - Private

    private func configure(for screen: NSScreen) {
        // Position the overlay just above Finder's desktop icon layer so that
        // normal application windows (level 0) remain visible above us.
        level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopIconWindow)) + 1)

        // Span all Spaces and remain stationary; never appear in Exposé / Mission Control.
        collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle, .fullScreenAuxiliary]

        isOpaque = true
        hasShadow = false
        // Pass all mouse/keyboard events through so the user can interact with
        // whatever active application is visible above the overlay.
        ignoresMouseEvents = true
        isReleasedWhenClosed = false
        backgroundColor = .black

        contentView = makeBackgroundView(for: screen)
    }

    private func makeBackgroundView(for screen: NSScreen) -> NSView {
        let frame = NSRect(origin: .zero, size: screen.frame.size)

        // Attempt to render the current wallpaper image.
        // NSWorkspace.shared.desktopImageURL is sandbox-safe; the image read
        // may silently fail for user-picked photos outside our sandbox container,
        // in which case we fall back to a neutral solid colour.
        if let wallpaperURL = NSWorkspace.shared.desktopImageURL(for: screen),
           let image = NSImage(contentsOf: wallpaperURL) {
            let imageView = NSImageView(frame: frame)
            imageView.image = image
            imageView.imageScaling = .scaleAxesIndependently
            imageView.autoresizingMask = [.width, .height]
            return imageView
        }

        // Fallback: solid colour that matches the system appearance.
        let view = NSView(frame: frame)
        view.wantsLayer = true
        let isDark = NSAppearance.current.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
        view.layer?.backgroundColor = isDark
            ? NSColor(calibratedWhite: 0.12, alpha: 1).cgColor
            : NSColor(calibratedWhite: 0.88, alpha: 1).cgColor
        return view
    }
}
