//
//  ConnectionManager.swift
//  Rush
//
//  Created by Theo Lampert on 06.11.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

struct ConnectionManager: View {
    @Environment(\.presentationMode) var presentationMode

    var onConnect: (MQTTConfiguration) -> Void

    @State var selectedConnection: Connection = Connection(name: "", color: Color.orange, config: MQTTConfiguration(
        host: "test.mosquitto.org",
        textPort: "1883",
        username: "",
        password: "",
        tls: false
    ))

    var availableConnections: [Connection] = [
        Connection(name: "Mosuitto Test", color: .blue, config: MQTTConfiguration(
            host: "test.mosquitto.org",
            textPort: "1883",
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
                onConnect: onConnect,
                configuration: $selectedConnection.config,
                onDismiss: {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct ConnectionManager_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionManager(onConnect: { _ in })
    }
}
