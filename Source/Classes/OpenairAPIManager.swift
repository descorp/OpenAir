//
//  OpenAirAPIManager.swift
//  OpenAir
//
//  Created by Sameh Mabrouk on 26/12/16.
//  Copyright © 2016 Sameh Mabrouk. All rights reserved.
//

import Foundation

public typealias OpenairAPIManagerCompletionHandler = (_ success: Bool, _ result: Any?) -> ()

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

/** This class manage all XML API requests to OpenAir **/
public class OpenairAPIManager: NSObject {
    
    // MARK: private variables
    private var url: URL! = nil
    private var request: NSMutableURLRequest! = nil
    private var connection: NSURLConnection! = nil
    private var session = URLSession.shared
    
    // XML API constants
    let netSuitServerBaseURL: String
    let builder: RequestBuilder
    
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
    
    /**
     
     Initiate new instance of manager to access OpenAir API
     
     The namespace and APIkey parameters are used to verify that
     the request is coming from a valid partner that has permission to use OpenAir API
     
     - Parameters:
     - apiKey: secret APIKey of your organisation.
     - nameSpace: namespace of your organisation. By default value is *default*
     - address: Url of your OpenAir server. By default OpenAir XML API address
     
     - Note: Contact the OpenAir Support Department or your account representative to request API access.
     **/
    public init(to request: RequestConfiguration, byUrl address: String = "https://www.openair.com/api.pl") {
        self.builder = RequestBuilder(for: request)
        self.netSuitServerBaseURL = address
    }
    
    public func authenticateUser(company: String, userName: String, password: String, callback: @escaping OpenairAPIManagerCompletionHandler) {
        let login = Login(login: userName, password: password, company: company)
        let xml = builder.create(.auth(login: login),
                                     .readSimple(dataType: "User", attributes: [.method(.all),
                                                                                .limit(1)]))
        
        if let payload = xml.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            sendRequest(path: netSuitServerBaseURL, requestPayload: payload, httpMethod: "POST", callback: callback)
        }
        consumedEndpoit = .authUser
    }
    
    public func checkTimesheetExistsForDate(year: Int, month: Int, day: Int, company: String, userName: String, password: String, callback: @escaping OpenairAPIManagerCompletionHandler) {
        
        let login = Login(login: userName, password: password, company: company)
        let date = OpenAirDate(year: year, month: month, day: day)
        
        let xml = builder.create(.auth(login: login),
                                     .read(dataType: "Timesheet",
                                           body: [date],
                                           attributes: [.method(.all),
                                                        .limit(1),
                                                        .filter("date-equal-to"),
                                                        .filter("starts")]))
        
        if let payload = xml.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            sendRequest(path: netSuitServerBaseURL, requestPayload: payload, httpMethod: "POST", callback: callback)
        }
        
        consumedEndpoit = .checkTimesheet
    }
    
    public func addTimesheet(startDate: Date, endDate: Date, userId: String, company: String, userName: String, password: String, callback: @escaping OpenairAPIManagerCompletionHandler) {
        
        let login = Login(login: userName, password: password, company: company)
        let timesheet = Timesheet(starts: startDate, ends: endDate, userid: userId)
        
        let xml = builder.create(.auth(login: login), .add(timesheet))
        
        if let payload = xml.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            sendRequest(path: netSuitServerBaseURL, requestPayload: payload, httpMethod: "POST", callback: callback)
        }
        
        consumedEndpoit = .addTimeSheet
    }
    
    public func addTaskToTimesheet(date: Date, hours: Int, timesheetId: String, projectId: String, projectTaskId: String, userId: String, company: String, userName: String, password: String, callback: @escaping OpenairAPIManagerCompletionHandler) {
        
        let login = Login(login: userName, password: password, company: company)
        let task = Task(date: date, hours: hours, timesheetid: timesheetId, userid: userId, projectid: projectId, projecttaskid: projectTaskId)
        let xml = builder.create(.auth(login: login), .add(task))
        
        if let payload = xml.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            sendRequest(path: netSuitServerBaseURL, requestPayload: payload, httpMethod: "POST", callback: callback)
        }
        
        consumedEndpoit = .addTimeSheet
    }
    
    public func getProjects(company: String, userName: String, password: String, callback: @escaping OpenairAPIManagerCompletionHandler) {
        
        let login = Login(login: userName, password: password, company: company)
        
        let xml = builder.create(.auth(login: login),
                                     .readSimple(dataType: "Project", attributes: [.method(.all), .limit(40)]))
        
        if let payload = xml.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            sendRequest(path: netSuitServerBaseURL, requestPayload: payload, httpMethod: "POST", callback: callback)
        }
        consumedEndpoit = .projects
    }
    
    public func getprojectTasks(projectId: String, company: String, userName: String, password: String, callback: @escaping OpenairAPIManagerCompletionHandler) {
        
        let login = Login(login: userName, password: password, company: company)
        let projectTask = ProjectTask(projectId: projectId)
        
        let xml = builder.create(.auth(login: login),
                                     .readObject(data: projectTask, attributes: [.method(.equalTo ), .limit(40)]))
        
        if let payload = xml.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            sendRequest(path: netSuitServerBaseURL, requestPayload: payload, httpMethod: "POST", callback: callback)
        }
        consumedEndpoit = .projectTask
    }
    
    public func submitTimesheet(company: String, userName: String, password: String, timesheetId: String, callback: @escaping OpenairAPIManagerCompletionHandler) {
        
        let login = Login(login: userName, password: password, company: company)
        let timesheet = Timesheet(id: timesheetId)
        
        let xml = builder.create(.auth(login: login), .submit(timesheet, approval: nil))
        
        if let payload = xml.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            sendRequest(path: netSuitServerBaseURL, requestPayload: payload, httpMethod: "POST", callback: callback)
        }
        consumedEndpoit = .submitTimesheet
    }
    
    public func sendRequest(path: String, requestPayload: Data, httpMethod: String, callback: @escaping OpenairAPIManagerCompletionHandler) {
        
        url = URL(string: path)
        request = NSMutableURLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = requestPayload
        
        completionHandler = callback
        
        var shouldKeepRunning = true
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let data = data {
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

    public func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        mutableData.length = 0
    }

    public func connection(_ connection: NSURLConnection, didReceive data: Data) {
        mutableData.append(data)
    }

    public func connectionDidFinishLoading(_ connection: NSURLConnection) {
        xmlParser = XMLParser(data: mutableData as Data)
        xmlParser.delegate = self
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
    }
}

