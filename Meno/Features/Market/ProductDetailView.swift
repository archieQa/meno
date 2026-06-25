import SwiftUI

/// Zone F, screen 40 — Product Detail. Calm, with community proof up front and a
/// "Get it" that hands off to the shop (affiliate model — no native commerce).
struct ProductDetailView: View {
    let product: Product
    @EnvironmentObject var store: MenoStore
    @Environment(\.dismiss) private var dismiss
    @State private var showHandoff = false
    @State private var showConfirm = false

    private var listed: Bool { store.listedProductIDs.contains(product.id) }
    private var wished: Bool { store.wishlistProductIDs.contains(product.id) }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").font(.system(size: 22)).foregroundStyle(Meno.faint)
                }
                Spacer()
                Button { store.toggleWishlist(product.id) } label: {
                    Image(systemName: wished ? "heart.fill" : "heart")
                        .font(.system(size: 20)).foregroundStyle(wished ? Meno.clay : Meno.taupe)
                }
            }
            .padding(.horizontal, 22).padding(.bottom, 8)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    MarketThumb(tone: product.tone).frame(height: 200).padding(.bottom, 18)
                    Text(product.name).font(.serif(25)).foregroundStyle(Meno.ink).padding(.bottom, 6)
                    Text(product.price).font(.sans(18, .bold)).foregroundStyle(Meno.clay).padding(.bottom, 14)
                    Text(product.blurb).font(.sans(16)).foregroundStyle(Meno.sub).lineSpacing(4).padding(.bottom, 18)

                    MenoCard(padding: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            SectionLabel(text: "From women in your stage", color: Meno.sageDark)
                            Text("\(product.triedCount) women tried this")
                                .font(.sans(14.5, .bold)).foregroundStyle(Meno.bodyText)
                            Text("\u{201C}\(product.review)\u{201D} \u{2014} \(product.reviewBy)")
                                .font(.sans(15)).foregroundStyle(Meno.bodyText).lineSpacing(3)
                        }
                    }
                    .background(Meno.sage.opacity(0.10))
                    .clipShape(RoundedRectangle(cornerRadius: Meno.rCard, style: .continuous))
                }
                .padding(.horizontal, 22).padding(.top, 4).padding(.bottom, 20)
            }

            HStack(spacing: 10) {
                Button { store.toggleList(product.id) } label: {
                    Text(listed ? "Saved" : "Save")
                        .font(.sans(17, .bold)).foregroundStyle(Meno.clay)
                        .frame(maxWidth: .infinity).frame(height: 54)
                        .background(listed ? Meno.claySoft : .clear)
                        .overlay(RoundedRectangle(cornerRadius: Meno.rButton, style: .continuous)
                            .stroke(Meno.clay, lineWidth: 1.5))
                        .clipShape(RoundedRectangle(cornerRadius: Meno.rButton, style: .continuous))
                }
                .buttonStyle(.plain)
                Button { showHandoff = true } label: {
                    Text("Get it \u{2197}")
                        .font(.sans(17, .bold)).foregroundStyle(Meno.surface)
                        .frame(maxWidth: .infinity).frame(height: 54)
                        .background(Meno.clay)
                        .clipShape(RoundedRectangle(cornerRadius: Meno.rButton, style: .continuous))
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 22).padding(.top, 12).padding(.bottom, 16)
            .background(Meno.surface)
            .overlay(Rectangle().fill(Meno.hairline).frame(height: 1), alignment: .top)
        }
        .background(Meno.base)
        .navigationBarHidden(true)
        .sheet(isPresented: $showHandoff) {
            ShopHandoffSheet(product: product) {
                showHandoff = false
                // Let the sheet finish dismissing before presenting the cover.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { showConfirm = true }
            }
            .presentationDetents([.height(340)])
            .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $showConfirm) {
            OrderConfirmationView()
        }
    }
}

/// Zone F, screen 42 — Shop Handoff. The honest "you'll finish on their shop" step.
struct ShopHandoffSheet: View {
    let product: Product
    var onContinue: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 6)
            MarketThumb(tone: product.tone, radius: 18).frame(width: 70, height: 70).padding(.bottom, 18)
            Text("Heading to \(product.shop)").font(.serif(23)).foregroundStyle(Meno.ink).padding(.bottom, 10)
            Text("You\u{2019}ll finish your purchase on their shop \u{2014} safe and secure. We\u{2019}ll keep it on your list either way.")
                .font(.sans(16)).foregroundStyle(Meno.sub).multilineTextAlignment(.center).lineSpacing(3)
                .padding(.bottom, 24)
            PrimaryButton(title: "Continue to \(product.shop) \u{2197}") { onContinue() }
                .padding(.bottom, 10)
            Button { dismiss() } label: {
                Text("Not now").font(.sans(16, .bold)).foregroundStyle(Meno.taupe)
                    .frame(maxWidth: .infinity).frame(height: 50)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 28).padding(.top, 20).padding(.bottom, 16)
        .frame(maxWidth: .infinity)
        .background(Meno.base)
    }
}

/// Zone F, screen 43 — Order / Saved confirmation. Warm, human, no receipt-speak.
struct OrderConfirmationView: View {
    @EnvironmentObject var store: MenoStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            ZStack {
                Circle().fill(Meno.sage).frame(width: 96, height: 96)
                Image(systemName: "checkmark").font(.system(size: 40, weight: .bold)).foregroundStyle(Meno.surface)
            }
            .padding(.bottom, 24)
            Text("Hope it helps, \(store.profile.displayName)")
                .font(.serif(28)).foregroundStyle(Meno.ink).multilineTextAlignment(.center).padding(.bottom, 12)
            Text("It\u{2019}s noted on your list. If it works for you, a word in the reviews helps the next woman find it too.")
                .font(.sans(16.5)).foregroundStyle(Meno.sub).multilineTextAlignment(.center).lineSpacing(3)
                .frame(maxWidth: 290).padding(.bottom, 26)
            Button { dismiss() } label: {
                Text("Back to Market").font(.sans(17, .bold)).foregroundStyle(Meno.clay)
                    .frame(maxWidth: 240).frame(height: 54)
                    .overlay(RoundedRectangle(cornerRadius: Meno.rButton, style: .continuous).stroke(Meno.clay, lineWidth: 1.5))
            }
            .buttonStyle(.plain)
            Spacer()
        }
        .padding(.horizontal, 34)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Meno.surfaceAlt.ignoresSafeArea())
    }
}

#Preview {
    NavigationStack { ProductDetailView(product: MenoStore().collections[0].products[3]) }
        .environmentObject(MenoStore())
}
