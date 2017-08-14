//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Xuelin Zhao on 2017/8/3.
//  Copyright © 2017年 zhaoxuelin. All rights reserved.
//

import Foundation

//Defined the function to a variable
func changeSign(operand : Double) -> Double{
    return -operand
}

struct CalculatorBrain{
    private var accumulator : Double?
    
    private enum Operation{
        case constant(Double)
        case unaryOperation((Double)->Double)
        case binaryOperation((Double,Double)->Double)
        case equals
    }
    
    private var operations:
        Dictionary<String,Operation>=[
            "π" : Operation.constant(Double.pi),//constant because the Double in the enum was defined
            "e" : Operation.constant(M_E),
            "±" : Operation.unaryOperation(changeSign),//the name of method could be used here because it was defined before
            "√" : Operation.unaryOperation(sqrt),
            "cos" : Operation.unaryOperation(cos),
            "+" : Operation.binaryOperation({$0+$1}),//closure
            "-" : Operation.binaryOperation({$0-$1}),
            "×" : Operation.binaryOperation({$0*$1}),
            "÷" : Operation.binaryOperation({$0/$1}),
            "=" : Operation.equals
            
    ]
    
    mutating func setOperand(_ operand:Double) {
        accumulator = operand
    }
    
    mutating func performOperation(_ symbol:String){
        if let operation = operations[symbol]{
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil{
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil{
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                if accumulator != nil && pendingBinaryOperation != nil{
                    accumulator = pendingBinaryOperation?.perform(with: accumulator!)
                    pendingBinaryOperation = nil
                }
            }
        }
    }
    
    private var pendingBinaryOperation : PendingBinaryOperation?
    
    private struct PendingBinaryOperation{
        let function: (Double, Double)-> Double
        let firstOperand:Double
        
        func perform(with secondOperand:Double)->Double{
            return function(firstOperand, secondOperand)
        }
        
    }
    
    var result:Double?{
        get{
            return accumulator
        }
    }
}
