
import SwiftUI

public struct BooleanType: Encodable, Decodable, View {
    var type: SchemaType = SchemaType.boolean
    var title: String?
    var description: String?
    @State var value = false
    
    enum CodingKeys: String, CodingKey {
        case type
        case title
        case description
    }
    
    public init(from decoder: Decoder) throws {
        let kv = try decoder.container(keyedBy: CodingKeys.self)
        self.type = .boolean
        self.title = try kv.decodeIfPresent(String.self, forKey: .title)
        self.description = try kv.decodeIfPresent(String.self, forKey: .description)
    }
    
    public func jsonValue() throws -> JsonValue {
        return .JsonBool(value: self.value)
    }
    
    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(self.type, forKey: .type)
        try c.encode(self.title, forKey: .title)
        try c.encode(self.description, forKey: .description)
    }
    
    public var body: some View {
        Toggle("Boolean", isOn: $value)
    }
}

