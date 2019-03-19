import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

protocol BubbleViewDelegate: class {
    func userDidTap(into bubbleView: BubbleView)
}
class BubbleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    private var delegateQueue: DispatchQueue = .main
    private weak var delegate: BubbleViewDelegate?
    
    func setDelegate(_ delegate: BubbleViewDelegate?, queue: DispatchQueue? = nil) {
        assert(self.delegate == nil, "Delegate was already set.")
        self.delegate = delegate
        queue.map { delegateQueue = $0 }
    }
    
    private func setup() {
        self.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BubbleView.didTapIntoButton))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTapIntoButton(_ sender: UITapGestureRecognizer) {
        delegateQueue.async { [weak self] in
            guard let self = self else { return }
            self.delegate?.userDidTap(into: self)
        }
    }
}

class ContainerViewController: UIViewController {
    
    lazy var bubbleView: BubbleView = {
        let bubbleView = BubbleView(frame: CGRect(x: 80, y: 0, width: 160, height: 160))
        bubbleView.backgroundColor = .blue
        bubbleView.layer.cornerRadius = 80
        bubbleView.setDelegate(self, queue: .main)
        return bubbleView
    }()
    override func loadView() {
        super.loadView()
        view.addSubview(bubbleView)
    }
}
extension ContainerViewController: BubbleViewDelegate {
    func userDidTap(into bubbleView: BubbleView) {
        let currentBounds = view.bounds
        UIView.animate(withDuration: 1.5) {
            var frame = bubbleView.frame
            frame.origin.y = currentBounds.height
            bubbleView.frame = frame
        }
    }
}
let viewController = ContainerViewController()
viewController.view.frame = CGRect(x: 0, y: 0, width: 320, height: 640)
viewController.view.backgroundColor = .white
PlaygroundPage.current.liveView = viewController.view

