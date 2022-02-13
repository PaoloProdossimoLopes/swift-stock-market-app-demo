//
//  STCAssetDetailViewController.swift
//  StockApp
//
//  Created by Paolo Prodossimo Lopes on 09/10/21.
//

import UIKit

final class STCAssetDetailViewController: STCCustomViewControllerProtocol {
    
    //MARK: - Properties
    
    var assetModel: AssetOffer
    
    private let assetSymbolLabel: UILabel = UILabel()
    private let assetNameLabel: UILabel = UILabel()
    
    private let divider = UIView()
    
    private let currencyLabel: UILabel = UILabel()
    private let valueLabel: UILabel = UILabel()
    
    private let investAmountLabel: UILabel = UILabel()
    private let investAmountValueLabel: UILabel = UILabel()
    
    private let gainLabel: UILabel = UILabel()
    private let gainValueLabel: UILabel = UILabel()
    
    private let annualReturnLabel: UILabel = UILabel()
    private let annualReturnValueLabel: UILabel = UILabel()
    
    private let HAssetNameStackView = UIStackView()
    private let HInvestAmountStackView = UIStackView()
    private let HGainStackView = UIStackView()
    private let HAnnualReturnStackView = UIStackView()
    
    private let dividerTwo = UIView()
    
    private let initialInvestmentAmountLabel: UILabel = UILabel()
    private let initialInvestmentAmountTextField = UITextField()
    
    private let monthlyCostAcveragingAmountLabel: UILabel = UILabel()
    private let monthlyCostAcveragingAmountTextField = UITextField()
    
    private let initialDateOfEventLabel: UILabel = UILabel()
    private let initialDateOfEventTextField = UITextField()
    
    private let VInitialInvestmentAmountStack = UIStackView()
    private let VMonthlyCostAcveragingStack = UIStackView()
    private let VInitialDateOfEventStack = UIStackView()
    
    private let sliderView = UISlider()
    
    private lazy var mainStackView = UIStackView(arrangedSubviews: [
                                                    HAssetNameStackView, divider,
                                                    HInvestAmountStackView, HGainStackView,
                                                    HAnnualReturnStackView, dividerTwo,
                                                    VInitialInvestmentAmountStack, VMonthlyCostAcveragingStack,
                                                    VInitialDateOfEventStack, sliderView])
    
    //MARK: - Init
    
    init(assetModel: AssetOffer) {
        self.assetModel = assetModel
        super.init(nibName: nil, bundle: nil)
        inputDatas()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    
    //MARK: - Helpers
    
    func configureHierarchy() {
        HAssetNameStackView.addArrangedSubview(assetSymbolLabel)
        HAssetNameStackView.addArrangedSubview(assetNameLabel)
        
        HInvestAmountStackView.addArrangedSubview(investAmountLabel)
        HInvestAmountStackView.addArrangedSubview(investAmountValueLabel)

        HGainStackView.addArrangedSubview(gainLabel)
        HGainStackView.addArrangedSubview(gainValueLabel)

        HAnnualReturnStackView.addArrangedSubview(annualReturnLabel)
        HAnnualReturnStackView.addArrangedSubview(annualReturnValueLabel)
        
        VInitialInvestmentAmountStack.addArrangedSubview(initialInvestmentAmountLabel)
        VInitialInvestmentAmountStack.addArrangedSubview(initialInvestmentAmountTextField)

        VMonthlyCostAcveragingStack.addArrangedSubview(monthlyCostAcveragingAmountLabel)
        VMonthlyCostAcveragingStack.addArrangedSubview(monthlyCostAcveragingAmountTextField)
        
        VInitialDateOfEventStack.addArrangedSubview(initialDateOfEventLabel)
        VInitialDateOfEventStack.addArrangedSubview(initialDateOfEventTextField)
        
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 1),
            dividerTwo.heightAnchor.constraint(equalToConstant: 1),
            
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    func configureStyle() {
        
        title = "\(assetModel.assetsModel.symbol) Detail"
        view.backgroundColor = .white
        
        let customCollorApp: UIColor = .init(red: 35/255, green: 84/255, blue: 177/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = customCollorApp
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        mainStackView.distribution = .fillProportionally
        
        [HAssetNameStackView, HInvestAmountStackView, HGainStackView, HAnnualReturnStackView].forEach { $0.axis = .horizontal }
        
        [VInitialInvestmentAmountStack, VMonthlyCostAcveragingStack, VInitialDateOfEventStack].forEach { $0.axis = .vertical }
        
        [divider, dividerTwo].forEach  { $0.backgroundColor = .lightGray }
        
        [assetNameLabel, investAmountValueLabel, gainValueLabel, annualReturnValueLabel].forEach { $0.textAlignment = .right }
        
        [initialInvestmentAmountTextField, initialDateOfEventTextField, monthlyCostAcveragingAmountTextField].forEach { $0.addDoneButton() }
        
        assetNameLabel.numberOfLines = 2
        sliderView.tintColor = .black
    }
    
    private func inputDatas() {
        assetSymbolLabel.text = assetModel.assetsModel.symbol
        assetSymbolLabel.font = .boldSystemFont(ofSize: 20)
        
        assetNameLabel.text = assetModel.assetsModel.name
        assetNameLabel.font = .systemFont(ofSize: 18)
        
        currencyLabel.text = "Currency value (\(assetModel.assetsModel.region)"
        
        valueLabel.text = "5000"
    
        investAmountLabel.text = "Invest amount"
        investAmountValueLabel.text = assetModel.assetsModel.currency
        
        gainLabel.text = "Gain"
        gainValueLabel.text = "+100.25 (+10.25%)"
        
        annualReturnLabel.text = "Annual return"
        annualReturnValueLabel.text = "10.5%"
        
        initialInvestmentAmountLabel.text = "Initial investiment Amount (USD)"
        initialInvestmentAmountTextField.placeholder = "Enter Initial investiment Amount"
        
        monthlyCostAcveragingAmountLabel.text = "Monthly dollars averaging amount (USD)"
        monthlyCostAcveragingAmountTextField.placeholder = "Enter Monthly dollars averaging amount"
        
        initialDateOfEventLabel.text = "Initial data of investiment (USD)"
        initialDateOfEventTextField.placeholder = "Enter Initial data of investiment"
    }
    
    //MARK: - Selectors
    
}
