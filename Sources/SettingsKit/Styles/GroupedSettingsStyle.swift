import SwiftUI

/// A settings style with grouped/inset appearance.
public struct GroupedSettingsStyle: SettingsStyle {
    public init() {}

    public func makeContainer(configuration: ContainerConfiguration) -> some View {
        NavigationStack(path: configuration.navigationPath) {
            Group {
                if let searchText = configuration.searchText {
                    List {
                        configuration.content
                    }
                    #if os(iOS)
                    .listStyle(.insetGrouped)
                    #endif
                    .navigationTitle(configuration.title)
                    .searchable(text: searchText, prompt: "Search settings")
                } else {
                    List {
                        configuration.content
                    }
                    #if os(iOS)
                    .listStyle(.insetGrouped)
                    #endif
                    .navigationTitle(configuration.title)
                }
            }
            .navigationDestination(for: SettingsGroupConfiguration.self) { groupConfig in
                List {
                    groupConfig.content
                }
                #if os(iOS)
                .listStyle(.insetGrouped)
                #endif
                .navigationTitle(groupConfig.title)
            }
        }
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
            } header: {
                configuration.label
            } footer: {
                if let footer = configuration.footer {
                    Text(footer)
                }
            }
        }
    }

    public func makeItem(configuration: ItemConfiguration) -> some View {
        HStack {
            configuration.label
            Spacer()
            configuration.content
        }
    }
}
