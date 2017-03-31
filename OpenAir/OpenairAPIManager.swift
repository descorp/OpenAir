//
//  OpenAirAPIManager.swift
//  OpenAir
//
//  Created by Sameh Mabrouk on 26/12/16.
//  Copyright © 2016 Sameh Mabrouk. All rights reserved.
//

import Foundation

// XML API constants
let netSuitServerBaseURL = "https://www.openair.com/api.pl"
let nameSpace     = "default"
let apiKey        = "MSC2kxYUFYkm7rJ8z50z"

typealias OpenairAPIManagerCompletionHandler = (_ success: Bool, _ result: Any?) -> ()

// enum for endpoints
enum Endpoint {
    case authUser
    case checkTimesheet
    case addTimeSheet
    case projects
    case projectTask
    case timesheetTask
    case submitTimesheet
}

/** This class mange all XML API requests to OpenAir **/
class OpenairAPIManager: NSObject {
    
    // MARK: private variables
    private var url: URL! = nil
    private var request: NSMutableURLRequest! = nil
    private var connection: NSURLConnection! = nil
    private var session = URLSession.shared
    
    var projects: [Project]?
    var projectName: String = ""
    var projectId: String = ""
    var tasks: [ProjectTask]?
    var projectTask: String = ""
    var projectTaskName: String = ""
    var projectTaskId: String = ""
    
    var consumedEndpoit = Endpoint.authUser
    var completionHandler: OpenairAPIManagerCompletionHandler! = nil
    var mutableData: NSMutableData  = NSMutableData()
    var currentElementName: String = ""
    var xmlParser: XMLParser! = nil
    
    func authenticateUser(company: String, userName: String, password: String, callback: @escaping OpenairAPIManagerCompletionHandler) {
        let requestPayload = "<?xml version='1.0' encoding='UTF-8' standalone='yes'?><request API_ver='1.0' client='test app' client_ver='1.1' namespace='\(nameSpace)' key='\(apiKey)'><Auth><Login><company>\(company)</company><user>\(userName)</user><password>\(password)</password></Login></Auth><Read type='User' method='all' limit='1'/></request>"
//        print("requestPayload: \(requestPayload)")
        let requestPayloadData = requestPayload.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let requestPayloadData = requestPayloadData{
            sendRequest(path: netSuitServerBaseURL, requestPayload: requestPayloadData, httpMethod: "POST", callback: callback)
        }
        
        consumedEndpoit = .authUser
    }
    
    func checkTimesheetExistsForDate(year: Int, month: Int, day: Int, company: String, userName: String, password: String, callback: @escaping OpenairAPIManagerCompletionHandler) {
        let requestPayload = "<?xml version='1.0' encoding='UTF-8' standalone='yes'?><request API_ver='1.0' client='test app' client_ver='1.1' namespace='\(nameSpace)' key='\(apiKey)'><Auth><Login><company>\(company)</company><user>\(userName)</user><password>\(password)</password></Login></Auth><Read type='Timesheet' method='all' limit='1' filter='date-equal-to' field='starts'><Date><year>\(year)</year><month>\(month)</month><day>\(day)</day></Date></Read></request>"
//        print("requestPayload: \(requestPayload)")
        let requestPayloadData = requestPayload.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let requestPayloadData = requestPayloadData {
            sendRequest(path: netSuitServerBaseURL, requestPayload: requestPayloadData, httpMethod: "POST", callback: callback)
        }
        
        consumedEndpoit = .checkTimesheet
    }
    
    func addTimesheet(startDateComponents: CalendarDateComponents, endDateComponents: CalendarDateComponents, userId: String, company: String, userName: String, password: String, callback: @escaping OpenairAPIManagerCompletionHandler) {
        
        let startDate = String(startDateComponents.1) + "/" + String(startDateComponents.2) + "/" + String(startDateComponents.0)
        let endDate = String(endDateComponents.1) + "/" + String(endDateComponents.2) + "/" + String(endDateComponents.0)
        
        let requestPayload = "<?xml version='1.0' encoding='UTF-8' standalone='yes'?><request API_ver='1.0' client='test app' client_ver='1.1' namespace='\(nameSpace)' key='\(apiKey)'><Auth><Login><company>\(company)</company><user>\(userName)</user><password>\(password)</password></Login></Auth><Add type='Timesheet'><Timesheet><name>\(startDate) to \(endDate)</name><userid>\(userId)</userid><starts><Date><month>\(startDateComponents.1)</month><day>\(startDateComponents.2)</day><year>\(startDateComponents.0)</year></Date></starts><ends><Date><hour/><minute/><timezone/><second/><month>\(endDateComponents.1)</month><day>\(endDateComponents.2)</day><year>\(endDateComponents.0)</year></Date></ends></Timesheet></Add></request>"
        
//        print("requestPayload: \(requestPayload)")
        let requestPayloadData = requestPayload.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let requestPayloadData = requestPayloadData {
            sendRequest(path: netSuitServerBaseURL, requestPayload: requestPayloadData, httpMethod: "POST", callback: callback)
        }
        
        consumedEndpoit = .addTimeSheet
    }
    
