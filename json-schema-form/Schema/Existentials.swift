
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

public struct OneOfType: Encodable, Decodable {
    var anyOf: Array<JsonType>
    
    enum CodingKeys: String, CodingKey {
        case anyOf
    }
}

