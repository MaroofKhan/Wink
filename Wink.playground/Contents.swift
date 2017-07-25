
import UIKit
import PlaygroundSupport

extension CGRect {
    var isSquare: Bool {
        return (width == height)
    }
    var center: CGPoint {
        return CGPoint(x: width / 2.0, y: height / 2.0)
    }
}
extension Int {
    var radian: CGFloat { return CGFloat(self) * .pi / 180 }
}
extension Double {
    var radian: CGFloat { return CGFloat(self) * .pi / 180 }
}

func point (radius: CGFloat, center: CGPoint, angle: CGFloat) -> CGPoint {
    let x = center.x + (radius * cos(angle))
    let y = center.y + (radius * sin(angle))
    return CGPoint(x: x, y: y)
}

let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 360, height: 480))
PlaygroundPage.current.liveView = view

let smile = Smile(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
smile.center = view.center
//view.addSubview(smile)

class Wink: UIView {
    
}

class Smile: UIView, Animatable {

    internal var shapeLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        draw()
    }
    
    internal func draw () {
        guard bounds.isSquare else {
            fatalError("The frame is not a square!")
        }
        
        shapeLayer = CAShapeLayer(layer: layer)
        shapeLayer?.path = UIBezierPath(ovalIn: bounds).cgPath
        shapeLayer?.lineWidth = 30.0
        shapeLayer?.strokeColor = UIColor.white.cgColor
        shapeLayer?.fillColor = UIColor.clear.cgColor
        shapeLayer?.strokeStart = 0.04
        shapeLayer?.strokeEnd = 0.5
    }
    
    func animate() {
        
        let right = CABasicAnimation(keyPath: .strokeStart)
            .from(value: 0.04)
            .to(value: 0.0)
            .till(duration: 0.25)
            .fill(mode: kCAFillModeForwards)
            .onCompletion(remove: false)
            .auto(reverses: true)
        
        let left = CABasicAnimation(keyPath: .strokeEnd)
            .from(value: 0.5)
            .to(value: 0.25)
            .till(duration: 0.25)
            .fill(mode: kCAFillModeForwards)
            .onCompletion(remove: false)
            .auto(reverses: true)
        
        let group = CAAnimationGroup()
        group.animations = [right, left]
        group.timeOffset = 1.0
        group.duration = 3
        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        group.repeatCount = HUGE
        
        shapeLayer?.add(group, forKey: "smile")
        
    }
}

protocol Animatable {
    var path: UIBezierPath? { get set }
    var shapeLayer: CAShapeLayer? { get set }
    func draw()
    func animate ()
}

extension CABasicAnimation {
    convenience init (keyPath: CAKeyPath) {
        self.init(keyPath: keyPath.rawValue)
    }
    
    func from(value: CGFloat) -> CABasicAnimation {
        fromValue = value
        return self
    }
    
    func to(value: CGFloat) -> CABasicAnimation {
        toValue = value
        return self
    }
    
    func till(duration: TimeInterval) -> CABasicAnimation {
        duration = value
        return self
    }
    
    func fill(mode: String) -> CABasicAnimation {
        fillMode = value
        return self
    }
    
    func onCompletion(remove: Bool) -> CABasicAnimation {
        isRemovedOnCompletion = remove
        return self
    }
    
    func auto (reverses: Bool) -> CABasicAnimation {
        autoreverses = reverses
        return self
    }
}

enum CAKeyPath: String {
    case strokeEnd, strokeStart
}



