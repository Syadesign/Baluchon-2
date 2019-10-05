//
//  WeatherServiceTestCase.swift
//  BaluchonTests
//
//  Created by Samahir Adi on 02/10/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

@testable import Baluchon
import XCTest

class WeatherServiceTestCase: XCTestCase {
    
    func testGetWeatherShouldPostFailedCallbackError() {
        //Given
        let weatherService = WeatherService(session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.weatherError))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherService.getWeather(city: "6455259") { (success, weather) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfNoData() {
        //Given
        let weatherService = WeatherService(session: URLSessionFake(data: nil, response: nil, error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherService.getWeather(city: "6455259") { (success, weather) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfIncorrectResponse() {
        //Given
         let weatherService = WeatherService(session: URLSessionFake(data: FakeResponseData.currencyCorrectData, response: FakeResponseData.responseKO, error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherService.getWeather(city: "6455259") { (success, weather) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfIncorrectData() {
        //Given
         let weatherService = WeatherService(session: URLSessionFake(data: FakeResponseData.translationIncorrectData, response: FakeResponseData.responseOK, error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherService.getWeather(city: "6455259") { (success, weather) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        //Given
         let weatherService = WeatherService(session: URLSessionFake(data: FakeResponseData.weatherCorrectData, response: FakeResponseData.responseOK, error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherService.getWeather(city: "6455259") { (success, weather) in
            // Then
            let temp = 12.35
            let main = "Clear"
        
            XCTAssertTrue(success)
            XCTAssertNotNil(weather)
            XCTAssertEqual(temp, weather!.main.temp)
            XCTAssertEqual(main, weather?.weather[0].main)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
}
