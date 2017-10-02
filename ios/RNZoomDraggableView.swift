//
//  RNZoomDraggableView.swift
//

import UIKit

class RNZoomDraggableView: RCTView, UIGestureRecognizerDelegate {
    
    var dragStartPositionRelativeToCenter : CGPoint?
    var contentView: UIView!
    
    var maximumZoomScale: CGFloat?
    var minimumZoomScale: CGFloat?
    var zoomScale: CGFloat = 1
    
    var onViewTouchStart: RCTBubblingEventBlock?
    var onViewTouchEnd: RCTBubblingEventBlock?
    var onViewLongPress: RCTBubblingEventBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var params: NSDictionary? {
        set {
            guard let _params = newValue else { return }
            
            if let minZoomScale = _params.object(forKey: "minimumZoomScale") as? CGFloat {
                self.minimumZoomScale = minZoomScale
            }
            if let maxZoomScale = _params.object(forKey: "maximumZoomScale") as? CGFloat {
                self.maximumZoomScale = maxZoomScale
            }
            if let zoomScale = _params.object(forKey: "zoomScale") as? CGFloat {
                self.zoomScale = zoomScale
            }
        }
        get {
            return nil
        }
    }
    
    override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
        super.insertSubview(subview, at: atIndex)
        self.contentView = subview
        initialSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateContent(animated: false)
    }
    
    func initialSetup() {
        self.isUserInteractionEnabled = true
        contentView.isUserInteractionEnabled = true
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        panRecognizer.delegate = self
        self.contentView.addGestureRecognizer(panRecognizer)
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(gesture:)))
        pinchRecognizer.delegate = self
        self.contentView.addGestureRecognizer(pinchRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        longPressRecognizer.delegate = self
        longPressRecognizer.delaysTouchesBegan = true
        self.contentView.addGestureRecognizer(longPressRecognizer)
        
        if self.zoomScale != contentView.transform.a {
            contentView.transform = contentView.transform.scaledBy(x: self.zoomScale, y: self.zoomScale)
        }
    }
    
    func sendOnTouchStartEvent(numberOfTouches: Int) {
        if self.onViewTouchStart != nil {
            let event = ["numberOfTouches": numberOfTouches]
            self.onViewTouchStart!(event);
        }
    }
    
    func sendOnTouchEndEvent(numberOfTouches: Int) {
        if self.onViewTouchEnd != nil {
            let event = ["numberOfTouches": numberOfTouches]
            self.onViewTouchEnd!(event)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.sendOnTouchStartEvent(numberOfTouches: touches.count)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
    func updateContent(animated: Bool = true) {
        var centerX = contentView.center.x
        var centerY = contentView.center.y
        if contentView.frame.origin.x > 0 {
            centerX = contentView.frame.size.width / 2
        }
        if contentView.frame.origin.x < self.frame.size.width - contentView.frame.size.width {
            if contentView.transform.a > 1 {
                centerX = self.frame.size.width - contentView.frame.size.width / 2
            } else {
                centerX = -(contentView.frame.size.width - self.frame.size.width - contentView.frame.size.width / 2)
            }
        }
        if contentView.frame.origin.y > 0 {
            centerY = contentView.frame.size.height / 2
        }
        if contentView.frame.origin.y < self.frame.size.height - contentView.frame.size.height {
            if contentView.transform.a > 1 {
                centerY = self.frame.size.height - contentView.frame.size.height / 2
            } else {
                centerY = -(contentView.frame.size.height - self.frame.size.height - contentView.frame.size.height / 2)
            }
        }
        var scaleX = contentView.transform.a
        var scaleY = contentView.transform.a
        
        if contentView.frame.size.width < self.frame.size.width {
            scaleX = self.frame.size.width / contentView.frame.size.width
            centerX = self.frame.size.width / 2
        }
        if contentView.frame.size.height < self.frame.size.height {
            scaleY = self.frame.size.height / contentView.frame.size.height
            centerY = self.frame.size.height / 2
        }
        
        if scaleX != contentView.transform.a && scaleY != contentView.transform.a {
            let scale = min(scaleX, scaleY)
            contentView.transform = contentView.transform.scaledBy(x: scale, y: scale)
        }
        if centerX != contentView.center.x || centerY != contentView.center.y {
            if animated {
                UIView.animate(withDuration: 0.1) {
                    self.contentView.center = CGPoint(x: centerX, y: centerY)
                }
            } else {
                self.contentView.center = CGPoint(x: centerX, y: centerY)
            }
        }
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.began {
            let locationInView = gesture.location(in: self)
            dragStartPositionRelativeToCenter = CGPoint(x: locationInView.x - contentView.center.x, y: locationInView.y - contentView.center.y)
            return
        }
        
        if gesture.state == UIGestureRecognizerState.ended {
            updateContent()
            dragStartPositionRelativeToCenter = nil
            self.sendOnTouchEndEvent(numberOfTouches: 1)
            return
        }
        
        let locationInView = gesture.location(in: self)
        UIView.animate(withDuration: 0.1) {
            self.contentView.center = CGPoint(x: locationInView.x - self.dragStartPositionRelativeToCenter!.x,
                                              y: locationInView.y - self.dragStartPositionRelativeToCenter!.y)
        }
    }
    
    @objc func handlePinch(gesture: UIPinchGestureRecognizer) {
        contentView.transform = contentView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1;
        if gesture.state == .ended {
            self.sendOnTouchEndEvent(numberOfTouches: 2)
        }
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if onViewLongPress == nil {
            return
        }
        if gesture.state == .began {
            onViewLongPress!(["touchEnd": false])
        }
        if gesture.state == .ended {
            onViewLongPress!(["touchEnd": true])
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

