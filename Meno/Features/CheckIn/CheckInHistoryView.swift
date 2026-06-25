import SwiftUI

/// Zone C, screen 21 — Check-in History. A gentle record. No scores, no streaks.
struct CheckInHistoryView: View {
    @EnvironmentObject var store: MenoStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").font(.system(size: 22)).foregroundStyle(Meno.faint)
                }
                Text("Your check-ins").font(.serif(24)).foregroundStyle(Meno.ink)
                Spacer()
            }
            .padding(.horizontal, 22).padding(.bottom, 12)
            .overlay(Rectangle().fill(Meno.hairline).frame(height: 1), alignment: .bottom)

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("A gentle record. No scores, no streaks.")
                        .font(.sans(15)).foregroundStyle(Meno.sub).padding(.bottom, 6)

                    ForEach(store.checkInLog) { entry in
                        HStack(spacing: 14) {
                            Circle().fill(Color(hex: entry.mood.hex)).frame(width: 14, height: 14)
                            MenoCard {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(entry.day).font(.sans(13)).foregroundStyle(Meno.muted)
                                    HStack(spacing: 6) {
                                        Text(entry.mood.rawValue).font(.sans(17, .bold)).foregroundStyle(Meno.ink)
                                        if let note = entry.note {
                                            Text("\u{00B7} \u{201C}\(note)\u{201D}").font(.sans(14)).foregroundStyle(Meno.muted)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 22).padding(.top, 18).padding(.bottom, 24)
            }
        }
        .background(Meno.base)
        .navigationBarHidden(true)
    }
}

#Preview { NavigationStack { CheckInHistoryView() }.environmentObject(MenoStore()) }
