import SwiftUI

/// Screen 61 — Notification Preferences. What reaches her, and quiet hours.
struct NotificationSettingsView: View {
    @EnvironmentObject var store: MenoStore

    var body: some View {
        SettingsScaffold(title: "Notifications") {
            SettingsCard {
                SettingsToggleRow(label: "Replies to me", isOn: $store.settings.notifyReplies)
                SettingsDivider()
                SettingsToggleRow(label: "Circle activity", isOn: $store.settings.notifyCircles)
                SettingsDivider()
                SettingsToggleRow(label: "Daily check-in nudge", isOn: $store.settings.notifyCheckIn)
                SettingsDivider()
                SettingsToggleRow(label: "New from the wider feed", isOn: $store.settings.notifyWiderFeed)
            }

            SettingsGroupLabel(text: "Quiet hours")
            SettingsCard {
                SettingsToggleRow(label: "Pause overnight", isOn: $store.settings.quietHours)
                SettingsDivider()
                SettingsNavRow(label: "From \u{2014} to",
                               value: "\(store.settings.quietFrom) \u{2013} \(store.settings.quietTo)")
            }
        }
    }
}

#Preview {
    NavigationStack { NotificationSettingsView() }.environmentObject(MenoStore())
}
