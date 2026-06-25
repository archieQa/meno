# Meno — Build Handoff & Roadmap

> Pick-up doc for a fresh chat. Everything needed to continue building the Meno iOS app
> without re-deriving context. **Zone G (Profile) is done and verified;** the rest is a TODO below.

Last updated: 2026-06-23 · App lives at `~/Desktop/Meno` · Built & verified on Xcode 26.5, iPhone 16 Pro simulator.

---

## 1. What Meno is (one breath)

Community-first femtech app for women (45–55) living **through** menopause. Warm, calm,
mature — the opposite of a clinical dashboard and the opposite of a "girly" pink wellness app.
Full product brief + architecture in the vault: `Luars Vault/Tech Projects/Meno/`
(`meno.md`, `MenoArchitecture.md`, `MenoDeepResearch.md`).

Guiding constraints for every screen:
- No clinical blue, no stereotyped hot-pink. Warm cream + terracotta + sage.
- **Body text never below 16pt.** Generous tap targets, high contrast (audience is 45–55).
- Feed-first, emotional-first, privacy/anonymity visible and reassuring.
- Community at the center; tracking is quiet and never the landing surface.

---

## 2. How to run

```bash
open ~/Desktop/Meno/Meno.xcodeproj    # Xcode 16+
# pick an iPhone simulator → ⌘R
```

Min iOS 17 · portrait · bundle id `com.luars.meno`.

Dev shortcut to jump straight to one screen (QA only):
```bash
DEV=$(xcrun simctl list devices booted | grep -oE "[0-9A-F-]{36}" | head -1)
SIMCTL_CHILD_MENO_SCREEN=profile xcrun simctl launch "$DEV" com.luars.meno
# Zone A: onboarding
# Zone B: feed · composer · postdetail · savedfeed
# Zone C: checkin · reflection · checkinhistory
# Zone D: circles · discover · circlehome · createcircle
# Zone E: grow · wisdom · sharewisdom · challenge
# Zone F: market · collection · product · yourlist · wishlist · recommend
# Zone G: profile · edit · public · journey · contributions · saved · search · notifications
# Zone I: settings · account · privacy · anonymity · blocked · notifsettings · appearance · help · guidelines · safety · crisis · about · dataexport
# States: loading · error · offline · empty
```

---

## 3. The design source (Claude Design)

Project "Claude Design direction", owner **Lurch**, projectId
`ac947150-1b15-434c-b668-9a41f9a90190`.

Fetch any design file in a new chat with the `claude_design` connector (DesignSync tool),
method `get_file`, the projectId above, and one of these paths:

| Design file | Covers | Built? |
|---|---|---|
| `Meno - Foundations.dc.html` | Colors, type, buttons, chips, cards, nav | ✅ tokens ported |
| `Meno - Zone A Onboarding.dc.html` | Welcome → matching | ✅ **done** |
| `Meno - Zone B Feed.dc.html` | Today feed, composer, post detail | ✅ **done** |
| `Meno - Zone C Checkin.dc.html` | Daily check-in, reflection | ✅ **done** |
| `Meno - Zone D Circles.dc.html` | Circles | ✅ **done** |
| `Meno - Zone E Grow.dc.html` | Wisdom + challenges | ✅ **done** |
| `Meno - Zone F Market.dc.html` | Market | ✅ **done** |
| `Meno - Zone G Profile.dc.html` | Profile / Search / Notifications (47–55) | ✅ **done** |
| `Meno - Zone I Settings.dc.html` | Settings, privacy, anonymity, help (56–70 + states) | ✅ **done** |
| `Meno.dc.html` | Overview / index | n/a |

> Design files use their **own sequential screen numbers** (Zone G = 47–55). The vault
> `MenoArchitecture.md` uses a separate 1–43 inventory. Mapping is noted per zone in §6.

---

## 4. Design system (already implemented in `Theme.swift` — reuse, don't reinvent)

