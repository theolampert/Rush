//
//  ConnectionStatusIndicator.swift
//  Rush
//
//  Created by Theo Lampert on 27.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

enum ConnectionStatus {
    case disconnected
    case connecting
    case connected

    var label: (String, Color) {
        switch self {
        case .disconnected:
            return ("Disconnected", .red)
        case .connecting:
            return ("Connecting", .orange)
        case .connected:
            return ("Connected", .green)
        }
    }
}

struct ConnectionStatusIndicator: View {
    let status: ConnectionStatus
    let hostname: String

    var body: some View {
        HStack {
            Circle()
                .frame(width: 10, height: 10, alignment: .center)
                .foregroundColor(status.label.1)
            Text("\(status.label.0) | \(hostname)").font(.caption)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(Color(NSColor.darkGray))
        )
    }
}

struct ConnectionStatusIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionStatusIndicator(status: .disconnected, hostname: "mqtt.datacake.de")
    }
}
