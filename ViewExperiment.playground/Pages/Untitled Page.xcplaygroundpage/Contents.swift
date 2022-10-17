//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        setupViews()
    }
    
    private func setupViews() {
        self.view = getRootView()
        let redView = getRedView()
        let greenView = getGreenView()
        let whiteView = getWhiteView()
        let pink = getPinckView()
        
        set(view: greenView, toCenterOfView: redView)
        set(view: whiteView, toCenterOfView: greenView)
        
        view.addSubview( redView )
        redView.addSubview( greenView )
        greenView.addSubview( whiteView )
        view.addSubview( pink )
    }
    
    private func getRootView() -> UIView {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }
    
    private func getRedView() -> UIView {
        let viewFrame = CGRect(x: 50, y: 50, width: 200, height: 200)
        let view = UIView(frame: viewFrame)
        view.backgroundColor = .red
        view.clipsToBounds = true
        view.transform = CGAffineTransform(rotationAngle: .pi/3)
        return view
    }
    
    private func getGreenView() -> UIView {
        let viewFrame = CGRect(x: 100, y: 100, width: 180, height: 180)
        let view = UIView(frame: viewFrame)
        view.backgroundColor = .green
        return view
    }
    
    private func getWhiteView() -> UIView {
        let viewFrame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let view = UIView(frame: viewFrame)
        view.backgroundColor = .white
        return view
    }
    
    private func getPinckView() -> UIView {
        let viewFrame = CGRect(x: 50, y: 300, width: 100, height: 100)
        let view = UIView(frame: viewFrame)
        view.backgroundColor = .systemPink
        
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.yellow.cgColor
        view.layer.cornerRadius = 10
        view.layer.shadowOpacity = 0.95
        view.layer.shadowRadius = 20
        view.layer.shadowOffset = CGSize(width: 10, height: 10)
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.opacity = 0.7
        
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.cgColor
        layer.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        layer.cornerRadius = 10
        view.layer.addSublayer(layer)
        
        return view
    }
    
    private func set(view centredView: UIView, toCenterOfView center: UIView) {
        let centerX = center.bounds.midX
        let centerY = center.bounds.midY
        centredView.center = CGPoint(x: centerX, y: centerY)
    }
    

}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
 
