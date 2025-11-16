import SwiftUI

/// Protocol representing any content that can appear in a settings hierarchy.
/// This includes both groups and individual items.
/// Conforms to View so SwiftUI properly installs @State and other property wrappers.
public protocol SettingsContent: View, Sendable {
    /// Convert this content into the internal node representation
    func makeNodes() -> [SettingsNode]
}

/// A container for settings content, typically the root-level settings view.
public protocol SettingsContainer {
    associatedtype Body: SettingsContent

    @SettingsContentBuilder
    var body: Body { get }
}

/// A group of settings that can contain both items and nested groups.
public protocol SettingsGroup: SettingsContent {
    associatedtype SettingsBody: SettingsContent

    /// The display title for this group
    var title: String { get }

    /// Optional SF Symbol icon name
    var icon: String? { get }

    /// Optional search tags for discoverability
    var tags: [String] { get }

    @SettingsContentBuilder
    var settingsBody: SettingsBody { get }
}

// Default implementations
public extension SettingsGroup {
    var icon: String? { nil }
    var tags: [String] { [] }

    // Implement View.body to return a NavigationLink with the content
    var body: some View {
        SettingsGroupView(title: title, icon: icon) {
            settingsBody
        }
    }

    func makeNodes() -> [SettingsNode] {
        [.group(
            id: UUID(),
            title: title,
            icon: icon,
            tags: tags,
            children: settingsBody.makeNodes()
        )]
    }
}

