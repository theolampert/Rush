//
//  App.swift
//  Rush
//
//  Created by Theo Lampert on 15.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI
import CocoaMQTT

private let store = RushStore()

@main
struct RushApp: App {
    @State var presenting: Bool = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .sheet(isPresented: $presenting, content: {
                    ConnectionManager(onConnect: { conf in
                        store.connectClient(mqttConfig: conf)
                    })
                })
                .environmentObject(store)
                .toolbar {
                    MainToolbar(presenting: $presenting)
                        .environmentObject(store)
                }
        }.commands {
            SidebarCommands()
            ToolbarCommands()
        }
    }
}
