//
//  MyWalletCell.swift
//  CurrencyExchanger
//
//  Created by Giorgi Katamadze on 4/11/23.
//

import UIKit

class MyWalletCell: UITableViewCell {
    //MARK: - Properties
    private let cardView = CardView()
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor().hexStringToUIColor(hex: "E5E7EC", alpha: 1)
        return view
    }()
    //MARK: - Helpers
    func configureUI() {
        cardView.moneyLabel.rightToLeft(of: cardView.rightArrowIcon,offset:0)
        cardView.rightArrowIcon.width(0)
        self.addSubview(lineView)
        lineView.left(to: self,offset: 32)
        lineView.right(to: self,offset: -32)
        lineView.bottom(to: self, offset: 0)
        lineView.height(1)
        self.backgroundColor  = .clear
        self.selectionStyle = .none
        self.addSubview(cardView)
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
