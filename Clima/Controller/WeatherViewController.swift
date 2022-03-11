//
//  ViewController.swift
//  Clima
//
//  Created by Allan Castro on 03/11/2022.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weatherManager.delegate = self

        searchTextField.delegate = self

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()        
    }
    
    @IBAction func btnPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }

}
//MARK: - UITextFieldDelegate

extension WeatherViewController:UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    // these delegate methods are triggered by the textField class
    // note: it is possible to have multiple textFields triggering a single method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //this function can be used because of the searchField.delegate=self
        //asks the assigned delegate if the textfield should process the return button
        
        //process happens when the return button is pressed
        searchTextField.endEditing(true)
        return true;
    }
    
    //delegate method for checking when editing is done on the textField
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = "" //clear out the text field
    }// using this eliminates the need to place this in textFieldShouldReturn and searchPressed
    
    //delegate method for handling when to allow editing on a text field to end
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //use case example: useful for doing validation
        if textField.text != "" {
            return true
        }
        else {
            //prompt the user about any errors
            textField.placeholder = "Type something"
            return false// keep the focus on the textfield and the keyboard opened
        }
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController : WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager : WeatherManager, _ weather: WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    func didFailWithError(_ error: Error) {
        print(error)
    }
}

//MARK: - LocationManagerDelegate
extension WeatherViewController : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var lat : CLLocationDegrees
        var long : CLLocationDegrees
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            lat = location.coordinate.latitude
            long = location.coordinate.longitude
            
            weatherManager.fetchWeather(lat: lat, long: long)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
