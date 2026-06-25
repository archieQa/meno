import SwiftUI

/// Zone C, screens 19 / 20 / 22 — Daily Check-in, Reflection, and first-time empty.
/// Emotional-first: one word for how you are, never an audit.
///
/// "Living Check-in": the orb breathes at the centre of a drifting ambient field;
/// the day's question and a row of mood pills settle in beneath it. Choosing a
/// word is the whole interaction — the moment then quietly closes into Reflection.
struct CheckInView: View {
    @EnvironmentObject var store: MenoStore
    /// Closes the immersive check-in back to the feed — the prototype's "×".
    var onClose: (() -> Void)? = nil
    @State private var mood: Mood?
    @State private var showReflection = false
    @State private var started = false

    private var dateLabel: String {
        let f = DateFormatter(); f.dateFormat = "EEEE, d MMMM"
        return f.string(from: Date())
    }

    var body: some View {
        NavigationStack {
            Group {
                if store.checkInLog.isEmpty && !started {
                    firstTime
                } else {
                    checkInForm
                }
            }
            .menoImmersiveBackground()
            .overlay(RisingParticles(count: 11))
            .navigationBarHidden(true)
            .sheet(isPresented: $showReflection) {
                ReflectionView(onFinish: { onClose?() }).presentationDetents([.large])
            }
        }
        .onAppear { mood = store.todayMood }
    }

    // MARK: 19 — Daily check-in

    private var checkInForm: some View {
        VStack(spacing: 0) {
            // Header — the day, and a quiet close back to the feed.
            HStack {
                Text(dateLabel.uppercased())
                    .font(.sans(13, .medium)).tracking(0.6)
                    .foregroundStyle(Meno.taupe)
                Spacer()
                Button { onClose?() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 19, weight: .regular))
                        .foregroundStyle(Meno.faint)
                        .frame(width: 32, height: 32)
                        .contentShape(Rectangle())
                }
                .buttonStyle(MenoPress(scale: 0.9))
            }
            .padding(.horizontal, 26).padding(.top, 12)
            .menoFadeUp(delay: 0.05)

            // The breathing orb sets the pace at the heart of the screen.
            VStack(spacing: 30) {
                BreathingOrb(accent: Meno.clay, size: 154)
                BreathGuide()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .menoFadeUp(delay: 0.2)

            // The question, one word for how you are, then a gentle close.
            VStack(spacing: 0) {
                Text("How are you, really?")
                    .font(.serif(26)).foregroundStyle(Meno.ink)
                    .tracking(-0.4)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 16)

                CenteredFlowLayout(spacing: 9) {
                    ForEach(Mood.allCases) { m in moodChip(m) }
                }
                .padding(.bottom, 18)

                Button { finish() } label: {
                    Text("Done for today")
                        .font(.sans(18, .medium)).foregroundStyle(Color(hex: "FFFCF7"))
                        .frame(maxWidth: .infinity).frame(height: 56)
                        .background(Meno.clay)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Meno.clay.opacity(0.32), radius: 12, x: 0, y: 10)
                }
                .buttonStyle(MenoPress(scale: 0.97))
            }
            .padding(.horizontal, 26).padding(.bottom, 26)
            .menoFadeUp(delay: 0.55)
        }
    }

    private func moodChip(_ m: Mood) -> some View {
        let on = mood == m
        return Button { selectMood(m) } label: {
            HStack(spacing: 8) {
                Circle().fill(on ? Color(hex: "FFFCF7") : Color(hex: m.hex))
                    .frame(width: 14, height: 14)
                Text(m.rawValue).font(.sans(15, .medium))
                    .foregroundStyle(on ? Color(hex: "FFFCF7") : Meno.sub)
            }
            .padding(.horizontal, 16).frame(height: 46)
            .background(on ? Meno.clay : Meno.surface)
            .overlay(Capsule().stroke(on ? Meno.clay : Meno.cardBorder, lineWidth: 1.5))
            .clipShape(Capsule())
            .shadow(color: on ? Meno.clay.opacity(0.32) : Color.black.opacity(0.05),
                    radius: on ? 12 : 5, x: 0, y: on ? 8 : 2)
        }
        .buttonStyle(MenoPress(scale: 0.94))
    }

    /// Selecting a word simply settles it in — changing your mind is free until
    /// you tap "Done for today".
    private func selectMood(_ m: Mood) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) { mood = m }
    }

    /// "Done for today" logs the chosen word and closes into Reflection.
    private func finish() {
        store.logCheckIn(mood: mood ?? .tender, note: "")
        showReflection = true
    }

    // MARK: 22 — First-time / empty

    private var firstTime: some View {
        VStack(spacing: 0) {
            Spacer()
            BreathingOrb(accent: Meno.clay, size: 96)
                .padding(.bottom, 24)
            Text("A small daily moment, just for you").font(.serif(30)).foregroundStyle(Meno.ink)
                .multilineTextAlignment(.center).padding(.bottom, 14)
            Text("One word for how you\u{2019}re feeling. That\u{2019}s all. Over time, it helps you — and your circle — notice the patterns together.")
                .font(.sans(17)).foregroundStyle(Meno.sub).multilineTextAlignment(.center)
                .lineSpacing(3).frame(maxWidth: 290).padding(.bottom, 30)
            Button { withAnimation { started = true } } label: {
                Text("Start my first check-in").font(.sans(17, .bold)).foregroundStyle(Meno.surface)
                    .frame(maxWidth: 250).frame(height: 56).background(Meno.clay)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .buttonStyle(.plain)
            Spacer()
        }
        .padding(.horizontal, 34)
    }
}

