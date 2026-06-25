import Foundation
import SwiftUI

// MARK: - Domain models for Zone G (Me & System)

struct UserProfile: Identifiable {
    let id = UUID()
    var displayName: String
    var initial: String
    var stage: String          // "Perimenopause"
    var here: String           // "here 4 months"
    var bio: String
    var tone: AvatarTone
    var posts: Int
    var circles: Int
    var checkIns: Int
}

struct PublicProfile: Identifiable {
    let id = UUID()
    let initial: String
    let name: String
    let tagline: String
    let badges: [String]
    let recentlyShared: String
    let tone: AvatarTone
}

struct JourneyEvent: Identifiable {
    enum Tone { case clay, sage, sand }
    let id = UUID()
    let when: String
    let title: String
    let detail: String?
    let tone: Tone
}

struct Contribution: Identifiable {
    enum Kind: String, CaseIterable { case posts = "Posts", wisdom = "Wisdom", reviews = "Reviews" }
    let id = UUID()
    let kind: Kind
    let body: String
    let meta: String
}

struct SavedItem: Identifiable {
    enum Kind: String, CaseIterable { case all = "All", post = "Posts", wisdom = "Wisdom", product = "Products" }
    let id = UUID()
    let kind: Kind
    let tag: String           // "WISDOM" / "PRODUCT"
    let title: String
}

struct SearchResult: Identifiable {
    enum Group { case wisdom, product }
    let id = UUID()
    let group: Group
    let title: String
    let meta: String
}

struct MenoNotification: Identifiable {
    enum Bucket: String { case today = "Today", earlier = "Earlier" }
    enum Glyph { case person(String, AvatarTone), checkin }
    let id = UUID()
    let bucket: Bucket
    let glyph: Glyph
    let text: String          // markdown — **name** is bolded
    let time: String
}

// MARK: - Zone I (Settings & Trust)

/// Something the learning engine inferred about her — shown in plain language,
/// always editable or removable. Trust is only real when it's reversible.
struct LearnedInsight: Identifiable {
    let id = UUID()
    var text: String
}

/// A person she's blocked. They're never told; they simply can't reach her.
struct BlockedUser: Identifiable {
    let id = UUID()
    let name: String
}

/// How she appears in each part of Meno. Her real name is never shown anywhere.
enum AnonymityContext: String, CaseIterable, Identifiable {
    case feed = "In the Today feed"
    case circles = "In my circles"
    case wisdom = "On wisdom tips"
    var id: String { rawValue }
}

/// Warm theme options for Appearance.
enum AppTheme: String, CaseIterable, Identifiable {
    case warm = "Warm (default)", quiet = "Quiet", system = "Match system"
    var id: String { rawValue }

    /// Drives `.preferredColorScheme`. Warm forces the light palette, Quiet
    /// forces the warm-dark palette, Match system follows the device.
    var colorScheme: ColorScheme? {
        switch self {
        case .warm:   return .light
        case .quiet:  return .dark
        case .system: return nil
        }
    }
}

/// All user-controllable settings. A value type so SwiftUI bindings
/// (`$store.settings.notifyReplies`) drive the toggles directly; swap the
/// whole struct for a synced record when the backend lands.
struct AppSettings {
    // Account
    var email: String = "anna@email.com"
    var phone: String? = nil
    var connectedLogin: String = "Apple"

    // Privacy & data
    var keepDataSeparate: Bool = true
    var personalization: Bool = true

    // Anonymity
    var postAnonymouslyByDefault: Bool = true
    var anonymityFeed: String = "Anonymous"
    var anonymityCircles: String = "As Anna"
    var anonymityWisdom: String = "As Anna"

    // Notifications
    var notifyReplies: Bool = true
    var notifyCircles: Bool = true
    var notifyCheckIn: Bool = true
    var notifyWiderFeed: Bool = false
    var quietHours: Bool = true
    var quietFrom: String = "10pm"
    var quietTo: String = "7am"

    // Appearance & accessibility
    var textScale: Double = 0.62      // 0…1 along the slider
    var higherContrast: Bool = false
    var reduceMotion: Bool = true
    var theme: AppTheme = .warm
}

// MARK: - Zone B (Today / Feed)

/// A single support reaction on a post — a feeling, not a like.
struct Reaction: Identifiable, Hashable {
    let id = UUID()
    let label: String         // "been there", "holding you", "me too"…
    var count: Int
    var mine: Bool = false
}

/// A warm reply under a post. Author may be anonymous.
struct Reply: Identifiable {
    let id = UUID()
    let author: String
    let initial: String
    let tone: AvatarTone
    let anonymous: Bool
    let body: String
}

/// A feed post from a circle member (named or anonymous).
struct FeedPost: Identifiable {
    let id = UUID()
    let author: String
    let initial: String
    let tone: AvatarTone
    let anonymous: Bool
    let time: String          // "2h ago"
    let circle: String?       // "Working Through It" — nil when none
    let body: String
    var reactions: [Reaction]
    var replies: [Reply]
    var saved: Bool = false
}

