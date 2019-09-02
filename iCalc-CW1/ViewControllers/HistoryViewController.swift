//
//  HistoryViewController.swift
//  iCalc-CW1
//
//  Created by Smoking Dots on 4/8/19.
//  Copyright © 2019 studentasd. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var row1: UILabel!
    @IBOutlet weak var row2: UILabel!
    @IBOutlet weak var row3: UILabel!
    @IBOutlet weak var row4: UILabel!
    @IBOutlet weak var row5: UILabel!
    
    private var rows = [UILabel]()
    private var conversionArray = [String]()
    private var weight = "weight"
    private var length = "length"
    private var speed = "speed"
    private var volume = "volume"
    private var temperature = "temperature"
    
    var comingFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rows.append(row1)
        rows.append(row2)
        rows.append(row3)
        rows.append(row4)
        rows.append(row5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        switch comingFrom {
        case weight:
            if let savedWeights = UserDefaults.standard.object(forKey: "savedWeights") as? [String]{
                conversionArray = savedWeights
            }
            break
        case length:
            if let savedLengths = UserDefaults.standard.object(forKey: "savedLengths") as? [String]{
                conversionArray = savedLengths
            }
            break
        case speed:
            if let savedSpeeds = UserDefaults.standard.object(forKey: "savedSpeeds") as? [String]{
                conversionArray = savedSpeeds
            }
        case temperature:
            if let savedTemperatures = UserDefaults.standard.object(forKey: "savedTemperatures") as? [String]{
                conversionArray = savedTemperatures
            }
        case volume:
            if let savedVolumes = UserDefaults.standard.object(forKey: "savedVolumes") as? [String]{
                conversionArray = savedVolumes
            }
        default:
            print("Conversion type is not matched")
        }
        
        displayConversionHistory()
        
    }
    
    func displayConversionHistory() {
        if (!conversionArray.isEmpty){
            for (index, row) in conversionArray.enumerated() {
                if(!row.isEmpty) {
                    rows[index].text = row
                } else {
                    break
                }
            }
        }
    }
}
