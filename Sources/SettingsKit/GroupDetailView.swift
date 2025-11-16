import SwiftUI

/// View for rendering a group's content when navigated via deep link
struct GroupDetailView: View {
    let node: SettingsNode
    let allNodes: [SettingsNode]
    @State private var searchText = ""

    var body: some View {
        List {
            if searchText.isEmpty {
                ForEach(node.children ?? []) { child in
                    SearchResultView(node: child)
                }
            } else {
                ForEach(filteredResults) { result in
                    SearchResultView(node: result)
                }
            }
        }
        .navigationTitle(node.title)
        .searchable(text: $searchText, prompt: "Search \(node.title)")
    }

    var filteredResults: [SettingsNode] {
        var results: [SettingsNode] = []
        searchNodes(node.children ?? [], query: searchText.lowercased(), results: &results)
        return results
    }

    func searchNodes(_ nodes: [SettingsNode], query: String, results: inout [SettingsNode]) {
        for node in nodes {
            let matches = node.title.lowercased().contains(query) ||
                         node.tags.contains(where: { $0.lowercased().contains(query) })

            if matches {
                results.append(node)
            }

            if let children = node.children {
                searchNodes(children, query: query, results: &results)
            }
        }
    }
}
