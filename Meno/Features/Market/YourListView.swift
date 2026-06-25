import SwiftUI

/// Zone F, screen 41 — Your List (the affiliate "cart"). Saved to come back to;
/// you buy from each shop directly.
struct YourListView: View {
    @EnvironmentObject var store: MenoStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            MenoHeader(title: "Your list") { dismiss() }.padding(.top, 2)
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Saved to come back to. You buy from each shop directly \u{2014} Meno just gathers what your circle trusts.")
                        .font(.sans(15)).foregroundStyle(Meno.sub).lineSpacing(3).padding(.bottom, 16)

                    if store.listedProducts.isEmpty {
                        MarketEmpty(icon: "bag",
                                    line: "Nothing saved yet. Tap \u{201C}Save\u{201D} on anything your circle swears by.")
                    } else {
                        VStack(spacing: 12) {
                            ForEach(store.listedProducts) { p in
                                NavigationLink { ProductDetailView(product: p) } label: { ListRow(product: p) }
                                    .buttonStyle(.plain)
                            }
                        }
                    }

                    NavigationLink { OrderHistoryView() } label: {
                        HStack {
                            Text("Your purchases").font(.sans(15, .bold)).foregroundStyle(Meno.clay)
                            Image(systemName: "chevron.right").font(.system(size: 13, weight: .bold)).foregroundStyle(Meno.clay)
                            Spacer()
                        }
                        .padding(.top, 18)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20).padding(.top, 14).padding(.bottom, 24)
            }
        }
        .background(Meno.base)
        .navigationBarHidden(true)
    }
}

private struct ListRow: View {
    let product: Product
    var body: some View {
        MenoCard(padding: 12) {
            HStack(spacing: 14) {
                MarketThumb(tone: product.tone).frame(width: 60, height: 60)
                VStack(alignment: .leading, spacing: 2) {
                    Text(product.name).font(.sans(16, .bold)).foregroundStyle(Meno.ink)
                    Text("\(product.price) \u{00B7} \(product.shop)").font(.sans(13)).foregroundStyle(Meno.muted)
                }
                Spacer(minLength: 8)
                Text("Get it \u{2197}")
                    .font(.sans(13.5, .bold)).foregroundStyle(Meno.surface)
                    .padding(.horizontal, 14).frame(height: 36)
                    .background(Meno.clay).clipShape(Capsule())
            }
        }
    }
}

/// Zone F, screen 44 — Order history / saved links. Past affiliate hand-offs.
struct OrderHistoryView: View {
    @EnvironmentObject var store: MenoStore
    @Environment(\.dismiss) private var dismiss
    @State private var reviewing = false

    var body: some View {
        VStack(spacing: 0) {
            MenoHeader(title: "Your purchases") { dismiss() }.padding(.top, 2)
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(store.purchases) { item in
                        MenoCard(padding: 14) {
                            HStack(spacing: 14) {
                                MarketThumb(tone: item.tone).frame(width: 54, height: 54)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.name).font(.sans(15.5, .bold)).foregroundStyle(Meno.ink)
                                    Text(item.meta).font(.sans(13)).foregroundStyle(Meno.muted)
                                }
                                Spacer(minLength: 8)
                                Button { reviewing = true } label: {
                                    Text("Review").font(.sans(13.5, .bold)).foregroundStyle(Meno.clay)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20).padding(.top, 14).padding(.bottom, 24)
            }
        }
        .background(Meno.base)
        .navigationBarHidden(true)
        .sheet(isPresented: $reviewing) { RecommendProductView() }
    }
}

/// Zone F, screen 45 — Wishlist / saved-for-later products.
struct WishlistView: View {
    @EnvironmentObject var store: MenoStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            MenoHeader(title: "Saved for later") { dismiss() }.padding(.top, 2)
            ScrollView {
                if store.wishlistProducts.isEmpty {
                    MarketEmpty(icon: "heart",
                                line: "Tap the heart on anything you\u{2019}re not sure about yet. It waits here.")
                        .padding(.horizontal, 20).padding(.top, 14)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                        ForEach(store.wishlistProducts) { p in
                            NavigationLink { ProductDetailView(product: p) } label: {
                                ProductTile(product: p, subtitle: p.price)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20).padding(.top, 14).padding(.bottom, 24)
                }
            }
        }
        .background(Meno.base)
        .navigationBarHidden(true)
    }
}

/// Shared gentle empty state for Market lists.
struct MarketEmpty: View {
    let icon: String
    let line: String
    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: icon).font(.system(size: 30, weight: .light)).foregroundStyle(Meno.sage)
            Text(line).font(.sans(16)).foregroundStyle(Meno.taupe)
                .multilineTextAlignment(.center).lineSpacing(3).frame(maxWidth: 260)
        }
        .frame(maxWidth: .infinity).padding(.top, 60)
    }
}

#Preview {
    let store = MenoStore()
    store.listedProductIDs = [store.collections[0].products[3].id]
    return NavigationStack { YourListView() }.environmentObject(store)
}
