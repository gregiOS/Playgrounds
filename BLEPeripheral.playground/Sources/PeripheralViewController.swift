import AppKit

public class PeripheralViewController: NSViewController {
    
    lazy var titleTextFiled: NSTextField = {
        let textFiled = NSTextField(frame: NSRect(x: 0, y: 598, width: 320, height: 35))
        textFiled.font = NSFont.systemFont(ofSize: 25)
        textFiled.alignment = .center
        return textFiled
    }()
    
    lazy var peripheralNameTextFiled: NSTextField = {
        let textFiled = NSTextField(frame: NSRect(x: 0, y: 538, width: 320, height: 30))
        textFiled.alignment = .left
        return textFiled
    }()
    
    lazy var isOnTextField = NSTextField(frame: NSRect(x: 0, y: 508, width: 160, height: 30))
    
    lazy var isOnButton = NSButton(frame: NSRect(x: 160, y: 508, width: 160, height: 30))
    
    lazy var goLeftButton: NSButton = {
        let button = NSButton(frame: NSRect(x: 60, y: 400, width: 72, height: 45))
        button.title = "LEFT"
        button.alignment = .center
        return button
    }()
    
    lazy var goRightButton: NSButton = {
        let button = NSButton(frame: NSRect(x: 190, y: 400, width: 72, height: 45))
        button.title = "RIGHT"
        button.alignment = .center
        return button
    }()
    
    lazy var goForwardButton: NSButton = {
        let button = NSButton(frame: NSRect(x: 120, y: 450, width: 85, height: 45))
        button.title = "FORWARD"
        
        return button
    }()
    
    lazy var goBackwardButton: NSButton = {
        let button = NSButton(frame: NSRect(x: 120, y: 350, width: 85, height: 45))
        button.title = "BACKWARD"
        button.alignment = .center
        return button
    }()
    
    var isPeripheralOn = false {
        didSet {
            isOnButton.title = isPeripheralOn ? "Turn Off" : "Turn On"
            if isPeripheralOn {
                peripheralController = PeripheralController(peripheralName: peripheralNameTextFiled.stringValue)
                peripheralController.registerServiceController(MotionService())
                try? peripheralController.turnOn()
                carsManager.addCar(RCCarModel(name: peripheralController.peripheralName))
            } else {
                try? peripheralController?.turnOff()
                peripheralController = nil
            }
        }
    }
    
    let carsManager = CarsManager.shared
    private(set) var peripheralController: PeripheralController!
    
    
    override public func loadView() {
        view = NSView(frame: NSRect(x: 0, y: 0, width: 320, height: 667))
        view.layer = CALayer()
        view.layer?.backgroundColor = NSColor.white.cgColor
        view.addSubview(titleTextFiled)
        view.addSubview(peripheralNameTextFiled)
        view.addSubview(isOnTextField)
        view.addSubview(isOnButton)
        view.addSubview(goLeftButton)
        view.addSubview(goRightButton)
        view.addSubview(goForwardButton)
        view.addSubview(goBackwardButton)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        titleTextFiled.stringValue = "Peripheral controller"
        peripheralNameTextFiled.stringValue = "MyRCCar"
        isOnTextField.stringValue = "IsOn"
        isOnButton.title = "Turn On"
        isOnButton.target = self
        isOnButton.action = #selector(didTapIsOnButton(_:))
        [goLeftButton, goRightButton, goForwardButton, goBackwardButton].forEach { $0.target = self }
        goLeftButton.action = #selector(didTapGoLeftButton(_:))
        goRightButton.action = #selector(didTapGoRightButton(_:))
        goForwardButton.action = #selector(didTapGoForwardButton(_:))
        goBackwardButton.action = #selector(didTapGoBackwardButton(_:))
    }
    
    @objc func didTapIsOnButton(_ sender: NSButton) {
        isPeripheralOn = !isPeripheralOn
    }
    
    @objc func didTapGoLeftButton(_ sender: NSButton) {
        guard isPeripheralOn else { return }
        carsManager.changeMoveDirection(carName: peripheralController.peripheralName, direction: .left)
    }
    
    @objc func didTapGoRightButton(_ sender: NSButton) {
        guard isPeripheralOn else { return }
        carsManager.changeMoveDirection(carName: peripheralController.peripheralName, direction: .right)
    }
    
    @objc func didTapGoForwardButton(_ sender: NSButton) {
        guard isPeripheralOn else { return }
        carsManager.changeMoveDirection(carName: peripheralController.peripheralName, direction: .forward)
    }
    
    @objc func didTapGoBackwardButton(_ sender: NSButton) {
        guard isPeripheralOn else { return }
        carsManager.changeMoveDirection(carName: peripheralController.peripheralName, direction: .backward)
    }
    
}
