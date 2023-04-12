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
        return label
    }()
    
    func configureMyWalletHeader() {
        addSubview(titleLabel)
        titleLabel.left(to: self,offset: 32)
        titleLabel.centerY(to: self)
    }
}
