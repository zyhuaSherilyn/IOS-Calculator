//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Sherilyn Hua on 2017-05-23.
//  Copyright © 2017 Sherilyn Hua. All rights reserved.
//

import Foundation

func changeSign(operand: Double) -> Double {
    return -operand
}

struct CalculatorBrain {
    
    private var accumulator: Double? //no accumulated result in the beginning
    
    private enum Operation { // a mixed type for the operations dictionary
        case constant(Double)
        case unaryOperation((Double) -> Double)
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation(changeSign)
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            }
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
