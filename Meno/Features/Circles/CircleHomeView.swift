import SwiftUI

/// Zone D, screen 25 — Circle Home. Warm gradient masthead, the room's posts,
/// and a gentle "share with this circle" prompt pinned at the bottom.
/// Info opens About (26); the gear opens Settings (29).
struct CircleHomeView: View {
    let circle: MenoCircle
    @Environment(\.dismiss) private var dismiss

    private var preview: [(initial: String, tone: AvatarTone)] {
        circle.members.filter { !$0.anonymous }.prefix(3).map { ($0.initial, $0.tone) }
    }

    var body: some View {
        VStack(spacing: 0) {
            masthead
            ScrollView {
                VStack(spacing: 12) {
                    welcomeBanner
                    ForEach(circle.posts) { post in CirclePostCard(post: post) }
                }
                .padding(.horizontal, 18).padding(.top, 16).padding(.bottom, 20)
            }
            composer
        }
        .menoDeepIn()
        .menoLivingBackground()
        .navigationBarHidden(true)
    }

    private var masthead: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 14) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").font(.system(size: 22)).foregroundStyle(Meno.sub)
                }
                Spacer()
                NavigationLink { CircleAboutView(circle: circle) } label: {
                    Image(systemName: "info.circle").font(.system(size: 20)).foregroundStyle(Meno.sub)
                }
                NavigationLink { CircleSettingsView(circle: circle) } label: {
                    Image(systemName: "slider.horizontal.3").font(.system(size: 20)).foregroundStyle(Meno.sub)
                }
            }
            .padding(.bottom, 12)
            Text(circle.name).font(.serif(26)).foregroundStyle(Meno.ink)
            Text(circle.tagline).font(.sans(14)).foregroundStyle(Meno.subtle)
                .padding(.top, 4).padding(.bottom, 12)
            HStack(spacing: 9) {
                AvatarStack(people: preview, ring: Meno.surfaceAlt)
                Text(circle.memberLine).font(.sans(13, .semibold)).foregroundStyle(Meno.subtle)
            }
        }
        .padding(.horizontal, 22).padding(.top, 2).padding(.bottom, 16)
        .background(
            LinearGradient(colors: [Meno.clay.opacity(0.16), Meno.sage.opacity(0.14)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
        )
    }

    private var welcomeBanner: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "bookmark.fill").font(.system(size: 15)).foregroundStyle(Meno.sage)
                .padding(.top, 2)
            (Text("Welcome. ").font(.sans(14.5, .bold))
             + Text("What\u{2019}s said here stays here. Be as honest as you need to be.").font(.sans(14.5)))
                .foregroundStyle(Meno.bodyText).lineSpacing(3)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Meno.sage.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var composer: some View {
        HStack {
            Text("Share with this circle\u{2026}").font(.sans(15)).foregroundStyle(Meno.muted)
            Spacer()
        }
        .padding(.horizontal, 16).frame(height: 46)
        .background(Meno.base)
        .overlay(Capsule().stroke(Meno.border, lineWidth: 1.5))
        .clipShape(Capsule())
        .padding(.horizontal, 18).padding(.top, 12).padding(.bottom, 14)
        .frame(maxWidth: .infinity)
        .background(Meno.surface)
        .overlay(Rectangle().fill(Meno.hairline).frame(height: 1), alignment: .top)
    }
}

/// One post inside a circle home.
struct CirclePostCard: View {
    let post: CirclePost
    var body: some View {
        MenoCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    Avatar(initial: post.initial, tone: post.tone, size: 36)
                    VStack(alignment: .leading, spacing: 1) {
                        Text(post.author).font(.sans(15, .bold)).foregroundStyle(Meno.ink)
                        Text(post.time).font(.sans(12.5)).foregroundStyle(Meno.muted)
                    }
                    Spacer()
                }
                Text(post.body).font(.sans(16)).foregroundStyle(Meno.ink).lineSpacing(4)
            }
        }
    }
}

#Preview {
    NavigationStack { CircleHomeView(circle: MenoStore().circles[0]) }
        .environmentObject(MenoStore())
}
