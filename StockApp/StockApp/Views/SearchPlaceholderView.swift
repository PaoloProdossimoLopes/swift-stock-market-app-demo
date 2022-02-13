//
//  SearchPlaceholderView.swift
//  StockApp
//
//  Created by Paolo Prodossimo Lopes on 09/10/21.
//

import UIKit

final class SearchPlaceholderView: STCCustomViewProtocol {
    
    
    //MARK: - Properties
    
    private let placeHolderImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "imDca")?.withTintColor(.white)
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "Search for companies to calculate potential returns via dollar cost averaging"
        label.textColor = .white
        return label
    }()
    
    private lazy var stackView = UIStackView(arrangedSubviews: [placeHolderImage, placeHolderLabel])
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureHierarchy() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureConstraints() {
        
        NSLayoutConstraint.activate([
            placeHolderImage.heightAnchor.constraint(equalToConstant: 30),

            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            stackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 400),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        stackView.frame = super.frame
    }
    
    func configureStyle() {
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        
        placeHolderLabel.numberOfLines = 3
        placeHolderLabel.textAlignment = .center
    }
    
    //MARK: - Selectors
    
}
