//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

protocol ShapeLayerProtocol {
    init(size: CGSize, fillColor: CGColor)
}

extension ShapeLayerProtocol {
    init() {
        fatalError("You can't use initial init")
    }
}

//MARK: - Frontside of the card (end)
class CyrcleShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        let radius = ([size.width, size.height].min() ?? 0) / 2
        let centerX = size.width / 2
        let centerY = size.height / 2
        let path = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: 0, endAngle: .pi*2, clockwise: true)
        path.close()
        self.fillColor = fillColor
        self.path = path.cgPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("You can't use initial init")
    }
}

class SquareShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        
        let edgeSize = ([size.width, size.height].min() ?? 0)
        let rect = CGRect(x: 0, y: 0, width: edgeSize, height: edgeSize)
        let path = UIBezierPath(rect: rect)
        path.close()
        self.path = path.cgPath
        self.fillColor = fillColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("You can't use initial init")
    }
}

class FillShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let path = UIBezierPath(rect: rect)
        path.close()
        self.path = path.cgPath
        self.fillColor = fillColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("You can't use initial init")
    }
}

//MARK: - Backside of the card

class BackSideCircle: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        let path = UIBezierPath()
        
        for _ in 1...15 {
            let randomX =  Int.random(in: 1...Int(size.width))
            let randomY = Int.random(in: 1...Int(size.height))
            let center = CGPoint(x: randomX, y: randomY)
            let radius = Int.random(in: 5...15)
            
            path.move(to: center)
            path.addArc(withCenter: center, radius: CGFloat(radius), startAngle: 0, endAngle: .pi*2, clockwise: true)
        }
        
        self.path = path.cgPath
        self.strokeColor = fillColor
        self.fillColor = fillColor
        self.lineWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("You can't use initial init")
    }
}

class BackSideLines: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()
        let path = UIBezierPath()
        
        for _ in 1...15 {
            let randomNumberArray = { (value: CGSize) -> [Int] in
                [Int.random(in: 1...Int(value.width)),
                 Int.random(in: 1...Int(value.height))]
            }
            let randomXs = randomNumberArray(size)
            let randomYs = randomNumberArray(size)
            
            path.move(to: CGPoint(x: randomXs[0], y: randomXs[1]))
            path.addLine(to: CGPoint(x: randomYs[0], y: randomYs[1]))
        }
        
        self.path = path.cgPath
        self.strokeColor = fillColor
        self.lineWidth = 3
    } 
    
    required init?(coder: NSCoder) {
        fatalError("You can't use initial init")
    }
}

//MARK: - Card

protocol FlippableView: UIView {
    var isFlipped: Bool { get set }
    var flipCompletionHandler: ((FlippableView) -> Void)? { get set }
    func flip()
}

class CardView<ShapeType: ShapeLayerProtocol>: UIView, FlippableView {
    var color: UIColor!
    var isFlipped: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var flipCompletionHandler: ((FlippableView) -> Void)?
    private let margin: Int = 10
    var cornerRadius = 20
    var startTouchPoint: CGPoint!
    
    lazy var frontSideView: UIView = getFrontSideView()
    lazy var backSideView: UIView = getBackSideView()
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.color = color
        setupBorders()
    }
    
    override func draw(_ rect: CGRect) {
        backSideView.removeFromSuperview()
        frontSideView.removeFromSuperview()
        
        if isFlipped {
            self.addSubview(backSideView)
            self.addSubview(frontSideView)
        } else {
            self.addSubview(frontSideView)
            self.addSubview(backSideView)
        }
    }
    
    func flip() {
        
    }
    
    private func setupBorders() {
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(self.cornerRadius)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func getBackSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        
        view.backgroundColor = .white
        
        switch ["circle", "line"].randomElement() {
        case "circle":
            let layer = BackSideCircle(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        case "line":
            let layer = BackSideLines(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        default:
            break
        }
        
        return view
    }
    
    func getFrontSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
        let shapeView = UIView(frame: CGRect(x: margin,
                                             y: margin,
                                             width: Int(self.bounds.width)-margin*2,
                                             height: Int(self.bounds.height)-margin*2))
        view.addSubview(shapeView)
        
        let shapeLayer = ShapeType(size: shapeView.frame.size, fillColor: color.cgColor)
        shapeView.layer.addSublayer(shapeLayer as! CALayer)
        
        return view
    }
    
    // MARK: Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("first frame \(anchorPoint)")
        
        
        anchorPoint.x = touches.first!.location(in: window).x - self.frame.minX
        print("first frame \(anchorPoint)")
        anchorPoint.y = touches.first!.location(in: window).y - self.frame.minY
        print("first frame \(anchorPoint)")
        self.startTouchPoint = self.frame.origin
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.frame.origin.x = touches.first!.location(in: window).x - anchorPoint.x
        self.frame.origin.y = touches.first!.location(in: window).y - anchorPoint.y
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.5) {
            self.frame.origin = self.startTouchPoint
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
        
        let firstCardView = CardView<CyrcleShape>(frame: CGRect(x: 0, y: 0, width: 120, height: 150), color: .red)
        view.addSubview(firstCardView)
        
        let secondCardView = CardView<CyrcleShape>(frame: CGRect(x: 200, y: 0, width: 120, height: 150), color: .red)
        secondCardView.isFlipped = true
        view.addSubview(secondCardView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("controller begin")
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
