//
//  PlacesViewModel.swift
//  CityTour
//
//

import Foundation
import CoreLocation

@MainActor
class PlacesViewModel: NSObject, ObservableObject {
    
    private let apiClient = APIClient()
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    @Published var selectedKeyword: Keyword = .cafe
    @Published var places: [PlaceRowModel] = []
    @Published var isLoading = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var presentAlert = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func changeKeyword(to keyword: Keyword) async {
        guard let currentLocation = currentLocation else { return }
        if selectedKeyword == keyword {
            return
        } else {
            selectedKeyword = keyword
        }
        isLoading = true
        let result = await apiClient.getPlaces(forKeyword: keyword.apiName, location: currentLocation)
        isLoading = false
        parseAPI(result: result)
    }
    
    func fetchPlaces(location: CLLocation) async {
        isLoading = true
        let result = await apiClient.getPlaces(forKeyword: "Coffee", location: location)
        isLoading = false
        parseAPI(result: result)
    }
    
    private func parseAPI(result: APIClient.PlacesResult) {
        switch result {
        case .success(let placesResponseModel):
            let places = placesResponseModel.results
            self.places = places.compactMap({ PlaceRowModel(place: $0) })
        case .failure(let placesError):
            switch placesError {
            case .invalidURL, .invalidResponse, .badRequestError:
                alertTitle = "Something Has Gone Wrong"
                alertMessage = "We apologize and we are looking into the issue. Please try again later."
            case .serverError:
                alertTitle = "Something Has Gone Wrong"
                alertMessage = "Please check your internet connection or please try again later."
            }
            presentAlert = true
        }
    }
    
}

extension PlacesViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            alertTitle = "No Location Access"
            alertMessage = "Please grant location access in settings to allow City Tour to find places around you."
            presentAlert = true
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            alertTitle = "No Location Access"
            alertMessage = "Please grant location access in settings to allow City Tour to find places around you."
            presentAlert = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        currentLocation = location
        Task {
            await fetchPlaces(location: location)
        }
        
    }
    
}
