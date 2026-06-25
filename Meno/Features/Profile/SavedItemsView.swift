import SwiftUI

/// Screen 52 — Saved Items (All / Posts / Wisdom / Products).
struct SavedItemsView: View {
    @EnvironmentObject var store: MenoStore
    @Environment(\.dismiss) private var dismiss
    @State private var filter: SavedItem.Kind = .all

    private var shown: [SavedItem] {
        filter == .all ? store.saved : store.saved.filter { $0.kind == filter }
    }

    var body: some View {
        VStack(spacing: 0) {
            MenoHeader(title: "Saved") { dismiss() }
                .padding(.top, 2)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(SavedItem.Kind.allCases, id: \.self) { kind in
                        Button { filter = kind } label: {
                            Chip(title: kind.rawValue, selected: filter == kind)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 16)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(shown) { item in
                        MenoCard(padding: 14) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.tag)
                                    .font(.sans(12, .bold))
                                    .foregroundStyle(item.kind == .product ? Meno.clay : Meno.sage)
                                Text(item.title)
                                    .font(.sans(16, .bold)).foregroundStyle(Meno.ink)
                                    .lineSpacing(2)
                            }
                        }
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

#Preview { NavigationStack { SavedItemsView() }.environmentObject(MenoStore()) }
