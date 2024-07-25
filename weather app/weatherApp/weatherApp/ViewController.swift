//
//  ViewController.swift
//  weatherApp
//
//  Created by Victoria Samsonova on 5.05.24.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, WeatherGetterDelegate, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cloudCoverLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var getCityWeatherButton: UIButton!
    @IBOutlet weak var getLocationWeatherButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    var weather: WeatherGetter!
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weather = WeatherGetter(delegate: self)
        
        // Initialize UI
        // -------------
        cityLabel.text = "simple weather"
        weatherLabel.text = ""
        temperatureLabel.text = ""
        cloudCoverLabel.text = ""
        windLabel.text = ""
        rainLabel.text = ""
        humidityLabel.text = ""
        cityTextField.text = ""
        cityTextField.placeholder = "Enter city name"
        cityTextField.delegate = self
        cityTextField.enablesReturnKeyAutomatically = true
        
        
        getLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      }
    
    // MARK: - Button events and states
    // --------------------------------
    
    @IBAction func getWeatherForCityButtonTapped(_ sender: UIButton) {
        guard let text = cityTextField.text, !text.trimmed.isEmpty 
        else {
          return
        }
        setWeatherButtonStates(state: false)
        weather.getWeatherByCity(city: cityTextField.text!.urlEncoded)
    }
    
    @IBAction func getWeatherForLocationButtonTapped(_ sender: Any) {
        setWeatherButtonStates(state: false)
        getLocation()
    }
    
    @IBAction func CurrentLocWeather(_ sender: Any) {
        setWeatherButtonStates(state: false)
        getLocation()
    }
    
    @IBAction func SpecifiedCityButton(_ sender: Any) {
        setWeatherButtonStates(state: false)
        weather.getWeatherByCity(city: cityTextField.text!.urlEncoded)
    }
    
    func setWeatherButtonStates(state: Bool) {
        getLocationWeatherButton.isEnabled = state
    }
      
      // MARK: WeatherGetterDelegate methods
      // -----------------------------------
      
      func didGetWeather(weather: Weather) {
          // This method is called asynchronously, which means it won't execute in the main queue.
          // All UI code needs to execute in the main queue, which is why we're wrapping the code
          // that updates all the labels in a dispatch_async() call.
          DispatchQueue.main.async {
            self.cityLabel.text = weather.city
            self.weatherLabel.text = weather.weatherDescription
            self.temperatureLabel.text = "\(Int(round(weather.tempCelsius)))°"
            self.cloudCoverLabel.text = "\(weather.cloudCover)%"
            self.windLabel.text = "\(weather.windSpeed) m/s"
            
            if let rain = weather.rainfallInLast3Hours {
                self.rainLabel.text = "\(rain) mm"
            }
            else {
                self.rainLabel.text = "None"
            }
            
            self.humidityLabel.text = "\(weather.humidity)%"
            self.getLocationWeatherButton.isEnabled = true
            self.getCityWeatherButton.isEnabled = true;
          }
      }
      
    func didNotGetWeather(error: NSError) {
          // This method is called asynchronously, which means it won't execute in the main queue.
          // All UI code needs to execute in the main queue, which is why we're wrapping the call
          // to showSimpleAlert(title:message:) in a dispatch_async() call.
        DispatchQueue.main.async {
            self.showSimpleAlert(title: "Can't get the weather",
                                 message: "The weather service isn't responding.")
            self.getLocationWeatherButton.isEnabled = true
            self.getCityWeatherButton.isEnabled = true;
        }
    }
      
    
    // MARK: - CLLocationManagerDelegate and related methods
    
    func getLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            showSimpleAlert(
            title: "Please turn on location services",
            message: "This app needs location services in order to report the weather " +
                   "for your current location.\n" +
                   "Go to Settings → Privacy → Location Services and turn location services on."
            )
            getLocationWeatherButton.isEnabled = true
            return
        }
      
        let authStatus = CLLocationManager.authorizationStatus()
        guard authStatus == .authorizedWhenInUse else {
            switch authStatus {
            case .denied, .restricted:
                let alert = UIAlertController(
                    title: "Location services for this app are disabled",
                    message: "In order to get your current location, please open Settings for this app, choose \"Location\"  and set \"Allow location access\" to \"While Using the App\".",
                    preferredStyle: .alert
                )
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let openSettingsAction = UIAlertAction(title: "Open Settings", style: .default) {
                    action in
                    if let url = NSURL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.openURL(url as URL)
                    }
                }
                alert.addAction(cancelAction)
                alert.addAction(openSettingsAction)
                present(alert, animated: true, completion: nil)
                getLocationWeatherButton.isEnabled = true
                return
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                
            default:
                print("Oops! Shouldn't have come this far.")
            }
            return
        }
    
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
      locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        weather.getWeatherByCoordinates(latitude: newLocation.coordinate.latitude,
                                      longitude: newLocation.coordinate.longitude)
    }
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
          // This method is called asynchronously, which means it won't execute in the main queue.
          // All UI code needs to execute in the main queue, which is why we're wrapping the call
          // to showSimpleAlert(title:message:) in a dispatch_async() call.

        self.showSimpleAlert(title: "Can't determine your location",
                             message: "The GPS and other location services aren't responding.")
      
        print("locationManager didFailWithError: \(error)")
    }

    
      
    // MARK: - UITextFieldDelegate and related methods
    // -----------------------------------------------
    
    // Enable the "Get weather for the city above" button
    // if the city text field contains any text,
    // disable it otherwise.
    func textField(textField: UITextField,
                   shouldChangeCharactersInRange range: NSRange,
                                                 replacementString string: String) -> Bool {
      let currentText = textField.text ?? ""
      let prospectiveText = (currentText as NSString).replacingCharacters(
          in: range,
          with: string).trimmed
      getCityWeatherButton.isEnabled = prospectiveText.count > 0
      return true
    }
      
    // Pressing the clear button on the text field (the x-in-a-circle button
    // on the right side of the field)
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
      // Even though pressing the clear button clears the text field,
      // this line is necessary. I'll explain in a later blog post.
      textField.text = ""
      
      getCityWeatherButton.isEnabled = false
      return true
    }
      
    // Pressing the return button on the keyboard should be like
    // pressing the "Get weather for the city above" button.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
        getWeatherForCityButtonTapped(getCityWeatherButton)
      return true
    }
      
//    // Tapping on the view should dismiss the keyboard.
//     override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//       view.endEditing(true)
//     }
//      
      
      // MARK: - Utility methods
      // -----------------------

    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(
          title: title,
          message: message,
          preferredStyle: .alert
        )
        let okAction = UIAlertAction(
          title: "OK",
          style:  .default,
          handler: nil
        )
        alert.addAction(okAction)
          present(
          alert,
          animated: true,
          completion: nil
        )
      }
      
    }


extension String {
  
  // A handy method for %-encoding strings containing spaces and other
  // characters that need to be converted for use in URLs.
  var urlEncoded: String {
    return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlUserAllowed)!;
  }
  
  // Trim excess whitespace from the start and end of the string.
  var trimmed: String {
    return self.trimmingCharacters(in: NSCharacterSet.whitespaces);
  }
}
