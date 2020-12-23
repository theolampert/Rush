//
//  App.swift
//  Rush
//
//  Created by Theo Lampert on 15.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

fileprivate let engine = MQTTEngine()

@main
struct RushApp: App {
    @State var presenting: Bool = false
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SubscriptionList(viewModel: SubscriptionListViewModel(engine: engine))
                VSplitView {
                    MessageTableView(viewModel: MessageTableViewModel(engine: engine))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    MessageDetail(viewModel: MessageDetailViewModel(engine: engine))
                }
            }.sheet(isPresented: $presenting, content: {
                ConnectionManager(onConnect: { config in
                    engine.connect(config: config)
                })
            })
            .toolbar {
                MainToolbar(presenting: $presenting, viewModel: MainToolbarViewModel(engine: engine))
            }
        }.commands {
            SidebarCommands()
            ToolbarCommands()
        }
    }
}
