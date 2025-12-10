//
//  BoxStickerView.swift
//  IDPhoto
//
//  Created by Liqun Zhang on 2023/8/14.
//

import UIKit
import CoreGraphics

let BoxControlItemWidth = 3.0
let BoxControlItemHalfWidth = 1.5

let BoxMinScale: CGFloat = 0.5
let BoxMaxScale: CGFloat = 3.0

public class BoxStickerView: UIView {
    public var enabledControl: Bool = true {
        didSet {
            self.deleteControl.isHidden = self.enabledControl ? !self.enabledDeleteControl : true
            self.resizeControl.isHidden = !self.enabledControl
            self.resizeControl.isHidden = !self.enabledControl
            self.rightTopControl.isHidden = !self.enabledControl
            self.leftBottomControl.isHidden = !self.enabledControl
        }
    }
    
    public var enabledDeleteControl: Bool = true {
        didSet {
            if self.enabledControl && self.enabledDeleteControl {
                self.deleteControl.isHidden = false
            } else {
                self.deleteControl.isHidden = true
            }
        }
    }
    
    public var enabledBorder: Bool = true {
        didSet {
            if self.enabledBorder {
                self.contentView.layer.addSublayer(self.shapeLayer)
            } else {
                self.shapeLayer.removeFromSuperlayer()
            }
        }
    }
    
    open weak var delegate: BoxStickerViewDelegate?
    
    public var contentImage: UIImage {
        didSet {
            self.contentView.image = self.contentImage
        }
    }
    
    public init(frame: CGRect, contentImage: UIImage) {
        self.contentImage = contentImage
        super.init(frame: CGRect(x: frame.origin.x - BoxControlItemHalfWidth, y: frame.origin.y - BoxControlItemHalfWidth, width: frame.size.width + BoxControlItemWidth, height: frame.size.height + BoxControlItemWidth))
        self.addSubview(self.contentView)
        self.addSubview(self.resizeControl)
        self.addSubview(self.deleteControl)
        self.addSubview(self.rightTopControl)
        self.addSubview(self.leftBottomControl)
        
        self.initShapeLayer()
        self.setupConfig()
        self.attachGestures()
    }
    
    private func initShapeLayer() {
        let shapeRect = self.contentView.frame
        self.shapeLayer.bounds = shapeRect
        self.shapeLayer.position = CGPoint(x: self.contentView.frame.size.width / 2, y: self.contentView.frame.size.height / 2)
        self.shapeLayer.fillColor = UIColor.clear.cgColor
        self.shapeLayer.lineWidth = 1.0
        self.shapeLayer.lineJoin = .round
        self.shapeLayer.allowsEdgeAntialiasing = true
        self.shapeLayer.lineDashPattern = [NSNumber(value: 2), NSNumber(value: 3)]
        
        let path = CGMutablePath()
        path.addRect(shapeRect)
        self.shapeLayer.path = path
        path.closeSubpath()
    }
    
    private func setupConfig() {
        self.isExclusiveTouch = true
        self.isUserInteractionEnabled = true
        self.contentView.isUserInteractionEnabled = true
        self.resizeControl.isUserInteractionEnabled = true
        self.deleteControl.isUserInteractionEnabled = true
        self.rightTopControl.isUserInteractionEnabled = true
        self.leftBottomControl.isUserInteractionEnabled = true
        
        self.enableRightTopControl = true
        self.enableLeftBottomControl = true
        
        self.enabledBorder = true
        self.enabledDeleteControl = true
        self.enabledControl = true
    }
    
