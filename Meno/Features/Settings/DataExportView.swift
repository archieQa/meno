import SwiftUI

/// Screen 69 — Data Export & Delete Account. Export is reassuring; delete is
/// gated behind an explicit confirmation because it's permanent.
struct DataExportView: View {
    @EnvironmentObject var store: MenoStore
    @AppStorage("meno.onboarded") private var onboarded = false
    @Environment(\.dismiss) private var dismiss
    @State private var confirmDelete = false

    var body: some View {
        SettingsScaffold(title: "Your data") {
            SettingsCard {
                SettingsNavRow(label: "Export my data")
            }
            Text("A full, readable copy of everything you\u{2019}ve shared, sent to your email.")
                .font(.sans(14)).foregroundStyle(Meno.sub).lineSpacing(1)
                .padding(.horizontal, 4).padding(.top, 14)

            SettingsGroupLabel(text: "Permanent")
            VStack(alignment: .leading, spacing: 16) {
                Text("Deleting removes your account, posts, check-ins and circles for good. This can\u{2019}t be undone.")
                    .font(.sans(15)).foregroundStyle(Meno.sub).lineSpacing(2)
                Button { confirmDelete = true } label: {
                    Text("Delete everything")
                        .font(.sans(16, .bold)).foregroundStyle(Meno.clay)
                        .frame(maxWidth: .infinity).frame(height: 52)
                        .overlay(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous)
                            .stroke(Meno.clay.opacity(0.4), lineWidth: 1.5))
                }
            }
            .padding(18)
            .background(Meno.clay.opacity(0.08))
            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Meno.clay.opacity(0.2), lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .confirmationDialog("Delete everything?", isPresented: $confirmDelete, titleVisibility: .visible) {
            Button("Delete my account", role: .destructive) {
                store.logOut()
                onboarded = false
            }
            Button("Keep my account", role: .cancel) { }
        } message: {
            Text("This permanently removes your account and everything in it. It can\u{2019}t be undone.")
        }
    }
}

#Preview {
    NavigationStack { DataExportView() }.environmentObject(MenoStore())
}
