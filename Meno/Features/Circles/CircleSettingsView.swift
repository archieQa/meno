import SwiftUI

/// Zone D, screen 29 — Circle settings (member view). Mute, notification level,
/// visibility, and a quiet way to leave (30, presented as a sheet).
struct CircleSettingsView: View {
    let circle: MenoCircle
    @Environment(\.dismiss) private var dismiss
    @State private var muted = false
    @State private var showLeave = false

    var body: some View {
        VStack(spacing: 0) {
            MenoHeader(title: "Circle settings") { dismiss() }.padding(.top, 2)
            ScrollView {
                VStack(spacing: 0) {
                    Text(circle.name).font(.serif(18)).foregroundStyle(Meno.ink)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 14).padding(.bottom, 6)

                    settingRow {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Mute this circle").font(.sans(16, .bold)).foregroundStyle(Meno.ink)
                            Text("Stay a member, pause the nudges").font(.sans(13)).foregroundStyle(Meno.muted)
                        }
                    } trailing: {
                        MenoToggle(isOn: $muted)
                    }

                    settingRow {
                        Text("Notification level").font(.sans(16, .bold)).foregroundStyle(Meno.ink)
                    } trailing: {
                        Text("Replies only \u{203A}").font(.sans(15)).foregroundStyle(Meno.taupe)
                    }

                    settingRow {
                        Text("Who can see my posts").font(.sans(16, .bold)).foregroundStyle(Meno.ink)
                    } trailing: {
                        Text("This circle \u{203A}").font(.sans(15)).foregroundStyle(Meno.taupe)
                    }

                    Button { showLeave = true } label: {
                        Text("Leave circle")
                            .font(.sans(16, .bold)).foregroundStyle(Meno.clay)
                            .frame(maxWidth: .infinity).frame(height: 52)
                            .overlay(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous)
                                .stroke(Meno.clay.opacity(0.4), lineWidth: 1.5))
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 24)
                }
                .padding(.horizontal, 24).padding(.bottom, 24)
            }
        }
        .background(Meno.base)
        .navigationBarHidden(true)
        .sheet(isPresented: $showLeave) {
            LeaveCircleSheet(circle: circle) { dismiss() }
                .presentationDetents([.height(330)])
                .presentationDragIndicator(.visible)
        }
    }

    private func settingRow<L: View, T: View>(@ViewBuilder _ leading: () -> L,
                                              @ViewBuilder trailing: () -> T) -> some View {
        HStack {
            leading()
            Spacer()
            trailing()
        }
        .padding(.vertical, 16)
        .overlay(Rectangle().fill(Meno.hairline).frame(height: 1), alignment: .bottom)
    }
}

/// Zone D, screen 30 — Leave Circle confirmation. Quiet exit, no announcement.
struct LeaveCircleSheet: View {
    let circle: MenoCircle
    var onLeave: () -> Void
    @EnvironmentObject var store: MenoStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 8)
            Text("Leaving \(circle.name)?").font(.serif(25)).foregroundStyle(Meno.ink)
                .multilineTextAlignment(.center).padding(.bottom, 12)
            Text("No hard feelings, and no announcement to the group. You\u{2019}re always welcome back whenever you need them.")
                .font(.sans(16.5)).foregroundStyle(Meno.sub)
                .multilineTextAlignment(.center).lineSpacing(3).padding(.bottom, 26)
            PrimaryButton(title: "Leave quietly") {
                store.leaveCircle(circle.id)
                dismiss()
                onLeave()
            }
            .padding(.bottom, 10)
            Button { dismiss() } label: {
                Text("Stay").font(.sans(16, .bold)).foregroundStyle(Meno.taupe)
                    .frame(maxWidth: .infinity).frame(height: 50)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 28).padding(.top, 22).padding(.bottom, 16)
        .frame(maxWidth: .infinity)
        .background(Meno.base)
    }
}

#Preview {
    NavigationStack { CircleSettingsView(circle: MenoStore().circles[0]) }
        .environmentObject(MenoStore())
}
