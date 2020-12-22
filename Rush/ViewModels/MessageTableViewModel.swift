//
//  MessageTableViewModel.swift
//  Rush
//
//  Created by Theo Lampert on 21.12.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import Foundation

final class MessageTableViewModel: ObservableObject {
    private let engine: MQTTEngine
    
    @Published var messages: [Message] = []
    @Published var selectedMessageIndex: Int? = nil {
        didSet {
            NotificationCenter.default.post(name: .setSelectedMessage, object: selectedMessageIndex)
        }
    }
    
    init(engine: MQTTEngine) {
        self.engine = engine
        engine.$messages.assign(to: &$messages)
    }
}
