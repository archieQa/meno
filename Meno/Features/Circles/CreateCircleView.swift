import SwiftUI

/// Zone D, screen 28 — Create / Request a Circle. Gather your own people;
/// Meno helps the right women find it.
struct CreateCircleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var who = ""
    @State private var keepPrivate = true

    var body: some View {
        VStack(spacing: 0) {
            MenoHeader(title: "Start a circle") { dismiss() }.padding(.top, 2)
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Can\u{2019}t find your people? Gather them. We\u{2019}ll help the right women find it.")
                        .font(.sans(16)).foregroundStyle(Meno.sub).lineSpacing(3).padding(.bottom, 22)

                    fieldLabel("Circle name")
                    TextField("Single & Thriving", text: $name)
                        .font(.sans(16)).foregroundStyle(Meno.ink)
                        .padding(.horizontal, 16).frame(height: 50)
                        .background(Meno.surface)
                        .overlay(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous)
                            .stroke(Meno.border, lineWidth: 1.5))
                        .clipShape(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous))
                        .padding(.bottom, 18)

                    fieldLabel("Who\u{2019}s it for?")
                    ZStack(alignment: .topLeading) {
                        if who.isEmpty {
                            Text("Women doing this season on their own terms\u{2026}")
                                .font(.sans(16)).foregroundStyle(Meno.muted)
                                .padding(.horizontal, 16).padding(.top, 13)
                        }
                        TextEditor(text: $who)
                            .font(.sans(16)).foregroundStyle(Meno.ink)
                            .scrollContentBackground(.hidden)
                            .padding(.horizontal, 12).padding(.vertical, 6)
                            .frame(minHeight: 88)
                    }
                    .background(Meno.surface)
                    .overlay(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous)
                        .stroke(Meno.border, lineWidth: 1.5))
                    .clipShape(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous))
                    .padding(.bottom, 18)

                    HStack {
                        Text("Keep it small & private").font(.sans(15, .bold)).foregroundStyle(Meno.bodyText)
                        Spacer()
                        MenoToggle(isOn: $keepPrivate)
                    }
                    .padding(14)
                    .background(Meno.sage.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .padding(.horizontal, 24).padding(.top, 18).padding(.bottom, 16)
            }
            PrimaryButton(title: "Request circle") { dismiss() }
                .padding(.horizontal, 24).padding(.top, 8).padding(.bottom, 16)
        }
        .background(Meno.base)
        .navigationBarHidden(true)
    }

    private func fieldLabel(_ text: String) -> some View {
        Text(text).font(.sans(13, .bold)).foregroundStyle(Meno.taupe)
            .frame(maxWidth: .infinity, alignment: .leading).padding(.bottom, 7)
    }
}

#Preview { NavigationStack { CreateCircleView() }.environmentObject(MenoStore()) }
