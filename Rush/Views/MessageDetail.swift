//
//  MessageDetail.swift
//  Rush
//
//  Created by Theo Lampert on 28.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import AppKit
import SwiftUI

struct JSONView: View {
    var JSONString: String

    var body: some View {
        let data = Data(JSONString.utf8)//TODO: potentiall ineficient
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            return AnyView(DisclosureTree(dict: json))
        } else {
            return AnyView(EmptyView())
        }
    }
}

struct MessageDetail: View {
    var selectedMessage: Message?
    var selectedHistory: [Float]

    @State private var selection: Int = 0
    
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
            HStack {
                HStack {
                    Text("Raw")
                        .foregroundColor(selection == 0 ? .white : .gray)
                        .onTapGesture {
                            self.selection = 0
                        }
                    Text("JSON")
                        .foregroundColor(selection == 1 ? .white : .gray)
                        .onTapGesture {
                            self.selection = 1
                        }
                    Text("Tree View")
                        .foregroundColor(selection == 2 ? .white : .gray)
                        .onTapGesture {
                            self.selection = 2
                        }
                }
                Spacer()
                Text("\(selectedMessage?.formattedTimestamp ?? "--")")
                    .font(.footnote)
            }.padding(.horizontal, padding)
            Divider()
                .padding(padding)
            VStack(alignment: .leading) {
                if selection == 0 {
                    selectedMessage.map { msg in
                        return HStack {
                            TextEditor(text: .constant(msg.value))
                                .foregroundColor(.secondary)
                                .font(Font(NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)))
                            Spacer()
                        }
                    }
                }
                if selection == 1 {
                    selectedMessage.map { msg in
                        return HStack {
                            TextEditor(text: .constant(msg.value.data(using: .utf8)?.prettyPrintedJSONString ?? "--"))
                                .foregroundColor(.secondary)
                                .font(Font(NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)))
                            Spacer()
                        }
                    }
                }
                if selection == 2 {
                    selectedMessage.map {
                        JSONView(JSONString: $0.value)
                    }
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
