//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation
protocol CoinManagerDelegate {
    func didFailWithError(error: Error)
    func priceUpdate(price: String, currency: String)
}
struct CoinManager {
    var delegate : CoinManagerDelegate? //this is a data type. not assigned!!!
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "8C9780DE-0F43-4DC7-8660-8B72525D56DC"
    //var cyrpto = String?
    let currencyArray =  ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    
    func getCoinPrice(for currency: String){
        //1. create urlString from selected currency and apikey
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        //create url for networking purposes based on value of urlstring(from selection)
        if let url = URL(string: urlString){
            //create session
            let session = URLSession(configuration: .default)
            //create new data task from session
            let task = session.dataTask(with: url){ (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let price = self.parseJSON(safeData) {
                        //Optional: round the price down to 2 decimal places.
                        let priceString = String(format: "%.2f", price)
                        //Call the delegate method in the delegate (ViewController) and
                        //pass along the necessary data.
                        self.delegate?.priceUpdate(price: priceString, currency: currency)
    
                    }}}
                    task.resume()
                }
            }
    
    func parseJSON (_ data: Data) -> Double? { //func takes data as an imput. expects to return an optional double
        let decoder = JSONDecoder() //create json decoder
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data) //Try to decode 'data' using 'CoinData struct.'
            let lastPrice = decodedData.rate //set rate as lastrpice
            return lastPrice
        }
        catch{ //catch and print any errors
            print(error)
            return nil
        }
    }
}

//Using what you’ve learnt about extensions, create an extension for the CoinManagerDelegate related code and an extension for the UIPickerView Delegate and DataSource related code. Then mark them with a MARK comment.
