//
//  STCSearchController.swift
//  StockApp
//
//  Created by Paolo Prodossimo Lopes on 08/10/21.
//

import UIKit

protocol STCSearchControllerDelegate: class  {
    func updateSearchResults(_ searchController: UISearchController)
    func willDismissSearchController(_ searchController: UISearchController)
}

final class STCSearchController: UISearchController {
    
    //MARK: - Propertie
    
    weak var searchBarDelegate: STCSearchControllerDelegate?
    
    //MARK: - Lifecycle
    
    init() {
        super.init(searchResultsController: nil)
        configureStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureStyle() {
        
        searchResultsUpdater = self
        
        delegate = self
        
        obscuresBackgroundDuringPresentation = false
        searchBar.autocapitalizationType = .allCharacters
        
        searchBar.tintColor = .white
        searchBar.barStyle = .black
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Busque pelo nome da empresa ou sigla",
                                                                             attributes: [.foregroundColor : UIColor.white])
        searchBar.showsSearchResultsButton = false
        searchBar.searchTextField.leftView?.tintColor = .white
        searchBar.searchTextField.rightView?.tintColor = .white
        searchBar.searchTextField.clearButtonMode = .whileEditing
        searchBar.searchTextField.tokenBackgroundColor = .white
        
        if let clearButton = searchBar.searchTextField.value(forKey: "_clearButton") as? UIButton {
            // Create a template copy of the original button image
            let templateImage =  clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            
            // Set the template image copy as the button image
            clearButton.setImage(templateImage, for: .normal)
            clearButton.setImage(templateImage, for: .highlighted)
            
            // Finally, set the image color
            clearButton.tintColor = .white
        }
        
        searchBar.isTranslucent = true
        searchBar.backgroundColor = .clear
        
        searchBar.isOpaque = false
    }
    
    //MARK: - Selectors
    
}

//MARK: - SearchController extensions

extension STCSearchController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let delegate = searchBarDelegate else { return }
        delegate.updateSearchResults(searchController)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        guard let delegate = searchBarDelegate else { return }
        delegate.willDismissSearchController(searchController)
    }
}
