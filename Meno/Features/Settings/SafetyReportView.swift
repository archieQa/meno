import SwiftUI

/// Screen 66 — Safety Center & Report. Nothing here is ever announced.
/// The clay "urgent support" card pushes to the crisis screen (67).
struct SafetyReportView: View {
    var body: some View {
        SettingsScaffold(title: "Safety") {
            Text("If something doesn\u{2019}t feel right, we\u{2019}re here. Nothing you do here is announced.")
                .font(.sans(15)).foregroundStyle(Meno.sub).lineSpacing(2)
                .padding(.bottom, 16)

            SettingsCard {
                SettingsNavRow(label: "Report a post")
                SettingsDivider()
                SettingsNavRow(label: "Block someone")
                SettingsDivider()
                SettingsNavRow(label: "How moderation works")
            }

            NavigationLink { CrisisSupportView() } label: {
                HStack {
                    Text("Need urgent support?")
                        .font(.sans(16, .bold)).foregroundStyle(Meno.clayDark)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 15, weight: .semibold)).foregroundStyle(Meno.clay)
                }
                .padding(16)
                .background(Meno.clay.opacity(0.1))
                .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Meno.clay.opacity(0.22), lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .buttonStyle(.plain)
            .padding(.top, 16)
        }
    }
}

/// Screen 67 — Crisis Support Resources. Warm sand wash, no app chrome
/// competing for attention; the only job is to get her to a human, now.
struct CrisisSupportView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22)).foregroundStyle(Meno.faint)
                }
                Spacer()
            }
            .padding(.horizontal, 22).padding(.bottom, 8)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("You don\u{2019}t have to hold this alone")
                        .font(.serif(28)).foregroundStyle(Meno.ink)
                        .padding(.bottom, 12)
                    Text("If you\u{2019}re in real distress, please reach a person who can help right now. We\u{2019}ll still be here after.")
                        .font(.sans(16.5)).foregroundStyle(Meno.sub).lineSpacing(2)
                        .padding(.bottom, 24)

                    VStack(spacing: 12) {
                        resource("Samaritans", "Call 116 123 \u{00B7} free, any time")
                        resource("Text a crisis line", "Text SHOUT to 85258")
                    }
                }
                .padding(.horizontal, 26)
                .padding(.bottom, 28)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Meno.surfaceAlt)
        .navigationBarHidden(true)
    }

    private func resource(_ title: String, _ detail: String) -> some View {
        MenoCard(padding: 18) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.sans(17, .bold)).foregroundStyle(Meno.ink)
                Text(detail).font(.sans(15)).foregroundStyle(Meno.sub)
            }
        }
    }
}

#Preview("Safety") {
    NavigationStack { SafetyReportView() }.environmentObject(MenoStore())
}
#Preview("Crisis") {
    NavigationStack { CrisisSupportView() }
}
