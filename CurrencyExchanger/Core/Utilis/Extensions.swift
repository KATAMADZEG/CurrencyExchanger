//
//  Extensions.swift
//  CurrencyExchanger
//
//  Created by Giorgi Katamadze on 4/6/23.
//

import Foundation
import UIKit
import Alamofire


extension UIView {
    func addBorder(_ edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let subview = UIView()
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.backgroundColor = color
        self.addSubview(subview)
        switch edge {
        case .top, .bottom:
            subview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
            subview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            subview.heightAnchor.constraint(equalToConstant: thickness).isActive = true
            if edge == .top {
                subview.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            } else {
                subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            }
        case .left, .right:
            subview.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            subview.widthAnchor.constraint(equalToConstant: thickness).isActive = true
            if edge == .left {
                subview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
            } else {
                subview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            }
        default:
            break
        }
    }
}


extension UIColor {
    func hexStringToUIColor (hex:String, alpha:CGFloat) -> UIColor {
        let cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
extension UILabel {
    func attributedTitle(firstPart:String,secondPart:String) {
        let atts : [NSAttributedString.Key:Any] = [.foregroundColor : UIColor().hexStringToUIColor(hex: "130F26", alpha: 1),.font:UIFont.systemFont(ofSize: 14)]
        let attributeTitle = NSMutableAttributedString(string: firstPart , attributes: atts)
        let boldAtts : [NSAttributedString.Key:Any] = [.foregroundColor : UIColor().hexStringToUIColor(hex: "4B5B6C", alpha: 1),.font:UIFont.boldSystemFont(ofSize: 12)]
        attributeTitle.append(NSAttributedString(string: secondPart, attributes: boldAtts))
        self.attributedText = attributeTitle

    }
}



extension String {
    
    func makeQueryItems() -> [URLQueryItem]? {
        
        return split(separator: "&")
            .compactMap({ queryPart -> URLQueryItem? in
                let keyAndValue = queryPart.split(separator: "=")
                guard let key = keyAndValue.first else { return nil }
                let value = keyAndValue[1]
                
                return URLQueryItem(name: String(key), value: String(value))
            })
    }
    
    var queryParameters: [String: Any] {
        guard let queryItems = makeQueryItems(), queryItems.count > 0 else { return [:] }
        
        var parameters: [String: Any] = [:]
        
        queryItems.forEach { item in
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}

extension Array {

    func asParameters() -> Parameters {
        return [ArrayEncoding.arrayParametersKey: self]
    }
}

