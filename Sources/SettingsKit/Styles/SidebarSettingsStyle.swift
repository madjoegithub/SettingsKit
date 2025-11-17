import SwiftUI

/// A settings style using a split view with sidebar navigation.
public struct SidebarSettingsStyle: SettingsStyle {
    public init() {}
    
    public func makeContainer(configuration: ContainerConfiguration) -> some View {
        SidebarContainer(configuration: configuration)
    }
    
    public func makeGroup(configuration: GroupConfiguration) -> some View {
        switch configuration.presentation {
        case .navigation:
            NavigationLink(value: configuration) {
                configuration.label
            }
        case .inline:
            Section {
                configuration.content
            } footer: {
                if let footer = configuration.footer {
                    Text(footer)
                }
            }
        }
    }
    
    public func makeItem(configuration: ItemConfiguration) -> some View {
        configuration.content
    }
}

private struct SidebarContainer: View {
    let configuration: SettingsContainerConfiguration
    @State private var selectedGroup: SettingsGroupConfiguration?
    
    var body: some View {
        NavigationSplitView {
            if let searchText = configuration.searchText {
                List(selection: $selectedGroup) {
                    configuration.content
                }
                .navigationTitle(configuration.title)
                .searchable(text: searchText, prompt: "Search settings")
            } else {
                List(selection: $selectedGroup) {
                    configuration.content
                }
                .navigationTitle(configuration.title)
            }
        } detail: {
            if let selectedGroup {
                NavigationStack(path: configuration.navigationPath) {
                    List {
                        selectedGroup.content
                    }
                    .listStyle(.sidebar)
                    .navigationTitle(selectedGroup.title)
#if !os(tvOS) && !os(macOS)
                    .navigationBarTitleDisplayMode(.inline)
#endif
                    .navigationDestination(for: SettingsGroupConfiguration.self) { groupConfig in
                        List {
                            groupConfig.content
                        }
                        .navigationTitle(groupConfig.title)
#if !os(tvOS) && !os(macOS)
                        .navigationBarTitleDisplayMode(.inline)
#endif
                    }
                }
            } else {
                Text("Select a setting")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
