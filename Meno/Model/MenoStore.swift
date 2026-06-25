import SwiftUI

/// In-memory store seeded with the sample content shown in the Zone G design.
/// Swap these arrays for a real backend / persistence layer later.
@MainActor
final class MenoStore: ObservableObject {
    @Published var profile = UserProfile(
        displayName: "Anna",
        initial: "A",
        stage: "Perimenopause",
        here: "here 4 months",
        bio: "Learning to be gentler with myself.",
        tone: .clay,
        posts: 18, circles: 3, checkIns: 112
    )

    let mentor = PublicProfile(
        initial: "M",
        name: "Marguerite",
        tagline: "\u{201C}Three years ahead, happy to share the map.\u{201D}",
        badges: ["Working Through It \u{00B7} host"],
        recentlyShared: "\u{201C}Took a personal day that was really a cry-and-nap day. Recommend.\u{201D}",
        tone: .sage
    )

    let journey: [JourneyEvent] = [
        .init(when: "This week", title: "Joined \u{201C}7 nights of better sleep\u{201D}", detail: nil, tone: .clay),
        .init(when: "Last month", title: "100th check-in",
              detail: "\u{201C}Bright\u{201D} days are slowly outnumbering the \u{201C}Heavy\u{201D} ones.", tone: .sage),
        .init(when: "4 months ago", title: "Found your first circle", detail: nil, tone: .sand)
    ]

    let contributions: [Contribution] = [
        .init(kind: .posts, body: "First full night's sleep in months. Nearly cried over the coffee machine.",
              meta: "2 days ago \u{00B7} 14 reactions"),
        .init(kind: .posts, body: "Anyone else's memory just\u{2026} buffering lately?",
              meta: "1 week ago \u{00B7} 31 reactions"),
        .init(kind: .wisdom, body: "The \u{201C}two lists\u{201D} trick for a racing 3am mind.",
              meta: "Shared in Grow \u{00B7} 207 women tried this"),
        .init(kind: .reviews, body: "Cooling pillowcase \u{2014} actually let me sleep on the bad nights.",
              meta: "Market review \u{00B7} 47 found helpful")
    ]

    let saved: [SavedItem] = [
        .init(kind: .wisdom, tag: "WISDOM", title: "The \u{201C}two lists\u{201D} trick for a racing 3am mind"),
        .init(kind: .product, tag: "PRODUCT", title: "Cooling pillowcase \u{00B7} \u{00A3}28")
    ]

    let searchSuggestions = ["night sweats", "brain fog at work", "HRT", "joint aches", "feeling invisible"]

    let searchResults: [SearchResult] = [
        .init(group: .wisdom, title: "Cool sheets & a fan I can reach", meta: "207 women tried this"),
        .init(group: .product, title: "Cooling pillowcase", meta: "47 tried \u{00B7} \u{00A3}28")
    ]

    let notifications: [MenoNotification] = [
        .init(bucket: .today, glyph: .person("P", .sage),
              text: "**Priya** held you close on your post about work.", time: "2h ago"),
        .init(bucket: .today, glyph: .checkin,
              text: "A gentle nudge \u{2014} how did today feel?", time: "5h ago"),
        .init(bucket: .earlier, glyph: .person("Y", .plum),
              text: "**Yuki** replied in Working Through It.", time: "Yesterday")
    ]

    // MARK: Zone B — feed (mutable: react, save, post)

    @Published var posts: [FeedPost] = [
        FeedPost(
            author: "Marguerite", initial: "M", tone: .sage, anonymous: false,
            time: "2h ago", circle: "Working Through It",
            body: "Walked out of a meeting today because I couldn\u{2019}t find the word I needed. Just stood in the corridor. Anyone else?",
            reactions: [
                .init(label: "been there", count: 18, mine: true),
                .init(label: "holding you", count: 7),
                .init(label: "me too", count: 11)
            ],
            replies: [
                .init(author: "Yuki", initial: "Y", tone: .clay, anonymous: false,
                      body: "Every single week. You\u{2019}re so far from alone in this."),
                .init(author: "Anonymous", initial: "", tone: .neutral, anonymous: true,
                      body: "I keep a little notebook now. It helped more than I expected.")
            ]
        ),
        FeedPost(
            author: "Anonymous", initial: "", tone: .neutral, anonymous: true,
            time: "Posted anonymously \u{00B7} 5h", circle: nil,
            body: "Does anyone else feel invisible at work lately? Needed to say it somewhere safe.",
            reactions: [
                .init(label: "I feel this", count: 42),
                .init(label: "holding you", count: 26)
            ],
            replies: []
        )
    ]

