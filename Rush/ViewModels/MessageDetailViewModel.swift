//
//  MessageDetailViewModel.swift
//  Rush
//
//  Created by Theo Lampert on 21.12.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import Foundation

class MessageDetailViewModel: ObservableObject {
    private let engine: MQTTEngine?
    
    enum TabState {
        case raw
        case json
        case tree
    }
    
    @Published var message: Message? = nil
    @Published var tabSelection: TabState = .raw
    
    init(engine: MQTTEngine?) {
        self.engine = engine
    }
    
    func setMessage(index: Int) {
        message = engine?.messages[index]
    }
}
