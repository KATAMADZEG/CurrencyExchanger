//
//  MyWalletCell.swift
//  CurrencyExchanger
//
//  Created by Giorgi Katamadze on 4/11/23.
//

import UIKit

class MyWalletCell: UITableViewCell {
    
    private let cardView = CardView()

    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.separatorInset = UIEdgeInsets(top: 16, left: 32, bottom: 0, right: 32)
        contentView.layoutMargins = .zero
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        contentView.bounds = contentView.bounds.inset(by: insets)
        contentView.backgroundColor = .yellow
        self.backgroundColor  = .clear
        self.selectionStyle = .none
        self.addSubview(cardView)
        cardView.backgroundColor  = .yellow
        cardView.top(to: self, offset: 20)
        cardView.leading(to: self, offset: 20)
        cardView.trailing(to: self, offset: -20)
        cardView.bottom(to: self, offset: -20)
        cardView.isUserInteractionEnabled = false
    }
    
    func configureModel(with model: MyWalletModel) {
        let roundedBalance = String(format: "%.2f", model.balance ?? 0.0)
        cardView.cardNumLabel.text = model.cardAccNum ?? ""
        cardView.moneyLabel.text = "\(roundedBalance) \(model.currencySymbol ?? "")"
    
    }
}
