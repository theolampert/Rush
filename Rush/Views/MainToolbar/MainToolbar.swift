//
//  MainToolbar.swift
//  Rush
//
//  Created by Theo Lampert on 06.11.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

fileprivate struct MessageCountIndicator: View {
    var count: Int

    var body: some View {
        Text("\(count) messages").font(.footnote)
    }
}

struct MainToolbar: View {
    @Binding var presenting: Bool
    @StateObject var viewModel: MainToolbarViewModel

    var body: some View {
        MessageCountIndicator(count: viewModel.totalMessages)
        Button(action: viewModel.clearMessageHistory) {
            Label("Clear Messages", systemImage: "trash.circle.fill")
        }
        Button(action: { viewModel.autoscroll.toggle() }) {
            Label("Toggle Autoscroll", systemImage: viewModel.autoscroll ? "pause.circle.fill" : "play.circle.fill")
        }
//        ConnectionStatusIndicator()
        MenuButton(label: Image(systemName: "dot.radiowaves.left.and.right")) {
            if viewModel.connectionStatus != .connected {
                Button("New Connection") { self.presenting = true }
            } else {
                Button("Disconnect", action: viewModel.disconnectClient)
            }
        }
    }
}

struct MainToolbar_Previews: PreviewProvider {
    static var previews: some View {
        MainToolbar(presenting: .constant(false), viewModel: MainToolbarViewModel(engine: nil))
    }
}
