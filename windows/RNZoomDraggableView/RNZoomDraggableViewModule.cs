using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Zoom.Draggable.View.RNZoomDraggableView
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNZoomDraggableViewModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNZoomDraggableViewModule"/>.
        /// </summary>
        internal RNZoomDraggableViewModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNZoomDraggableView";
            }
        }
    }
}
