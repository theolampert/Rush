//
//  MessageDetailTabs.swift
//  Rush
//
//  Created by Theo Lampert on 20.12.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

struct MessageDetailTabs: View {
    @Binding var selection: MessageDetailViewModel.TabState
    let message: Message?
    
    var body: some View {
        HStack {
            HStack {
                Text("Raw")
                    .foregroundColor(selection == .raw ? .white : .gray)
                    .onTapGesture {
                        self.selection = .raw
                    }
                Text("JSON")
                    .foregroundColor(selection == .json ? .white : .gray)
                    .onTapGesture {
                        self.selection = .json
                    }
                Text("Tree View")
                    .foregroundColor(selection == .tree ? .white : .gray)
                    .onTapGesture {
                        self.selection = .tree
                    }
            }
            Spacer()
            Text("\(message?.formattedTimestamp ?? "--")")
                .font(.footnote)
        }.padding(.horizontal, 10)
    }
}
