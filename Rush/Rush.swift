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

struct ConnectionManager: View {
    @Environment(\.presentationMode) var presentationMode

    @State var selectedConnection: Connection = Connection(name: "", color: Color.orange, config: MQTTConfiguration(
        host: "",
        textPort: "8883",
        username: "",
        password: "",
        tls: true
    ))

    var availableConnections: [Connection] = [
        Connection(name: "Mosuitto Test", color: .blue, config: MQTTConfiguration(
            host: "test.mosquitto.org",
            textPort: "1883",
            username: "",
            password: "",
            tls: false
        )),
        Connection(name: "HiveMQ Test", color: .green, config: MQTTConfiguration(
            host: "broker.mqttdashboard.com",
            textPort: "8000",
            username: "",
            password: "",
            tls: false
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
                        }.onTapGesture {
                            selectedConnection = connection
                        }
                    }
                }
            }
            CreateConnectionForm(
                configuration: $selectedConnection.config,
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
