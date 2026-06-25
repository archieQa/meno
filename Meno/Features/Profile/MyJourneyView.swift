import SwiftUI

/// Screen 50 — My Journey (a warm, engine-assembled timeline).
struct MyJourneyView: View {
    @EnvironmentObject var store: MenoStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            MenoHeader(title: "My Journey") { dismiss() }
                .padding(.top, 2)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Your path so far \u{2014} gathered gently, just for you.")
                        .font(.sans(15)).foregroundStyle(Meno.sub)
                        .lineSpacing(3)
                        .padding(.bottom, 22)

                    HStack(alignment: .top, spacing: 0) {
                        // The timeline rail
                        ZStack(alignment: .top) {
                            Rectangle().fill(Meno.clay.opacity(0.25))
                                .frame(width: 2)
                                .padding(.vertical, 6)
                            VStack(spacing: 0) {
                                ForEach(Array(store.journey.enumerated()), id: \.element.id) { idx, e in
                                    Circle().fill(dotColor(e.tone)).frame(width: 12, height: 12)
                                        .padding(.top, 4)
                                    if idx < store.journey.count - 1 { Spacer(minLength: 0) }
                                }
                            }
                        }
                        .frame(width: 12)
                        .padding(.trailing, 16)

                        VStack(alignment: .leading, spacing: 22) {
                            ForEach(store.journey) { e in
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(e.when).font(.sans(13)).foregroundStyle(Meno.muted)
                                    Text(e.title).font(.sans(16, .bold)).foregroundStyle(Meno.ink)
                                    if let d = e.detail {
                                        Text(d).font(.sans(14.5)).foregroundStyle(Meno.sub)
                                            .lineSpacing(2).padding(.top, 1)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 18)
                .padding(.bottom, 24)
            }
        }
        .background(Meno.base)
        .navigationBarHidden(true)
    }

    private func dotColor(_ t: JourneyEvent.Tone) -> Color {
        switch t {
        case .clay: return Meno.clay
        case .sage: return Meno.sage
        case .sand: return Color(hex: "CDB89C")
        }
    }
}

#Preview { NavigationStack { MyJourneyView() }.environmentObject(MenoStore()) }
