//
//  DisclosureTree.swift
//  Rush
//
//  Created by Theo Lampert on 08.11.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import SwiftUI

fileprivate struct Item: Identifiable {
    let id = UUID()
    let title: Text
    var children: [Item]?
}

fileprivate struct Theme {
    static let mono = Font(NSFont.monospacedSystemFont(ofSize: 12, weight: .regular))
    static let red = Color(NSColor(red: 0.91, green: 0.518, blue: 0.455, alpha: 1.0))
    static let green = Color(NSColor(red: 0.482, green: 0.682, blue: 0.588, alpha: 1.0))
    static let blue = Color(NSColor(red: 0.561, green: 0.526, blue: 0.792, alpha: 1.0))
}


fileprivate func dictToItem(key: String, value: Any) -> Item {
    switch value {
    case let label as String:
        let key = Text(key)
            .font(Theme.mono)
            .foregroundColor(Theme.green)
        + Text(": ")
            .font(Theme.mono)
            .foregroundColor(Theme.green)
        + Text(label)
            .font(Theme.mono)
            .foregroundColor(Theme.green)
        return Item(title: key, children: nil)
    case let label as Int:
        let key = Text(key)
            .font(Theme.mono)
            .foregroundColor(Theme.green)
        + Text(": ")
            .font(Theme.mono)
            .foregroundColor(Theme.green)
        + Text(label.description)
            .font(Theme.mono)
            .foregroundColor(Theme.blue)
        return Item(title: key, children: nil)
    case let label as Double:
        let key = Text(key)
            .font(Theme.mono)
            .foregroundColor(Theme.green)
        + Text(": ")
            .font(Theme.mono)
            .foregroundColor(Theme.green)
        + Text(label.description)
            .font(Theme.mono)
            .foregroundColor(Theme.blue)
        return Item(title: key, children: nil)
    case let label as [String: Any]:
        let key = Text(key)
            .font(Theme.mono)
            .foregroundColor(Theme.green)
        + Text(": ")
        + Text("Dictionary")
            .font(Theme.mono)
            .foregroundColor(.secondary)
        let child: Item = buildDisclosureTree(dict: label, title: key)
        return child

    case let label as [[String: Any]]:
        let key = Text(key)
            .font(Theme.mono)
            .foregroundColor(Theme.green)
        + Text(": ")
        + Text("Array \(label.count)")
            .font(Theme.mono)
            .foregroundColor(.secondary)
        let items = label.flatMap { item in item.map { dictToItem(key: $0.key, value: item[$0.key]) } }
        return Item(title: key, children: items)
    default:
        return Item(title: Text("Unknown"), children: nil)
    }
}

fileprivate func buildDisclosureTree(
    dict: [String: Any],
    title: Text = Text("Root").font(Theme.mono).foregroundColor(.secondary)
) -> Item {
    let children = dict.map { next in
        dictToItem(key: next.key, value: dict[next.key])
    }
    return Item(title: title, children: children)
}

struct DisclosureTree: View {
    let dict: [String: Any]

    var body: some View {
        let items = buildDisclosureTree(dict: dict)
        return List {
            OutlineGroup(items, children: \.children) { $0.title }
                .listRowInsets(EdgeInsets())
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
            "blerp": 2.000000001234,
            "baz": ["boop": "Bap", "ma": "baaa", "plunk": 1],
            "bam": [1, 2, 3, 4],
            "rap": [
                ["foo": 1],
                ["bar": ["boo": 2]]
            ]
        ])
    }
}
