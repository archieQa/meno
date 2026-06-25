import SwiftUI

/// Screen 49 — Public Profile (how another woman appears, e.g. a circle host).
struct PublicProfileView: View {
    let person: PublicProfile
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").font(.system(size: 22)).foregroundStyle(Meno.faint)
                }
                Spacer()
            }
            .padding(.horizontal, 22).padding(.top, 2).padding(.bottom, 8)

            ScrollView {
                VStack(spacing: 0) {
                    Avatar(initial: person.initial, tone: person.tone, size: 84)
                        .padding(.bottom, 12)
                    Text(person.name).font(.serif(23)).foregroundStyle(Meno.ink)
                    Text(person.tagline)
                        .font(.sans(14)).foregroundStyle(Meno.taupe)
                        .multilineTextAlignment(.center)
                        .padding(.top, 3)
                        .padding(.horizontal, 20)

                    // Badges
                    HStack {
                        ForEach(person.badges, id: \.self) { badge in
                            Text(badge)
                                .font(.sans(13, .bold))
                                .foregroundStyle(Meno.clayDark)
                                .padding(.horizontal, 14)
                                .frame(height: 34)
                                .background(Meno.claySoft)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.vertical, 22)

                    MenoCard {
                        VStack(alignment: .leading, spacing: 10) {
                            SectionLabel(text: "Recently shared")
                            Text(person.recentlyShared)
                                .font(.sans(15.5)).foregroundStyle(Meno.ink)
                                .lineSpacing(3)
                        }
                    }
                }
                .padding(.horizontal, 22)
                .padding(.top, 10)
                .padding(.bottom, 24)
            }
        }
        .background(Meno.base)
        .navigationBarHidden(true)
    }
}

#Preview {
    PublicProfileView(person: MenoStore().mentor)
}
