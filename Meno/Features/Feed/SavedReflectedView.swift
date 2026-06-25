import SwiftUI

/// Zone B, screen 18 — Saved & Reflected ("words you wanted to hold onto"),
/// closing with a gentle, engine-surfaced reflection.
struct SavedReflectedView: View {
    @EnvironmentObject var store: MenoStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").font(.system(size: 22)).foregroundStyle(Meno.faint)
                }
                Text("Saved").font(.serif(24)).foregroundStyle(Meno.ink)
                Spacer()
            }
            .padding(.horizontal, 22).padding(.bottom, 12)
            .overlay(Rectangle().fill(Meno.hairline).frame(height: 1), alignment: .bottom)

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Words you wanted to hold onto.")
                        .font(.sans(15)).foregroundStyle(Meno.sub).padding(.bottom, 4)

                    ForEach(store.savedQuotes) { q in
                        MenoCard {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 10) {
                                    Avatar(initial: q.initial, tone: q.tone, size: 32)
                                    Text(q.author).font(.sans(14, .bold)).foregroundStyle(Meno.ink)
                                    Spacer()
                                    Image(systemName: "bookmark.fill").font(.system(size: 15)).foregroundStyle(Meno.clay)
                                }
                                Text(q.body).font(.sans(16)).foregroundStyle(Meno.ink).lineSpacing(2)
                            }
                        }
                    }

                    // Reflected back to you
                    VStack(alignment: .leading, spacing: 8) {
                        SectionLabel(text: "Reflected back to you", color: Meno.sageDark)
                        Text("You\u{2019}ve saved a lot about sleep lately. Three women in your circle have too — want to start a thread?")
                            .font(.sans(16)).foregroundStyle(Meno.bodyText).lineSpacing(3)
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Meno.sage.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .padding(.top, 6)
                }
                .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 24)
            }
        }
        .background(Meno.base)
        .navigationBarHidden(true)
    }
}

#Preview { NavigationStack { SavedReflectedView() }.environmentObject(MenoStore()) }
