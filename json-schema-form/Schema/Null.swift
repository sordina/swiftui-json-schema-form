
import SwiftUI

public struct NullType: Encodable, Decodable, Copy {
    
    var common: CommonProperties<Int> // What to do about the default value??

    public init(from decoder: Decoder) throws {
        self.common = try CommonProperties(from: decoder)
    }
    
    public func jsonValue() throws -> JsonValue {
        return .JsonNull
    }
    
    public func encode(to encoder: Encoder) throws {
        try common.encode(to: encoder)
    }
}

