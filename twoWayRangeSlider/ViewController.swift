//
//  ViewController.swift
//  twoWayRangeSlider
//
//  Created by Vihar Shah  on 16/05/17.
//  Copyright © 2017 ViharShah. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var sliderCollection: UICollectionView?
    
    var rangeArray: NSMutableArray = NSMutableArray()
    
    var rangeSliderControl = rangeSlider(frame: CGRectZero)
    
//    MARK: - UIViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        Call this method when you required to initialize two way slider. For this example project I have called it here just to show the slider as soon as view didload.
        self.initializeTwoWaySlider()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = self.sliderCollection?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.invalidateLayout()
    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        rangeSliderControl.frame = CGRectMake(margin, margin + topLayoutGuide.length, width, 25.0)
        
        var frame: CGRect = self.rangeSliderControl.frame
        let x: CGFloat = CGFloat(self.rangeSliderControl.positionForValue(self.rangeSliderControl.minimumValue))
        let collectionWidth: CGFloat = CGFloat(self.rangeSliderControl.positionForValue(self.rangeSliderControl.maximumValue)) - x
        
        frame.origin.x = x;
        frame.origin.y = 0.0
        frame.size.width = collectionWidth
        
        self.sliderCollection?.frame = frame
        self.sliderCollection?.hidden = false
//        Below is the heart of the functionality. Here collection view's layer, which show the value assinged above
        let layer: CALayer = (self.sliderCollection?.layer)!
        self.rangeSliderControl.layer.insertSublayer(layer, above: self.rangeSliderControl.trackLayer)
        
    }
    
//    MARK: - Slider Initializer Method
    
    func initializeTwoWaySlider() {
        //        Configure your slider from here. Below is the defalut/ example setting. You can set your own settings from here.
        
        self.rangeArray = [ "D", "E", "F", "G", "H", "I", "J", "K", "L"] // This Array contains any value which can be displaied on range slider.
        
        rangeSliderControl.backgroundColor = UIColor.clearColor()
        rangeSliderControl.minimumValue = 0.0
        rangeSliderControl.maximumValue = Double(rangeArray.count)
        rangeSliderControl.lowwerValue = rangeSliderControl.minimumValue
        rangeSliderControl.upperValue = rangeSliderControl.maximumValue
        rangeSliderControl.minimumRangeValue = 1.0 // Used to set minimum value between lower and upper Thumb. In this for e.g. it will set minimum possible range is (F-G)
        rangeSliderControl.thumbTintColor = UIColor.blackColor()
        self.view.addSubview(rangeSliderControl)
        
        self.rangeSliderControl.trackHighlightTintColor = UIColor.redColor().colorWithAlphaComponent(0.25)
        self.rangeSliderControl.curvaceousness = 0.0
        
        self.rangeSliderControl.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), forControlEvents: .ValueChanged)
        self.rangeSliderControl.addTarget(self, action: #selector(endRangeSliderValueChanged(_:)), forControlEvents: .TouchUpInside)
        
        //        Add gesture recognizer to the custom slider to get the click on slider track.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(customSliderTrackTapped(_:)))
        self.rangeSliderControl.addGestureRecognizer(tapGestureRecognizer)
    }

//    MARK: - Slider Action mehods
    
    func rangeSliderValueChanged(range_slider: rangeSlider) {
        print("Range Slider current value changed: (\(range_slider.lowwerValue), \(range_slider.upperValue))")
    }
    
    func endRangeSliderValueChanged(range_slider: rangeSlider) {
        print("Range Slider Final value Changed :::: (\(range_slider.lowwerValue), \(range_slider.upperValue))")
        
        let newLowerValue : Double = round(range_slider.lowwerValue)
        let newUpperValue : Double = round(range_slider.upperValue)
        range_slider.lowwerValue = newLowerValue
        range_slider.upperValue = newUpperValue
        
        print("Range Slider Roundoff Value ::: (\(newLowerValue), \(newUpperValue))")
    }
    
    func customSliderTrackTapped(gestureRecognizer: UIGestureRecognizer) {
        
        let slider: rangeSlider = gestureRecognizer.view as! rangeSlider
        if slider.highlighted {
            return
        }
        
        let pointTapped: CGPoint = gestureRecognizer.locationInView(self.view)
        
        var valueOfPointTapped: Double = (Double(pointTapped.x) * rangeSliderControl.maximumValue) / Double(CGRectGetWidth(rangeSliderControl.frame))
        print("Value at point tapped ::: \(valueOfPointTapped)")
        
        valueOfPointTapped = round(valueOfPointTapped)
        print("Roundof Value at point tapped ::: \(valueOfPointTapped)")
        
        let centerOfCurrentRange: Double = (rangeSliderControl.maximumValue - rangeSliderControl.minimumValue) / 2
        
        if valueOfPointTapped <= centerOfCurrentRange {
            rangeSliderControl.lowwerValue = valueOfPointTapped
        } else if valueOfPointTapped > centerOfCurrentRange {
            rangeSliderControl.upperValue = valueOfPointTapped
        } else {
            print("Value ::: \(valueOfPointTapped) ::: Return")
            return
        }
        
    }
    
//    MARK: - UICollectionView Datasource methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rangeArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let item = self.sliderCollection?.dequeueReusableCellWithReuseIdentifier("sliderItem",  forIndexPath: indexPath) as! rangeCollectionViewCell
        
        item.titleLbl?.text = "\(rangeArray[indexPath.row])"
        item.titleLbl?.textAlignment = .Center
        return item
    }
    
    
//    MARK: - UICollectionView Delegate Flow Layout method
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let collectionFrame: CGRect = collectionView.frame
        let count = CGFloat(rangeArray.count)
        let width: CGFloat = (collectionFrame.size.width / count) as CGFloat
        
        let itemSize: CGSize = CGSizeMake(width, collectionFrame.size.height)
        
        return itemSize
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

