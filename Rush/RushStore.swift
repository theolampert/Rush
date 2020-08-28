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

class RushStore: ObservableObject {
    var mqttClient: CocoaMQTT?
    let monitor = NetworkMonitor()

    @Published var selectedMessageIndex: Int = -1
    @Published var messages: [Message] = []
    @Published var connectionStatus: ConnectionStatus = .disconnected

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

    var subscriptions: [String] {
        guard let client = mqttClient else { return [] }
        return Array(client.subscriptions.keys)
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

            self.mqttClient?.subscribe("dtck/mqtt-timeout-device/e9e7fa09-7cd2-4ca1-91dd-4a914c85590c/#")
            self.mqttClient?.subscribe("dtck/masterbrick-p1-3d0026001951353530353431/aeccc67f-461f-44f2-b2b4-a8dca9cb3219/#")
//            self.mqttClient?.subscribe("Minion Lair")
            self.mqttClient?.didReceiveMessage = { mqtt, message, id in
                if let msg = message.string {
                    self.messages = self.messages + [Message(
                        id: id,
                        topic: message.topic,
                        value: msg,
                        qos: message.qos,
                        timestamp: Date().timeIntervalSince1970
                    )]
                }
            }
        }
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
