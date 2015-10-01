//
//  PeakRecognition.swift
//  FeatureExtraction
//
//  Created by Aidan Gomez on 2015-09-28.
//  Copyright © 2015 Venture Media. All rights reserved.
//

import Foundation

import Surge

protocol PeakRecognition {
    func process(input: [Point]) -> [Point]
}

struct Peak {
    var location: Int
    var height: Double
}
