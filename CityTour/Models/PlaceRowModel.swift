//
//  PlaceRowModel.swift
//  CityTour
//
//

import Foundation

struct PlaceRowModel: Identifiable {
    let id: String
    let name: String
    let photoURL: URL
    let rating: Double
    let address: String
    
    init?(place: PlaceDetailResponseModel) {
        self.id = place.placeId
        self.name = place.name
        self.rating = place.rating
        self.address = place.vicinity
        guard let photos = place.photos,
            let firstPhoto = photos.first,
        let photoURL = URL(string: "https://maps.gomaps.pro/maps/api/place/photo?photo_reference=\(firstPhoto.photoReference)&maxwidth=400&key=APIKey") else {
                return nil
            }
        self.photoURL = photoURL
    }
}
