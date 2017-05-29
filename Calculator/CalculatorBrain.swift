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
    
    private enum Operation { // a mixed type for the operations dictionary
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "AC" : Operation.clear,
        "±" : Operation.unaryOperation({ -$0 }),
        "×" : Operation.binaryOperation({ $0 * $1 }),
        "-" : Operation.binaryOperation(({ $0 - $1 })),
        "÷" : Operation.binaryOperation(({ $0 / $1 })),
        "+" : Operation.binaryOperation(({ $0 + $1 })),
        "=" : Operation.equals
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
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            case .clear:
                clearNumber()
            }
            
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation? // optional because we're not in the middle of pending binary operation
    
    // place to store data in a binary operation situation
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    // if this function is called, perform the pending binary operation with the "perform" function in PendingBinaryOperation
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private mutating func clearNumber() {
        accumulator = 0
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
