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
    var host = "mqtt.datacake.co"
    var port: UInt16 = 8883
    var username = "7be44bafd31e21c4b3f035bc62eec5d2dda1fb91"
    var password = "7be44bafd31e21c4b3f035bc62eec5d2dda1fb91"
    var tls = true
}

//struct MQTTConfiguration {
//    var host = "test.mosquitto.org"
//    var port: UInt16 = 1883
//    var username: String?
//    var password: String?
//    var tls = false
//}

@main
struct RushApp: App {
    let connectionConfig = MQTTConfiguration()
    @StateObject private var store = RushStore()

    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
            .toolbar {
                ConnectionStatusIndicator(
                    status: store.connectionStatus,
                    hostname: connectionConfig.host
                )
                Button(action: { store.clearMessages() }) {
                    Label("Clear Messages", systemImage: "trash")
                }
            }
            .onAppear {
                store.connectClient(mqttConfig: connectionConfig)
            }
        }
    }
}
