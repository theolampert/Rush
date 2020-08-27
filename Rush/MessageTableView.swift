//
//  MessageTableView.swift
//  Rush
//
//  Created by Theo Lampert on 14.08.20.
//  Copyright © 2020 Theo Lampert. All rights reserved.
//

import Foundation
import SwiftUI
import AppKit

struct MessageTableView: NSViewRepresentable {
    var messages: [Message] = []
    @Binding var selectedMessageIndex: Int

    func makeCoordinator() -> Coordinator {
        return Coordinator(messages: messages, parent: self)
    }

    func makeNSView(context: NSViewRepresentableContext<MessageTableView>) -> NSView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.documentView = context.coordinator.tableView
        return scrollView
    }

    func updateNSView(_ nsView: NSView, context: NSViewRepresentableContext<MessageTableView>) {
        context.coordinator.messages = messages
    }
}

extension MessageTableView {
    class Coordinator: NSObject, NSTableViewDataSource, NSTableViewDelegate {
        var parent: MessageTableView

        var messages: [Message] {
            didSet {
                let indexes = tableView.selectedRowIndexes
                tableView.reloadData()
                tableView.selectRowIndexes(indexes, byExtendingSelection: false)
                if messages.count > 0 {
                    tableView.scrollRowToVisible(messages.count - 1)
                }
            }
        }

        init(messages: [Message], parent: MessageTableView) {
            self.messages = messages
            self.parent = parent
        }

        private enum Column: String, CaseIterable {
            case id, topic, value, qos, timestamp

            var nsColumn: NSTableColumn {
                let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(self.rawValue))
                switch self {
                case .id:
                    column.title = NSLocalizedString("ID", comment: "")

                case .topic:
                    column.title = NSLocalizedString("Topic", comment: "")

                case .value:
                    column.title = NSLocalizedString("Message", comment: "")

                case .qos:
                    column.title = NSLocalizedString("QoS", comment: "")

                case .timestamp:
                    column.title = NSLocalizedString("Time", comment: "")
                }

                return column
            }
        }

        lazy var tableView: NSTableView = {
            let tableView = NSTableView(frame: .zero)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
            tableView.selectionHighlightStyle = .regular
            tableView.allowsEmptySelection = true
            tableView.allowsColumnReordering = true
            tableView.usesAlternatingRowBackgroundColors = true

            Column.allCases.forEach { column in
                tableView.addTableColumn(column.nsColumn)
            }
            return tableView
        }()

        // MARK: - NSTableViewDelegate
        func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
            guard let identifier = tableColumn?.identifier, let column = Column(rawValue: identifier.rawValue) else { return nil }

            let text: String
            let message = messages[row]

            switch column {
            case .id:
                text = message.id.description

            case .topic:
                text = message.topicName

            case .value:
                text = message.value

            case .qos:
                text = message.qos.description

            case .timestamp:
                text = message.formattedTimestamp
            }

            if let textField = tableView.makeView(withIdentifier: identifier, owner: nil) as? NSTextField {
                textField.stringValue = text
                return textField
            } else {
                let textField = NSTextField(labelWithString: text)
                textField.font = NSFont.monospacedSystemFont(ofSize: 11, weight: .regular)
                textField.identifier = identifier
                return textField
            }
        }

        func tableViewSelectionIsChanging(_ notification: Notification) {
            guard let object = notification.object else { return }
            guard let tableView = (object as? NSTableView) else { return }
            let selection = tableView.selectedRow
            if parent.selectedMessageIndex != selection {
                parent.selectedMessageIndex = selection
            }
        }

        func numberOfRows(in tableView: NSTableView) -> Int {
            return messages.count
        }
    }
}
