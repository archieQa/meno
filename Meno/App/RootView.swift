import SwiftUI

/// App shell: the custom Meno tab bar pinned to the bottom. Today (Zone B),
/// Check-in (Zone C) and Profile/Search/Notifications (Zone G) are built;
/// Circles, Grow and Market still show gentle placeholders.
struct RootView: View {
    @State private var tab: MenoTab = .today

    var body: some View {
        ZStack(alignment: .bottom) {
            Meno.base.ignoresSafeArea()

            Group {
                switch tab {
                case .today:   TodayFeedView()
                case .circles: CirclesView()
                case .checkin: CheckInView(onClose: { tab = .today })
                case .grow:    GrowView()
                case .market:  MarketView()
                }
            }
            .id(tab)              // re-trigger the entrance each time the tab changes
            .menoScreenIn()
            // Reserve the bar's height for *content* only. Unlike `.padding`, this
            // doesn't shrink the screen's frame, so each screen's full-bleed
            // `.ignoresSafeArea()` background flows continuously down behind the
            // bar — letting the translucent tab bar pick up the warm gradient.
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Color.clear.frame(height: 84)
            }

            MenoTabBar(selection: $tab)
        }
        .background(Meno.base)
    }
}

struct PlaceholderView: View {
    let title: String
    let line: String
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title).font(.serif(26)).foregroundStyle(Meno.ink)
                Spacer()
            }
            .padding(.horizontal, 22).padding(.bottom, 14)
            .overlay(Rectangle().fill(Meno.hairline).frame(height: 1), alignment: .bottom)
            PlaceholderBody(line: line)
        }
        .background(Meno.base)
    }
}

private struct PlaceholderBody: View {
    let line: String
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "leaf")
                .font(.system(size: 34, weight: .light))
                .foregroundStyle(Meno.sage)
            Text(line)
                .font(.sans(16))
                .foregroundStyle(Meno.taupe)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 40)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
