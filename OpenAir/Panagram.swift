//
//  Panagram.swift
//  Panagram
//
//  Created by Sameh Mabrouk on 24/12/16.
//  Copyright © 2016 Sameh Mabrouk. All rights reserved.
//

import Foundation

class Panagram {
    let consoleIO = ConsoleIO()
    
    func staticMode() {
        //        ConsoleIO.printUsage()
        //1
        let argCount = CommandLine.argc
        //2
        let argument = CommandLine.arguments[1]
        //3
        let (option, value) = consoleIO.getOption(option: argument.substring(from: argument.characters.index(argument.startIndex, offsetBy: 1)))
        //4
        //        print("Argument count: \(argCount) Option: \(option) value: \(value)")
        
        
        //1
        switch option {
        case .submit:
            if argCount != 4 {
                if argCount > 4 {
                    consoleIO.writeMessage("Too many arguments for option \(option.rawValue)", to: .error)
                } else {
                    consoleIO.writeMessage("too few arguments for option \(option.rawValue)", to: .error)
                }
                ConsoleIO.printUsage()
            } else {
                let first = CommandLine.arguments[2]
                let second = CommandLine.arguments[3]
                
                if first.isAnagramOfString(s: second) {
                    consoleIO.writeMessage("\(second) is an anagram of \(first)")
                } else {
                    consoleIO.writeMessage("\(second) is not an anagram of \(first)")
                }
            }
        case .palindrome:
            if argCount != 3 {
                if argCount > 3 {
                    consoleIO.writeMessage("Too many arguments for option \(option.rawValue)", to: .error)
                } else {
                    consoleIO.writeMessage("too few arguments for option \(option.rawValue)", to: .error)
                }
            } else {
                let s = CommandLine.arguments[2]
                let isPalindrome = s.isPalindrome()
                consoleIO.writeMessage("\(s) is \(isPalindrome ? "" : "not ")a palindrome")
            }
        case .help:
            ConsoleIO.printUsage()
        case .unknown, .quit:
            consoleIO.writeMessage("Unkonwn option \(value)", to: .error)
            ConsoleIO.printUsage()
        }
    }
    
    func interactiveMode() {
        //1
        consoleIO.writeMessage("Welcome to OpenAir. This program enables you to submit your timesheets.")
        //2
        var shouldQuit = false
        while !shouldQuit {
            //3
            consoleIO.writeMessage("Type 'submit' to submit your timesheet for current week type 'q' to quit.")
            let (option, value) = consoleIO.getOption(option: consoleIO.getInput())
            
            switch option {
            case .submit:
                //4
                consoleIO.writeMessage("Type your company name:")
                let company = consoleIO.getInput()
                consoleIO.writeMessage("Type your user name:")
                let userName = consoleIO.getInput()
                consoleIO.writeMessage("Type your password:")
                let password = consoleIO.getInput()
                
                //5: call OpenairAPIManager
                let apiManager = OpenairAPIManager()
                apiManager.authenticateUser(company: company, userName: userName, password: password, callback: { (success, result) in
                    self.consoleIO.writeMessage("User Authenticated successfully")
                    
                    // Start submit timeeheet 
                    
                })
                
            case .palindrome:
                consoleIO.writeMessage("Type a word or sentence:")
                let s = consoleIO.getInput()
                let isPalindrome = s.isPalindrome()
                consoleIO.writeMessage("\(s) is \(isPalindrome ? "" : "not ")a palindrome")
            case .quit:
                shouldQuit = true
            default:
                //6
                consoleIO.writeMessage("Unknown option \(value)", to: .error)
            }
        }
    }
}
