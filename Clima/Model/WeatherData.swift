//
//  WeatherData.swift
//  Clima
//
//  Created by Allan Castro on 03/10/2022.
//

import Foundation

struct WeatherData : Decodable, Encodable { //make this struct conform to the decodable (A type that can decode itself from an external representation which in this case we are expecting a JSON representation)
    //the encodable allows the swift object to a JSON
    let name : String
    let main: Main
    let weather: [Weather]
}

struct Main : Codable { // Codable is a typealias for combining both the Decodable and Encodable protocol
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id : Int
}
