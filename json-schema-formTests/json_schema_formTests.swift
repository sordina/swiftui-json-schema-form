//
//  json_schema_formTests.swift
//  json-schema-formTests
//
//  Created by Lyndon Maydwell on 31/7/2022.
//

import XCTest
import json_schema_form

class json_schema_formTests: XCTestCase {

    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }
    
    func testGeographical() throws { try testFile("geographical-location.schema") }
    func testCard()         throws { try testFile("card.schema") }
    func testAddress()      throws { try testFile("address.schema") }
    func testCalandar()     throws { try testFile("calandar.schema") }
//    func testOutput()       throws { try testFile("output.schema") }

    func testFile(_ fileName: String) throws {
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: fileName, ofType: "json") {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            let schema = try decoder.decode(JsonSchema.self, from: data)
            XCTAssertTrue(true)
            XCTAssertTrue(true)
            print(try schema.encodeString())
            
            // RoundTrip Test
            do {
                let str    = try schema.encodeString()
                let value1 = try decoder.decode(JsonValue.self, from: data)
                let value2 = try decoder.decode(JsonValue.self, from: str.data(using: .utf8)!)
                XCTAssertEqual(value1, value2)
            }
        }
        XCTAssertTrue(true)
        XCTAssertTrue(true)
        XCTAssertTrue(true)
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}
