//
//  MQTTEngine.swift
//  Rush
//
//  Created by Theo Lampert on 21.12.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

//import CocoaMQTT
import Foundation
import MQTTNIO

struct Topic: Codable, RawRepresentable, Hashable {
    var rawValue: String
}

final class MQTTEngine: ObservableObject {
//    private final let client: CocoaMQTT = CocoaMQTT(clientID: "Rush")
    private final var client: MQTTClient?
    private final let monitor = NetworkMonitor()
    
    @Published final var messages: ContiguousArray<Message> = ContiguousArray()
    @Published final var topics: [Topic] = []
    @Published final var connectionStatus: ConnectionStatus = .disconnected
    @Published final var hostname: String? = nil
    
    final let queue = DispatchQueue(label: "mqtt", qos: .background)
    
    public func connect(config: MQTTConfiguration) {
        connectionStatus = .connecting
        hostname = config.host
        
        client = MQTTClient(host: config.host, identifier: "Rush", eventLoopGroupProvider: .createNew)
        _ = try? client?.connect().wait()
        connectionStatus = .connected
        
        listenForConnectionStateChanges()
        listenForMessages()
        listenForNetworkChanges()
    }
    
    public func disconnect() {
        connectionStatus = .disconnected
        client = nil
        hostname = nil
        topics = []
    }
    
    public func subscribeTopic(_ topic: Topic) {
        topics = topics + [topic]
        let subscription = MQTTSubscribeInfo(
            topicFilter: topic.rawValue,
            qos: .atLeastOnce
        )
        try? client?.subscribe(to: [subscription]).wait()
    }

    public func unsubscribeTopic(_ topic: Topic) {
        topics = topics.filter { $0 != topic }
        client?.unsubscribe(from: [topic.rawValue])
    }
}

extension MQTTEngine {
    private func listenForNetworkChanges() {
        monitor.onChange { [weak self] status in
            self?.connectionStatus = status
        }
    }
    
    private func listenForMessages() {
//        client.didReceiveMessage = { [weak self] mqtt, payload, id in
//            let message = Message(id: id, topic: payload.topic, value: payload.string ?? "", qos: payload.qos)
//            DispatchQueue.main.async {
//                self?.messages.append(message)
//            }
//        }
        client?.addPublishListener(named: "My Listener") { [weak self] result in
            switch result {
            case .success(let publish):
                var buffer = publish.payload
                let string = buffer.readString(length: buffer.readableBytes)
                let message = Message(topic: publish.topicName, value: string ?? "", qos: publish.qos)
                DispatchQueue.main.async {
                    self?.messages.append(message)
                }
            case .failure(let error):
                print("Error while receiving PUBLISH event")
            }
        }
    }
    
    private func listenForConnectionStateChanges() {
//        client.didChangeState = { [weak self] mqtt, state in
//            DispatchQueue.main.async {
//                switch state {
//                case .initial:
//                    self?.connectionStatus = .disconnected
//                case .disconnected:
//                    self?.connectionStatus = .disconnected
//                case .connecting:
//                    self?.connectionStatus = .connecting
//                case .connected:
//                    self?.connectionStatus = .connected
//                }
//            }
//        }
    }
}
