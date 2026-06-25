import SwiftUI

/// Zone D, screen 26 — About this circle. Purpose + how members look after
/// each other, with a tap through to the member list (27).
struct CircleAboutView: View {
    let circle: MenoCircle
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            MenoHeader(title: "About this circle") { dismiss() }.padding(.top, 2)
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text(circle.name).font(.serif(26)).foregroundStyle(Meno.ink)
                        .padding(.bottom, 6)
                    Text(circle.about).font(.sans(16.5)).foregroundStyle(Meno.sub)
                        .lineSpacing(4).padding(.bottom, 22)

                    SectionLabel(text: "How we look after each other").padding(.bottom, 12)
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(circle.guidelines, id: \.self) { line in
                            HStack(alignment: .top, spacing: 12) {
                                Text("\u{2022}").font(.sans(18)).foregroundStyle(Meno.sage)
                                Text(line).font(.sans(15.5)).foregroundStyle(Meno.ink).lineSpacing(2)
                            }
                        }
                    }
                    .padding(.bottom, 24)

                    NavigationLink { CircleMembersView(circle: circle) } label: {
                        MenoCard {
                            HStack {
                                Text("\(circle.memberCount) members").font(.sans(15, .bold)).foregroundStyle(Meno.ink)
                                Spacer()
                                Text("See who\u{2019}s here \u{203A}").font(.sans(14, .bold)).foregroundStyle(Meno.clay)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24).padding(.top, 18).padding(.bottom, 24)
            }
        }
        .background(Meno.base)
        .navigationBarHidden(true)
    }
}

/// Zone D, screen 27 — Circle Members. Hosts, members, and respected anonymity.
struct CircleMembersView: View {
    let circle: MenoCircle
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").font(.system(size: 22)).foregroundStyle(Meno.faint)
                }
                Text("Members").font(.serif(24)).foregroundStyle(Meno.ink)
                Spacer()
                Text("\(circle.memberCount)").font(.sans(14)).foregroundStyle(Meno.muted)
            }
            .padding(.horizontal, 22).padding(.bottom, 12)
            .overlay(Rectangle().fill(Meno.hairline).frame(height: 1), alignment: .bottom)

            ScrollView {
                VStack(spacing: 0) {
                    ForEach(circle.members) { m in
                        HStack(spacing: 14) {
                            if m.anonymous {
                                PostAvatar(anonymous: true, size: 46)
                            } else {
                                Avatar(initial: m.initial, tone: m.tone, size: 46)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(m.name).font(.sans(16, .bold))
                                    .foregroundStyle(m.anonymous ? Meno.subtle : Meno.ink)
                                Text(m.here).font(.sans(13)).foregroundStyle(Meno.muted)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 16)
                        .overlay(Rectangle().fill(Meno.hairline).frame(height: 1), alignment: .bottom)
                    }
                }
                .padding(.horizontal, 22).padding(.bottom, 24)
            }
        }
        .background(Meno.base)
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack { CircleAboutView(circle: MenoStore().circles[0]) }
        .environmentObject(MenoStore())
}
