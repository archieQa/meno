import SwiftUI

/// Screen 48 — Edit Profile (presented as a sheet with Cancel / Save).
struct EditProfileView: View {
    @EnvironmentObject var store: MenoStore
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var bio: String = ""

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button("Cancel") { dismiss() }
                    .font(.sans(16, .bold)).foregroundStyle(Meno.taupe)
                Spacer()
                Text("Edit profile").font(.serif(18)).foregroundStyle(Meno.ink)
                Spacer()
                Button("Save") {
                    store.profile.displayName = name
                    store.profile.initial = String(name.prefix(1)).uppercased()
                    store.profile.bio = bio
                    dismiss()
                }
                .font(.sans(16, .heavy)).foregroundStyle(Meno.clay)
            }
            .padding(.horizontal, 22)
            .padding(.top, 14)
            .padding(.bottom, 14)
            .overlay(Rectangle().fill(Meno.hairline).frame(height: 1), alignment: .bottom)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(spacing: 10) {
                        Avatar(initial: store.profile.initial, tone: store.profile.tone, size: 84)
                        Text("Change avatar").font(.sans(14, .bold)).foregroundStyle(Meno.clay)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)

                    fieldLabel("Display name")
                    TextField("Your name", text: $name)
                        .font(.sans(16)).foregroundStyle(Meno.ink)
                        .padding(.horizontal, 16)
                        .frame(height: 50)
                        .background(fieldBg)
                        .padding(.bottom, 18)

                    HStack(spacing: 5) {
                        fieldLabel("A line about you")
                        Text("(optional)").font(.sans(13, .medium)).foregroundStyle(Meno.faint)
                    }
                    .padding(.bottom, 7)

                    ZStack(alignment: .topLeading) {
                        fieldBg
                        TextEditor(text: $bio)
                            .font(.sans(16))
                            .foregroundStyle(Meno.ink)
                            .scrollContentBackground(.hidden)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                    }
                    .frame(minHeight: 84)
                }
                .padding(22)
            }
        }
        .background(Meno.base)
        .onAppear { name = store.profile.displayName; bio = store.profile.bio }
    }

    private func fieldLabel(_ t: String) -> some View {
        Text(t).font(.sans(13, .bold)).foregroundStyle(Meno.taupe).padding(.bottom, 7)
    }

    private var fieldBg: some View {
        RoundedRectangle(cornerRadius: Meno.rField, style: .continuous)
            .fill(Meno.surface)
            .overlay(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous).stroke(Meno.border, lineWidth: 1.5))
    }
}

#Preview { EditProfileView().environmentObject(MenoStore()) }
