import SwiftUI

/// Zone B, screen 14 — Post Composer (sheet, Cancel / Share).
/// Anonymity is front-and-centre; a circle target is optional.
struct PostComposerView: View {
    @EnvironmentObject var store: MenoStore
    @Environment(\.dismiss) private var dismiss

    @State private var text = ""
    @State private var anonymous = true
    @State private var circle: String? = "Working Through It"
    @FocusState private var focused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button("Cancel") { dismiss() }
                    .font(.sans(16, .bold)).foregroundStyle(Meno.taupe)
                Spacer()
                Text("New post").font(.serif(18)).foregroundStyle(Meno.ink)
                Spacer()
                Button("Share") {
                    let body = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !body.isEmpty else { return }
                    store.addPost(body: body, anonymous: anonymous, circle: circle)
                    dismiss()
                }
                .font(.sans(16, .heavy))
                .foregroundStyle(text.trimmingCharacters(in: .whitespaces).isEmpty ? Meno.faint : Meno.clay)
            }
            .padding(.horizontal, 22).padding(.top, 14).padding(.bottom, 14)
            .overlay(Rectangle().fill(Meno.hairline).frame(height: 1), alignment: .bottom)

            // Identity + anonymity toggle
            HStack(spacing: 10) {
                PostAvatar(anonymous: anonymous, initial: store.profile.initial, tone: store.profile.tone, size: 40)
                Button { withAnimation { anonymous.toggle() } } label: {
                    HStack(spacing: 8) {
                        Text(anonymous ? "Posting anonymously" : "Posting as \(store.profile.displayName)")
                            .font(.sans(14.5, .bold)).foregroundStyle(anonymous ? Meno.clay : Meno.sub)
                        MenoToggle(isOn: $anonymous, width: 40, height: 24)
                    }
                    .padding(.horizontal, 14).frame(height: 40)
                    .background(anonymous ? Meno.claySoft : Meno.ink.opacity(0.05))
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding(.horizontal, 22).padding(.top, 18).padding(.bottom, 4)

            // Editor
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text("What did today actually feel like?")
                        .font(.sans(18)).foregroundStyle(Meno.muted)
                        .padding(.horizontal, 22).padding(.top, 14)
                }
                TextEditor(text: $text)
                    .font(.sans(18)).foregroundStyle(Meno.ink)
                    .scrollContentBackground(.hidden)
                    .lineSpacing(4)
                    .padding(.horizontal, 18).padding(.top, 6)
                    .focused($focused)
            }
            .frame(maxHeight: .infinity, alignment: .top)

            // Footer toolbar
            HStack(spacing: 20) {
                Image(systemName: "photo").font(.system(size: 22)).foregroundStyle(Meno.taupe)
                Image(systemName: "mic").font(.system(size: 22)).foregroundStyle(Meno.taupe)
                Spacer()
                Menu {
                    Button("Working Through It") { circle = "Working Through It" }
                    Button("Foggy Days") { circle = "Foggy Days" }
                    Button("No circle") { circle = nil }
                } label: {
                    HStack(spacing: 7) {
                        Text("Share to: \(circle ?? "Everyone")")
                        Image(systemName: "chevron.right").font(.system(size: 11, weight: .bold))
                    }
                    .font(.sans(14, .bold)).foregroundStyle(Meno.sub)
                    .padding(.horizontal, 14).frame(height: 38)
                    .overlay(Capsule().stroke(Meno.border, lineWidth: 1.5))
                }
            }
            .padding(.horizontal, 24).padding(.vertical, 14)
            .background(Meno.surface)
            .overlay(Rectangle().fill(Meno.hairline).frame(height: 1), alignment: .top)
        }
        .background(Meno.base)
        .onAppear { focused = true }
    }
}

#Preview { PostComposerView().environmentObject(MenoStore()) }
