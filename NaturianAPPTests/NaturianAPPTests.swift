//
//  NaturianAPPTests.swift
//  NaturianAPPTests
//
//  Created by Jordan Wu on 2022/7/20.
//

import XCTest
@testable import NaturianAPP

class NaturianAPPTests: XCTestCase {
    var vc: TransferSeedVC!

    override func setUpWithError() throws {
        super.setUp()
        vc = TransferSeedVC()
    }
    
    func testTextFieldDidEndEditing() {
//        vc.userModels?.seedValue = 100
        let p = vc.seedRemainValue(originSeed: 100, transferSeed: 50)
        XCTAssert( p == 50 )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
        // Put the code you want to measure the time of here.
        }
    }

}
