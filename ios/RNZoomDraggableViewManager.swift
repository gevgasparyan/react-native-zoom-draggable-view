//
//  RNZoomDraggableViewManager.swift
//  RNZoomDraggableView
//
//  Created by Gevorg Gasparyan on 10/17/17.
//  Copyright © 2017 Gevorg Gasparyan. All rights reserved.
//

import UIKit

@objc(RNZoomDraggableViewManager)
class RNZoomDraggableViewManager: RCTViewManager {
    
    @objc override func view() -> UIView! {
        return RNZoomDraggableView()
    }
}

