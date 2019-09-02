//
//  LengthViewController.swift
//  iCalc-CW1
//
//  Created by Smoking Dots on 4/7/19.
//  Copyright © 2019 studentasd. All rights reserved.
//

import UIKit

class LengthViewController: UIViewController {
    
    @IBOutlet weak var meterField: CustomTextField!
    @IBOutlet weak var mileField: CustomTextField!
    @IBOutlet weak var cmField: CustomTextField!
    @IBOutlet weak var mmField: CustomTextField!
    @IBOutlet weak var yardField: CustomTextField!
    @IBOutlet weak var inchField: CustomTextField!
    
    var tabBarFrameOriginY = CGFloat()  // stores tab bar's original y-origin
    private var lengthArray = [String]()
    
    // letting the HistoryViewController know to show length history
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HistoryViewController {
            let vc = segue.destination as? HistoryViewController
            vc?.comingFrom = "length"
            print("COMING FROM LENGTH")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //add a notification for when the keyboard shows and and disappears
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // unsubscribe to keyboard notification
        self.view.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        //this moves the tab bar above the keyboard for all devices
        var tabBarFrame: CGRect = (self.tabBarController?.tabBar.frame)!
        
        tabBarFrameOriginY = tabBarFrame.origin.y
        
        if let keyboard = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tabBarFrame.origin.y = keyboard.origin.y - tabBarFrame.size.height
        }
        
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            self.tabBarController?.tabBar.frame = tabBarFrame
        })
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        ///this restores the tab bar to its original position
        var tabBarFrame: CGRect = (self.tabBarController?.tabBar.frame)!
        
        tabBarFrame.origin.y = tabBarFrameOriginY
        
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            self.tabBarController?.tabBar.frame = tabBarFrame
        })
    }
    
    @IBAction func meterChanged(_ sender: Any) {
        
        let meterValue = (self.meterField.text! as NSString).floatValue
        let mileValue = meterToMile(meter: meterValue)
        let cmValue = meterToCm(meter: meterValue)
        let mmValue = meterToMm(meter: meterValue)
        let yardValue = meterToYard(meter: meterValue)
        let inchValue = meterToInch(meter: meterValue)
        
        if(meterValue != 0) {
            self.mileField.text = String(format: "%.4f", mileValue)
            self.cmField.text = String(format: "%.4f", cmValue)
            self.mmField.text = String(format: "%.4f", mmValue)
            self.yardField.text = String(format: "%.4f", yardValue)
            self.inchField.text = String(format: "%.4f", inchValue)
        } else {
            emptyAllFields()
        }
    }
    
    @IBAction func mileChanged(_ sender: CustomTextField) {
        
        let mileValue = (self.mileField.text! as NSString).floatValue
        let meterValue = miletoMeter(mile: mileValue)
        let cmValue = meterToCm(meter: meterValue)
        let mmValue = meterToMm(meter: meterValue)
        let yardValue = meterToYard(meter: meterValue)
        let inchValue = meterToInch(meter: meterValue)
        
        if(mileValue != 0) {
            self.meterField.text = String(format: "%.4f", meterValue)
            self.cmField.text = String(format: "%.4f", cmValue)
            self.mmField.text = String(format: "%.4f", mmValue)
            self.yardField.text = String(format: "%.4f", yardValue)
            self.inchField.text = String(format: "%.4f", inchValue)
        } else {
            emptyAllFields()
        }
    }
    
    @IBAction func cmChanged(_ sender: CustomTextField) {
        
        let cmValue = (self.cmField.text! as NSString).floatValue
        let meterValue = cmToMeter(cm: cmValue)
        let mileValue = meterToMile(meter: meterValue)
        let mmValue = meterToMm(meter: meterValue)
        let yardValue = meterToYard(meter: meterValue)
        let inchValue = meterToInch(meter: meterValue)
        
        if(cmValue != 0) {
            self.meterField.text = String(format: "%.4f", meterValue)
            self.mileField.text = String(format: "%.4f", mileValue)
            self.mmField.text = String(format: "%.4f", mmValue)
            self.yardField.text = String(format: "%.4f", yardValue)
            self.inchField.text = String(format: "%.4f", inchValue)
        } else {
            emptyAllFields()
        }
    }
    
    @IBAction func mmChanged(_ sender: CustomTextField) {
        
        let mmValue = (self.mmField.text! as NSString).floatValue
        let meterValue = mmToMeter(mm: mmValue)
        let mileValue = meterToMile(meter: meterValue)
        let cmValue = meterToCm(meter: meterValue)
        let yardValue = meterToYard(meter: meterValue)
        let inchValue = meterToInch(meter: meterValue)
        
        if(mmValue != 0) {
            self.meterField.text = String(format: "%.4f", meterValue)
            self.mileField.text = String(format: "%.4f", mileValue)
            self.cmField.text = String(format: "%.4f", cmValue)
            self.yardField.text = String(format: "%.4f", yardValue)
            self.inchField.text = String(format: "%.4f", inchValue)
        } else {
            emptyAllFields()
        }
    }
    
    @IBAction func yardChanged(_ sender: CustomTextField) {
        
        let yardValue = (self.yardField.text! as NSString).floatValue
        let meterValue = yardToMeter(yard: yardValue)
        let mileValue = meterToMile(meter: meterValue)
        let cmValue = meterToCm(meter: meterValue)
        let mmValue = meterToMm(meter: meterValue)
        let inchValue = meterToInch(meter: meterValue)
        
        if(yardValue != 0) {
            self.meterField.text = String(format: "%.4f", meterValue)
            self.mileField.text = String(format: "%.4f", mileValue)
            self.cmField.text = String(format: "%.4f", cmValue)
            self.mmField.text = String(format: "%.4f", mmValue)
            self.inchField.text = String(format: "%.4f", inchValue)
        } else {
            emptyAllFields()
        }
    }
    
    @IBAction func inchChanged(_ sender: CustomTextField) {
        
        let inchValue = (self.inchField.text! as NSString).floatValue
        let meterValue = inchToMeter(inch: inchValue)
        let mileValue = meterToMile(meter: meterValue)
        let cmValue = meterToCm(meter: meterValue)
        let mmValue = meterToMm(meter: meterValue)
        let yardValue = meterToYard(meter: meterValue)
        
        if(inchValue != 0) {
            self.meterField.text = String(format: "%.4f", meterValue)
            self.mileField.text = String(format: "%.4f", mileValue)
            self.cmField.text = String(format: "%.4f", cmValue)
            self.mmField.text = String(format: "%.4f", mmValue)
            self.yardField.text = String(format: "%.4f", yardValue)
        } else {
            emptyAllFields()
        }
    }
    
    func meterToMile(meter: Float)->Float {
        return meter / 1609.344
    }
    
    func meterToCm(meter: Float)->Float {
        return meter * 100
    }
    
    func meterToMm(meter: Float)->Float {
        return meter * 1000
    }
    
    func meterToYard(meter: Float)->Float {
        return meter * 1.09361
    }
    
    func meterToInch(meter: Float)->Float {
        return meter * 39.3701
    }
    
    func miletoMeter(mile: Float)->Float {
        return mile * 1609.344
    }
    
    func cmToMeter(cm: Float)->Float {
        return cm / 100
    }
    
    func mmToMeter(mm: Float)->Float {
        return mm / 1000
    }
    
    func yardToMeter(yard: Float)->Float {
        return yard * 0.9144
    }
    
    func inchToMeter(inch: Float)->Float {
        return inch * 0.0254
    }
    
    func emptyAllFields() {
        self.meterField.text = nil
        self.mileField.text = nil
        self.cmField.text = nil
        self.mmField.text = nil
        self.yardField.text = nil
        self.inchField.text = nil
    }
    
    @IBAction func saveLengthData(_ sender: Any) {
        let meterValue = meterField.text
        let mileValue = mileField.text
        let cmValue = cmField.text
        let mmValue = mmField.text
        let yardValue = yardField.text
        let inchValue = inchField.text
        
        if let savedLengthArray = UserDefaults.standard.object(forKey: "savedLengths") as? [String]{
            lengthArray = savedLengthArray
        }
        
        if (lengthArray.count == 5) {
            lengthArray.remove(at: 0)
        }
        
        if((meterValue?.isEmpty)! || (mileValue?.isEmpty)! || (cmValue?.isEmpty)! || (mmValue?.isEmpty)! || (yardValue?.isEmpty)! || (inchValue?.isEmpty)!) == false {
            
            // save data
            lengthArray.append(meterValue! + " meter = " + mileValue! + " mile = " + cmValue! + " cm = " + mmValue! + " mm = " + yardValue! + " yard = " + inchValue! + " inch ")
            let defaults = UserDefaults.standard
            defaults.set(self.lengthArray, forKey: "savedLengths")
            
            // show alert
            let alert = UIAlertController(title: "", message: "Length conversion has been saved", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            // clear fields
            emptyAllFields()
        } else {
            //alert message
            let alert = UIAlertController(title: "", message: "Empty conversions cannot be saved", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
