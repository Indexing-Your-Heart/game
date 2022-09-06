//
//  MainMenuView.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/6/22.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import SwiftUI

enum NavigationState {
    case mainMenu
    case game
}

struct ContentView: View {
    @State private var navigationState: NavigationState = .mainMenu
    var body: some View {
        Group {
            switch navigationState {
            case .mainMenu:
                ZStack {
                    Group {
                        Image("PrototypeMain")
                            .resizable()
                            .scaledToFill()
                        Color.black.opacity(0.1)
                    }
                    .edgesIgnoringSafeArea(.horizontal)
                    menu
                }
                .aspectRatio(16 / 9, contentMode: .fit)
            case .game:
                GameSceneView()
            }
        }
    }

    var menu: some View {
        VStack(spacing: 32) {
            Spacer()
            MenuTitle()
            VStack(spacing: 16) {
                Button {
                    withAnimation {
                        navigationState = .game
                    }
                } label: {
                    Text("example.demo_prompt")
                }
            }
            .buttonStyle(.plain)
            .font(.salmonEquivalent(for: .body))
            Spacer()
            Text("general.copyright")
                .font(.salmonEquivalent(for: .footnote))
                .padding(.bottom, 16)
        }
        .foregroundColor(.white)
    }
}

/// The main menu's game title.
private struct MenuTitle: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Text("general.app_name")
                .font(.salmonEquivalent(for: .largeTitle))
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
            Text("app_states.prototype")
                .font(.salmonEquivalent(for: .body))
                .textCase(.uppercase)
                .bold()
                .padding(.vertical, 2)
                .padding(.horizontal, 16)
                .background(
                    Capsule()
                        .fill(
                            Color("DebugColor").gradient
                                .shadow(.drop(radius: 2, y: 2))
                        )
                )
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 600)
    }
}
