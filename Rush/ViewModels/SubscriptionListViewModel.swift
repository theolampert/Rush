//
//  SubscriptionListViewModel.swift
//  Rush
//
//  Created by Theo Lampert on 21.12.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import Foundation

class SubscriptionListViewModel: ObservableObject {
    private let engine: MQTTEngine?
    
    @Published var topicList: [Topic] = []
    @Published var newTopic: String = ""
    
    init(engine: MQTTEngine?) {
        self.engine = engine
        engine?.$topics.assign(to: &$topicList)
    }
    
    func subscribe() {
        engine?.subscribeTopic(Topic(rawValue: newTopic))
    }
    
    func unsubscribe(topic: Topic) {
        engine?.unsubscribeTopic(topic)
    }
}
