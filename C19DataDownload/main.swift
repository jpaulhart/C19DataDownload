//
//  main.swift
//  C19DataDownload
//
//  Created by Paul Hart on 2022-02-02.
//

import Foundation

print("Starting Italy Data loading: \(Date.now)")
let italyData = ItalyItems()
print("Ending Italy Data loading: \(Date.now)")

print("Starting World Data loading: \(Date.now)")
let worldData = WorldItems()
print("Ending World Data loading: \(Date.now)")
