import SwiftUI

/// A group of settings that can contain both items and nested groups.
public struct SettingsGroup<Content: SettingsContent>: SettingsContent {
    let id: UUID
    let title: String
    let icon: String?
    let footer: String?
    var tags: [String]
    let presentation: SettingsGroupPresentation
    let content: Content

    public init(
        _ title: String,
        _ presentation: SettingsGroupPresentation = .navigation,
        systemImage: String? = nil,
        footer: String? = nil,
        @SettingsContentBuilder content: () -> Content
    ) {
        self.id = UUID()
        self.title = title
        self.icon = systemImage
        self.footer = footer
        self.tags = []
        self.presentation = presentation
        self.content = content()
    }

    public var body: some View {
        StyledSettingsGroup(
            title: title,
            icon: icon,
            footer: footer,
            presentation: presentation,
            content: content
        )
    }

    public func makeNodes() -> [SettingsNode] {
        let children = content.makeNodes()

        return [.group(
            id: id,
            title: title,
            icon: icon,
            tags: tags,
            children: children
        )]
    }
}

// MARK: - Styled Group View

/// Internal view that applies the current group style from the environment.
struct StyledSettingsGroup<Content: SettingsContent>: View {
    let title: String
    let icon: String?
    let footer: String?
    let presentation: SettingsGroupPresentation
    let content: Content

    @Environment(\.settingsStyle) private var style

    var body: some View {
        style.makeGroup(
            configuration: SettingsGroupConfiguration(
                title: title,
                icon: icon,
                footer: footer,
                presentation: presentation,
                content: AnyView(content)
            )
        )
    }
}

// MARK: - Modifiers

public extension SettingsGroup {
    /// Adds tags to the settings group for improved searchability.
    func settingsTags(_ tags: [String]) -> Self {
        var copy = self
        copy.tags = tags
        return copy
    }
}
