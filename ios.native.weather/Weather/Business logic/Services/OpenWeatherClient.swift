//
//  OpenWeatherClient.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 01.12.2021.
//

import Foundation

class OpenWeatherClient
{
    private let OPENWEATHER_API_KEY = "79eefe16f6e4714470502074369fc77b"
    
    private var dataTask: URLSessionDataTask?
    
    var onWeatherDataUpdate: (Data) -> Void = { print($0) }
    private(set) var givenData: Data = Data()
    {
        didSet
        {
            onWeatherDataUpdate(givenData)
        }
    }
    
    func updateWeatherData(exclude: String = "hourly,minutely,daily",
                           units: String = "metric",
                           latitude: String = "55.662546456740564",
                           longitude: String = "85.62138369331707")
    {
        guard let encodedExclude = exclude.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string:
                                "https://api.openweathermap.org/data/2.5/onecall?" +
                                "lat=\(latitude)" +
                                "&lon=\(longitude)" +
                                "&units=\(units)" +
                                "&exclude=\(encodedExclude)" +
                                "&appid=\(OPENWEATHER_API_KEY)")
        else { return }
        
        let request = URLRequest(url: url)
        
        dataTask = URLSession.shared.dataTask(with: request)
        { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            var givenData: Data?
            var errorMessage: String?
            
            if let error = error
            {
                errorMessage = error.localizedDescription
            }
            else if let response = response as? HTTPURLResponse, response.statusCode != 200
            {
                errorMessage = "Response: " + HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
            }
            else if let data = data
            {
                givenData = data
            }
            
            DispatchQueue.main.async
            { [weak self] in guard let self = self else { return }
                
                if let givenData = givenData
                {
                    self.givenData = givenData
                }
                if let errorMessage = errorMessage
                {
                    print(errorMessage)
                }
                
                self.dataTask = nil
            }
            
        }
        
        dataTask?.resume()
    }
}
