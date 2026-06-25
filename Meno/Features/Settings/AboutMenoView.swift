import SwiftUI

/// Screen 68 — About Meno. The "why" behind the app, then the legal links.
struct AboutMenoView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22)).foregroundStyle(Meno.faint)
                }
                .accessibilityIdentifier("backButton")
                .accessibilityLabel("Back")
                Spacer()
            }
            .padding(.horizontal, 22).padding(.bottom, 8)

            ScrollView {
                VStack(spacing: 0) {
                    Text("Meno")
                        .font(.serif(44, .medium)).foregroundStyle(Meno.clay)
                        .padding(.bottom, 16)
                    Text("We started Meno because menopause is lonely, and it shouldn\u{2019}t be. This is a room full of women who get it \u{2014} built to keep you company through the change.")
                        .font(.sans(17)).foregroundStyle(Meno.sub)
                        .multilineTextAlignment(.center).lineSpacing(2)
                        .padding(.bottom, 26)

                    SettingsCard {
                        SettingsNavRow(label: "Our story")
                        SettingsDivider()
                        SettingsNavRow(label: "Terms of Service")
                        SettingsDivider()
                        SettingsNavRow(label: "Privacy Policy")
                    }

                    Text("Version 1.0")
                        .font(.sans(13)).foregroundStyle(Meno.muted)
                        .padding(.top, 18)
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 28)
            }
        }
        .background(Meno.base)
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack { AboutMenoView() }.environmentObject(MenoStore())
}
