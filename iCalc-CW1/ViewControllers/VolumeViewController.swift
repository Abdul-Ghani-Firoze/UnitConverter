//
//  VolumeViewController.swift
//  iCalc-CW1
//
//  Created by student on 4/10/19.
//  Copyright © 2019 studentasd. All rights reserved.
//

import UIKit

class VolumeViewController: UIViewController {
    
    @IBOutlet weak var gallonField: CustomTextField!
    @IBOutlet weak var litreField: CustomTextField!
    @IBOutlet weak var pintField: CustomTextField!
    @IBOutlet weak var fluidOunceField: CustomTextField!
    @IBOutlet weak var mililitreField: CustomTextField!
    
    var tabBarFrameOriginY = CGFloat()  // stores tab bar's original y-origin
    private var volumeArray = [String]()
    
    // letting the HistoryViewController know to show volume history
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HistoryViewController {
            let vc = segue.destination as? HistoryViewController
            vc?.comingFrom = "volume"
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
    
    @IBAction func gallonChanged(_ sender: CustomTextField) {
        
        let gallonValue = (self.gallonField.text! as NSString).floatValue
        let litreValue = gallonToLitre(gallon: gallonValue)
        let pintValue = litreToPint(litre: litreValue)
        let fluidOunceValue = litreToFluidOunce(litre: litreValue)
        let mililitreValue = litreToMililitre(litre: litreValue)
        
        if(gallonValue != 0) {
            self.litreField.text = String(format: "%.4f", litreValue)
            self.pintField.text = String(format: "%.4f", pintValue)
            self.fluidOunceField.text = String(format: "%.4f", fluidOunceValue)
            self.mililitreField.text = String(format: "%.4f", mililitreValue)
        } else {
            emptyAllFields()
        }
    }
    
    @IBAction func litreChanged(_ sender: CustomTextField) {
        
        let litreValue = (self.litreField.text! as NSString).floatValue
        let gallonValue = litreToGallon(litre: litreValue)
        let pintValue = litreToPint(litre: litreValue)
        let fluidOunceValue = litreToFluidOunce(litre: litreValue)
        let mililitreValue = litreToMililitre(litre: litreValue)
        
        if(litreValue != 0) {
            self.gallonField.text = String(format: "%.4f", gallonValue)
            self.pintField.text = String(format: "%.4f", pintValue)
            self.fluidOunceField.text = String(format: "%.4f", fluidOunceValue)
            self.mililitreField.text = String(format: "%.4f", mililitreValue)
        } else {
            emptyAllFields()
        }
    }
    
    @IBAction func pintChanged(_ sender: CustomTextField) {
        
        let pintValue = (self.pintField.text! as NSString).floatValue
        let litreValue = pintToLitre(pint: pintValue)
        let gallonValue = litreToGallon(litre: litreValue)
        let fluidOunceValue = litreToFluidOunce(litre: litreValue)
        let mililitreValue = litreToMililitre(litre: litreValue)
        
        if(pintValue != 0) {
            self.litreField.text = String(format: "%.4f", litreValue)
            self.gallonField.text = String(format: "%.4f", gallonValue)
            self.fluidOunceField.text = String(format: "%.4f", fluidOunceValue)
            self.mililitreField.text = String(format: "%.4f", mililitreValue)
        } else {
            emptyAllFields()
        }
    }
    
    @IBAction func fluidOunceChanged(_ sender: CustomTextField) {
        
        let fluidOunceValue = (self.fluidOunceField.text! as NSString).floatValue
        let litreValue = fluidOunceToLitre(fluidOunce: fluidOunceValue)
        let pintValue = litreToPint(litre: litreValue)
        let gallonValue = litreToGallon(litre: litreValue)
        let mililitreValue = litreToMililitre(litre: litreValue)
        
        if(fluidOunceValue != 0) {
            self.litreField.text = String(format: "%.4f", litreValue)
            self.pintField.text = String(format: "%.4f", pintValue)
            self.gallonField.text = String(format: "%.4f", gallonValue)
            self.mililitreField.text = String(format: "%.4f", mililitreValue)
        } else {
            emptyAllFields()
        }
    }
    
    @IBAction func mililitreChanged(_ sender: CustomTextField) {
        
        let mililitreValue = (self.mililitreField.text! as NSString).floatValue
        let litreValue = mililitreToLitre(mililitre: mililitreValue)
        let gallonValue = litreToGallon(litre: litreValue)
        let pintValue = litreToPint(litre: litreValue)
        let fluidOunceValue = litreToFluidOunce(litre: litreValue)
        
        if(mililitreValue != 0) {
            self.gallonField.text = String(format: "%.4f", gallonValue)
            self.pintField.text = String(format: "%.4f", pintValue)
            self.fluidOunceField.text = String(format: "%.4f", fluidOunceValue)
            self.litreField.text = String(format: "%.4f", litreValue)
        } else {
            emptyAllFields()
        }
    }
    
    func litreToGallon(litre: Float)->Float {
        return litre / 4.54609
    }
    
    func litreToPint(litre: Float)->Float {
        return litre * 1.75975
    }
    
    func litreToFluidOunce(litre: Float)->Float {
        return litre * 35.1951
    }
    
    func litreToMililitre(litre: Float)->Float {
        return litre * 1000
    }
    
    func gallonToLitre(gallon: Float)->Float {
        return gallon * 4.54609
    }
    
    func pintToLitre(pint: Float)->Float {
        return pint / 1.75975
    }
    
    func fluidOunceToLitre(fluidOunce: Float)->Float {
        return fluidOunce / 35.1951
    }
    
    func mililitreToLitre(mililitre: Float)->Float {
        return mililitre / 1000
    }
    
    func emptyAllFields() {
        self.gallonField.text = nil
        self.litreField.text = nil
        self.pintField.text = nil
        self.fluidOunceField.text = nil
        self.mililitreField.text = nil
    }
    
    @IBAction func saveVolumeData(_ sender: Any) {
        let gallonValue = gallonField.text
        let litreValue = litreField.text
        let pintValue = pintField.text
        let fluidOunceValue = fluidOunceField.text
        let mililitreValue = mililitreField.text
        
        if let savedVolumeArray = UserDefaults.standard.object(forKey: "savedVolumes") as? [String]{
            volumeArray = savedVolumeArray
        }
        
        if (volumeArray.count == 5){
            volumeArray.remove(at: 0)
        }
        
        // checking if fields are empty
        if((gallonValue?.isEmpty)! || (litreValue?.isEmpty)! || (pintValue?.isEmpty)! || (fluidOunceValue?.isEmpty)! || (mililitreValue?.isEmpty)!) == false {
            
            // save data
            volumeArray.append(gallonValue! + " gallon = " + litreValue! + " litre = " + pintValue! + " pint = " + fluidOunceValue! + " fluid ounce = " + mililitreValue! + " ml")
            let defaults = UserDefaults.standard
            defaults.set(self.volumeArray, forKey: "savedVolumes")
            
            // show alert
            let alert = UIAlertController(title: "", message: "Volume conversion has been saved", preferredStyle: .alert)
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
