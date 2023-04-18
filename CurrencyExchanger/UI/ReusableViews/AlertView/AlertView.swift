//
//  AlertView.swift
//  CurrencyExchanger
//
//  Created by Giorgi Katamadze on 4/18/23.
//

import Foundation
import UIKit

final class AlertView: NSObject {
    static func showAlert(vc: UIViewController , message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
