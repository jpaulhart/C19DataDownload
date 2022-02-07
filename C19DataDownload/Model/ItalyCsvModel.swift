//
//  ItalyCsvModel.swift
//
//  Created by Paul Hart on 2022-02-02.
//

import Foundation
import SwiftUI
import SwiftCSV

class ItalyItems {
    var italyItems: [ItalyItem] = []
    var italyLocations: [String: Location] = [:]
    var italyLoadTimestamp: Date = Date.now
    var italyUrlCsv = "https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-regioni/dpc-covid19-ita-regioni.csv"
    
    init() {
        loadData()
    }
    
    func loadData() {
        loadCsvData()
        convertCsvData()
    }
    
    func loadCsvData () {
        print("     ItalyCsvModel:loadCsvData - Loading Italy COVID data.")
        print()
        if let url = URL(string: italyUrlCsv) {
            do {
                let csvFile: CSV = try CSV(url: url)
                let rows = csvFile.enumeratedRows

                var lineNo = 0
                italyItems.removeAll()
                for fields in rows {
                    lineNo += 1
                    if fields.count == 30 {
                        let item: ItalyItem = ItalyItem()
                        item.data                                   = fields[0]
                        item.stato                                  = fields[1]
                        item.codice_regione                         = fields[2]
                        item.denominazione_regione                  = fields[3]
                        item.lat                                    = fields[4]
                        item.long                                   = fields[5]
                        item.ricoverati_con_sintomi                 = fields[6]
                        item.terapia_intensiva                      = fields[7]
                        item.totale_ospedalizzati                   = fields[8]
                        item.isolamento_domiciliare                 = fields[9]
                        item.totale_positivi                        = fields[10]
                        item.variazione_totale_positivi             = fields[11]
                        item.nuovi_positivi                         = fields[12]
                        item.dimessi_guariti                        = fields[13]
                        item.deceduti                               = fields[14]
                        item.casi_da_sospetto_diagnostico           = fields[15] == "" ? "0" : fields[15]
                        item.casi_da_screening                      = fields[16] == "" ? "0" : fields[16]
                        item.totale_casi                            = fields[17]
                        item.tamponi                                = fields[18]
                        item.casi_testati                           = fields[19] == "" ? "0" : fields[19]
                        item.note                                   = fields[20] == "" ? "0" : fields[20]
                        item.ingressi_terapia_intensiva             = fields[21] == "" ? "0" : fields[21]
                        item.note_test                              = fields[22] == "" ? "0" : fields[22]
                        item.note_casi                              = fields[23] == "" ? "0" : fields[23]
                        item.totale_positivi_test_molecolare        = fields[24] == "" ? "0" : fields[24]
                        item.totale_positivi_test_antigenico_rapido = fields[25] == "" ? "0" : fields[25]
                        item.tamponi_test_molecolare                = fields[26] == "" ? "0" : fields[26]
                        item.tamponi_test_antigenico_rapido         = fields[27] == "" ? "0" : fields[27]
                        item.codice_nuts_1                          = fields[28] == "" ? "0" : fields[28]
                        item.codice_nuts_2                          = fields[29] == "" ? "0" : fields[29]

                        italyItems.append(item)
                        
                    } else {
                        print("     ItalyCsvModel:loadCsvData - Line \(lineNo) has fields error")
                    }
                }
                
            } catch {
                print("     ItalyCsvModel:loadCsvData - File read error")
            }
        } else {
            print("     ItalyCsvModel:loadCsvData - Invalid URL: \(italyUrlCsv)")
        }
        italyLoadTimestamp = Date.now
        print("     ItalyCsvModel:loadCsvData - Loaded Italy COVID data.")
    }
    
