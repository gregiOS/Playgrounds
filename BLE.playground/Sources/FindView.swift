
import Cocoa

public func findView<T: NSView>(of aClass: T.Type, in array: NSArray) -> T? {
    var foundView: T?
    for object in array {
        (object as? NSScrollView)?.subviews
            .forEach({ view in
                view.subviews.forEach({
                    if $0.isKind(of: aClass) {
                        foundView = $0 as? T
                    }
                })
            })
    }
    return foundView
}
