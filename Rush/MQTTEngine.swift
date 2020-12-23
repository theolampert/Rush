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

        listenForMessages()
        listenForNetworkChanges()
        
        subscribeTopic(Topic(rawValue: "$SYS/broker/publish/bytes/received"))
        subscribeTopic(Topic(rawValue: "$SYS/broker/publish/bytes/sent"))
        subscribeTopic(Topic(rawValue: "$SYS/broker/store/messages/count"))
        subscribeTopic(Topic(rawValue: "$SYS/broker/heap/current"))
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
        _ = try? client?.unsubscribe(from: [topic.rawValue]).wait()
    }
}

extension MQTTEngine {
    private func listenForNetworkChanges() {
        monitor.onChange { [weak self] status in
            self?.connectionStatus = status
        }
    }
    
    private func listenForMessages() {
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
}
