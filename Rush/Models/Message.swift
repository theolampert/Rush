//
//  Message.swift
//  Rush
//
//  Created by Theo Lampert on 15.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import Foundation
import CocoaMQTT

struct Message {
    let id: UInt16
    let topic: String
    let value: String
    let qos: CocoaMQTTQOS
    let timestamp: Double

    var formattedTimestamp: String {
        let date = Date(timeIntervalSince1970: self.timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "HH:mm:ss.SSSSSSZZ"
        return dateFormatter.string(from: date)
    }

    var topicName: String {
        return String(topic.split(separator: "/").last ?? "")
    }
}

extension Message: Hashable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
