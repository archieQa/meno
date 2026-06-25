import SwiftUI

/// Zone B, screen 13 / 17 — Today Feed (the app's heartbeat) with empty state.
/// Carries the Zone G entry points in its top bar (avatar → Profile, search, bell).
struct TodayFeedView: View {
    @EnvironmentObject var store: MenoStore
    @State private var showComposer = false

    private var greeting: String {
        let h = Calendar.current.component(.hour, from: Date())
        let part = h < 12 ? "morning" : (h < 18 ? "afternoon" : "evening")
        return "Good \(part), \(store.profile.displayName)"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                topBar
                if store.posts.isEmpty {
                    emptyState
                } else {
                    feed
                }
            }
            .menoLivingBackground()
            .navigationBarHidden(true)
            .sheet(isPresented: $showComposer) {
                PostComposerView().environmentObject(store)
            }
        }
    }

    private var topBar: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 14) {
                Text(greeting).font(.serif(24)).foregroundStyle(Meno.ink)
                    .lineLimit(1).minimumScaleFactor(0.7)
                Spacer(minLength: 8)
                NavigationLink { ProfileView() } label: {
                    Avatar(initial: store.profile.initial, tone: store.profile.tone, size: 44)
                }
                .accessibilityIdentifier("feedProfile")
                .accessibilityLabel("Profile")
            }
            HStack(spacing: 0) {
                if let mood = store.todayMood {
                    HStack(spacing: 9) {
                        LivePulseDot(color: Color(hex: mood.hex), size: 9)
                        (Text("Today you felt ").foregroundColor(Meno.sageDark)
                         + Text(mood.rawValue).foregroundColor(Meno.ink))
                            .font(.sans(14, .bold))
                    }
                    .padding(.horizontal, 14).frame(height: 36)
                    .background(Meno.sage.opacity(0.16)).clipShape(Capsule())
                }
                Spacer(minLength: 12)
                HStack(spacing: 20) {
                    NavigationLink { SearchView() } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 19, weight: .semibold)).foregroundStyle(Meno.taupe)
                    }
                    .accessibilityIdentifier("feedSearch")
                    .accessibilityLabel("Search")
                    NavigationLink { NotificationsView() } label: {
                        Image(systemName: "bell")
                            .font(.system(size: 19, weight: .semibold)).foregroundStyle(Meno.taupe)
                    }
                    .accessibilityIdentifier("feedNotifications")
                    .accessibilityLabel("Notifications")
                    NavigationLink { SavedReflectedView() } label: {
                        Image(systemName: "bookmark")
                            .font(.system(size: 19, weight: .semibold)).foregroundStyle(Meno.taupe)
                    }
                    .accessibilityIdentifier("feedSaved")
                    .accessibilityLabel("Saved")
                }
            }
        }
        .padding(.horizontal, 22).padding(.bottom, 12)
        .overlay(Rectangle().fill(Meno.hairline).frame(height: 1), alignment: .bottom)
    }

    private var feed: some View {
        ScrollView {
            VStack(spacing: 14) {
                // Composer prompt
                Button { showComposer = true } label: {
                    HStack(spacing: 12) {
                        Avatar(initial: store.profile.initial, tone: store.profile.tone, size: 42)
                        Text("What did today actually feel like?")
                            .font(.sans(16.5)).foregroundStyle(Meno.muted)
                        Spacer()
                    }
                    .padding(16)
                    .background(Meno.surface)
                    .overlay(RoundedRectangle(cornerRadius: Meno.rCard, style: .continuous).stroke(Meno.cardBorder, lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: Meno.rCard, style: .continuous))
                }
                .buttonStyle(.plain)
                .menoFadeUp(index: 0)

                ForEach(Array(store.posts.enumerated()), id: \.element.id) { i, post in
                    PostCard(post: post)
                        .menoFadeUp(index: i + 1)
                }
            }
            .padding(.horizontal, 18).padding(.top, 16).padding(.bottom, 24)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 0) {
            Spacer()
            ZStack {
                Circle().fill(Meno.sage.opacity(0.16)).frame(width: 120)
                Circle().fill(Meno.clay.opacity(0.30)).frame(width: 54).offset(x: -18, y: -6)
                Circle().fill(Meno.sage.opacity(0.50)).frame(width: 42).offset(x: 22, y: 22)
            }
            .padding(.bottom, 24)
            Text("Your circle is just waking up").font(.serif(27)).foregroundStyle(Meno.ink)
                .multilineTextAlignment(.center).padding(.bottom, 12)
            Text("Be the first to say how today felt. Someone out there needs to read exactly what you\u{2019}re about to write.")
                .font(.sans(16.5)).foregroundStyle(Meno.sub).multilineTextAlignment(.center)
                .lineSpacing(3).frame(maxWidth: 280).padding(.bottom, 26)
            Button { showComposer = true } label: {
                Text("Share something").font(.sans(17, .bold)).foregroundStyle(Meno.surface)
                    .frame(maxWidth: 240).frame(height: 54).background(Meno.clay)
                    .clipShape(RoundedRectangle(cornerRadius: Meno.rButton, style: .continuous))
            }
            .buttonStyle(.plain)
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

/// A single feed post: header + body open the detail; reactions act in place.
struct PostCard: View {
    @EnvironmentObject var store: MenoStore
    let post: FeedPost

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationLink { PostDetailView(postID: post.id) } label: {
                VStack(alignment: .leading, spacing: 12) {
                    PostHeader(post: post)
                    Text(post.body).font(.sans(17)).foregroundStyle(Meno.ink)
                        .lineSpacing(4).multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .buttonStyle(.plain)

            if !post.reactions.isEmpty {
                FlexWrap(post.reactions, spacing: 8) { r in
                    ReactionPill(reaction: r) { store.toggleReaction(postID: post.id, reactionID: r.id) }
                }
                .padding(.top, 14)
            }
        }
        .padding(18)
        .background(Meno.surface)
        .overlay(RoundedRectangle(cornerRadius: Meno.rCard, style: .continuous).stroke(Meno.cardBorder, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: Meno.rCard, style: .continuous))
        .shadow(color: Color(hex: "2E2622", opacity: 0.04), radius: 10, x: 0, y: 2)
    }
}

/// Avatar + name + time, with an optional circle tag.
struct PostHeader: View {
    let post: FeedPost
    var body: some View {
        HStack(spacing: 11) {
            PostAvatar(anonymous: post.anonymous, initial: post.initial, tone: post.tone, size: 40)
            VStack(alignment: .leading, spacing: 1) {
                Text(post.author).font(.sans(16, .bold))
                    .foregroundStyle(post.anonymous ? Meno.subtle : Meno.ink)
                Text(post.time).font(.sans(13)).foregroundStyle(Meno.muted)
            }
            Spacer(minLength: 8)
            if let circle = post.circle {
                Text(circle).font(.sans(12, .bold)).foregroundStyle(Meno.taupe)
                    .padding(.horizontal, 11).padding(.vertical, 5)
                    .background(Meno.ink.opacity(0.05)).clipShape(Capsule())
            }
        }
    }
}

#Preview { TodayFeedView().environmentObject(MenoStore()) }
