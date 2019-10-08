//
//  WeatherNetworkHandler.swift
//  Ios_Labra6_teht1
//
//  Created by Saku Huuha on 01/10/2019.
//  Copyright © 2019 Saku Huuha. All rights reserved.
//

import Foundation

class WeatherNetworkHandler: WeatherNetworkHandlerObservable {
    // MARK: - WeatherStruct
    struct WeatherStruct: Codable {
        let coord: Coord
        let weather: [Weather]
        let base: String
        let main: Main
        let visibility: Int
        let wind: Wind
        let clouds: Clouds
        let dt: Int
        let sys: Sys
        let timezone, id: Int
        let name: String
        let cod: Int
    }
    
    // MARK: - Clouds
    struct Clouds: Codable {
        let all: Int
    }
    
    // MARK: - Coord
    struct Coord: Codable {
        let lon, lat: Double
    }
    
    // MARK: - Main
    struct Main: Codable {
        let temp: Double
        let pressure, humidity: Int
        let tempMin, tempMax: Double
        
        enum CodingKeys: String, CodingKey {
            case temp, pressure, humidity
            case tempMin = "temp_min"
            case tempMax = "temp_max"
        }
    }
    
    // MARK: - Sys
    struct Sys: Codable {
        let type, id: Int
        let message: Double
        let country: String
        let sunrise, sunset: Int
    }
    
    // MARK: - Weather
    struct Weather: Codable {
        let id: Int
        let main, weatherDescription, icon: String
        
        enum CodingKeys: String, CodingKey {
            case id, main
            case weatherDescription = "description"
            case icon
        }
    }
    
    // MARK: - Wind
    struct Wind: Codable {
        let speed: Double
        let deg: Int
    }
    
    func newJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
    
    func newJSONEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            encoder.dateEncodingStrategy = .iso8601
        }
        return encoder
    }
    
    // MARK: - URLSession response handlers
    
    var weatherIcon: Data?
    
    var temperature: String?
    
    var weatherType: String?
    
    private var observers: [WeatherNetworkHandlerObserver] = []
    
    func addObserver(observer: WeatherNetworkHandlerObserver) {
        guard self.observers.contains(where: { $0.id == observer.id }) == false else {
            return
        }
        self.observers.append(observer)
    }
    
    func removeObserver(observer: WeatherNetworkHandlerObserver) {
        guard let index = self.observers.firstIndex(where: { $0.id == observer.id }) else {
            return
        }
        self.observers.remove(at: index)
        
    }
    
    func notifyObservers() {
        observers.forEach { (observer) in
            observer.notifyChangedData(handler: self)
        }
    }
    
    
    let API_URL = "https://api.openweathermap.org/data/2.5/weather?q="
    let API_APPID = "&APPID=65dbec3aae5e5bf9000c7a956c8b76f6"
    let API_ICON_URL = "https://openweathermap.org/img/w/"
    let API_ICON_PNG = ".png"
    
    
    
    
    
    func fetchData(searchTerm: String){
        let urlString = API_URL + searchTerm + API_APPID
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
            
                }
                if let decodedJson = try? self.newJSONDecoder().decode(WeatherStruct.self, from: data){
                    self.weatherType = decodedJson.weather[0].main
                    let tempTemperature = decodedJson.main.temp - 273.15
                    self.temperature = String(format: "%.1f",tempTemperature)
                    
                    let imgUrl = URL(string: self.API_ICON_URL + decodedJson.weather[0].icon + self.API_ICON_PNG)
                    
                    DispatchQueue.global().async {
                        self.weatherIcon = try! Data(contentsOf: imgUrl!)
                        self.notifyObservers()
                    }
                    
                }
            }
            }.resume()
        
    }
    
    
}
