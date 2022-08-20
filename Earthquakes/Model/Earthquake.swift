//
//  Earthquake.swift
//  Earthquakes
//
//  Created by Jindrich Kocman on 10.08.2022.
//

import Foundation
import SwiftUI

struct Earthquake: Hashable, Identifiable {
    
    var id: String{time}
    
    let mag: String // (e.g. 2.2)
    
    let place: String // (e.g. 22km ESE of Anza, CA)
   
    let timeAgo: String // (e.g. 1 hour ago)
    
    let time: String // (e.g. 8/18/2022, 1:12 PM)
    
    let color: Color // Color of the font displaying the earthquake magnitude
    
    let updated: String
    
}
