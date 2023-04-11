
import UIKit
import TinyConstraints
import Combine

final class CurrencyExchangeVC: UIViewController {
    
    //MARK: - Properties
    lazy var contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 40)
    private lazy var topBarView = TopBarView(titleText: "კონვერტაცია", navController: self.navigationController)
  
    lazy var  scrollView : UIScrollView = {
        let sc = UIScrollView(frame: .zero)
        sc.frame = CGRect(x: 0, y: 108, width: view.frame.size.width, height: view.frame.size.height)
        sc.contentSize = contentSize
        sc.showsHorizontalScrollIndicator = true
        sc.keyboardDismissMode = .onDrag
        return sc
    }()
    
    lazy var  contentView : UIView = {
       let view  = UIView()
        view.backgroundColor = .clear
        view.frame.size = contentSize
        return view
    }()
    
    private let fromAccLabel : UILabel = {
        let label = UILabel()
        label.text = "ანგარიშიდან"
        label.textColor = UIColor().hexStringToUIColor(hex: "4B5B6C", alpha: 1)
        label.font = label.font.withSize(12)
        return label
    }()
    
    private let toAccLabel : UILabel = {
        let label = UILabel()
        label.text = "ანგარიშზე"
        label.font = label.font.withSize(12)
        label.textColor = UIColor().hexStringToUIColor(hex: "4B5B6C", alpha: 1)
        return label
    }()
    
    private let cardViewFrom  = CardView(type: .From)
    private let cardViewTo  = CardView(type: .To)
    
    private let seperatorView  : UIView = {
       let view  = UIView()
        view.backgroundColor  = .white
        return view
    }()
    
    private let lineImage  : UIView = {
       let iv  = UIImageView()
        iv.backgroundColor  = UIColor().hexStringToUIColor(hex: "E5E7EC", alpha: 1)
        return iv
    }()
    
    lazy var swapAccButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "swapAccIcon"), for: .normal)
        button.backgroundColor  = .white
        return button
    }()
    
    private var buyCurrencyTextField = CustomTextField(placeholder: "0.00",milliseconds: 300)
    private var sellCurrencyTextField = CustomTextField(placeholder: "0.00",milliseconds: 300)
    
    private let buyCurrencyTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "ყიდვის თანხა"
        label.font = label.font.withSize(12)
        label.textColor = UIColor().hexStringToUIColor(hex: "4B5B6C", alpha: 1)
        return label
    }()
    private let sellCurrencyTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "გაყიდვის თანხა"
        label.font = label.font.withSize(12)
        label.textColor = UIColor().hexStringToUIColor(hex: "4B5B6C", alpha: 1)
        return label
    }()
    
    lazy var currencyExchangeButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("გაგრძელება", for: .normal)
        button.setTitleColor(UIColor().hexStringToUIColor(hex: "130F26", alpha: 1), for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor().hexStringToUIColor(hex: "F7F8FA", alpha: 1)
        button.addTarget(self, action: #selector(tapAnEchangeButton), for: .touchUpInside)
        return button
    }()
    private var subscriptions       = Set<AnyCancellable>()
    private var viewModel           = CurrencyExchangeViewModel()
    //MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()

        cardViewFrom.delegate = self
        cardViewTo.delegate = self
        self.registerKeyboardEvent()
        view.backgroundColor  =  .white
        self.configureUI()
        self.configureTextFields()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    //MARK: - Helpers
    private func configureUI() {
        self.view.addSubview(topBarView)
        topBarView.edgesToSuperview(excluding: .bottom)
        topBarView.height(108)
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(fromAccLabel)
        fromAccLabel.left(to: contentView,offset: 16)
        fromAccLabel.top(to: contentView,offset: 24)
        self.contentView.addSubview(cardViewFrom)
        cardViewFrom.topToBottom(of: fromAccLabel,offset: 25)
        cardViewFrom.left(to: contentView,offset: 16)
        cardViewFrom.right(to: contentView,offset: -16)
        cardViewFrom.backgroundColor = .clear
        scrollView.addSubview(seperatorView)
        seperatorView.topToBottom(of: cardViewFrom,offset: 16)
        seperatorView.leading(to: cardViewFrom)
        seperatorView.trailing(to: cardViewFrom)
        seperatorView.addSubview(lineImage)
        lineImage.edgesToSuperview(excluding: [.top,.bottom])
        lineImage.centerY(to: seperatorView)
        lineImage.height(1)
        seperatorView.addSubview(swapAccButton)
        swapAccButton.edgesToSuperview(excluding: [.left,.right])
        swapAccButton.height(24)
        swapAccButton.width(32)
        swapAccButton.left(to: seperatorView,offset: 12)
        scrollView.addSubview(toAccLabel)
        toAccLabel.leading(to: seperatorView)
        toAccLabel.topToBottom(of: seperatorView,offset: 19)
        scrollView.addSubview(cardViewTo)
        cardViewTo.leading(to: seperatorView)
        cardViewTo.trailing(to: seperatorView)
        cardViewTo.topToBottom(of: toAccLabel,offset: 19)
        cardViewTo.backgroundColor = .clear
        let stackViewForFields = UIStackView(arrangedSubviews: [buyCurrencyTextField,sellCurrencyTextField])
        stackViewForFields.axis = .horizontal
        stackViewForFields.distribution = .fillEqually
        stackViewForFields.spacing = 9
        scrollView.addSubview(stackViewForFields)
        stackViewForFields.leading(to: cardViewTo)
        stackViewForFields.trailing(to: cardViewTo)
        stackViewForFields.topToBottom(of: cardViewTo,offset: 41)
        scrollView.addSubview(buyCurrencyTitleLabel)
        buyCurrencyTitleLabel.leading(to: buyCurrencyTextField)
        buyCurrencyTitleLabel.bottomToTop(of: buyCurrencyTextField,offset: -10)
        scrollView.addSubview(sellCurrencyTitleLabel)
        sellCurrencyTitleLabel.leading(to: sellCurrencyTextField)
        sellCurrencyTitleLabel.bottomToTop(of: buyCurrencyTextField,offset: -10)
        scrollView.addSubview(currencyExchangeButton)
        currencyExchangeButton.leading(to: stackViewForFields)
        currencyExchangeButton.trailing(to: stackViewForFields)
        currencyExchangeButton.topToBottom(of: stackViewForFields,offset: 16)
        currencyExchangeButton.height(48)
    }
    private func configureTextFields() {
        buyCurrencyTextField.throughText.map{$0}.sink(receiveValue: {[self] buyText in
            print(buyText)
            viewModel.fromAmount = buyText
            viewModel.fromCurrency = "USD"
            viewModel.toCurrency = "EUR"
            viewModel.input.getExchangedMoney(type: .Buy)
            viewModel.output = self
        })
        .store(in: &subscriptions)
        sellCurrencyTextField.throughText.map{$0}.sink(receiveValue: {[self] sellText in
            print(sellText)
            viewModel.fromAmount = sellText
            viewModel.fromCurrency = "EUR"
            viewModel.toCurrency = "USD"
            viewModel.input.getExchangedMoney(type: .Sell)
            viewModel.output = self
        })
        .store(in: &subscriptions)
    }
    //MARK: - Actions
    @objc func tapAnEchangeButton() {
        print("sadjhaksjhdas")
    }
}

//MARK: - CurrencyExchangeViewModelOutput
extension CurrencyExchangeVC : CurrencyExchangeViewModelOutput {
    func response(data: CurrencyExchangeEndPoint.Response?, error: Error?, type: FieldType) {
        switch type {
        case .Buy:
            sellCurrencyTextField.text = data?.amount
        case .Sell:
            buyCurrencyTextField.text = data?.amount
        }
    }
}

//MARK: - CardViewDelegate
extension CurrencyExchangeVC : CardViewDelegate {
    func tapToCard(type: CardViewType) {
        let vc  = MyWalletVC()
        self.navigationController?.pushViewController(vc, animated: true)
        //        switch type {
        //        case .From:
        //            print("ანგარიშიდან")
        //        case .To:
        //            print("ანგარიშზე")
        //        }
    }
}

//MARK: - RDKeyboardEventHandlerProtocol
extension CurrencyExchangeVC : RDKeyboardEventHandlerProtocol {
    func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo ,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {return}
        let keyboardHeight = keyboardFrame.cgRectValue.height
        print("\(keyboardHeight)height")
//        self.scrollView.contentOffset.y += 60
    }
    func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo ,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else {return}
    }
}
