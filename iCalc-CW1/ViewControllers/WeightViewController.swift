//
//  FirstViewController.swift
//  iCalc-CW1
//
//  Created by student on 4/2/19.
//  Copyright © 2019 studentasd. All rights reserved.
//

import UIKit

class WeightViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ounceField: CustomTextField!
    @IBOutlet weak var poundField: CustomTextField!
    @IBOutlet weak var gramField: CustomTextField!
    @IBOutlet weak var stoneField: CustomTextField!
    @IBOutlet weak var sPoundField: CustomTextField!
    @IBOutlet weak var kilogramField: CustomTextField!
    
    var tabBarFrameOriginY = CGFloat()  // stores tab bar's original y-origin
    private var weightArray = [String]()
    
    // letting the HistoryViewController know to show weight history
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HistoryViewController {
            let vc = segue.destination as? HistoryViewController
            vc?.comingFrom = "weight"
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

        //this moves the tab bar above the keyboard
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
    
    @IBAction func ounceChanged(_ sender: CustomTextField) {
        
        let ounceValue = (self.ounceField.text! as NSString).floatValue
        let poundValue = ounceToPound(ounce: ounceValue)
        let gramValue = poundToGram(pound: poundValue)
        let kgValue = gramToKg(gram: gramValue)
        let stoneValue = kgToStone(kg: kgValue)
        let sPoundValue = kgToSPound(kg: kgValue)
        
        if(ounceValue != 0) {
            self.poundField.text = String(format: "%.4f", poundValue)
            self.gramField.text = String(format: "%.4f", gramValue)
            self.kilogramField.text = String(format: "%.4f", kgValue)
            self.stoneField.text = "\(stoneValue)"
            self.sPoundField.text = String(format: "%.4f", sPoundValue)
        } else {
            emptyAllFields()
        }
    }
    
    @IBAction func poundChanged(_ sender: CustomTextField) {
        
        let poundValue = (self.poundField.text! as NSString).floatValue
        let ounceValue = poundToOunce(pound: poundValue)
        let gramValue = poundToGram(pound: poundValue)
        let kgValue = gramToKg(gram: gramValue)
        let stoneValue = kgToStone(kg: kgValue)
        let sPoundValue = kgToSPound(kg: kgValue)
        
        if(poundValue != 0) {
            self.ounceField.text = String(format: "%.4f", ounceValue)
            self.gramField.text = String(format: "%.4f", gramValue)
            self.kilogramField.text = String(format: "%.4f", kgValue)
            self.stoneField.text = "\(stoneValue)"
            self.sPoundField.text = String(format: "%.4f", sPoundValue)
        } else {
            emptyAllFields()
        }
    }
    
    @IBAction func gramChanged(_ sender: CustomTextField) {
        
        let gramValue = (self.gramField.text! as NSString).floatValue
        let poundValue = gramToPound(gram: gramValue)
        let ounceValue = poundToOunce(pound: poundValue)
        let kgValue = gramToKg(gram: gramValue)
        let stoneValue = kgToStone(kg: kgValue)
        let sPoundValue = kgToSPound(kg: kgValue)
        
        if(gramValue != 0) {
            self.poundField.text = String(format: "%.4f", poundValue)
            self.ounceField.text = String(format: "%.4f", ounceValue)
            self.kilogramField.text = String(format: "%.4f", kgValue)
            self.stoneField.text = "\(stoneValue)"
            self.sPoundField.text = String(format: "%.4f", sPoundValue)
        } else {
            emptyAllFields()
        }
    }
    
    @IBAction func stoneChanged(_ sender: CustomTextField) {
        
        let stoneValue = (self.stoneField.text! as NSString).floatValue
        let sPoundValue = (self.sPoundField.text! as NSString).floatValue
        let kgValue = stonePoundToKg(stone: stoneValue, sPound: sPoundValue)
        let gramValue = kgToGram(kg: kgValue)
        let poundValue = gramToPound(gram: gramValue)
        let ounceValue = poundToOunce(pound: poundValue)
        
        if(stoneValue == 0 && sPoundValue == 0) {
            emptyAllFields()
        } else {
            self.poundField.text = String(format: "%.4f", poundValue)
            self.ounceField.text = String(format: "%.4f", ounceValue)
            self.gramField.text = String(format: "%.4f", gramValue)
            self.kilogramField.text = String(format: "%.4f", kgValue)
        }
    }
    
    @IBAction func sPoundChanged(_ sender: CustomTextField) {
        
        var sPoundValue = (self.sPoundField.text! as NSString).floatValue
        
        //restrict user from entering a value more than 14 coz 14 pounds = 1 stone
        if (sPoundValue > 13.9999){
            sPoundValue = 0.0
            self.sPoundField.text = String(0)
        }
        
        let stoneValue = (self.stoneField.text! as NSString).floatValue

        if(stoneValue == 0 && sPoundValue == 0) {
            emptyAllFields()
        } else {
            let kgValue = stonePoundToKg(stone: stoneValue, sPound: sPoundValue)
            let gramValue = kgToGram(kg: kgValue)
            let poundValue = gramToPound(gram: gramValue)
            let ounceValue = poundToOunce(pound: poundValue)
            
            self.poundField.text = String(format: "%.4f", poundValue)
            self.ounceField.text = String(format: "%.4f", ounceValue)
            self.gramField.text = String(format: "%.4f", gramValue)
            self.kilogramField.text = String(format: "%.4f", kgValue)
        }
    }
    
    @IBAction func kilogramChanged(_ sender: CustomTextField) {
        
        let kgValue = (self.kilogramField.text! as NSString).floatValue
        let gramValue = kgToGram(kg: kgValue)
        let poundValue = gramToPound(gram: gramValue)
        let ounceValue = poundToOunce(pound: poundValue)
        let stoneValue = kgToStone(kg: kgValue)
        let sPoundValue = kgToSPound(kg: kgValue)
        
        if(kgValue != 0) {
            self.poundField.text = String(format: "%.4f", poundValue)
            self.ounceField.text = String(format: "%.4f", ounceValue)
            self.gramField.text = String(format: "%.4f", gramValue)
            self.stoneField.text = "\(stoneValue)"
            self.sPoundField.text = String(format: "%.4f", sPoundValue)
        } else {
            emptyAllFields()
        }
    }
    
    func ounceToPound(ounce:Float)->Float {
        return ounce / 16
    }
    
    func poundToOunce(pound:Float)->Float {
        return pound * 16
    }
    
    func stoneToPound(stone:Float)->Float {
        return stone * 14
    }
    
    func poundToGram(pound:Float)->Float {
        return pound * 453.592
    }
    
    func gramToPound(gram:Float)->Float {
        return gram / 453.592
    }
    
    func gramToKg(gram:Float)->Float {
        return gram / 1000
    }
    
    func kgToGram(kg:Float)->Float {
        return kg * 1000
    }
    
    func kgToStone(kg:Float)->Float {
        return floor(kg / 6.35029318)
    }
    
    func kgToSPound(kg:Float)->Float {
        let poundValue = kg / 6.35029318
        let poundDecimal = poundValue.truncatingRemainder(dividingBy: 1)
        let sPoundValue = poundDecimal * 14
        return sPoundValue
    }
    
    func stonePoundToKg(stone: Float, sPound: Float)->Float {
        return (stone + (sPound/14)) * 6.35029318
    }
    
    func emptyAllFields() {
        self.ounceField.text = nil
        self.poundField.text = nil
        self.gramField.text = nil
        self.stoneField.text = nil
        self.sPoundField.text = nil
        self.kilogramField.text = nil
    }
    
    // save weight data
    @IBAction func saveWeightData(_ sender: Any) {
        let ounceValue = ounceField.text
        let poundValue = poundField.text
        let gramValue = gramField.text
        let stoneValue = stoneField.text
        let sPoundValue = sPoundField.text
        let kgValue = kilogramField.text
        
        if let savedWeightArray = UserDefaults.standard.object(forKey: "savedWeights") as? [String]{
            weightArray = savedWeightArray
        }
        
        if (weightArray.count == 5){
            weightArray.remove(at: 0)
        }
        
        // checking if fields are empty
        if((ounceValue?.isEmpty)! || (poundValue?.isEmpty)! || (gramValue?.isEmpty)! || ((stoneValue?.isEmpty)! && (sPoundValue?.isEmpty)!) || (kgValue?.isEmpty)!) == false {
            
            // save data
            weightArray.append(ounceValue! + " Ounce = " + poundValue! + " Pound = " + gramValue! + " Grams = " + kgValue! + " Kilograms = " + stoneValue! + " Stone & " + sPoundValue! + " Pounds ")
            let defaults = UserDefaults.standard
            defaults.set(self.weightArray, forKey: "savedWeights")
            
            // show alert
            let alert = UIAlertController(title: "", message: "Weight conversion has been saved", preferredStyle: .alert)
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

