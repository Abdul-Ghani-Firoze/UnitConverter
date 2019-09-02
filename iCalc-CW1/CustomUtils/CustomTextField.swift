//
//  CustomTextField.swift
//  iCalc-CW1
//
//  Created by Smoking Dots on 4/6/19.
//  Copyright © 2019 studentasd. All rights reserved.
//

import UIKit

class CustomTextField: UITextField, KeyboardDelegate, UITextFieldDelegate {
    
    var deleteButtonString = "Del"
    var clearButtonString = "C"
    var decimalButtonString = "."
    var negativeButtonString = "-"
    
    var keyboardView = KeyboardView(frame: CGRect(x: 0, y: 0, width: 0, height: 300))
    
    func keyWasTapped(character: String) {
        switch character {
        case deleteButtonString:
            // if textfield not empty
            if let text = self.text, String(text).count > 0 {
                self.deleteBackward()
            }
        case clearButtonString:
            // clear current field
            self.text = nil
            // firing this event to update conversion
            self.sendActions(for: .editingChanged)
        case decimalButtonString:
                // prevent user from adding multiple decimal points
            if(!(self.text!.contains(decimalButtonString))) {
                self.insertText(decimalButtonString)
            }
        case negativeButtonString:
            if var fieldValue = self.text {
                // don't allow '-' on empty field (due to unintended conversion) and 0
                if(!fieldValue.isEmpty && fieldValue != "0") {
                    //check if negative already present
                    if(fieldValue.contains(negativeButtonString) == false) {
                        // add if yes
                        fieldValue.insert("-", at: fieldValue.startIndex)
                    } else {
                        // remove if no
                        fieldValue.remove(at: fieldValue.startIndex)
                    }
                    self.text = fieldValue
                    // firing this event to update conversion
                    self.sendActions(for: .editingChanged)
                }
            }
        default:
            self.insertText(character)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(tag == 1) {
            self.keyboardView.negButton.isEnabled = true
            self.keyboardView.negButton.backgroundColor = UIColor.darkGray
        } else {
            self.keyboardView.negButton.isEnabled = false
            self.keyboardView.negButton.backgroundColor = UIColor.lightGray
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        setupCustomKeyboard(tag: self.tag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        setupCustomKeyboard(tag: self.tag)
    }
    
    private func setupCustomKeyboard(tag: Int) {
        // replace system keyboard with custom keyboard
        self.inputView = keyboardView

        // configure delegate for keyboard
        keyboardView.delegate = self
    }

}