**Colors**
| Token | Hex | Use |
|---|---|---|
| `Meno.base` | `#FAF6F0` | app background (cream) |
| `Meno.surface` | `#FFFCF7` | cards, inputs |
| `Meno.clay` / `clayDark` | `#C46A52` / `#A2503C` | primary / pressed |
| `Meno.claySoft` | `#C46A52` @12% | clay tint fills |
| `Meno.sage` / `sageDark` | `#7E8B6F` / `#5C6650` | secondary / sage avatars |
| `Meno.plum` / `plumDark` | `#7E6B8F` / `#574766` | plum avatars |
| `Meno.ink` | `#2E2622` | primary text |
| `Meno.sub` / `taupe` / `muted` / `faint` | `#5E544C` / `#8A7D72` / `#9C9087` / `#B3A99F` | text greys, chevrons |
| `Meno.navIdle` | `#A99E90` | inactive tab |
| `Meno.hairline` / `border` / `cardBorder` | ink @7% / @14% / @9% | dividers, strokes |

**Radii:** card 20 · button 15 · field 14 · pill = capsule.

**Type:** `Font.serif(size, weight)` (Spectral → system serif; headings) and
`Font.sans(size, weight)` (Mulish → system sans; UI/body). Brand TTFs not bundled yet —
to make exact, add Spectral + Mulish to the target and update those two helpers in `Theme.swift`.

**Living motion layer (`DesignSystem/LivingAnimations.swift`)** — from the
`Meno Zone animations` Claude Design project (projectId
`eac324d9-c496-4ee5-831b-50f9527d6bff`, file `Meno - Living Prototype.dc.html`).
All reusable, all Reduce-Motion aware:
- `AmbientField` — three drifting blurred blobs (clay/sage/gold) behind every
  screen. Use via `.menoLivingBackground(accent:)` (cream) or
  `.menoImmersiveBackground(accent:)` (warm radial wash, for meditative screens).
- `BreathingOrb(accent:size:)` — swelling gradient sphere with glow + ripple
  rings; the heart of Check-in / Reflection / onboarding splash.
- `BreathGuide` — cycles "Breathe in / Hold / Breathe out / Rest" on a 12s loop.
- `LivePulseDot`, `ShimmerGlow` — small presence/aliveness accents.
- Entrances: `.menoScreenIn()` (tab roots), `.menoDeepIn()` (pushed detail),
  `.menoFadeUp(index:)` (staggered cards). Press feedback: `MenoPress` button
  style (already wired into Primary/Secondary buttons, ReactionPill, tab bar).
- Immersive bg tokens (`Meno.immersiveTop/Core/Edge`) live in `Theme.swift`.

**Reusable components in `Components.swift`:**
`MenoCard`, `Avatar(initial:tone:size:)` (tones: clay/sage/plum/neutral), `Chip(title:selected:)`,
`SectionLabel`, `PrimaryButton`, `SecondaryButton`, `DisclosureRow`, `MenoHeader(title:onBack:)`.
Bottom nav: `MenoTabBar` + `MenoTab` enum in `MenoTabBar.swift`.

---

## 5. Conventions (follow these for new screens)

- **One file per screen**, named `<Screen>View.swift`, organized into folders under `Meno/`:
  `App/` (entry, root, tab bar) · `DesignSystem/` (Theme, Components, SystemStates) ·
  `Model/` (Models, MenoStore) · `Features/<Zone>/` (Onboarding, Feed, CheckIn, Circles,
  Grow, Market, Profile, Settings). The whole `Meno/` folder is a file-system-synchronized
  Xcode group, so new files **and subfolders** are auto-included — no pbxproj editing needed.
- Data comes from **`MenoStore`** (`@EnvironmentObject`), an in-memory `ObservableObject`
  seeded with the design's sample content. Add new models to `Models.swift`, new seed data
  to `MenoStore.swift`. Swap this layer for a real backend later — views shouldn't change.
- Navigation: push with `NavigationLink`; modal forms (with Cancel/Save) as `.sheet`.
  Each pushed screen uses `MenoHeader` or a custom top bar and `.navigationBarHidden(true)`.
- Every screen: `.background(Meno.base)`, 20–24pt horizontal padding, `MenoCard` for grouped content.
- Add a `#Preview` per screen with `.environmentObject(MenoStore())`.
- Keep the dev `MENO_SCREEN` switch in `MenoApp.swift` updated when adding showcase screens.