    /// The four feelings offered in the support-reactions sheet.
    let reactionPalette: [(label: String, tone: AvatarTone)] = [
        ("been there", .clay), ("holding you", .sage), ("me too", .plum), ("sending warmth", .clay)
    ]

    let savedQuotes: [SavedQuote] = [
        .init(author: "Yuki", initial: "Y", tone: .clay,
              body: "Grateful for this chapter, honestly. My daughter and I talked for two hours."),
        .init(author: "Devi", initial: "D", tone: .sage,
              body: "A cool pillow and a fan I can reach without getting up. Small mercies.")
    ]

    func toggleReaction(postID: UUID, reactionID: UUID) {
        guard let p = posts.firstIndex(where: { $0.id == postID }),
              let r = posts[p].reactions.firstIndex(where: { $0.id == reactionID }) else { return }
        let mine = posts[p].reactions[r].mine
        posts[p].reactions[r].mine = !mine
        posts[p].reactions[r].count += mine ? -1 : 1
    }

    func addPost(body: String, anonymous: Bool, circle: String?) {
        let post = FeedPost(
            author: anonymous ? "Anonymous" : profile.displayName,
            initial: anonymous ? "" : profile.initial,
            tone: anonymous ? .neutral : profile.tone,
            anonymous: anonymous,
            time: anonymous ? "Posted anonymously \u{00B7} now" : "now",
            circle: circle, body: body, reactions: [], replies: []
        )
        posts.insert(post, at: 0)
    }

    func addReply(postID: UUID, body: String) {
        guard let p = posts.firstIndex(where: { $0.id == postID }) else { return }
        posts[p].replies.append(
            .init(author: profile.displayName, initial: profile.initial,
                  tone: profile.tone, anonymous: false, body: body)
        )
    }

    // MARK: Zone C — check-in & reflection (mutable)

    @Published var todayMood: Mood? = .tender

    @Published var checkInLog: [CheckIn] = [
        .init(day: "Today", mood: .tender, note: nil),
        .init(day: "Yesterday", mood: .steady, note: nil),
        .init(day: "Sunday", mood: .heavy, note: "Rough night"),
        .init(day: "Saturday", mood: .bright, note: nil)
    ]

    func logCheckIn(mood: Mood, note: String?) {
        todayMood = mood
        let trimmed = note?.trimmingCharacters(in: .whitespacesAndNewlines)
        let entry = CheckIn(day: "Today", mood: mood, note: (trimmed?.isEmpty == false) ? trimmed : nil)
        if let i = checkInLog.firstIndex(where: { $0.day == "Today" }) {
            checkInLog[i] = entry
        } else {
            checkInLog.insert(entry, at: 0)
        }
    }

    // MARK: Zone D — circles

    @Published var circles: [MenoCircle] = [
        MenoCircle(
            name: "Working Through It",
            tagline: "For women holding down a career mid-transition",
            memberCount: 24,
            status: "3 new today", isLively: true,
            memberLine: "24 members",
            about: "A circle for women holding down a career while everything shifts. We talk shop, boundaries, brain fog, and quiet wins.",
            guidelines: ["What\u{2019}s shared here stays here.",
                         "No advice unless it\u{2019}s asked for.",
                         "Anonymity is always respected."],
            members: [
                .init(name: "Marguerite", initial: "M", tone: .sage, here: "Host \u{00B7} here 8 months"),
                .init(name: "Priya", initial: "P", tone: .clay, here: "here 5 months"),
                .init(name: "Anonymous member", initial: "", tone: .neutral, here: "prefers to stay private", anonymous: true),
                .init(name: "Devi", initial: "D", tone: .plum, here: "here 2 months")
            ],
            posts: [
                .init(author: "Priya", initial: "P", tone: .sage, time: "1h ago",
                      body: "Took a \u{201C}personal day\u{201D} that was really just a cry-and-nap day. Recommend."),
                .init(author: "Devi", initial: "D", tone: .clay, time: "3h ago",
                      body: "Asked for the meeting notes in writing from now on. Tiny boundary, big relief.")
            ]
        ),
        MenoCircle(
            name: "Warm Evenings",
            tagline: "Slow, quiet company for the post-menopause years",
            memberCount: 31,
            status: "Quiet today", isLively: false,
            memberLine: "31 members \u{00B7} post-menopause",
            about: "A gentler, slower circle for women who are mostly through it and want easy company in the evenings.",
            guidelines: ["What\u{2019}s shared here stays here.",
                         "Come as you are, however the day went.",
                         "Anonymity is always respected."],
            members: [
                .init(name: "Eleanor", initial: "E", tone: .plum, here: "Host \u{00B7} here 1 year"),
                .init(name: "Joan", initial: "J", tone: .sage, here: "here 7 months")
            ],
            posts: [
                .init(author: "Eleanor", initial: "E", tone: .plum, time: "Yesterday",
                      body: "The other side really is calmer. It does come. Holding the door open for you all.")
            ]
        )
    ]

