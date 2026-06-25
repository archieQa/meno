import SwiftUI

/// Screen 65 — Community Guidelines ("Our agreement"). Quiet promises, not rules.
struct CommunityGuidelinesView: View {
    private let promises: [(title: String, body: String)] = [
        ("What\u{2019}s shared here stays here.", "No screenshots, no carrying stories outside."),
        ("Kindness over correction.", "We hold each other up; advice only when it\u{2019}s wanted."),
        ("Everyone\u{2019}s season is valid.", "No gatekeeping, no comparison.")
    ]

    var body: some View {
        SettingsScaffold(title: "Our agreement", topPadding: 18) {
            Text("Meno works because of how we treat each other. A few quiet promises:")
                .font(.sans(17)).foregroundStyle(Meno.sub).lineSpacing(2)
                .padding(.bottom, 22)

            VStack(alignment: .leading, spacing: 18) {
                ForEach(Array(promises.enumerated()), id: \.offset) { _, p in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(p.title).font(.serif(19)).foregroundStyle(Meno.ink)
                        Text(p.body).font(.sans(15)).foregroundStyle(Meno.sub).lineSpacing(1)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack { CommunityGuidelinesView() }.environmentObject(MenoStore())
}
