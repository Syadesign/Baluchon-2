//
//  TranslationServiceTestCase.swift
//  BaluchonTests
//
//  Created by Samahir Adi on 02/10/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

@testable import Baluchon
import XCTest

class TranslationServiceTestCase: XCTestCase {
    
    func testGetTranslationShouldPostFailedCallbackError() {
        //Given
        let translationService = TranslationService(session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.translationError))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translationService.getTranslation(text: "Bonjour", from: "fr", to: "en") { (success, translatedText) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translatedText)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslationShouldPostFailedCallbackIfNoData() {
        //Given
        let translationService = TranslationService(session: URLSessionFake(data: nil, response: nil, error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translationService.getTranslation(text: "Bonjour", from: "fr", to: "en") { (success, translatedText) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translatedText)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslationShouldPostFailedCallbackIfIncorrectResponse() {
        //Given
        let translationService = TranslationService(session: URLSessionFake(data: FakeResponseData.currencyCorrectData, response: FakeResponseData.responseKO, error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
       translationService.getTranslation(text: "Bonjour", from: "fr", to: "en") { (success, translatedText) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translatedText)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslationShouldPostFailedCallbackIfIncorrectData() {
        //Given
        let translationService = TranslationService(session: URLSessionFake(data: FakeResponseData.translationIncorrectData, response: FakeResponseData.responseOK, error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translationService.getTranslation(text: "Bonjour", from: "fr", to: "en") { (success, translatedText) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translatedText)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslationShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        //Given
        let translationService = TranslationService(session: URLSessionFake(data: FakeResponseData.translationCorrectData, response: FakeResponseData.responseOK, error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translationService.getTranslation(text: "Bonjour", from: "fr", to: "en") { (success, translatedText) in
            // Then
            let translation = "Hello"
            XCTAssertTrue(success)
            XCTAssertNotNil(translatedText)
            XCTAssertEqual(translation, translatedText)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
}
