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
    @StateObject var viewModel: MessageTableViewModel

    internal func makeCoordinator() -> Coordinator {
        return Coordinator(messages: viewModel.messages, parent: self)
    }

    internal func makeNSView(context: NSViewRepresentableContext<MessageTableView>) -> NSView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.drawsBackground = false
        scrollView.wantsLayer = true
        scrollView.documentView = context.coordinator.tableView
        return scrollView
    }

    internal func updateNSView(_ nsView: NSView, context: NSViewRepresentableContext<MessageTableView>) {
        if context.coordinator.messages.count != viewModel.messages.count {
            context.coordinator.messages = viewModel.messages
        }
        context.coordinator.autoscroll = viewModel.autoscroll
    }
}

extension MessageTableView {
    final class Coordinator: NSObject, NSTableViewDataSource, NSTableViewDelegate {
        var parent: MessageTableView
        var autoscroll: Bool = true

        var messages: ContiguousArray<Message> {
            didSet {
                tableView.noteNumberOfRowsChanged()
                if messages.count > 0 && autoscroll {
                    tableView.scrollRowToVisible(messages.count - 1)
                }
            }
        }

        init(messages: ContiguousArray<Message>, parent: MessageTableView) {
            self.messages = messages
            self.parent = parent
        }

        private enum Column: String, CaseIterable {
            case topic, value, size, qos, timestamp

            var nsColumn: NSTableColumn {
                let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(self.rawValue))
                switch self {
                case .topic:
                    column.title = NSLocalizedString("Topic", comment: "")

                case .value:
                    column.title = NSLocalizedString("Message", comment: "")

                case .qos:
                    column.title = NSLocalizedString("QoS", comment: "")

                case .size:
                    column.title = NSLocalizedString("Size (bytes)", comment: "")

                case .timestamp:
                    column.title = NSLocalizedString("Time", comment: "")
                }

                return column
            }
        }

        lazy var tableView: NSTableView = { [weak self] in
            let tableView = NSTableView(frame: .zero)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
            tableView.selectionHighlightStyle = .regular
            tableView.allowsEmptySelection = true
            tableView.allowsColumnReordering = true
            tableView.usesAlternatingRowBackgroundColors = true
            tableView.wantsLayer = true

            Column.allCases.forEach { column in
                tableView.addTableColumn(column.nsColumn)
            }

            return tableView
        }()

        // MARK: - NSTableViewDelegate
        internal func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
            guard let identifier = tableColumn?.identifier, let column = Column(rawValue: identifier.rawValue) else { return nil }

            let text: String
            let message = messages[row]

            switch column {
            case .topic:
                text = message.topic

            case .value:
                text = message.value

            case .qos:
                text = message.qos.description

            case .size:
                text = message.sizeLabel

            case .timestamp:
                text = message.formattedTimestamp
            }
            
            if let textField = tableView.makeView(withIdentifier: identifier, owner: nil) as? NSTextField {
                textField.drawsBackground = false
                textField.wantsLayer = true
                textField.stringValue = text
                return textField
            } else {
                let textField = NSTextField(labelWithString: text)
                textField.drawsBackground = false
                textField.font = NSFont.monospacedSystemFont(ofSize: 11, weight: .regular)
                textField.identifier = identifier
                textField.wantsLayer = true
                return textField
            }
        }

        internal func tableViewSelectionIsChanging(_ notification: Notification) {
            guard let object = notification.object else { return }
            guard let tableView = (object as? NSTableView) else { return }
            let selection = tableView.selectedRow
            if parent.viewModel.selectedMessageIndex != selection {
                parent.viewModel.selectedMessageIndex = selection
            }
        }

        internal func numberOfRows(in tableView: NSTableView) -> Int {
            return messages.count
        }
    }
}
