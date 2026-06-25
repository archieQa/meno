import SwiftUI

/// Zone F, screen 39 — Collection / Category. A 2-up grid of honestly-reviewed
/// products inside one collection.
struct CollectionView: View {
    let collection: MarketCollection
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").font(.system(size: 22)).foregroundStyle(Meno.faint)
                }
                Spacer()
            }
            .padding(.horizontal, 22).padding(.bottom, 8)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text(collection.title).font(.serif(26)).foregroundStyle(Meno.ink).padding(.bottom, 6)
                    Text("Honestly reviewed by women who\u{2019}ve been awake at 3am too.")
                        .font(.sans(15)).foregroundStyle(Meno.sub).padding(.bottom, 18)

                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                        ForEach(collection.products) { p in
                            NavigationLink { ProductDetailView(product: p) } label: { ProductTile(product: p) }
                                .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 20).padding(.top, 8).padding(.bottom, 24)
            }
        }
        .background(Meno.base)
        .navigationBarHidden(true)
    }
}

/// A compact product tile (thumb + name + how many tried).
struct ProductTile: View {
    let product: Product
    var subtitle: String? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle().fill(product.tone.thumbGradient).frame(height: 110)
            VStack(alignment: .leading, spacing: 3) {
                Text(product.name).font(.sans(15, .bold)).foregroundStyle(Meno.ink).lineSpacing(2)
                Text(subtitle ?? "\(product.triedCount) tried")
                    .font(.sans(12.5)).foregroundStyle(Meno.muted)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Meno.surface)
        .overlay(RoundedRectangle(cornerRadius: Meno.rCard, style: .continuous).stroke(Meno.cardBorder, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: Meno.rCard, style: .continuous))
    }
}

#Preview {
    NavigationStack { CollectionView(collection: MenoStore().collections[0]) }
        .environmentObject(MenoStore())
}
