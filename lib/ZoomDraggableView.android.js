import React, { Component } from 'react';
import { View } from 'react-native';

export class ZoomDraggableView extends Component {
    render() {
        const { ...props } = this.props;
        return (
            <View
                {...props}
            >
                {children}
            </View>
          );
    }
}
