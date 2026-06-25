import SwiftUI

/// Screen 58 — Privacy & Data Controls. Shows, in plain language, what Meno
/// has learned (each line editable / removable) and the toggles that govern it.
struct PrivacyDataView: View {
    @EnvironmentObject var store: MenoStore

    var body: some View {
        SettingsScaffold(title: "Privacy & Data") {
            SettingsGroupLabel(text: "What Meno has learned about you")

            if store.learnedInsights.isEmpty {
                Text("Nothing learned yet. As you check in and share, gentle patterns may show up here \u{2014} and you can always remove them.")
                    .font(.sans(15)).foregroundStyle(Meno.taupe).lineSpacing(2)
                    .padding(.vertical, 8)
            } else {
                VStack(spacing: 10) {
                    ForEach(store.learnedInsights) { insight in
                        MenoCard(padding: 16) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(insight.text)
                                    .font(.sans(15.5)).foregroundStyle(Meno.ink).lineSpacing(1)
                                HStack(spacing: 16) {
                                    Text("Edit").font(.sans(14, .bold)).foregroundStyle(Meno.clay)
                                    Button { store.removeInsight(insight.id) } label: {
                                        Text("Remove").font(.sans(14, .bold)).foregroundStyle(Meno.taupe)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            SettingsGroupLabel(text: "Your controls")
            SettingsCard {
                SettingsToggleRow(label: "Keep emotional & shopping data separate",
                                  isOn: $store.settings.keepDataSeparate)
                SettingsDivider()
                SettingsToggleRow(label: "Personalization", isOn: $store.settings.personalization)
            }
        }
    }
}

#Preview {
    NavigationStack { PrivacyDataView() }.environmentObject(MenoStore())
}
