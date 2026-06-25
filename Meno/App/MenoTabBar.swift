import SwiftUI

enum MenoTab: Int, CaseIterable {
    case today, circles, checkin, grow, market
    var label: String {
        switch self {
        case .today: return "Today"
        case .circles: return "Circles"
        case .checkin: return "Check-in"
        case .grow: return "Grow"
        case .market: return "Market"
        }
    }
}

/// Custom bottom navigation with the floating central check-in button,
/// matching the Foundations "Bottom navigation" component.
struct MenoTabBar: View {
    @Binding var selection: MenoTab

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            item(.today)
            item(.circles)
            centerItem
            item(.grow)
            item(.market)
        }
        .padding(.horizontal, 6)
        .padding(.top, 8)
        .padding(.bottom, 28)
        // Translucent: the bar blurs and tints to whatever screen sits behind it,
        // so it melts into the warm gradient on Check-in and the cream base on the
        // feed — adapting to light/dark automatically instead of a fixed slab.
        .background(.ultraThinMaterial)
        // A whisper of a top edge for depth, fading out rather than a hard line.
        .overlay(
            LinearGradient(colors: [Meno.hairline, .clear], startPoint: .top, endPoint: .bottom)
                .frame(height: 10),
            alignment: .top
        )
    }

    private func item(_ tab: MenoTab) -> some View {
        let active = selection == tab
        return Button { selection = tab } label: {
            VStack(spacing: 4) {
                glyph(for: tab, active: active)
                Text(tab.label)
                    .font(.sans(11, .bold))
                    .foregroundStyle(active ? Meno.clay : Meno.navIdle)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(MenoPress(scale: 0.9))
    }

    private var centerItem: some View {
        let active = selection == .checkin
        return Button { selection = .checkin } label: {
            VStack(spacing: 5) {
                CenterPulseButton()
                    .offset(y: -22)
                    .padding(.bottom, -22)
                Text("Check-in")
                    .font(.sans(11, .bold))
                    .foregroundStyle(active ? Meno.clay : Meno.navIdle)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(MenoPress(scale: 0.92))
    }

    @ViewBuilder
    private func glyph(for tab: MenoTab, active: Bool) -> some View {
        let c = active ? Meno.clay : Meno.navIdle
        Group {
            switch tab {
            case .today:   Image(systemName: "text.alignleft")
            case .circles: Image(systemName: "circle.grid.2x1")
            case .grow:    Image(systemName: "leaf")
            case .market:  Image(systemName: "bag")
            case .checkin: Image(systemName: "smallcircle.filled.circle")
            }
        }
        .font(.system(size: 22, weight: .regular))
        .foregroundStyle(c)
        .frame(height: 24)
    }
}

/// The floating check-in button: it gently breathes (scale + shadow) and emits a
/// slow outward ring, an open invitation to pause. Calms under Reduce Motion.
private struct CenterPulseButton: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var pulse = false
    @State private var ring = false

    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Meno.clay.opacity(0.5), lineWidth: 1.5)
                .frame(width: 54, height: 54)
                .scaleEffect(ring ? 1.7 : 1)
                .opacity(ring ? 0 : 0.5)
                .animation(.easeOut(duration: 3.6).repeatForever(autoreverses: false), value: ring)

            Circle().fill(Meno.clay)
                .frame(width: 54, height: 54)
                .shadow(color: Meno.clay.opacity(0.4), radius: pulse ? 13 : 8, x: 0, y: 6)
                .scaleEffect(pulse ? 1.06 : 1)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: pulse)
                .overlay(
                    Image(systemName: "smallcircle.filled.circle")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundStyle(Meno.surface)
                )
        }
        .onAppear {
            guard !reduceMotion else { return }
            pulse = true
            ring = true
        }
    }
}
