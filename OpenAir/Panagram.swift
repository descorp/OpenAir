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
    
    let apiManager = OpenairAPIManager()
    var calendarComponents: CalendarDateComponents? = nil
    var index = 1
    
    func interactiveMode() {
        consoleIO.writeMessage("Welcome to OpenAir. This program enables you to submit your timesheets 🐣")
        var shouldQuit = false
        while !shouldQuit {
            consoleIO.writeMessage("📦  Type 'submit' to submit your timesheet for current week type 'q' to quit.")
            let (option, value) = consoleIO.getOption(option: consoleIO.getInput())
            
            switch option {
            case .submit:
                consoleIO.writeMessage("📛  Type your company name:")
                let company = consoleIO.getInput()
                consoleIO.writeMessage("👶  Type your user name:")
                let userName = consoleIO.getInput()
                consoleIO.writeMessage("🔑  Type your password:")
                let password = consoleIO.getInput()
                
                //5: call OpenairAPIManager
                apiManager.authenticateUser(company: company, userName: userName, password: password, callback: { (success, result) in
                    self.consoleIO.writeMessage("User Authenticated successfully")
                    
                    // Start submit timeeheet
                    
                    // Get start date of the current week
                    let startDateOfWeek = Date().startOfWeek
                    
                    // Get Year, Month and Day of start date of the current week
                    self.calendarComponents = startDateOfWeek?.calendarComponents
                    
//                    print("First day of the week: \(startDateOfWeek?.calendarComponents)")
//                    print("End day of the week: \(Date().endOfWeek)")
                    
                    let retrievedUerId = result
                    
                    //1- Check if timesheet already exist or not
                    self.apiManager.checkTimesheetExistsForDate(year: (self.calendarComponents?.0)!, month: (self.calendarComponents?.1)!, day: (self.calendarComponents?.2)!, company: company, userName: userName, password: password, callback: { (success, result) in
                        if success {
                            self.consoleIO.writeMessage("Hey, Sorry timesheet existed you cannot create one for this week")
                        }
                        else {
                            self.consoleIO.writeMessage("Creating new timesheet...")
                            self.consoleIO.writeMessage("Listing projects...")
                            
                            // Get end date of the current week
                            let endDateOfWeek = Date().endOfWeek
                            
                            // Get Year, Month and Day of end date of the current week
                            let endDateCalendarComponents = endDateOfWeek?.calendarComponents
                            
                            //2- Get list of project names
                            self.apiManager.getProjects(company: company, userName: userName, password: password, callback: { (success, result) in
                                
                                if success {
                                    
                                    // print each project name to console
                                    let projects = result as? [Project]
                                    if let projects = projects {
                                        for (index, project) in projects.enumerated() {
                                            self.consoleIO.writeMessage(String(index) + "." + project.picklist_label, to: .projects)
                                        }
                                        
                                        
                                        self.consoleIO.writeMessage("Now select project...")
                                        let projectId = self.consoleIO.getInput()
                                        
                                        // check if input is number
                                        if self.IsNumber(input: projectId) {
                                            if let projectId = Int(projectId), projectId < projects.count {
                                                
                                                //3- get project task
                                                self.apiManager.getprojectTasks(projectId: projects[projectId].id, company: company, userName: userName, password: password, callback: { (success, result) in
                                                    
                                                    if success {
                                                        
                                                        // print each project task to console
                                                        let projectTasks = result as? [ProjectTask]
                                                        if let projectTasks = projectTasks {
                                                            for (index, projectTask) in projectTasks.enumerated() {
                                                                self.consoleIO.writeMessage(String(index) + "." + projectTask.name, to: .projectTasks)
                                                            }
                                                            
                                                            self.consoleIO.writeMessage("Now select project task...")
                                                            let taskId = self.consoleIO.getInput()
                                                            // check if input is number
                                                            if self.IsNumber(input: taskId) {
                                                                if let taskId = Int(taskId), taskId < projectTasks.count {
                                                                    
                                                                    // Ask user for working hours for every day per week
                                                                    self.consoleIO.writeMessage("Now enter timesheet work hour per day...")
                                                                    
                                                                    //self.consoleIO.writeMessage("Monday: ")
                                                                    //let taskId = self.consoleIO.getInput()
                                                                    let weekDaysWorkHours = self.getWorkHourForDay()
                                                                    
                                                                    self.consoleIO.writeMessage("🚀  Now creating timesheet...")
                                                                    
                                                                    //4- Add timesheet for current week
                                                                    self.apiManager.addTimesheet(startDateComponents: self.calendarComponents!, endDateComponents: endDateCalendarComponents!, userId: retrievedUerId as! String, company: company, userName: userName, password: password, callback: { (success, result) in
                                                                        if success {
                                                                            self.consoleIO.writeMessage("YES, Timesheet created successfully")
                                                                            
                                                                            if let calendarComponents = self.calendarComponents {
                                                                            
                                                                                var currentDateComponents = DateComponents()
                                                                                currentDateComponents.year = calendarComponents.0
                                                                                currentDateComponents.month = calendarComponents.1
                                                                                currentDateComponents.day = calendarComponents.2
                                                                                
                                                                                let date =  Date.dateFromComponents(dateComponents: currentDateComponents)
                                                                                
                                                                                let date2 = date?.dateComponentsByAddingDays(days: self.index)
                                                                                print("Adding 1 day to sunday: \(date2)")
                                                                                let newcalendarComponents = date2?.calendarComponents
                                                                                print("newcalendarComponents \(newcalendarComponents)")
                                                                                
                                                                                
                                                                                
                                                                                if let newcalendarComponents = newcalendarComponents {
                                                                                    
                                                                                    //5- Add timesheet tasks, e.g. work hour per day
                                                                                    self.addTaskToTimesheet(dateComponent: newcalendarComponents, weekDaysWorkHours: weekDaysWorkHours, timesheetId: result as! String, projectId: projects[projectId].id , projectTaskId: projectTasks[taskId].id, userId: retrievedUerId as! String, company: company, userName: userName, password: password)
                                                                                    
                                                                                }
                                                                                
                                                                            }
                                                                           
                                                                            
                                                                        }
                                                                        else {
                                                                            self.consoleIO.writeMessage("Error, Timesheet is not created")
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
                                    self.consoleIO.writeMessage("Sorry, no existing projects")
                                }
                                
                                
                                
                            })
                            
                            
                            
                        }
                    })
                    
                })
            case .quit:
                shouldQuit = true
            default:
                //6
                consoleIO.writeMessage("Unknown option \(value)", to: .error)
            }
        }
    }
    
    // MARK: Helper functions
    
    func IsNumber(input: String) -> Bool {
        let num = Int(input)
        guard (num != nil) else {
            return false
        }
        return true
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
                
                guard self.index < 6 else { return }
                
                self.consoleIO.writeMessage("Task added to timesheet...")
                
                if let calendarComponents = self.calendarComponents {
                    var currentDateComponents = DateComponents()
                    currentDateComponents.year = calendarComponents.0
                    currentDateComponents.month = calendarComponents.1
                    currentDateComponents.day = calendarComponents.2
                    
                    let date =  Date.dateFromComponents(dateComponents: currentDateComponents)
                    
                    let date2 = date?.dateComponentsByAddingDays(days: self.index)
                    print("Adding 1 day to sunday: \(date2)")
                    let newcalendarComponents = date2?.calendarComponents
                    print("newcalendarComponents \(newcalendarComponents)")
                    
                    if let newcalendarComponents = newcalendarComponents {
                        
                        self.addTaskToTimesheet(dateComponent: newcalendarComponents, weekDaysWorkHours: weekDaysWorkHours, timesheetId: timesheetId, projectId: projectId, projectTaskId: projectTaskId, userId: userId, company: company, userName: userName, password: password)
                    }
                }
            }
        }
    }
}
