//
//  AssetModel.swift
//  StockApp
//
//  Created by Paolo Prodossimo Lopes on 08/10/21.
//

import Foundation

protocol AssetModelProtocol {
    var symbol: String { get }
    var name: String { get }
    var type: String { get }
    var region: String { get }
    var marketOpen: String { get }
    var marketClose: String { get }
    var timezone: String { get }
    var currency: String { get }
    var matchScore: String { get }
}

struct AssetModel: Decodable, AssetModelProtocol {
    let symbol: String
    let name: String
    let type: String
    let region: String
    let marketOpen: String
    let marketClose: String
    let timezone: String
    let currency: String
    let matchScore: String
    
    enum CodingKeys: String, CodingKey {
        case symbol = "1. symbol"
        case name = "2. name"
        case type = "3. type"
        case region = "4. region"
        case marketOpen = "5. marketOpen"
        case marketClose = "6. marketClose"
        case timezone = "7. timezone"
        case currency = "8. currency"
        case matchScore = "9. matchScore"
    }
    
}
