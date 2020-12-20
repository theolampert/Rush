//
//  MessageDetail.swift
//  Rush
//
//  Created by Theo Lampert on 28.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import AppKit
import SwiftUI


struct MessageDetail: View {
    var selectedMessage: Message?
    var selectedHistory: [Float]

    @State private var selection: MessageDetailTabBody.TabState = .Raw
    
    let padding: CGFloat = 10

    var body: some View {
        VStack(alignment: .leading) {
            OptionalText(text: selectedMessage?.topic)
                .font(.footnote)
                .padding(.bottom)
                .foregroundColor(.gray)
                .padding(padding)
            Divider()
                .padding(padding)
            MessageDetailTabs(selection: $selection, message: selectedMessage)
            Divider()
                .padding(padding)
            VStack(alignment: .leading) {
                selectedMessage.map { message in
                    MessageDetailTabBody(selection: selection, message: message)
                }
                Spacer()
            }
            
        }
        .background(Color(NSColor.textBackgroundColor))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MessageDetail_Previews: PreviewProvider {
    static var previews: some View {
        MessageDetail(
            selectedMessage: Message(id: UUID(), topic: "dtck", value: "{\"sid\":{ \"foo\": \"bar\" }}", sizeLabel: "12 bytes", qos: .qos0, timestamp: 0.11),
            selectedHistory: []
        )
    }
}
