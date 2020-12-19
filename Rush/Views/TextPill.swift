//
//  TextPill.swift
//  Rush
//
//  Created by Theo Lampert on 15.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

struct TextPill: View {
    var text: String?

    var body: some View {
        OptionalText(text: text)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .font(.footnote)
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .foregroundColor(Color(NSColor.systemBlue))
            )
    }
}

struct TextPill_Previews: PreviewProvider {
    static var previews: some View {
        TextPill(text: "MQTT_ROUNDTRIP")
    }
}
