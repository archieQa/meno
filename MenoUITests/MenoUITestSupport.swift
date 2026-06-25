import XCTest

/// Shared helpers for driving the Meno app from UI tests.
///
/// The app exposes two launch hooks we lean on:
///   • `MENO_SCREEN` (environment) — boots a single screen directly, bypassing
///     the onboarding gate. Handled in `MenoApp.rootContent`.
///   • `-meno.onboarded YES` (launch argument) — lands in the NSUserDefaults
///     argument domain, so `@AppStorage("meno.onboarded")` reads true and the
///     app opens straight into the real tab shell (RootView).
///   • `-meno.theme <raw>` (launch argument) — seeds the persisted appearance
///     theme so we can launch directly into dark ("Quiet") or light ("Warm").
enum Meno {
    /// Launches the full app already past onboarding, into RootView.
    @discardableResult
    static func launchAppOnboarded(theme: String? = nil) -> XCUIApplication {
        let app = XCUIApplication()
        var args = ["-meno.onboarded", "YES"]
        if let theme { args += ["-meno.theme", theme] }
        app.launchArguments = args
        app.launch()
        return app
    }

    /// Launches the app directly into a single screen via `MENO_SCREEN`.
    @discardableResult
    static func launchScreen(_ key: String) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchEnvironment["MENO_SCREEN"] = key
        app.launch()
        return app
    }
}

extension XCUIElement {
    @discardableResult
    func waitUntilHittable(timeout: TimeInterval = 8) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            if exists && isHittable { return true }
            usleep(100_000)
        }
        return false
    }
}
