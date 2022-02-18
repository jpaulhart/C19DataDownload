//
//  LocationModel.swift
//  C19DataDownload
//
//  Created by Paul Hart on 2022-02-02.
//

import Foundation
import SwiftUI

class LocationIndex: ObservableObject, Codable {
    var locationIndexItems: [LocationIndexItem] = []      // Collection of Index entries
    var selectedLocations: [String] = []
    let defaultSelectedLocations: [String] = ["Italy - Lazio", "Italy - Puglia", "Italy - Sicilia", "Italy - Basilicata", "Italy - Calabria", "Canada - British Columbia"]

}

class LocationIndexItem: Codable {
    var id: UUID = UUID()                                 // Item id
    var displayName: String = ""                          // Display Name
    var fileName: String = ""                             // File Name
    var isSelected: Bool = false                          // Location selected for graphing indicator
    var isLoaded: Bool = false                            // Location data load indicator
    var loadedDate: Date = Date.now                       // Location data loaded date and time

    init(displayName: String, fileName: String) {
        self.displayName = displayName
        self.fileName = fileName
    }
}

//
class Locations: ObservableObject {
    var locations: [String: Location] = [:]              // Collection of Locations
}

/// Contains the data for a given location
public class Location: Codable {
    
    init() { }

    public var id: UUID = UUID()                         // Unique ID
    public var displayName: String = ""                  // Display name
    public var fileName: String = ""                     // JSON file name
    public var updateTime: Date = Date.now               // Date/Time object created
    
    public var country: String = ""                      // Caption for the location
    public var region: String = ""                       // Subcation to show for the location
    public var totalCases: Int = 0                       // Total number of cases for that location
    public var deltaCases: Int = 0                       // Number of new cases in the last day for that location
    public var totalDeaths: Int = 0                      // Total number of deaths in that location
    public var deltaDeaths: Int = 0                      // Total of new deaths in the last day for that location

    public var latitude: String = ""                     // Latitude
    public var longitude: String = ""                    // Longitude
    
    public var cases: [Int] = []                         // Array of total cases since the beginning
    public var casesDelta: [Int] = []                    // Array of change of cases per day
    public var casesDeltaSmooth: [Int] = []              // Smoothed Array of change of cases per day
    
    public var deaths: [Int] = []                        // Array of total deaths since the beginning
    public var deathsDelta: [Int] = []                   // Array of changes in deaths since the beginning
    public var deathsDeltaSmooth: [Int] = []             // Smoothed Array of changes in deaths since the beginning
    
    public var hospitalizations: [Int] = []              // Array of total hospitalizations since the beginning
    public var hospitalizationsDelta: [Int] = []         // Array of change of hospitalizations per day
    public var hospitalizationsDeltaSmooth: [Int] = []   // Smoothed Array of change of hospitalizations per day
}

