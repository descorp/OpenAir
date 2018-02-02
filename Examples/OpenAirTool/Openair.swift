//
//  Openair.swift
//  Openair
//
//  Created by Sameh Mabrouk on 24/12/16.
//  Copyright © 2016 Sameh Mabrouk. All rights reserved.
//

import Foundation

let apiKey     = "MSC2kxYUFYkm7rJ8z50z"
let apiManager = OpenairAPIManager(to: RequestConfiguration(key: apiKey))

class State {
    static var login: Login?
    static var index = 0
    static var userId: String?
    static var timesheetId: String?
    static var selectedProject: Project?
    static var selectedTask: ProjectTask?
    
    static var projects: [Project]?
    static var tasks = [Project: [ProjectTask]]()
}

class Openair {
    
    func interactiveMode() {
        ConsoleIO.writeMessage("Welcome to OpenAir. This program enables you to submit your timesheets 🐣")
        
        var shouldQuit = false
        while !shouldQuit {
            ConsoleIO.writeMessage("📦  Type 'submit' to submit your timesheet for current week type 'q' to quit program.")
            let (option, value) = ConsoleIO.getOption(option: ConsoleIO.getInput())
            
            switch option {
            case .submit:
                if State.login == nil {
                    StateMachine.goto(.getCredentials)
                } else {
                    StateMachine.goto(.checkTimesheet)
                }
            case .quit:
                shouldQuit = true
            default:
                ConsoleIO.writeMessage("Unknown option \(value)", to: .error)
            }
        }
    }
    
    // MARK: Helper functions
    
    static func IsNumber(input: String) -> Bool {
        return Int(input) != nil
    }
    
    static func getNumberImput(message: String, min: Int = 0, max: Int = Int.max) -> Int {
        var isValid = false
        var value = 0
        
        // check if input is number
        while !isValid {
            ConsoleIO.writeMessage(message)
            let projectIdInput = ConsoleIO.getInput()
            if IsNumber(input: projectIdInput), let id = Int(projectIdInput), id <= max, id >= min {
                isValid = true
                value = id - 1
            }
        }
        
        return value
    }
    
    enum StateMachine {
        case getCredentials
        case auth
        case checkTimesheet
        case createTimesheet
        case getProjects
        case selectProject
        case getTasks
        case selectTask
        case addday
        case submit
        
