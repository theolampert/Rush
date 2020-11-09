//
//  DisclosureTree.swift
//  Rush
//
//  Created by Theo Lampert on 08.11.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    let title: Text
    var children: [Item]?
}

struct Styles {
    static let mono = Font(NSFont.monospacedSystemFont(ofSize: 12, weight: .regular))
    static let red = Color(NSColor(red: 0.91, green: 0.518, blue: 0.455, alpha: 1.0))
    static let green = Color(NSColor(red: 0.482, green: 0.682, blue: 0.588, alpha: 1.0))
    static let blue = Color(NSColor(red: 0.561, green: 0.526, blue: 0.792, alpha: 1.0))
}

func buildDisclosureTree(dict: [String: Any], title: Text = Text("Root").font(Styles.mono).foregroundColor(.secondary)) -> Item {

    var root = Item(title: title, children: [])
    dict.forEach { next in
        switch dict[next.key] {
        case let label as String:
            let key = Text(next.key)
                .font(Styles.mono)
                .foregroundColor(Styles.green)
            + Text(": ")
                .font(Styles.mono)
                .foregroundColor(Styles.green)
            + Text(label)
                .font(Styles.mono)
                .foregroundColor(Styles.green)
            root.children?.append(Item(title: key, children: nil))
        case let label as Int:
            let key = Text(next.key)
                .font(Styles.mono)
                .foregroundColor(Styles.green)
            + Text(": ")
                .font(Styles.mono)
                .foregroundColor(Styles.green)
            + Text(label.description)
                .font(Styles.mono)
                .foregroundColor(Styles.blue)
            root.children?.append(Item(title: key, children: nil))
        case let label as [String: Any]:
            let key = Text(next.key)
                .font(Styles.mono)
                .foregroundColor(Styles.green)
            + Text(": ")
            + Text("Dictionary")
                .font(Styles.mono)
                .foregroundColor(.secondary)
            let child: Item = buildDisclosureTree(dict: label, title: key)
            root.children?.append(child)

        case let label as [[String: Any]]:
            let key = Text(next.key)
                .font(Styles.mono)
                .foregroundColor(Styles.green)
            + Text(": ")
            + Text("Dictionary")
                .font(Styles.mono)
                .foregroundColor(.secondary)
            let items = label.map { buildDisclosureTree(dict: $0, title: Text(next.key)) }
            root.children?.append(Item(title: Text(next.key), children: items))
//            let child: Item = buildDisclosureTree(dict: label, title: key)
//            root.children?.append(child)
        default:
            root.children?.append(Item(title: Text("Fuck"), children: nil))
        }
    }

    return root

}

struct DisclosureTree: View {
    let dict: [String: Any]

    var body: some View {
        let items = buildDisclosureTree(dict: dict)
        return List {
            OutlineGroup(items, children: \.children) {
                $0.title
            }.listRowInsets(EdgeInsets())
        }.listStyle(PlainListStyle())
        .padding(.horizontal, 5)
    }
}

struct DisclosureTree_Previews: PreviewProvider {
    static var previews: some View {
        DisclosureTree(dict: [
            "foo": "bar",
            "bar": "foo",
            "boo": 2,
            "baz": ["boop": "Bap", "ma": "baaa", "plunk": 1],
            "bam": [1, 2, 3, 4],
            "rap": [
                ["foo": 1],
                ["bar": 2]
            ]
        ])
    }
}
