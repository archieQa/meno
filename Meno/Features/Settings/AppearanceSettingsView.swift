import SwiftUI

/// Screen 62 — Appearance & Accessibility. Text size, contrast, motion, theme.
/// Critical for a 45–55 audience — large, high-contrast controls.
struct AppearanceSettingsView: View {
    @EnvironmentObject var store: MenoStore

    var body: some View {
        SettingsScaffold(title: "Appearance", topPadding: 18) {
            Text("TEXT SIZE")
                .font(.sans(13, .bold)).tracking(0.4).foregroundStyle(Meno.taupe)
                .padding(.bottom, 12)

            HStack(spacing: 12) {
                Text("A").font(.sans(14)).foregroundStyle(Meno.ink)
                Slider(value: $store.settings.textScale, in: 0...1)
                    .tint(Meno.clay)
                Text("A").font(.sans(24)).foregroundStyle(Meno.ink)
            }
            .padding(.bottom, 22)

            SettingsCard {
                SettingsToggleRow(label: "Higher contrast", isOn: $store.settings.higherContrast)
                SettingsDivider()
                SettingsToggleRow(label: "Reduce motion", isOn: $store.settings.reduceMotion)
                SettingsDivider()
                Menu {
                    ForEach(AppTheme.allCases) { theme in
                        Button(theme.rawValue) { store.settings.theme = theme }
                    }
                } label: {
                    SettingsNavRow(label: "Theme", value: store.settings.theme.rawValue)
                }
            }
        }
    }
}

#Preview {
    NavigationStack { AppearanceSettingsView() }.environmentObject(MenoStore())
}
