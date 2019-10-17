//
//  APIServiceTests.swift
//  MVVMDemoTests
//
//  Created by Jason Chen on 2019/10/17.
//  Copyright © 2019 Jason Chen. All rights reserved.
//

import XCTest
@testable import MVVMDemo

class APIServiceTests: XCTestCase {
    
    var sut: APIService?
    
    override func setUp() {
        super.setUp()
        sut = APIService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_fetch_popular_photos() {

        // Given A apiservice
        let sut = self.sut!

        // When fetch popular photo
        let expect = XCTestExpectation(description: "callback")

        sut.fetchPopularPhoto(complete: { (success, photos, error) in
            expect.fulfill()
            XCTAssertEqual( photos.count, 20)
            for photo in photos {
                XCTAssertNotNil(photo.id)
            }
            
        })

        wait(for: [expect], timeout: 3.1)
    }
    
}
