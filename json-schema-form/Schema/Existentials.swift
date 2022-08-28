//
//  JSON.swift
//  Agent Dashboard
//
//  Created by Lyndon Maydwell on 25/7/2022.
//  Implements json-schema: https://json-schema.org/draft/2020-12/json-schema-core.html
//

import SwiftUI

public struct AllOfType: Encodable, Decodable {
    var allOf: Array<JsonType>
    
    enum CodingKeys: String, CodingKey {
        case allOf
    }
}

public struct AnyOfType: Encodable, Decodable {
    var anyOf: Array<JsonType>
    
    enum CodingKeys: String, CodingKey {
        case anyOf
    }
}

