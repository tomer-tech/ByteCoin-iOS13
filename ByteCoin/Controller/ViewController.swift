//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var currencyLabel: UILabel!
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
}
    //MARK: - CoinManagerDelegate
    extension ViewController : CoinManagerDelegate {
        func priceUpdate(price: String, currency: String) {
            DispatchQueue.main.async {
                self.tokenLabel.text = price
                self.currencyLabel.text = currency }
        }
        func didFailWithError(error: Error) {
            print(error)
        }
    }

    //MARK: - PickerView
    extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1 //just one column needed
        }
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return coinManager.currencyArray.count //return the number of items in the coinManager array
        }
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent: Int ) -> String?{
            return coinManager.currencyArray[row]
        }
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let selectedCurrency = coinManager.currencyArray[row]
            coinManager.getCoinPrice(for: selectedCurrency)
        }
    




