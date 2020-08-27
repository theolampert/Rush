//
//  SubscriptionList.swift
//  Rush
//
//  Created by Theo Lampert on 15.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

extension RangeReplaceableCollection where Self: StringProtocol {
    func paddingToLeft(upTo length: Int, using element: Element = "-") -> SubSequence {
        return repeatElement(element, count: Swift.max(0, length-count)) + suffix(Swift.max(count, count-length))
    }
}

struct SubscriptionList: View {
    var subscriptions: [String]

    var body: some View {
        List {
            Section(header: HStack {
                Image(systemName: "staroflife.fill")
                Text("Subscriptions")
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
