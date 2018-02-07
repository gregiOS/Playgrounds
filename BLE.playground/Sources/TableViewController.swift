
import Cocoa

public class TableViewController: NSViewController {
    
    public var dataSource = TableViewDataSource()
    var tableView: NSTableView!
    
    override public func loadView() {
        var topLevelObjects: NSArray?
        let nib = NSNib.init(nibNamed: .init("TableView"), bundle: nil)!
        guard nib.instantiate(withOwner: nil, topLevelObjects: &topLevelObjects) else { fatalError() }
        let views = (topLevelObjects as! Array<Any>).filter { $0 is NSView }
        view = views[0] as! NSView
        tableView = findView(of: NSTableView.self, in: topLevelObjects!)!
        dataSource.myTableView = tableView
    }
    
}
