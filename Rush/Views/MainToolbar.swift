//
//  MainToolbar.swift
//  Rush
//
//  Created by Theo Lampert on 06.11.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

struct MessageCountIndicator: View {
    var count: Int

    var body: some View {
        Text("\(count) messages").font(.footnote)
    }
}

struct MainToolbar: View {
    @Binding var presenting: Bool
    @EnvironmentObject private var store: RushStore

    var body: some View {
        MessageCountIndicator(count: store.messages.count)
        Button(action: { store.clearMessages() }) {
            Label("Clear Messages", systemImage: "trash.circle.fill")
        }
        Button(action: { store.autoscroll.toggle() }) {
            Label("Toggle Autoscroll", systemImage: store.autoscroll ? "pause.circle.fill" : "play.circle.fill")
        }
        ConnectionStatusIndicator()
        MenuButton(label: Image(systemName: "dot.radiowaves.left.and.right")) {
            Button("New Connection") {
                self.presenting = true
            }
        }
    }
}

struct MainToolbar_Previews: PreviewProvider {
    static var previews: some View {
        MainToolbar(presenting: .constant(false))
    }
}
