//
//  ContentView.swift
//  Rush
//
//  Created by Theo Lampert on 02.07.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//
import Foundation
import SwiftUI
import AppKit
import CocoaMQTT
import Charts

struct ContentView: View {
    @EnvironmentObject var store: RushStore

    var body: some View {
        NavigationView {
            SubscriptionList(subscriptions: store.subscriptions)
            VSplitView {
                MessageTableView(
                    messages: Array(store.messages).sorted { $0.id < $1.id },
                    selectedMessageIndex: $store.selectedMessageIndex
                )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                MessageDetail(
                    selectedMessage: store.selectedMessage,
                    selectedHistory: store.selectedHistory
                )
            }
        }
    }
}
