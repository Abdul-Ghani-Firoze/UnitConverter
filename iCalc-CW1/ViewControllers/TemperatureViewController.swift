//
//  TemperatureViewController.swift
//  iCalc-CW1
//
//  Created by Smoking Dots on 4/9/19.
//  Copyright © 2019 studentasd. All rights reserved.
//

import UIKit

class TemperatureViewController: UIViewController {
    
    @IBOutlet weak var celciusField: CustomTextField!
    @IBOutlet weak var fahrenheitField: CustomTextField!
    @IBOutlet weak var kelvinField: CustomTextField!
    
    var tabBarFrameOriginY = CGFloat()  // stores tab bar's original y-origin
    private var temperatureArray = [String]()
    
    // letting the HistoryViewController know to show temperature history
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HistoryViewController {
            let vc = segue.destination as? HistoryViewController
            vc?.comingFrom = "temperature"
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
    
    @IBAction func celciusChanged(_ sender: CustomTextField) {
        
        if(self.celciusField.text?.isEmpty == false) {
            let celciusValue = (self.celciusField.text! as NSString).floatValue
            let kelvinValue = celciusToKelvin(celcius: celciusValue)
            let fahrenheitValue = celciusToFahrenheit(celcius: celciusValue)
            
            self.fahrenheitField.text = String(format: "%.4f", fahrenheitValue)
            self.kelvinField.text = String(format: "%.4f", kelvinValue)
        } else {
            emptyAllFields()
        }
    }
    
    @IBAction func fahrenheitChanged(_ sender: CustomTextField) {
        
        if(self.fahrenheitField.text?.isEmpty == false) {
            let fahrenheitValue = (self.fahrenheitField.text! as NSString).floatValue
            let celciusValue = fahrenheitToCelcius(fahrenheit: fahrenheitValue)
            let kelvinValue = celciusToKelvin(celcius: celciusValue)
            
            self.celciusField.text = String(format: "%.4f", celciusValue)
            self.kelvinField.text = String(format: "%.4f", kelvinValue)
        } else {
            emptyAllFields()
        }
    }
    
    @IBAction func kelvinChanged(_ sender: CustomTextField) {
        
        if(self.kelvinField.text?.isEmpty == false) {
            let kelvinValue = (self.kelvinField.text! as NSString).floatValue
            let celciusValue = kelvinToCelcius(kelvin: kelvinValue)
            let fahrenheitValue = celciusToFahrenheit(celcius: celciusValue)
            
            self.celciusField.text = String(format: "%.4f", celciusValue)
            self.fahrenheitField.text = String(format: "%.4f", fahrenheitValue)
        } else {
            emptyAllFields()
        }
    }
    
    func celciusToKelvin(celcius: Float)->Float {
        return celcius + 273.15
    }
    
    func celciusToFahrenheit(celcius: Float)->Float {
        return (celcius * (9/5)) + 32
    }
    
    func kelvinToCelcius(kelvin: Float)->Float {
        return kelvin - 273.15
    }
    
    func fahrenheitToCelcius(fahrenheit: Float)->Float {
        return (fahrenheit - 32) * (5/9)
    }
    
    func emptyAllFields() {
        self.celciusField.text = nil
        self.fahrenheitField.text = nil
        self.kelvinField.text = nil
    }
    
    @IBAction func saveTemperatureData(_ sender: Any) {
        let celciusValue = celciusField.text
        let fahrenheitValue = fahrenheitField.text
        let kelvinValue = kelvinField.text
        
        if let savedTemperatureArray = UserDefaults.standard.object(forKey: "savedTemperatures") as? [String]{
            temperatureArray = savedTemperatureArray
        }
        
        if (temperatureArray.count == 5) {
            temperatureArray.remove(at: 0)
        }
        
        if((celciusValue?.isEmpty)! || (fahrenheitValue?.isEmpty)! || (kelvinValue?.isEmpty)!) == false {
            // save data
            temperatureArray.append(celciusValue! + " C = " + fahrenheitValue! + " F = " + kelvinValue! + " K")
            let defaults = UserDefaults.standard
            defaults.set(self.temperatureArray, forKey: "savedTemperatures")
            
            // show alert
            let alert = UIAlertController(title: "", message: "Temperature conversion has been saved", preferredStyle: .alert)
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
