//
//  CustomViewsProtocol.swift
//  StockApp
//
//  Created by Paolo Prodossimo Lopes on 08/10/21.
//

import UIKit

typealias STCCustomViewProtocol = (UIView & CustomViewsProtocol)
typealias STCCustomViewControllerProtocol = (UIViewController & CustomViewsProtocol)
typealias STCCustomTableViewControllerProtocol = (UITableViewController & CustomViewsProtocol)

protocol CustomViewsProtocol {
    func configureHierarchy()
    func configureConstraints()
    func configureStyle()
}

extension CustomViewsProtocol {
    func configureStyle() {}
    
    func commonInit() {
        configureHierarchy()
        configureConstraints()
        configureStyle()
    }
}