---

## 6. TODO — full screen inventory by zone

Legend: ✅ done · 🟡 placeholder exists · ⬜ not started

### Shell / navigation
- [x] ✅ App entry, theme, component library, in-memory store
- [x] ✅ `RootView` 5-tab shell + custom `MenoTabBar` (floating center check-in)
- [x] ✅ All five tabs are real screens (Today · Circles · Check-in · Grow · Market); no placeholders left
- [x] ✅ Onboarding gate (`RootGate` + `@AppStorage("meno.onboarded")`) runs Zone A on first launch
- [ ] ⬜ Decide profile entry point long-term (currently: avatar in Today top bar → Profile)

### Zone A — Onboarding & Belonging  *(design: `Zone A`, arch 1–9)* — ✅ DONE (`OnboardingFlow.swift`)
- [x] ✅ Splash / Welcome (logo, pitch line, "Begin")
- [x] ✅ Recognition carousel (3-card)
- [x] ✅ Sign Up + Log In + Reset (anonymous-first messaging)
- [x] ✅ Stage selection (peri / meno / post / not sure)
- [x] ✅ Life situation multi-select
- [x] ✅ What Brought You Here — pains multi-select
- [x] ✅ Private Identity (display name + avatar tone + default anonymity)
- [x] ✅ We Found Your People (matched circles reveal)
- [x] ✅ Notifications Permission + Onboarding Complete (seeds profile from choices)

### Zone B — Today / Feed  *(design: `Zone B`, arch 10–14)* — ✅ DONE
- [x] ✅ Today Feed + empty state — `TodayFeedView.swift`
- [x] ✅ Post Composer (anonymity toggle, optional circle target) — `PostComposerView.swift`
- [x] ✅ Post Detail + threaded replies — `PostDetailView.swift`
- [x] ✅ Support Reactions Sheet (been there / holding you / me too / sending warmth) — `ReactionsSheet`
- [x] ✅ Saved & Reflected — `SavedReflectedView.swift`

### Zone C — Check-in & Reflection  *(design: `Zone C`, arch 15–16)* — ✅ DONE
- [x] ✅ Daily Check-in ("How are you, really?", mood grid, optional note) — `CheckInView.swift`
- [x] ✅ Reflection (gentle pattern + a story) — `ReflectionView`
- [x] ✅ Check-in History + first-time empty — `CheckInHistoryView.swift` / `CheckInView`

### Zone D — Circles  *(design: `Zone D` 23–30, arch 17–21)* — ✅ DONE
- [x] ✅ 23 My Circles (tab root) — `CirclesView.swift`
- [x] ✅ 24 Discover Circles (search/filter/join + start-your-own link) — `DiscoverCirclesView.swift`
- [x] ✅ 25 Circle Home (gradient masthead, posts, composer) — `CircleHomeView.swift`
- [x] ✅ 26 Circle About + 27 Members — `CircleAboutView.swift`
- [x] ✅ 28 Create / Request a Circle — `CreateCircleView.swift`
- [x] ✅ 29 Circle Settings + 30 Leave (sheet) — `CircleSettingsView.swift`

### Zone E — Grow  *(design: `Zone E` 31–37, arch 22–26)* — ✅ DONE
- [x] ✅ 31 Wisdom Library + 35 Challenges (one Grow tab, "Wisdom / Together" segment) — `GrowView.swift`
- [x] ✅ 32 Wisdom Category + 33 Wisdom Detail ("I tried this too" + thread) — `WisdomDetailView.swift`
- [x] ✅ 34 Share Your Wisdom (sheet) — `ShareWisdomView.swift`
- [x] ✅ 36 Challenge Detail + 37 Challenge Progress (day cells, group note) — `ChallengeDetailView.swift`

