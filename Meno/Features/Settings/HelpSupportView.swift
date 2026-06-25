import SwiftUI

/// Screen 64 — Help & Support. Common questions + a way to reach the team.
struct HelpSupportView: View {
    private let topics = [
        "How do circles work?",
        "Staying anonymous",
        "Managing notifications",
        "Trouble logging in"
    ]

    var body: some View {
        SettingsScaffold(title: "Help & Support") {
            SettingsCard {
                ForEach(Array(topics.enumerated()), id: \.offset) { i, topic in
                    SettingsNavRow(label: topic)
                    if i < topics.count - 1 { SettingsDivider() }
                }
            }

            SettingsCard {
                SettingsNavRow(label: "Message our team", labelColor: Meno.clay)
            }
            .padding(.top, 16)
        }
    }
}

#Preview {
    NavigationStack { HelpSupportView() }.environmentObject(MenoStore())
}
