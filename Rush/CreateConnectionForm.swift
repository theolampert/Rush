//
//  CreateConnectionForm.swift
//  Rush
//
//  Created by Theo Lampert on 05.11.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

struct CreateConnectionForm: View {
    @EnvironmentObject var store: RushStore
    @Binding var configuration: MQTTConfiguration

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

//struct CreateConnectionForm_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateConnectionForm(configuration: <#T##Binding<MQTTConfiguration>#>, onDismiss: <#T##() -> Void#>)
//    }
//}
