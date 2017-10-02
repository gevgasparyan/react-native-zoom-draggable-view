//
//  RNZoomDraggableViewManager.swift
//

import UIKit

@objc(RNZoomDraggableViewManager)
class RNZoomDraggableViewManager: RCTViewManager {
    
    @objc override func view() -> UIView! {
        return RNZoomDraggableView()
    }
}