// NSXMLParserDelegate

extension OpenairAPIManager: XMLParserDelegate {

    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElementName = elementName
    }

    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        switch consumedEndpoit {
        case .checkTimesheet:
            if elementName == "response" {
                // timesheet is not existed
                self.completionHandler(false, nil)
            }
        case .addTimeSheet:
            if elementName == "response" {
                // timesheet is not created
                self.completionHandler(false, nil)
            }
        case .projects:
            if elementName == "response" {
                if let projects = projects {
                    if projects.count > 0 {
                        self.completionHandler(true, projects)
                    }
                    else {
                        self.completionHandler(false, nil)
                    }
                }
            }
            else {
                if elementName == "id" {
                    // found project name
                    let project = Project(id: projectId, label: projectName)
                    projects?.append(project)

                    projectName = ""
                }
            }
        case .projectTask:
            if elementName == "response" {
                if let tasks = tasks {
                    if tasks.count > 0 {
                        self.completionHandler(true, tasks)
                    }
                    else {
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

    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch consumedEndpoit {
        case .authUser:
            if currentElementName == "id" {
                // Stop parser, because there is multiple id and we want the first id in the respose xml
                xmlParser.abortParsing()

                // Success authentication
                self.completionHandler(true, string)
            }
        case .checkTimesheet:
            if currentElementName == "status" {
                // Stop parser
                xmlParser.abortParsing()
                // timesheet existed
                self.completionHandler(true, string)
            }
        case .addTimeSheet:
            if currentElementName == "id" {
                // Stop parser
                xmlParser.abortParsing()
                // timesheet created
                self.completionHandler(true, string)
            }
        case .projects:
            if currentElementName == "picklist_label" {
                projectName = projectName + string
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
            }
        case .submitTimesheet:
            if currentElementName == "id" {
                xmlParser.abortParsing()
                self.completionHandler(true, string)
            }
        }
    }
}
