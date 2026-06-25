import XCTest

/// Targeted navigation tests: real button taps through the primary surfaces,
/// asserting the destination actually renders.
final class MenoNavigationUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    // MARK: Tab bar — all five tabs route to their screen

    func testTabBarNavigatesAllFiveTabs() {
        let app = Meno.launchAppOnboarded()

        // RootGate runs a brief loading state, then RootView with the tab bar.
        XCTAssertTrue(app.buttons["Today"].waitForExistence(timeout: 12),
                      "Tab bar did not appear after onboarding gate")

        // Markers are content reliably visible at the top of each tab root.
        let tabs: [(button: String, marker: String)] = [
            ("Circles",  "Your Circles"),
            ("Grow",     "Wisdom"),
            ("Market",   "What your circle swears by"),
            ("Check-in", "How are you, really?"),
            ("Today",    "What did today actually feel like?"),
        ]

        for tab in tabs {
            let button = app.buttons[tab.button]
            XCTAssertTrue(button.waitUntilHittable(), "Tab '\(tab.button)' not tappable")
            button.tap()
            XCTAssertTrue(app.staticTexts[tab.marker].waitForExistence(timeout: 6),
                          "Tapping '\(tab.button)' did not show '\(tab.marker)'")
        }
    }

    // MARK: Today top bar — profile / search / notifications / saved

    func testTodayTopBarEntryPoints() {
        // Each top-bar entry pushes onto the feed's own NavigationStack. Assert the
        // destination actually rendered (its own distinctive content).
        let entries: [(id: String, marker: String, isTextField: Bool)] = [
            ("feedProfile",       "Edit profile",                 false),
            ("feedSearch",        "Search Meno",                  true),
            ("feedNotifications", "Notifications",                false),
            ("feedSaved",         "Words you wanted to hold onto.", false),
        ]

        for entry in entries {
            let app = Meno.launchScreen("feed")
            let button = app.buttons[entry.id]
            XCTAssertTrue(button.waitUntilHittable(), "Top-bar entry '\(entry.id)' not tappable")
            button.tap()

            let destination = entry.isTextField
                ? app.textFields[entry.marker]
                : app.staticTexts[entry.marker]
            XCTAssertTrue(destination.waitForExistence(timeout: 6),
                          "'\(entry.id)' did not navigate to a screen showing '\(entry.marker)'")
            app.terminate()
        }
    }

    // MARK: Settings tree — push each sub-screen and pop back

    func testSettingsTreeNavigation() {
        let app = Meno.launchScreen("settings")
        XCTAssertTrue(app.staticTexts["Settings"].waitForExistence(timeout: 8),
                      "Settings home did not render")

        let rows = ["Account", "Privacy & Data", "Anonymity", "Blocked users",
                    "Notifications", "Appearance & Accessibility", "Help & Support",
                    "Community Guidelines", "Safety & Report", "About Meno"]

        for row in rows {
            let rowButton = app.buttons[row]
            XCTAssertTrue(rowButton.waitUntilHittable(), "Settings row '\(row)' not tappable")
            rowButton.tap()

            let back = app.buttons["backButton"]
            XCTAssertTrue(back.waitForExistence(timeout: 6),
                          "Settings row '\(row)' did not push a screen with a back button")
            back.tap()
            XCTAssertTrue(app.buttons["Account"].waitForExistence(timeout: 6),
                          "Did not return to Settings home after '\(row)'")
        }
    }

    // MARK: Onboarding shows on a clean (not-onboarded) launch

    func testOnboardingAppearsOnFirstLaunch() {
        let app = XCUIApplication()
        app.launchArguments = ["-meno.onboarded", "NO"]
        app.launch()
        // Onboarding renders some text and the tab bar is NOT present yet.
        XCTAssertTrue(app.staticTexts.firstMatch.waitForExistence(timeout: 8),
                      "Onboarding did not render any content")
        XCTAssertFalse(app.buttons["Market"].exists,
                       "Tab bar should not be visible during onboarding")
    }
}
