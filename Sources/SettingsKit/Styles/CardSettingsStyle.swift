import SwiftUI

/// A settings style with card-based appearance.
public struct CardSettingsStyle: SettingsStyle {
    public init() {}

    public func makeContainer(configuration: ContainerConfiguration) -> some View {
        NavigationStack(path: configuration.navigationPath) {
            ScrollView {
                VStack(spacing: 16) {
                    configuration.content
                }
                .padding()
            }
            .navigationTitle(configuration.title)
            .navigationDestination(for: SettingsGroupConfiguration.self) { groupConfig in
                ScrollView {
                    VStack(spacing: 16) {
                        groupConfig.content
                    }
                    .padding()
                }
                .navigationTitle(groupConfig.title)
            }
        }
    }

    public func makeGroup(configuration: GroupConfiguration) -> some View {
        switch configuration.presentation {
        case .navigation:
            NavigationLink(value: configuration) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        configuration.label
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding()
                }
                .background(.background.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        case .inline:
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    configuration.label
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)

                configuration.content
                    .padding(.horizontal)

                if let footer = configuration.footer {
                    Text(footer)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
            }
            .background(.background.secondary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    public func makeItem(configuration: ItemConfiguration) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            configuration.label
                .font(.headline)
            configuration.content
        }
        .padding(.vertical, 4)
    }
}
