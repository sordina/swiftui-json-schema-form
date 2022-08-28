
import SwiftUI

public struct StringType: Encodable, Decodable, View, Copy {
    var type: SchemaType = SchemaType.string
    var title: String?
    var description: String?
    var defaultValue: String?
    
    @ObservedObject private var value = Model()
    
    class Model: ObservableObject {
        var value: String = ""
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case title
        case description
        case defaultValue = "default"
    }
    
    public init(from decoder: Decoder) throws {
        let kv = try decoder.container(keyedBy: CodingKeys.self)
        self.type = SchemaType.array
        self.title = try kv.decodeIfPresent(String.self, forKey: .title)
        self.description = try kv.decodeIfPresent(String.self, forKey: .description)
        self.defaultValue = try kv.decodeIfPresent(String.self, forKey: .defaultValue)
        value.value = defaultValue ?? "" // TODO: Figure out how to handle optionals
    }
    
    public func jsonValue() throws -> JsonValue {
        return .JsonString(value: value.value)
    }
    
    public func copy() -> StringType {
        var result = self
        result.respawnValue()
        return result
    }
    
    public mutating func respawnValue() {
        self.value = Model()
    }
    
    public func encode(to encoder: Encoder) throws {
        var kv = encoder.container(keyedBy: CodingKeys.self)
        try kv.encode(type, forKey: .type)
        try kv.encode(title, forKey: .title)
        try kv.encode(description, forKey: .description)
        try kv.encode(defaultValue, forKey: .defaultValue)
    }
    
    private func prompt() -> Text {
        if title != nil || description != nil {
            return Text("\(title ?? "") \(description ?? "")")
        } else {
            return Text("...")
        }
    }
    
    public var body: some View {
        TextField("String", text: $value.value, prompt: prompt())
    }
}

