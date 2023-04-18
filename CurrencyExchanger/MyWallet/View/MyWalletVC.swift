//
//  MyWalletVC.swift
//  CurrencyExchanger
//
//  Created by Giorgi Katamadze on 4/6/23.
//

import UIKit

enum MyWalletSections {
    case firstSec
}
protocol MyWalletVCDelegate: AnyObject {
    func throwCardInfo(model:MyWalletModel,type:CardViewType)
}
final class MyWalletVC: UIViewController {
    //MARK: - Properties
    lazy var  topBarView = TopBarView(titleText: "ანგარიშის არჩევა", navController: self.navigationController)
    private lazy var myWalletTableView: UITableView = {
        let tv = UITableView(frame: .zero,style: .grouped)
        tv.separatorStyle = .none
        tv.backgroundColor = .white
        return tv
    }()
    lazy  var dataSource: UITableViewDiffableDataSource<MyWalletSections,MyWalletModel> = {
        let dataSource : UITableViewDiffableDataSource<MyWalletSections,MyWalletModel> =   UITableViewDiffableDataSource(tableView: myWalletTableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyWalletCell", for: indexPath) as! MyWalletCell
            cell.lineView.isHidden = false
            cell.configureUI()
            if indexPath.row == self.viewModel.myWallet.count - 1 {
                cell.lineView.isHidden = true
            }
            cell.configureModel(with: itemIdentifier)
            return cell
        }
        return dataSource
    }()
    let viewModel = MyWalletViewModel()
    weak var delegate: MyWalletVCDelegate?
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .white
        view.addSubview(topBarView)
        topBarView.edgesToSuperview(excluding: .bottom)
        topBarView.height(108)
        view.addSubview(myWalletTableView)
        myWalletTableView.edgesToSuperview(excluding: .top)
        myWalletTableView.topToBottom(of: topBarView)
        configureTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    //MARK: - Helpers
    private func configureTableView() {
        myWalletTableView.delegate = self
        myWalletTableView.dataSource = dataSource
        myWalletTableView.register(MyWalletCell.self, forCellReuseIdentifier: "MyWalletCell")
        var snapShot = NSDiffableDataSourceSnapshot<MyWalletSections,MyWalletModel>()
        snapShot.appendSections([.firstSec])
        snapShot.appendItems(viewModel.myWallet)
        dataSource.apply(snapShot,animatingDifferences: true)
    }
}
//MARK: - UITableViewDelegate
extension MyWalletVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item  = dataSource.itemIdentifier(for: indexPath) else {return}
        delegate?.throwCardInfo(model: item,type: viewModel.type)
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = MyWalletHeader()
        header.configureMyWalletHeader()
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        48
    }
}
