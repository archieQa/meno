import SwiftUI

/// Screen 60 — Blocked Users. Blocking is silent and reversible; they're
/// never told. Empty here is a good thing, and the copy says so.
struct BlockedUsersView: View {
    @EnvironmentObject var store: MenoStore

    var body: some View {
        SettingsScaffold(title: "Blocked") {
            Text("They can\u{2019}t see you or reach you. They\u{2019}re never told.")
                .font(.sans(15)).foregroundStyle(Meno.sub).lineSpacing(2)
                .padding(.bottom, 16)

            if store.blockedUsers.isEmpty {
                Text("No one\u{2019}s blocked. Quiet here, thankfully.")
                    .font(.sans(14)).foregroundStyle(Meno.muted)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 24)
            } else {
                SettingsCard {
                    ForEach(Array(store.blockedUsers.enumerated()), id: \.element.id) { i, user in
                        HStack {
                            Text(user.name).font(.sans(16, .bold)).foregroundStyle(Meno.ink)
                            Spacer()
                            Button { store.unblock(user.id) } label: {
                                Text("Unblock").font(.sans(14, .bold)).foregroundStyle(Meno.clay)
                            }
                        }
                        .padding(16)
                        if i < store.blockedUsers.count - 1 { SettingsDivider() }
                    }
                }
                Text("Just one. Quiet here, thankfully.")
                    .font(.sans(14)).foregroundStyle(Meno.muted)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 18)
                    .opacity(store.blockedUsers.count == 1 ? 1 : 0)
            }
        }
    }
}

#Preview {
    NavigationStack { BlockedUsersView() }.environmentObject(MenoStore())
}
