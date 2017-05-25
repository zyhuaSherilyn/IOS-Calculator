//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Sherilyn Hua on 2017-05-23.
//  Copyright © 2017 Sherilyn Hua. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double? //no accumulated result in the beginning
    
    mutating func performOperation(_ symbol: String) {
        switch symbol {
        case "π":
            accumulator = Double.pi
        case "√":
            if let operand = accumulator {
                accumulator = sqrt(operand)
            }
        default:
            break
        }
        
    }
    
    // structs copy on write
    // have to indicate that the struct is changed by add "mutating"
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get { // read-only property
            return accumulator
        }
    }
    
}