    func addTaskToTimesheet(dateComponents: CalendarDateComponents, hours: String, timesheetId: String, projectId: String, projectTaskId: String, userId: String, company: String, userName: String, password: String, callback: @escaping OpenairAPIManagerCompletionHandler) {
        
        
        let requestPayload = "<?xml version='1.0' encoding='UTF-8' standalone='yes'?><request API_ver='1.0' client='test app' client_ver='1.1' namespace='\(nameSpace)' key='\(apiKey)'><Auth><Login><company>\(company)</company><user>\(userName)</user><password>\(password)</password></Login></Auth><Add type='Task'><Task><date><Date><month>\((dateComponents.1))</month><day>\((dateComponents.2))</day><year>\((dateComponents.0))</year></Date></date><hours>\(hours)</hours><timesheetid>\(timesheetId)</timesheetid><userid>\(userId)</userid><projectid>\(projectId)</projectid><projecttaskid>\(projectTaskId)</projecttaskid></Task></Add></request>"
        
        print("addTaskToTimesheet requestPayload: \(requestPayload)")
        let requestPayloadData = requestPayload.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let requestPayloadData = requestPayloadData {
            sendRequest(path: netSuitServerBaseURL, requestPayload: requestPayloadData, httpMethod: "POST", callback: callback)
        }
        
        consumedEndpoit = .addTimeSheet
    }
    
    func getProjects(company: String, userName: String, password: String, callback: @escaping OpenairAPIManagerCompletionHandler) {
        
        projects = [Project]()
        
        let requestPayload = "<?xml version='1.0' encoding='UTF-8' standalone='yes'?><request API_ver='1.0' client='test app' client_ver='1.1' namespace='\(nameSpace)' key='\(apiKey)'><Auth><Login><company>\(company)</company><user>\(userName)</user><password>\(password)</password></Login></Auth><Read type='Project' method='all' limit='40'/></request>"
//        print("requestPayload: \(requestPayload)")
        let requestPayloadData = requestPayload.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let requestPayloadData = requestPayloadData {
            sendRequest(path: netSuitServerBaseURL, requestPayload: requestPayloadData, httpMethod: "POST", callback: callback)
        }
        consumedEndpoit = .projects
    }
    
    func getprojectTasks(projectId: String, company: String, userName: String, password: String, callback: @escaping OpenairAPIManagerCompletionHandler) {
        
        tasks = [ProjectTask]()
        
        let requestPayload = "<?xml version='1.0' encoding='UTF-8' standalone='yes'?><request API_ver='1.0' client='test app' client_ver='1.1' namespace='\(nameSpace)' key='\(apiKey)'><Auth><Login><company>\(company)</company><user>\(userName)</user><password>\(password)</password></Login></Auth><Read type='Projecttask' method='equal to' limit='10'><Projecttask><projectid>\(projectId)</projectid></Projecttask></Read></request>"
        let requestPayloadData = requestPayload.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let requestPayloadData = requestPayloadData {
            sendRequest(path: netSuitServerBaseURL, requestPayload: requestPayloadData, httpMethod: "POST", callback: callback)
        }
        consumedEndpoit = .projectTask
    }
    
    func submitTimesheet(company: String, userName: String, password: String, timesheetId: String, callback: @escaping OpenairAPIManagerCompletionHandler) {
        
        let requestPayload = "<?xml version='1.0' encoding='UTF-8' standalone='yes'?><request API_ver='1.0' client='test app' client_ver='1.1' namespace='\(nameSpace)' key='\(apiKey)'><Auth><Login><company>\(company)</company><user>\(userName)</user><password>\(password)</password></Login></Auth><Submit type='Timesheet'><Timesheet><id>\(timesheetId)</id></Timesheet></Submit></request>"
        let requestPayloadData = requestPayload.data(using: String.Encoding.utf8, allowLossyConversion: false)
        if let requestPayloadData = requestPayloadData {
            sendRequest(path: netSuitServerBaseURL, requestPayload: requestPayloadData, httpMethod: "POST", callback: callback)
        }
        consumedEndpoit = .submitTimesheet
    }
    
    func sendRequest(path: String, requestPayload: Data, httpMethod: String, callback: @escaping OpenairAPIManagerCompletionHandler) {
        
        url = URL(string: path)
        request = NSMutableURLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = requestPayload
        
        completionHandler = callback
        
        var shouldKeepRunning = true
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            //print("Response: \(response)")
            //print("data: \(data)")
            if let data = data {
            
                //let strData = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
//                print("Body: \(strData)")
                
                self.xmlParser = XMLParser(data: data)
                self.xmlParser.delegate = self
                self.xmlParser.parse()
                self.xmlParser.shouldResolveExternalEntities = true
                
                shouldKeepRunning = false
            }
            
        }
        task.resume()
        
