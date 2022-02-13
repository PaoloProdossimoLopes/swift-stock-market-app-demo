//
//  TimeSerieMonthyAdjust.swift
//  StockApp
//
//  Created by Paolo Prodossimo Lopes on 09/10/21.
//

import Foundation

struct MonthInfo {
    let date: Date
    let adjustedOpen: Double
    let adjustedClose: Double
}

protocol TimeSerieMonthyAdjustProtocol {
    var meta: Meta { get }
    var timeSeries: [String: AssetsOffer] { get }
}

struct TimeSerieMonthyAdjust: Decodable, TimeSerieMonthyAdjustProtocol {
    let meta: Meta
    let timeSeries: [String: AssetsOffer]
    
    func getMonthInfos() -> [MonthInfo] {
        var monthInfos: [MonthInfo] = []
        let sortedTimeSeries = timeSeries.sorted(by: { $0.key > $1.key })
        for (dateString, ohlc) in sortedTimeSeries {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let date = dateFormatter.date(from: dateString),
                  let adjustedOpen = getAdjustedOpen(ohlc: ohlc),
                  let adjustedClose = ohlc.adjustedClose.toDouble() else { return [] }
            let monthInfo = MonthInfo(date: date, adjustedOpen: adjustedOpen, adjustedClose: adjustedClose)
            monthInfos.append(monthInfo)
        }
        return monthInfos
    }
    
    private func getAdjustedOpen(ohlc: AssetsOffer) -> Double? {
        guard let open = ohlc.open.toDouble(),
              let adjustedClose = ohlc.adjustedClose.toDouble(),
              let close = ohlc.close.toDouble() else { return nil }
        return open * adjustedClose / close
    }
    
    enum CodingKeys: String, CodingKey {
        case meta = "Meta Data"
        case timeSeries = "Monthly Adjusted Time Series"
    }
    
}

struct Meta: Decodable {
    let symbol: String
    
    enum CodingKeys: String, CodingKey {
        case symbol = "2. Symbol"
    }
}

protocol AssetsOfferProtocol {
    var open: String { get }
    var close: String { get }
    var adjustedClose: String { get }
}

struct AssetsOffer: Decodable, AssetsOfferProtocol {
    let open: String
    let close: String
    let adjustedClose: String
    
    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case close = "4. close"
        case adjustedClose = "5. adjusted close"
    }
}
