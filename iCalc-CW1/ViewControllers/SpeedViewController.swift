//
//  SpeedViewController.swift
//  iCalc-CW1
//
//  Created by Smoking Dots on 4/8/19.
//  Copyright © 2019 studentasd. All rights reserved.
//

import UIKit

class SpeedViewController: UIViewController {
    
    @IBOutlet weak var mPerSecField: CustomTextField!
    @IBOutlet weak var kmPHField: CustomTextField!
    @IBOutlet weak var mPHField: CustomTextField!
    @IBOutlet weak var nautMPHField: CustomTextField!
    
    var tabBarFrameOriginY = CGFloat()  // stores tab bar's original y-origin
    private var speedArray = [String]()
    
    // letting the HistoryViewController know to show speed history
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HistoryViewController {
            let vc = segue.destination as? HistoryViewController
            vc?.comingFrom = "speed"
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
    
    @IBAction func mPSecChanged(_ sender: CustomTextField) {
        
        let mPSecValue = (self.mPerSecField.text! as NSString).floatValue
        let kmPHValue = mPSecToKmPH(mPSec: mPSecValue)
        let mPHValue = mPSecToMPH(mPSec: mPSecValue)
        let nautMPHValue = mPSECToNautMPH(mPSec: mPSecValue)
        
        if(mPSecValue != 0) {
            self.kmPHField.text = String(format: "%.4f", kmPHValue)
            self.mPHField.text = String(format: "%.4f", mPHValue)
            self.nautMPHField.text = String(format: "%.4f", nautMPHValue)
        } else {
            emptyAllFields()
        }
    }
    
    @IBAction func kmPHChanged(_ sender: CustomTextField) {
        
        let kmPHValue = (self.kmPHField.text! as NSString).floatValue
        let mPSecValue = kmPHToMPSec(kmPH: kmPHValue)
        let mPHValue = mPSecToMPH(mPSec: mPSecValue)
        let nautMPHValue = mPSECToNautMPH(mPSec: mPSecValue)
        
        if(kmPHValue != 0) {
            self.mPerSecField.text = String(format: "%.4f", mPSecValue)
            self.mPHField.text = String(format: "%.4f", mPHValue)
            self.nautMPHField.text = String(format: "%.4f", nautMPHValue)
        } else {
            emptyAllFields()
        }
    }
    
    @IBAction func mPHChanged(_ sender: CustomTextField) {
        
        let mPHValue = (self.mPHField.text! as NSString).floatValue
        let mPSecValue = mPHToMPSec(mPH: mPHValue)
        let kmPHValue = mPSecToKmPH(mPSec: mPSecValue)
        let nautMPHValue = mPSECToNautMPH(mPSec: mPSecValue)
        
        if(mPHValue != 0) {
            self.mPerSecField.text = String(format: "%.4f", mPSecValue)
            self.kmPHField.text = String(format: "%.4f", kmPHValue)
            self.nautMPHField.text = String(format: "%.4f", nautMPHValue)
        } else {
            emptyAllFields()
        }
    }
    
    @IBAction func nautMPHChanged(_ sender: CustomTextField) {
        
        let nautMPHValue = (self.nautMPHField.text! as NSString).floatValue
        let mPSecValue = nautMPHToMPSec(nautMPH: nautMPHValue)
        let kmPHValue = mPSecToKmPH(mPSec: mPSecValue)
        let mPHValue = mPSecToMPH(mPSec: mPSecValue)
        
        if(nautMPHValue != 0) {
            self.mPerSecField.text = String(format: "%.4f", mPSecValue)
            self.kmPHField.text = String(format: "%.4f", kmPHValue)
            self.mPHField.text = String(format: "%.4f", mPHValue)
        } else {
            emptyAllFields()
        }
    }
    
    func mPSecToKmPH(mPSec: Float)->Float {
        return mPSec * 3.6
    }
    
    func mPSecToMPH(mPSec: Float)->Float {
        return mPSec * 2.237
    }
    
    func mPSECToNautMPH(mPSec: Float)->Float {
        return mPSec * 1.944
    }
    
    func kmPHToMPSec(kmPH: Float)->Float {
        return kmPH / 3.6
    }
    
    func mPHToMPSec(mPH: Float)->Float {
        return mPH / 2.237
    }
    
    func nautMPHToMPSec(nautMPH: Float)->Float {
        return nautMPH / 1.944
    }
    
    func emptyAllFields() {
        self.mPerSecField.text = nil
        self.kmPHField.text = nil
        self.mPHField.text = nil
        self.nautMPHField.text = nil
    }
    
    @IBAction func saveSpeedData(_ sender: Any) {
        let mPSecValue = mPerSecField.text
        let kmPHValue = kmPHField.text
        let mPHValue = mPHField.text
        let nautMPHValue = nautMPHField.text
        
        if let savedSpeedArray = UserDefaults.standard.object(forKey: "savedSpeeds") as? [String]{
            speedArray = savedSpeedArray
        }
        
        if (speedArray.count == 5) {
            speedArray.remove(at: 0)
        }
        
        if((mPSecValue?.isEmpty)! || (kmPHValue?.isEmpty)! || (mPHValue?.isEmpty)! || (nautMPHValue?.isEmpty)!) == false {
            
            // save data
            speedArray.append(mPSecValue! + " m/s = " + kmPHValue! + " km/h = " + mPHValue! + " mph = " + nautMPHValue! + " naut. mph")
            let defaults = UserDefaults.standard
            defaults.set(self.speedArray, forKey: "savedSpeeds")
            
            // show alert
            let alert = UIAlertController(title: "", message: "Speed conversion has been saved", preferredStyle: .alert)
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
