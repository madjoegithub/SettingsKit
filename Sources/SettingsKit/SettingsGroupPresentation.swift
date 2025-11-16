import SwiftUI

/// The presentation mode for a settings group.
public enum SettingsGroupPresentation: Sendable {
    /// Display the group as a navigation link that navigates to a detail view.
    case navigation

    /// Display the group inline as a section.
    case inline
}
