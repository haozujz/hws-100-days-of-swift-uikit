//
//  Person.swift
//  project10
//
//  Created by Joseph Zhu on 4/11/2022.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
