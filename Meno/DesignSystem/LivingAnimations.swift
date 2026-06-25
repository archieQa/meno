import SwiftUI

// MARK: - Living motion system (from "Meno — Living Prototype")
//
// The Living direction makes every surface feel quietly alive: a slow drifting
// blob field behind the app, a breathing gradient orb at the heart of Check-in,
// staggered card entrances, gentle screen transitions, and soft press feedback.
//
// Everything here is reusable and respects Reduce Motion — when the user has it
// on, looping animations settle to a calm static mid-state instead of moving.

// MARK: Accent shading — mirrors the prototype's _lighten / _darken helpers

extension Color {
    /// Blend toward another colour by `t` (0…1) in sRGB. Used to derive the
    /// orb's highlight (toward white) and shadow (toward black) from an accent.
    func mix(with other: Color, by t: CGFloat) -> Color {
        let a = UIColor(self), b = UIColor(other)
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, o1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, o2: CGFloat = 0
        a.getRed(&r1, green: &g1, blue: &b1, alpha: &o1)
        b.getRed(&r2, green: &g2, blue: &b2, alpha: &o2)
        return Color(.sRGB,
                     red: Double(r1 + (r2 - r1) * t),
                     green: Double(g1 + (g2 - g1) * t),
                     blue: Double(b1 + (b2 - b1) * t),
                     opacity: Double(o1 + (o2 - o1) * t))
    }
    /// Highlight used at the top-left of the breathing orb (42% toward white).
    func orbHighlight() -> Color { mix(with: .white, by: 0.42) }
    /// Lower shading of the orb (30% toward black).
    func orbShadowColor() -> Color { mix(with: .black, by: 0.30) }
}

// MARK: - Reduce-Motion aware looping driver
//
// A tiny helper: flips a Bool true on appear (so a repeatForever animation
// starts), unless Reduce Motion is on — then it stays at the resting value.

private struct LoopState: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Binding var running: Bool
    func body(content: Content) -> some View {
        content.onAppear { if !reduceMotion { running = true } }
    }
}

extension View {
    /// Starts a looping animation flag on appear unless Reduce Motion is on.
    func startLoop(_ running: Binding<Bool>) -> some View { modifier(LoopState(running: running)) }
}

// MARK: - Ambient field
//
// Three large, heavily-blurred radial blobs (clay / sage / gold) drifting on
// long, offset cycles. Sits behind every screen at z-index 0 and bleeds past
// the edges so motion is felt more than seen.

struct AmbientField: View {
    /// The clay-tinted blob follows the active accent so themed screens stay cohesive.
    var accent: Color = Meno.clay
    var fieldOpacity: Double = 0.8

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                MovingBlob(color: accent.opacity(0.34),
                           diameter: w * 0.78,
                           anchor: CGPoint(x: w * 0.10, y: h * 0.14),
                           travel: CGSize(width: 32, height: -44),
                           scaleTo: 1.18, duration: 28)
                MovingBlob(color: Meno.sage.opacity(0.32),
                           diameter: w * 0.74,
                           anchor: CGPoint(x: w * 0.78, y: h * 0.50),
                           travel: CGSize(width: -38, height: 38),
                           scaleFrom: 1.10, scaleTo: 0.92, duration: 34)
                MovingBlob(color: Meno.gold.opacity(0.24),
                           diameter: w * 0.80,
                           anchor: CGPoint(x: w * 0.30, y: h * 0.86),
                           travel: CGSize(width: 30, height: 40),
                           scaleTo: 1.22, duration: 40)
            }
            .frame(width: w, height: h)
        }
        .blur(radius: 50)
        .opacity(fieldOpacity)
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

/// One blurred blob that eases back and forth on a long autoreversing cycle.
private struct MovingBlob: View {
    var color: Color
    var diameter: CGFloat
    var anchor: CGPoint
    var travel: CGSize
    var scaleFrom: CGFloat = 1
    var scaleTo: CGFloat = 1.18
    var duration: Double
    @State private var on = false

    var body: some View {
        Circle()
            .fill(RadialGradient(colors: [color, .clear], center: .center,
                                 startRadius: 0, endRadius: diameter * 0.5))
            .frame(width: diameter, height: diameter)
            .scaleEffect(on ? scaleTo : scaleFrom)
            .position(x: anchor.x + (on ? travel.width : 0),
                      y: anchor.y + (on ? travel.height : 0))
            .animation(.easeInOut(duration: duration).repeatForever(autoreverses: true), value: on)
            .startLoop($on)
    }
}

