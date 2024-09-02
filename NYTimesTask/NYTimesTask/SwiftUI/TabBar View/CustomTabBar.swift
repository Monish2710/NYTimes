//
//  CustomTabBar.swift
//  NYTimesTask
//
//  Created by Monish Kumar on 02/09/24.
//

import SwiftUI

struct AppTabBarView: View {
    @State private var selection: String = ""
    @State private var tabSelection: TabBarItem = .uikit

    var body: some View {
        CustomTabBarContainerView(selection: $tabSelection) {
            ListViewControllerWrapper()
                .tabBarItem(tab: .uikit, selection: $tabSelection)
            ListContentView()
                .tabBarItem(tab: .swiftUI, selection: $tabSelection)
        }
    }
}

struct CustomTabBarContainerView<Content: View>: View {
    @Binding var selection: TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem] = []

    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        _selection = selection
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .padding(.bottom, safeAreaInsets.bottom + 50)
            CustomTabBarView(tabs: tabs, selection: $selection, localSelection: selection)
                .padding(.bottom, safeAreaInsets.bottom)
                .background(Color.white)
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
            self.tabs = value
        }
    }
}

struct CustomTabBarView: View {
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @Namespace private var namespace
    @State var localSelection: TabBarItem

    var body: some View {
        tabBarView
            .onChange(of: selection, { _, newValue in
                withAnimation(.easeInOut) {
                    localSelection = newValue
                }
            })
    }

    private func tabView(tab: TabBarItem) -> some View {
        VStack {
            Text(tab.title)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
        }
        .foregroundColor(localSelection == tab ? tab.color : Color.gray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                if localSelection == tab {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(tab.color.opacity(0.2))
                        .matchedGeometryEffect(id: "background_rectangle", in: namespace)
                }
            }
        )
    }

    private var tabBarView: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab)
                    .onTapGesture {
                        switchTab(tab: tab)
                    }
            }
        }
        .padding(6)
        .background(
            Color.white.ignoresSafeArea(edges: .bottom)
        )
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }

    private func switchTab(tab: TabBarItem) {
        selection = tab
        withAnimation(.easeInOut) {
        }
    }
}
