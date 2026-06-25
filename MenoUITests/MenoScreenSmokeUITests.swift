import XCTest

/// Broad smoke coverage: boot every screen the app can launch directly via
/// `MENO_SCREEN` and assert it renders (reaches the foreground with content)
/// rather than crashing or coming up blank. This exercises all ~40 zones'
/// entry views plus the four system states in one pass.
final class MenoScreenSmokeUITests: XCTestCase {

    /// Every key handled by `MenoApp.rootContent`.
    static let screenKeys = [
        // Zone A
        "onboarding",
        // Zone B
        "feed", "composer", "postdetail", "savedfeed",
        // Zone C
        "checkin", "reflection", "checkinhistory",
        // Zone D
        "circles", "discover", "circlehome", "createcircle",
        // Zone E
        "grow", "wisdom", "sharewisdom", "challenge",
        // Zone F
        "market", "collection", "product", "yourlist", "wishlist", "recommend",
        // Zone G
        "profile", "edit", "public", "journey", "contributions",
        "saved", "search", "notifications",
        // Zone I — settings & trust
        "settings", "account", "privacy", "anonymity", "blocked",
        "notifsettings", "appearance", "help", "guidelines", "safety",
        "crisis", "about", "dataexport",
        // System states
        "loading", "error", "offline", "empty",
    ]

    override func setUp() {
        super.setUp()
        continueAfterFailure = true   // collect every failing screen, not just the first
    }

    func testEveryScreenRenders() {
        for key in Self.screenKeys {
            let app = Meno.launchScreen(key)
            // The view rendered if the app is foregrounded and shows some content.
            let hasContent = app.staticTexts.firstMatch.waitForExistence(timeout: 8)
                || app.images.firstMatch.waitForExistence(timeout: 1)
                || app.buttons.firstMatch.waitForExistence(timeout: 1)
            XCTAssertEqual(app.state, .runningForeground,
                           "Screen '\(key)' is not in the foreground (possible crash)")
            XCTAssertTrue(hasContent, "Screen '\(key)' rendered no visible content")
            app.terminate()
        }
    }

    /// Dark ("Quiet") theme launches and renders the same content — verifies the
    /// dynamic-token + preferredColorScheme wiring doesn't break any view.
    func testDarkThemeLaunches() {
        let app = Meno.launchAppOnboarded(theme: "Quiet")
        XCTAssertTrue(app.buttons["Today"].waitForExistence(timeout: 12),
                      "App did not reach the tab shell under the Quiet (dark) theme")
        XCTAssertTrue(app.staticTexts["What did today actually feel like?"].waitForExistence(timeout: 6),
                      "Feed did not render under the Quiet (dark) theme")
    }
}
