//
//  TopBarView.swift
//  CurrencyExchanger
//
//  Created by Giorgi Katamadze on 4/6/23.
//

import UIKit


 final class TopBarView: UIView {

    lazy var backButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "BackButtonIcon"), for: .normal)
        button.addTarget(self, action: #selector(tapAndReturnPreviousPage), for: .touchUpInside)
        return button
    }()
     

    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor().hexStringToUIColor(hex: "130F26", alpha: 1)
        label.font = label.font.withSize(16)
        return label
    }()
    
    let helperView : UIView = {
        let view = UIView()
        
        return view
    }()
    
     private var navigationControler : UINavigationController?

    
     init(titleText:String?,navController: UINavigationController?) {
        super.init(frame: .zero)
         
         if let nav =  navController {
             self.navigationControler = nav
         }
       
        titleLabel.text = titleText ?? ""
        self.configureUI()
    }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

    
    //MARK: - Helpers
    private func configureUI() {
        
        self.addBorder(.bottom, color: UIColor().hexStringToUIColor(hex: "E5E7EC", alpha: 1), thickness: 1)
        
        self.addSubview(helperView)
        helperView.edgesToSuperview()

        
        helperView.addSubview(backButton)
        backButton.height(24)
        backButton.width(24)

        backButton.leadingToSuperview(offset: 24)
        backButton.bottomToSuperview(offset: -16)
        
        
        helperView.addSubview(titleLabel)
       
        titleLabel.leadingToTrailing(of: backButton, offset: 24)
        titleLabel.top(to: backButton)
        titleLabel.bottom(to: backButton)

     
    }
     //MARK: - Action
     @objc private func tapAndReturnPreviousPage() {
         
         navigationControler?.popToRootViewController(animated: true)
        
     }
}


