//
//  RNZoomDraggableViewBridge.m
//

#import <Foundation/Foundation.h>

#import "React/RCTBridgeModule.h"
#import "React/RCTViewManager.h"

@interface RCT_EXTERN_MODULE(RNZoomDraggableViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(params, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(onViewTouchStart, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onViewTouchEnd, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onViewLongPress, RCTBubblingEventBlock)

@end

