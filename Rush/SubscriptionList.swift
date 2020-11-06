//
//  SubscriptionList.swift
//  Rush
//
//  Created by Theo Lampert on 15.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

struct SubscriptionList: View {
    var topics: [String]
    var addTopic: (String) -> Void
    var removeTopic: (String) -> Void

    @State var topicName: String = ""

    var body: some View {
        List {
            HStack {
                TextField("Add a topic", text: $topicName)
                Button(action: {
                    self.addTopic(topicName)
                }, label: { Image(systemName: "plus.circle.fill") })
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
                            .onTapGesture {
                                self.removeTopic(topic)
                            }
                    }
                })
            }
        }.listStyle(SidebarListStyle())
    }
}

struct SubscriptionList_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionList(topics: ["dtck/foo/bar/#"], addTopic: { _ in }, removeTopic: { _ in })
    }
}
