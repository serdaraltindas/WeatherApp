import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager , weather :WeatherModel)
    func didFailWithError(error : Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=4eb44d65f81f807a30e3443ffc9f38bd&units=metric"
    var clima = ""
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName : String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest( with : urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude : CLLocationDegrees){
        let urlMap = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlMap)
    }
    
    func performRequest(with urlString : String){
        if let url = URL(string: urlString) {
            let sesion = URLSession(configuration: .default)
            let task = sesion.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.ParseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func ParseJSON(_ weatherData : Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
    