/// Zone C, screen 20 — Reflection: a gentle pattern, reflected back with a story.
struct ReflectionView: View {
    @Environment(\.dismiss) private var dismiss
    /// Called once the moment closes — used to return to the feed, per the design.
    var onFinish: (() -> Void)? = nil
    /// "I hear that" first acknowledges ("Held — thank you"), then the moment closes.
    @State private var held = false
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                BreathingOrb(accent: Meno.sage, size: 60, showRipples: true)
                    .frame(width: 72, height: 72, alignment: .leading)
                    .padding(.bottom, 20)
                Text("Evenings have felt heavier this week.").font(.serif(29)).foregroundStyle(Meno.ink)
                    .lineSpacing(2).padding(.bottom, 16)
                    .menoFadeUp(delay: 0.15)
                Text("You\u{2019}re not the only one — three women in your circle felt that too. It tends to pass.")
                    .font(.sans(18)).foregroundStyle(Meno.sub).lineSpacing(3).padding(.bottom, 26)
                    .menoFadeUp(delay: 0.3)

                VStack(alignment: .leading, spacing: 0) {
                    SectionLabel(text: "A story that might help", color: Meno.taupe).padding(.bottom, 10)
                    Text("\u{201C}I started leaving the lamp on low and reading ten minutes before bed. The dread of the evening eased.\u{201D}")
                        .font(.sans(16)).foregroundStyle(Meno.ink).lineSpacing(2).padding(.bottom, 8)
                    Text("— Priya, post-menopause").font(.sans(14)).foregroundStyle(Meno.muted)
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Meno.surface)
                .overlay(RoundedRectangle(cornerRadius: Meno.rCard, style: .continuous).stroke(Meno.cardBorder, lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: Meno.rCard, style: .continuous))
                .menoFadeUp(delay: 0.45)
            }
            .padding(.horizontal, 30).padding(.top, 36)
            .frame(maxHeight: .infinity, alignment: .top)

            Button {
                if held { finish() }
                else {
                    withAnimation(.easeInOut(duration: 0.4)) { held = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) { finish() }
                }
            } label: {
                Text(held ? "Held \u{2014} thank you" : "I hear that")
                    .font(.sans(18, .bold)).foregroundStyle(held ? Meno.surface : Meno.clay)
                    .frame(maxWidth: .infinity).frame(height: 56)
                    .background(held ? Meno.clay : Color.clear)
                    .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Meno.clay, lineWidth: 1.5))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 30).padding(.bottom, 30)
        }
        .menoImmersiveBackground(accent: Meno.sage)
    }

    /// Close the sheet, then hand back to the caller so it can return to the feed.
    private func finish() {
        dismiss()
        onFinish?()
    }
}

// MARK: - Centered flow layout
//
// Wraps the mood pills onto as many rows as needed, centring each row — matching
// the prototype's `flex-wrap; justify-content:center`.

struct CenteredFlowLayout: Layout {
    var spacing: CGFloat = 9

    private struct Row { var indices: [Int] = []; var height: CGFloat = 0 }

    private func rows(maxWidth: CGFloat, subviews: Subviews) -> [Row] {
        var rows = [Row()]
        var x: CGFloat = 0
        for (i, sub) in subviews.enumerated() {
            let size = sub.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                rows.append(Row()); x = 0
            }
            rows[rows.count - 1].indices.append(i)
            rows[rows.count - 1].height = max(rows[rows.count - 1].height, size.height)
            x += size.width + spacing
        }
        return rows
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        let rows = rows(maxWidth: maxWidth, subviews: subviews)
        let height = rows.map(\.height).reduce(0, +) + spacing * CGFloat(max(0, rows.count - 1))
        return CGSize(width: proposal.width ?? 0, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var y = bounds.minY
        for row in rows(maxWidth: bounds.width, subviews: subviews) {
            let rowWidth = row.indices.map { subviews[$0].sizeThatFits(.unspecified).width }.reduce(0, +)
                + spacing * CGFloat(max(0, row.indices.count - 1))
            var x = bounds.minX + (bounds.width - rowWidth) / 2
            for i in row.indices {
                let size = subviews[i].sizeThatFits(.unspecified)
                subviews[i].place(
                    at: CGPoint(x: x, y: y + (row.height - size.height) / 2),
                    anchor: .topLeading,
                    proposal: ProposedViewSize(size))
                x += size.width + spacing
            }
            y += row.height + spacing
        }
    }
}

#Preview { CheckInView().environmentObject(MenoStore()) }
