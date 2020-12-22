//
//  JSONView.swift
//  Rush
//
//  Created by Theo Lampert on 20.12.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

struct JSONView: View {
    var JSONString: String

    var body: some View {
        let data = Data(JSONString.utf8)
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            return AnyView(DisclosureTree(dict: json))
        } else {
            return AnyView(EmptyView())
        }
    }
}

struct JSONView_Previews: PreviewProvider {
    static var previews: some View {
        JSONView(JSONString: "{\"Hello\": \"World\"}")
    }
}
