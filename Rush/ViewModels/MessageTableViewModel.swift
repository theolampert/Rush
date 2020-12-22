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
    private let autoscrollPublisher = NotificationCenter.Publisher(center: .default, name: .setAutoscroll, object: nil)
    
    @Published var messages: [Message] = []
    @Published var autoscroll: Bool = false
    @Published var selectedMessageIndex: Int? = nil {
        didSet {
            NotificationCenter.default.post(name: .setSelectedMessage, object: selectedMessageIndex)
        }
    }
    
    init(engine: MQTTEngine) {
        self.engine = engine
        engine.$messages
//            .throttle(for: .seconds(0.25), scheduler: RunLoop.main, latest: true)
            .assign(to: &$messages)
        
        autoscrollPublisher
            .compactMap { $0.object as? Bool }
            .assign(to: &$autoscroll)
    }
}
