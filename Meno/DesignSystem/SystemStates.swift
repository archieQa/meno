import SwiftUI

// MARK: - System states (from "Meno — Zone I + States")
// Reusable full-surface states. Warm, never alarming — the audience is 45–55
// and a red error wall is the opposite of the brand. Drop these into any
// screen that loads, fails, goes offline, or has nothing to show yet.

/// Three softly-pulsing clay dots + a gentle line. Use while first content loads.
struct LoadingStateView: View {
    var message: String = "Gathering your circle\u{2026}"
    @State private var phase = 0

    private let timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 10) {
                ForEach(0..<3) { i in
                    Circle().fill(Meno.clay)
                        .frame(width: 14, height: 14)
                        .opacity(phase == i ? 0.9 : 0.25)
                }
            }
            .onReceive(timer) { _ in
                withAnimation(.easeInOut(duration: 0.3)) { phase = (phase + 1) % 3 }
            }
            Text(message)
                .font(.serif(19)).foregroundStyle(Meno.taupe)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Meno.base)
    }
}

/// Recoverable failure. Soft clay circle, reassuring copy, one "Try again".
struct ErrorStateView: View {
    var title: String = "Something went sideways"
    var message: String = "Not your fault. Let\u{2019}s try that again."
    var retry: () -> Void = {}

    var body: some View {
        StateScaffold(
            badge: badge,
            title: title, message: message
        ) {
            Button(action: retry) {
                Text("Try again")
                    .font(.sans(16, .bold)).foregroundStyle(Meno.clay)
                    .padding(.horizontal, 28).frame(height: 50)
                    .overlay(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous)
                        .stroke(Meno.clay, lineWidth: 1.5))
            }
        }
    }

    private var badge: some View {
        Circle().fill(Meno.claySoft).frame(width: 80, height: 80)
            .overlay(Image(systemName: "exclamationmark.circle")
                .font(.system(size: 34, weight: .regular)).foregroundStyle(Meno.clay))
    }
}

/// No connection. Sage-toned, calm, reassures the draft is safe.
struct OfflineStateView: View {
    var body: some View {
        StateScaffold(
            badge: Circle().fill(Meno.sage.opacity(0.18)).frame(width: 80, height: 80)
                .overlay(Image(systemName: "wifi.slash")
                    .font(.system(size: 32, weight: .regular)).foregroundStyle(Meno.sage)),
            title: "You\u{2019}re offline",
            message: "We\u{2019}ll reconnect you the moment you\u{2019}re back. Your draft is saved."
        ) { EmptyView() }
    }
}

/// Nothing here yet. Reusable empty state with optional action.
struct EmptyStateView: View {
    var title: String = "Nothing here yet"
    var message: String = "When there\u{2019}s something to see, it\u{2019}ll show up right here."
    var actionTitle: String? = nil
    var action: () -> Void = {}

    var body: some View {
        StateScaffold(badge: badge, title: title, message: message) {
            if let actionTitle {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.sans(16, .bold)).foregroundStyle(Meno.surface)
                        .padding(.horizontal, 28).frame(height: 50)
                        .background(Meno.clay)
                        .clipShape(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous))
                }
            }
        }
    }

    private var badge: some View {
        Circle().fill(Meno.sage.opacity(0.16)).frame(width: 100, height: 100)
            .overlay(
                ZStack {
                    Circle().fill(Meno.clay.opacity(0.3)).frame(width: 44, height: 44).offset(x: -12, y: -8)
                    Circle().fill(Meno.sage.opacity(0.5)).frame(width: 34, height: 34).offset(x: 14, y: 14)
                }
            )
    }
}

/// Shared centred layout for the error/offline/empty states.
private struct StateScaffold<Badge: View, Action: View>: View {
    let badge: Badge
    let title: String
    let message: String
    @ViewBuilder var action: Action

    var body: some View {
        VStack(spacing: 0) {
            badge.padding(.bottom, 20)
            Text(title)
                .font(.serif(24)).foregroundStyle(Meno.ink)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            Text(message)
                .font(.sans(16)).foregroundStyle(Meno.sub)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .padding(.bottom, 24)
            action
        }
        .padding(.horizontal, 36)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Meno.base)
    }
}

#Preview("Loading") { LoadingStateView() }
#Preview("Error") { ErrorStateView() }
#Preview("Offline") { OfflineStateView() }
#Preview("Empty") { EmptyStateView(actionTitle: "Explore") }
