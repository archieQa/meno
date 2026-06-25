import SwiftUI

/// Zone E, screen 34 — Share Your Wisdom. A modal form (Cancel / Post) with a
/// gentle reminder that this is shared experience, not medical advice.
struct ShareWisdomView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var howto = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Cancel") { dismiss() }
                    .font(.sans(16, .bold)).foregroundStyle(Meno.taupe)
                Spacer()
                Text("Share wisdom").font(.serif(18)).foregroundStyle(Meno.ink)
                Spacer()
                Button("Post") { dismiss() }
                    .font(.sans(16, .heavy)).foregroundStyle(Meno.clay)
            }
            .padding(.horizontal, 22).padding(.top, 18).padding(.bottom, 14)
            .overlay(Rectangle().fill(Meno.hairline).frame(height: 1), alignment: .bottom)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    fieldLabel("Give it a title")
                    TextField("What helped you, in a line\u{2026}", text: $title)
                        .font(.sans(16)).foregroundStyle(Meno.ink)
                        .padding(.horizontal, 16).frame(height: 50)
                        .background(Meno.surface)
                        .overlay(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous)
                            .stroke(Meno.border, lineWidth: 1.5))
                        .clipShape(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous))
                        .padding(.bottom, 16)

                    fieldLabel("Tell us how")
                    ZStack(alignment: .topLeading) {
                        if howto.isEmpty {
                            Text("Write it like you\u{2019}d tell a friend. Real and practical.")
                                .font(.sans(16)).foregroundStyle(Meno.muted)
                                .padding(.horizontal, 16).padding(.top, 14)
                        }
                        TextEditor(text: $howto)
                            .font(.sans(16)).foregroundStyle(Meno.ink)
                            .scrollContentBackground(.hidden)
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .frame(minHeight: 120)
                    }
                    .background(Meno.surface)
                    .overlay(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous)
                        .stroke(Meno.border, lineWidth: 1.5))
                    .clipShape(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous))
                    .padding(.bottom, 16)

                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "exclamationmark.circle")
                            .font(.system(size: 17)).foregroundStyle(Meno.goldDark).padding(.top, 1)
                        Text("Shared experience, not medical advice. A gentle human moderator reads new tips first.")
                            .font(.sans(13.5)).foregroundStyle(Meno.goldDark).lineSpacing(2)
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Meno.gold.opacity(0.14))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
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

#Preview { ShareWisdomView().environmentObject(MenoStore()) }
