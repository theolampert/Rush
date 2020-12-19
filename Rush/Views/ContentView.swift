//
//  ContentView.swift
//  Rush
//
//  Created by Theo Lampert on 02.07.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//
import Foundation
import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: RushStore

    var body: some View {
        NavigationView {
            SubscriptionList(topics: store.topics, addTopic: store.subscribeTopic, removeTopic: store.unsubscribeTopic)
                .equatable()
            VSplitView {
                MessageTableView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                MessageDetail(
                    selectedMessage: store.selectedMessage,
                    selectedHistory: store.selectedHistory
                )
            }
        }
    }
}
