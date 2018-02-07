//  Created by Grzegorz Przybyła on 04/02/2018.
//  Copyright © 2018 Grzegorz Przybyła. All rights reserved.
//

import Cocoa

public class TableViewDataSource: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    
    public weak var myTableView: NSTableView? {
        didSet {
            myTableView.map {
                $0.dataSource = self
                $0.delegate = self
            }
        }
    }
    
    public var items: [PeripheralRepresntable] = [] {
        didSet { myTableView?.reloadData() }
    }
    
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
    
    public func update(peripheral: PeripheralRepresntable) {
        if let index = items.index(where: { $0.uuid == peripheral.uuid }) {
            items.insert(peripheral, at: index)
            return
        }
        items.append(peripheral)
    }
    
    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = items[row].tableViewData
        let columnIdentifier = tableColumn!.identifier
        let cell = tableView.makeView(withIdentifier: columnIdentifier, owner: self) as! NSTableCellView
        cell.textField!.stringValue = item[columnIdentifier.rawValue] ?? ""
        return cell
    }
    
}
