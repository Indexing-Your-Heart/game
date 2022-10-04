//
//  SettingsView.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/15/22.
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

enum SettingsScreen: Codable {
    case debug
}

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
#if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
#endif
    @State private var selection: SettingsScreen? = .debug

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                NavigationLink(value: SettingsScreen.debug) {
                    Label("settings.debugging.title", systemImage: "ant")
                }
            }
            .navigationTitle("settings.name")
            .toolbar {
#if os(iOS)
                ToolbarItem {
                    if horizontalSizeClass == .compact {
                        dismissButton
                    }
                }
#endif
            }
        } detail: {
            Group {
                if let selection {
                    switch selection {
                    case .debug:
                        SettingsDebuggingView()
                    }
                } else {
                    Text("example.hello_world")
                }
            }
            .toolbar {
#if os(iOS)
                dismissButton
#endif
            }
        }
    }

    private var dismissButton: some View {
        Button {
            dismiss()
        } label: {
            Text("general.dismiss")
        }
    }
}
