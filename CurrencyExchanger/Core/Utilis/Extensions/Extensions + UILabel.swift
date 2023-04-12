//
//  Extensions + UILabel.swift
//  CurrencyExchanger
//
//  Created by Giorgi Katamadze on 4/12/23.
//

import Foundation
import UIKit

extension UILabel {
    func attributedTitle(firstPart:String,secondPart:String) {
        let atts : [NSAttributedString.Key:Any] = [.foregroundColor : UIColor().hexStringToUIColor(hex: "130F26", alpha: 1),.font:UIFont.systemFont(ofSize: 14)]
        let attributeTitle = NSMutableAttributedString(string: firstPart , attributes: atts)
        let boldAtts : [NSAttributedString.Key:Any] = [.foregroundColor : UIColor().hexStringToUIColor(hex: "4B5B6C", alpha: 1),.font:UIFont.boldSystemFont(ofSize: 12)]
        attributeTitle.append(NSAttributedString(string: secondPart, attributes: boldAtts))
        self.attributedText = attributeTitle
    }
}
