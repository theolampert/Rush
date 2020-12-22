//
//  ConnectionStatusIndicator.swift
//  Rush
//
//  Created by Theo Lampert on 27.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

struct ConnectionStatusIndicator: View {
    @StateObject var viewModel: ConnectionStatusIndicatorViewModel

    var body: some View {
        HStack {
            Circle()
                .frame(width: 10, height: 10, alignment: .center)
                .foregroundColor(viewModel.status.label.1)
                .transition(.opacity)

            Text(viewModel.status.label.0)
                .font(.caption)
            if viewModel.hostname != nil {
                Divider()
                OptionalText(text: viewModel.hostname).font(.caption)
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(Color(NSColor.darkGray))
        )
    }
}

struct ConnectionStatusIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionStatusIndicator(viewModel: ConnectionStatusIndicatorViewModel(engine: nil))
    }
}