        // To cause the command line program not to exit because of loading data Async from different thread other than Main Thread, use RunLoop
        // http://stackoverflow.com/questions/38505552/urlsession-in-command-line-tool-control-multiple-tasks-and-convert-html-to-text
        // http://stackoverflow.com/questions/25126471/cfrunloop-in-swift-command-line-program
        // Waiting for tasks to complete
        let theRL = RunLoop.current
        while shouldKeepRunning && theRL.run(mode: .defaultRunLoopMode, before: .distantFuture) { }
    }
}

// NSURLConnectionDelegate

extension OpenairAPIManager: NSURLConnectionDataDelegate {
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        mutableData.length = 0
    }
    
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        mutableData.append(data)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        xmlParser = XMLParser(data: mutableData as Data)
        xmlParser.delegate = self
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
    }
}

// NSXMLParserDelegate

extension OpenairAPIManager: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElementName = elementName
        
//        print("didStartElement \(elementName)")
        /*
         // Result: <Read status = "0"></Read >
         switch consumedEndpoit {
         case .checkTimesheet:
         if currentElementName == "Read" {
         if attributeDict["status"] == "0" {
         
         print("DEBUG: Timesheet is not existed")
         
         // timesheet is not existed
         self.completionHandler(false, nil)
         }
         }
         default: break
         }
         */
        
        /*
         if elementName == "id" {
         // Success authentication
         if attributeDict["status"] == "0" {
         self.completionHandler(true, nil)
         }
         }
         */
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        print("didEndElement \(elementName)")
        
        switch consumedEndpoit {
        case .checkTimesheet:
            if elementName == "response" {
//                print("DEBUG: Timesheet is not existed")
                // timesheet is not existed
                self.completionHandler(false, nil)
            }
        case .addTimeSheet:
            if elementName == "response" {
//                print("DEBUG: Timesheet is not created")
                // timesheet is not created
                self.completionHandler(false, nil)
            }
        case .projects:
            if elementName == "response" {
                if let projects = projects {
                    if projects.count > 0 {
//                        print("DEBUG: Found list of projects")
                        
                        self.completionHandler(true, projects)
                    }
                    else {
//                        print("DEBUG: cannot find list of projects")
                        self.completionHandler(false, nil)
                    }
                }
            }
            else {
                if elementName == "id" {
                    // found project name
                    let project = Project(id: projectId, picklist_label: projectName)
                    projects?.append(project)
                    
                    projectName = ""
                }
            }
        case .projectTask:
            if elementName == "response" {
                if let tasks = tasks {
                    if tasks.count > 0 {
//                        print("DEBUG: Found list of project tasks")
                        
                        self.completionHandler(true, tasks)
                    }
                    else {
//                        print("DEBUG: cannot find list of project tasks")
                        self.completionHandler(false, nil)
                    }
                }
            }
            else {
                if elementName == "name" {
                    // found project task
                    let projectTask = ProjectTask(id: projectTaskId, name: projectTaskName)
                    tasks?.append(projectTask)
                    
                    projectTaskName = ""
                }
            }
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch consumedEndpoit {
        case .authUser:
            if currentElementName == "id" {
                // Stop parser, because there is multiple id and we want the first id in the respose xml
                xmlParser.abortParsing()
                
                // Success authentication
//                print("DEBUG: userid: \(string)")
                self.completionHandler(true, string)
            }
        case .checkTimesheet:
            if currentElementName == "status" {
                // Stop parser
                xmlParser.abortParsing()
                // timesheet existed
//                print("DEBUG: timesheet status : \(string)")
                self.completionHandler(true, string)
            }
        case .addTimeSheet:
            if currentElementName == "id" {
                // Stop parser
                xmlParser.abortParsing()
                // timesheet created
//                print("DEBUG: timesheet created : \(string)")
                self.completionHandler(true, string)
            }
        case .projects:
            if currentElementName == "picklist_label" {
                projectName = projectName + string
//                print("DEBUG: project name : \(projectName)")
            }
            else if (currentElementName == "id") {
                projectId = string
            }
        case .projectTask:
            if currentElementName == "name" {
                projectTaskName = projectTaskName + string
            }
            else if (currentElementName == "id") {
                projectTaskId = string
            }
            
        case .timesheetTask:
            if currentElementName == "id" {
                projectTask = string
//                print("DEBUG: timesheet task id : \(projectTask)")
            }
        case .submitTimesheet:
            if currentElementName == "id" {
                xmlParser.abortParsing()
                self.completionHandler(true, string)
            }
        }
    }
}
