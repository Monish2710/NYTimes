//
//  LaunchScreen.swift
//  NYTimesTask
//
//  Created by Monish Kumar on 02/09/24.
//

import Foundation
import SwiftUI

@main
struct LaunchScreen: App {
    var body: some Scene {
        WindowGroup {
            LaunchContentView()
        }
    }
}

struct LaunchContentView: View {
    @State var isHomeRootScreen = false
    @State var scaleAmount: CGFloat = 1

    var body: some View {
        ZStack {
            Color(.white)
            if isHomeRootScreen {
                HomeScreenView()
            } else {
                Image("splashBird")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scaleAmount)
                    .frame(width: 80)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                scaleAmount = 0.6
            }
            withAnimation(.easeInOut(duration: 1).delay(0.5)) {
                scaleAmount = 80
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                isHomeRootScreen = true
            }
        }
    }
}

struct HomeScreenView: View {
    var body: some View {
        AppTabBarView()
    }
}
