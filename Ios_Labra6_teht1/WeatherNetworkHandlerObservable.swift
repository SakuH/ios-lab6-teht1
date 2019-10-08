//
//  WeatherNetworkHandlerObservable.swift
//  Ios_Labra6_teht1
//
//  Created by Saku Huuha on 01/10/2019.
//  Copyright © 2019 Saku Huuha. All rights reserved.
//

import Foundation

protocol WeatherNetworkHandlerObservable: class {
    var temperature: String? { get }
    var weatherType: String? { get }
    var weatherIcon: Data? { get }
    
    func addObserver(observer: WeatherNetworkHandlerObserver)
    func removeObserver(observer: WeatherNetworkHandlerObserver)
    func notifyObservers()
}
