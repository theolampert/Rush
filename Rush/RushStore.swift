//
//  RushStore.swift
//  Rush
//
//  Created by Theo Lampert on 15.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import Foundation
import Network
import Combine
import CocoaMQTT

extension Array {
    var isNotEmpty: Bool { !isEmpty }
}

final class RushStore: ObservableObject {
    private let mqttEngine: MQTTEngine
    private let monitor = NetworkMonitor()

    @Published var selectedMessageIndex: Int = -1
    @Published var autoscroll: Bool = false
    
    init(engine: MQTTEngine) {
        self.mqttEngine = engine
    }
    
    var selectedMessage: Message? {
        if selectedMessageIndex > -1 && mqttEngine.messages.isNotEmpty {
            return mqttEngine.messages[selectedMessageIndex]
        }
        return nil
    }

//    var selectedHistory: [Float] {
//        return mqttEngine.messages
//            .filter { $0.topic == selectedMessage?.topic }
//            .compactMap { Float($0.value) }
//    }

    func clearMessages() {
        selectedMessageIndex = -1
        mqttEngine.messages.removeAll()
    }

    func subscribeTopic(_ topic: Topic) {
        mqttEngine.subscribeTopic(topic)
    }

    func unsubscribeTopic(_ topic: Topic) {
        mqttEngine.unsubscribeTopic(topic)
    }
}
