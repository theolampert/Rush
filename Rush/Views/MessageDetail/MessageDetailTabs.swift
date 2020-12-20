//
//  MessageDetailTabs.swift
//  Rush
//
//  Created by Theo Lampert on 20.12.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

struct MessageDetailTabs: View {
    @Binding var selection: MessageDetailTabBody.TabState
    let message: Message?
    
    var body: some View {
        HStack {
            HStack {
                Text("Raw")
                    .foregroundColor(selection == .Raw ? .white : .gray)
                    .onTapGesture {
                        self.selection = .Raw
                    }
                Text("JSON")
                    .foregroundColor(selection == .JSON ? .white : .gray)
                    .onTapGesture {
                        self.selection = .JSON
                    }
                Text("Tree View")
                    .foregroundColor(selection == .Tree ? .white : .gray)
                    .onTapGesture {
                        self.selection = .Tree
                    }
            }
            Spacer()
            Text("\(message?.formattedTimestamp ?? "--")")
                .font(.footnote)
        }.padding(.horizontal, 10)
    }
}
