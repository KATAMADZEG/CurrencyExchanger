//
//  MyWalletHeader.swift
//  CurrencyExchanger
//
//  Created by Giorgi Katamadze on 4/12/23.
//

import UIKit

final class MyWalletHeader: UIView {

    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "საფულეების ანგარიში"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor().hexStringToUIColor(hex: "130F26", alpha: 1)
        return label
    }()
    
    func configureMyWalletHeader() {
        addSubview(titleLabel)
        titleLabel.left(to: self,offset: 32)
        titleLabel.centerY(to: self)
    }
}
