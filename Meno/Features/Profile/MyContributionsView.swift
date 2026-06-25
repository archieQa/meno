import SwiftUI

/// Screen 51 — My Contributions (Posts / Wisdom / Reviews).
struct MyContributionsView: View {
    @EnvironmentObject var store: MenoStore
    @Environment(\.dismiss) private var dismiss
    @State private var filter: Contribution.Kind = .posts

    private var shown: [Contribution] { store.contributions.filter { $0.kind == filter } }

    var body: some View {
        VStack(spacing: 0) {
            MenoHeader(title: "My Contributions") { dismiss() }
                .padding(.top, 2)

            // Filter chips
            HStack(spacing: 8) {
                ForEach(Contribution.Kind.allCases, id: \.self) { kind in
                    Button { filter = kind } label: {
                        Chip(title: kind.rawValue, selected: filter == kind)
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(shown) { c in
                        MenoCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(c.body).font(.sans(16)).foregroundStyle(Meno.ink).lineSpacing(3)
                                Text(c.meta).font(.sans(13)).foregroundStyle(Meno.muted)
                            }
                        }
                    }
                    if shown.isEmpty {
                        Text("Nothing here yet.")
                            .font(.sans(15)).foregroundStyle(Meno.taupe)
                            .padding(.top, 40)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .background(Meno.base)
        .navigationBarHidden(true)
    }
}

#Preview { NavigationStack { MyContributionsView() }.environmentObject(MenoStore()) }
