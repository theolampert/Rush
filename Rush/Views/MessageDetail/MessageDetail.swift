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
    @StateObject var viewModel: MessageDetailViewModel
    
    private let padding: CGFloat = 10

    var body: some View {
        VStack(alignment: .leading) {
            OptionalText(text: viewModel.message?.topic)
                .font(.footnote)
                .padding(.bottom)
                .foregroundColor(.gray)
                .padding(padding)
            Divider().padding(padding)
            MessageDetailTabs(selection: $viewModel.tabSelection, message: viewModel.message)
            Divider().padding(padding)
            VStack(alignment: .leading) {
                viewModel.message.map { message in
                    MessageDetailTabBody(selection: viewModel.tabSelection, message: message)
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
        MessageDetail(viewModel: MessageDetailViewModel(engine: nil))
    }
}
