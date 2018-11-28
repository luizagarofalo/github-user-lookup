//
//  AnimatedButton.swift
//  github-user-lookup
//
//  Created by Luiza Collado Garofalo on 11/21/18.
//  Copyright © 2018 Luiza Garofalo. All rights reserved.
//

import Foundation
import UIKit

public enum StopAnimationStyle {
    case normal
    case expand
    case shake
}

@IBDesignable class TransitionButton: UIButton, UIViewControllerTransitioningDelegate, CAAnimationDelegate {

    @IBInspectable var spinnerColor: UIColor = UIColor.white {
        didSet {
            spinner.spinnerColor = spinnerColor
        }
    }

    @IBInspectable var disabledBackgroundColor: UIColor = UIColor.lightGray {
        didSet {
            self.setBackgroundImage(UIImage(color: disabledBackgroundColor), for: .disabled)
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

    private lazy var spinner: Spinner = {
        let spinner = Spinner(frame: self.frame)
        self.layer.addSublayer(spinner)
        return spinner
    }()

    private var cachedTitle: String?
    private var cachedImage: UIImage?

    private let springGoEase: CAMediaTimingFunction = CAMediaTimingFunction(controlPoints: 0.45, -0.36, 0.44, 0.92)
    private let shrinkCurve: CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    private let expandCurve: CAMediaTimingFunction = CAMediaTimingFunction(controlPoints: 0.95, 0.02, 1, 0.05)
    private let shrinkDuration: CFTimeInterval = 0.1

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.spinner.setToFrame(self.frame)
    }

    private func setup() {
        self.clipsToBounds  = true
        spinner.spinnerColor = spinnerColor
    }

    func startAnimation() {
        self.isUserInteractionEnabled = false
        self.cachedTitle            = title(for: .normal)
        self.cachedImage            = image(for: .normal)

        self.setTitle("", for: .normal)
        self.setImage(nil, for: .normal)

        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.layer.cornerRadius = self.frame.height / 2
        }, completion: { _ -> Void in
            self.shrink()
            self.spinner.animation()
        })
    }

    func stopAnimation(animationStyle: StopAnimationStyle = .normal,
                       revertAfterDelay delay: TimeInterval = 1.0, completion:(() -> Void)? = nil) {

        let delayToRevert = max(delay, 0.2)

        switch animationStyle {
        case .normal:
            DispatchQueue.main.asyncAfter(deadline: .now() + delayToRevert) {
                self.setOriginalState(completion: completion)
            }
        case .shake:
            DispatchQueue.main.asyncAfter(deadline: .now() + delayToRevert) {
                self.setOriginalState(completion: nil)
                self.shakeAnimation(completion: completion)
            }
        case .expand:
            self.spinner.stopAnimation()
            self.expand(completion: completion, revertDelay: delayToRevert)
        }
    }

    private func shakeAnimation(completion:(() -> Void)?) {
        let keyFrame = CAKeyframeAnimation(keyPath: "position")
        let point = self.layer.position
        keyFrame.values = [NSValue(cgPoint: CGPoint(x: CGFloat(point.x), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x - 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x + 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x - 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x + 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x - 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x + 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: point)]

        keyFrame.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        keyFrame.duration = 0.7
        self.layer.position = point

        CATransaction.setCompletionBlock {
            completion?()
        }
        self.layer.add(keyFrame, forKey: keyFrame.keyPath)
        CATransaction.commit()
    }

    private func setOriginalState(completion:(() -> Void)?) {
        self.animateToOriginalWidth(completion: completion)
        self.spinner.stopAnimation()
        self.setTitle(self.cachedTitle, for: .normal)
        self.setImage(self.cachedImage, for: .normal)
        self.isUserInteractionEnabled = true // enable again the user interaction
        self.layer.cornerRadius = self.cornerRadius
    }

    private func animateToOriginalWidth(completion:(() -> Void)?) {
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue = (self.bounds.height)
        shrinkAnim.toValue = (self.bounds.width)
        shrinkAnim.duration = shrinkDuration
        shrinkAnim.timingFunction = shrinkCurve
        shrinkAnim.fillMode = kCAFillModeForwards
        shrinkAnim.isRemovedOnCompletion = false

        CATransaction.setCompletionBlock {
            completion?()
        }
        self.layer.add(shrinkAnim, forKey: shrinkAnim.keyPath)
        CATransaction.commit()
    }

    private func shrink() {
        let shrinkAnim                   = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue             = frame.width
        shrinkAnim.toValue               = frame.height
        shrinkAnim.duration              = shrinkDuration
        shrinkAnim.timingFunction        = shrinkCurve
        shrinkAnim.fillMode              = kCAFillModeForwards
        shrinkAnim.isRemovedOnCompletion = false

        layer.add(shrinkAnim, forKey: shrinkAnim.keyPath)
    }

    private func expand(completion:(() -> Void)?, revertDelay: TimeInterval) {

        let expandAnim = CABasicAnimation(keyPath: "transform.scale")
        let expandScale = (UIScreen.main.bounds.size.height/self.frame.size.height)*2
        expandAnim.fromValue            = 1.0
        expandAnim.toValue              = max(expandScale, 26.0)
        expandAnim.timingFunction       = expandCurve
        expandAnim.duration             = 0.4
        expandAnim.fillMode             = kCAFillModeForwards
        expandAnim.isRemovedOnCompletion  = false

        CATransaction.setCompletionBlock {
            completion?()
            DispatchQueue.main.asyncAfter(deadline: .now() + revertDelay) {
                self.setOriginalState(completion: nil)
                self.layer.removeAllAnimations()
            }
        }

        layer.add(expandAnim, forKey: expandAnim.keyPath)
        CATransaction.commit()
    }
}

extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image!.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
