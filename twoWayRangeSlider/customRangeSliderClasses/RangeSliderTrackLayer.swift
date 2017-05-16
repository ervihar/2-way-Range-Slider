//
//  RangeSliderTrackLayer.swift
//  swiftGeneralDemo
//
//  Created by Vihar Shah  on 01/05/17.
//  Copyright © 2017 ViharShah . All rights reserved.
//

import UIKit
import QuartzCore

class RangeSliderTrackLayer: CALayer {
    weak var range_slider: rangeSlider?
    
    override func drawInContext(ctx: CGContext) {
        if let slider = range_slider {
//            Clip
            let cornerRadius = bounds.height * slider.curvaceousness / 2.0
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            CGContextAddPath(ctx, path.CGPath)
            
//            Fill the track
            CGContextSetFillColorWithColor(ctx, slider.trackTintColor.CGColor)
            CGContextAddPath(ctx, path.CGPath)
            CGContextFillPath(ctx)
            
//            Fill the highlighted range
            CGContextSetFillColorWithColor(ctx, slider.trackHighlightTintColor.CGColor)
            let lowerValuePosition = CGFloat(slider.positionForValue(slider.lowwerValue))
            let upperValuePosition = CGFloat(slider.positionForValue(slider.upperValue))
            let rect = CGRectMake(lowerValuePosition, 0.0, upperValuePosition - lowerValuePosition, bounds.height)
            
            CGContextFillRect(ctx, rect)
            
        }
        
    }

}
