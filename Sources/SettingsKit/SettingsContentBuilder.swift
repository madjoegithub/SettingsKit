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

    public static func buildExpression(_ expression: SettingsContent) -> SettingsContent {
        expression
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
