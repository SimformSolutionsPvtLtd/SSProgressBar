//
//  ULProgressBar.swift
//  ULProgressBar
//
//  Created by Umang Loriya on 7/23/18.
//  Copyright © 2018 Umang Loriya. All rights reserved.
//

import UIKit

@IBDesignable
open class SSProgressBar: UIView {
    
    public enum GradientDirection {
        case leftToRight
        case rightToLeft
        case topToBottom
        case bottomToTop
    }
    public enum Parameters {
        case shadowColor
        case cornerRadius
        case shadowOffset
        case shadowOpacity
        case borderColor
        case borderWidth
        case trackBGColor
        case progressWidth
        case gradientColor
        case gradientDirection
    }
    
    private var progressView = UIView()
    public var gradientDirection: GradientDirection = .topToBottom {
        didSet {
            self.updateView(params: .gradientDirection)
        }
    }
    
    public var colors: [CGColor] = [] {
        didSet {
            if colors.count > 0 {
                self.updateView(params: .gradientColor)
            }
        }
    }
    
    @IBInspectable public var progress: Int = 10 {
        didSet {
            print(progress)
            progressWidth = Int(self.frame.width * CGFloat(min(progress, 100)) / 100)
        }
    }
    
    private var progressWidth: Int {
        get {
            return Int(self.frame.width * CGFloat(min(progress, 100)) / 100)
        }
        set {
            self.progressView.frame = CGRect(x: 0, y: 0, width: newValue, height: Int(self.frame.height))
            self.updateView(params: .progressWidth)
        }
    }
    
    @IBInspectable public var trackBackgroundColor: UIColor = UIColor.white {
        didSet {
            self.updateView(params: .cornerRadius)
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.updateView(params: .cornerRadius)
        }
    }
    
    @IBInspectable public  var borderWidth: CGFloat = 0 {
        didSet {
            self.updateView(params: .borderWidth)
        }
    }
    
    @IBInspectable public var borderColor: UIColor? = UIColor.clear {
        didSet {
            self.updateView(params: .borderColor)
        }
    }
    
    @IBInspectable public var shadowColor: UIColor? = UIColor.clear {
        didSet {
            self.updateView(params: .shadowColor)
        }
    }
    
    @IBInspectable public var shadowOffset: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            self.updateView(params: .shadowOffset)
        }
    }
    
    @IBInspectable public var shadowOpacity: Double = 0 {
        didSet {
            self.updateView(params: .shadowOpacity)
        }
    }
    
    private func updateView(params: Parameters) {
        if self.progressView.layer.sublayers != nil {
            if self.progressView.layer.sublayers![0].isKind(of: CAGradientLayer.self) {
                let layer = self.progressView.layer.sublayers![0] as? CAGradientLayer
                
                switch params {
                case .shadowColor:
                    layer?.shadowColor = self.shadowColor?.cgColor
                case .cornerRadius:
                    layer?.cornerRadius = self.cornerRadius
                case .shadowOffset:
                    layer?.shadowOffset = self.shadowOffset
                case .shadowOpacity:
                    layer?.shadowOpacity = Float(self.shadowOpacity)
                case .borderColor:
                    self.layer.borderColor = self.borderColor?.cgColor
                //  layer?.borderColor = self.borderColor?.cgColor
                case .borderWidth:
                    self.layer.borderWidth = self.borderWidth
                //  layer?.borderWidth = self.borderWidth
                case .trackBGColor:
                    self.backgroundColor = self.trackBackgroundColor
                case .progressWidth:
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                        layer?.frame.size.width = CGFloat(self.progressWidth)
                    }) { (isDone) in
                        
                    }
                case .gradientColor:
                    layer?.colors = self.colors
                case .gradientDirection:
                    self.changeGradientDirection(dir: self.gradientDirection, layer: layer)
                }
            }
        }
    }
    
    private func changeGradientDirection(dir: GradientDirection, layer: CAGradientLayer?) {
        switch dir {
        case .leftToRight:
            layer?.startPoint = CGPoint(x: 0.0, y: 0.5)
            layer?.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            layer?.startPoint = CGPoint(x: 1.0, y: 0.5)
            layer?.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .bottomToTop:
            layer?.startPoint = CGPoint(x: 0.5, y: 1.0)
            layer?.endPoint = CGPoint(x: 0.5, y: 0.0)
        default:
            break
        }
    }
    
    public func withProgressGradientBackground(from color1: UIColor, to color2: UIColor, direction: GradientDirection) {
        if self.progressView.layer.sublayers != nil {
            if self.progressView.layer.sublayers![0].isKind(of: CAGradientLayer.self) {
                let layer = self.progressView.layer.sublayers![0] as? CAGradientLayer
                layer?.colors = [color1.cgColor, color2.cgColor]
                self.changeGradientDirection(dir: direction, layer: layer)
                return
            }
        }
        self.addSubview(progressView)
        self.layoutIfNeeded()
        self.applyConstraints()
        let gradient = CAGradientLayer()
        self.progressView.frame = CGRect(x: 0, y: 0, width: progressWidth, height: Int(self.frame.height))
        gradient.frame = self.progressView.bounds
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.cornerRadius = self.cornerRadius
        gradient.shadowColor = self.shadowColor?.cgColor
        gradient.shadowOffset = self.shadowOffset
        gradient.shadowOpacity = Float(self.shadowOpacity)
        self.applySelfProperties()
        self.changeGradientDirection(dir: direction, layer: gradient)
        self.progressView.layer.insertSublayer(gradient, at: 0)
        print(progressView.frame)
        print(self.frame)
        
        
    }
    
    private func applySelfProperties() {
        self.layer.borderColor = self.borderColor?.cgColor
        self.layer.borderWidth = self.borderWidth
        self.layer.cornerRadius = self.cornerRadius
        self.backgroundColor = self.trackBackgroundColor
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func applyConstraints() {
        self.progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            self.progressView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: self.frame.width - CGFloat(self.progressWidth)),
            self.progressView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0),
            self.progressView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
            ])
    }
    
}
