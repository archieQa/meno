import SwiftUI

/// Zone E, screen 32 — Wisdom Category. A list of tried-and-tested tips.
struct WisdomCategoryView: View {
    let category: WisdomCategory
    @Environment(\.dismiss) private var dismiss

    private var triedTotal: Int { category.tips.reduce(0) { $0 + $1.triedCount } }

    var body: some View {
        VStack(spacing: 0) {
            MenoHeader(title: category.name) { dismiss() }.padding(.top, 2)
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("\(category.tips.count) tips, tried by women like you.")
                        .font(.sans(15)).foregroundStyle(Meno.sub).padding(.bottom, 4)
                    ForEach(category.tips) { tip in
                        NavigationLink { WisdomDetailView(tip: tip, category: category.name) } label: {
                            MenoCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(tip.title).font(.serif(18)).foregroundStyle(Meno.ink).lineSpacing(2)
                                    Text("\(tip.author) \u{00B7} \(tip.triedCount) women tried this")
                                        .font(.sans(13.5)).foregroundStyle(Meno.muted)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20).padding(.top, 14).padding(.bottom, 24)
            }
        }
        .menoDeepIn()
        .menoLivingBackground(accent: Meno.gold)
        .navigationBarHidden(true)
    }
}

/// Zone E, screen 33 — Wisdom Detail. One woman's account, "I tried this too",
/// and a short thread of replies.
struct WisdomDetailView: View {
    let tip: WisdomTip
    let category: String
    @Environment(\.dismiss) private var dismiss
    @State private var tried = false

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").font(.system(size: 22)).foregroundStyle(Meno.faint)
                }
                Text(category).font(.sans(15)).foregroundStyle(Meno.taupe)
                Spacer()
            }
            .padding(.horizontal, 22).padding(.bottom, 12)
            .overlay(Rectangle().fill(Meno.hairline).frame(height: 1), alignment: .bottom)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text(tip.title).font(.serif(27)).foregroundStyle(Meno.ink).lineSpacing(2)
                        .padding(.bottom, 12)
                    HStack(spacing: 10) {
                        Avatar(initial: String(tip.author.prefix(1)), tone: .sage, size: 34)
                        Text("Shared by \(tip.author)\(tip.stage.map { ", \($0)" } ?? "")")
                            .font(.sans(14)).foregroundStyle(Meno.taupe)
                    }
                    .padding(.bottom, 16)

                    HStack {
                        Text("\(tip.triedCount) women tried this")
                            .font(.sans(14.5, .bold)).foregroundStyle(Meno.bodyText)
                        Spacer()
                        Button { withAnimation(.easeInOut(duration: 0.15)) { tried.toggle() } } label: {
                            Text(tried ? "You tried this" : "I tried this too")
                                .font(.sans(13.5, .bold)).foregroundStyle(Meno.surface)
                                .padding(.horizontal, 14).frame(height: 36)
                                .background(Meno.sage).clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(14)
                    .background(Meno.sage.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .padding(.bottom, 18)

                    Text(tip.body).font(.sans(16.5)).foregroundStyle(Meno.ink).lineSpacing(5)
                        .padding(.bottom, 18)

                    if !tip.replies.isEmpty {
                        SectionLabel(text: "From the thread").padding(.bottom, 12)
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(tip.replies) { r in
                                HStack(alignment: .top, spacing: 10) {
                                    Avatar(initial: r.initial, tone: r.tone, size: 30)
                                    MenoCard(padding: 12) {
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text(r.author).font(.sans(13, .bold)).foregroundStyle(Meno.ink)
                                            Text(r.body).font(.sans(14.5)).foregroundStyle(Meno.sub).lineSpacing(2)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 22).padding(.top, 18).padding(.bottom, 24)
            }
        }
        .menoDeepIn()
        .menoLivingBackground(accent: Meno.gold)
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack { WisdomCategoryView(category: MenoStore().wisdomCategories[0]) }
        .environmentObject(MenoStore())
}
