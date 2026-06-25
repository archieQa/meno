import SwiftUI

// MARK: - Reusable building blocks (from "Meno — Foundations")

/// Soft surface card: cream-white, hairline border, gentle shadow, 20pt radius.
struct MenoCard<Content: View>: View {
    var padding: CGFloat = 16
    @ViewBuilder var content: Content
    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Meno.surface)
            .overlay(
                RoundedRectangle(cornerRadius: Meno.rCard, style: .continuous)
                    .stroke(Meno.cardBorder, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: Meno.rCard, style: .continuous))
            .shadow(color: Color(hex: "2E2622", opacity: 0.04), radius: 10, x: 0, y: 2)
    }
}

/// Round monogram avatar with a tonal palette per person.
enum AvatarTone { case clay, sage, plum, sand, neutral }

extension AvatarTone {
    /// The solid brand colour for this tone.
    var accent: Color {
        switch self {
        case .clay:    return Meno.clay
        case .sage:    return Meno.sage
        case .plum:    return Meno.plum
        case .sand:    return Meno.gold
        case .neutral: return Meno.muted
        }
    }
    /// Soft tonal wash used behind category cards and product thumbnails.
    var softFill: Color {
        switch self {
        case .clay:    return Meno.clay.opacity(0.16)
        case .sage:    return Meno.sage.opacity(0.18)
        case .plum:    return Meno.plum.opacity(0.16)
        case .sand:    return Meno.gold.opacity(0.18)
        case .neutral: return Meno.ink.opacity(0.06)
        }
    }
    /// Diagonal gradient used as a stand-in for product imagery.
    var thumbGradient: LinearGradient {
        let pairs: (Color, Color)
        switch self {
        case .clay:    pairs = (Meno.clay.opacity(0.18), Meno.sage.opacity(0.14))
        case .sage:    pairs = (Meno.sage.opacity(0.20), Meno.clay.opacity(0.14))
        case .plum:    pairs = (Meno.plum.opacity(0.20), Color(hex: "A7B0B8", opacity: 0.18))
        case .sand:    pairs = (Meno.gold.opacity(0.18), Meno.clay.opacity(0.14))
        case .neutral: pairs = (Meno.ink.opacity(0.08), Meno.ink.opacity(0.04))
        }
        return LinearGradient(colors: [pairs.0, pairs.1], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

/// Overlapping monogram avatars — a quick "who's here" glance.
struct AvatarStack: View {
    let people: [(initial: String, tone: AvatarTone)]
    var size: CGFloat = 32
    var ring: Color = Meno.surface
    var body: some View {
        HStack(spacing: -size * 0.31) {
            ForEach(Array(people.enumerated()), id: \.offset) { _, p in
                Avatar(initial: p.initial, tone: p.tone, size: size)
                    .overlay(Circle().stroke(ring, lineWidth: 2))
            }
        }
    }
}

/// Gradient placeholder for product imagery (Market).
struct MarketThumb: View {
    var tone: AvatarTone = .clay
    var radius: CGFloat = 14
    var body: some View {
        RoundedRectangle(cornerRadius: radius, style: .continuous)
            .fill(tone.thumbGradient)
    }
}

struct Avatar: View {
    let initial: String
    var tone: AvatarTone = .clay
    var size: CGFloat = 40

    private var bg: Color {
        switch tone {
        case .clay:    return Meno.clay
        case .sage:    return Meno.sageSoft
        case .plum:    return Meno.plumSoft
        case .sand:    return Meno.goldSoft
        case .neutral: return Meno.cardBorder
        }
    }
    private var fg: Color {
        switch tone {
        case .clay:    return Meno.surface
        case .sage:    return Meno.sageDark
        case .plum:    return Meno.plumDark
        case .sand:    return Meno.goldDark
        case .neutral: return Meno.muted
        }
    }
    var body: some View {
        Text(initial)
            .font(.serif(size * 0.4))
            .foregroundStyle(fg)
            .frame(width: size, height: size)
            .background(bg)
            .clipShape(Circle())
    }
}

/// Pill chip with selected / unselected states.
struct Chip: View {
    let title: String
    var selected: Bool = false
    var height: CGFloat = 36
    var body: some View {
        Text(title)
            .font(.sans(height >= 40 ? 15 : 14, .bold))
            .foregroundStyle(selected ? Meno.surface : Meno.sub)
            .padding(.horizontal, 16)
            .frame(height: height)
            .background(selected ? Meno.clay : .clear)
            .overlay(
                Capsule().stroke(selected ? .clear : Meno.border, lineWidth: 1.5)
            )
            .clipShape(Capsule())
    }
}

/// Uppercase section label used above groups.
struct SectionLabel: View {
    let text: String
    var color: Color = Meno.muted
    var body: some View {
        Text(text.uppercased())
            .font(.sans(12.5, .heavy))
            .tracking(0.5)
            .foregroundStyle(color)
    }
}

/// Filled primary button.
struct PrimaryButton: View {
    let title: String
    var action: () -> Void = {}
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.sans(17, .bold))
                .foregroundStyle(Meno.surface)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Meno.clay)
                .clipShape(RoundedRectangle(cornerRadius: Meno.rButton, style: .continuous))
        }
        .buttonStyle(MenoPress())
    }
}

