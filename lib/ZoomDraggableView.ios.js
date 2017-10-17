import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { View, requireNativeComponent } from 'react-native';

export class ZoomDraggableView extends Component {
  static propTypes = {
    ...View.propTypes,
    requiresMinScale: PropTypes.bool,
    userInteractionEnabled: PropTypes.bool,
    longPressEnabled: PropTypes.bool,
    maximumZoomScale: PropTypes.number,
    minimumZoomScale: PropTypes.number,
    zoomScale: PropTypes.number,
    params: PropTypes.object,
    onTouchStart: PropTypes.func,
    onTouchEnd: PropTypes.func,
    onLongPress: PropTypes.func,
    onTap: PropTypes.func,
  };

  _onTap = (event) => {
    if (this.props.onTap) {
      this.props.onTap(event);
    }
  };

  _onTouchStart = (event) => {
    if (this.props.onTouchStart) {
      this.props.onTouchStart(event);
    }
  }

  _onTouchEnd = (event) => {
    if (this.props.onTouchEnd) {
      this.props.onTouchEnd(event);
    }
  }

  _onLongPress = (event) => {
    if (this.props.onLongPress) {
      this.props.onLongPress(event);
    }
  }
  render() {
    const {
      children,
      requiresMinScale,
      userInteractionEnabled,
      longPressEnabled,
      maximumZoomScale,
      minimumZoomScale,
      zoomScale,
      ...props,
    } = this.props;
    const params = {
      maximumZoomScale,
      minimumZoomScale,
      zoomScale,
      requiresMinScale,
      userInteractionEnabled,
      longPressEnabled,
    };
    return (
      <RNZoomDraggableView
        {...props}
        params={params}
        onViewTouchStart={this._onTouchStart}
        onViewTouchEnd={this._onTouchEnd}
        onViewLongPress={this._onLongPress}
        onViewTap={this._onTap}
      >
        {children}
      </RNZoomDraggableView>
    );
  }
}

const RNZoomDraggableView = requireNativeComponent('RNZoomDraggableView', ZoomDraggableView, {
  nativeOnly: {
    onViewTap: true,
    onViewTouchEnd: true,
    onViewTouchStart: true,
    onViewLongPress: true
  }
});
