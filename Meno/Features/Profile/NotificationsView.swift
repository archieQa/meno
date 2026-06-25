import SwiftUI

/// Screen 55 — Notifications (engine-paced, warm, never spammy).
struct NotificationsView: View {
    @EnvironmentObject var store: MenoStore
    @Environment(\.dismiss) private var dismiss

    private var buckets: [MenoNotification.Bucket] { [.today, .earlier] }

    var body: some View {
        VStack(spacing: 0) {
            MenoHeader(title: "Notifications") { dismiss() }
                .padding(.top, 2)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(buckets, id: \.self) { bucket in
                        let items = store.notifications.filter { $0.bucket == bucket }
                        if !items.isEmpty {
                            SectionLabel(text: bucket.rawValue)
                                .padding(.top, bucket == .today ? 12 : 18)
                                .padding(.bottom, 10)
                            ForEach(items) { n in row(n) }
                        }
                    }
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 24)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .background(Meno.base)
        .navigationBarHidden(true)
    }

    private func row(_ n: MenoNotification) -> some View {
        HStack(alignment: .top, spacing: 12) {
            glyph(n.glyph)
            VStack(alignment: .leading, spacing: 3) {
                Text(attributed(n.text))
                    .font(.sans(15.5)).foregroundStyle(Meno.ink).lineSpacing(2)
                Text(n.time).font(.sans(13)).foregroundStyle(Meno.muted)
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 12)
    }

    @ViewBuilder
    private func glyph(_ g: MenoNotification.Glyph) -> some View {
        switch g {
        case let .person(initial, tone):
            Avatar(initial: initial, tone: tone, size: 40)
        case .checkin:
            ZStack {
                Circle().fill(Meno.claySoft).frame(width: 40, height: 40)
                Image(systemName: "smallcircle.filled.circle")
                    .font(.system(size: 18)).foregroundStyle(Meno.clay)
            }
        }
    }

    private func attributed(_ md: String) -> AttributedString {
        (try? AttributedString(markdown: md)) ?? AttributedString(md)
    }
}

#Preview { NavigationStack { NotificationsView() }.environmentObject(MenoStore()) }
