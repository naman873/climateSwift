
import Foundation



protocol WeatherManagerDelete{
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

//

class WeatherManager{
    
    let apikey = "f6ecf2f6f958a9aed7631592550608fe";
    let openWeatherMapUrl = "https://api.openweathermap.org/data/2.5/weather";
    
    var delegate: WeatherManagerDelete?
    
 
    
    func fetchWeather(cityName: String){
        
        let url = "\(openWeatherMapUrl)?q=\(cityName)&appid=\(apikey)&units=metric";
        performRequest(url: url)
    }
    
    func fetchCurrentWeather(_ lat: Double, _ long: Double){
        let url = "\(openWeatherMapUrl)?appid=\(apikey)&lat=\(lat)&lon=\(long)&units=metric";
        performRequest(url: url)
    }
    
    
    func performRequest(url: String){
        //1. Create Url
        
        if let  url = URL(string: url){
            
            //2. Create Session
            
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            
            let task = session.dataTask(with: url) {(data, response, error) in
                if (error != nil){
                    print(error ?? "")
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    
                    if let weather = self.parseJson(weatherData: safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                    
                }
            }
            
            //4. Start the task
            
            task.resume()
        }
    }
    
    func parseJson(weatherData: Data)-> WeatherModel? {
        
        let decoder = JSONDecoder()
        do{
            let decodeData =  try decoder.decode(WeatherData.self, from: weatherData)
            let temperature = decodeData.main.temp
            let citeName = decodeData.name
            let id = decodeData.weather[0].id
            let weatherModel = WeatherModel(temperature: temperature, conditionId: id, cityName: citeName)
          
            return weatherModel
        }
        catch{
            print(error)
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
        
        
    
    