    func convertCsvData() {
        
        italyLocations = [
            "Abruzzo": Location(),
            "Basilicata": Location(),
            "Calabria": Location(),
            "Campania": Location(),
            "Emilia-Romagna": Location(),
            "Friuli Venezia Giulia": Location(),
            "Lazio": Location(),
            "Liguria": Location(),
            "Lombardia": Location(),
            "Marche": Location(),
            "Molise": Location(),
            "P.A. Bolzano": Location(),
            "P.A. Trento": Location(),
            "Piemonte": Location(),
            "Puglia": Location(),
            "Sardegna": Location(),
            "Sicilia": Location(),
            "Toscana": Location(),
            "Umbria": Location(),
            "Valle d'Aosta": Location(),
            "Veneto": Location()
        ]
        
        for item in italyItems {
            // Caption for the location
            self.italyLocations[item.denominazione_regione]!.country = "Italy"
            // Subcation to show for the location
            self.italyLocations[item.denominazione_regione]!.region = item.denominazione_regione
            // Total number of cases for that location
            self.italyLocations[item.denominazione_regione]!.totalCases = Int(item.totale_positivi) ?? 0
            // Number of new cases in the last day for that location
            self.italyLocations[item.denominazione_regione]!.deltaCases = Int(item.variazione_totale_positivi) ?? 0
            // Total number of cases for that location
            self.italyLocations[item.denominazione_regione]!.totalDeaths = Int(item.totale_positivi) ?? 0
            // Number of new cases in the last day for that location
            self.italyLocations[item.denominazione_regione]!.deltaDeaths = Int(item.variazione_totale_positivi) ?? 0
            // Latitude, Longitude
            self.italyLocations[item.denominazione_regione]!.latitude = item.lat
            self.italyLocations[item.denominazione_regione]!.longitude = item.long

            // Array of total cases since the beginning
            self.italyLocations[item.denominazione_regione]!.cases.append(Int(item.totale_positivi) ?? 0)
            // Array of change of cases per day
            self.italyLocations[item.denominazione_regione]!.casesDelta.append(Int(item.nuovi_positivi) ?? 0)
            // Smoothed Array of change of cases per day
            self.italyLocations[item.denominazione_regione]!.casesDeltaSmooth.append(0)

            // Array of total deaths since the beginning
            self.italyLocations[item.denominazione_regione]!.deaths.append(Int(item.deceduti) ?? 0)
            // Array of changes in deaths since the beginning
            self.italyLocations[item.denominazione_regione]!.deathsDelta.append(0)
            // Smoothed Array of changes in deaths since the beginning
            self.italyLocations[item.denominazione_regione]!.deathsDeltaSmooth.append(0)

            // Array of total hospitalizations since the beginning
            self.italyLocations[item.denominazione_regione]!.hospitalizations.append(Int(item.totale_ospedalizzati) ?? 0)
            // Array of change of hospitalizations per day
            self.italyLocations[item.denominazione_regione]!.hospitalizationsDelta.append(Int(item.ricoverati_con_sintomi) ?? 0)
            // Smoothed Array of change of hospitalizations per day
            self.italyLocations[item.denominazione_regione]!.hospitalizationsDeltaSmooth.append(0)

        }

        let keys = italyLocations.keys
        for key in keys {
            let maxIndex = italyLocations[key]!.deaths.count - 1
            for index in 1...maxIndex {
                italyLocations[key]!.deathsDelta[index] = italyLocations[key]!.deaths[index] - italyLocations[key]!.deaths[index-1]
                if index >= 7 {
                    italyLocations[key]!.deathsDeltaSmooth[index] = (italyLocations[key]!.deathsDelta[index - 7] +
                                                                     italyLocations[key]!.deathsDelta[index - 5] +
                                                                     italyLocations[key]!.deathsDelta[index - 4] +
                                                                     italyLocations[key]!.deathsDelta[index - 3] +
                                                                     italyLocations[key]!.deathsDelta[index - 2] +
                                                                     italyLocations[key]!.deathsDelta[index - 1] +
                                                                     italyLocations[key]!.deathsDelta[index]) / 7
                    italyLocations[key]!.casesDeltaSmooth[index]  = (italyLocations[key]!.casesDelta[index - 7] +
                                                                     italyLocations[key]!.casesDelta[index - 6] +
                                                                     italyLocations[key]!.casesDelta[index - 5] +
                                                                     italyLocations[key]!.casesDelta[index - 4] +
                                                                     italyLocations[key]!.casesDelta[index - 3] +
                                                                     italyLocations[key]!.casesDelta[index - 2] +
                                                                     italyLocations[key]!.casesDelta[index - 1] +
                                                                     italyLocations[key]!.casesDelta[index]) / 7
                }
            }
            italyLocations[key]!.totalCases = (italyLocations[key]!.cases[maxIndex])
            italyLocations[key]!.deltaCases = (italyLocations[key]!.casesDelta[maxIndex])
            italyLocations[key]!.totalDeaths = (italyLocations[key]!.deaths[maxIndex])
            italyLocations[key]!.deltaDeaths = (italyLocations[key]!.deathsDelta[maxIndex])
        }
    }
}

class ItalyItem {
    
    init() { }
    
    var data: String = ""                                     // Date of notification
    var stato: String = ""                                    // Country of reference
    var codice_regione: String = ""                           // Code of the Region (ISTAT 2019)
    var denominazione_regione: String = ""                    // Name of the Region
    var lat: String = ""                                      // Latitude
    var long: String = ""                                     // Longitude
    var ricoverati_con_sintomi: String = ""                   // Hospitalised patients with symptoms
    var terapia_intensiva: String = ""                        // Intensive Care
    var totale_ospedalizzati: String = ""                     // Total hospitalised patients
    var isolamento_domiciliare: String = ""                   // Home confinement
    var totale_positivi: String = ""                          // Total amount of current positive cases (Hospitalised patients + Home confinement)
    var variazione_totale_positivi: String = ""               // News amount of current positive cases (totale_positivi current day - totale_positivi previous day)
    var nuovi_positivi: String = ""                           // News amount of current positive cases (totale_casi current day - totale_casi previous day)
    var dimessi_guariti: String = ""                          // Recovered
    var deceduti: String = ""                                 // Death
    var casi_da_sospetto_diagnostico: String = ""             // Positive cases emerged from clinical activity No longer populated
    var casi_da_screening: String = ""                        // Positive cases emerging from surveys and tests, planned at national or regional level No longer populated
    var totale_casi: String = ""                              // Total amount of positive cases
    var tamponi: String = ""                                  // Tests performed (processed with molecular tests)
    var casi_testati: String = ""                             // Total number of people tested
    var note: String = ""                                     // Notes
    var ingressi_terapia_intensiva: String = ""               // Daily admissions to intensive care
    var note_test: String = ""                                // Notes on the tests carried out
    var note_casi: String = ""                                // Notes on the cases tested
    var totale_positivi_test_molecolare: String = ""          // total positive molecular test
    var totale_positivi_test_antigenico_rapido: String = ""   // total positive rapid antigen test
    var tamponi_test_molecolare: String = ""                  // molecular test swabs
    var tamponi_test_antigenico_rapido: String = ""           // swabs rapid antigen test
    var codice_nuts_1: String = ""                            // nuts code 1
    var codice_nuts_2: String = ""                            // nuts code 2
}
