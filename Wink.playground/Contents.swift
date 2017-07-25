
import UIKit
import PlaygroundSupport

class Wink: UIView {
    
    var smile: Smile?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        draw()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        draw()
    }
    
    func draw () {
        guard frame.isSquare else {
            fatalError("The Wink View is not a square!")
        }
        
        smile = Smile(bounds: bounds, fill: .clear, color: .white, width: 30.0, start: 14.degree, end: 177.5.degree)
        smile?.position = bounds.center
        layer.addSublayer(layer: smile)
        
        let right = CABasicAnimation(keyPath: .strokeStart)
            .from(value: 14.degree)
            .to(value: 0.degree)
            .till(duration: 0.25)
            .fill(mode: kCAFillModeForwards)
            .onCompletion(remove: false)
            .reverse(value: true)
        
        let left = CABasicAnimation(keyPath: .strokeEnd)
            .from(value: 177.5.degree)
            .to(value: 90.degree)
            .till(duration: 0.25)
            .fill(mode: kCAFillModeForwards)
            .onCompletion(remove: false)
            .reverse(value: true)
        
        let smileAnimations = smile?.animate(animations: right, left)
        
    }
}

class Eye: CAShapeLayer {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(bounds: CGRect, fill: UIColor = .clear, color: UIColor = .white, width: CGFloat, start: CGFloat, end: CGFloat) {
        super.init()
        self.bounds = bounds
        self.fillColor = fill.cgColor
        draw(width: width, stroke: color, start: start, end: end)
    }
    
    func draw (width: CGFloat, stroke: UIColor, start: CGFloat, end: CGFloat) {
        path = UIBezierPath(ovalIn: bounds).cgPath
        lineWidth = width
        strokeColor = stroke.cgColor
        strokeStart = start
        strokeEnd = end
    }
    
    @discardableResult func animate(animations: CAAnimation..., offset: CFTimeInterval = 0.5, duration: CFTimeInterval = 0.5, timing: CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn), count: Float = HUGE) -> CAAnimationGroup {
        let group = CAAnimationGroup()
        group.animations = animations
        group.timeOffset = offset
        group.duration = duration
        group.timingFunction = timing
        group.repeatCount = count
        add(group, forKey: "animation")
        
        return group
    }
    
}

class Smile: CAShapeLayer, Animatable {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(bounds: CGRect, fill: UIColor = .clear, color: UIColor = .white, width: CGFloat, start: CGFloat, end: CGFloat) {
        super.init()
        self.bounds = bounds
        self.fillColor = fill.cgColor
        
        draw(width: width, stroke: color, start: start, end: end)
    }
    
    func draw (width: CGFloat, stroke: UIColor, start: CGFloat, end: CGFloat) {
        path = UIBezierPath(ovalIn: bounds).cgPath
        lineWidth = width
        strokeColor = stroke.cgColor
        strokeStart = start
        strokeEnd = end
    }
    
    @discardableResult func animate(animations: CAAnimation..., offset: CFTimeInterval = 0.5, duration: CFTimeInterval = 0.5, timing: CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn), count: Float = HUGE) -> CAAnimationGroup {
        let group = CAAnimationGroup()
        group.animations = animations
        group.timeOffset = offset
        group.duration = duration
        group.timingFunction = timing
        group.repeatCount = count
        add(group, forKey: "animation")
        
        return group
    }
}

protocol Animatable {
    func animate (animations: CAAnimation..., offset: CFTimeInterval, duration: CFTimeInterval, timing: CAMediaTimingFunction, count: Float) -> CAAnimationGroup
}

extension CGRect {
    var isSquare: Bool {
        return (width == height)
    }
    var center: CGPoint {
        return CGPoint(x: width / 2.0, y: height / 2.0)
    }
}
extension Int {
    var degree: CGFloat { return CGFloat(self) / 360.0 }
}
extension Double {
    var degree: CGFloat { return CGFloat(self) / 360.0 }
}

func point (radius: CGFloat, center: CGPoint, angle: CGFloat) -> CGPoint {
    let x = center.x + (radius * cos(angle))
    let y = center.y + (radius * sin(angle))
    return CGPoint(x: x, y: y)
}

extension CABasicAnimation {
    convenience init (keyPath: KeyPath) {
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
    
    func till(duration value: TimeInterval) -> CABasicAnimation {
        duration = value
        return self
    }
    
    func fill(mode value: String) -> CABasicAnimation {
        fillMode = value
        return self
    }
    
    func onCompletion(remove: Bool) -> CABasicAnimation {
        isRemovedOnCompletion = remove
        return self
    }
    
    func reverse (value: Bool) -> CABasicAnimation {
        autoreverses = value
        return self
    }
    
    enum KeyPath: String {
        case strokeEnd, strokeStart
    }
}

extension CALayer {
    
    func addSublayer (layer: CALayer?) {
        guard let layer = layer else { return }
        addSublayer(layer)
    }
}

// MARK: - Playground specific code
// TODO: - Remove it in app
let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 360, height: 480))
PlaygroundPage.current.liveView = view
view.backgroundColor = UIColor.green

// MARK: - Instantiate CareemSmile
let wink = Wink(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
wink.center = view.center
view.addSubview(wink)
