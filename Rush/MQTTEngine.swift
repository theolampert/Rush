//
//  MQTTEngine.swift
//  Rush
//
//  Created by Theo Lampert on 21.12.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import CocoaMQTT
import Foundation

struct Topic: Codable, RawRepresentable, Hashable {
    var rawValue: String
}

final class MQTTEngine: ObservableObject {
    private let client: CocoaMQTT = CocoaMQTT(clientID: "Rush")
    private let monitor = NetworkMonitor()
    
    @Published var messages: [Message] = []
    @Published var topics: [Topic] = []
    @Published var connectionStatus: ConnectionStatus = .disconnected
    @Published var hostname: String? = nil
    
    init() {
        // Setup client callbacks
        listenForConnectionStateChanges()
        listenForMessages()
        listenForConnectionAck()
        listenForNetworkChanges()
    }
    
    public func connect(config: MQTTConfiguration) {
        client.host = config.host
        client.port = config.port
        client.username = config.username
        client.password = config.password
        client.keepAlive = 60
        client.enableSSL = config.tls
        _ = client.connect()
    }
    
    public func disconnect() {
        client.disconnect()
        topics = []
    }
    
    public func subscribeTopic(_ topic: Topic) {
        topics = topics + [topic]
        client.subscribe(topic.rawValue)
    }

    public func unsubscribeTopic(_ topic: Topic) {
        topics = topics.filter { $0 != topic }
        client.unsubscribe(topic.rawValue)
    }
}

extension MQTTEngine {
    private func listenForNetworkChanges() {
        monitor.onChange { [weak self] status in
            self?.connectionStatus = status
        }
    }
    
    private func listenForConnectionAck() {
        self.hostname = client.host
    }
    
    private func listenForMessages() {
        client.didReceiveMessage = { [weak self] mqtt, payload, id in
            guard let value = payload.string else { return }
            let message = Message(id: UUID(), topic: payload.topic, value: value, qos: payload.qos)
            self?.messages.append(message)
        }
    }
    
    private func listenForConnectionStateChanges() {
        client.didChangeState = { [weak self] mqtt, state in
            switch state {
            case .initial:
                self?.connectionStatus = .disconnected
            case .disconnected:
                self?.connectionStatus = .disconnected
            case .connecting:
                self?.connectionStatus = .connecting
            case .connected:
                self?.connectionStatus = .connected
            }
        }
    }
}
