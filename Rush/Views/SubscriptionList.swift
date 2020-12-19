//
//  SubscriptionList.swift
//  Rush
//
//  Created by Theo Lampert on 15.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

struct TopicPill: View {
    var topic: String

    var body: some View {
        return topic.split(separator: "/").reduce(Text(""), { $0 + Text($1) + Text(" → ") })
    }
}

struct SubscriptionList: View, Equatable {
    var topics: [String]
    var addTopic: (String) -> Void
    var removeTopic: (String) -> Void

    @State var topicName: String = ""

    var body: some View {
        List {
            HStack {
                TextField("Add a topic", text: $topicName)
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(topicName.isEmpty ? .secondary : .green)
                    .onTapGesture {
                        if !topicName.isEmpty {
                            self.addTopic(topicName)
                            self.topicName = ""
                        }
                    }
            }
            Section(header: HStack {
                Image(systemName: "number.circle.fill")
                Text("Subscribed Topics")
            }) {
                ForEach(topics, id: \.self, content: { topic in
                    HStack {
                        Text(topic)
                        Spacer()
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.red)
                            .onTapGesture {
                                self.removeTopic(topic)
                            }
                    }
                })
            }
        }.listStyle(SidebarListStyle())
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.topics.count == rhs.topics.count
    }
}

struct SubscriptionList_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionList(topics: ["dtck/foo/bar/#"], addTopic: { _ in }, removeTopic: { _ in })
    }
}
