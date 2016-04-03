//
//  AboutViewController.swift
//  ScrollviewTest
//
//  Created by Yung-Tien Chu on 11/25/15.
//  Copyright © 2015 Yung-Tien Chu. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    var address: String = ""
    var city: String = ""
    var state: String = ""
    var unitIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "goBackFromAboutSegue") {
            let svc = segue.destinationViewController as! SearchFormViewController;
            
            svc.address = self.address
            svc.city = self.city
            svc.state = self.state
            svc.unitIndex = self.unitIndex
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
