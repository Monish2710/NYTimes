//
//  TabBar Extensions.swift
//  NYTimesTask
//
//  Created by Monish Kumar on 02/09/24.
//

import SwiftUI

struct TabBarItemsPreferenceKey: PreferenceKey {
    static var defaultValue: [TabBarItem] = []

    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value += nextValue()
    }
}

struct TabBarItemViewModifier: ViewModifier {
    let tab: TabBarItem
    @Binding var selection: TabBarItem

    func body(content: Content) -> some View {
        content
            .opacity(selection == tab ? 1.0 : 0.0)
            .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
    }
}

extension View {
    func tabBarItem(tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
        modifier(TabBarItemViewModifier(tab: tab, selection: selection))
    }
}

enum TabBarItem: Hashable {
    case swiftUI, uikit

    var title: String {
        switch self {
        case .swiftUI: return "SwiftUI"
        case .uikit: return "UIKit"
        }
    }

    var color: Color {
        switch self {
        case .swiftUI: return Color.red
        case .uikit: return Color.green
        }
    }
}
