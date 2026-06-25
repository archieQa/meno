import SwiftUI

@main
struct MenoApp: App {
    @StateObject private var store = MenoStore()
    var body: some Scene {
        WindowGroup {
            rootContent
                .environmentObject(store)
                .tint(Meno.clay)
                .preferredColorScheme(store.settings.theme.colorScheme)
        }
    }

    // Optional dev/QA override: launch a single screen directly via the
    // MENO_SCREEN env var (e.g. "feed"). Defaults to the onboarding gate.
    @ViewBuilder private var rootContent: some View {
        switch ProcessInfo.processInfo.environment["MENO_SCREEN"] {
        // Zone A
        case "onboarding":    OnboardingFlow()
        // Zone B
        case "feed":          TodayFeedView()
        case "composer":      PostComposerView()
        case "postdetail":    NavigationStack { PostDetailView(postID: store.posts[0].id) }
        case "savedfeed":     NavigationStack { SavedReflectedView() }
        // Zone C
        case "checkin":       CheckInView()
        case "reflection":    ReflectionView()
        case "checkinhistory":NavigationStack { CheckInHistoryView() }
        // Zone D
        case "circles":       CirclesView()
        case "discover":      NavigationStack { DiscoverCirclesView() }
        case "circlehome":    NavigationStack { CircleHomeView(circle: store.circles[0]) }
        case "createcircle":  NavigationStack { CreateCircleView() }
        // Zone E
        case "grow":          GrowView()
        case "wisdom":        NavigationStack { WisdomCategoryView(category: store.wisdomCategories[0]) }
        case "sharewisdom":   ShareWisdomView()
        case "challenge":     NavigationStack { ChallengeDetailView(challenge: store.challenges[0]) }
        // Zone F
        case "market":        MarketView()
        case "collection":    NavigationStack { CollectionView(collection: store.collections[0]) }
        case "product":       NavigationStack { ProductDetailView(product: store.collections[0].products[3]) }
        case "yourlist":      NavigationStack { YourListView() }
        case "wishlist":      NavigationStack { WishlistView() }
        case "recommend":     RecommendProductView()
        // Zone G
        case "profile":       NavigationStack { ProfileView() }
        case "edit":          EditProfileView()
        case "public":        NavigationStack { PublicProfileView(person: store.mentor) }
        case "journey":       NavigationStack { MyJourneyView() }
        case "contributions": NavigationStack { MyContributionsView() }
        case "saved":         NavigationStack { SavedItemsView() }
        case "search":        NavigationStack { SearchView() }
        case "notifications": NavigationStack { NotificationsView() }
        // Zone I — settings & trust
        case "settings":      NavigationStack { SettingsView() }
        case "account":       NavigationStack { AccountSettingsView() }
        case "privacy":       NavigationStack { PrivacyDataView() }
        case "anonymity":     NavigationStack { AnonymitySettingsView() }
        case "blocked":       NavigationStack { BlockedUsersView() }
        case "notifsettings": NavigationStack { NotificationSettingsView() }
        case "appearance":    NavigationStack { AppearanceSettingsView() }
        case "help":          NavigationStack { HelpSupportView() }
        case "guidelines":    NavigationStack { CommunityGuidelinesView() }
        case "safety":        NavigationStack { SafetyReportView() }
        case "crisis":        NavigationStack { CrisisSupportView() }
        case "about":         NavigationStack { AboutMenoView() }
        case "dataexport":    NavigationStack { DataExportView() }
        // System states
        case "loading":       LoadingStateView()
        case "error":         ErrorStateView()
        case "offline":       OfflineStateView()
        case "empty":         EmptyStateView(actionTitle: "Explore")
        default:              RootGate()
        }
    }
}

/// Gates the app on onboarding: Zone A runs until the woman arrives, then RootView.
/// Once onboarded, a brief loading state covers the initial data load.
struct RootGate: View {
    @EnvironmentObject var store: MenoStore
    @AppStorage("meno.onboarded") private var onboarded = false
    var body: some View {
        if onboarded {
            if store.isLoading {
                LoadingStateView()
                    .task { await store.bootstrap() }
            } else {
                RootView()
            }
        } else {
            OnboardingFlow { onboarded = true }
        }
    }
}
