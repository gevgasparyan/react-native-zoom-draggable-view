//
//  RNZoomDraggableView.swift
//  RNZoomDraggableView
//
//  Created by Gevorg Gasparyan on 10/17/17.
//  Copyright © 2017 Gevorg Gasparyan. All rights reserved.
//

import UIKit

class RNZoomDraggableView: RCTView, UIGestureRecognizerDelegate {
  
  var dragStartPositionRelativeToCenter : CGPoint?
  var contentView: UIView!
  
  var maximumZoomScale: CGFloat?
  var minimumZoomScale: CGFloat?
  var zoomScale: CGFloat = 1
  var requiresMinScale: Bool = true
  var needToUpdateContent: Bool = true
  var interactionEnabled: Bool = true
  
  var onViewTap: RCTBubblingEventBlock?
  var onViewTouchStart: RCTBubblingEventBlock?
  var onViewTouchEnd: RCTBubblingEventBlock?
  var onViewLongPress: RCTBubblingEventBlock?
  
  var tapRecognizer: UITapGestureRecognizer!
  var panRecognizer: UIPanGestureRecognizer!
  var pinchRecognizer: UIPinchGestureRecognizer!
  var longPressRecognizer: UILongPressGestureRecognizer!
  
  var longPressEnabled: Bool = true
  deinit {
    if contentView != nil {
      self.contentView.removeObserver(self, forKeyPath: "bounds")
      self.contentView.removeObserver(self, forKeyPath: "bounds")
    }
  }
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
      var updateContent = false
      if let _interactionEnabled = _params.object(forKey: "userInteractionEnabled") as? Bool {
        if self.interactionEnabled !=  _interactionEnabled {
          self.interactionEnabled = _interactionEnabled
          self.isUserInteractionEnabled = _interactionEnabled
          if contentView != nil {
            contentView.isUserInteractionEnabled = _interactionEnabled
          }
        }
      }
      if let _longPressEnabled = _params.object(forKey: "longPressEnabled") as? Bool {
        longPressEnabled = _longPressEnabled
        if longPressRecognizer != nil {
          longPressRecognizer.isEnabled = _longPressEnabled
        }
      }
      if let minZoomScale = _params.object(forKey: "minimumZoomScale") as? CGFloat {
        if self.minimumZoomScale != nil && self.minimumZoomScale != minZoomScale {
          self.minimumZoomScale = minZoomScale
          updateContent = true
        }
        self.minimumZoomScale = minZoomScale
      }
      if let maxZoomScale = _params.object(forKey: "maximumZoomScale") as? CGFloat {
        if self.maximumZoomScale != nil && self.maximumZoomScale != maxZoomScale {
          self.maximumZoomScale = maxZoomScale
          updateContent = true
        }
        self.maximumZoomScale = maxZoomScale
      }
      if let zoomScale = _params.object(forKey: "zoomScale") as? CGFloat {
        self.zoomScale = zoomScale
      }
      if let reqMinScale = _params.object(forKey: "requiresMinScale") as? Bool {
        if self.requiresMinScale != reqMinScale {
          self.requiresMinScale = reqMinScale
          updateContent = true
        }
        self.requiresMinScale = reqMinScale
      }
      if updateContent {
        self.updateContent()
      }
    }
    get {
      return nil
    }
  }
  
  override var bounds: CGRect {
    willSet {
      needToUpdateContent = true
    }
  }
  
  override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
    super.insertSubview(subview, at: atIndex)
    self.contentView = subview
    self.contentView.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
    self.contentView.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.old, context: nil)
    initialSetup()
  }
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath != "bounds" || change == nil {
      return
    }
    var oldBounds = CGRect.zero
    var newBounds = CGRect.zero
    if let new = change![NSKeyValueChangeKey.newKey] as? CGRect {
      newBounds = new
    }
    if let old = change![NSKeyValueChangeKey.oldKey] as? CGRect {
      oldBounds = old
    }
    if !oldBounds.equalTo(newBounds) {
      self.updateContent()
    }
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    if needToUpdateContent {
      needToUpdateContent = false
      updateContent(animated: false)
    }
  }
  
  func initialSetup() {
    self.isUserInteractionEnabled = interactionEnabled
    contentView.isUserInteractionEnabled = interactionEnabled
    
    panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
    panRecognizer.delegate = self
    contentView.addGestureRecognizer(panRecognizer)
    
    pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(gesture:)))
    pinchRecognizer.delegate = self
    contentView.addGestureRecognizer(pinchRecognizer)
    
    longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
    longPressRecognizer.delegate = self
    longPressRecognizer.delaysTouchesBegan = true
    longPressRecognizer.isEnabled = longPressEnabled
    contentView.addGestureRecognizer(longPressRecognizer)
    
    tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
    tapRecognizer.delegate = self
    contentView.addGestureRecognizer(tapRecognizer)
    
    if self.zoomScale != contentView.transform.a {
      contentView.transform = contentView.transform.scaledBy(x: self.zoomScale, y: self.zoomScale)
    }
    if minimumZoomScale == nil {
      let scaleWidth = frame.size.width / contentView.frame.size.width
      let scaleHeight = frame.size.height / contentView.frame.size.height
      self.minimumZoomScale = min(scaleWidth, scaleHeight)
    }
  }
  
  func sendOnTapEvent() {
    if self.onViewTap != nil {
      let event: [String: Any] = [:]
      self.onViewTap!(event);
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

  func updateContent(animated: Bool = true) {
    if contentView == nil {
      return
    }
    var centerX = contentView.center.x
    var centerY = contentView.center.y
    let width = frame.size.width
    let height = frame.size.height
    let contentWidth = contentView.frame.size.width
    let contentHeight = contentView.frame.size.height
    
    var applyMaxMinScale = false
    var changeMaxMinScale = true
    var scaleX = contentView.transform.a
    var scaleY = contentView.transform.a
    let scaleWidth = width / contentWidth
    let scaleHeight = height / contentHeight
    let maxScale = max(scaleWidth, scaleHeight)
    
    if contentView.frame.origin.x > 0 {
      centerX = contentWidth / 2
    } else if contentView.frame.origin.x < width - contentWidth {
      centerX = width - contentWidth / 2
    }
    if contentView.frame.origin.y > 0 {
      centerY = contentHeight / 2
    } else if contentView.frame.origin.y < height - contentHeight {
      centerY = height - contentHeight / 2
    }
    
    if contentWidth < width {
      scaleX = scaleWidth
      centerX = width / 2
      if requiresMinScale {
        scaleX = maxScale
        scaleY = maxScale
        applyMaxMinScale = false
        changeMaxMinScale = false
      }
    }
    if contentHeight < height {
      scaleY = scaleHeight
      centerY = height / 2
      if requiresMinScale {
        scaleX = maxScale
        scaleY = maxScale
        applyMaxMinScale = false
        changeMaxMinScale = false
      }
    }
    
    if changeMaxMinScale && maximumZoomScale != nil && contentView.transform.a > maximumZoomScale! {
      scaleX = maximumZoomScale!
      scaleY = maximumZoomScale!
      applyMaxMinScale = true
    }
    if changeMaxMinScale && minimumZoomScale != nil && contentView.transform.a < minimumZoomScale!  {
      applyMaxMinScale = true
      scaleX = minimumZoomScale!
      scaleY = minimumZoomScale!
    }
    
    if scaleX != contentView.transform.a && scaleY != contentView.transform.a {
      if applyMaxMinScale {
        contentView.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
      } else {
        let scale = min(scaleX, scaleY)
        contentView.transform = contentView.transform.scaledBy(x: scale, y: scale)
      }
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
      self.sendOnTouchStartEvent(numberOfTouches: 1)
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
      updateContent()
      self.sendOnTouchEndEvent(numberOfTouches: 2)
    } else {
      self.sendOnTouchStartEvent(numberOfTouches: 2)
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
  
  @objc func handleTap(gesture: UITapGestureRecognizer) {
    sendOnTapEvent()
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return false
  }
}
