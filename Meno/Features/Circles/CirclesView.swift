import SwiftUI

/// Zone D, screen 23 — My Circles (the Circles tab root).
/// Small, private, pseudonymous rooms. Lively circles surface first.
struct CirclesView: View {
    @EnvironmentObject var store: MenoStore

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(Array(store.circles.enumerated()), id: \.element.id) { i, circle in
                            NavigationLink { CircleHomeView(circle: circle) } label: {
                                CircleCard(circle: circle)
                            }
                            .buttonStyle(.plain)
                            .menoFadeUp(index: i)
                        }
                        NavigationLink { DiscoverCirclesView() } label: {
                            Text("Discover more circles")
                                .font(.sans(17, .bold)).foregroundStyle(Meno.clay)
                                .frame(maxWidth: .infinity).frame(height: 54)
                                .overlay(RoundedRectangle(cornerRadius: Meno.rButton, style: .continuous)
                                    .stroke(Meno.clay, lineWidth: 1.5))
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 4)
                    }
                    .padding(.horizontal, 20).padding(.top, 14).padding(.bottom, 24)
                }
            }
            .menoLivingBackground()
            .navigationBarHidden(true)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Your Circles").font(.serif(28)).foregroundStyle(Meno.ink)
            Text("Small, private, pseudonymous by design.")
                .font(.sans(14)).foregroundStyle(Meno.taupe)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 22).padding(.bottom, 12)
    }
}

/// A single circle on the My Circles list. Lively rooms get a clay wash.
private struct CircleCard: View {
    let circle: MenoCircle

    private var preview: [(initial: String, tone: AvatarTone)] {
        circle.members.filter { !$0.anonymous }.prefix(3).map { ($0.initial, $0.tone) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if circle.isLively {
                HStack(spacing: 7) {
                    LivePulseDot(color: Meno.sage, size: 8)
                    Text(circle.status.uppercased())
                        .font(.sans(12, .heavy)).tracking(0.5).foregroundStyle(Meno.clayDark)
                }
                .padding(.bottom, 8)
            } else {
                Text(circle.status)
                    .font(.sans(12, .bold)).foregroundStyle(Meno.muted)
                    .padding(.bottom, 8)
            }
            Text(circle.name).font(.serif(22)).foregroundStyle(Meno.ink)
                .padding(.bottom, circle.isLively ? 8 : 4)
            if circle.isLively {
                HStack(spacing: 10) {
                    AvatarStack(people: preview)
                    Text(circle.memberLine).font(.sans(13.5)).foregroundStyle(Meno.taupe)
                }
            } else {
                Text(circle.memberLine).font(.sans(13.5)).foregroundStyle(Meno.taupe)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(circle.isLively ? Meno.clay.opacity(0.10) : Meno.surface)
        .overlay(RoundedRectangle(cornerRadius: Meno.rCard, style: .continuous)
            .stroke(circle.isLively ? Meno.clay.opacity(0.22) : Meno.cardBorder, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: Meno.rCard, style: .continuous))
    }
}

#Preview { CirclesView().environmentObject(MenoStore()) }
