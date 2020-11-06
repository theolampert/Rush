//
//  RushStore.swift
//  Rush
//
//  Created by Theo Lampert on 15.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import Foundation
import CocoaMQTT
import Network
import Combine

class RushStore: ObservableObject {
    var mqttClient: CocoaMQTT?
    let monitor = NetworkMonitor()

    @Published var selectedMessageIndex: Int = -1
    @Published var messages: [Message] = []
    @Published var connectionStatus: ConnectionStatus = .disconnected
    @Published var currentlyConnectedHostname: String?
    @Published var subscriptions: [String] = []

    var cancellables: [AnyCancellable] = []

    init(mqttClient: CocoaMQTT? = nil) {
        self.mqttClient = mqttClient
    }

    var selectedMessage: Message? {
        if selectedMessageIndex > -1 && !messages.isEmpty {
            return messages[selectedMessageIndex]
        }
        return nil
    }

    var selectedHistory: [Float] {
        return messages
            .filter { $0.topic == selectedMessage?.topic }
            .compactMap { Float($0.value) }
    }

    func clearMessages() {
        selectedMessageIndex = -1
        messages = []
    }

    func connectClient(mqttConfig: MQTTConfiguration) {
        if let mqttClient = mqttClient {
            mqttClient.disconnect()
        }

        self.mqttClient = CocoaMQTT(
            clientID: String(ProcessInfo().processIdentifier),
            host: mqttConfig.host,
            port: mqttConfig.port
        )

        mqttClient?.username = mqttConfig.username
        mqttClient?.password = mqttConfig.password
        mqttClient?.keepAlive = 60
        mqttClient?.enableSSL = mqttConfig.tls
//        mqttClient?.logLevel = .debug
        _ = mqttClient?.connect()

        mqttClient?.didChangeState = { mqtt, state in
            switch state {
            case .initial:
                self.connectionStatus = .disconnected
            case .disconnected:
                self.connectionStatus = .disconnected
            case .connecting:
                self.connectionStatus = .connecting
            case .connected:
                self.connectionStatus = .connected
            }
        }

        mqttClient?.didConnectAck = { mqtt, ack in

            self.monitor.onChange { status in
                self.connectionStatus = status
            }

            self.mqttClient?.didReceiveMessage = { mqtt, message, id in
                if let msg = message.string {
                    self.messages = self.messages + [Message(
                        id: UUID(),
                        topic: message.topic,
                        value: msg,
                        qos: message.qos,
                        timestamp: Date().timeIntervalSince1970
                    )]
                }
            }
        }
    }

    func subscribeTopic(_ topic: String) {
        subscriptions.append(topic)
        self.mqttClient?.subscribe(topic)
    }

    func unsubscribeTopic(_ topic: String) {
        subscriptions = subscriptions.filter { $0 != topic }
        self.mqttClient?.unsubscribe(topic)
    }
}

extension Array {
    public subscript(index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
        guard index >= 0, index < endIndex else {
            return defaultValue()
        }

        return self[index]
    }
}
