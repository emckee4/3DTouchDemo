//
//  PeekNPopViewController.swift
//  3DTouchDemo
//
//  Created by Evan Mckee on 9/26/15.
//  Copyright © 2015 McKeeMaKer. All rights reserved.
//

import UIKit

class PeekNPopViewController: UIViewController, UIViewControllerPreviewingDelegate {

    @IBOutlet weak var button:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: view)
        } else {
            button.titleLabel!.adjustsFontSizeToFitWidth = true
            button.titleLabel!.text = "Preview Unavailable"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.navigationBarHidden = true
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.navigationBarHidden = false
    }
    
    @IBAction func buttonPressed(sender:UIButton!){
        print("Button pressed. Use peek and pop to transition")
    }
    
    
    //Previewing delegate
    
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        print("previewing")
        let locInButton = self.view.convertPoint(location, toView: button)
        guard  button.pointInside(locInButton, withEvent: nil) else {
            print("previewDelegate: location outside button")
            return nil
        }
        let junkVC = storyboard!.instantiateViewControllerWithIdentifier("junkVC") as! JunkViewController
        previewingContext.sourceRect = button.frame
        
        return junkVC
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        print("commiting")
        showViewController(viewControllerToCommit, sender: self)
    }
    


    

}
