//: Playground - noun: a place where people can play

import Cocoa
import PlaygroundSupport

let tableViewController = TableViewController()
let dataSource = tableViewController.dataSource

PlaygroundPage.current.liveView = tableViewController.view

let scanner = BluetoothScanner { scanner in
    scanner.startScanning { (peripheral) in
        print("Discovered peripheral: \(peripheral.tableViewData)")
        dataSource.update(peripheral: peripheral)
    }
}
