//
//  ViewController.swift
//  3DTouchDemo
//
//  Created by Evan Mckee on 9/26/15.
//  Copyright © 2015 McKeeMaKer. All rights reserved.
//

import UIKit

class PressueViewController: UIViewController {
    
    
    @IBOutlet weak var pressurePadView:UIView!
    
    var tapRecognizer:UITapGestureRecognizer!
    var touchCircles:Set<UIView> = []
    
    var forceTouchEnabled:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tapRecognizer = UITapGestureRecognizer(target: self, action: "tapRecognizerEvent:")
        //pressurePadView.addGestureRecognizer(tapRecognizer)
        pressurePadView.clipsToBounds = true
        pressurePadView.multipleTouchEnabled = true
        pressurePadView.layer.cornerRadius = 5.0
        forceTouchEnabled = self.traitCollection.forceTouchCapability == .Available
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !forceTouchEnabled {
            let alert = UIAlertController(title: "Force touch unavailable", message: "This demo is designed to work with force touch enabled devices. It's pretty boring otherwise.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        

    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        //print("touches began  ")
        handleTouches(touches)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        handleTouches(touches)
    }

   
//
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        handleTouches(touches)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        if let touches = touches {
            handleTouches(touches)
        }
        
    }
    
    
    func handleTouches(touches:Set<UITouch>){
        for touch in touches {
            let locInPad = touch.locationInView(pressurePadView)
            if touch.phase != .Began {
                //remove old view circle (there won't be one if the previous touch wasn't in the pressurePadView
                let previous = touch.previousLocationInView(pressurePadView)
                if pressurePadView.pointInside(previous, withEvent: nil) {
                    //remove old
                    if let viewToRemove = touchCircles.filter({$0.center == previous}).first {
                        viewToRemove.removeFromSuperview()
                        touchCircles.remove(viewToRemove)
                    } else if let viewToRemove = touchCircles.filter({$0.center == locInPad}).first {
                        viewToRemove.removeFromSuperview()
                        touchCircles.remove(viewToRemove)
                        } else {
                            print("view to remove not found: current: \(locInPad), previous \(previous); with existing = \(touchCircles.map({$0.center}))")
                        }
                }
            }
            
            if touch.phase != .Ended && touch.phase != .Cancelled {
                //draw new touch object if touch is inside
                if pressurePadView.pointInside(locInPad, withEvent: nil) {
                    
                    let forcePercentage:Int = forceTouchEnabled == true ? Int((touch.force / touch.maximumPossibleForce) * 100.0) : 0
                    drawCircleWithStats(locInPad, diameter: 90.0, forcePercentage: forcePercentage)
                }
            }
        }



    }
    
    
    func drawCircleWithStats(centerInPadView:CGPoint, diameter:CGFloat, forcePercentage:Int){
        let circleContainer = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 1.5 * diameter, height: 1.5 * diameter)))
        circleContainer.center = centerInPadView
        
        let circleView = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: diameter, height: diameter)))
        circleView.center = CGPoint(x: circleContainer.bounds.midX, y: circleContainer.bounds.midY)
        circleView.backgroundColor = UIColor(white: 0.5, alpha: 0.8)
        circleView.clipsToBounds = true
        circleView.layer.cornerRadius = diameter / 2.0
        circleContainer.addSubview(circleView )
        self.pressurePadView.addSubview(circleContainer)
        self.touchCircles.insert(circleContainer)
        
        let topLeftInSuper = pressurePadView.pointInside(circleContainer.frame.origin, withEvent: nil)
        let topRightInSuper = pressurePadView.pointInside(CGPoint(x:circleContainer.frame.maxX,y:circleContainer.frame.minY), withEvent: nil)
        
        let statsLabel = UILabel(frame: CGRectZero)
        statsLabel.text = "Force: \(forcePercentage)%"
        statsLabel.sizeToFit()
        let labelWidth = statsLabel.bounds.width
        let labelHeight = statsLabel.bounds.height
        
        
        if topLeftInSuper && topRightInSuper {
            statsLabel.frame.offsetInPlace(dx: (circleContainer.bounds.width - labelWidth) / 2.0 , dy: 0)
        } else if topLeftInSuper {
            //do nothing because the label is already in the top left
        } else if topRightInSuper {
            statsLabel.frame.offsetInPlace(dx: (circleContainer.bounds.width - labelWidth) , dy: 0)
        } else {
            statsLabel.frame.offsetInPlace(dx: (circleContainer.bounds.width - labelWidth) / 2.0 , dy: (circleContainer.bounds.height - labelHeight))
        }
        
        
        circleContainer.addSubview(statsLabel)
    }
    

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        for circle in touchCircles {
            circle.removeFromSuperview()
        }
        touchCircles.removeAll()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        for circle in touchCircles {
            circle.removeFromSuperview()
        }
        touchCircles.removeAll()
    }
 
    
}