### Zone F — Market  *(design: `Zone F` 38–46, arch 27–32)* — ✅ DONE  *(affiliate model A — Save/Get-it link-out, no native commerce)*
- [x] ✅ 38 Market Home (tab root, list + wishlist entry) — `MarketView.swift`
- [x] ✅ 39 Collection / Category — `CollectionView.swift`
- [x] ✅ 40 Product Detail + 42 Shop Handoff (sheet) + 43 Confirmation (cover) — `ProductDetailView.swift`
- [x] ✅ 41 Your List + 44 Order History + 45 Wishlist — `YourListView.swift`
- [x] ✅ 46 Recommend a Product (sheet) — `RecommendProductView.swift`

### Zone G — Me & System  *(design: `Zone G` 47–55)* — ✅ DONE
- [x] ✅ 47 Profile (Me) — `ProfileView.swift`
- [x] ✅ 48 Edit Profile (sheet, Cancel/Save, writes to store) — `EditProfileView.swift`
- [x] ✅ 49 Public Profile — `PublicProfileView.swift`
- [x] ✅ 50 My Journey (timeline) — `MyJourneyView.swift`
- [x] ✅ 51 My Contributions (Posts/Wisdom/Reviews filter) — `MyContributionsView.swift`
- [x] ✅ 52 Saved Items (All/Posts/Wisdom/Products filter) — `SavedItemsView.swift`
- [x] ✅ 53/54 Global Search (empty suggestions + grouped results) — `SearchView.swift`
- [x] ✅ 55 Notifications (Today/Earlier) — `NotificationsView.swift`

### Zone I — Settings & Trust  *(design: `Zone I Settings` 56–70)* — ✅ DONE
- [x] ✅ 56 Settings Home — `Features/Settings/SettingsView.swift` (+ shared rows, `LogOutSheet` 70)
- [x] ✅ 57 Account + 69 Data Export/Delete — `AccountSettingsView.swift` / `DataExportView.swift`
- [x] ✅ 58 Privacy & Data (plain-language "what Meno learned", removable + toggles) — `PrivacyDataView.swift`
- [x] ✅ 59 Anonymity + 60 Blocked Users — `AnonymitySettingsView.swift` / `BlockedUsersView.swift`
- [x] ✅ 61 Notifications + 62 Appearance/Accessibility — `NotificationSettingsView.swift` / `AppearanceSettingsView.swift`
- [x] ✅ 64 Help · 65 Guidelines · 66 Safety + 67 Crisis · 68 About — respective `*View.swift`
- [x] ✅ 4 reusable system states (Loading/Error/Offline/Empty) — `DesignSystem/SystemStates.swift`; launch shows Loading via `store.bootstrap()`
- Profile gear + a "Settings" row now push the real `SettingsView` (Edit profile is its own row).

### Zone H — Advanced (post-MVP)  *(arch 42–43)* — ⬜ later
- [ ] ⬜ Mentor Connect · Live Rooms / Events

### Cross-cutting features (not screens) — ⬜
- [ ] ⬜ Real persistence / backend behind `MenoStore` (currently in-memory sample data) — **architecture designed**: see vault `Tech Projects/Meno/MenoBackend.md` (Supabase free-tier, RLS data firewall, protocol-ize `MenoStore` then add a `SupabaseStore` conformance; views unchanged)
- [ ] ⬜ Bundle real Spectral + Mulish fonts; update `Font.serif`/`Font.sans`
- [ ] ⬜ Learning Engine v1 hooks (feed rank, circle match, wisdom surfacing) — invisible, no screen
- [ ] ⬜ Auth / accounts · Real reactions, voting, "tried this" · Notifications plumbing
- [ ] ⬜ App icon + launch screen art · Accessibility pass (Dynamic Type, VoiceOver)

---

## 7. Suggested build order (design hand-off note)

Onboarding (A) → Today feed (B) → Check-in (C) → Circle home (D) → Wisdom detail (E)
→ Market home (F) → Settings/Privacy (I). These carry the experience; everything else hangs off them.

**For the next loop:** start a chat, fetch the relevant `Zone X` design file via `get_file`
(projectId in §3), build screen-by-screen following §4 tokens and §5 conventions, verify each
on the simulator, and tick the boxes above. Replace the matching placeholder in `RootView`
when a tab's zone is built.
