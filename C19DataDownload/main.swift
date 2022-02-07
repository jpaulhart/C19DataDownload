//
//  main.swift
//  C19DataDownload
//
//  Created by Paul Hart on 2022-02-02.
//

import Foundation

let inputArgs = CommandLine.arguments

if inputArgs.count == 2 {
    var isDir: ObjCBool = true
    let locationJsonPath = inputArgs[1]

    if FileManager.default.fileExists(atPath: locationJsonPath, isDirectory: &isDir) {
        
        print("Starting Italy Data loading: \(Date.now)")
        let italyItems = ItalyItems()
        print("Ending Italy Data loading: \(Date.now)")

        print("Starting World Data loading: \(Date.now)")
        let worldItems = WorldItems()
        print("Ending World Data loading: \(Date.now)")

        print("Writing JSON data: \(Date.now)")
        writeJsonFiles(italyItems: italyItems, worldItems: worldItems, jsonDirectory: locationJsonPath)
        print("Wrote JSON data: \(Date.now)")

    } else {
        print("ERROR: Directory doen't exist: \(locationJsonPath)")
    }
} else {
    print("ERROR: Invalid number of command line parameters: \(inputArgs)")
}
