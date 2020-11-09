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
    @Published var topics: [String] = []
    @Published var autoscroll: Bool = false

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
        messages.removeAll()
    }

    func connectClient(mqttConfig: MQTTConfiguration) {
        if let mqttClient = mqttClient {
            mqttClient.disconnect()
        }

        self.currentlyConnectedHostname = mqttConfig.host

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

        mqttClient?.didChangeState = { [weak self] mqtt, state in
            guard self != nil else { return }
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

        mqttClient?.didReceiveMessage = { [weak self] mqtt, message, id in
            guard self != nil else { return }
            let bcf = ByteCountFormatter()
            bcf.allowedUnits = [.useBytes]
            bcf.countStyle = .file
            let size = bcf.string(fromByteCount: Int64(message.payload.count))
            if let msg = message.string {
                self?.messages.append(
                    Message(
                        id: UUID(),
                        topic: message.topic,
                        value: msg,
                        sizeLabel: size,
                        qos: message.qos,
                        timestamp: Date().timeIntervalSince1970
                    )
                )
            }
        }

        monitor.onChange { [weak self] status in
            self?.connectionStatus = status
        }

        mqttClient?.didConnectAck = { [weak self] mqtt, ack in
            guard self != nil else { return }

//            self?.subscribeTopic("/fmeag/#")
//            self?.subscribeTopic("ag2000/Nora/home-assistant/weather/smhi_home/forecast")
//            self?.subscribeTopic("EBO/Data")
            self?.subscribeTopic("#")

        }
    }

    func subscribeTopic(_ topic: String) {
        topics = topics + [topic]
        self.mqttClient?.subscribe(topic)
    }

    func unsubscribeTopic(_ topic: String) {
        topics = topics.filter { $0 != topic }
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
