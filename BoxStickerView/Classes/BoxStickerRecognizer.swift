//
//  BoxStickerRecognizer.swift
//  IDPhoto
//
//  Created by Liqun Zhang on 2023/8/14.
//

import UIKit

class BoxStickerRecognizer: UIGestureRecognizer {
    var scale: CGFloat = 0
    var rotation: CGFloat = 0
    let anchorView: UIView
    init(target: Any?, action: Selector?, anchorView: UIView) {
        self.anchorView = anchorView
        super.init(target: target, action: action)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if event.touches(for: self)?.count ?? 0 > 1 {
            self.state = .failed
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if self.state == .possible {
            self.state = .began
        } else {
            self.state = .changed
        }
        
        let touch = touches.randomElement()
        let anchorViewCenter = self.anchorView.center
        let currentPoint = touch?.location(in: self.anchorView.superview)
        let previousPoint = touch?.previousLocation(in: self.anchorView.superview)
        
        let currentRotation = atan2f(Float((currentPoint?.y ?? 0 - anchorViewCenter.y)), Float((currentPoint?.x ?? 0 - anchorViewCenter.x)))
        let previousRotation = atan2f(Float(previousPoint?.y ?? 0 - anchorViewCenter.y), Float(previousPoint?.x ?? 0 - anchorViewCenter.x))
        
        let currentRadius = self.distanceBetween(first: currentPoint ?? .zero, second: anchorViewCenter)
        let previousRadius = self.distanceBetween(first: previousPoint ?? .zero, second: anchorViewCenter)
        let scale = currentRadius / previousRadius
        self.rotation = CGFloat(currentRotation - previousRotation)
        self.scale = scale
    }
    
    private func distanceBetween(first: CGPoint, second: CGPoint) -> CGFloat {
        let deltaX = second.x - first.x
        let deltaY = second.y - first.y
        return sqrt(deltaX * deltaX + deltaY * deltaY)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        if self.state == .changed {
            self.state = .ended
        } else {
            self.state = .failed
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .failed
    }
    
    override func reset() {
        self.rotation = 0
        self.scale = 1
    }
}
