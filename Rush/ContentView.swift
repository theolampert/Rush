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
    @ObservedObject var store: RushStore

    var body: some View {
        NavigationView {
            SubscriptionList(subscriptions: store.subscriptions)
            VSplitView {
                MessageTableView(
                    messages: Array(store.messages).sorted { $0.id < $1.id },
                    selectedMessageIndex: $store.selectedMessageIndex
                )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                VStack(alignment: .leading) {
                    OptionalText(text: store.selectedMessage?.topic)
                        .font(.footnote)
                        .padding(.bottom)
                        .foregroundColor(.gray)
                    HStack {
                        TextPill(text: store.selectedMessage?.topicName)
                        Spacer()
                        Text("Time: \(store.selectedMessage?.formattedTimestamp ?? "--")")
                            .font(.footnote)
                    }
                    Divider()
                    Text("\(store.selectedMessage?.value.data(using: .utf8)?.prettyPrintedJSONString ?? "--")")
                        .font(Font(NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)))
                        .foregroundColor(.gray)
                    Spacer()
                    if store.selectedHistory.count > 1 {
                        Histogram(data: store.selectedHistory)
                    }
                }.padding()
                    .background(Color(NSColor.textBackgroundColor))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? { // NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil
        }
        return prettyPrintedString
    }
}
