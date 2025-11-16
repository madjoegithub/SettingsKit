import SwiftUI

/// Protocol representing any content that can appear in a settings hierarchy.
/// This includes both groups and individual items.
/// Conforms to View so SwiftUI properly installs @State and other property wrappers.
public protocol SettingsContent: View, Sendable {
    /// Convert this content into the internal node representation
    func makeNodes() -> [SettingsNode]
}

/// A container view for settings content.
public struct SettingsContainer<Content: SettingsContent>: View {
    let content: Content

    public init(@SettingsContentBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        SettingsView(content: content)
    }

    /// Get the node tree for search/navigation
    func makeNodes() -> [SettingsNode] {
        content.makeNodes()
    }
}
