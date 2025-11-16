import SwiftUI

/// Internal wrapper that groups multiple SettingsContent items
public struct SettingsContentGroup: SettingsContent {
    let items: [SettingsContent]

    public init(_ items: [SettingsContent]) {
        self.items = items
    }

    public var body: some View {
        ForEach(Array(items.indices), id: \.self) { index in
            AnyView(erasing: items[index])
        }
    }

    private func AnyView(erasing view: any View) -> AnyView {
        SwiftUI.AnyView(view)
    }

    public func makeNodes() -> [SettingsNode] {
        items.flatMap { $0.makeNodes() }
    }
}
