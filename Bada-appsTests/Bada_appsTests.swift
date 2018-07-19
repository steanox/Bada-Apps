//
//  Bada_appsTests.swift
//  Bada-appsTests
//
//  Created by octavianus on 10/07/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import XCTest
import Firebase
@testable import Bada_apps

class Bada_appsTests: XCTestCase {
    
    var att: Attendance?
    var testUserID = "12345678"
    
    var performStatusInDatabase: AttendanceType?
    var performStatusExpectation: XCTestExpectation? = nil
    
    var clockStatusInDatabase: ClockStatus?
    //var clockStatusExpectation: XCTestExpectation? = nil
    
    var performCount: XCTestExpectation? = nil
    var count = 0
    
    override func setUp() {
        super.setUp()
        
        att = Attendance()
        att?.delegate = self
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    

    func testConfigureAndPerformCheckIn(){
        FirebaseApp.configure()
        performCount = expectation(description: "Perform Check in and out")
        
        att?.performCheckIn(forUID: self.testUserID, notes: "UNIT TESTING \((att?.dateID)!) - \((att?.time)!)")
        
        wait(for: [performCount!], timeout: 10)
    }
    
    func testPerformCheckOut(){
        att?.performCheckOut(forUID: self.testUserID, notes: "UNIT TESTING \((att?.dateID)!) - \((att?.time)!)")
    }
    
    
    
    func testStatusInDatabase(){
        performStatusExpectation = expectation(description: "Perform Status")
        att?.checkStatusInDatabase(forUID: self.testUserID, onResponse: { (attendance) in
            self.performStatusExpectation?.fulfill()
            
            //Make sure attendance response not error
            XCTAssertNotNil(attendance,"attendance status return error")
            
            //Make sure the expectations fulfil
            XCTAssertEqual(self.performStatusExpectation?.expectedFulfillmentCount, 1)
            
            //Make sure the perform status not error
            XCTAssertNotEqual(AttendanceType.error, attendance)
        })
        
        wait(for: [performStatusExpectation!], timeout: 10)
        
        
    }
}

extension Bada_appsTests: AttendanceDelegate{
    func attendanceOnProgress() {
        XCTAssertTrue(true)
    }

    func attendanceFailed(error: String) {
        print("failed on check In \(error)")
        
        XCTAssertTrue(false)
    }

    func attendanceRemoveProgress() {
        XCTAssertTrue(true)
    }

    func attendanceSuccess() {
        
        print("success on \(self.testRun?.test.name) - \(self.performCount?.expectationDescription) - \(self.performCount?.expectedFulfillmentCount)")
        self.performCount?.fulfill()
        XCTAssertTrue(true)
        XCTAssertTrue((self.performCount?.expectedFulfillmentCount)! > 0)
    }
}
