//
//  MainToolbar.swift
//  Rush
//
//  Created by Theo Lampert on 06.11.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

struct MessageCountIndicator: View {
    @EnvironmentObject private var store: RushStore

    var body: some View {
        Text("\(store.messages.count) messages").font(.footnote)
    }
}

struct MainToolbar: View {
    @Binding var presenting: Bool

    var autoscroll: Bool
    var clearMessages: () -> Void
    var toggleAutoscroll: () -> Void

    var body: some View {
        MessageCountIndicator()
        Button(action: { clearMessages() }) {
            Label("Clear Messages", systemImage: "trash.circle.fill")
        }
        Button(action: { toggleAutoscroll() }) {
            Label("Clear Messages", systemImage: autoscroll ? "pause.circle.fill" : "play.circle.fill")
        }
        ConnectionStatusIndicator()
        MenuButton(label: Image(systemName: "dot.radiowaves.left.and.right")) {
            Button("New Connection") {
                self.presenting = true
            }
        }
    }
}

//struct MainToolbar_Previews: PreviewProvider {
//    static var previews: some View {
//        MainToolbar(presenting: .constant(false))
//    }
//}
