//
//  NetworkMonitor.swift
//  Rush
//
//  Created by Theo Lampert on 28.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import Foundation
import Network

final class NetworkMonitor {
    let monitor: NWPathMonitor = NWPathMonitor()
    let queue = DispatchQueue.global(qos: .background)

    func onChange(closure: @escaping (_ status: ConnectionStatus) -> Void) {
        monitor.pathUpdateHandler = { path in
            if path.status == .unsatisfied {
                DispatchQueue.main.async {
                    closure(.disconnected)
                }
            }
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    closure(.connected)
                }
            }
        }
    }

    init() {
        monitor.start(queue: queue)
    }
}
