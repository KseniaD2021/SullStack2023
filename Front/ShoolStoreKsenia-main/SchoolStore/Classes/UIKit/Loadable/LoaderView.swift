//
//  LoaderView.swift
//
//  Created by Ксения Дураева
//

import UIKit

final class LoaderView: UIView {
    // MARK: Lifecycle

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Shouldn't use this way")
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        animatedLayer = constructIndefiniteAnimationGradientLayer()
    }

    // MARK: Public

    override public func sizeThatFits(_: CGSize) -> CGSize {
        CGSize(
            width: (radius + strokeThickness * 0.5 + 5) * 2,
            height: (radius + strokeThickness * 0.5 + 5) * 2
        )
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        animatedLayer?.position = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
    }

    // MARK: Internal

    var parameters: LoaderParameters = .empty

    var isLoading: Bool = false

    func animateLoading() {
        guard !isLoading else {
            return
        }
        isLoading = true
        UIView.animate(
            withDuration: 0.5,
            animations: { [unowned self] in
                self.alpha = 1.0
                self.animatedLayer?.removeFromSuperlayer()
                self.animatedLayer = self.constructIndefiniteAnimationGradientLayer()

                if self.superview != nil {
                    self.layoutAnimatedLayer()
                }
            }
        )
    }

    func setRotationState(with angle: CGFloat) {
        let shapeLayer = self.shapeLayer(with: angle, endAngle: angle - CGFloat(2 * Double.pi))
        alpha = 1.0
        animatedLayer?.removeFromSuperlayer()
        animatedLayer = constructGradientLayer(shapeLayer: shapeLayer)

        if superview != nil {
            layoutAnimatedLayer()
        }
    }

    // MARK: Private

    private var animatedLayer: CAGradientLayer?

    private var strokeThickness: CGFloat {
        parameters.strokeThickness
    }

    private var strokeColor: UIColor {
        parameters.color
    }

    private var diameter: CGFloat {
        parameters.diameter
    }

    private var radius: CGFloat {
        diameter * 0.5
    }

    private var roundedAnimation: CABasicAnimation {
        let animationDuration: TimeInterval = 1
        let linearCurve = CAMediaTimingFunction(name: .linear)

        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        animation.valueFunction = CAValueFunction(name: .rotateZ)
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = animationDuration
        animation.timingFunction = linearCurve
        animation.isRemovedOnCompletion = false
        animation.repeatCount = .infinity
        animation.fillMode = .forwards
        animation.autoreverses = false
        return animation
    }

    // MARK: - Private methods

    private func layoutAnimatedLayer() {
        guard let layer = animatedLayer else {
            return
        }
        self.layer.addSublayer(layer)
        let widthDiff = bounds.width - layer.bounds.width
        let heightDiff = bounds.height - layer.bounds.height
        layer.position = CGPoint(
            x: bounds.width - layer.bounds.width * 0.5 - widthDiff * 0.5,
            y: bounds.height - layer.bounds.height * 0.5 - heightDiff * 0.5
        )
    }

    private func constructGradientLayer(shapeLayer: CAShapeLayer) -> CAGradientLayer {
        let animatedLayer = CAGradientLayer()
        animatedLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        animatedLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        animatedLayer.frame = shapeLayer.bounds
        animatedLayer.colors = [
            strokeColor.withAlphaComponent(0.0).cgColor,
            strokeColor.withAlphaComponent(0.5).cgColor,
            strokeColor.withAlphaComponent(0.5).cgColor,
            strokeColor.cgColor,
        ]
        animatedLayer.locations = [
            NSNumber(value: 0.0), NSNumber(value: 0.25), NSNumber(value: 0.5), NSNumber(value: 1.0),
        ]
        animatedLayer.mask = shapeLayer
        return animatedLayer
    }

    private func constructIndefiniteAnimationGradientLayer() -> CAGradientLayer {
        let animatedLayer = constructGradientLayer(shapeLayer: shapeLayer())
        animatedLayer.add(roundedAnimation, forKey: "rotate")
        return animatedLayer
    }

    private func shapeLayer(
        with startAngle: CGFloat = CGFloat(Double.pi * 3 / 2),
        endAngle: CGFloat = CGFloat(-0.5 * .pi)
    ) -> CAShapeLayer {
        let arcCenter = CGPoint(
            x: radius + strokeThickness * 0.5 + 5,
            y: radius + strokeThickness * 0.5 + 5
        )
        let smoothedPath = UIBezierPath(
            arcCenter: arcCenter,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        let shapeLayer = CAShapeLayer()
        shapeLayer.contentsScale = UIScreen.main.scale
        shapeLayer.frame = CGRect(origin: .zero, size: CGSize(width: arcCenter.x * 2, height: arcCenter.y * 2))
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = strokeThickness
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        shapeLayer.path = smoothedPath.cgPath
        shapeLayer.strokeStart = 0.4
        shapeLayer.strokeEnd = 1.0
        return shapeLayer
    }
}