    func leaveCircle(_ id: UUID) {
        circles.removeAll { $0.id == id }
    }

    let discoverCircles: [DiscoverCircle] = [
        .init(name: "Foggy Days", blurb: "Brain fog & focus \u{00B7} 19 women", tone: .clay),
        .init(name: "Just Diagnosed", blurb: "Newly navigating \u{00B7} 12 women", tone: .sage),
        .init(name: "Still Dating", blurb: "Intimacy & identity \u{00B7} 15 women", tone: .plum)
    ]

    // MARK: Zone E — grow (wisdom + challenges)

    let wisdomCategories: [WisdomCategory] = [
        WisdomCategory(name: "Sleep", tone: .plum, tips: [
            .init(title: "How I survived hot flashes at my daughter\u{2019}s wedding",
                  author: "Maggie", triedCount: 312, stage: "post-menopause",
                  body: "A thin silk slip under the dress, a tiny battery fan in my clutch, and a glass of iced water I kept topping up. I told my daughter beforehand so I didn\u{2019}t panic about panicking. Honestly? Nobody noticed but me.",
                  replies: [
                    .init(author: "Yuki", initial: "Y", tone: .clay,
                          body: "The clutch fan saved me at a funeral. Zero shame.")
                  ]),
            .init(title: "The \u{201C}two lists\u{201D} trick for a racing 3am mind",
                  author: "Maggie", triedCount: 312, stage: nil,
                  body: "One list for what\u{2019}s actually in my control tomorrow, one for what isn\u{2019}t. The second list I literally close the notebook on. Sounds silly; quiets the spin."),
            .init(title: "Cool sheets & a fan I can reach without standing",
                  author: "Devi", triedCount: 207, stage: nil,
                  body: "Set the fan on the nightstand angled at the pillow, and keep a spare cool pillowcase in the drawer to swap at 3am without fully waking."),
            .init(title: "Magnesium an hour before bed (ask your GP first)",
                  author: "Anonymous", triedCount: 189, stage: nil,
                  body: "Glycinate, an hour before lights out. Check with your GP, especially on other meds \u{2014} but it took the edge off for me.")
        ]),
        WisdomCategory(name: "Cooling down", tone: .clay, tips: [
            .init(title: "A clutch fan in every coat pocket",
                  author: "Priya", triedCount: 142, stage: nil,
                  body: "I bought four little folding fans and stashed one in each bag and coat. Never caught without one now.")
        ]),
        WisdomCategory(name: "Intimacy", tone: .sage, tips: [
            .init(title: "Saying the awkward thing out loud, kindly",
                  author: "Eleanor", triedCount: 96, stage: "post-menopause",
                  body: "Naming what\u{2019}s changed, gently, took the pressure off both of us. It got easier the second time.")
        ]),
        WisdomCategory(name: "Feeling like me", tone: .sand, tips: [
            .init(title: "One thing a day that is just mine",
                  author: "Joan", triedCount: 73, stage: nil,
                  body: "Ten minutes that nobody else gets a say in. A coffee, a walk, a chapter. It adds back up.")
        ])
    ]

    @Published var challenges: [Challenge] = [
        Challenge(title: "7 nights of better sleep",
                  blurb: "A tiny wind-down ritual each night, in good company.",
                  participants: 128, joined: true, totalDays: 7, currentDay: 4,
                  detail: "Each evening, one small wind-down step. Share how it went, or just quietly do it. No streak to break, no guilt if you miss a night.",
                  groupNote: "Phone out of the bedroom finally stuck. Read four pages and was gone.",
                  groupNoteBy: "Priya"),
        Challenge(title: "Move a little, daily",
                  blurb: "Ten minutes, your way. Walk, stretch, dance in the kitchen.",
                  participants: 94, joined: false, totalDays: 7, currentDay: 0,
                  detail: "Ten minutes of movement, however you like it. It counts even on the days it\u{2019}s slow.",
                  groupNote: "Danced to one song while the kettle boiled. Counts.",
                  groupNoteBy: "Devi")
    ]

    func toggleChallenge(_ id: UUID) {
        guard let i = challenges.firstIndex(where: { $0.id == id }) else { return }
        challenges[i].joined.toggle()
    }

    // MARK: Zone F — market (affiliate model A)

