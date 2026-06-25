import SwiftUI

/// Zone E, screen 36 — Challenge Detail. Soft hero, the gentle premise, and the
/// women alongside you. Join, or step into progress if you already have.
struct ChallengeDetailView: View {
    let challenge: Challenge
    @EnvironmentObject var store: MenoStore
    @Environment(\.dismiss) private var dismiss

    private var live: Challenge {
        store.challenges.first { $0.id == challenge.id } ?? challenge
    }
    private var preview: [(initial: String, tone: AvatarTone)] {
        [("M", .sand), ("P", .clay), ("D", .sage)]
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").font(.system(size: 22)).foregroundStyle(Meno.faint)
                }
                Spacer()
            }
            .padding(.horizontal, 22).padding(.bottom, 12)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    RoundedRectangle(cornerRadius: Meno.rCard, style: .continuous)
                        .fill(LinearGradient(colors: [Meno.plum.opacity(0.20), Meno.sage.opacity(0.16)],
                                             startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(height: 120).padding(.bottom, 20)

                    Text(live.title).font(.serif(28)).foregroundStyle(Meno.ink).padding(.bottom, 10)
                    Text(live.detail).font(.sans(16.5)).foregroundStyle(Meno.sub).lineSpacing(4)
                        .padding(.bottom, 20)
                    HStack(spacing: 10) {
                        AvatarStack(people: preview, ring: Meno.base)
                        Text("\(live.participants) women alongside you")
                            .font(.sans(14)).foregroundStyle(Meno.taupe)
                    }
                }
                .padding(.horizontal, 24).padding(.top, 8).padding(.bottom, 20)
            }

            VStack(spacing: 10) {
                if live.joined {
                    NavigationLink { ChallengeProgressView(challenge: live) } label: {
                        Text("View your progress")
                            .font(.sans(17, .bold)).foregroundStyle(Meno.surface)
                            .frame(maxWidth: .infinity).frame(height: 54)
                            .background(Meno.clay)
                            .clipShape(RoundedRectangle(cornerRadius: Meno.rButton, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    Button { store.toggleChallenge(challenge.id) } label: {
                        Text("Leave challenge").font(.sans(15, .bold)).foregroundStyle(Meno.taupe)
                            .frame(maxWidth: .infinity).frame(height: 28)
                    }
                    .buttonStyle(.plain)
                } else {
                    PrimaryButton(title: "Join this challenge") { store.toggleChallenge(challenge.id) }
                }
            }
            .padding(.horizontal, 24).padding(.top, 6).padding(.bottom, 16)
        }
        .background(Meno.base)
        .navigationBarHidden(true)
    }
}

/// Zone E, screen 37 — Challenge Progress. No streak to break; showing up is it.
struct ChallengeProgressView: View {
    let challenge: Challenge
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            MenoHeader(title: "Better sleep") { dismiss() }.padding(.top, 2)
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("You\u{2019}re on night \(challenge.currentDay). However it\u{2019}s going, you\u{2019}re showing up \u{2014} that\u{2019}s the whole thing.")
                        .font(.sans(16)).foregroundStyle(Meno.sub).lineSpacing(4).padding(.bottom, 22)

                    HStack(spacing: 9) {
                        ForEach(0..<challenge.totalDays, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(fill(for: i))
                                .frame(maxWidth: .infinity).frame(height: 46)
                        }
                    }
                    .padding(.bottom, 24)

                    MenoCard(padding: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            SectionLabel(text: "From the group tonight", color: Meno.sageDark)
                            Text("\u{201C}\(challenge.groupNote)\u{201D} \u{2014} \(challenge.groupNoteBy)")
                                .font(.sans(16)).foregroundStyle(Meno.bodyText).lineSpacing(3)
                        }
                    }
                    .background(Meno.sage.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: Meno.rCard, style: .continuous))
                }
                .padding(.horizontal, 24).padding(.top, 18).padding(.bottom, 20)
            }
            PrimaryButton(title: "Mark tonight done") { dismiss() }
                .padding(.horizontal, 24).padding(.top, 6).padding(.bottom, 16)
        }
        .background(Meno.base)
        .navigationBarHidden(true)
    }

    private func fill(for index: Int) -> Color {
        if index < challenge.currentDay - 1 { return Meno.sage }
        if index == challenge.currentDay - 1 { return Meno.clay }
        return Meno.ink.opacity(0.08)
    }
}

#Preview {
    NavigationStack { ChallengeDetailView(challenge: MenoStore().challenges[0]) }
        .environmentObject(MenoStore())
}
