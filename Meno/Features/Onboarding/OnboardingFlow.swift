import SwiftUI

/// Zone A — Auth & Onboarding (screens 1–12).
/// One self-contained flow: from "you belong here" to arriving in the app.
/// On completion it seeds the store's profile from the choices made here,
/// so Zone G reflects who the woman said she is.
struct OnboardingFlow: View {
    @EnvironmentObject var store: MenoStore
    var onComplete: () -> Void = {}

    enum Step { case splash, recognition, signUp, logIn, reset, stage, life, pains, identity, match, notifications, complete }
    @State private var step: Step = .splash

    // collected choices
    @State private var recogIndex = 0
    @State private var stage: String = "Perimenopause"
    @State private var life: Set<String> = ["Working", "Caregiver"]
    @State private var pains: Set<String> = ["Sleep", "Brain fog", "Loneliness"]
    @State private var name: String = "Anna"
    @State private var tone: AvatarTone = .clay
    @State private var anonymousDefault = true

    private func go(_ s: Step) { withAnimation(.easeInOut(duration: 0.25)) { step = s } }

    private var immersiveStep: Bool { step == .splash || step == .complete || step == .stage }

    var body: some View {
        ZStack {
            // Living backdrop: a warm immersive wash on the meditative steps,
            // the cream base elsewhere — both carry the drifting ambient field.
            if immersiveStep {
                ImmersiveBackground()
            } else {
                Meno.base.ignoresSafeArea()
            }
            AmbientField(fieldOpacity: immersiveStep ? 1 : 0.8)
            // The stage step is the living welcome: a soft updraft of motes over the wash.
            if step == .stage { RisingParticles() }
            content
                .transition(.opacity)
        }
    }

    @ViewBuilder private var content: some View {
        switch step {
        case .splash:        splash
        case .recognition:   recognition
        case .signUp:        signUp
        case .logIn:         logIn
        case .reset:         reset
        case .stage:         stageStep
        case .life:          lifeStep
        case .pains:         painsStep
        case .identity:      identityStep
        case .match:         matchStep
        case .notifications: notificationsStep
        case .complete:      complete
        }
    }

    // MARK: 01 — Splash / Welcome

