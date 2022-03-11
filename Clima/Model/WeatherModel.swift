//
//  WeatherModel.swift
//  Clima
//
//  Created by Allan Castro on 03/10/2022.
//

import Foundation

struct WeatherModel {
    //stored properties
    let conditionId : Int
    let cityName : String
    let temperature: Double
    
    var temperatureString : String {
        return String(format: "%.1f", temperature)
    }
    
    //computed property
    var conditionName : String {
        switch conditionId {//uses the conditionId property to compute a value
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    init (conditionId: Int, cityName : String, temperature: Double) {
        self.conditionId = conditionId
        self.cityName = cityName
        self.temperature = temperature
    }
}
