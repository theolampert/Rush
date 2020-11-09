//
//  App.swift
//  Rush
//
//  Created by Theo Lampert on 15.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI
import CocoaMQTT

struct MQTTConfiguration {
    var host: String
    var textPort: String
    var username: String
    var password: String
    var tls = true

    var port: UInt16 {
        UInt16(textPort)!
    }
}

struct Connection {
    let name: String
    let color: Color
    var config: MQTTConfiguration
}

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
                    MainToolbar(presenting: $presenting, autoscroll: store.autoscroll, clearMessages: store.clearMessages, toggleAutoscroll: { store.autoscroll.toggle() })
                        .environmentObject(store)
                }
        }.commands {
            SidebarCommands()
            ToolbarCommands()
        }
    }
}
