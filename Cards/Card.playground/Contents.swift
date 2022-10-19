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

class CardView<ShapeType: ShapeLayerProtocol>: UIView, FlippableView {
    var color: UIColor!
    var isFlipper: bool = false
    var flipCompletionHandler: ((FlippableView) -> Void)? { get set }
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.color = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal error")
    }
    
    func flip() {
        
    }
}

protocol FlippableView {
    var isFlipped: Bool { get set }
    var flipCompletionHandler: ((FlippableView) -> Void)? { get set }
    func flip()
    
}

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
        view.layer.addSublayer( BackSideLines(size: CGSize(width: 150, height: 150), fillColor: UIColor.red.cgColor) )
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
