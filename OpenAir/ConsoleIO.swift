//
//  ConsoleIO.swift
//  Panagram
//
//  Created by Sameh Mabrouk on 24/12/16.
//  Copyright © 2016 Sameh Mabrouk. All rights reserved.
//

import Foundation

enum OutputType {
    case error
    case standard
}

enum OptionType: String {
    case palindrome = "p"
    case submit = "submit"
    case help = "h"
    case quit = "q"
    case unknown
    
    init(value: String) {
        switch value {
        case "submit": self = .submit
        case "p": self = .palindrome
        case "h": self = .help
        case "q": self = .quit
        default: self = .unknown
        }
    }
}

class ConsoleIO {
    class func printUsage() {
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        
        print("usage:")
        print("\(executableName) -a string1 string2")
        print("or")
        print("\(executableName) -p string")
        print("or")
        print("\(executableName) -h to show usage information")
        print("Type \(executableName) without an option to enter interactive mode.")
    }
    
    func getOption(option: String) -> (option:OptionType, value: String) {
        return (OptionType(value: option), option)
    }
    
    /* default values for to parameter is "standard". */
    func writeMessage(_ message: String, to: OutputType = .standard) {
        switch to {
        case .standard:
            //the sequence \u{001B}[;m used in the standard case resets the terminal color back to the default.
            print("\u{001B}[;m\(message)")
        case .error:
            //in this case you’ll print error messages in red (\u{001B}[0;31m).
            fputs("\u{001B}[0;31m\(message)\n", stderr)
        }
    }
    
    func getInput() -> String {
        
        // 1
        let keyboard = FileHandle.standardInput
        
        // 2
        let inputData = keyboard.availableData
        
        // 3
        let strData = String(data: inputData, encoding: String.Encoding.utf8)!
        
        // 4
        return strData.trimmingCharacters(in: CharacterSet.newlines)
    }
}
