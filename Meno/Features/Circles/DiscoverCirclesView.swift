import SwiftUI

/// Zone D, screen 24 — Discover Circles. Search + filter, then joinable rooms.
struct DiscoverCirclesView: View {
    @EnvironmentObject var store: MenoStore
    @Environment(\.dismiss) private var dismiss
    @State private var filter = "By stage"
    @State private var joined: Set<UUID> = []

    private let filters = ["By stage", "By struggle", "By life"]

    var body: some View {
        VStack(spacing: 0) {
            MenoHeader(title: "Discover") { dismiss() }.padding(.top, 2)
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Search field (display-only prototype)
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .semibold)).foregroundStyle(Meno.muted)
                        Text("Search circles").font(.sans(16)).foregroundStyle(Meno.muted)
                        Spacer()
                    }
                    .padding(.horizontal, 16).frame(height: 50)
                    .background(Meno.surface)
                    .overlay(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous)
                        .stroke(Meno.border, lineWidth: 1.5))
                    .clipShape(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous))
                    .padding(.bottom, 16)

                    HStack(spacing: 8) {
                        ForEach(filters, id: \.self) { f in
                            Button { filter = f } label: { Chip(title: f, selected: filter == f, height: 38) }
                                .buttonStyle(.plain)
                        }
                    }
                    .padding(.bottom, 18)

                    VStack(spacing: 12) {
                        ForEach(store.discoverCircles) { c in
                            DiscoverRow(circle: c, joined: joined.contains(c.id)) {
                                if joined.contains(c.id) { joined.remove(c.id) } else { joined.insert(c.id) }
                            }
                        }
                    }

                    NavigationLink { CreateCircleView() } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle").font(.system(size: 18, weight: .semibold))
                            Text("Start your own circle").font(.sans(15, .bold))
                        }
                        .foregroundStyle(Meno.clay)
                        .frame(maxWidth: .infinity).frame(height: 50)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 6)
                }
                .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 24)
            }
        }
        .background(Meno.base)
        .navigationBarHidden(true)
    }
}

private struct DiscoverRow: View {
    let circle: DiscoverCircle
    let joined: Bool
    let onJoin: () -> Void

    var body: some View {
        MenoCard(padding: 15) {
            HStack(spacing: 14) {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(circle.tone.softFill)
                    .frame(width: 46, height: 46)
                VStack(alignment: .leading, spacing: 2) {
                    Text(circle.name).font(.serif(18)).foregroundStyle(Meno.ink)
                    Text(circle.blurb).font(.sans(13.5)).foregroundStyle(Meno.muted)
                }
                Spacer(minLength: 8)
                Button(action: onJoin) {
                    Text(joined ? "Joined" : "Join")
                        .font(.sans(14, .bold))
                        .foregroundStyle(joined ? Meno.surface : Meno.clay)
                        .padding(.horizontal, 16).frame(height: 38)
                        .background(joined ? Meno.clay : .clear)
                        .overlay(Capsule().stroke(Meno.clay, lineWidth: 1.5))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview { NavigationStack { DiscoverCirclesView() }.environmentObject(MenoStore()) }
