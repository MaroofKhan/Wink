
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

extension UIColor {
    static var careemGreen: UIColor {
        return self.init(red: 107/255, green: 182/255, blue: 96/255, alpha: 1)
    }
}

func point (radius: CGFloat, center: CGPoint, angle: CGFloat) -> CGPoint {
    let x = center.x + (radius * cos(angle))
    let y = center.y + (radius * sin(angle))
    return CGPoint(x: x, y: y)
}

class Smile: UIView {
    
    var lips: Arc!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        draw()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        draw()
    }
    
    internal func draw() {
        guard bounds.isSquare else {
            fatalError("The frame is not a square!")
        }
        
        lips = Arc(bounds: bounds)
        lips.draw(start: 0.04, end: 0.5)
        lips.position = center
        layer.addSublayer(lips)
    }
    
    func animate() {
        lips.animate(duration: 0.25)
    }
}

class Arc: CAShapeLayer, Animatable {
    convenience init(bounds: CGRect) {
        self.init()
        self.bounds = bounds
    }
    
    func draw(start: CGFloat = 0,
              end: CGFloat = 0,
              width: CGFloat? = nil,
              color: UIColor = UIColor.white) {
        
        // Set the arc start and end corners using strokes
        strokeStart = start
        strokeEnd = end
        
        // Set colors
        strokeColor = color.cgColor
        fillColor = UIColor.clear.cgColor
        
        // Set line width
        lineWidth = width ?? bounds.width * 0.25
        
        // Draw
        path = UIBezierPath(ovalIn: bounds).cgPath
    }
    
    func animate(duration: TimeInterval) {
        let right = CABasicAnimation(keyPath: .strokeStart)
            .from(value: 0.04)
            .to(value: 0.0)
            .till(duration: duration)
            .fill(mode: kCAFillModeForwards)
            .onCompletion(remove: false)
            .auto(reverses: true)
        
        let left = CABasicAnimation(keyPath: .strokeEnd)
            .from(value: 0.5)
            .to(value: 0.25)
            .till(duration: duration)
            .fill(mode: kCAFillModeForwards)
            .onCompletion(remove: false)
            .auto(reverses: true)
        
        let group = CAAnimationGroup()
        group.animations = [left, right]
        group.timeOffset = 1.0
        group.duration = 3
        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        group.repeatCount = HUGE
        
        add(group, forKey: nil)
    }
}

protocol Animatable {
    func animate(duration: TimeInterval)
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
        self.duration = duration
        return self
    }
    
    func fill(mode: String) -> CABasicAnimation {
        fillMode = mode
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

// MARK: - Playground specific code
// TODO: - Remove it in app
let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 360, height: 480))
PlaygroundPage.current.liveView = view
view.backgroundColor = UIColor.careemGreen

// MARK: - Instantiate CareemSmile
let careemSmile = Smile(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
careemSmile.center = view.center
view.addSubview(careemSmile)
careemSmile.animate()
