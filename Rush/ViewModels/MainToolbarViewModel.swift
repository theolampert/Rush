//
//  MainToolbarViewModel.swift
//  Rush
//
//  Created by Theo Lampert on 21.12.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let setAutoscroll = Notification.Name("set_autoscroll")
    static let setSelectedMessage = Notification.Name("set_selected_message")
}

final class MainToolbarViewModel: ObservableObject {
    private let engine: MQTTEngine?
    
    @Published var totalMessages: Int = 0
    @Published var connectionStatus: ConnectionStatus = .disconnected
    @Published var autoscroll: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .setAutoscroll, object: autoscroll)
        }
    }
    @Published var status: ConnectionStatus = .disconnected
    @Published var hostname: String? = nil
    
    init(engine: MQTTEngine?) {
        self.engine = engine
        
        engine?.$messages
            .throttle(for: .milliseconds(60), scheduler: RunLoop.main, latest: true)
            .map(\.count)
            .assign(to: &$totalMessages)
        
        engine?.$connectionStatus
            .assign(to: &$connectionStatus)
        
        engine?.$connectionStatus.assign(to: &$status)
        engine?.$hostname.assign(to: &$hostname)
    }
    
    func clearMessageHistory() {
        engine?.messages = []
    }
    
    func disconnectClient() {
        engine?.disconnect()
    }
}
