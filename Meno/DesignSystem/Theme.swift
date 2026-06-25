import SwiftUI

// MARK: - Color tokens (from "Meno — Foundations")
// Warm, calm, mature palette. No clinical blue, no stereotyped pink.

extension Color {
    init(hex: String, opacity: Double = 1) {
        let h = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var rgb: UInt64 = 0
        Scanner(string: h).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: opacity)
    }

    /// A color that resolves to `light` or `dark` based on the active interface
    /// style. Every `Meno` token is built from this, so the whole app adapts to
    /// the theme without any view touching color logic.
    static func dyn(_ light: Color, _ dark: Color) -> Color {
        Color(uiColor: UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }

    /// Convenience: a dynamic token whose light/dark sides are the same hue at
    /// (optionally) different opacities — used for the `*Soft` tints.
    static func dyn(hex: String, light: Double, dark: Double) -> Color {
        dyn(Color(hex: hex, opacity: light), Color(hex: hex, opacity: dark))
    }
}

enum Meno {
    // Surfaces — warm cream in light, warm near-black (never pure black) in dark
    static let base       = Color.dyn(Color(hex: "FAF6F0"), Color(hex: "1A1714"))   // app background
    static let surface    = Color.dyn(Color(hex: "FFFCF7"), Color(hex: "241F1B"))   // cards, inputs
    static let surfaceAlt = Color.dyn(Color(hex: "F4E9DF"), Color(hex: "2C2622"))   // deeper warm surface — section bgs, avatar rings, splash
    // Brand — keep the hue, lift slightly in dark so it reads on near-black
    static let clay       = Color.dyn(Color(hex: "C46A52"), Color(hex: "D88468"))   // primary
    static let clayDark   = Color.dyn(Color(hex: "A2503C"), Color(hex: "C46A52"))
    static let claySoft   = Color.dyn(hex: "C46A52", light: 0.12, dark: 0.22)
    static let sage       = Color.dyn(Color(hex: "7E8B6F"), Color(hex: "9AA889"))   // secondary
    static let sageDark   = Color.dyn(Color(hex: "5C6650"), Color(hex: "7E8B6F"))
    static let sageSoft   = Color.dyn(hex: "7E8B6F", light: 0.24, dark: 0.30)
    static let plum       = Color.dyn(Color(hex: "7E6B8F"), Color(hex: "9C88AD"))
    static let plumDark   = Color.dyn(Color(hex: "574766"), Color(hex: "7E6B8F"))
    static let plumSoft   = Color.dyn(hex: "7E6B8F", light: 0.24, dark: 0.32)
    static let gold       = Color.dyn(Color(hex: "D7A24B"), Color(hex: "E2B566"))   // warm sand accent (Grow / Market)
    static let goldDark   = Color.dyn(Color(hex: "7A5F24"), Color(hex: "D7A24B"))
    static let goldSoft   = Color.dyn(hex: "D7A24B", light: 0.24, dark: 0.28)
    // Text — dark brown on cream, warm off-white on near-black
    static let ink        = Color.dyn(Color(hex: "2E2622"), Color(hex: "F2ECE4"))   // primary text
    static let sub        = Color.dyn(Color(hex: "5E544C"), Color(hex: "C9BEB3"))   // secondary text
    static let taupe      = Color.dyn(Color(hex: "8A7D72"), Color(hex: "A89C90"))   // quiet
    static let muted      = Color.dyn(Color(hex: "9C9087"), Color(hex: "938881"))   // captions
    static let faint      = Color.dyn(Color(hex: "B3A99F"), Color(hex: "6F665F"))   // chevrons
    static let navIdle    = Color.dyn(Color(hex: "A99E90"), Color(hex: "8A8077"))   // inactive nav
    // Body / quote text variants kept distinct from ink/sub to preserve the light design
    static let bodyText   = Color.dyn(Color(hex: "3F4736"), Color(hex: "E4E7DD"))   // body & quotes (sage-tinted)
    static let subtle     = Color.dyn(Color(hex: "6B6157"), Color(hex: "B7AC9F"))   // anonymous / secondary labels
    // Hairlines / borders — dark ink overlay in light, light overlay in dark
    static let hairline   = Color.dyn(Color(hex: "2E2622", opacity: 0.07), Color(hex: "FFFFFF", opacity: 0.08))
    static let border     = Color.dyn(Color(hex: "2E2622", opacity: 0.14), Color(hex: "FFFFFF", opacity: 0.16))
    static let cardBorder = Color.dyn(Color(hex: "2E2622", opacity: 0.09), Color(hex: "FFFFFF", opacity: 0.10))

    // Immersive wash — warm radial gradient behind meditative screens
    // (onboarding, check-in, reflection). Light: sandy cream; dark: deep ember.
    static let immersiveTop  = Color.dyn(Color(hex: "F6ECE1"), Color(hex: "201A16"))
    static let immersiveCore = Color.dyn(Color(hex: "F6ECE1"), Color(hex: "2A211B"))
    static let immersiveEdge = Color.dyn(Color(hex: "E3CFBA"), Color(hex: "16110E"))

    // Radii
    static let rCard: CGFloat = 20
    static let rButton: CGFloat = 15
    static let rField: CGFloat = 14
}

// MARK: - Typography
// Spectral (serif) carries warmth in headings; Mulish keeps UI crisp.
// System serif/default stand in until the brand fonts are bundled.
// Body never below 16pt — audience is 45–55.

extension Font {
    static func serif(_ size: CGFloat, _ weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }
    static func sans(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
}
