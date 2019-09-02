//
//  ConstantsViewController.swift
//  iCalc-CW1
//
//  Created by student on 4/11/19.
//  Copyright © 2019 studentasd. All rights reserved.
//

import UIKit

class ConstantsViewController: UIViewController {
    
    @IBOutlet weak var eMass: UILabel!
    @IBOutlet weak var pMass: UILabel!
    @IBOutlet weak var nMass: UILabel!
    @IBOutlet weak var eP: UILabel!
    @IBOutlet weak var mP: UILabel!
    @IBOutlet weak var lightSpeed: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let font:UIFont? = UIFont(name:"HelveticaNeue-Italic", size:20)
        let fontSuper:UIFont? = UIFont(name:"HelveticaNeue-Italic", size:10)

        let attString:NSMutableAttributedString = NSMutableAttributedString(string: "me", attributes: [.font:font!])
        attString.setAttributes([.font:fontSuper!,.baselineOffset:-3], range: NSRange(location:1,length:1))
        eMass.attributedText = attString
        
        let proString:NSMutableAttributedString = NSMutableAttributedString(string: "mp", attributes: [.font:font!])
        proString.setAttributes([.font:fontSuper!,.baselineOffset:-3], range: NSRange(location:1,length:1))
        pMass.attributedText = proString
        
        let neuString:NSMutableAttributedString = NSMutableAttributedString(string: "mn", attributes: [.font:font!])
        neuString.setAttributes([.font:fontSuper!,.baselineOffset:-3], range: NSRange(location:1,length:1))
        nMass.attributedText = neuString
        
        let permString:NSMutableAttributedString = NSMutableAttributedString(string: "\u{03b5}0", attributes: [.font:font!])
        permString.setAttributes([.font:fontSuper!,.baselineOffset:-3], range: NSRange(location:1,length:1))
        eP.attributedText = permString
        
        let magString:NSMutableAttributedString = NSMutableAttributedString(string: "\u{03bc}0", attributes: [.font:font!])
        magString.setAttributes([.font:fontSuper!,.baselineOffset:-3], range: NSRange(location:1,length:1))
        mP.attributedText = magString
        
    }
}
