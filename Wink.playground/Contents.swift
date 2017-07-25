
import UIKit
import PlaygroundSupport

class Wink: UIView {
    
    var smile: Arc?
    var leftEye: Eye?
    var rightEye: Eye?
    var winkingEye: Arc?
    
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
        
        winkingEye = Arc(bounds: bounds, fill: .clear, color: .white, width: 30.0, start: 330.degree, end: 330.degree)
        winkingEye?.position = bounds.center
        layer.addSublayer(layer: winkingEye)
        
        let wink = CABasicAnimation(keyPath: .strokeStart)
            .from(value: 330.degree)
            .delay(duration: 0.25)
            .to(value: 300.degree)
            .till(duration: 0.25)
            .fill(mode: kCAFillModeForwards)
            .onCompletion(remove: false)
            .reverse(value: false)
        
        let winkingEyeAnimations = winkingEye?.animate(animations: wink)
        
        
        smile = Arc(bounds: bounds, fill: .clear, color: .white, width: 30.0, start: 14.degree, end: 177.5.degree)
        smile?.position = bounds.center
        layer.addSublayer(layer: smile)
        
        let right = CABasicAnimation(keyPath: .strokeStart)
            .from(value: 14.degree)
            .to(value: 0.degree)
            .till(duration: 0.25)
            .fill(mode: kCAFillModeForwards)
            .onCompletion(remove: false)
            .reverse(value: false)
        
        let left = CABasicAnimation(keyPath: .strokeEnd)
            .from(value: 177.5.degree)
            .to(value: 90.degree)
            .till(duration: 0.25)
            .fill(mode: kCAFillModeForwards)
            .onCompletion(remove: false)
            .reverse(value: true)
        
        let smileAnimations = smile?.animate(animations: right, left)
        
        leftEye = Eye(bounds: CGRect(origin: CGPoint.zero, size: CGSize(width: 30.0, height: 30.0)), fill: .white)
        let leftPosition = GET_POINT(radius: frame.width / 2.0, center: center, angle: 240.radians)
        leftEye?.position = leftPosition
        layer.addSublayer(layer: leftEye)

        
        rightEye = Eye(bounds: CGRect(origin: CGPoint.zero, size: CGSize(width: 30.0, height: 30.0)), fill: .white)
        let rightPosition = GET_POINT(radius: frame.width / 2.0, center: center, angle: 300.radians)
        rightEye?.position = rightPosition
        layer.addSublayer(layer: rightEye)
        
        let animatedPosition = GET_POINT(radius: frame.width / 2.0, center: center, angle: 330.radians)
        
        let rightEyeMovementX = CABasicAnimation(keyPath: .positionX)
            .to(value: animatedPosition.x)
            .till(duration: 0.25)
            .fill(mode: kCAFillModeForwards)
            .onCompletion(remove: false)
            .reverse(value: false)
        
        let rightEyeMovementY = CABasicAnimation(keyPath: .positionY)
            .to(value: animatedPosition.y)
            .till(duration: 0.25)
            .fill(mode: kCAFillModeForwards)
            .onCompletion(remove: false)
            .reverse(value: false)
        
        rightEye?.animate(animations: rightEyeMovementX, rightEyeMovementY)
        
    }
}

class Eye: CAShapeLayer {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(bounds: CGRect, fill: UIColor = .clear) {
        super.init()
        self.bounds = bounds
        self.fillColor = fill.cgColor
        draw()
    }
    
    func draw () {
        path = UIBezierPath(ovalIn: bounds).cgPath
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

class Arc: CAShapeLayer, Animatable {
    
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
    var radians: CGFloat { return CGFloat(self) * .pi / 180 }
    var degree: CGFloat { return CGFloat(self) / 360.0 }
}
extension Double {
    var radians: CGFloat { return CGFloat(self) * .pi / 180 }
    var degree: CGFloat { return CGFloat(self) / 360.0 }
}

func GET_POINT (radius: CGFloat, center: CGPoint, angle: CGFloat) -> CGPoint {
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
    
    func delay (duration value: TimeInterval) -> CABasicAnimation {
        beginTime = CACurrentMediaTime() + value
        return self
    }
    
    enum KeyPath: String {
        case strokeEnd, strokeStart, positionX = "position.x", positionY = "position.y"
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
let wink = Wink(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
wink.center = view.center
view.addSubview(wink)
