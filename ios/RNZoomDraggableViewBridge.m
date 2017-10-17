//
//  RNZoomDraggableViewBridge.m
//  RNZoomDraggableView
//
//  Created by Gevorg Gasparyan on 10/17/17.
//  Copyright © 2017 Gevorg Gasparyan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "React/RCTBridgeModule.h"
#import "React/RCTViewManager.h"

@interface RCT_EXTERN_MODULE(RNZoomDraggableViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(params, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(onViewTouchStart, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onViewTouchEnd, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onViewLongPress, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onViewTap, RCTBubblingEventBlock)

@end
