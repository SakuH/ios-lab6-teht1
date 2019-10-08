//
//  ViewController.swift
//  Ios_Labra6_teht1
//
//  Created by Saku Huuha on 01/10/2019.
//  Copyright © 2019 Saku Huuha. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WeatherNetworkHandlerObserver {
    var id: Int = 0
    
    func notifyChangedData(handler: WeatherNetworkHandlerObservable) {
        DispatchQueue.main.async {
            
            self.tempLabel.text = handler.temperature! + " C"
            self.weatherTypeLabel.text = handler.weatherType
            self.weatherImageView.image = UIImage(data: handler.weatherIcon!)
        }
        print("notifychangeddatassa")
    }

    private weak var observable: WeatherNetworkHandlerObservable?

    let API_URL = "https://api.openweathermap.org/data/2.5/weather?q="
    let API_APPID = "&APPID=65dbec3aae5e5bf9000c7a956c8b76f6"
    let weatherNetworkHandler = WeatherNetworkHandler()
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observable = weatherNetworkHandler
        observable?.addObserver(observer: self)
        
        // Do any additional setup after loading the view.
    }

    @IBAction func searchButtonClicked(_ sender: Any) {
        weatherNetworkHandler.fetchData(searchTerm: searchField.text!)
    }
    
}

