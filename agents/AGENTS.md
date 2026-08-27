All responses and output content must follow these writing style rules:
Write in ASD-STE100 style english that's easy to read. No antithesis. No corrective negation. No paragraph pinning. No parataxis. No summary beats. No rhetorical crutches. No negative parallelisms. No negative anaphoras. No contrasting pairs. No rule of three. No em dashes. No throat-clearing openers. No landing sentences. No setup/payoff constructions. No parallel sentence structures within a paragraph. Vary sentence length unpredictably. No stacked noun phrases. No filler intensifiers (genuinely, really, truly, actually). No corporate-register verbs (leverage, underscore, reflect). No nominalization. No hedging qualifiers. Write for the spoken voice. No performed enthusiasm.

# General

These rules apply to every task in this project unless explicitly overridden.
Bias: caution over speed on non-trivial work. Use judgment on trivial tasks.

## Rule 1 — Think Before Coding
State assumptions explicitly. If uncertain, ask rather than guess.
Present multiple interpretations when ambiguity exists.
Push back when a simpler approach exists.
Stop when confused. Name what's unclear.

## Rule 2 — Simplicity First
Minimum code that solves the problem. Nothing speculative.
No features beyond what was asked. No abstractions for single-use code.
Test: would a senior engineer say this is overcomplicated? If yes, simplify.

## Rule 3 — Surgical Changes
Touch only what you must. Clean up only your own mess.
Don't "improve" adjacent code, comments, or formatting.
Don't refactor what isn't broken. Match existing style.

## Rule 4 — Goal-Driven Execution
Define success criteria. Loop until verified.
Don't follow steps. Define success and iterate.
Strong success criteria let you loop independently.

## Rule 5 — Use the model only for judgment calls
Use me for: classification, drafting, summarization, extraction.
Do NOT use me for: routing, retries, deterministic transforms.
If code can answer, code answers.

## Rule 6 — Token budgets are not advisory
Per-task: 4,000 tokens. Per-session: 30,000 tokens.
If approaching budget, summarize and start fresh.
Surface the breach. Do not silently overrun.

## Rule 7 — Surface conflicts, don't average them
If two patterns contradict, pick one (more recent / more tested).
Explain why. Flag the other for cleanup.
Don't blend conflicting patterns.

## Rule 8 — Read before you write
Before adding code, read exports, immediate callers, shared utilities.
"Looks orthogonal" is dangerous. If unsure why code is structured a way, ask.

## Rule 9 — Tests verify intent, not just behavior
Tests must encode WHY behavior matters, not just WHAT it does.
A test that can't fail when business logic changes is wrong.

## Rule 10 — Checkpoint after every significant step
Summarize what was done, what's verified, what's left.
Don't continue from a state you can't describe back.
If you lose track, stop and restate.

## Rule 11 — Match the codebase's conventions, even if you disagree
Conformance > taste inside the codebase.
If you genuinely think a convention is harmful, surface it. Don't fork silently.

## Rule 12 — Fail loud
"Completed" is wrong if anything was skipped silently.
"Tests pass" is wrong if any were skipped.
Default to surfacing uncertainty, not hiding it.

# Swift/SwiftUI code

## unstructured (TODO)
- Use explicit types in property declarations, don't rely on type inference
- Don't use single line closures to make breakpointing easier

- Views should call out to endpoints on the viewmodel, don't impl. behavior in views

## Scope
- Prefer current APIs over legacy compatibility patterns unless older OS support is explicitly required
- Treat this as a practical baseline, not an exhaustive rulebook

## Always Prefer These Replacements
- `foregroundColor(...)` -> `foregroundStyle(...)`
- `cornerRadius(...)` -> `clipShape(.rect(cornerRadius: ...))`
- Old 1-parameter `onChange` -> new 0-parameter or 2-parameter `onChange` variants
- `NavigationView` -> `NavigationStack`
- Old `tabItem(...)` pattern -> modern `Tab` API
- `Task.sleep(nanoseconds: ...)` -> `Task.sleep(for: ...)` with duration values like `.seconds(1)`
- Manual Documents URL lookup -> `URL.documentsDirectory`
- `UIGraphicsImageRenderer` (for SwiftUI rendering) -> `ImageRenderer`
- `ForEach(Array(x.enumerated()), id: \.element.id)` -> `ForEach(x.enumerated(), id: \.element.id)`
- `.clipShape(Circle())` -> `.clipShape(.circle)`

## Closure semantics
- Always do the `guard let self else { return }` opener in closures that capture `weak self`

## SwiftUI Interaction and Accessibility Defaults
- Prefer `Button` over `onTapGesture` for tappable UI
- Use `onTapGesture` only when tap count or tap location is specifically required
- Prefer inline button labels with title + SF Symbol (`Button("Title", systemImage: "...")`) over image-only buttons
- Avoid accessibility regressions caused by gesture-driven controls and missing labels
- When breaking out parts, use `@ViewBuilder private func widget() -> some View { ... }`

## Observation, State, and View Structure
- Avoid splitting large views into computed-property `some View` fragments; extract real subviews/types instead
- Keep intelligent invalidation effective by using explicit subviews with `@Observable` data flow
- Use `.assign` vs `.sink` when you can so there's no need to store a Cancellable

## Typography and Text Formatting
- Avoid hardcoded fonts like `.font(.system(size: ...))` in most cases
- Prefer Dynamic Type-friendly text styles (`.body`, `.title`, etc.; optionally scaled styles on newer OSes)
- Don’t overuse `fontWeight(...)`; use semantically correct text styles and `bold()` intentionally
- Prefer Swift format styles over C-style formatting (`String(format: ...)` -> typed format styles such as `.number.precision(...)`)

## Navigation and Lists
- In lists, avoid inline destination `NavigationLink` style that couples creation and destination
- Prefer value-driven navigation with `navigationDestination(for:)` and related modern APIs

## Concurrency and Main Threading
- Do not paper over concurrency issues with repeated `DispatchQueue.main.async`
- Use modern concurrency: `async` functions and `Task` calls
- Try to keep `Task` outside viewmodels. Viewmodels should expose `async` functions and a `Task` is to be launched from the view
- Fix isolation and async boundaries directly rather than forcing main-queue hops

## Performance and Build Hygiene
- Do not pack many unrelated types into one file; split by responsibility to help compile times and maintainability
- Be skeptical of excessive `GeometryReader` usage and fixed frame sizes
- Prefer modern layout alternatives when possible (e.g. `visualEffect`, `containerRelativeFrame`, layout APIs that preserve adaptivity)
