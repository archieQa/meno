import SwiftUI

/// Zone F, screen 38 — Market home (the Market tab). Calm and editorial:
/// peer experience first, storefront second. Affiliate model — we link out.
struct MarketView: View {
    @EnvironmentObject var store: MenoStore
    @State private var showRecommend = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                topBar
                ScrollView {
                    VStack(spacing: 14) {
                        ForEach(Array(store.collections.enumerated()), id: \.element.id) { i, col in
                            NavigationLink { CollectionView(collection: col) } label: {
                                CollectionCard(collection: col)
                            }
                            .buttonStyle(.plain)
                            .menoFadeUp(index: i, step: 0.12)
                        }
                    }
                    .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 24)
                }
            }
            .menoLivingBackground(accent: Meno.gold)
            .navigationBarHidden(true)
            .sheet(isPresented: $showRecommend) { RecommendProductView() }
        }
    }

    private var topBar: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("What your circle swears by")
                .font(.serif(27)).foregroundStyle(Meno.ink)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 8)
            HStack(spacing: 18) {
                NavigationLink { WishlistView() } label: {
                    Image(systemName: "heart").font(.system(size: 19, weight: .semibold)).foregroundStyle(Meno.taupe)
                }
                NavigationLink { YourListView() } label: {
                    Image(systemName: "bag").font(.system(size: 19, weight: .semibold)).foregroundStyle(Meno.taupe)
                        .overlay(alignment: .topTrailing) {
                            if !store.listedProducts.isEmpty {
                                Circle().fill(Meno.clay).frame(width: 8, height: 8).offset(x: 3, y: -2)
                            }
                        }
                }
            }
            .padding(.top, 6)
        }
        .padding(.horizontal, 22).padding(.bottom, 12)
        .overlay(Rectangle().fill(Meno.hairline).frame(height: 1), alignment: .bottom)
    }
}

/// A large editorial collection card.
private struct CollectionCard: View {
    let collection: MarketCollection
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle().fill(collection.tone.thumbGradient).frame(height: 120)
                .overlay(ShimmerGlow(color: collection.tone.accent.opacity(0.40)))
                .clipped()
            VStack(alignment: .leading, spacing: 8) {
                Text(collection.title).font(.serif(20)).foregroundStyle(Meno.ink)
                SignalPill(text: collection.signal)
            }
            .padding(16)
        }
        .background(Meno.surface)
        .overlay(RoundedRectangle(cornerRadius: Meno.rCard, style: .continuous).stroke(Meno.cardBorder, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: Meno.rCard, style: .continuous))
        .shadow(color: Color(hex: "2E2622", opacity: 0.04), radius: 10, x: 0, y: 2)
    }
}

/// Sage "social proof" pill used across Market.
struct SignalPill: View {
    let text: String
    var body: some View {
        HStack(spacing: 7) {
            Image(systemName: "person.2.fill").font(.system(size: 11)).foregroundStyle(Meno.sageDark)
            Text(text).font(.sans(13, .bold)).foregroundStyle(Meno.sageDark)
        }
        .padding(.horizontal, 12).padding(.vertical, 6)
        .background(Meno.sage.opacity(0.16)).clipShape(Capsule())
    }
}

#Preview { MarketView().environmentObject(MenoStore()) }
