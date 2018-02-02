// https://github.com/Quick/Quick

import Foundation
import Quick
import Nimble

#if os(iOS)
    @testable import OpenAirSwift_iOS
#else
    @testable import OpenAirSwift_Mac
#endif


class RequestBuilderCanAddTaskToTimesheetsTestsSpec: QuickSpec {

    override func spec() {
        describe("Request builder tests") {
            
            let apiKey = "apiKey"
            let namespace = "namespace"
            let company = "company"
            let userName = "userName"
            let password = "password"
            let client = "tests app"
            let client_ver = "0.1.0"
            
            let request = RequestConfiguration(key: apiKey, namespace: namespace, client: client, client_ver: client_ver)
            let requestBuilder = RequestBuilder(for: request)
            
            it("can create request to Add Task to the Timesheet ") {
                
                let date = Date()
                let hours = 2
                let timesheetId = "timesheetId"
                let userId = "userId"
                let projectId = "projectId"
                let projectTaskId = "projectTaskId"
                
                let login = Login(login: userName, password: password, company: company)
                let task = Task(date: date, hours: hours, timesheetid: timesheetId, userid: userId, projectid: projectId, projecttaskid: projectTaskId)
                let request = requestBuilder.create(.auth(login: login), .add(task))
                
                let actual =
                """
                <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
                <request API_ver="1.0" client="\(client)" client_ver="\(client_ver)" namespace="\(namespace)" key="\(apiKey)">
                    <Auth>
                        <Login>
                            <user>\(userName)</user>
                            <password>\(password)</password>
                            <company>\(company)</company>
                        </Login>
                    </Auth>
                    <Add type="Task">
                        <Task>
                            <date>
                                <Date>
                                    <year>\(date.year)</year>
                                    <month>\(date.month)</month>
                                    <day>\(date.day)</day>
                                </Date>
                            </date>
                            <hours>\(hours)</hours>
                            <timesheetid>\(timesheetId)</timesheetid>
                            <userid>\(userId)</userid>
                            <projectid>\(projectId)</projectid>
                            <projecttaskid>\(projectTaskId)</projecttaskid>
                        </Task>
                    </Add>
                </request>
                """
                
                expect(request).toNot(beNil())
                expect(request).to(equal(actual.minifiedXml))
            }
        }
    }
}