// MARK: - Zone C (Check-in & Reflection)

/// One-word emotional state, colour-coded. Body never an audit.
enum Mood: String, CaseIterable, Identifiable {
    case heavy = "Heavy", tender = "Tender", steady = "Steady"
    case bright = "Bright", wired = "Wired", foggy = "Foggy"
    var id: String { rawValue }
    var hex: String {
        switch self {
        case .heavy:  return "6E6A86"
        case .tender: return "C49C86"
        case .steady: return "7E8B6F"
        case .bright: return "D7A24B"
        case .wired:  return "C46A52"
        case .foggy:  return "A7B0B8"
        }
    }
}

/// A logged daily check-in. No scores, no streaks.
struct CheckIn: Identifiable {
    let id = UUID()
    let day: String           // "Today", "Yesterday", "Sunday"…
    let mood: Mood
    let note: String?
}

/// A post a member chose to hold onto (Saved & Reflected).
struct SavedQuote: Identifiable {
    let id = UUID()
    let author: String
    let initial: String
    let tone: AvatarTone
    let body: String
}

// MARK: - Zone D (Circles)
// Named MenoCircle to avoid colliding with SwiftUI's Circle shape.

/// A person inside a circle. May choose to stay anonymous.
struct CircleMember: Identifiable {
    let id = UUID()
    let name: String
    let initial: String
    let tone: AvatarTone
    let here: String           // "Host \u{00B7} here 8 months" / "here 5 months"
    var anonymous: Bool = false
}

/// A short post shared inside a circle home.
struct CirclePost: Identifiable {
    let id = UUID()
    let author: String
    let initial: String
    let tone: AvatarTone
    let time: String
    let body: String
}

/// One of the woman's small, private rooms.
struct MenoCircle: Identifiable {
    let id = UUID()
    let name: String
    let tagline: String        // "For women holding down a career mid-transition"
    let memberCount: Int
    let status: String         // "3 new today" / "Quiet today"
    let isLively: Bool         // clay-tinted "active" card on My Circles
    let memberLine: String     // "24 members" / "31 members \u{00B7} post-menopause"
    let about: String          // longer blurb on the About screen
    let guidelines: [String]   // "What's shared here stays here." …
    let members: [CircleMember]
    let posts: [CirclePost]
}

/// A circle surfaced on the Discover screen (not yet joined).
struct DiscoverCircle: Identifiable {
    let id = UUID()
    let name: String
    let blurb: String          // "Brain fog & focus \u{00B7} 19 women"
    let tone: AvatarTone       // tint for the rounded-square mark
}

// MARK: - Zone E (Grow)

/// A reply on a wisdom thread.
struct WisdomReply: Identifiable {
    let id = UUID()
    let author: String
    let initial: String
    let tone: AvatarTone
    let body: String
}

/// One woman-tested tip inside a wisdom category.
struct WisdomTip: Identifiable {
    let id = UUID()
    let title: String
    let author: String         // "Maggie" / "Anonymous"
    let triedCount: Int
    let stage: String?         // "post-menopause"
    let body: String           // full text on the detail screen
    var replies: [WisdomReply] = []
}

/// A wisdom library category (Sleep, Cooling down, …).
struct WisdomCategory: Identifiable {
    let id = UUID()
    let name: String
    let tone: AvatarTone       // card tint
    let tips: [WisdomTip]
}

/// A gentle, opt-in collective challenge. No streaks, no guilt.
struct Challenge: Identifiable {
    let id = UUID()
    let title: String
    let blurb: String
    let participants: Int
    var joined: Bool
    let totalDays: Int
    let currentDay: Int        // nights completed so far
    let detail: String         // longer copy on the detail screen
    let groupNote: String      // "Phone out of the bedroom finally stuck…"
    let groupNoteBy: String
}

// MARK: - Zone F (Market)

/// A product reviewed by the community. Affiliate model: we link out to buy.
struct Product: Identifiable {
    let id = UUID()
    let name: String
    let price: String          // "\u{00A3}28"
    let shop: String           // "NightCool"
    let triedCount: Int
    let tone: AvatarTone       // thumbnail tint
    let blurb: String
    let review: String         // "The only thing that got me through July."
    let reviewBy: String
}

/// A market collection / category card on the Market home.
struct MarketCollection: Identifiable {
    let id = UUID()
    let title: String          // "For the 3am wake-ups"
    let signal: String         // "47 women in your stage tried these"
    let tone: AvatarTone
    let products: [Product]
}

/// A past affiliate hand-off (Order history).
struct Purchase: Identifiable {
    let id = UUID()
    let name: String
    let meta: String           // "Got it June 18 \u{00B7} NightCool"
    let tone: AvatarTone
}
