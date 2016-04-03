//
//  SearchFormViewController.swift
//  ScrollviewTest
//
//  Created by Yung-Tien Chu on 11/25/15.
//  Copyright © 2015 Yung-Tien Chu. All rights reserved.
//

import UIKit

class SearchFormViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var address: String = ""
    var city: String = ""
    var state: String = ""
    var unitIndex: Int = 0
    @IBOutlet weak var streetLabel: UITextField!
    @IBOutlet weak var cityLabel: UITextField!
    @IBOutlet weak var stateLabel: UITextField!
    @IBOutlet weak var unitSwitchView: UIView!
    var selectedUnit: Int!
    let pickerData = [
        "AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA",
        "HI","ID","IL","IN","IA","KS","KY","LA","ME","MD",
        "MA","MI","MS","MN","MO","MT","NE","NV","NH","NJ",
        "NM","NY","NC","ND","OH","OK","OR","PA","RI","SC",
        "SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"
    ]
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tap)
        configureSwitch()
        let statePickerview = UIPickerView()
        
        statePickerview.dataSource = self
        statePickerview.delegate = self
        
        // retain values after one search
        streetLabel.text! = address
        cityLabel.text! = city
        stateLabel.text! = state
        
        
        stateLabel.inputView = statePickerview
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearForm(sender: AnyObject) {
        
        streetLabel.text = ""
        cityLabel.text = ""
        stateLabel.text = ""
        
    }
    
    @IBAction func toForecastio(sender: AnyObject) {
        
        let application = UIApplication.sharedApplication()
        if  let targetURL = NSURL(string: "http://forecast.io") {
            application.openURL(targetURL)
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        var validated = true
        var streetFilled = false
        var cityFilled = false
        var stateFilled = false
        if identifier == "searchSegue" {
            
            if (streetLabel.text!.isEmpty) {
                streetLabel.attributedPlaceholder = NSAttributedString(string:"Enter Street!",
                    attributes:[NSForegroundColorAttributeName: UIColor.yellowColor()])
            } else {
                streetFilled = true
            }
            validated = validated && streetFilled
            if (cityLabel.text!.isEmpty) {
                cityLabel.attributedPlaceholder = NSAttributedString(string:"Enter City!",
                    attributes:[NSForegroundColorAttributeName: UIColor.yellowColor()])
            } else {
                cityFilled = true
            }
            validated = validated && cityFilled
            if (stateLabel.text!.isEmpty) {
                stateLabel.attributedPlaceholder = NSAttributedString(string:"Pick your State!",
                    attributes:[NSForegroundColorAttributeName: UIColor.yellowColor()])
            } else {
                stateFilled = true
            }
            validated = validated && stateFilled
        }
        
        return validated
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "searchSegue") {
            let svc = segue.destinationViewController as! ViewController;
            
            svc.address = streetLabel.text!
            svc.city = cityLabel.text!
            svc.state = stateLabel.text!
            if let selected = selectedUnit {
                svc.unitIndex = selected
            } else {
                svc.unitIndex = 0
            }
        }
        if (segue.identifier == "aboutSegue") {
            let svc = segue.destinationViewController as! AboutViewController;
            
            svc.address = streetLabel.text!
            svc.city = cityLabel.text!
            svc.state = stateLabel.text!
            if let selected = selectedUnit {
                svc.unitIndex = selected
            } else {
                svc.unitIndex = 0
            }
        }
    }
    
    func configureSwitch() {
        let runkeeperSwitch = DGRunkeeperSwitch()
        runkeeperSwitch.leftTitle = "ºC"
        runkeeperSwitch.rightTitle = "ºF"
        runkeeperSwitch.backgroundColor = .whiteColor()
        runkeeperSwitch.selectedBackgroundColor = UIColor(red: 64/255.0, green: 151/255.0, blue: 211/255.0, alpha: 1)
        runkeeperSwitch.titleColor = UIColor(red: 64/255.0, green: 136/255.0, blue: 211/255.0, alpha: 1)
        runkeeperSwitch.selectedTitleColor = .whiteColor()
        runkeeperSwitch.titleFont = UIFont(name: "Futura-Condensed-Medium", size: 17.0)
        runkeeperSwitch.frame = CGRect(x: 0, y: 0, width: 140, height: 30.0)
        runkeeperSwitch.translatesAutoresizingMaskIntoConstraints = false
        runkeeperSwitch.setSelectedIndex(unitIndex, animated: true)
        unitSwitchView.addSubview(runkeeperSwitch)
        runkeeperSwitch.addTarget(self, action: Selector("switchValueDidChange:"), forControlEvents: .ValueChanged)
        
        
    }
    
    func switchValueDidChange(sender: DGRunkeeperSwitch!) {
        // 0: C, 1: F
        selectedUnit = sender.selectedIndex
        print("valueChanged: \(selectedUnit)")
    }

    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateLabel.text = pickerData[row]
    }
    
    func dissmissKeyboard() {
        streetLabel.resignFirstResponder()
        cityLabel.resignFirstResponder()
        stateLabel.resignFirstResponder()
        
    }
 
}
