import SwiftUI

/// Main view for rendering a settings container.
/// This will eventually support different styles via the environment.
public struct SettingsView<Container: SettingsContainer>: View {
    let container: Container
    @State private var searchText = ""
    @State private var allNodes: [SettingsNode] = []

    public init(_ container: Container) {
        self.container = container
    }

    public var body: some View {
        SettingsRenderView(content: container.body, searchText: $searchText, allNodes: $allNodes)
            .searchable(text: $searchText, prompt: "Search settings")
            .onAppear {
                // Build the searchable index
                allNodes = container.body.makeNodes()
            }
    }
}

/// Internal view that knows how to render SettingsContent with proper navigation
struct SettingsRenderView<Content: SettingsContent>: View {
    let content: Content
    @Binding var searchText: String
    @Binding var allNodes: [SettingsNode]

    var body: some View {
        List {
            if searchText.isEmpty {
                content
            } else {
                ForEach(filteredResults) { node in
                    SearchResultView(node: node)
                }
            }
        }
    }

    var filteredResults: [SettingsNode] {
        var results: [SettingsNode] = []
        flatSearchNodes(allNodes, query: searchText.lowercased(), results: &results)
        return results
    }

    func flatSearchNodes(_ nodes: [SettingsNode], query: String, results: inout [SettingsNode]) {
        for node in nodes {
            let matches = node.title.lowercased().contains(query) ||
                         node.tags.contains(where: { $0.lowercased().contains(query) })

            if matches {
                results.append(node)
            }

            // Recursively search children
            if let children = node.children {
                flatSearchNodes(children, query: query, results: &results)
            }
        }
    }

}

/// View for rendering a search result
struct SearchResultView: View {
    let node: SettingsNode
    let breadcrumb: String?

    init(node: SettingsNode, breadcrumb: String? = nil) {
        self.node = node
        self.breadcrumb = breadcrumb
    }

    var body: some View {
        switch node {
        case .group(_, let title, _, _, let children):
            // Render as a section with the group title as header
            Section(title) {
                ForEach(children) { child in
                    SearchResultView(node: child)
                }
            }

        case .item(_, _, let icon, _, let content):
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundStyle(.secondary)
                }
                content
            }
        }
    }
}

/// Internal view for rendering a single node (group or item)
struct NodeView: View {
    let node: SettingsNode

    var body: some View {
        switch node {
        case .group(_, let title, let icon, _, let children):
            // For groups, create a navigation link to a list of children
            NavigationLink {
                List {
                    ForEach(children) { child in
                        NodeView(node: child)
                    }
                }
                .navigationTitle(title)
            } label: {
                Label(title, systemImage: icon ?? "folder")
            }

        case .item(_, let title, let icon, _, let content):
            // For items, show the title/icon and render the user's view
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundStyle(.secondary)
                        .frame(width: 24)
                }
                content
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
