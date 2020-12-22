//
//  MessageDetailViewModel.swift
//  Rush
//
//  Created by Theo Lampert on 21.12.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import Foundation
import Combine

class MessageDetailViewModel: ObservableObject {
    private let engine: MQTTEngine?
    private let selectedMesasgePublisher = NotificationCenter.Publisher(center: .default, name: .setSelectedMessage, object: nil)
    
    enum TabState {
        case raw
        case json
        case tree
    }
    
    @Published var message: Message? = nil
    @Published var tabSelection: TabState = .raw
    
    init(engine: MQTTEngine?) {
        self.engine = engine
        selectedMesasgePublisher
            .compactMap { $0.object as? Int }
            .map { engine?.messages[$0] }
            .assign(to: &$message)
    }
    
    func setMessage(index: Int) {
        message = engine?.messages[index]
    }
}
