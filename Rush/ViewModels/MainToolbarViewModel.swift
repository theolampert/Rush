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
    
    init(engine: MQTTEngine?) {
        self.engine = engine
        
        engine?.$messages
            .throttle(for: .milliseconds(250), scheduler: RunLoop.main, latest: true)
            .map(\.count)
            .assign(to: &$totalMessages)
        
        engine?.$connectionStatus
            .assign(to: &$connectionStatus)
    }
    
    func clearMessageHistory() {
        engine?.messages = []
    }
    
    func disconnectClient() {
        engine?.disconnect()
    }
}
