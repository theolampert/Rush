//
//  View+eraseToAnyView.swift
//  Rush
//
//  Created by Theo Lampert on 20.12.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
