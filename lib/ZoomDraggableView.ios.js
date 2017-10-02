import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { View, requireNativeComponent } from 'react-native';

export class ZoomDraggableView extends Component {
    static propTypes = {
        ...View.propTypes,
        maximumZoomScale: PropTypes.number,
        minimumZoomScale: PropTypes.number,
        zoomScale: PropTypes.number,
        params: PropTypes.object,
        onTouchStart: PropTypes.func,
        onTouchEnd: PropTypes.func,
        onLongPress: PropTypes.func
    };

    constructor(...args) {
        super(...args);
    }

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
            maximumZoomScale,
            minimumZoomScale,
            zoomScale,
            onTouchStart,
            onTouchEnd,
            onViewLongPress,
            ...props,
        } = this.props;
        const params = {
            maximumZoomScale,
            minimumZoomScale,
            zoomScale,
        };
        return (
            <RNZoomDraggableView
                {...props}
                params={params}
                onViewTouchStart={this._onTouchStart}
                onViewTouchEnd={this._onTouchEnd}
                onViewLongPress={this._onLongPress}
            >
                {children}
            </RNZoomDraggableView>
          );
    }
}

const RNZoomDraggableView = requireNativeComponent('RNZoomDraggableView', ZoomDraggableView, {
    nativeOnly: {
        onViewTouchEnd: true,
        onViewTouchStart: true,
        onViewLongPress: true
    }
});
