//
//  ConsoleIO.swift
//  Openair
//
//  Created by Sameh Mabrouk on 24/12/16.
//  Copyright © 2016 Sameh Mabrouk. All rights reserved.
//

import Foundation

enum InputType {
    case text
    case password
}

enum OutputType {
    case error
    case standard
    case timesheetTasks
    case projects
    case projectTasks
}

enum OptionType: String {
    case submit = "submit"
    case help = "h"
    case quit = "q"
    case unknown
    
    init(value: String) {
        switch value {
        case "submit": self = .submit
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
    
    static func getOption(option: String) -> (option:OptionType, value: String) {
        return (OptionType(value: option), option)
    }
    
    static func writeMessage(_ message: String, to: OutputType = .standard) {
        switch to {
        case .standard:
            //the sequence \u{001B}[;m used in the standard case resets the terminal color back to the default.
            print("\u{001B}[;m\(message)")
        case .timesheetTasks:
            fputs("\u{001B}[0;33m\(message)\n", stderr)
        case .projects:
            fputs("\u{001B}[0;35m\(message)\n", stderr)
        case .projectTasks:
            fputs("\u{001B}[0;36m\(message)\n", stderr)
        case .error:
            fputs("\u{001B}[0;31m\(message)\n", stderr)
        }
    }
    
    static func getInput(inputType: InputType = .text) -> String {
        if inputType == .text {
            let keyboard = FileHandle.standardInput
            let inputData = keyboard.availableData
            let strData = String(data: inputData, encoding: String.Encoding.utf8)!
            return strData.trimmingCharacters(in: CharacterSet.newlines)
        }
        else {
           let newStr = String.init(cString: (UnsafePointer<CChar>(getpass("🔑  Type your password: "))))
            return newStr
        }
    }
}
