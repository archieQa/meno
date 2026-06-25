import SwiftUI

/// Screen 47 — Profile (Me).
struct ProfileView: View {
    @EnvironmentObject var store: MenoStore
    @Environment(\.dismiss) private var dismiss
    @State private var showEdit = false

    var body: some View {
        VStack(spacing: 0) {
            // Top bar: back + settings gear
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22)).foregroundStyle(Meno.faint)
                }
                Spacer()
                NavigationLink { SettingsView() } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 21)).foregroundStyle(Meno.taupe)
                }
            }
            .padding(.horizontal, 22)
            .padding(.top, 2)

            ScrollView {
                VStack(spacing: 16) {
                    // Identity
                    VStack(spacing: 0) {
                        Avatar(initial: store.profile.initial, tone: store.profile.tone, size: 88)
                            .padding(.bottom, 12)
                        Text(store.profile.displayName).font(.serif(24)).foregroundStyle(Meno.ink)
                        Text("\(store.profile.stage) \u{00B7} \(store.profile.here)")
                            .font(.sans(14)).foregroundStyle(Meno.taupe)
                            .padding(.top, 3)
                    }
                    .padding(.top, 6)
                    .padding(.bottom, 8)

                    // Stats card
                    MenoCard {
                        HStack {
                            stat(store.profile.posts, "posts")
                            Spacer()
                            stat(store.profile.circles, "circles")
                            Spacer()
                            stat(store.profile.checkIns, "check-ins")
                        }
                    }

                    // Navigation list
                    MenoCard(padding: 0) {
                        VStack(spacing: 0) {
                            NavigationLink { MyJourneyView() } label: { DisclosureRow(title: "My Journey") }
                            divider
                            NavigationLink { MyContributionsView() } label: { DisclosureRow(title: "My Contributions") }
                            divider
                            NavigationLink { SavedItemsView() } label: { DisclosureRow(title: "Saved") }
                            divider
                            NavigationLink { PublicProfileView(person: store.mentor) } label: { DisclosureRow(title: "Preview public profile") }
                            divider
                            Button { showEdit = true } label: { DisclosureRow(title: "Edit profile") }
                            divider
                            NavigationLink { SettingsView() } label: { DisclosureRow(title: "Settings") }
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 22)
                .padding(.top, 6)
                .padding(.bottom, 24)
            }
        }
        .background(Meno.base)
        .navigationBarHidden(true)
        .sheet(isPresented: $showEdit) { EditProfileView() }
    }

    private func stat(_ value: Int, _ label: String) -> some View {
        VStack(spacing: 2) {
            Text("\(value)").font(.serif(22)).foregroundStyle(Meno.ink)
            Text(label).font(.sans(12.5)).foregroundStyle(Meno.muted)
        }
    }

    private var divider: some View {
        Rectangle().fill(Meno.hairline).frame(height: 1).padding(.leading, 16)
    }
}

#Preview {
    NavigationStack { ProfileView() }.environmentObject(MenoStore())
}
