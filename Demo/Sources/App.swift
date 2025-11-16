import SwiftUI
import SettingsKit

@main
struct SettingsKitDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SettingsView(DemoSettings())
                    .navigationTitle("Settings")
            }
        }
    }
}

struct DemoSettings: SettingsContainer {
    var body: some SettingsContent {
        GeneralSettings()
        AppearanceSettings()
        AdvancedSettings()
    }
}

struct GeneralSettings: SettingsGroup {
    @State private var appName = "My App"
    @State private var enableNotifications = true

    var title: String { "General" }
    var icon: String? { "gearshape" }

    var settingsBody: some SettingsContent {
        SettingsItem("App Name", icon: "app") {
            TextField("App Name", text: $appName)
        }

        SettingsItem("Enable Notifications", icon: "bell") {
            Toggle("Enable Notifications", isOn: $enableNotifications)
        }

        NotificationSettings()
    }
}

struct AppearanceSettings: SettingsGroup {
    @State private var darkMode = false

    var title: String { "Appearance" }
    var icon: String? { "paintbrush" }

    var settingsBody: some SettingsContent {
        SettingsItem("Dark Mode", icon: "moon.fill") {
            Toggle("Dark Mode", isOn: $darkMode)
        }
    }
}

struct AdvancedSettings: SettingsGroup {
    @State private var debugMode = false

    var title: String { "Advanced" }
    var icon: String? { "hammer" }

    var settingsBody: some SettingsContent {
        SettingsItem("Debug Mode", icon: "ladybug") {
            Toggle("Debug Mode", isOn: $debugMode)
        }
    }
}

struct NotificationSettings: SettingsGroup {
    @State private var soundEnabled = true

    var title: String { "Notification Settings" }
    var icon: String? { "bell.badge" }

    var settingsBody: some SettingsContent {
        SettingsItem("Sound", icon: "speaker.wave.2") {
            Toggle("Sound", isOn: $soundEnabled)
        }
    }
}
