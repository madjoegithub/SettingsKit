import SwiftUI

/// Default rendering for a SettingsGroup - shows as a NavigationLink
public struct SettingsGroupView<Content: SettingsContent>: View {
    let title: String
    let icon: String?
    let group: SettingsGroup<Content>

    public init(title: String, icon: String?, group: SettingsGroup<Content>) {
        self.title = title
        self.icon = icon
        self.group = group
    }

    public var body: some View {
        NavigationLink {
            List {
                group.content
            }
            .navigationTitle(title)
        } label: {
            Label(title, systemImage: icon ?? "folder")
        }
    }
}

/// Rendering for inline SettingsGroup - shows as a Section
struct InlineGroupView<Content: SettingsContent>: View {
    let group: SettingsGroup<Content>
    let footer: String?

    var body: some View {
        Section {
            group.content
        } footer: {
            if let footer = footer {
                Text(footer)
            }
        }
    }
}
