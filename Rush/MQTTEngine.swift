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
    private final let client: CocoaMQTT = CocoaMQTT(clientID: "Rush")
    private final let monitor = NetworkMonitor()
    
    @Published final var messages: ContiguousArray<Message> = ContiguousArray()
    @Published final var topics: [Topic] = []
    @Published final var connectionStatus: ConnectionStatus = .disconnected
    @Published final var hostname: String? = nil
    
    final let queue = DispatchQueue(label: "mqtt", qos: .background)
    
    init() {
        // Setup client callbacks
        listenForConnectionStateChanges()
        listenForMessages()
        listenForNetworkChanges()
        
        client.dispatchQueue = queue
    }
    
    public func connect(config: MQTTConfiguration) {
        hostname = config.host
        
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
    
    private func listenForMessages() {
        client.didReceiveMessage = { [weak self] mqtt, payload, id in
            let message = Message(id: id, topic: payload.topic, value: payload.string ?? "", qos: payload.qos)
            DispatchQueue.main.async {
                self?.messages.append(message)
            }
        }
    }
    
    private func listenForConnectionStateChanges() {
        client.didChangeState = { [weak self] mqtt, state in
            DispatchQueue.main.async {
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
}
