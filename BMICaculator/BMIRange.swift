//
//  BMIRange.swift
//  BMICaculator
//
//  Created by dopamint on 5/22/24.
//


enum BMIRange: String {

    case underweight = "저체중"
    case normal = "정상"
    case overweight = "과체중"
    case obesity = "비만"
    
    var range: ClosedRange<Float> {
        switch self {
        case .underweight:
            return 0...18.5
        case .normal:
            return 18.5...22.9
        case .overweight:
            return 23.0...24.9
        case .obesity:
            return 25...99999
        }
    }
}

