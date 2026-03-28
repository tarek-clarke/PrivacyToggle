import SwiftUI

@main
struct PrivacyToggleApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var privacyManager = PrivacyManager()

    var body: some Scene {
        MenuBarExtra {
            MenuBarView()
                .environmentObject(privacyManager)
        } label: {
            Image(systemName: privacyManager.isEnabled ? "eye" : "eye.slash")
                .symbolVariant(privacyManager.isEnabled ? .fill : .none)
        }
        .menuBarExtraStyle(.menu)
    }
}
