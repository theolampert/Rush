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

fileprivate struct ClearHistoryButton: View, Equatable {
    static func == (lhs: ClearHistoryButton, rhs: ClearHistoryButton) -> Bool {
        true
    }
    
    let clearHistory: () -> Void
    var body: some View {
        Button(action: clearHistory) {
            Label("Clear Messages", systemImage: "trash.circle.fill")
        }
    }
}

fileprivate struct AutoScrollButton: View {
    @Binding var autoscroll: Bool
    var body: some View {
        Button(action: { autoscroll.toggle() }) {
            Label("Toggle Autoscroll", systemImage: autoscroll ? "pause.circle.fill" : "play.circle.fill")
        }
    }
}

fileprivate struct ConnectMenu: View {
    @Binding var presenting: Bool
    let disconnect: () -> Void
    let connectionStatus: ConnectionStatus
    
    var body: some View {
        MenuButton(label: Image(systemName: "dot.radiowaves.left.and.right")) {
            if connectionStatus != .connected {
                Button("New Connection") { self.presenting = true }
            } else {
                Button("Disconnect", action: disconnect)
            }
        }
    }
}

struct MainToolbar: View {
    @Binding var presenting: Bool
    @StateObject var viewModel: MainToolbarViewModel

    var body: some View {
        MessageCountIndicator(count: viewModel.totalMessages)
        ClearHistoryButton(clearHistory: viewModel.clearMessageHistory)
        AutoScrollButton(autoscroll: $viewModel.autoscroll)
        ConnectionStatusIndicator(hostname: viewModel.hostname, status: viewModel.connectionStatus)
        ConnectMenu(presenting: $presenting, disconnect: viewModel.disconnectClient, connectionStatus: viewModel.connectionStatus)
    }
}

struct MainToolbar_Previews: PreviewProvider {
    static var previews: some View {
        MainToolbar(presenting: .constant(false), viewModel: MainToolbarViewModel(engine: nil))
    }
}
