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
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "±": Operation.UnaryOperation({-$0}),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "×": Operation.BinaryOperation({$0 * $1}),
        "÷": Operation.BinaryOperation({$0 / $1}),
        "+": Operation.BinaryOperation({$0 + $1}),
        "-": Operation.BinaryOperation({$0 - $1}),
        "=": Operation.Equals,
    ]
    
    private enum Operation {
        case BinaryOperation((Double, Double)->Double)
        case Constant(Double)
        case Equals //((Double, Double)->Double)
        case UnaryOperation((Double)->Double)
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Constant(let value):
                accumulator = value
            case .Equals:
                executePendingBinaryOperation()
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
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
}
