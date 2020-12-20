//
//  MessageDetailTabBody.swift
//  Rush
//
//  Created by Theo Lampert on 20.12.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

struct MessageDetailTabBody: View {
    enum TabState {
        case Raw
        case JSON
        case Tree
    }
    
    let selection: TabState
    let message: Message

    func renderBody() -> AnyView {
        switch selection {
        case .Raw:
            return HStack {
                TextEditor(text: .constant(message.value))
                    .foregroundColor(.secondary)
                    .font(Font(NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)))
                Spacer()
            }
            .padding(.horizontal, 5)
            .eraseToAnyView()
        case .JSON:
            return HStack {
                TextEditor(text: .constant(message.value.data(using: .utf8)?.prettyPrintedJSONString ?? "--"))
                    .foregroundColor(.secondary)
                    .font(Font(NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)))
                Spacer()
            }
            .padding(.horizontal, 5)
            .eraseToAnyView()
        case .Tree:
            return JSONView(JSONString: message.value).eraseToAnyView()
        }
    }
    
    var body: some View {
        renderBody()
    }
}
