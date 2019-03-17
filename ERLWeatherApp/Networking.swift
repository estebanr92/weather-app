import Foundation
import Alamofire
import AlamofireObjectMapper
import AlamofireImage
import CoreLocation

class Networking {
    var appId:String = "aaa2b071832300bcaf73ee98f6b65d5c"
    func getCurrentWeatherFromCoordinates(_ coordinates: CLLocationCoordinate2D, onCompletion:@escaping (Weather)-> ()) {
        let URL = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(appId)"
        Alamofire.request(URL).responseObject {( response:DataResponse<Weather>
            ) in
            switch response.result {
            case .success:
                let cityInfo = response.result.value
                onCompletion(cityInfo!)
            case .failure:
                print("error")
            }
        }
    }
    
    func getWeatherForNextDays(_ coordinates: CLLocationCoordinate2D, onCompletion:@escaping ([Weather])-> ()) {
        let URL = "https://api.openweathermap.org/data/2.5/forecast?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(appId)"
        Alamofire.request(URL).responseObject {( response:DataResponse<WeatherList>
            ) in
            switch response.result {
            case .success:
                let weatherList = response.result.value
                //let cityInfo = response.result.value?.weatherList?[0].temperature
                onCompletion((weatherList?.weatherList)!)
            case .failure:
                print("error")
            }
        }
    }
    
    func getCurrentWeatherFromCity(_ city: String, onCompletion:@escaping (Weather)-> ()) {
        let URL = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(appId)"
        Alamofire.request(URL).responseObject {( response:DataResponse<Weather>
            ) in
            switch response.result {
            case .success:
                let cityInfo = response.result.value
                onCompletion(cityInfo!)
            case .failure:
                print("error")
            }
        }
    }
    
    func getConditionIcon(_ iconId:String, onCompletion:@escaping (UIImage)-> ()) {
        let imageURL = "https://openweathermap.org/img/w/\(iconId).png"
        Alamofire.request(imageURL).responseImage {( response ) in
            switch response.result {
            case .success:
                onCompletion(response.result.value!)
            case .failure:
                print("error")
            }
        }
    }
    
}
