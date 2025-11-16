import SwiftUI

/// A group of settings that can contain both items and nested groups.
public struct SettingsGroup<Content: SettingsContent>: SettingsContent {
    let id: UUID
    let title: String
    let icon: String?
    let footer: String?
    var tags: [String]
    var style: SettingsGroupStyle
    let content: Content

    public init(
        _ title: String,
        systemImage: String? = nil,
        footer: String? = nil,
        @SettingsContentBuilder content: () -> Content
    ) {
        self.id = UUID()
        self.title = title
        self.icon = systemImage
        self.footer = footer
        self.tags = []
        self.style = .navigation
        self.content = content()
    }

    public var body: some View {
        Group {
            switch style {
            case .navigation:
                SettingsGroupView(title: title, icon: icon, group: self)
            case .inline:
                InlineGroupView(group: self, footer: footer)
            }
        }
    }

    public func makeNodes() -> [SettingsNode] {
        let children = content.makeNodes()

        if style == .inline {
            // Inline groups are transparent but their children inherit the inline group's title/tags for search
            return children.map { child in
                switch child {
                case .group(let id, let childTitle, let icon, let childTags, let grandchildren):
                    return .group(
                        id: id,
                        title: childTitle,
                        icon: icon,
                        tags: childTags + tags + [title],
                        children: grandchildren
                    )
                case .item(let id, let childTitle, let icon, let childTags, let searchable, let content):
                    return .item(
                        id: id,
                        title: childTitle,
                        icon: icon,
                        tags: childTags + tags + [title],
                        searchable: searchable,
                        content: content
                    )
                }
            }
        } else {
            return [.group(
                id: id,
                title: title,
                icon: icon,
                tags: tags,
                children: children
            )]
        }
    }
}

// MARK: - Modifiers

public extension SettingsGroup {
    func settingsTags(_ tags: [String]) -> Self {
        var copy = self
        copy.tags = tags
        return copy
    }

    func settingsStyle(_ style: SettingsGroupStyle) -> Self {
        var copy = self
        copy.style = style
        return copy
    }
}
