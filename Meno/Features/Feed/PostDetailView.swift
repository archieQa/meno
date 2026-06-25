import SwiftUI

/// Zone B, screen 15 — Post Detail with threaded replies and a warm reply bar.
struct PostDetailView: View {
    @EnvironmentObject var store: MenoStore
    @Environment(\.dismiss) private var dismiss
    let postID: UUID

    @State private var reply = ""
    @State private var showReactions = false

    private var post: FeedPost? { store.posts.first { $0.id == postID } }

    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            HStack(spacing: 14) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").font(.system(size: 22)).foregroundStyle(Meno.faint)
                }
                Text("Post").font(.serif(18)).foregroundStyle(Meno.ink)
                Spacer()
            }
            .padding(.horizontal, 22).padding(.bottom, 12)
            .overlay(Rectangle().fill(Meno.hairline).frame(height: 1), alignment: .bottom)

            if let post {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        PostHeader(post: post).padding(.bottom, 12)
                        Text(post.body).font(.sans(18)).foregroundStyle(Meno.ink).lineSpacing(4).padding(.bottom, 14)

                        FlexWrap(post.reactions, spacing: 8) { r in
                            ReactionPill(reaction: r) { store.toggleReaction(postID: post.id, reactionID: r.id) }
                        }
                        .padding(.bottom, 16)

                        Button { showReactions = true } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "heart")
                                Text("Send her something")
                            }
                            .font(.sans(14, .bold)).foregroundStyle(Meno.clay)
                        }
                        .padding(.bottom, 16)

                        Rectangle().fill(Meno.hairline).frame(height: 1)

                        SectionLabel(text: "\(post.replies.count) replies").padding(.top, 18).padding(.bottom, 14)

                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(post.replies) { r in replyBubble(r) }
                            if post.replies.isEmpty {
                                Text("Be the first to reply with warmth.")
                                    .font(.sans(15)).foregroundStyle(Meno.taupe)
                            }
                        }
                    }
                    .padding(.horizontal, 20).padding(.top, 18).padding(.bottom, 20)
                }

                replyBar(post: post)
            } else {
                Spacer()
                Text("This post is no longer here.").font(.sans(15)).foregroundStyle(Meno.taupe)
                Spacer()
            }
        }
        .background(Meno.base)
        .navigationBarHidden(true)
        .sheet(isPresented: $showReactions) {
            ReactionsSheet { label in
                if let i = store.posts.firstIndex(where: { $0.id == postID }) {
                    if let r = store.posts[i].reactions.firstIndex(where: { $0.label == label }) {
                        store.toggleReaction(postID: postID, reactionID: store.posts[i].reactions[r].id)
                    } else {
                        store.posts[i].reactions.append(Reaction(label: label, count: 1, mine: true))
                    }
                }
                showReactions = false
            }
            .environmentObject(store)
            .presentationDetents([.height(440)])
        }
    }

    private func replyBubble(_ r: Reply) -> some View {
        HStack(alignment: .top, spacing: 11) {
            PostAvatar(anonymous: r.anonymous, initial: r.initial, tone: r.tone, size: 34)
            VStack(alignment: .leading, spacing: 3) {
                Text(r.author).font(.sans(14, .bold))
                    .foregroundStyle(r.anonymous ? Meno.subtle : Meno.ink)
                Text(r.body).font(.sans(15.5)).foregroundStyle(Meno.ink).lineSpacing(2)
            }
            .padding(.horizontal, 14).padding(.vertical, 12)
            .background(Meno.surface)
            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Meno.hairline, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }

    private func replyBar(post: FeedPost) -> some View {
        HStack(spacing: 10) {
            TextField("Reply with warmth\u{2026}", text: $reply)
                .font(.sans(15)).foregroundStyle(Meno.ink)
                .padding(.horizontal, 16).frame(height: 46)
                .background(Meno.base)
                .overlay(Capsule().stroke(Meno.border, lineWidth: 1.5))
                .clipShape(Capsule())
            Button {
                let body = reply.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !body.isEmpty else { return }
                store.addReply(postID: post.id, body: body); reply = ""
            } label: {
                Image(systemName: "arrow.right").font(.system(size: 20, weight: .bold)).foregroundStyle(Meno.surface)
                    .frame(width: 46, height: 46).background(Meno.clay).clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 18).padding(.vertical, 12)
        .background(Meno.surface)
        .overlay(Rectangle().fill(Meno.hairline).frame(height: 1), alignment: .top)
    }
}

/// Zone B, screen 16 — Support Reactions Sheet ("a feeling she'll actually feel").
struct ReactionsSheet: View {
    @EnvironmentObject var store: MenoStore
    var onPick: (String) -> Void = { _ in }

    private func dotColor(_ tone: AvatarTone) -> Color {
        switch tone {
        case .clay: return Meno.clay.opacity(0.25)
        case .sage: return Meno.sage.opacity(0.25)
        case .plum: return Meno.plum.opacity(0.25)
        case .sand: return Meno.gold.opacity(0.25)
        case .neutral: return Color(hex: "D7A24B", opacity: 0.25)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Capsule().fill(Meno.ink.opacity(0.16)).frame(width: 44, height: 5)
                .padding(.top, 14).padding(.bottom, 20)
            VStack(alignment: .leading, spacing: 0) {
                Text("Send her something").font(.serif(23)).foregroundStyle(Meno.ink).padding(.bottom, 6)
                Text("Not a like — a feeling she\u{2019}ll actually feel.")
                    .font(.sans(15)).foregroundStyle(Meno.sub).padding(.bottom, 20)
                VStack(spacing: 11) {
                    ForEach(Array(store.reactionPalette.enumerated()), id: \.offset) { idx, item in
                        let primary = idx == 0
                        Button { onPick(item.label) } label: {
                            HStack(spacing: 14) {
                                Circle().fill(dotColor(item.tone)).frame(width: 36, height: 36)
                                Text(item.label).font(.sans(18, .bold))
                                    .foregroundStyle(primary ? Meno.clay : Meno.ink)
                                Spacer()
                            }
                            .padding(.horizontal, 18).padding(.vertical, 15)
                            .background(primary ? Meno.claySoft : Meno.surface)
                            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(primary ? Meno.clay : Meno.cardBorder, lineWidth: 1.5))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 26)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Meno.base)
    }
}

#Preview {
    NavigationStack { PostDetailView(postID: MenoStore().posts[0].id) }
        .environmentObject(MenoStore())
}
