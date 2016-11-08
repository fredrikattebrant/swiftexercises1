//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Fredrik Attebrant on 2016-11-01.
//  Copyright © 2016 Fredrik Attebrant. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
        description = String(operand)
        print("setOperand: \(operand)")
    }
    
    func clear() {
        accumulator = 0.0
        pending = nil
        sequence = ""
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "±": Operation.UnaryOperation({-$0}),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "sin": Operation.UnaryOperation(sin),
        "tan": Operation.UnaryOperation(tan),
        "×": Operation.BinaryOperation({$0 * $1}),
        "÷": Operation.BinaryOperation({$0 / $1}),
        "+": Operation.BinaryOperation({$0 + $1}),
        "-": Operation.BinaryOperation({$0 - $1}),
        "xʸ": Operation.BinaryOperation({pow($0, $1)}),
        "=": Operation.Equals,
        ]
    
    private enum Operation {
        case BinaryOperation((Double, Double)->Double)
        case Constant(Double)
        case Equals //((Double, Double)->Double)
        case UnaryOperation((Double)->Double)
    }
    
    func performOperation(symbol: String) {
        print("performOperation: \(symbol)")
        //description += String(accumulator)
        if let operation = operations[symbol] {
            switch operation {
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                description = symbol
            case .Constant(let value):
                accumulator = value
                description = symbol
            case .Equals:
                executePendingBinaryOperation()
                description += "="
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
                description = symbol + "(\(accumulator))"
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        return accumulator
    }
    

    private var sequence = ""
    
    var description: String {
        get {
            return sequence
        }
        set {
            if isPartialResult {
                sequence += newValue
            } else {
                sequence = newValue
            }
            print("Sequence: " + sequence)
        }
    }
    
    var isPartialResult: Bool {
        return pending != nil
    }
}
