//
//  WeatherManager.swift
//  Clima
//
//  Created by Allan Castro on 03/10/2022.
//

import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager ,_ weather : WeatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=bb9a73a5c2a65597d067a78b8bfd17f1&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(lat: CLLocationDegrees, long: CLLocationDegrees){
        let urlStringz = "\(weatherURL)&lat=\(lat)&lon=\(long)"
        print(urlStringz)
        performRequest(with: urlStringz)
    }
    
    func performRequest(with urlString:String) {
        //1.create a url
        if let url = URL(string: urlString) {
            //2. create a url session
            let session = URLSession(configuration: .default)
            
            //3. create a task
            //let task = session.dataTask(with: url, completionHandler: handleCompletion(data: response: error:))
            let task = session.dataTask(with: url){ (data, response , error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    //                    let dataString = String(data: safeData, encoding: .utf8)
                    //                    print(dataString)
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather)
                        //print("inside manager\ncity=\(weather.cityName) temp=\(weather.temperatureString) condition=\(weather.conditionName)")
                    }
                }
            }
            //4. start the task
            task.resume()
        }
    }
    
    func parseJSON (_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            //            print(weather.conditionName)
            //            print("\(weather.temperatureString) \(temp)")
            return weather
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
        
    }
    
    
    
    //    func handleCompletion(data: Data?, response: URLResponse?, error: Error?) {
    //        if error != nil {
    //            print(error!)
    //            return
    //        }
    //        if let safeData = data {
    //            let dataString = String(data: safeData, encoding: .utf8)
    //            print(dataString)
    //        }
    //    }
}
