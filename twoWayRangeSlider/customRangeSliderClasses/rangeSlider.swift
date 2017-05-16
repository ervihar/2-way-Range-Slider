//
//  rangeSlider.swift
//  swiftFullDemo
//
//  Created by Vihar Shah  on 19/04/17.
//  Copyright © 2017 ViharShah . All rights reserved.
//

import UIKit
import QuartzCore


class rangeSlider: UIControl {
    
/**
 * Minimum Range value for the 2 Way range slider : Vihar
 */
    var minimumValue: Double = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
/**
 * Maximum Range value for the 2 Way range slider : Vihar
 */
    var maximumValue: Double = 1.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
/**
 * Default lowwer value for the 2 Way range slider : Vihar
 */
    var lowwerValue: Double = 0.2 {
        didSet {
            updateLayerFrames()
        }
    }
    
/**
 * Default upper value for the 2 Way range slider : Vihar
 */
    var upperValue: Double = 0.8 {
        didSet {
            updateLayerFrames()
        }
    }

/**
 * Returns bool value true if currently lower thumb is updating/Active. : Vihar
 */
    var isLowerThumb: Bool = false
/**
 * Returns bool value true if currently upper thumb is updating/Active. : Vihar
 */
    var isUpperThumb: Bool = false
   
/**
 * Set to TRUE when range slider's selected value required to be roundOff/ whole : Vihar
 */
    var isRoundOffValue = true
    
/**
 * Set the minimum range value.
 */
    var minimumRangeValue: Double = 1.0
    
    
    
    let trackLayer = RangeSliderTrackLayer()
    let lowwerThumbLayer = RangeSliderThumbLayer()
    let upperThumbeLayer = RangeSliderThumbLayer()
    
    var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    var previousLocation = CGPoint()
    
    var trackTintColor: UIColor = UIColor(white: 0.9, alpha: 1.0) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    var trackHighlightTintColor: UIColor = UIColor(red: 0.0, green: 0.45, blue: 0.94, alpha: 1.0) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    var thumbTintColor: UIColor = UIColor.whiteColor() {
        didSet {
            lowwerThumbLayer.setNeedsDisplay()
            upperThumbeLayer.setNeedsDisplay()
        }
    }
    
    var curvaceousness: CGFloat = 1.0 {
        didSet {
            trackLayer.setNeedsDisplay()
            lowwerThumbLayer.setNeedsDisplay()
            upperThumbeLayer.setNeedsDisplay()
        }
    }
    
    
    
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        trackLayer.range_slider = self
        trackLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(trackLayer)
        
        lowwerThumbLayer.range_Slider = self
        lowwerThumbLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(lowwerThumbLayer)
        
        upperThumbeLayer.range_Slider = self
        upperThumbeLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(upperThumbeLayer)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
//    MARK: - Custom Methods Related to Frame
    
    func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: 0.0)
        trackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(lowwerValue))
        lowwerThumbLayer.frame = CGRectMake(lowerThumbCenter - thumbWidth , -5.0, thumbWidth, thumbWidth + 10)
        lowwerThumbLayer.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(upperValue))
        upperThumbeLayer.frame = CGRectMake(upperThumbCenter, -5.0, thumbWidth, thumbWidth + 10)
        upperThumbeLayer.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    func positionForValue(value: Double) -> Double {
        
        let width: Double = Double(bounds.width - thumbWidth)
        let positionValue: Double = value - minimumValue
        let maxMin: Double = maximumValue - minimumValue
        let halfThumbWidth: Double = Double(thumbWidth / 2.0)
        
        let position: Double = width * positionValue / maxMin + halfThumbWidth
        
        return position
    }
    
//    MARK: - Touch Handeler Methods
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        previousLocation = touch.locationInView(self)
        
//        Hit test the thumb layers
        if lowwerThumbLayer.frame.contains(previousLocation) {
            lowwerThumbLayer.highlighted = true
            isLowerThumb = true
            isUpperThumb = false
        } else if upperThumbeLayer.frame.contains(previousLocation) {
            upperThumbeLayer.highlighted = true
            isLowerThumb = false
            isUpperThumb = true
        }
        
        return lowwerThumbLayer.highlighted || upperThumbeLayer.highlighted
    }
    
    func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let location = touch.locationInView(self)
        
//        1. Determine by how much the user has dragged
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - thumbWidth)
        
        previousLocation = location
        
//        2. Update the values

            if lowwerThumbLayer.highlighted {
                lowwerValue += deltaValue
                lowwerValue = boundValue(lowwerValue, toLowerValue: minimumValue, upperValue: (upperValue - minimumRangeValue))
            } else if upperThumbeLayer.highlighted {
                upperValue += deltaValue
                upperValue = boundValue(upperValue, toLowerValue: (lowwerValue + minimumRangeValue), upperValue: maximumValue)
            }
        
//        3. Update the UI
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        updateLayerFrames()
        
        CATransaction.commit()
        
        sendActionsForControlEvents(.ValueChanged)
        
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        lowwerThumbLayer.highlighted = false
        upperThumbeLayer.highlighted = false
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
