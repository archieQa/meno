import SwiftUI

/// Screen 57 — Account. Email / phone / password / connected login.
struct AccountSettingsView: View {
    @EnvironmentObject var store: MenoStore

    var body: some View {
        SettingsScaffold(title: "Account") {
            SettingsCard {
                SettingsNavRow(label: "Email", value: store.settings.email)
                SettingsDivider()
                SettingsNavRow(label: "Phone", value: store.settings.phone ?? "Add")
                SettingsDivider()
                SettingsNavRow(label: "Password", value: "Change")
                SettingsDivider()
                SettingsNavRow(label: "Connected login", value: store.settings.connectedLogin)
            }

            SettingsGroupLabel(text: "Your data")
            SettingsCard {
                NavigationLink { DataExportView() } label: { SettingsNavRow(label: "Export & delete") }
            }
        }
    }
}

#Preview {
    NavigationStack { AccountSettingsView() }.environmentObject(MenoStore())
}
