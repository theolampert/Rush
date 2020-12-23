//
//  SubscriptionList.swift
//  Rush
//
//  Created by Theo Lampert on 15.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

struct SubscriptionList: View {
    @StateObject var viewModel: SubscriptionListViewModel

    var body: some View {
        List {
            Section(header: Text("Subscribe to topic")) {
                HStack {
                    TextField("Topic Name", text: $viewModel.newTopic)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(viewModel.newTopic.isEmpty ? .secondary : .green)
                        .onTapGesture(perform: viewModel.subscribe)
                }
            }
            Section(header: HStack {
                Image(systemName: "star")
                Text("Favourite topics")
            }) {
                ForEach([Topic(rawValue: "mtech/iot/2020"), Topic(rawValue: "digitransit")], id: \.self, content: { topic in
                    HStack {
                        Image(systemName: "number")
                            .foregroundColor(.secondary)
                        Text(topic.rawValue).foregroundColor(.secondary)
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(.secondary)
                            .onTapGesture {
                                self.viewModel.newTopic = topic.rawValue
                                self.viewModel.subscribe()
                            }
                    }
                })
            }
            Section(header: HStack {
                Image(systemName: "clock")
                Text("Recent topics")
            }) {
                ForEach([Topic(rawValue: "mtech/iot/2020"), Topic(rawValue: "digitransit")], id: \.self, content: { topic in
                    HStack {
                        Image(systemName: "number")
                            .foregroundColor(.secondary)
                        Text(topic.rawValue).foregroundColor(.secondary)
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(.secondary)
                            .onTapGesture {
                                self.viewModel.newTopic = topic.rawValue
                                self.viewModel.subscribe()
                            }
                    }
                })
            }
            Section(header: Text("Subscribed Topics")) {
                ForEach(viewModel.topicList, id: \.self, content: { topic in
                    HStack {
                        Image(systemName: "number")
                            .foregroundColor(.secondary)
                        Text(topic.rawValue).foregroundColor(.secondary)
                        Spacer()
                        Image(systemName: "multiply")
                            .foregroundColor(.secondary)
                            .onTapGesture {
                                self.viewModel.unsubscribe(topic: topic)
                            }
                    }
                })
            }
        }.listStyle(SidebarListStyle())
    }
}

struct SubscriptionList_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionList(viewModel: SubscriptionListViewModel(engine: nil))
    }
}
