//
//  AppDelegate.swift
//  Calculator
//
//  Created by Jan Andersson on 2014-08-05.
//  Copyright (c) 2014 Jan Andersson. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
                            
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var txtResult: NSTextField!
    var result: Double = 0
    var decimals: Bool = false
    var decimalPos: Double = 1
    var operand: Operand?
    var argument: Double = 0
    var start: Bool = true

    enum Operand {
        case Add
        case Sub
        case Mul
        case Div
    }

    func output(value: Double) {
        txtResult.stringValue = String(format: "%.15g", value)
    }
    
    func updateResult() {
        output(operand == nil ? result : argument)
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
       updateResult()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication!) -> Bool {
        return true
    }
    
    func append(value: Double, to: Double) -> Double {
        var result: Double = to
        let diff = to >= 0 ? value : -value
        if decimals {
            result += diff / pow(10.0, Double(decimalPos))
            decimalPos += 1
        } else {
            result = result * 10 + diff
        }
        return result
    }

    func calc(arg1: Double, withOp op: Operand, andArg arg2: Double) -> Double {
        switch op {
        case .Add: return arg1 + arg2
        case .Sub: return arg1 - arg2
        case .Div: return arg1 / arg2
        case .Mul: return arg1 * arg2
        }
    }
    
    @IBAction func btnNumber(sender: NSButton) {
        let input = Double(sender.title.toInt()!)
        if start {
            result = input
            start = false
        } else {
            if operand == nil {
                result = append(input, to: result)
            } else {
                argument = append(input, to: argument)
            }
        }
        updateResult()
    }
    
    @IBAction func btnClear(sender: AnyObject) {
        result = 0
        argument = 0
        decimalPos = 1
        decimals = false
        operand = nil
        updateResult()
    }
    @IBAction func btnNegate(sender: AnyObject) {
        if operand == nil {
            result = -result
        } else {
            argument = -argument
        }
        updateResult()
    }
    @IBAction func btnDecimals(sender: AnyObject) {
        decimals = true
    }
    @IBAction func btnOperand(sender: NSButton) {
        if operand != nil {
            result = calc(result, withOp: operand!, andArg: argument)
            output(result)
        }
        decimalPos = 1
        decimals = false
        argument = 0
        start = false
        if sender.title == "+" {
            operand = .Add
        } else if sender.title == "-" {
            operand = .Sub
        } else if sender.title == "*" {
            operand = .Mul
        } else if sender.title == "/" {
            operand = .Div
        } else {
            operand = nil
            argument = 0
            start = true
        }
    }
    @IBAction func btnPercent(sender: AnyObject) {
        if operand == nil {
            result = result/100
        } else {
            argument = argument/100
        }
        updateResult()
    }
    
}

