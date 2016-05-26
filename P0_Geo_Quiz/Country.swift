//
//  Country.swift
//  P0_Geo_Quiz
//
//  Created by Andy Xu on 16/5/25.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation

struct Country {
    let code: String
    let name: String
    let flagImageFile: String
    let speechText: String
    
    init(name: String, code: String, speechText: String, flagImageFile: String) {
        self.code = code
        self.name = name
        self.flagImageFile = flagImageFile
        self.speechText = speechText
    }
}