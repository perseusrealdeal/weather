//
//  OpenWeatherClient.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 01.12.2021.
//

import Foundation

// MARK: - Helper abstracts used to make code testable

protocol URLSessionProtocol
{
    func dataTask(with request: URLRequest, completionHandler:
                    @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }

// MARK: - Failure scenario details

enum WeatherDataDeliveryError: Error
{
    case invalidExclude
    case invalidUrl
    case failedRequest(String)
}

// MARK: - Client for communicating with OpenWeather Service

class OpenWeatherClient
{
    private var api_key  : String { "79eefe16f6e4714470502074369fc77b" }
    private var units    : String { "metric" }

    private var dataTask : URLSessionDataTask?
    private let session  : URLSessionProtocol // Isolated for unit testing

    var onResultDelivered: (Result<Data, WeatherDataDeliveryError>) -> Void = { print($0) }
    var weather          : Data { givenData }

    private(set) var givenData: Data = Data()
    {
        didSet
        {
            onResultDelivered(.success(givenData))
        }
    }

    // Constructor injection used to make URLSession isolated
    init(session: URLSessionProtocol = URLSession.shared)
    {
        self.session = session
    }

    func requestWeatherData(exclude  : String = "hourly,minutely,daily,alerts",
                            latitude : String = "55.662546456740564",
                            longitude: String = "85.62138369331707")
    {
        // Validate parameters

        guard let encodedExclude
                = exclude.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else { onResultDelivered(.failure(.invalidExclude)); return }

        guard let url
                = URL(string:
                        "https://api.openweathermap.org/data/2.5/onecall?" +
                        "lat=\(latitude)" +
                        "&lon=\(longitude)" +
                        "&units=\(units)" +
                        "&exclude=\(encodedExclude)" +
                        "&appid=\(api_key)")
        else { onResultDelivered(.failure(.invalidUrl)); return }

        let request = URLRequest(url: url)

        // Send request

        dataTask = session.dataTask(with: request)
        { [self] (weather: Data?, response: URLResponse?, error: Error?) -> Void in

            // Read answer

            var answer_data : Data?
            var answer_error: String?

            if let error = error
            {
                answer_error = error.localizedDescription
            } else if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                answer_error = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
            } else if let requested_data = weather {
                answer_data = requested_data
            }

            // Communicate changes

            DispatchQueue.main.async
            { [weak self] in guard let self = self else { return }

                if let requested_data = answer_data
                {
                    self.givenData = requested_data
                } else if let error = answer_error {
                    self.onResultDelivered(.failure(.failedRequest(error)))
                }

                self.dataTask = nil
            }
        }

        dataTask?.resume()
    }
}
