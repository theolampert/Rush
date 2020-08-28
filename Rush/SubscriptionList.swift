//
//  SubscriptionList.swift
//  Rush
//
//  Created by Theo Lampert on 15.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

struct SubscriptionList: View {
    var subscriptions: [String]

    var body: some View {
        List {
            Section(header: HStack {
                Image(systemName: "number.circle.fill")
                Text("Subscribed Topics")
            }) {
                ForEach(subscriptions, id: \.self, content: { subscription in
                    Text(subscription)
                        .font(.caption)
                })
            }
        }.listStyle(SidebarListStyle())
    }
}

struct SubscriptionList_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionList(subscriptions: ["dtck/foo/bar/#"])
    }
}
