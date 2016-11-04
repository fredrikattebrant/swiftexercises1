//
//  ViewController.swift
//  Calculator
//
//  Created by Fredrik Attebrant on 2016-10-31.
//  Copyright © 2016 Fredrik Attebrant. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    private var userTypedComma = false
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        switch digit {
        case ",":
            if userTypedComma {
                // only allow this once
                return
            }
            userTypedComma = true
        default:
            break
        }
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = displayValue
            displayValue = textCurrentlyInDisplay + digit
        } else {
            if userTypedComma {
                displayValue = "0."
            } else {
                displayValue = digit
            }
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue: String {
        get {
            return display.text!
        }
        set {
            display.text = newValue
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: Double(displayValue)!)
        }
        userIsInTheMiddleOfTyping = false
        userTypedComma = false
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
        }
        displayValue = String(brain.result)
    }
    
    @IBAction func reset(_ sender: UIButton) {
        brain.clear()
        userIsInTheMiddleOfTyping = false
        userTypedComma = false
        displayValue = "0"
    }
}
