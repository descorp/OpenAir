//
//  Openair.swift
//  Openair
//
//  Created by Sameh Mabrouk on 24/12/16.
//  Copyright © 2016 Sameh Mabrouk. All rights reserved.
//

import Foundation
import OpenAirSwift

class Openair {
    
    // XML API constants
    private static let namespace     = "default"
    private static let apiKey        = "MSC2kxYUFYkm7rJ8z50z"
    
    let consoleIO = ConsoleIO()
    let apiManager = OpenairAPIManager(for: namespace, with: apiKey)
    var calendarComponents: CalendarDateComponents? = nil
    var endDateCalendarComponents: CalendarDateComponents? = nil
    var index = 1
    
    func interactiveMode() {
        consoleIO.writeMessage("Welcome to OpenAir. This program enables you to submit your timesheets 🐣")
        var shouldQuit = false
        while !shouldQuit {
            consoleIO.writeMessage("📦  Type 'submit' to submit your timesheet for current week type 'q' to quit program.")
            let (option, value) = consoleIO.getOption(option: consoleIO.getInput())
            
            switch option {
            case .submit:
                consoleIO.writeMessage("📛  Type your company name:")
                let company = consoleIO.getInput()
                consoleIO.writeMessage("👶  Type your user name:")
                let userName = consoleIO.getInput()
                let password = consoleIO.getInput(inputType: .password)
                
                //1- Authenticate user
                self.consoleIO.writeMessage("👉  Authenticating user...")
                apiManager.authenticateUser(company: company, userName: userName, password: password, callback: { (success, result) in
                    self.consoleIO.writeMessage("✅  User Authenticated successfully")
                    
                    // Get start date of the current week
                    let startDateOfWeek = Date().startOfWeek
                    
                    // Get Year, Month and Day of start date of the current week
                    self.calendarComponents = startDateOfWeek?.calendarComponents
                    
                    let userId = result
                    
                    //2- Check if timesheet already exist or not
                    self.consoleIO.writeMessage("👉  Checking if timesheet exists...")
                    self.apiManager.checkTimesheetExistsForDate(year: (self.calendarComponents?.0)!, month: (self.calendarComponents?.1)!, day: (self.calendarComponents?.2)!, company: company, userName: userName, password: password, callback: { (success, result) in
                        if success {
                            self.consoleIO.writeMessage("Hey, Sorry timesheet existed you cannot create one for this week")
                        }
                        else {
                            self.consoleIO.writeMessage("✅  Done")

                            //self.consoleIO.writeMessage("Creating new timesheet...")
                            self.consoleIO.writeMessage("👉  Listing projects...")
                            
                            // Get end date of the current week
                            let endDateOfWeek = Date().endOfWeek
                            
                            // Get Year, Month and Day of end date of the current week
                            self.endDateCalendarComponents = endDateOfWeek?.calendarComponents
                            
                            //3- Get list of project names
                            self.apiManager.getProjects(company: company, userName: userName, password: password, callback: { (success, result) in
                                
                                if success {
                                    self.consoleIO.writeMessage("✅  Done")

                                    // print each project name to console
                                    let projects = result as? [Project]
                                    if let projects = projects {
                                        for (index, project) in projects.enumerated() {
                                            self.consoleIO.writeMessage(String(index) + "." + project.picklist_label, to: .projects)
                                        }
                                        
                                        self.consoleIO.writeMessage("👉  Now select project e.g. [0,1,2,33]...")
                                        let projectId = self.consoleIO.getInput()
                                        
                                        // check if input is number
                                        if self.IsNumber(input: projectId) {
                                            if let projectId = Int(projectId), projectId < projects.count {
                                                
                                                //4- get project task
                                                self.consoleIO.writeMessage("👉  Getting project tasks...")
                                                self.apiManager.getprojectTasks(projectId: projects[projectId].id, company: company, userName: userName, password: password, callback: { (success, result) in
                                                    
                                                    if success {
                                                        self.consoleIO.writeMessage("✅  Done")
                                                        // print each project task to console
                                                        let projectTasks = result as? [ProjectTask]
                                                        if let projectTasks = projectTasks {
                                                            for (index, projectTask) in projectTasks.enumerated() {
                                                                self.consoleIO.writeMessage(String(index) + "." + projectTask.name, to: .projectTasks)
                                                            }
                                                            
                                                            self.consoleIO.writeMessage("👉  Now select project task...")
                                                            let taskId = self.consoleIO.getInput()
                                                            
                                                            // check if input is number
                                                            if self.IsNumber(input: taskId) {
                                                                if let taskId = Int(taskId), taskId < projectTasks.count {
                                                                    
                                                                    // Ask user for working hours for every day per week
                                                                    self.consoleIO.writeMessage("👉  Now enter timesheet work hour per day...")
                                                                    
                                                                    //let taskId = self.consoleIO.getInput()
                                                                    let weekDaysWorkHours = self.getWorkHourForDay()
                                                                    
                                                                    self.consoleIO.writeMessage("🚀  creating timesheet...")
                                                                    
                                                                    //5- Add timesheet for current week
                                                                    self.apiManager.addTimesheet(startDateComponents: self.calendarComponents!, endDateComponents: self.endDateCalendarComponents!, userId: userId as! String, company: company, userName: userName, password: password, callback: { (success, result) in
                                                                        if success {
                                                                            self.consoleIO.writeMessage("✅  Timesheet created successfully")
                                                                            
                                                                            if let calendarComponents = self.calendarComponents {
                                                                                
                                                                                var currentDateComponents = DateComponents()
                                                                                currentDateComponents.year = calendarComponents.0
                                                                                currentDateComponents.month = calendarComponents.1
                                                                                currentDateComponents.day = calendarComponents.2
                                                                                
                                                                                let date =  Date.dateFromComponents(dateComponents: currentDateComponents)
                                                                                let newDate = date?.dateComponentsByAddingDays(days: self.index)
                                                                                let newcalendarComponents = newDate?.calendarComponents
                                                                                
                                                                                if let newcalendarComponents = newcalendarComponents {
                                                                                    
                                                                                    //6- Add timesheet tasks, e.g. work hour per day
                                                                                    self.addTaskToTimesheet(dateComponent: newcalendarComponents, weekDaysWorkHours: weekDaysWorkHours, timesheetId: result as! String, projectId: projects[projectId].id , projectTaskId: projectTasks[taskId].id, userId: userId as! String, company: company, userName: userName, password: password)
                                                                                }
                                                                            }
                                                                        }
                                                                        else {
                                                                            self.consoleIO.writeMessage("An error was encountered , Timesheet is not created 🙁")
                                                                        }
                                                                    })
                                                                }
                                                            }
                                                        }
                                                        
                                                    }
                                                })
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                else {
                                    self.consoleIO.writeMessage("An error was encountered, no existing projects 🙁")
                                }
                            })
                        }
                    })
                })
                
            case .quit:
                shouldQuit = true
            default:
                consoleIO.writeMessage("Unknown option \(value)", to: .error)
            }
        }
    }
    
    // MARK: Helper functions
    
    func IsNumber(input: String) -> Bool {
        return Int(input) != nil
    }
    
    func getWorkHourForDay()-> [Int] {
        var weekDaysWorkHours = [Int]()
        
        for index in 0...4 {
            self.consoleIO.writeMessage(DayOfWeek.fromNumber(number: index).description + ": ", to: .timesheetTasks)
            let workHour = Int(self.consoleIO.getInput())
            if workHour != nil {
                if let workHour = workHour {
                    weekDaysWorkHours.append(workHour)
                }
            }
            else {
                weekDaysWorkHours.append(0)
            }
        }
        return weekDaysWorkHours
    }
    
    func addTaskToTimesheet(dateComponent: CalendarDateComponents, weekDaysWorkHours: [Int], timesheetId: String, projectId: String, projectTaskId: String, userId: String, company: String, userName: String, password: String) {
        
        // add tasks to timesheet for 5 working days.
        apiManager.addTaskToTimesheet(dateComponents: dateComponent, hours: String(weekDaysWorkHours[index-1]), timesheetId: timesheetId, projectId: projectId, projectTaskId: projectTaskId, userId: userId, company: company, userName: userName, password: password) { (success, result) in
            if success {
                
                self.index = self.index + 1
                
                guard self.index < 6 else {
                    
                    // save and submit timesheet
                    print("Added 5 days tasks")
                    self.apiManager.submitTimesheet(company: company, userName: userName, password: password, timesheetId: timesheetId, callback: { (success, result) in
                        if success {
                            print("All done! 🎉 timesheet submitted, Enjoy your weekend! 🚀")
                        }
                        else {
                            print("An error was encountered, Cannot submit timesheet 🙁")
                        }
                    })
                    return
                }
                
                self.consoleIO.writeMessage("Task added to timesheet...")
                
                if let calendarComponents = self.calendarComponents {
                    var currentDateComponents = DateComponents()
                    currentDateComponents.year = calendarComponents.0
                    currentDateComponents.month = calendarComponents.1
                    currentDateComponents.day = calendarComponents.2
                    
                    let date =  Date.dateFromComponents(dateComponents: currentDateComponents)
                    
                    let date2 = date?.dateComponentsByAddingDays(days: self.index)
                    let newcalendarComponents = date2?.calendarComponents
                    
                    if let newcalendarComponents = newcalendarComponents {
                        
                        self.addTaskToTimesheet(dateComponent: newcalendarComponents, weekDaysWorkHours: weekDaysWorkHours, timesheetId: timesheetId, projectId: projectId, projectTaskId: projectTaskId, userId: userId, company: company, userName: userName, password: password)
                    }
                }
            }
        }
    }
}
