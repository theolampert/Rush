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

//struct MQTTConfiguration {
//    var host = "test.mosquitto.org"
//    var port: UInt16 = 1883
//    var username: String?
//    var password: String?
//    var tls = false
//}

struct CreateConnectionForm: View {
    @EnvironmentObject var store: RushStore
    @State var configuration: MQTTConfiguration

    var onDismiss: () -> Void

    var body: some View {
        VStack {
            Form {
                HStack {
                    TextField("Hostname", text: $configuration.host)
                    TextField("Port", text: $configuration.textPort)
                }
                HStack {
                    TextField("Username", text: $configuration.username)
                    SecureField("Password", text: $configuration.password)
                }
                Toggle("TLS", isOn: $configuration.tls)
                HStack {
                    Button("Cancel", action: {
                        onDismiss()
                    })
                    Button("Connect", action: {
                        store.connectClient(mqttConfig: configuration)
                        store.currentlyConnectedHostname = configuration.host
                        onDismiss()
                    })
                }
            }.padding()
        }
    }
}

struct Connection {
    let name: String
    let color: Color
    let config: MQTTConfiguration
}

struct ConnectionManager: View {
    @Environment(\.presentationMode) var presentationMode

    var availableConnections: [Connection] = [
        Connection(name: "Datacake", color: .green, config: MQTTConfiguration(
            host: "mqtt.datacake.co",
            textPort: "8883",
            username: "7be44bafd31e21c4b3f035bc62eec5d2dda1fb91",
            password: "7be44bafd31e21c4b3f035bc62eec5d2dda1fb91",
            tls: true
        )),
        Connection(name: "Mosuitto Test", color: .blue, config: MQTTConfiguration(
            host: "mqtt.datacake.co",
            textPort: "1883",
            username: "7be44bafd31e21c4b3f035bc62eec5d2dda1fb91",
            password: "7be44bafd31e21c4b3f035bc62eec5d2dda1fb91",
            tls: true
        ))
    ]

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(availableConnections, id: \.name) { connection in
                        HStack {
                            Circle()
                                .frame(width: 10, height: 10, alignment: .center)
                                .foregroundColor(connection.color)
                            Text(connection.name)
                        }
                    }
                }
            }
            CreateConnectionForm(
                configuration: MQTTConfiguration(
                    host: "mqtt.datacake.co",
                    textPort: "8883",
                    username: "7be44bafd31e21c4b3f035bc62eec5d2dda1fb91",
                    password: "7be44bafd31e21c4b3f035bc62eec5d2dda1fb91",
                    tls: true
                ),
                onDismiss: {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

@main
struct RushApp: App {
    @StateObject private var store = RushStore()
    @State private var presenting: Bool = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .sheet(isPresented: $presenting, content: {
                    ConnectionManager()
                })
                .environmentObject(store)
                .toolbar {
                    Text("\(store.messages.count) messages").font(.footnote)
                    Button(action: { store.clearMessages() }) {
                        Label("Clear Messages", systemImage: "trash.circle.fill")
                    }
                    ConnectionStatusIndicator(
                        status: store.connectionStatus,
                        hostname: store.currentlyConnectedHostname
                    )
                    MenuButton(label: Image(systemName: "dot.radiowaves.left.and.right")) {
                        Button("New Connection") {
                            self.presenting = true
                        }
                    }
                }
        }.commands {
            SidebarCommands()
            ToolbarCommands()
        }
    }
}
