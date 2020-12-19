//
//  TreeView.swift
//  Rush
//
//  Created by Theo Lampert on 07.11.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

struct DynamicView: View {
    struct Styles {
        static let mono = Font(NSFont.monospacedSystemFont(ofSize: 12, weight: .regular))
        static let red = Color(NSColor(red: 0.91, green: 0.518, blue: 0.455, alpha: 1.0))
        static let green = Color(NSColor(red: 0.482, green: 0.682, blue: 0.588, alpha: 1.0))
        static let blue = Color(NSColor(red: 0.561, green: 0.526, blue: 0.792, alpha: 1.0))
    }
    let key: String
    let elm: Any
    var depth: Int
    var body: some View {
        switch elm {
            case let label as String:
            return AnyView(
                HStack {
                    Text("".padding(toLength: depth, withPad: "・", startingAt: 0))
                        .font(Styles.mono)
                        .foregroundColor(.secondary)
                    + Text(key)
                        .foregroundColor(Styles.red)
                        .font(Styles.mono)
                    + Text(":")
                        .foregroundColor(Styles.red)
                        .font(Styles.mono)
                    Text(label)
                        .foregroundColor(Styles.green)
                        .font(Styles.mono)
                    Spacer()
                }
            )
            case let label as Int:
            return AnyView(
                HStack {
                    Text("".padding(toLength: Int(depth), withPad: "・", startingAt: 0))
                        .foregroundColor(.secondary)
                        .font(Styles.mono)
                    + Text(key)
                        .foregroundColor(Styles.red)
                        .font(Styles.mono)
                    + Text(": ")
                        .foregroundColor(Styles.red)
                        .font(Styles.mono)
                    + Text(label.description)
                        .foregroundColor(Styles.blue)
                        .font(Styles.mono)
                    Spacer()
                }
            )
            case let dict as [String: Any]:
            return AnyView(
                VStack(alignment: .leading) {
                    DisclosureGroup(isExpanded: .constant(true), content: {
//                        TreeView(depth: (depth + 1), dict: dict)
                    }, label: {
                        HStack {
                        Text(key)
                            .foregroundColor(Styles.red)
                            .font(Styles.mono)
                        + Text(": ")
                            .foregroundColor(Styles.red)
                            .font(Styles.mono)
                            Spacer()
                        }
                    })
                }
            )
        default:
            return AnyView(
                Text("Empty")
                    .foregroundColor(Styles.red)
                    .font(Styles.mono)
            )
        }
    }
}

struct TreeView: View {
    var depth: Int = 0
    let dict: [String: Any]
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(dict.map { $0.key }, id: \.self) { key in
                DynamicView(key: key, elm: self.dict[key] as Any, depth: depth)
            }
        }.padding(0)
    }
}

struct TreeView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            TreeView(dict: [
                "foo": "bar",
                "bar": "foo",
                "boo": 2,
                "baz": ["boop": "Bap"],
                "bam": [1, 2, 3, 4]
            ])
        }
    }
}
