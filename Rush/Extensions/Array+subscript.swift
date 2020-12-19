//
//  Array+subscript.swift
//  Rush
//
//  Created by Theo Lampert on 19.12.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import Foundation


extension Array {
    public subscript(index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
        guard index >= 0, index < endIndex else {
            return defaultValue()
        }

        return self[index]
    }
}
