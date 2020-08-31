//
//  ConnectionStatus.swift
//  Rush
//
//  Created by Theo Lampert on 28.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import Foundation
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
