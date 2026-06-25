import SwiftUI

/// Zone F, screen 46 — Recommend a Product. Modal form (Cancel / Send): tell your
/// circle about something that genuinely helped.
struct RecommendProductView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var what = ""
    @State private var why = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Cancel") { dismiss() }
                    .font(.sans(16, .bold)).foregroundStyle(Meno.taupe)
                Spacer()
                Text("Recommend").font(.serif(18)).foregroundStyle(Meno.ink)
                Spacer()
                Button("Send") { dismiss() }
                    .font(.sans(16, .heavy)).foregroundStyle(Meno.clay)
            }
            .padding(.horizontal, 22).padding(.top, 18).padding(.bottom, 14)
            .overlay(Rectangle().fill(Meno.hairline).frame(height: 1), alignment: .bottom)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Found something that genuinely helped? Tell your circle.")
                        .font(.sans(16)).foregroundStyle(Meno.sub).lineSpacing(3).padding(.bottom, 20)

                    fieldLabel("What is it?")
                    TextField("Product name or link", text: $what)
                        .font(.sans(16)).foregroundStyle(Meno.ink)
                        .padding(.horizontal, 16).frame(height: 50)
                        .background(Meno.surface)
                        .overlay(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous)
                            .stroke(Meno.border, lineWidth: 1.5))
                        .clipShape(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous))
                        .padding(.bottom, 16)

                    fieldLabel("Why it helped you")
                    ZStack(alignment: .topLeading) {
                        if why.isEmpty {
                            Text("A line or two, in your own words\u{2026}")
                                .font(.sans(16)).foregroundStyle(Meno.muted)
                                .padding(.horizontal, 16).padding(.top, 14)
                        }
                        TextEditor(text: $why)
                            .font(.sans(16)).foregroundStyle(Meno.ink)
                            .scrollContentBackground(.hidden)
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .frame(minHeight: 100)
                    }
                    .background(Meno.surface)
                    .overlay(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous)
                        .stroke(Meno.border, lineWidth: 1.5))
                    .clipShape(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous))
                }
                .padding(.horizontal, 22).padding(.top, 18).padding(.bottom, 24)
            }
        }
        .background(Meno.base)
    }

    private func fieldLabel(_ text: String) -> some View {
        Text(text).font(.sans(13, .bold)).foregroundStyle(Meno.taupe)
            .frame(maxWidth: .infinity, alignment: .leading).padding(.bottom, 7)
    }
}

#Preview { RecommendProductView().environmentObject(MenoStore()) }
