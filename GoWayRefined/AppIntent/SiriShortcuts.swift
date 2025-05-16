//
//  SiriShortcuts.swift
//  GoWayRefined
//
//  Created by Gustavo Hoze Ercolesea on 16/05/25.
//


import AppIntents

// Provider for Siri-specific shortcuts
class SiriShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: FindVendorByTypeIntent(),
            phrases: [
                "browse vendors by type in \(.applicationName)",
                "show me food places in \(.applicationName)",
                "find vendor categories in \(.applicationName)"
            ],
            shortTitle: "Browse Vendors by Type",
            systemImageName: "square.grid.2x2"
        )
        AppShortcut(
            intent: FindBuildingIntent(),
            phrases: [
                "find a building in \(.applicationName)",
                "navigate to building using \(.applicationName)",
                "show me building details in \(.applicationName)"
            ],
            shortTitle: "Find Building",
            systemImageName: "building.2"
        )
        
        AppShortcut(
            intent: SiriFindBuildingIntent(),
            phrases: [
                "Where is [building] in \(.applicationName)",
                "Find [building] using \(.applicationName)",
                "I need directions to [building] in \(.applicationName)",
                "Take me to [building] in \(.applicationName)"
            ],
            shortTitle: "Voice Building Search",
            systemImageName: "building.2.fill"
        )
        AppShortcut(
            intent: SiriFindVendorIntent(),
            phrases: [
                "Where is [vendor] in \(.applicationName)",
                "Find [vendor] using \(.applicationName)",
                "I need directions to [vendor] in \(.applicationName)",
                "Take me to [vendor] in \(.applicationName)"
            ],
            shortTitle: "Voice Vendor Search",
            systemImageName: "shop.fill"
        )
        AppShortcut(
            intent: SiriFindVendorByTypeIntent(),
            phrases: [
                "Show me [vendor type] vendors in \(.applicationName)",
                "Where can I find [vendor type] in \(.applicationName)",
                "Browse [vendor type] in \(.applicationName)",
                "I'm looking for [vendor type] in \(.applicationName)"
            ],
            shortTitle: "Voice Category Browse",
            systemImageName: "square.grid.2x2.fill"
        )
        
    }
}
