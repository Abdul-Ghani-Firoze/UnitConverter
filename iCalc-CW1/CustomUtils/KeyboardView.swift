//
//  KeyboardView.swift
//  iCalc-CW1
//
//  Created by student on 4/3/19.
//  Copyright © 2019 studentasd. All rights reserved.
//

import UIKit

protocol KeyboardDelegate: class {
    func keyWasTapped(character: String)
}

class KeyboardView: UIView {
    
    @IBOutlet weak var negButton: UIButton!
    
    weak var delegate: KeyboardDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let kV = Bundle.main.loadNibNamed("KeyboardView", owner: self, options: nil)?.first as! UIView
        self.addSubview(kV)
        kV.frame = self.bounds
    }
    
    @IBAction func keyTapped(sender: UIButton) {
        self.delegate?.keyWasTapped(character: sender.titleLabel!.text!)
    }
    
}

// to dismiss keyboard when tapped outside the keyboard
extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
