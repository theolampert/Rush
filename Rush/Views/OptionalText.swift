//
//  OptionalText.swift
//  Rush
//
//  Created by Theo Lampert on 15.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

struct OptionalText: View {
    var text: String?

    var body: some View {
        text.map { Text($0) }
    }
}

struct OptionalText_Previews: PreviewProvider {
    static var previews: some View {
        OptionalText(text: "Foo")
    }
}
