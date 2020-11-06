//
//  MessageDetail.swift
//  Rush
//
//  Created by Theo Lampert on 28.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

struct MessageDetail: View {
    var selectedMessage: Message?
    var selectedHistory: [Float]

    var body: some View {
        VStack(alignment: .leading) {
            OptionalText(text: selectedMessage?.topic)
                .font(.footnote)
                .padding(.bottom)
                .foregroundColor(.gray)
            HStack {
                TextPill(text: selectedMessage?.topicName)
                Spacer()
                Text("Time: \(selectedMessage?.formattedTimestamp ?? "--")")
                    .font(.footnote)
            }
            Divider()
            selectedMessage.map {
                Text($0.value.data(using: .utf8)?.prettyPrintedJSONString ?? "--")
                    .font(Font(NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)))
            }
            Spacer()
            if !selectedHistory.isEmpty {
                Histogram(data: selectedHistory)
            }
        }.padding()
            .background(Color(NSColor.textBackgroundColor))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MessageDetail_Previews: PreviewProvider {
    static var previews: some View {
        MessageDetail(
            selectedMessage: Message(id: UUID(), topic: "dtck", value: "foobar", qos: .qos0, timestamp: 0.11),
            selectedHistory: []
        )
    }
}
