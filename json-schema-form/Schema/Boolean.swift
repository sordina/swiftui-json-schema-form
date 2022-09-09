
import SwiftUI

public struct BooleanType: Encodable, Decodable, View, Copy {
    @EnvironmentObject var key: Key

    var common: CommonProperties<Bool>

    @State var value = false
    
    public init(from decoder: Decoder) throws {
        self.common = try CommonProperties(from: decoder)
    }
    
    public func jsonValue() throws -> JsonValue {
        return .JsonBool(value: self.value)
    }
    
    public func encode(to encoder: Encoder) throws {
        try common.encode(to: encoder)
    }
    
    public var body: some View {
        Toggle(common.title ?? key.key ?? "Boolean", isOn: $value)
    }
}