        static func goto(_ state: StateMachine) {
            switch state {
            case .getCredentials:
                ConsoleIO.writeMessage("📛  Type your company name:")
                let company = ConsoleIO.getInput()
                ConsoleIO.writeMessage("👶  Type your user name:")
                let userName = ConsoleIO.getInput()
                let password = ConsoleIO.getInput(inputType: .password)
                
                State.login = Login(login: userName, password: password, company: company)
                goto(.auth)
            case .auth:
                ConsoleIO.writeMessage("👉  Authenticating user...")
                apiManager.authenticateUser(login: State.login!) { (success, result) in
                    guard success, let userId = result as? String else {
                        ConsoleIO.writeMessage("🔐  User Authenticated unsuccessfully")
                        State.login = nil
                        goto(.getCredentials)
                        return
                    }
                    
                    State.userId = userId
                    ConsoleIO.writeMessage("✅  User Authenticated successfully")
                }
            case .checkTimesheet:
                ConsoleIO.writeMessage("🔍  Checking if timesheet exists...")
                apiManager.checkTimesheetExistsForDate(date: Date().startOfWeek(), login: State.login!) { (success, result) in
                    if success {
                        ConsoleIO.writeMessage("⏱   Hey, looks like your timesheet for this week is already submited! Well done!")
                        return
                    }
                    
                    goto(.createTimesheet)
                }
            case .createTimesheet:
                ConsoleIO.writeMessage("🚀   creating timesheet...")
                let timesheet = Timesheet(starts: Date().startOfWeek(), ends: Date().endOfWeek(), userid: State.userId!)
                apiManager.addTimesheet(timesheet: timesheet, login: State.login!) { (success, result) in
                    guard success, let timesheetId = result as? String else {
                        ConsoleIO.writeMessage("🙁   An error was encountered, not able to create new timesheet")
                        return
                    }
                    
                    ConsoleIO.writeMessage("✅   Timesheet created successfully")
                    State.timesheetId = timesheetId
                    goto(.selectProject)
                }
            case .getProjects:
                ConsoleIO.writeMessage("👉   Getting projects...")
                apiManager.getProjects(login: State.login!) { (success, result) in
                    guard success, let projects = result as? [Project] else {
                        ConsoleIO.writeMessage("🙁   An error was encountered, no existing projects")
                        return
                    }
                    
                    ConsoleIO.writeMessage("✅  Projects fetched successfully")
                    State.projects = projects
                    goto(.selectProject)
                }
            case .selectProject:
                guard let projects = State.projects else {
                    goto(.getProjects)
                    return
                }
                
                ConsoleIO.writeMessage("👉   Listing projects...")
                for (index, projectLabel) in projects.flatMap({ $0.picklist_label }).enumerated() {
                    ConsoleIO.writeMessage("\(String(index)). \(projectLabel)", to: .projects)
                }
                
                let message = "👉   Now select project e.g. select a number from 1 to \(projects.count)"
                let projectIndex = getNumberImput(message: message, max: projects.count)
                State.selectedProject = projects[projectIndex]
                
                goto(.selectTask)
            case .getTasks:
                ConsoleIO.writeMessage("👉   Getting project tasks...")
                apiManager.getprojectTasks(projectId: State.selectedProject!.id, login: State.login!) { (success, result) in
                    guard success, let projectTasks = result as? [ProjectTask] else {
                        ConsoleIO.writeMessage("🙁   An error was encountered, not able to fetch tasks")
                        return
                    }
                    
                    ConsoleIO.writeMessage("✅   Tasks fetched successfully")
                    State.tasks[State.selectedProject!] = projectTasks
                    goto(.selectTask)
                }
            case .selectTask:
                guard let projectTasks = State.tasks[State.selectedProject!] else {
                    goto(.getTasks)
                    return
                }
                
                ConsoleIO.writeMessage("👉   Listing project tasks...")
                // print each project task to console
                for (index, projectTaskName) in projectTasks.flatMap({ $0.name }).enumerated() {
                    ConsoleIO.writeMessage("\(String(index)). \(projectTaskName)", to: .projectTasks)
                }
                
                let message = "👉   Now select project task e.g. select a number from 1 to \(projectTasks.count)"
                let taskIndex = getNumberImput(message: message, max: projectTasks.count)
                
                State.selectedTask = projectTasks[taskIndex]
                goto(.addday)
            case .addday:
                ConsoleIO.writeMessage("👉   Now enter number of hour (between 0 and 12) or anything else to select another project")
                ConsoleIO.writeMessage("\(DayOfWeek.at(number: State.index).name): ", to: .timesheetTasks)
                
                let hoursInput = ConsoleIO.getInput()
                guard IsNumber(input: hoursInput), let hours = Int(hoursInput), hours <= 12, hours >= 1 else {
                    goto(.selectProject)
                    return
                }
                
                let date = Date().startOfWeek().add(days: State.index)
                let task = Task(date: date,
                                hours: hours,
                                timesheetid: State.timesheetId!,
                                userid: State.userId!,
                                projectid: State.selectedProject!.id,
                                projecttaskid: State.selectedTask!.id!)
                
                apiManager.addTaskToTimesheet(task: task, login: State.login!) { (success, result) in
                    guard success else {
                        print("🙁   An error was encountered, cannot add task to timesheet")
                        return
                    }
                    
                    State.index += 1
                    
                    if State.index < 4 {
                        goto(.addday)
                    }
                    goto(.submit)
                }
            case .submit:
                apiManager.submitTimesheet(login: State.login!, timesheetId: State.timesheetId!) { (success, result) in
                    if success {
                        print("🎉   All done! Timesheet submitted, Enjoy your weekend! 🚀")
                        return
                    }
                    
                    print("🙁   An error was encountered, cannot submit timesheet")
                }
            }
        }
    }
}

