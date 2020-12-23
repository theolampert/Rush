//
//  ConnectionStatusIndicator.swift
//  Rush
//
//  Created by Theo Lampert on 21.12.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import Foundation

final class ConnectionStatusIndicatorViewModel: ObservableObject {
    private let engine: MQTTEngine?
    
    @Published var status: ConnectionStatus = .disconnected
    @Published var hostname: String? = nil
    
    init(engine: MQTTEngine?) {
        self.engine = engine
        
        engine?.$connectionStatus.assign(to: &$status)
        engine?.$hostname.assign(to: &$hostname)
    }
}
