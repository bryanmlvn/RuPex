//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    let apiKey = "228ccae57dc73d93169f76e0"
    let baseURL = "https://v6.exchangerate-api.com/v6/228ccae57dc73d93169f76e0/pair"
    
    
    let currencyArray = ["AED", "AUD", "CAD", "CHF", "CNY", "EUR", "GBP", "HKD", "INR", "JPY", "KRW", "MYR", "NZD", "PHP", "QAR", "SAR", "SGD", "THB", "USD", "VND"]

    func getCoinPrice(for currency: String)
    {
        let urlString = "\(baseURL)/\(currency)/IDR"
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let idrPrice = self.parseJSON(safeData){
                        let priceString = String(format: "%.2f", idrPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
                
            }
            task.resume()
        }
    }
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.conversion_rate
            
            return lastPrice
            
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

}
