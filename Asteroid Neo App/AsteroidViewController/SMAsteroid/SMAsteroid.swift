//
//  SMAsteroid.swift
//  Asteroid Neo App
//
//  Created by Kashware Dev on 10/11/21.
//

import Foundation

struct SMAsteroidRequest {
    var startDate = ""
    var endDate = ""
}

struct SMBaseDataAsteroid {
    
    let nextLink: String
    let prevLink: String
    let selfLink: String
    let elementCount: Int
    let nearEarthObjects: [SMNearEarthObjects]
    
    init() {
        self.init(json: JSON())
    }
    
    init(json : JSON) {
        nextLink = json["links"]["next"].stringValue
        prevLink = json["links"]["prev"].stringValue
        selfLink = json["links"]["self"].stringValue
        elementCount = json["element_count"].intValue
        nearEarthObjects = json["near_earth_objects"].dictionaryValue.map { SMNearEarthObjects(key: $0.key, value: $0.value) }.sorted(by: { $0.date > $1.date })
    }
}

struct SMNearEarthObjects {
    
    let date: String
    let asteroidList: [SMAsteroid]
    let formattedDate: String

    init() {
        self.init(key: "", value: JSON())
    }
    
    init(key: String, value : JSON) {
        date = key
        asteroidList = value.arrayValue.map { SMAsteroid(json: $0) }
        formattedDate = key.getFormattedDate
    }
}

struct SMAsteroid {
    
    let links: String
    let id: String
    let neo_reference_id: String
    let name: String
    let closeApproachData: SMCloseApproachData
    let avgSize: Double
    let formattedAvgSize: String

    init() {
        self.init(json: JSON())
    }
    
    init(json : JSON) {
        links = json["links"]["self"].stringValue
        id = json["id"].stringValue
        neo_reference_id = json["neo_reference_id"].stringValue
        name = json["name"].stringValue
        closeApproachData = SMCloseApproachData(json: json["close_approach_data"].arrayValue.first ?? JSON())
        let estimatedDiameterKilometers = json["estimated_diameter"]["kilometers"]
        let estimated_diameter_min = estimatedDiameterKilometers["estimated_diameter_min"].doubleValue
        let estimated_diameter_max = estimatedDiameterKilometers["estimated_diameter_max"].doubleValue
        
        avgSize = (estimated_diameter_min+estimated_diameter_max)/2
        formattedAvgSize = avgSize.roundedBy(xDecimalPoints: 2)
    }
}

struct SMCloseApproachData {
    
    let kilometers: String
    let kilometersPerHour: String
    
    init() {
        self.init(json: JSON())
    }
    
    init(json: JSON) {
        kilometers = json["miss_distance"]["kilometers"].doubleValue.roundedBy(xDecimalPoints: 2)
        kilometersPerHour = json["relative_velocity"]["kilometers_per_hour"].doubleValue.roundedBy(xDecimalPoints: 2)
    }
}
