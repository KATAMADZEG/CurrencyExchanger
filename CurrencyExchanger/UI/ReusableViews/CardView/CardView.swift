//
//  CardView.swift
//  CurrencyExchanger
//
//  Created by Giorgi Katamadze on 4/9/23.
//

import UIKit

enum CardViewType {
    case From
    case To
}
protocol CardViewDelegate : AnyObject {
    func tapToCard(type:CardViewType)
}
final class CardView: UIView {
    //MARK: - Properties
    private let cardImageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor  = .clear
        iv.image = UIImage(named: "cardIcon")
        return iv
    }()
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Card Name"
        label.font = label.font.withSize(12)
        label.textColor = UIColor().hexStringToUIColor(hex: "130F26", alpha: 1)
        return label
    }()
     let cardNumLabel : UILabel = {
        let label = UILabel()
        label.text = "GE78****4553"
       
        label.textColor = UIColor().hexStringToUIColor(hex: "4B5B6C", alpha: 1)
        label.font = label.font.withSize(12)
        
        return label
    }()
     let moneyLabel : UILabel = {
        let label = UILabel()
        label.text = "145698.38 $"
        label.attributedTitle(firstPart: "1243.09 ", secondPart: "$")
        return label
    }()
     let rightArrowIcon : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "rightArrowIcon")
        
        return iv
    }()
    private let helperView : UIView = {
        let view = UIView()
        return view
    }()
    lazy var cardButton:UIButton =  {
        let buton = UIButton(type: .custom)
        buton.addTarget(self, action: #selector(tapToCardButton), for: .touchUpInside)
        return buton
    }()
    var type : CardViewType!
    weak var delegate : CardViewDelegate?

    init(type:CardViewType? = nil) {
        super.init(frame: .zero)
        self.type  = type
        self.configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    private func configureUI() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,cardNumLabel])
        stackView.axis = .vertical
        self.addSubview(stackView)
        stackView.top(to: self,offset: 0)
        stackView.backgroundColor = .clear
        stackView.distribution  = .fillEqually
        stackView.spacing = 11
        stackView.bottom(to: self)
        self.addSubview(cardImageView)
        cardImageView.height(46)
        cardImageView.width(46)
        cardImageView.left(to: self)
        cardImageView.centerY(to: stackView)
        stackView.leftToRight(of: cardImageView,offset: 16)
        self.addSubview(helperView)
        self.right(to: helperView)
        helperView.centerY(to: stackView)
        helperView.backgroundColor   = .clear
        helperView.addSubview(rightArrowIcon)
        rightArrowIcon.width(24)
        rightArrowIcon.height(24)
        rightArrowIcon.edgesToSuperview(excluding: .left)
        helperView.addSubview(moneyLabel)
        moneyLabel.left(to: helperView)
        moneyLabel.centerY(to: rightArrowIcon)
        moneyLabel.rightToLeft(of: rightArrowIcon,offset: -20)
        self.addSubview(cardButton)
        cardButton.edgesToSuperview()
    }
    @objc func tapToCardButton() {
        delegate?.tapToCard(type: self.type)
    }
}
