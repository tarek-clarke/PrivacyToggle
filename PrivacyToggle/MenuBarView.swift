import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject private var privacyManager: PrivacyManager

    var body: some View {
        Button {
            privacyManager.toggle()
        } label: {
            Text(privacyManager.isEnabled ? "Disable Privacy Mode" : "Enable Privacy Mode")
        }
        .keyboardShortcut("p", modifiers: [])

        Divider()

        Button("Quit PrivacyToggle") {
            NSApplication.shared.terminate(nil)
        }
        .keyboardShortcut("q", modifiers: [])
    }
}
