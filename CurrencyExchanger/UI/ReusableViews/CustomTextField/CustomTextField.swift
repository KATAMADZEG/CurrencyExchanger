//
//  CustomTextField.swift
//  CurrencyExchanger
//
//  Created by Giorgi Katamadze on 4/9/23.
//

import UIKit
import TinyConstraints
import Combine

final class CustomTextField: UITextField {
    //MARK: - Properties
    let currencyLabel : UILabel = {
        let label = UILabel()
        label.text = "$"
        label.textColor = UIColor().hexStringToUIColor(hex: "4B5B6C", alpha: 1)
        return label
    }()

    private var subscriptions = Set<AnyCancellable>()
    var throughText = PassthroughSubject<String, Never>()
    
    init(placeholder: String ,milliseconds : Int? = nil) {
        super.init(frame: .zero)
        self.setUpPublisher(milliseconds: milliseconds ?? 0)
        borderStyle = .none
        keyboardAppearance = .dark
        keyboardType = .decimalPad
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor().hexStringToUIColor(hex: "E5E7EC", alpha: 1)])
        self.configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    private func configureUI() {
        let spacer = UIView()
        spacer.height(48)
        spacer.width(16)
        leftView = spacer
        leftViewMode = .always
        self.height(48)
        self.addSubview(currencyLabel)
        currencyLabel.centerY(to: self)
        currencyLabel.right(to: self,offset: -16)
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor().hexStringToUIColor(hex: "E5E7EC", alpha: 1).cgColor
       
    }
    
    private func setUpPublisher(milliseconds:Int) {
        let publisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text }
        publisher.debounce(for: .milliseconds(milliseconds), scheduler: RunLoop.main)
            .compactMap{$0}
            .sink { text in
                self.throughText.send(text)
            }
            .store(in: &subscriptions)
    }
}

