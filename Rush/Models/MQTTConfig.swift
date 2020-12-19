//
//  MQTTConfig.swift
//  Rush
//
//  Created by Theo Lampert on 19.12.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import Foundation

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