/// Outlined secondary button.
struct SecondaryButton: View {
    let title: String
    var action: () -> Void = {}
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.sans(17, .bold))
                .foregroundStyle(Meno.clay)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .overlay(
                    RoundedRectangle(cornerRadius: Meno.rButton, style: .continuous)
                        .stroke(Meno.clay, lineWidth: 1.5)
                )
        }
        .buttonStyle(MenoPress())
    }
}

/// A tappable settings-style row with a trailing chevron.
struct DisclosureRow: View {
    let title: String
    var body: some View {
        HStack {
            Text(title).font(.sans(16, .bold)).foregroundStyle(Meno.ink)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Meno.faint)
        }
        .padding(16)
        .contentShape(Rectangle())
    }
}

/// Post author avatar — a lock glyph when anonymous, else a monogram.
struct PostAvatar: View {
    let anonymous: Bool
    var initial: String = ""
    var tone: AvatarTone = .neutral
    var size: CGFloat = 40
    var body: some View {
        if anonymous {
            Circle().fill(Meno.ink.opacity(0.09))
                .frame(width: size, height: size)
                .overlay(Image(systemName: "lock.fill")
                    .font(.system(size: size * 0.4)).foregroundStyle(Meno.muted))
        } else {
            Avatar(initial: initial, tone: tone, size: size)
        }
    }
}

/// A support reaction as a tappable pill — clay-tinted once it's yours.
struct ReactionPill: View {
    let reaction: Reaction
    var action: () -> Void = {}
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(reaction.label)
                if reaction.count > 0 {
                    Text("\(reaction.count)").opacity(0.6).fontWeight(.semibold)
                }
            }
            .font(.sans(14, .bold))
            .foregroundStyle(reaction.mine ? Meno.clay : Meno.taupe)
            .padding(.horizontal, 14).frame(height: 40)
            .background(reaction.mine ? Meno.claySoft : .clear)
            .overlay(Capsule().stroke(reaction.mine ? Meno.clay : Meno.border, lineWidth: 1.5))
            .clipShape(Capsule())
        }
        .buttonStyle(MenoPress())
    }
}

/// Pill toggle in the brand palette (clay when on).
struct MenoToggle: View {
    @Binding var isOn: Bool
    var width: CGFloat = 50
    var height: CGFloat = 29
    var body: some View {
        Button { withAnimation(.easeInOut(duration: 0.15)) { isOn.toggle() } } label: {
            Capsule().fill(isOn ? Meno.clay : Meno.border)
                .frame(width: width, height: height)
                .overlay(
                    Circle().fill(.white)
                        .frame(width: height - 6, height: height - 6)
                        .padding(3),
                    alignment: isOn ? .trailing : .leading
                )
        }
        .buttonStyle(.plain)
    }
}

/// Left-to-right wrapping container (chips, tags). iOS 16+ Layout.
struct FlexWrap<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    var spacing: CGFloat
    @ViewBuilder var content: (Data.Element) -> Content
    init(_ data: Data, spacing: CGFloat = 10, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data; self.spacing = spacing; self.content = content
    }
    var body: some View {
        WrapLayout(spacing: spacing) {
            ForEach(Array(data), id: \.self) { content($0) }
        }
    }
}

/// Flow layout: places subviews left to right, wrapping to new rows.
struct WrapLayout: Layout {
    var spacing: CGFloat = 10
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxW = proposal.width ?? .infinity
        var x: CGFloat = 0, y: CGFloat = 0, rowH: CGFloat = 0
        for v in subviews {
            let s = v.sizeThatFits(.unspecified)
            if x + s.width > maxW, x > 0 { x = 0; y += rowH + spacing; rowH = 0 }
            x += s.width + spacing; rowH = max(rowH, s.height)
        }
        return CGSize(width: maxW == .infinity ? x : maxW, height: y + rowH)
    }
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX, y = bounds.minY, rowH: CGFloat = 0
        for v in subviews {
            let s = v.sizeThatFits(.unspecified)
            if x + s.width > bounds.maxX, x > bounds.minX { x = bounds.minX; y += rowH + spacing; rowH = 0 }
            v.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(s))
            x += s.width + spacing; rowH = max(rowH, s.height)
        }
    }
}

/// Standard navigation header: back chevron + serif title.
struct MenoHeader: View {
    let title: String
    var onBack: (() -> Void)? = nil
    var body: some View {
        HStack(spacing: 14) {
            if let onBack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22, weight: .regular))
                        .foregroundStyle(Meno.faint)
                }
                .accessibilityIdentifier("backButton")
                .accessibilityLabel("Back")
            }
            Text(title).font(.serif(24))
                .foregroundStyle(Meno.ink)
            Spacer()
        }
        .padding(.horizontal, 22)
        .padding(.bottom, 12)
        .overlay(Rectangle().fill(Meno.hairline).frame(height: 1), alignment: .bottom)
    }
}