    private var splash: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 26) {
                BreathingOrb(accent: Meno.clay, size: 92)
                VStack(spacing: 18) {
                    Text("Meno").font(.serif(54)).foregroundStyle(Meno.clay).tracking(-1)
                    Text("Menopause is lonely. Meno makes sure you\u{2019}re never doing it alone.")
                        .font(.sans(19)).foregroundStyle(Meno.sub)
                        .multilineTextAlignment(.center).lineSpacing(4)
                        .frame(maxWidth: 280)
                }
            }
            Spacer()
            VStack(spacing: 12) {
                obPrimary("Begin") { go(.recognition) }
                obTertiary("I already have an account") { go(.logIn) }
            }
            .padding(.horizontal, 30).padding(.bottom, 24)
        }
    }

    // MARK: 02 — Recognition carousel

    private let recog: [(String, String)] = [
        ("The 3am wake-ups, when the house is finally quiet.", "You\u{2019}re not imagining it. And you\u{2019}re not doing it alone."),
        ("The word that\u{2019}s right there — and then it\u{2019}s gone.", "Brain fog is real. Here, nobody finishes your sentence for you."),
        ("Feeling unseen, just when you\u{2019}ve never been wiser.", "A room full of women who already see you.")
    ]

    private var recognition: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                obTertiary("Skip") { go(.signUp) }.fixedSize()
            }
            .padding(.horizontal, 22).padding(.top, 6)

            VStack(alignment: .leading, spacing: 0) {
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(LinearGradient(colors: [Meno.claySoft, Meno.sageSoft],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 200)
                    .overlay(
                        ZStack {
                            Circle().fill(Meno.clay.opacity(0.22)).frame(width: 130).offset(x: -55, y: -30)
                            Circle().fill(Meno.sage.opacity(0.30)).frame(width: 80).offset(x: 70, y: 50)
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                    .padding(.bottom, 30)
                Text(recog[recogIndex].0).font(.serif(33)).foregroundStyle(Meno.ink)
                    .lineSpacing(2).padding(.bottom, 16)
                Text(recog[recogIndex].1).font(.sans(18)).foregroundStyle(Meno.sub).lineSpacing(4)
            }
            .padding(.horizontal, 30).padding(.top, 6)
            .frame(maxHeight: .infinity, alignment: .top)

            VStack(spacing: 24) {
                HStack(spacing: 6) {
                    ForEach(0..<recog.count, id: \.self) { i in
                        Capsule().fill(i == recogIndex ? Meno.clay : Meno.ink.opacity(0.16))
                            .frame(width: i == recogIndex ? 26 : 22, height: 5)
                    }
                }
                obPrimary("Continue") {
                    if recogIndex < recog.count - 1 { withAnimation { recogIndex += 1 } }
                    else { go(.signUp) }
                }
            }
            .padding(.horizontal, 30).padding(.bottom, 24)
        }
    }

    // MARK: 03 — Sign Up

    @State private var email = ""
    @State private var password = ""

    private var signUp: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Make your space").font(.serif(31)).foregroundStyle(Meno.ink).padding(.bottom, 8)
                Text("We only ask for what helps your circle reach you.")
                    .font(.sans(16.5)).foregroundStyle(Meno.sub).padding(.bottom, 26)
                VStack(spacing: 13) {
                    obField("Email or phone", text: $email)
                    obField("Create a password", text: $password, secure: true)
                }
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "lock.fill").font(.system(size: 18)).foregroundStyle(Meno.sageDark)
                    Text("You can stay completely anonymous here. No real name is ever shown to anyone.")
                        .font(.sans(15, .semibold)).foregroundStyle(Meno.sageDark).lineSpacing(3)
                }
                .padding(16)
                .background(Meno.sage.opacity(0.14))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.top, 22)
            }
            .padding(.horizontal, 30).padding(.top, 40)
            .frame(maxHeight: .infinity, alignment: .top)

            obPrimary("Create account") { go(.stage) }
                .padding(.horizontal, 30).padding(.bottom, 24)
        }
    }

    // MARK: 04 — Log In

    private var logIn: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Meno").font(.serif(30)).foregroundStyle(Meno.clay).padding(.bottom, 24)
                Text("Welcome back").font(.serif(30)).foregroundStyle(Meno.ink).padding(.bottom, 22)
                VStack(spacing: 13) {
                    obField("Email or phone", text: $email)
                    obField("Password", text: $password, secure: true)
                }
                HStack {
                    Spacer()
                    Button { go(.reset) } label: {
                        Text("Forgot password?").font(.sans(15, .bold)).foregroundStyle(Meno.clay)
                    }
                }
                .padding(.top, 14)
            }
            .padding(.horizontal, 30).padding(.top, 40)
            .frame(maxHeight: .infinity, alignment: .top)

            VStack(spacing: 12) {
                obPrimary("Log in") { finish() }
                obTertiary("New here? Create an account") { go(.signUp) }
            }
            .padding(.horizontal, 30).padding(.bottom, 24)
        }
    }

    // MARK: 05 — Forgot / Reset

    private var reset: some View {
        VStack(spacing: 0) {
            backBar { go(.logIn) }
            VStack(alignment: .leading, spacing: 0) {
                Text("No trouble at all").font(.serif(30)).foregroundStyle(Meno.ink).padding(.bottom, 10)
                Text("Pop in your email and we\u{2019}ll send a link to set a new password. No rush.")
                    .font(.sans(16.5)).foregroundStyle(Meno.sub).lineSpacing(3).padding(.bottom, 26)
                obField("Email", text: $email)
            }
            .padding(.horizontal, 30).padding(.top, 8)
            .frame(maxHeight: .infinity, alignment: .top)

            obPrimary("Send reset link") { go(.logIn) }
                .padding(.horizontal, 30).padding(.bottom, 24)
        }
    }

    // MARK: 06 — Stage

    private let stages: [(String, String)] = [
        ("Perimenopause", "The shift has started"),
        ("Menopause", "In the thick of it"),
        ("Post-menopause", "On the other side"),
        ("Not sure yet", "That\u{2019}s okay too")
    ]

    private var stageStep: some View {
        VStack(spacing: 0) {
            // Living header — wordmark + step progress as soft dashes.
            HStack {
                Text("Meno").font(.serif(22)).foregroundStyle(Meno.clay).tracking(-0.2)
                Spacer()
                HStack(spacing: 6) {
                    Capsule().fill(Meno.clay).frame(width: 26, height: 5)
                    Capsule().fill(Meno.clay).frame(width: 26, height: 5)
                    Capsule().fill(Meno.ink.opacity(0.16)).frame(width: 9, height: 5)
                }
            }
            .padding(.horizontal, 26).padding(.top, 12).padding(.bottom, 6)
            .animation(nil, value: stage)

            ScrollView {
                VStack(spacing: 0) {
                    // A breath before the question — the clay orb sets the pace.
                    BreathingOrb(accent: Meno.clay, size: 60)
                        .padding(.top, 6).padding(.bottom, 14)
                    Text("Where are you right now?")
                        .font(.serif(31)).foregroundStyle(Meno.ink).tracking(-0.5)
                        .multilineTextAlignment(.center).lineSpacing(2)
                        .padding(.bottom, 10)
                        .menoFadeUp(delay: 0.2)
                    Text("There\u{2019}s no wrong answer \u{2014} and you can change this anytime.")
                        .font(.sans(16.5)).foregroundStyle(Meno.sub)
                        .multilineTextAlignment(.center).lineSpacing(3)
                        .padding(.bottom, 24)
                        .menoFadeUp(delay: 0.3)

                    VStack(spacing: 12) {
                        ForEach(Array(stages.enumerated()), id: \.element.0) { idx, s in
                            stageOption(s, index: idx)
                        }
                    }
                }
                .padding(.horizontal, 26).padding(.bottom, 20)
            }

            // Living footer — CTA + the always-pseudonymous reassurance.
            VStack(spacing: 14) {
                obPrimary("Next") { go(.life) }
                HStack(spacing: 7) {
                    Image(systemName: "lock.fill").font(.system(size: 12)).foregroundStyle(Meno.taupe)
                    Text("Always pseudonymous. No real names, ever.")
                        .font(.sans(13.5)).foregroundStyle(Meno.taupe)
                }
            }
            .padding(.horizontal, 26).padding(.top, 14).padding(.bottom, 24)
            .overlay(Rectangle().fill(Meno.hairline).frame(height: 1), alignment: .top)
        }
    }

    /// One stage choice: an animated radio dot that fills clay on selection,
    /// the card tinting and lifting with a soft shadow.
    private func stageOption(_ s: (String, String), index: Int) -> some View {
        let on = stage == s.0
        return Button {
            withAnimation(.easeInOut(duration: 0.4)) { stage = s.0 }
        } label: {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(on ? Meno.clay : Color.clear)
                        .overlay(Circle().strokeBorder(on ? Meno.clay : Meno.ink.opacity(0.25), lineWidth: 2))
                        .frame(width: 26, height: 26)
                    Circle().fill(Meno.surface).frame(width: 9, height: 9).opacity(on ? 1 : 0)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(s.0).font(.sans(19, .medium)).foregroundStyle(Meno.ink)
                    Text(s.1).font(.sans(14.5)).foregroundStyle(Meno.taupe)
                }
                Spacer(minLength: 0)
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(on ? Meno.claySoft : Meno.surface.opacity(0.78))
            .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(on ? Meno.clay : Meno.border, lineWidth: 1.5))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: on ? Meno.clay.opacity(0.18) : Meno.ink.opacity(0.04),
                    radius: on ? 14 : 6, x: 0, y: on ? 8 : 2)
        }
        .buttonStyle(MenoPress())
        .menoFadeUp(delay: 0.35 + Double(index) * 0.09)
    }

    // MARK: 07 — Life situation

    private let lifeOptions = ["Working", "Empty nest", "Caregiver", "Single", "Partnered", "Newly diagnosed", "Just exploring", "Raising teens"]

    private var lifeStep: some View {
        chipStep(stepIndex: 1, title: "What\u{2019}s your life like right now?",
                 sub: "Pick what fits — this helps us find your people.",
                 options: lifeOptions, selected: $life, next: { go(.pains) })
    }

    // MARK: 08 — What brought you here

    private let painOptions = ["Sleep", "Brain fog", "Mood", "Hot flashes", "Intimacy", "Work", "Identity", "Loneliness", "Anxiety", "Body changes"]

    private var painsStep: some View {
        chipStep(stepIndex: 2, title: "What brought you here?",
                 sub: "However you\u{2019}re feeling, you\u{2019}ll find women who feel it too.",
                 options: painOptions, selected: $pains, next: { go(.identity) })
    }

    // MARK: 09 — Private identity

    private let tones: [AvatarTone] = [.clay, .sage, .plum]

    private var identityStep: some View {
        VStack(spacing: 0) {
            progress(step: 3)
            VStack(alignment: .leading, spacing: 0) {
                Text("Choose how you\u{2019}ll show up").font(.serif(31)).foregroundStyle(Meno.ink).padding(.bottom, 8)
                Text("A name just for here. Never your real one.")
                    .font(.sans(16)).foregroundStyle(Meno.sub).padding(.bottom, 22)
                HStack(spacing: 12) {
                    ForEach(tones, id: \.self) { t in
                        Avatar(initial: String(name.prefix(1)).uppercased(), tone: t, size: 64)
                            .overlay(Circle().stroke(Meno.clay, lineWidth: tone == t ? 3 : 0))
                            .onTapGesture { tone = t }
                    }
                    Circle().fill(Meno.ink.opacity(0.08)).frame(width: 64, height: 64)
                        .overlay(Image(systemName: "plus").font(.system(size: 24)).foregroundStyle(Meno.muted))
                }
                .padding(.bottom, 20)
                obField("Anna", text: $name)
                HStack {
                    Text("Post anonymously by default")
                        .font(.sans(15.5, .bold)).foregroundStyle(Meno.sub)
                    Spacer()
                    MenoToggle(isOn: $anonymousDefault)
                }
                .padding(16)
                .background(Meno.claySoft.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.top, 16)
            }
            .padding(.horizontal, 30).padding(.top, 8)
            .frame(maxHeight: .infinity, alignment: .top)

            obPrimary("Continue") { go(.match) }
                .padding(.horizontal, 30).padding(.bottom, 24)
        }
    }

    // MARK: 10 — We found your people

    private var matchStep: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("We found your people").font(.serif(32)).foregroundStyle(Meno.ink).padding(.bottom, 8)
                Text("Small, private circles matched to your season.")
                    .font(.sans(16)).foregroundStyle(Meno.sub).padding(.bottom, 22)
                VStack(spacing: 14) {
                    matchCard(title: "Working Through It", meta: "Career mid-transition \u{00B7} 24 women", filled: true)
                    matchCard(title: "Foggy Days", meta: "Brain fog & focus \u{00B7} 19 women", filled: false)
                }
            }
            .padding(.horizontal, 26).padding(.top, 30)
            .frame(maxHeight: .infinity, alignment: .top)

            obTertiary("Explore more circles") { go(.notifications) }
                .padding(.horizontal, 30).padding(.bottom, 24)
        }
    }

    private func matchCard(title: String, meta: String, filled: Bool) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title).font(.serif(21)).foregroundStyle(Meno.ink).padding(.bottom, 3)
            Text(meta).font(.sans(14)).foregroundStyle(filled ? Meno.subtle : Meno.taupe).padding(.bottom, 14)
            Button { go(.notifications) } label: {
                Text("Join and say hello")
                    .font(.sans(16, .bold))
                    .foregroundStyle(filled ? Meno.surface : Meno.clay)
                    .frame(maxWidth: .infinity).frame(height: 48)
                    .background(filled ? Meno.clay : Color.clear)
                    .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(filled ? Color.clear : Meno.clay, lineWidth: 1.5))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .padding(18)
        .background(filled ? Meno.claySoft.opacity(0.85) : Meno.surface)
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
            .stroke(filled ? Meno.clay.opacity(0.22) : Meno.cardBorder, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    // MARK: 11 — Notifications permission

    private var notificationsStep: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Spacer()
                Circle().fill(Meno.claySoft).frame(width: 96, height: 96)
                    .overlay(Image(systemName: "bell").font(.system(size: 40, weight: .regular)).foregroundStyle(Meno.clay))
                    .padding(.bottom, 24)
                Text("So your circle can reach you").font(.serif(29)).foregroundStyle(Meno.ink)
                    .multilineTextAlignment(.center).padding(.bottom, 12)
                Text("We\u{2019}ll only nudge you when someone replies, or for a gentle daily check-in. Never spam.")
                    .font(.sans(17)).foregroundStyle(Meno.sub).multilineTextAlignment(.center)
                    .lineSpacing(3).frame(maxWidth: 280)
                Spacer()
            }
            .padding(.horizontal, 34)

            VStack(spacing: 12) {
                obPrimary("Turn on notifications") { go(.complete) }
                obTertiary("Maybe later") { go(.complete) }
            }
            .padding(.horizontal, 30).padding(.bottom, 24)
        }
    }

    // MARK: 12 — Complete

    private var complete: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Spacer()
                Circle().fill(Meno.clay).frame(width: 104, height: 104)
                    .overlay(Image(systemName: "checkmark").font(.system(size: 44, weight: .bold)).foregroundStyle(Meno.surface))
                    .padding(.bottom, 28)
                Text("You belong here, \(displayName).").font(.serif(32)).foregroundStyle(Meno.ink)
                    .multilineTextAlignment(.center).padding(.bottom, 12)
                Text("Your circle is waiting. Come and see what today felt like for everyone.")
                    .font(.sans(17)).foregroundStyle(Meno.sub).multilineTextAlignment(.center)
                    .lineSpacing(3).frame(maxWidth: 290)
                Spacer()
            }
            .padding(.horizontal, 34)

            obPrimary("Take me in") { finish() }
                .padding(.horizontal, 30).padding(.bottom, 24)
        }
    }

    // MARK: - Completion

    private var displayName: String {
        let n = name.trimmingCharacters(in: .whitespaces)
        return n.isEmpty ? "you" : n
    }

    private func finish() {
        let n = name.trimmingCharacters(in: .whitespaces)
        if !n.isEmpty {
            store.profile.displayName = n
            store.profile.initial = String(n.prefix(1)).uppercased()
        }
        store.profile.stage = stage
        store.profile.tone = tone
        onComplete()
    }

    // MARK: - Reusable bits

    private func chipStep(stepIndex: Int, title: String, sub: String,
                          options: [String], selected: Binding<Set<String>>,
                          next: @escaping () -> Void) -> some View {
        VStack(spacing: 0) {
            progress(step: stepIndex)
            VStack(alignment: .leading, spacing: 0) {
                Text(title).font(.serif(31)).foregroundStyle(Meno.ink).padding(.bottom, 8)
                Text(sub).font(.sans(16)).foregroundStyle(Meno.sub).padding(.bottom, 22)
                OnboardingChips(options: options, selected: selected)
            }
            .padding(.horizontal, 30).padding(.top, 8)
            .frame(maxHeight: .infinity, alignment: .top)

            obPrimary("Next", action: next)
                .padding(.horizontal, 30).padding(.bottom, 24)
        }
    }

    private func progress(step idx: Int) -> some View {
        HStack(spacing: 6) {
            ForEach(0..<4, id: \.self) { i in
                Capsule().fill(i <= idx ? Meno.clay : Meno.ink.opacity(0.16))
                    .frame(width: 22, height: 5)
            }
            Spacer()
        }
        .padding(.horizontal, 30).padding(.top, 6).padding(.bottom, 12)
    }

    private func backBar(_ action: @escaping () -> Void) -> some View {
        HStack {
            Button(action: action) {
                Image(systemName: "chevron.left").font(.system(size: 22)).foregroundStyle(Meno.faint)
            }
            Spacer()
        }
        .padding(.horizontal, 26).padding(.top, 6).padding(.bottom, 12)
    }

    private func obPrimary(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title).font(.sans(18, .bold)).foregroundStyle(Meno.surface)
                .frame(maxWidth: .infinity).frame(height: 56)
                .background(Meno.clay)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(MenoPress())
    }

    private func obTertiary(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title).font(.sans(16, .bold)).foregroundStyle(Meno.taupe)
                .frame(maxWidth: .infinity).frame(height: 50)
        }
        .buttonStyle(MenoPress())
    }

    private func obField(_ placeholder: String, text: Binding<String>, secure: Bool = false) -> some View {
        Group {
            if secure { SecureField(placeholder, text: text) }
            else { TextField(placeholder, text: text) }
        }
        .font(.sans(16.5)).foregroundStyle(Meno.ink)
        .textInputAutocapitalization(.never).autocorrectionDisabled()
        .padding(.horizontal, 16).frame(height: 54)
        .background(Meno.surface)
        .overlay(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous).stroke(Meno.border, lineWidth: 1.5))
        .clipShape(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous))
    }
}

/// Wrapping multi-select chip group used across onboarding.
private struct OnboardingChips: View {
    let options: [String]
    @Binding var selected: Set<String>
    var body: some View {
        FlexWrap(options, spacing: 11) { option in
            let on = selected.contains(option)
            Button {
                if on { selected.remove(option) } else { selected.insert(option) }
            } label: {
                Text(option)
                    .font(.sans(16, .bold)).foregroundStyle(on ? Meno.clay : Meno.sub)
                    .padding(.horizontal, 18).frame(minHeight: 48)
                    .background(on ? Meno.claySoft : Meno.surface)
                    .overlay(Capsule().stroke(on ? Meno.clay : Meno.border, lineWidth: 1.5))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview { OnboardingFlow().environmentObject(MenoStore()) }
