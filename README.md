# Meno — iOS app (Zone G: Profile / Me & System)

A SwiftUI implementation of the **Meno** femtech app, built from the Claude Design
spec `Meno - Zone G Profile.dc.html` and the shared `Meno - Foundations` design system.

Meno is a community-first space for women living through menopause — warm, calm,
mature; no clinical blue, no stereotyped pink. See the product brief in the vault
(`Tech Projects/Meno/meno.md`).

## Run it

```bash
open Meno.xcodeproj      # Xcode 16+ (built & verified on Xcode 26.5)
# Select an iPhone simulator, ⌘R
```

Min iOS 17 · portrait · bundle id `com.luars.meno`.

## What's implemented (Zone G screens 47–55)

| # | Screen | File |
|---|--------|------|
| 47 | Profile (Me) | `ProfileView.swift` |
| 48 | Edit Profile | `EditProfileView.swift` |
| 49 | Public Profile | `PublicProfileView.swift` |
| 50 | My Journey (timeline) | `MyJourneyView.swift` |
| 51 | My Contributions | `MyContributionsView.swift` |
| 52 | Saved Items | `SavedItemsView.swift` |
| 53 / 54 | Global Search (empty + results) | `SearchView.swift` |
| 55 | Notifications | `NotificationsView.swift` |

The app shell (`RootView.swift` + `MenoTabBar.swift`) carries the full 5-tab
bottom navigation with the floating central check-in button. The other four tabs
(Today, Circles, Grow, Market) show gentle placeholders — they belong to Zones B–F,
to be built next. Profile / Search / Notifications are reached from the Today top bar.

## Architecture

- **`Theme.swift`** — design tokens (colors, radii, type) straight from Foundations.
- **`Components.swift`** — reusable `MenoCard`, `Avatar`, `Chip`, buttons, rows, header.
- **`Models.swift` / `MenoStore.swift`** — domain models + an in-memory store seeded
  with the design's sample content. Swap `MenoStore` for a real backend later.
- **Feature views** — one file per screen, all driven by `MenoStore`.

### Notes
- Fonts approximate the brand (Spectral → system serif, Mulish → system sans). Drop the
  real TTFs into the target and update `Font.serif` / `Font.sans` in `Theme.swift` to match exactly.
- `MENO_SCREEN` env var (dev/QA only) launches a single screen directly — e.g.
  `SIMCTL_CHILD_MENO_SCREEN=profile xcrun simctl launch <dev> com.luars.meno`.
