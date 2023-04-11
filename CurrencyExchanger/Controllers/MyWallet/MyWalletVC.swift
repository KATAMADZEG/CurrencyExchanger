//
//  MyWalletVC.swift
//  CurrencyExchanger
//
//  Created by Giorgi Katamadze on 4/6/23.
//

import UIKit

final class MyWalletVC: UIViewController {
    //MARK: - Properties
    
   lazy var  topBarView = TopBarView(titleText: "ანგარიშის არჩევა", navController: self.navigationController)
    
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .white
        self.view.addSubview(topBarView)
        topBarView.edgesToSuperview(excluding: .bottom)
        topBarView.height(108)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}
