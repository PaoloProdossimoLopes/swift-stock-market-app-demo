//
//  STCSearchViewCell.swift
//  StockApp
//
//  Created by Paolo Prodossimo Lopes on 08/10/21.
//

import UIKit

typealias CustomTableViewCell = (UITableViewCell & CustomViewsProtocol)

final class STCSearchViewCell: CustomTableViewCell {
    
    //MARK: - Properties
    
    var assetModel: AssetModel? {
        didSet { configureDatas() }
    }
    
    private let containerView = UIView()
    
    private var companyNameLabel: UILabel = UILabel()
    private var assetSimbolLabel: UILabel = UILabel()
    private var countryLabel: UILabel = UILabel()
    
    private let VStack = UIStackView()
    private let HStack = UIStackView()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureHierarchy() {
        [assetSimbolLabel, countryLabel].forEach { VStack.addArrangedSubview($0) }
        [VStack, companyNameLabel].forEach { HStack.addArrangedSubview($0) }
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(HStack)
        HStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureConstraints() {
        
        NSLayoutConstraint.activate([
            assetSimbolLabel.widthAnchor.constraint(equalToConstant: (super.frame.width/3 + 10)),
            
            HStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            HStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            HStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            HStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
    
    func configureStyle() {
        
        let customCollorApp: UIColor = .init(red: 35/255, green: 84/255, blue: 177/255, alpha: 1)
        backgroundColor = customCollorApp
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        
        companyNameLabel.textAlignment = .right
        companyNameLabel.font = .boldSystemFont(ofSize: 20)
        companyNameLabel.numberOfLines = 2
        
        assetSimbolLabel.font = .boldSystemFont(ofSize: 26)
        assetSimbolLabel.numberOfLines = 1
        assetSimbolLabel.text = assetSimbolLabel.text?.uppercased()
        assetSimbolLabel.textAlignment = .left
        assetSimbolLabel.textColor = customCollorApp
        
        countryLabel.textAlignment = .left
        countryLabel.textColor = .systemGray
        
        VStack.distribution = .fillProportionally
        VStack.axis = .vertical
        VStack.alignment = .leading
        VStack.spacing = 8
        
        HStack.distribution = .fillProportionally
        HStack.axis = .horizontal
        HStack.spacing = 10
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.6
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 5
        
    }
    
    private func configureDatas() {
        
        companyNameLabel.text = assetModel?.name
        assetSimbolLabel.text = assetModel?.symbol
        countryLabel.text = assetModel?.currency
        
    }
    
    //MARK: - Selectors
    
}
