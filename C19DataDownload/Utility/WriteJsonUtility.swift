//
//  WriteJsonUtility.swift
//  C19DataDownload
//
//  Created by Paul Hart on 2022-02-05.
//

import Foundation

func writeJsonFiles(italyItems: ItalyItems, worldItems: WorldItems, jsonDirectory: String) {
    print("     writeJson - Writing JSON data to \(jsonDirectory)")

    let keys = italyItems.italyLocations.keys
    for key in keys {
        let location = italyItems.italyLocations[key]
        try! writeJsonFile(location: location!, jsonDirectory: jsonDirectory)
    }

    for location in worldItems.locations {
        try! writeJsonFile(location: location, jsonDirectory: jsonDirectory)
    }
    print("     writeJson - Wrote JSON data to \(jsonDirectory)")
}

func writeJsonFile(location: Location, jsonDirectory: String) throws {
    var fileName: String = ""
    var displayName: String = ""
    if location.region == "" {
        fileName = "\(location.country).json"
        displayName = "\(location.country)"
    } else {
        fileName = "\(location.country) - \(location.region).json"
        displayName = "\(location.country) - \(location.region)"
    }
    location.fileName = fileName
    location.displayName = displayName

    let encodedData = try JSONEncoder().encode(location)
    let jsonString = String(data: encodedData, encoding: .utf8)

    let directoryUrl = URL(string: "file://\(jsonDirectory)")!
    let fileUrl = directoryUrl.appendingPathComponent(location.fileName)
    
    do {
        try jsonString?.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
    } catch {
        // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
    }
    print("     writeJson - \(fileUrl)")
}