    let collections: [MarketCollection] = [
        MarketCollection(title: "For the 3am wake-ups", signal: "47 women in your stage tried these", tone: .clay, products: [
            .init(name: "Silk eye mask", price: "\u{00A3}19", shop: "Hush", triedCount: 34, tone: .clay,
                  blurb: "Blocks the early light without a strap that tugs your hair.",
                  review: "Tiny thing, big difference on the 5am summer mornings.", reviewBy: "Priya"),
            .init(name: "Magnesium balm", price: "\u{00A3}15", shop: "Calm Co.", triedCount: 61, tone: .sage,
                  blurb: "Rubbed into the calves before bed. Ask your GP if you\u{2019}re unsure.",
                  review: "Part of my wind-down now. Calms the restless legs.", reviewBy: "Maggie"),
            .init(name: "Bedside fan", price: "\u{00A3}42", shop: "BreezeAway", triedCount: 88, tone: .plum,
                  blurb: "Quiet enough to sleep through, strong enough to feel.",
                  review: "Reach it without sitting up. That\u{2019}s the whole magic.", reviewBy: "Devi"),
            .init(name: "Cooling pillowcase", price: "\u{00A3}28", shop: "NightCool", triedCount: 47, tone: .sand,
                  blurb: "Stays cool to the touch through the night. Several of us keep one on each side and flip it when the heat comes.",
                  review: "The only thing that got me through July.", reviewBy: "Devi")
        ]),
        MarketCollection(title: "Cooling, for when it hits", signal: "63 women tried these", tone: .plum, products: [
            .init(name: "Clutch fan", price: "\u{00A3}12", shop: "BreezeAway", triedCount: 120, tone: .clay,
                  blurb: "Folds flat into any bag. The one we all reach for.",
                  review: "In every coat pocket. Zero shame.", reviewBy: "Yuki")
        ])
    ]

    /// Saved-to-list ("cart") and wishlist live here. Affiliate: we only ever link out.
    @Published var listedProductIDs: Set<UUID> = []
    @Published var wishlistProductIDs: Set<UUID> = []

    var allProducts: [Product] { collections.flatMap(\.products) }
    var listedProducts: [Product] { allProducts.filter { listedProductIDs.contains($0.id) } }
    var wishlistProducts: [Product] { allProducts.filter { wishlistProductIDs.contains($0.id) } }

    func toggleList(_ id: UUID) {
        if listedProductIDs.contains(id) { listedProductIDs.remove(id) } else { listedProductIDs.insert(id) }
    }
    func toggleWishlist(_ id: UUID) {
        if wishlistProductIDs.contains(id) { wishlistProductIDs.remove(id) } else { wishlistProductIDs.insert(id) }
    }

    let purchases: [Purchase] = [
        .init(name: "Cooling pillowcase", meta: "Got it June 18 \u{00B7} NightCool", tone: .sand),
        .init(name: "Clutch fan", meta: "Got it May 30 \u{00B7} BreezeAway", tone: .clay)
    ]

    // MARK: Zone I — settings & trust (mutable)

    @Published var settings = AppSettings() {
        didSet {
            // Persist the appearance theme so a chosen dark/light mode survives
            // relaunch. The rest of AppSettings stays in-memory until the backend.
            if settings.theme != oldValue.theme {
                UserDefaults.standard.set(settings.theme.rawValue, forKey: Self.themeKey)
            }
        }
    }

    private static let themeKey = "meno.theme"

    init() {
        if let raw = UserDefaults.standard.string(forKey: Self.themeKey),
           let saved = AppTheme(rawValue: raw) {
            settings.theme = saved
        }
    }

    @Published var learnedInsights: [LearnedInsight] = [
        .init(text: "We\u{2019}ve noticed sleep is a theme for you."),
        .init(text: "Evenings tend to feel heavier for you.")
    ]

    @Published var blockedUsers: [BlockedUser] = [
        .init(name: "A member")
    ]

    func removeInsight(_ id: UUID) {
        learnedInsights.removeAll { $0.id == id }
    }

    func unblock(_ id: UUID) {
        blockedUsers.removeAll { $0.id == id }
    }

    /// Resets local state to a signed-out baseline. Real auth teardown lands
    /// with the backend; for now this clears the onboarding gate via the caller.
    func logOut() {
        // No-op on in-memory data; the @AppStorage("meno.onboarded") flag is
        // cleared by RootGate so the next launch returns to Zone A.
    }

    // MARK: System states (loading / error / offline)

    /// Drives the first-launch "Gathering your circle…" state. Flips to false
    /// once seed data is ready; a real fetch will await the network here.
    @Published var isLoading = true

    /// Simulates the initial data load so the loading state is exercised on
    /// launch. Replace the sleep with the real fetch when the backend lands.
    func bootstrap() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 900_000_000)
        isLoading = false
    }
}
