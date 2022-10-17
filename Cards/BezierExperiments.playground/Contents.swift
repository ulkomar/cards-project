//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
        self.createBezier(on: view)
    }
    
    private func createBezier(on view: UIView) {
        let shapeLayer = CAShapeLayer()
        view.layer.addSublayer(shapeLayer)
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.path = getPath().cgPath
        shapeLayer.fillColor = UIColor.green.cgColor
    }
    
    private func getPath() -> UIBezierPath {
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 50, y: 50))
//        path.addLine(to: CGPoint(x: 150, y: 50))
//        path.addLine(to: CGPoint(x: 150, y: 150))
//        path.close()
//
//        path.move(to: CGPoint(x: 50, y: 70))
//        path.addLine(to: CGPoint(x: 150, y: 170))
//        path.addLine(to: CGPoint(x: 50, y: 170))
//        path.close()
        let centerPoint = CGPoint(x: 200, y: 200)
        let path = UIBezierPath(arcCenter: centerPoint,
        radius: 150, startAngle: .pi/5, endAngle: .pi, clockwise: true)
        return path
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
