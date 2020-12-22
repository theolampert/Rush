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
            Section(header: Text("Add a topic")) {
                HStack {
                    TextField("", text: $viewModel.newTopic)
                        .background(Color.gray.padding())
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(viewModel.newTopic.isEmpty ? .secondary : .green)
                        .onTapGesture(perform: viewModel.subscribe)
                }
            }
            Section(header: Text("Subscribed Topics")) {
                ForEach(viewModel.topicList, id: \.self, content: { topic in
                    HStack {
                        Image(systemName: "number")
                            .foregroundColor(.secondary)
                        Text(topic.rawValue)
                        Spacer()
                        Image(systemName: "multiply.circle.fill")
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
