//
//  SearchResultsModel.swift
//  StockApp
//
//  Created by Paolo Prodossimo Lopes on 08/10/21.
//

import Foundation

struct SearchResults: Decodable {
    let bestMatches: [AssetModel]
}
