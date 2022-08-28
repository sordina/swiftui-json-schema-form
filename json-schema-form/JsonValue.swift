
import SwiftUI

public struct JsonDecodeError: Error {
    let message: String
    public init(message: String) {
        self.message = message
    }
}

// This is a more explicit version of JSONValue
public enum JsonValue: Encodable, Decodable, Equatable, Hashable {
    case JsonNull
    case JsonBool(value: Bool)
    case JsonString(value: String)
    case JsonNumber(value: Double) // TODO: Use a decimal instead. Maybe NSDecimalNumber?
    case JsonArray(value: Array<JsonValue>)
    case JsonObject(value: Dictionary<String,JsonValue>)
    
    // Just render the underlying data
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .JsonNull: try container.encodeNil()
        case .JsonBool(value: let b): try container.encode(b)
        case .JsonString(value: let s): try container.encode(s)
        case .JsonNumber(value: let n): try container.encode(n)
        case .JsonArray(value: let a): try container.encode(a)
        case .JsonObject(value: let o): try container.encode(o)
        }
    }
    
    // Convenience function to build a JSON string
    public func encodeString() throws -> String {
        let encoder = JSONEncoder()
        let _ = encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        let str = String(data: data, encoding: .utf8)! // Throw error if not encodable
        return str
    }
    
    // Cool,  but not used...
    public init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if(c.decodeNil()) {
            self = .JsonNull
            return
        }
        if let b = try? c.decode(Bool.self) {
            self = .JsonBool(value: b)
            return
        }
        if let s = try? c.decode(String.self) {
            self = .JsonString(value: s)
            return
        }
        if let n = try? c.decode(Double.self) {
            self = .JsonNumber(value: n)
            return
        }
        if let a = try? c.decode(Array<JsonValue>.self) {
            self = .JsonArray(value: a)
            return
        }
        if let o = try? c.decode(Dictionary<String, JsonValue>.self) {
            self = .JsonObject(value: o)
            return
        }
        throw(JsonDecodeError(message: "Couldn't decode to JsonValue"))
    }
}
