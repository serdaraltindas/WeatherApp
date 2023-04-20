import UIKit
import CoreLocation

class WeatherViewController: UIViewController{
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()
    //1.Kod satırı
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        weatherManager.delegate = self
        searchTextField.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func LocationButton(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {

        searchTextField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchTextField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if searchTextField.text != "" {
            return true
        }else{
            searchTextField.placeholder = "Type Something..."
            return false
        }
    }//1.Kod satırı
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager , weather :WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}
//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude : lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
