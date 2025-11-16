import SwiftUI

/// Result builder for declaratively composing settings content.
@resultBuilder
public struct SettingsContentBuilder {
    @preconcurrency
    public static func buildBlock(_ components: SettingsContent...) -> SettingsContentGroup {
        SettingsContentGroup(Array(components))
    }

    @preconcurrency
    public static func buildArray(_ components: [SettingsContent]) -> SettingsContentGroup {
        SettingsContentGroup(components)
    }

    public static func buildOptional(_ component: SettingsContent?) -> SettingsContent {
        component ?? EmptySettingsContent()
    }

    public static func buildEither(first component: SettingsContent) -> SettingsContent {
        component
    }

    public static func buildEither(second component: SettingsContent) -> SettingsContent {
        component
    }

    @preconcurrency
    public static func buildExpression(_ expression: SettingsContent) -> SettingsContent {
        expression
    }

    // Allow arbitrary Views to be included (they just won't contribute to the node tree)
    @preconcurrency
    public static func buildExpression<V: View>(_ view: V) -> SettingsContent {
        ViewWrapper(view)
    }
}

/// Empty content for conditionals
struct EmptySettingsContent: SettingsContent {
    var body: some View {
        EmptyView()
    }

    func makeNodes() -> [SettingsNode] {
        []
    }
}

/// Wraps an arbitrary View as SettingsContent (doesn't contribute to search/navigation)
struct ViewWrapper: SettingsContent {
    nonisolated(unsafe) let content: AnyView

    nonisolated init<Content: View>(_ content: Content) {
        self.content = AnyView(content)
    }

    var body: some View {
        content
    }

    func makeNodes() -> [SettingsNode] {
        []
    }
}
