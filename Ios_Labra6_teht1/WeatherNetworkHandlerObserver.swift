//
//  WeatherNetworkHandlerObserver.swift
//  Ios_Labra6_teht1
//
//  Created by Saku Huuha on 01/10/2019.
//  Copyright © 2019 Saku Huuha. All rights reserved.
//

import Foundation

protocol WeatherNetworkHandlerObserver {
    
    var id : Int { get set }

    func notifyChangedData(handler: WeatherNetworkHandlerObservable)
}
