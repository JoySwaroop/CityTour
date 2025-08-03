//
//  APIClient.swift
//  CityTour
//
//

import Foundation
import CoreLocation

class APIClient {
    
    private let baseURL = "https://maps.gomaps.pro/maps/api/place/nearbysearch/json"
    private let googlePlacesKey = "API Key"
    
    typealias PlacesResult = Result<PlacesResponseModel, PlacesError>
    
    private func responseType(statusCode: Int) -> ResponseType {
        switch statusCode {
        case 100..<200:
            print("DEBUG: informational")
            return .informational
        case 200..<300:
            print("DEBUG: successful request")
            return .success
        case 300..<400:
            print("DEBUG: redirection")
            return .redirection
        case 400..<500:
            print("DEBUG: bad request")
            return .clientError
        case 500..<600:
            print("DEBUG: server error")
            return .serverError
        default:
            print("DEBUG: unknown status code")
            return .undefined
        }
    }
    
    func getPlaces(forKeyword keyword: String, location: CLLocation) async -> PlacesResult {
        guard let url = createURL(location: location, keyword: keyword) else {
            return .failure(.invalidURL)
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            let responseType = responseType(statusCode: response.statusCode)
            switch responseType {
            case .serverError, .informational, .redirection, .undefined:
                print("DEBUG: server error in request")
                return .failure(.serverError)
            case .clientError:
                print("DEBUG: bad server request error")
                return .failure(.badRequestError)
            case .success:
                let decodedJSON = try JSONDecoder().decode(PlacesResponseModel.self, from: data)
                return .success(decodedJSON)
            }
        } catch {
            print("DEBUG11: \(error.localizedDescription)")
            return .failure(.badRequestError)
        }
    }
    
    private func createURL(location: CLLocation, keyword: String) -> URL? {
        var urlComponents = URLComponents(string: baseURL)
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "location", value: String(location.coordinate.latitude) + "," + String(location.coordinate.longitude)),
            URLQueryItem(name: "rankby", value: "distance"),
            URLQueryItem(name: "keyword", value: keyword),
            URLQueryItem(name: "key", value: googlePlacesKey)
        ]
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
    
    
}
