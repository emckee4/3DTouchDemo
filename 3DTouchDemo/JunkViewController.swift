//
//  JunkViewController.swift
//  3DTouchDemo
//
//  Created by Evan Mckee on 9/26/15.
//  Copyright © 2015 McKeeMaKer. All rights reserved.
//

import UIKit

class JunkViewController: UIViewController {

    @IBOutlet weak var textView:UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func previewActionItems() -> [UIPreviewActionItem] {
        let item = UIPreviewAction(title: "Do Some Action", style: .Destructive) { (action, previewVC) -> Void in
            print(action.title)
        }
        
        let groupItem = UIPreviewAction(title: "Some Action in Group", style: UIPreviewActionStyle.Default) { (action, previewVC) -> Void in
            print(action.title)
        }
        let group = UIPreviewActionGroup(title: "Some Action Group", style: .Default, actions: [groupItem])
        return [item,group]
    }

}
