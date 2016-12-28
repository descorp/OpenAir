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

/** This class mange all XML API requests to OpenAir **/
class OpenairAPIManager: NSObject {
    
    // MARK: private variables
    private var url: URL! = nil
    private var request: NSMutableURLRequest! = nil
    private var connection: NSURLConnection! = nil
    private var session = URLSession.shared

    var completionHandler: OpenairAPIManagerCompletionHandler! = nil
    
    var mutableData: NSMutableData  = NSMutableData()
    var currentElementName: String = ""
    
    var xmlParser: XMLParser! = nil

    func authenticateUser(company: String, userName: String, password: String, callback: @escaping OpenairAPIManagerCompletionHandler) {
        let requestPayload = "<?xml version='1.0' encoding='UTF-8' standalone='yes'?><request API_ver='1.0' client='test app' client_ver='1.1' namespace='\(nameSpace)' key='\(apiKey)'><Auth><Login><company>\(company)</company><user>\(userName)</user><password>\(password)</password></Login></Auth><Read type='User' method='all' limit='1'/></request>"
        print("requestPayload: \(requestPayload)")
        let requestPayloadData = requestPayload.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let requestPayloadData = requestPayloadData{
            sendRequest(path: netSuitServerBaseURL, requestPayload: requestPayloadData, httpMethod: "POST", callback: callback)
        }
    }
    
    func checkTimesheetExistsForDate(startingDateOfCurrentWeek: String, company: String, userName: String, password: String, callback: @escaping OpenairAPIManagerCompletionHandler) {
        let requestPayload = "<?xml version='1.0' encoding='UTF-8' standalone='yes'?><request API_ver='1.0' client='test app' client_ver='1.1' namespace='\(nameSpace)' key='\(apiKey)'><Auth><Login><company>\(company)</company><user>\(userName)</user><password>\(password)</password></Login></Auth><Read type='Timesheet' method='all' limit='1' filter='date-equal-to' field='starts'><Date><year>2016</year><month>12</month><day>25</day></Date></Read></request>"
        print("requestPayload: \(requestPayload)")
        let requestPayloadData = requestPayload.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let requestPayloadData = requestPayloadData{
            sendRequest(path: netSuitServerBaseURL, requestPayload: requestPayloadData, httpMethod: "POST", callback: callback)
        }
    }
    
    
/*
    func authenticateUser(company: String, userName: String, password: String, callback: @escaping OpenairAPIManagerCompletionHandler) {
        let requestPayload = "<?xml version='1.0' encoding='UTF-8' standalone='yes'?><request API_ver='1.0' client='test app' client_ver='1.1' namespace='\(nameSpace)' key='\(apiKey)'><Auth><Login><company>\(company)</company><user>\(userName)</user><password>\(password)</password></Login></Auth></request>"
        print("requestPayload: \(requestPayload)")
        let requestPayloadData = requestPayload.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let requestPayloadData = requestPayloadData{
            sendRequest(path: netSuitServerBaseURL, requestPayload: requestPayloadData, httpMethod: "POST", callback: callback)
        }
    }
 */
    
    func sendRequest(path: String, requestPayload: Data, httpMethod: String, callback: @escaping OpenairAPIManagerCompletionHandler) {
     
        url = URL(string: path)
        request = NSMutableURLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = requestPayload
        
        completionHandler = callback

        var shouldKeepRunning = true
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            print("Response: \(response)")
            print("data: \(data)")
            let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("Body: \(strData)")
            
            self.xmlParser = XMLParser(data: data!)
            self.xmlParser.delegate = self
            self.xmlParser.parse()
            self.xmlParser.shouldResolveExternalEntities = true
            
            shouldKeepRunning = false
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
        /*
        if elementName == "id" {
            // Success authentication
            if attributeDict["status"] == "0" {
                self.completionHandler(true, nil)
            }
        }
         */
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElementName == "id" {
            // Stop parser
            xmlParser.abortParsing()
            
            // Success authentication
            print("DEBUG: userid: \(string)")
            self.completionHandler(true, string)
        }
    }
}