// MARK: - Breathing orb
//
// The signature element: a soft gradient sphere that slowly swells and settles
// like a breath (~11s cycle), wrapped in a pulsing glow and outward ripple
// rings. Colour derives entirely from `accent`.

struct BreathingOrb: View {
    var accent: Color = Meno.clay
    /// Diameter of the solid orb. Glow/ripples scale from this.
    var size: CGFloat = 154
    var showRipples: Bool = true

    @State private var breathe = false
    @State private var glow = false

    private var container: CGFloat { size * 1.34 }

    var body: some View {
        ZStack {
            if showRipples {
                RippleRing(color: accent.opacity(0.4), size: size * 1.27)
                RippleRing(color: accent.opacity(0.4), size: size * 1.27, delay: 3)
            }

            // Soft glow halo
            Circle()
                .fill(RadialGradient(colors: [accent.opacity(0.5), .clear],
                                     center: .center, startRadius: 0, endRadius: size * 0.68))
                .frame(width: size * 1.32, height: size * 1.32)
                .blur(radius: size > 100 ? 14 : 10)
                .scaleEffect(glow ? 1.06 : 0.85)
                .opacity(glow ? 0.95 : 0.45)
                .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: glow)
                .startLoop($glow)

            // The orb itself
            Circle()
                .fill(RadialGradient(
                    gradient: Gradient(colors: [accent.orbHighlight(), accent, accent.orbShadowColor()]),
                    center: UnitPoint(x: 0.38, y: 0.32),
                    startRadius: 0, endRadius: size * 0.55))
                .frame(width: size, height: size)
                .overlay(
                    Circle().fill(RadialGradient(colors: [.white.opacity(0.35), .clear],
                                                 center: UnitPoint(x: 0.38, y: 0.30),
                                                 startRadius: 0, endRadius: size * 0.4))
                )
                .shadow(color: accent.opacity(0.42), radius: size > 100 ? 22 : 13, x: 0, y: size > 100 ? 14 : 8)
                .scaleEffect(breathe ? 1.0 : 0.80)
                .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: breathe)
                .startLoop($breathe)
        }
        .frame(width: container, height: container)
    }
}

/// A single expanding ring that fades as it grows — like sonar.
private struct RippleRing: View {
    var color: Color
    var size: CGFloat
    var delay: Double = 0
    @State private var go = false

    var body: some View {
        Circle()
            .strokeBorder(color, lineWidth: 1.5)
            .frame(width: size, height: size)
            .scaleEffect(go ? 2.1 : 0.55)
            .opacity(go ? 0 : 0.5)
            .animation(.easeOut(duration: 6).repeatForever(autoreverses: false).delay(delay), value: go)
            .startLoop($go)
    }
}

// MARK: - Breath guide
//
// Cycles "Breathe in → Hold → Breathe out → Rest" on a 12-second loop, timed to
// the orb. Phase boundaries match the prototype exactly (4.5s / 1.5s / 4.5s / 1.5s).

struct BreathGuide: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var label = "Breathe in"
    @State private var start = Date()
    private let tick = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()

    var body: some View {
        Text(label)
            .font(.serif(21))
            .foregroundStyle(Meno.sub)
            .contentTransition(.opacity)
            .onReceive(tick) { _ in
                guard !reduceMotion else { return }
                let t = Date().timeIntervalSince(start).truncatingRemainder(dividingBy: 12)
                let next = t < 4.5 ? "Breathe in" : t < 6 ? "Hold" : t < 10.5 ? "Breathe out" : "Rest"
                if next != label { withAnimation(.easeInOut(duration: 0.8)) { label = next } }
            }
    }
}

// MARK: - Live presence dot
//
// A small dot with a pulsing halo — "gently active now". Used on the feed mood
// chip and circle headers.

struct LivePulseDot: View {
    var color: Color = Meno.sage
    var size: CGFloat = 9
    @State private var pulse = false

