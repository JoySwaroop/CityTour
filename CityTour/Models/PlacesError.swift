//
//  PlacesError.swift
//  CityTour
//
//

import Foundation

enum PlacesError: Error {
    case invalidURL, invalidResponse, badRequestError, serverError
}
