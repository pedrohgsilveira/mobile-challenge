//
//  RequestManagerTests.swift
//  BTG_Mobile_ChallengeTests
//
//  Created by Pedro Henrique Guedes Silveira on 19/12/20.
//

import XCTest
@testable import BTG_Mobile_Challenge

class RequestManagerTests: XCTestCase {
    
    var service: ServiceMock!
    var sut: RequestManager!
    
    override func setUpWithError() throws {
        super.setUp()
        let bundle = Bundle(for: type(of: self))
        service = ServiceMock(bundle: bundle)
        sut = RequestManager(service: service)
    }
    
    func testLiveCurrencyBehavior() {        
        let expectation = XCTestExpectation()

        let url = CurrencyAPIEndpoint.live.url
        let stubJSONURL = service.bundle.url(forResource: "live-response", withExtension: "json")
        let stubJSONData = try! Data(contentsOf: stubJSONURL!) 
        let stubJSON = try! JSONDecoder().decode(LiveCurrencyReponse.self, from: stubJSONData)
        
        service.json = stubJSONURL
        
        DispatchQueue.main.async { [weak self] in
            self?.sut?.getRequest(url: url!, decodableType: LiveCurrencyReponse.self) { (response) in
                switch response {
                case .success(let result):
                    XCTAssertTrue(result.success)
                    XCTAssertFalse(result.quotes.isEmpty)
                    XCTAssertEqual(stubJSON, result)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testListCurrencyBehavior() {
        let expectation = XCTestExpectation()
        
        let url = CurrencyAPIEndpoint.list.url
        let stubJSONURL = service.bundle.url(forResource: "list-response", withExtension: "json")
        let stubJSONData = try! Data(contentsOf: stubJSONURL!) 
        let stubJSON = try! JSONDecoder().decode(ListCurrencyResponse.self, from: stubJSONData)
        
        service.json = stubJSONURL
        
        DispatchQueue.main.async { [weak self] in
            self?.sut?.getRequest(url: url!, decodableType: ListCurrencyResponse.self) { (response) in
                switch response {
                case .success(let result):
                    XCTAssertEqual(stubJSON.currencies.count, result.currencies.count)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        service = nil
        super.tearDown()
    }
}