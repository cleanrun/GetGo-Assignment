//
//  WebserviceTests.swift
//  RickMorty-AssignmentTests
//
//  Created by cleanmac on 20/02/23.
//

import XCTest
@testable import RickMorty_Assignment

final class WebserviceTests: XCTestCase {
    
    private let webservice = Webservice()
    
    func testSuccess() async throws {
        let result = try await webservice.request(endpoint: .Characters, responseType: APIResponse<Character>.self)
        
        XCTAssertNotNil(result)
    }
    
    func testPageSuccess() async throws {
        let result = try await webservice.request(endpoint: .Characters, page: 2, responseType: APIResponse<Character>.self)
        
        XCTAssertNotNil(result)
    }
    
    func testPageError() async throws {
        let maximumPage = try await webservice.request(endpoint: .Characters, responseType: APIResponse<Character>.self).info.pages
        
        let result = try? await webservice.request(endpoint: .Characters, page: maximumPage, responseType: APIResponse<Character>.self)
        
        XCTAssertNil(result)
    }
    
    func testCastError() async throws {
        //let result = try? await webservice.request(endpoint: .Characters, responseType: APIResponse<Location>.self)
        
        do {
            let result = try await webservice.request(endpoint: .Characters, responseType: APIResponse<Location>.self)
            XCTAssertNil(result)
        } catch {
            let castedError = error as! WebserviceError
            XCTAssertEqual(castedError, WebserviceError.responseError)
        }
    }
    
}
