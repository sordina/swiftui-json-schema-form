
import SwiftUI

// Convenience function to handle range automatically.
extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}

enum StringError: Error {
    case flagError(message: String)
}

func flags(_ s: String) throws -> NSRegularExpression.Options {
    let os = try s.map { c -> NSRegularExpression.Options in
        switch c {
        case "i": return .caseInsensitive
        default: throw StringError.flagError(message: "Not a valid NSRegularExpression flag")
        }
    }
    var result: NSRegularExpression.Options = []
    for o in os {
        result = result.union(o)
    }
    return result
}

public struct StringType: Encodable, Decodable, View, Copy {
    var type: SchemaType = SchemaType.string
    var title: String?
    var description: String?
    var defaultValue: String?
    var pattern: NSRegularExpression?

    @ObservedObject private var value = Model()
    @State private var validity = Color.black
    
    class Model: ObservableObject, Equatable {
        static func == (lhs: StringType.Model, rhs: StringType.Model) -> Bool {
            return lhs.value == rhs.value
        }
        
        @Published var value: String = ""
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case title
        case description
        case pattern
        case patternFlags = "flags"
        case defaultValue = "default"
    }
    
    public init(from decoder: Decoder) throws {
        let kv = try decoder.container(keyedBy: CodingKeys.self)
        self.type = SchemaType.array
        self.title = try kv.decodeIfPresent(String.self, forKey: .title)
        self.description = try kv.decodeIfPresent(String.self, forKey: .description)
        self.defaultValue = try kv.decodeIfPresent(String.self, forKey: .defaultValue)
        if let p = try kv.decodeIfPresent(String.self, forKey: .pattern) {
            let fs = try kv.decodeIfPresent(String.self, forKey: .patternFlags)
            self.pattern = try NSRegularExpression(pattern: p, options: flags(fs ?? ""))
        }
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
        try kv.encode(pattern?.pattern, forKey: .pattern)
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
            .foregroundColor(validity)
            .onChange(of: value.value) { v in
                if let p = pattern {
                    if p.matches(v) {
                        validity = .green
                    } else {
                        validity = .red
                    }
                }
            }
    }
}

