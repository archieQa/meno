import SwiftUI

// MARK: - Zone I shared rows
// Grouped settings rows in the Foundations card style. Reused by every
// Zone I screen so spacing, hairlines and tap targets stay consistent.

/// Uppercase group heading above a settings card.
struct SettingsGroupLabel: View {
    let text: String
    var body: some View {
        Text(text.uppercased())
            .font(.sans(12, .heavy)).tracking(0.5)
            .foregroundStyle(Meno.muted)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 18).padding(.bottom, 10)
    }
}

/// A card holding a vertical run of settings rows with hairline dividers.
struct SettingsCard<Content: View>: View {
    var tint: Color = Meno.surface
    var border: Color = Meno.cardBorder
    @ViewBuilder var content: Content
    var body: some View {
        VStack(spacing: 0) { content }
            .background(tint)
            .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(border, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

/// Row with a label and a trailing chevron (pushes to a sub-screen).
struct SettingsNavRow: View {
    let label: String
    var value: String? = nil
    var labelColor: Color = Meno.ink
    var body: some View {
        HStack {
            Text(label).font(.sans(16, .bold)).foregroundStyle(labelColor)
            Spacer()
            if let value {
                Text(value).font(.sans(15)).foregroundStyle(Meno.taupe)
            }
            Image(systemName: "chevron.right")
                .font(.system(size: 15, weight: .semibold)).foregroundStyle(Meno.faint)
        }
        .padding(16).contentShape(Rectangle())
    }
}

/// Row with a label and a bound toggle.
struct SettingsToggleRow: View {
    let label: String
    @Binding var isOn: Bool
    var body: some View {
        HStack {
            Text(label).font(.sans(16, .bold)).foregroundStyle(Meno.ink)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 12)
            MenoToggle(isOn: $isOn)
        }
        .padding(16)
    }
}

/// Hairline divider inset to match the card padding.
struct SettingsDivider: View {
    var body: some View { Rectangle().fill(Meno.hairline).frame(height: 1).padding(.leading, 16) }
}

/// Standard Zone I sub-screen chrome: back header + scrolling, padded body.
struct SettingsScaffold<Content: View>: View {
    let title: String
    var topPadding: CGFloat = 16
    @ViewBuilder var content: Content
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            MenoHeader(title: title) { dismiss() }
            ScrollView {
                VStack(alignment: .leading, spacing: 0) { content }
                    .padding(.horizontal, 20)
                    .padding(.top, topPadding)
                    .padding(.bottom, 28)
            }
        }
        .background(Meno.base)
        .navigationBarHidden(true)
    }
}

// MARK: - 56 Settings Home

struct SettingsView: View {
    @EnvironmentObject var store: MenoStore
    @State private var showLogOut = false

    var body: some View {
        VStack(spacing: 0) {
            MenoHeader(title: "Settings", onBack: nil)
            ScrollView {
                VStack(spacing: 0) {
                    SettingsGroupLabel(text: "Account & privacy")
                    SettingsCard {
                        NavigationLink { AccountSettingsView() } label: { SettingsNavRow(label: "Account") }
                        SettingsDivider()
                        NavigationLink { PrivacyDataView() } label: { SettingsNavRow(label: "Privacy & Data") }
                        SettingsDivider()
                        NavigationLink { AnonymitySettingsView() } label: { SettingsNavRow(label: "Anonymity") }
                        SettingsDivider()
                        NavigationLink { BlockedUsersView() } label: { SettingsNavRow(label: "Blocked users") }
                    }

                    SettingsGroupLabel(text: "App")
                    SettingsCard {
                        NavigationLink { NotificationSettingsView() } label: { SettingsNavRow(label: "Notifications") }
                        SettingsDivider()
                        NavigationLink { AppearanceSettingsView() } label: { SettingsNavRow(label: "Appearance & Accessibility") }
                    }

                    SettingsGroupLabel(text: "Support")
                    SettingsCard {
                        NavigationLink { HelpSupportView() } label: { SettingsNavRow(label: "Help & Support") }
                        SettingsDivider()
                        NavigationLink { CommunityGuidelinesView() } label: { SettingsNavRow(label: "Community Guidelines") }
                        SettingsDivider()
                        NavigationLink { SafetyReportView() } label: { SettingsNavRow(label: "Safety & Report") }
                        SettingsDivider()
                        NavigationLink { AboutMenoView() } label: { SettingsNavRow(label: "About Meno") }
                    }

                    Button { showLogOut = true } label: {
                        Text("Log out")
                            .font(.sans(16, .bold)).foregroundStyle(Meno.clay)
                            .frame(maxWidth: .infinity).frame(height: 52)
                            .overlay(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous)
                                .stroke(Meno.clay.opacity(0.4), lineWidth: 1.5))
                    }
                    .padding(.top, 28)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.bottom, 28)
            }
        }
        .background(Meno.base)
        .navigationBarHidden(true)
        .sheet(isPresented: $showLogOut) {
            LogOutSheet()
                .presentationDetents([.height(280)])
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - 70 Log Out

struct LogOutSheet: View {
    @EnvironmentObject var store: MenoStore
    @Environment(\.dismiss) private var dismiss
    @AppStorage("meno.onboarded") private var onboarded = false

    var body: some View {
        VStack(spacing: 0) {
            Text("Log out of Meno?")
                .font(.serif(24)).foregroundStyle(Meno.ink)
                .padding(.top, 30).padding(.bottom, 10)
            Text("Your circle will be right here when you\u{2019}re back.")
                .font(.sans(16)).foregroundStyle(Meno.sub)
                .multilineTextAlignment(.center)
                .padding(.bottom, 24)
            PrimaryButton(title: "Log out") {
                store.logOut()
                onboarded = false
                dismiss()
            }
            Button { dismiss() } label: {
                Text("Stay logged in")
                    .font(.sans(16, .bold)).foregroundStyle(Meno.taupe)
                    .frame(maxWidth: .infinity).frame(height: 50)
            }
            .padding(.top, 4)
        }
        .padding(.horizontal, 28)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Meno.base)
    }
}

#Preview {
    NavigationStack { SettingsView() }.environmentObject(MenoStore())
}
