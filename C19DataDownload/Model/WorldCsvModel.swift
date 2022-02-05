//
//  WorldCsvModel.swift
//  C19DataDownload
//
//  Created by Paul Hart on 2022-02-02.
//

import Foundation
import SwiftCSV

enum UrlError: Error {
    case obvious
}


class WorldItems {
    var confirmedUrl = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
    var deathsUrl = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"
    var worldLoadTimestamp: Date = Date.now
    var locations: [Location] = []
    
    init() {
        self.loadData()
    }
    
    func loadData() {
        do {
            let confirmedCsvFile = try loadConfirmedData()
            let deathsCsvFile = try loadDeathsData()
            self.locations = processFiles(confirmed: confirmedCsvFile, deaths: deathsCsvFile)
        } catch {
            print("Error thrown")
        }
        worldLoadTimestamp = Date.now
    }
    
    func loadConfirmedData() throws -> CSV {
        print("WorldCsvModel:loadConfirmedData - Loading World confirmed COVID data.")
        print()
        if let url = URL(string: confirmedUrl) {
            do {
                return try CSV(url: url)
            } catch {
                print("WorldCsvModel:loadConfirmedData - Confirmed file read error")
            }
        } else {
            print("WorldCsvModel:loadConfirmedData - In valid confirmed URL: \(confirmedUrl)")
        }
        print("WorldCsvModel:loadConfirmedData - Loaded world confirmed COVID data.")
        throw UrlError.obvious
    }
    
    func loadDeathsData() throws -> CSV {
        print("WorldCsvModel:loadDeathsData - Loading World deaths COVID data.")
        print()
        if let url = URL(string: deathsUrl) {
            do {
                return try CSV(url: url)
            } catch {
                print("WorldCsvModel:loadDeathsData - Deaths file read error")
            }
        } else {
            print("WorldCsvModel:loadDeathsData - Invalid deaths URL: \(deathsUrl)")
        }
        print("WorldCsvModel:loadDeathsData - Loaded world deaths COVID data.")
        throw UrlError.obvious
    }
    
    func processFiles(confirmed: CSV, deaths:CSV) -> [Location] {
        var locations: [Location] = []
        let confirmedRows = confirmed.enumeratedRows
        let deathsRows = deaths.enumeratedRows
        if confirmedRows.count == deathsRows.count {
            for index in 0..<confirmedRows.count {
                let newLocation = Location()
                let confirmedFields = confirmedRows[index]
                let deathsFields = deathsRows[index]
                for fieldIndex in 0..<confirmedFields.count {
                    if fieldIndex == 0 {
                        newLocation.region = confirmedFields[fieldIndex]
                    } else if fieldIndex == 1 {
                        newLocation.country = confirmedFields[fieldIndex]
                    } else if fieldIndex == 2 {
                        newLocation.latitude = confirmedFields[fieldIndex]
                    } else if fieldIndex == 3 {
                        newLocation.longitude = confirmedFields[fieldIndex]
                    } else {
                        newLocation.cases.append(Int(confirmedFields[fieldIndex]) ?? 0)
                        newLocation.deaths.append(Int(deathsFields[fieldIndex]) ?? 0)
                        let caseCount = newLocation.cases.count - 1
                        if caseCount > 0 {
                            newLocation.casesDelta.append( newLocation.cases[caseCount] - newLocation.cases[caseCount - 1] )
                            newLocation.deathsDelta.append( newLocation.deaths[caseCount] - newLocation.deaths[caseCount - 1] )
                        } else {
                            newLocation.casesDelta.append( 0 )
                            newLocation.deathsDelta.append( 0 )
                        }
                        if caseCount > 7 {
                            newLocation.casesDeltaSmooth.append( (newLocation.casesDelta[caseCount - 1] +
                                                                  newLocation.casesDelta[caseCount - 2] +
                                                                  newLocation.casesDelta[caseCount - 3] +
                                                                  newLocation.casesDelta[caseCount - 4] +
                                                                  newLocation.casesDelta[caseCount - 5] +
                                                                  newLocation.casesDelta[caseCount - 6] +
                                                                  newLocation.casesDelta[caseCount - 7] ) / 7)
                            newLocation.deathsDeltaSmooth.append( (newLocation.deathsDelta[caseCount - 1]  +
                                                                   newLocation.deathsDelta[caseCount - 2]  +
                                                                   newLocation.deathsDelta[caseCount - 3]  +
                                                                   newLocation.deathsDelta[caseCount - 4]  +
                                                                   newLocation.deathsDelta[caseCount - 5]  +
                                                                   newLocation.deathsDelta[caseCount - 6]  +
                                                                   newLocation.deathsDelta[caseCount - 7] ) / 7)
                        } else {
                            newLocation.casesDeltaSmooth.append(0)
                            newLocation.deathsDeltaSmooth.append(0)
                        }
                     }
                }
                let lastCase = newLocation.cases.count - 1
                newLocation.totalCases = newLocation.cases[lastCase]
                newLocation.deltaCases = newLocation.casesDelta[lastCase]
                newLocation.totalDeaths = newLocation.deaths[lastCase]
                newLocation.deltaDeaths = newLocation.deathsDelta[lastCase]
                locations.append(newLocation)
            }
        } else {
            print("WorldCsvModel:processFiles - confirmed and deaths file rows don't match")
        }
        
        return locations
    }
}

