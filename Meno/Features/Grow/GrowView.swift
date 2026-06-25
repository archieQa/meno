import SwiftUI

/// Zone E — the Grow tab. Two gentle halves: woman-tested Wisdom (31) and
/// opt-in collective Challenges (35), behind a quiet segmented switch.
struct GrowView: View {
    @EnvironmentObject var store: MenoStore
    @State private var section: Section = .wisdom
    @State private var showShare = false

    enum Section: String, CaseIterable { case wisdom = "Wisdom", challenges = "Together" }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header
                segmented
                ScrollView {
                    if section == .wisdom { wisdom } else { challenges }
                }
            }
            .menoLivingBackground(accent: Meno.gold)
            .navigationBarHidden(true)
            .sheet(isPresented: $showShare) { ShareWisdomView() }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(section == .wisdom ? "Wisdom" : "Small things, together")
                .font(.serif(28)).foregroundStyle(Meno.ink)
            Text(section == .wisdom
                 ? "What\u{2019}s actually worked, from women who\u{2019}ve been there."
                 : "Opt in if you like. Never a performance.")
                .font(.sans(14)).foregroundStyle(Meno.taupe)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 22).padding(.bottom, 12)
    }

    private var segmented: some View {
        HStack(spacing: 8) {
            ForEach(Section.allCases, id: \.self) { s in
                Button { section = s } label: { Chip(title: s.rawValue, selected: section == s, height: 38) }
                    .buttonStyle(.plain)
            }
            Spacer()
        }
        .padding(.horizontal, 20).padding(.bottom, 14)
    }

    // MARK: Wisdom (31)
    private var wisdom: some View {
        VStack(spacing: 16) {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                ForEach(Array(store.wisdomCategories.enumerated()), id: \.element.id) { i, cat in
                    NavigationLink { WisdomCategoryView(category: cat) } label: { CategoryTile(category: cat) }
                        .buttonStyle(.plain)
                        .menoFadeUp(index: i, step: 0.08)
                }
            }
            Button { showShare = true } label: {
                Text("Share your own wisdom")
                    .font(.sans(17, .bold)).foregroundStyle(Meno.clay)
                    .frame(maxWidth: .infinity).frame(height: 54)
                    .overlay(RoundedRectangle(cornerRadius: Meno.rButton, style: .continuous)
                        .stroke(Meno.clay, lineWidth: 1.5))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20).padding(.top, 2).padding(.bottom, 24)
    }

    // MARK: Challenges (35)
    private var challenges: some View {
        VStack(spacing: 12) {
            ForEach(Array(store.challenges.enumerated()), id: \.element.id) { i, ch in
                NavigationLink { ChallengeDetailView(challenge: ch) } label: { ChallengeCard(challenge: ch) }
                    .buttonStyle(.plain)
                    .menoFadeUp(index: i)
            }
        }
        .padding(.horizontal, 20).padding(.top, 2).padding(.bottom, 24)
    }
}

/// A wisdom category tile with its tonal wash.
private struct CategoryTile: View {
    let category: WisdomCategory
    var body: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(category.tone.accent.opacity(0.4))
                .frame(width: 34, height: 34)
            Spacer(minLength: 24)
            Text(category.name).font(.serif(19)).foregroundStyle(Meno.ink)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 118, alignment: .leading)
        .background(
            ZStack {
                category.tone.softFill
                ShimmerGlow(color: category.tone.accent.opacity(0.5), duration: 20)
            }
        )
        .overlay(RoundedRectangle(cornerRadius: Meno.rCard, style: .continuous)
            .stroke(Meno.cardBorder, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: Meno.rCard, style: .continuous))
    }
}

/// A challenge card on the Together list.
struct ChallengeCard: View {
    @EnvironmentObject var store: MenoStore
    let challenge: Challenge
    var body: some View {
        MenoCard(padding: 18) {
            VStack(alignment: .leading, spacing: 6) {
                Text(challenge.title).font(.serif(20)).foregroundStyle(Meno.ink)
                Text(challenge.blurb).font(.sans(14.5)).foregroundStyle(Meno.subtle)
                    .lineSpacing(2).padding(.bottom, 8)
                HStack {
                    Text("\(challenge.participants) women doing this with you")
                        .font(.sans(13.5)).foregroundStyle(Meno.taupe)
                    Spacer()
                    Text(challenge.joined ? "Joined" : "Join")
                        .font(.sans(14, .bold))
                        .foregroundStyle(challenge.joined ? Meno.surface : Meno.clay)
                        .padding(.horizontal, 18).frame(height: 38)
                        .background(challenge.joined ? Meno.clay : .clear)
                        .overlay(Capsule().stroke(Meno.clay, lineWidth: 1.5))
                        .clipShape(Capsule())
                }
            }
        }
    }
}

#Preview { GrowView().environmentObject(MenoStore()) }