    var body: some View {
        ZStack {
            Circle().fill(color).frame(width: size, height: size)
                .scaleEffect(pulse ? 1.5 : 1)
                .opacity(pulse ? 0.35 : 0.85)
                .animation(.easeInOut(duration: 1.7).repeatForever(autoreverses: true), value: pulse)
                .startLoop($pulse)
            Circle().fill(color).frame(width: size, height: size)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Shimmer glow
//
// A soft blurred highlight that drifts slowly inside a card thumbnail or tile,
// so even static imagery feels gently alive. Overlay it, clipped to the shape.

struct ShimmerGlow: View {
    var color: Color
    var duration: Double = 22
    @State private var on = false

    var body: some View {
        GeometryReader { geo in
            let d = max(geo.size.width, geo.size.height) * 0.9
            Circle()
                .fill(RadialGradient(colors: [color, .clear], center: .center,
                                     startRadius: 0, endRadius: d * 0.5))
                .frame(width: d, height: d)
                .blur(radius: 18)
                .offset(x: on ? geo.size.width * 0.18 : -geo.size.width * 0.18,
                        y: on ? 12 : -12)
                .scaleEffect(on ? 1.22 : 1)
                .animation(.easeInOut(duration: duration).repeatForever(autoreverses: true), value: on)
                .startLoop($on)
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Rising particles
//
// A scatter of small, blurred motes (clay / sage / gold / cream) drifting slowly
// upward and fading in then out — the breath of the living onboarding surface.
// Pure ambiance, so it's hidden entirely under Reduce Motion.

private struct ParticleDef {
    let left: CGFloat       // horizontal anchor, 0…1 of width
    let size: CGFloat
    let color: Color
    let maxOpacity: Double
    let dx: CGFloat         // horizontal drift across the rise
    let duration: Double
    let delay: Double       // staggered start so the field never pulses in unison
}

struct RisingParticles: View {
    var count: Int = 8
    /// How far a mote travels upward before fading out.
    var rise: CGFloat = 360
    private let defs: [ParticleDef]

    init(count: Int = 8, rise: CGFloat = 360) {
        self.count = count
        self.rise = rise
        // Mirrors the prototype palette: clay / sage / gold motes + a brighter cream fleck.
        let palette: [Color] = [
            Meno.clay.opacity(0.5), Meno.sage.opacity(0.5),
            Meno.gold.opacity(0.5), Color(hex: "FFFCF7", opacity: 0.7),
        ]
        defs = (0..<count).map { i in
            ParticleDef(
                left: .random(in: 0.06...0.92),
                size: .random(in: 4...8),
                color: palette[i % palette.count],
                maxOpacity: .random(in: 0.30...0.55),
                dx: .random(in: -22...22),
                duration: .random(in: 17...27),
                delay: .random(in: 0...6)
            )
        }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(defs.indices, id: \.self) { i in
                    RisingParticle(def: defs[i], rise: rise)
                        .position(x: geo.size.width * defs[i].left, y: geo.size.height + 12)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
    }
}

/// Keyframe-animated state for one mote: vertical travel, horizontal drift, fade.
private struct ParticleMotion {
    var y: CGFloat = 20
    var x: CGFloat = 0
    var opacity: Double = 0
}

/// One mote. Uses a repeating keyframe animator (iOS 17+) so the rise + the
/// fade-in/hold/fade-out stay perfectly in sync over an indefinite loop.
private struct RisingParticle: View {
    let def: ParticleDef
    let rise: CGFloat
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var begin = false

    var body: some View {
        Group {
            if begin && !reduceMotion {
                dot.keyframeAnimator(initialValue: ParticleMotion(), repeating: true) { view, m in
                    view.opacity(m.opacity).offset(x: m.x, y: m.y)
                } keyframes: { _ in
                    KeyframeTrack(\.y) { LinearKeyframe(-rise, duration: def.duration) }
                    KeyframeTrack(\.x) { LinearKeyframe(def.dx, duration: def.duration) }
                    KeyframeTrack(\.opacity) {
                        LinearKeyframe(def.maxOpacity, duration: def.duration * 0.14)
                        LinearKeyframe(def.maxOpacity, duration: def.duration * 0.72)
                        LinearKeyframe(0, duration: def.duration * 0.14)
                    }
                }
            }
        }
        // Stagger the start so motes don't all rise on the same beat.
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + def.delay) { begin = true }
        }
    }

    private var dot: some View {
        Circle().fill(def.color).frame(width: def.size, height: def.size).blur(radius: 1)
    }
}

// MARK: - Immersive background
//
// Warm radial wash used on the meditative screens (onboarding, check-in,
// reflection) in place of the flat cream base.

struct ImmersiveBackground: View {
    var body: some View {
        Meno.immersiveTop
            .overlay(
                RadialGradient(
                    gradient: Gradient(colors: [Meno.immersiveCore, Meno.immersiveEdge]),
                    center: UnitPoint(x: 0.5, y: 0.32),
                    startRadius: 0, endRadius: 560)
            )
            .ignoresSafeArea()
    }
}

// MARK: - Living background
//
// The standard tab background: cream base with the drifting ambient field
// behind it. Cards stay solid, so the motion reads as a quiet glow at the edges.

private struct LivingBackground: ViewModifier {
    var accent: Color
    var fieldOpacity: Double
    func body(content: Content) -> some View {
        content.background(
            ZStack {
                Meno.base
                AmbientField(accent: accent, fieldOpacity: fieldOpacity)
            }
            .ignoresSafeArea()
        )
    }
}

/// Immersive variant: warm radial wash with a fuller ambient field. For the
/// meditative screens (onboarding, check-in, reflection).
private struct ImmersiveLivingBackground: ViewModifier {
    var accent: Color
    func body(content: Content) -> some View {
        content.background(
            ZStack {
                ImmersiveBackground()
                AmbientField(accent: accent, fieldOpacity: 1)
            }
            .ignoresSafeArea()
        )
    }
}

extension View {
    /// Cream base + drifting ambient field. Use on tab roots in place of `.background(Meno.base)`.
    func menoLivingBackground(accent: Color = Meno.clay, fieldOpacity: Double = 0.8) -> some View {
        modifier(LivingBackground(accent: accent, fieldOpacity: fieldOpacity))
    }
    /// Warm immersive wash + ambient field. Use on meditative screens.
    func menoImmersiveBackground(accent: Color = Meno.clay) -> some View {
        modifier(ImmersiveLivingBackground(accent: accent))
    }
}

// MARK: - Screen transitions & staggered entrances

/// Tab/root screen entrance: rises 16pt and settles from 0.99 scale over ~0.72s.
private struct ScreenIn: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var shown = false
    func body(content: Content) -> some View {
        content
            .offset(y: shown ? 0 : 16)
            .scaleEffect(shown ? 1 : 0.99)
            .opacity(shown ? 1 : 0)
            .onAppear {
                guard !reduceMotion else { shown = true; return }
                withAnimation(.timingCurve(0.22, 0.61, 0.27, 1, duration: 0.72)) { shown = true }
            }
    }
}

/// Pushed/detail screen entrance: slides in 28pt from the trailing edge.
private struct DeepIn: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var shown = false
    func body(content: Content) -> some View {
        content
            .offset(x: shown ? 0 : 28)
            .opacity(shown ? 1 : 0)
            .onAppear {
                guard !reduceMotion else { shown = true; return }
                withAnimation(.timingCurve(0.22, 0.61, 0.27, 1, duration: 0.6)) { shown = true }
            }
    }
}

/// Card/list entrance: fades up 18pt, optionally staggered by `delay`.
private struct FadeUp: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    var delay: Double
    @State private var shown = false
    func body(content: Content) -> some View {
        content
            .opacity(shown ? 1 : 0)
            .offset(y: shown ? 0 : 18)
            .onAppear {
                guard !reduceMotion else { shown = true; return }
                withAnimation(.easeOut(duration: 0.7).delay(delay)) { shown = true }
            }
    }
}

extension View {
    /// Root/tab screen entrance.
    func menoScreenIn() -> some View { modifier(ScreenIn()) }
    /// Pushed detail screen entrance.
    func menoDeepIn() -> some View { modifier(DeepIn()) }
    /// Staggered fade-up for a card; pass the row index times ~0.08–0.1.
    func menoFadeUp(delay: Double = 0) -> some View { modifier(FadeUp(delay: delay)) }
    /// Convenience: stagger using a row index.
    func menoFadeUp(index: Int, step: Double = 0.09, base: Double = 0.05) -> some View {
        modifier(FadeUp(delay: base + Double(index) * step))
    }
}

// MARK: - Press feedback

/// Soft scale-down on press (0.95), used on every interactive surface.
struct MenoPress: ButtonStyle {
    var scale: CGFloat = 0.95
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

extension View {
    /// Apply the standard press scale to a tappable (non-Button) surface.
    func menoPressable() -> some View { buttonStyle(MenoPress()) }
}