    private lazy var contentView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: BoxControlItemHalfWidth, y: BoxControlItemHalfWidth, width: self.frame.size.width, height: self.frame.size.height))
        imageView.contentMode = .scaleAspectFill
        imageView.image = self.contentImage
        return imageView
    }()
    
    private lazy var resizeControl: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: self.contentView.center.x + self.contentView.bounds.size.width / 2 - BoxControlItemHalfWidth, y: self.contentView.center.y + self.contentView.bounds.size.height / 2 - BoxControlItemHalfWidth, width: BoxControlItemWidth, height: BoxControlItemWidth))
        imageView.layer.cornerRadius = BoxControlItemWidth / 2
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private lazy var deleteControl: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: self.contentView.center.x - self.contentView.bounds.size.width / 2 - BoxControlItemHalfWidth, y: self.contentView.center.y - self.contentView.bounds.size.height / 2 - BoxControlItemHalfWidth, width: BoxControlItemWidth, height: BoxControlItemWidth))
        imageView.layer.cornerRadius = BoxControlItemWidth / 2
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private lazy var rightTopControl: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: self.contentView.center.x + self.contentView.bounds.size.width / 2 - BoxControlItemHalfWidth, y: self.contentView.center.y - self.contentView.bounds.self.height / 2 - BoxControlItemHalfWidth, width: BoxControlItemWidth, height: BoxControlItemWidth))
        imageView.layer.cornerRadius = BoxControlItemWidth / 2
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private lazy var leftBottomControl: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: self.contentView.center.x - self.contentView.bounds.size.width / 2 - BoxControlItemHalfWidth, y: self.contentView.center.y + self.contentView.bounds.size.height / 2 - BoxControlItemHalfWidth, width: BoxControlItemWidth, height: BoxControlItemWidth))
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = BoxControlItemWidth / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    
    var enableRightTopControl: Bool = true
    var enableLeftBottomControl: Bool = true
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension BoxStickerView {
    private func attachGestures() {
        let rotateGrsture = UIRotationGestureRecognizer(target: self, action: #selector(self.handleRotate(_:)))
        rotateGrsture.delegate = self
        self.contentView.addGestureRecognizer(rotateGrsture)
        
        let pinGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.handleScale(_:)))
        pinGesture.delegate = self
        self.contentView.addGestureRecognizer(pinGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleMove(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        panGesture.delegate = self
        self.contentView.addGestureRecognizer(panGesture)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.delegate = self
        self.contentView.addGestureRecognizer(tapRecognizer)
        
        let singleHandGesture = BoxStickerRecognizer(target: self, action: #selector(self.handleSingleHandleAction(_:)), anchorView: self.contentView)
        self.resizeControl.addGestureRecognizer(singleHandGesture)
        
        let singleHandGesture1 = BoxStickerRecognizer(target: self, action: #selector(self.handleSingleHandleAction(_:)), anchorView: self.contentView)
        self.deleteControl.addGestureRecognizer(singleHandGesture1)
        
        let singleHandGesture2 = BoxStickerRecognizer(target: self, action: #selector(self.handleSingleHandleAction(_:)), anchorView: self.contentView)
        self.rightTopControl.addGestureRecognizer(singleHandGesture2)
        
        let singleHandGesture3 = BoxStickerRecognizer(target: self, action: #selector(self.handleSingleHandleAction(_:)), anchorView: self.contentView)
        self.leftBottomControl.addGestureRecognizer(singleHandGesture3)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        if gesture.view == self.contentView {
            self.handleTapContentView()
        } else if gesture.view == self.deleteControl {
            if self.enabledDeleteControl {
                self.removeFromSuperview()
                self.delegate?.stickerView(didTapDelete: self)
            }
        } else if gesture.view == self.rightTopControl {
            let targetOrientation: UIImage.Orientation = (self.contentImage.imageOrientation == .up ? .upMirrored : .up)
            if let cgImage = self.contentImage.cgImage {
                let invertImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: targetOrientation)
                self.contentImage = invertImage
            }
        } else if gesture.view == self.leftBottomControl {
            UIView.animate(withDuration: 0.3) {
                if let superview = self.superview {
                    self.center = superview.center
                }
            }
        }
    }
    
    private func handleTapContentView() {
        self.delegate?.stickerView(didTapContent: self)
    }
    
    @objc private func handleMove(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        switch gesture.state {
        case .began:
            break
        case .ended:
            break
        default: break
        }
        
        var targetPoint = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
        targetPoint.x = max(0, targetPoint.x)
        targetPoint.y = max(0, targetPoint.y)
        targetPoint.x = min(self.superview?.bounds.size.width ?? 0, targetPoint.x)
        targetPoint.y = min(self.superview?.bounds.size.height ?? 0, targetPoint.y)
        
        self.center = targetPoint
        gesture.setTranslation(.zero, in: self.superview)
    }
    
    @objc private func handleScale(_ gesture: UIPinchGestureRecognizer) {
        var scale = gesture.scale
        // Scale limit
        var currentScale: CGFloat = 0
        let value = self.contentView.layer.value(forKeyPath: "transform.scale")
        if value is NSNumber {
            currentScale = CGFloat((value as! NSNumber).floatValue)
        } else if self.contentView.layer.value(forKeyPath: "transform.scale") is String {
            currentScale = CGFloat((value as! NSString).floatValue)
        }
        if scale * currentScale <= BoxMinScale {
            scale = BoxMinScale / currentScale
        } else if scale * currentScale >= BoxMaxScale {
            scale = BoxMaxScale / currentScale
        }
        
        self.contentView.transform = CGAffineTransformScale(self.contentView.transform, scale, scale)
        gesture.scale = 1
        
        self.relocalControlView()
    }
    
    @objc private func handleRotate(_ gesture: UIRotationGestureRecognizer) {
        self.contentView.transform = CGAffineTransformRotate(self.contentView.transform, gesture.rotation)
        gesture.rotation = 0
        self.relocalControlView()
    }
    
    @objc private func handleSingleHandleAction(_ gesture: BoxStickerRecognizer) {
        var scale = gesture.scale
        // Scale limit
        var currentScale: CGFloat = 0
        let value = self.contentView.layer.value(forKeyPath: "transform.scale")
        if value is NSNumber {
            currentScale = CGFloat((value as! NSNumber).floatValue)
        } else if self.contentView.layer.value(forKeyPath: "transform.scale") is String {
            currentScale = CGFloat((value as! NSString).floatValue)
        }
        
        if scale * currentScale <= BoxMinScale {
            scale = BoxMinScale / currentScale
        } else if scale * currentScale >= BoxMaxScale {
            scale = BoxMaxScale / currentScale
        }
        
        self.contentView.transform = CGAffineTransformScale(self.contentView.transform, scale, scale)
        self.contentView.transform = CGAffineTransformRotate(self.contentView.transform, gesture.rotation)
        gesture.reset()
        
        self.relocalControlView()
    }
    
    private func relocalControlView() {
        let originalCenter = CGPointApplyAffineTransform(self.contentView.center, CGAffineTransformInvert(self.contentView.transform))
        self.resizeControl.center = CGPointApplyAffineTransform(CGPoint(x: originalCenter.x + self.contentView.bounds.size.width / 2, y: originalCenter.y + self.contentView.bounds.size.height / 2.0), self.contentView.transform)
        self.deleteControl.center = CGPointApplyAffineTransform(CGPoint(x: originalCenter.x - self.contentView.bounds.size.width / 2, y: originalCenter.y - self.contentView.bounds.size.height / 2), self.contentView.transform)
        self.rightTopControl.center = CGPointApplyAffineTransform(CGPoint(x: originalCenter.x + self.contentView.bounds.size.width / 2, y: originalCenter.y - self.contentView.bounds.size.height / 2), self.contentView.transform)
        self.leftBottomControl.center = CGPointApplyAffineTransform(CGPoint(x: originalCenter.x - self.contentView.bounds.size.width / 2, y: originalCenter.y + self.contentView.bounds.size.height / 2), self.contentView.transform)
    }
}

extension BoxStickerView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer || otherGestureRecognizer is UITapGestureRecognizer {
            return false
        } else {
            return true
        }
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.isHidden || !self.isUserInteractionEnabled || self.alpha < 0.01 {
            return nil
        }
        if self.enabledControl {
            if self.resizeControl.point(inside: self.convert(point, to: self.resizeControl), with: event) {
                return self.resizeControl
            }
            if self.enabledDeleteControl && self.deleteControl.point(inside: self.convert(point, to: self.deleteControl), with: event) {
                return self.deleteControl
            }
            if self.enableRightTopControl && self.rightTopControl.point(inside: self.convert(point, to: self.rightTopControl), with: event) {
                return self.rightTopControl
            }
            if self.enableLeftBottomControl && self.leftBottomControl.point(inside: self.convert(point, to: self.leftBottomControl), with: event) {
                return self.leftBottomControl
            }
        }
        if self.contentView.point(inside: self.convert(point, to: self.contentView), with: event) {
            return self.contentView
        }
        return nil
    }
}
