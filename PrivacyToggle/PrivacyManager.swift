import AppKit
import Combine

/// Manages privacy mode: hides inactive application windows and shows a
/// desktop overlay to cover Finder icons. All APIs used are sandbox-safe
/// and require no accessibility or screen-recording permissions.
@MainActor
final class PrivacyManager: ObservableObject {

    @Published private(set) var isEnabled = false

    private var hiddenApps: [NSRunningApplication] = []
    private var overlayWindows: [DesktopOverlayWindow] = []

    // MARK: - Public

    func toggle() {
        isEnabled ? disable() : enable()
    }

    // MARK: - Private

    private func enable() {
        isEnabled = true
        showDesktopOverlay()
        hideInactiveApplications()
    }

    private func disable() {
        isEnabled = false
        removeDesktopOverlay()
        unhideApplications()
    }

    // MARK: Desktop overlay

    private func showDesktopOverlay() {
        overlayWindows = NSScreen.screens.map { screen in
            let window = DesktopOverlayWindow(screen: screen)
            window.orderFrontRegardless()
            return window
        }
    }

    private func removeDesktopOverlay() {
        overlayWindows.forEach { $0.orderOut(nil) }
        overlayWindows = []
    }

    // MARK: Window management

    /// Hide every regular application that is currently visible, except for
    /// the frontmost app and PrivacyToggle itself.
    private func hideInactiveApplications() {
        hiddenApps = []
        let frontmost = NSWorkspace.shared.frontmostApplication
        let ownBundleID = Bundle.main.bundleIdentifier

        for app in NSWorkspace.shared.runningApplications {
            guard app.activationPolicy == .regular,
                  app.bundleIdentifier != ownBundleID,
                  app != frontmost,
                  !app.isHidden
            else { continue }

            if app.hide() {
                hiddenApps.append(app)
            }
        }
    }

    private func unhideApplications() {
        hiddenApps.forEach { $0.unhide() }
        hiddenApps = []
    }
}
