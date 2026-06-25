import SwiftUI

/// Screen 59 — Anonymity. Her real name is never shown; these control how
/// she appears, both as a default and per context.
struct AnonymitySettingsView: View {
    @EnvironmentObject var store: MenoStore

    var body: some View {
        SettingsScaffold(title: "Anonymity") {
            Text("Your real name is never shown anywhere. These control how you appear.")
                .font(.sans(15)).foregroundStyle(Meno.sub).lineSpacing(2)
                .padding(.bottom, 16)

            SettingsCard {
                SettingsToggleRow(label: "Post anonymously by default",
                                  isOn: $store.settings.postAnonymouslyByDefault)
            }

            SettingsGroupLabel(text: "Per context")
            SettingsCard {
                SettingsNavRow(label: "In the Today feed", value: store.settings.anonymityFeed)
                SettingsDivider()
                SettingsNavRow(label: "In my circles", value: store.settings.anonymityCircles)
                SettingsDivider()
                SettingsNavRow(label: "On wisdom tips", value: store.settings.anonymityWisdom)
            }
        }
    }
}

#Preview {
    NavigationStack { AnonymitySettingsView() }.environmentObject(MenoStore())
}
