//
//  JsonSchema.swift
//  Agent Dashboard
//
//  Created by Lyndon Maydwell on 25/7/2022.
//  Implements json-schema: https://json-schema.org/draft/2020-12/json-schema-core.html
//

import SwiftUI


struct JsonSchema_Previews: PreviewProvider {
    // TODO: Find some way to include geographical-location.schema in preview assets instead of main bundle
    static var previews: some View {
        let bundle = Bundle.main
//        if let path = bundle.path(forResource: "geographical-location.schema", ofType: "json") {
        if let path = bundle.path(forResource: "card.schema", ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            try! decoder.decode(JsonSchema.self, from: data)
        } else {
            Text("Preview Schema could not be loaded.").padding()
        }
    }
}

// Used to test if a key is present. The actual decoding result isn't used.
public struct TestKey: Decodable {
    var test = "testing"
    public init(from decoder: Decoder) throws {
        return
    }
    
    public func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        try c.encodeNil()
        return
    }
}

// A JsonSchema is just a JsonType with additional metadata - $id, $schema
public struct JsonSchema: Encodable, Decodable, View {
    var id: String
    var schema: String
    var type: JsonType
    var defs: Dictionary<String, JsonType>?

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case schema = "$schema"
        case defs = "$defs"
    }
    
    public init(from decoder: Decoder) throws {
        let kv = try decoder.container(keyedBy: CodingKeys.self)
        let c = try decoder.singleValueContainer()
        
        self.id = try kv.decode(String.self, forKey: .id)
        self.schema = try kv.decode(String.self, forKey: .schema)
        self.type = try c.decode(JsonType.self)
        self.defs = try kv.decodeIfPresent(Dictionary<String, JsonType>.self, forKey: .defs)
    }
    
    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(self.id, forKey: CodingKeys.id)
        try c.encode(self.schema, forKey: CodingKeys.schema)
        try self.type.encode(to: encoder) // neat
    }
    
    public func encodeString() throws -> String {
        let encoder = JSONEncoder()
        let _ = encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        let str = String(data: data, encoding: .utf8)! // Throw error if not encodable
        return str
    }
    
    public var body: some View {
        Form {
                Section(header: Text("JSON Schema Form!")) {
                    Link(schema, destination: URL(string: schema)!).font(.system(size: 12))
                    Link(id, destination: URL(string: id)!).font(.system(size: 12))
                    type
                }
        }
    }
}

public enum SchemaType: String, Encodable, Decodable {
    case object
    case array
    case string
    case number
    case boolean
    case null
}

public enum JsonType: Encodable, Decodable, View {
    case object(ObjectType)
    case number(NumberType)
    case array(ArrayType)
    case string(StringType)
    case null(NullType)
    case boolean(BooleanType)
    case ref(RefType)
    
    enum CodingKeysType: String, CodingKey {
        case type
    }
    
    public init(from decoder: Decoder) throws {
        let kvr = try decoder.container(keyedBy: RefType.CodingKeys.self)
        let c = try decoder.singleValueContainer()

        if let r = try kvr.decodeIfPresent(String.self, forKey: RefType.CodingKeys.ref) {
            self = .ref(RefType(ref: r))
            return
        } else {
            let kvt = try decoder.container(keyedBy: CodingKeysType.self)
            let t = try kvt.decode(SchemaType.self, forKey: CodingKeysType.type)
            
            switch t {
            case SchemaType.object:
                let o = try c.decode(ObjectType.self)
                try o.validate()
                self = .object(o)
            case SchemaType.number:
                self = .number(try c.decode(NumberType.self))
            case SchemaType.array:
                self = .array(try c.decode(ArrayType.self))
            case SchemaType.boolean:
                self = .boolean(try c.decode(BooleanType.self))
            case SchemaType.null:
                self = .null(try c.decode(NullType.self))
            case SchemaType.string:
                self = .string(try c.decode(StringType.self))
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .object(let o):
            try o.encode(to: encoder)
        case .number(let n):
            try n.encode(to: encoder)
        case .array(let a):
            try a.encode(to: encoder)
        case .string(let s):
            try s.encode(to: encoder)
        case .null(let n):
            try n.encode(to: encoder)
        case .boolean(let b):
            try b.encode(to: encoder)
        case .ref(let r):
            try r.encode(to: encoder)
        }
    }
    
    public var body: some View {
        switch self {
        case .object(let o): return AnyView(o)
        case .number(let n): return AnyView(n)
        case .array(let a): return AnyView(a)
        case .string(let s): return AnyView(Text("String"))
        case .null(let n): return AnyView(Text("Null"))
        case .boolean(let b): return AnyView(Text("Boolean"))
        case .ref(let r): return AnyView(Text("Ref"))
        }
    }
}

public struct RefType: Encodable, Decodable {
    var ref: String

    enum CodingKeys: String, CodingKey {
        case ref = "$ref"
    }
}

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

public struct NumberType: Encodable, Decodable, View {
    @State private var number: Float = 69 // TODO: Defaults, Environment Variable
    
    var type: SchemaType = SchemaType.number
    var minimum: Float?
    var maximum: Float?
    var title: String?
    var description: String?
    
    private enum CodingKeys: String, CodingKey {
        case type
        case minimum
        case maximum
        case title
        case description
    }
    
    public var body: some View {
        Section {
            if let t = title { Text(t) }
            if let d = description { Text(d) }
            TextField("Number", value: $number, format: .number)
                .onChange(of: number) { n in
                    if let m = minimum {
                        if n < m {
                            number = m
                        }
                    }
                    if let m = maximum {
                        if n > m {
                            number = m
                        }
                    }
                }
        }
    }
}

public struct StringType: Encodable, Decodable {
    var type: SchemaType = SchemaType.string
    var title: String?
    var description: String?
}

public struct NullType: Encodable, Decodable {
    var type: SchemaType = SchemaType.null
    var title: String?
    var description: String?
}

public struct BooleanType: Encodable, Decodable {
    var type: SchemaType = SchemaType.boolean
    var title: String?
    var description: String?
}

public struct ArrayType: Encodable, Decodable, View {
    @State var collection: Array<JsonValue> = [] // TODO: Use Environment instead of state
    
    var type: SchemaType = SchemaType.array
    var items: Array<JsonType> = [] // Hack to work around limits of Struct allocation.
    var title: String?
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case items
        case title
        case description
    }
    
    public init(from decoder: Decoder) throws {
        let kv = try decoder.container(keyedBy: CodingKeys.self)
        self.type = SchemaType.array
        if let v = try kv.decodeIfPresent(JsonType.self, forKey: CodingKeys.items) {
            self.items = [ v ]
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(self.type, forKey: .type)
        switch self.items.count {
        case 0:
            try c.encodeNil(forKey: .items)
        case 1:
            try c.encode(self.items[0], forKey: .items)
        default: throw(JsonDecodeError(message: "Couldn't encode items to JsonType"))
        }
    }
    
    public var body: some View {
        Section {
            ForEach(collection, id: \.self) { x in
                Text(try! x.encodeString())
            }
            Button(title ?? "New Item") {
                collection.append(.JsonString(value: "lol"))
            }
        }
    }
}

// This is a more explicit version of JSONValue
public struct ObjectType: Encodable, Decodable, View {
    let type: SchemaType = SchemaType.object
    var title: String?
    var description: String?
    var properties: Dictionary<String, JsonType>?
    var required: Array<String>? // TODO: Should be present in properties
    var dependentRequired: Dictionary<String, Array<String>>? // TODO: Should be present in properties

    enum CodingKeys: String, CodingKey {
        case type
        case title
        case description
        case properties
        case required
        case dependentRequired
    }
    
    // Check that required and requiredDependent references are present in properties
    public func validate() throws {
        for k in self.required ?? [] {
            if self.properties?[k] == nil {
                throw(JsonDecodeError(message: "Required required value is missing key \(k)"))
            }
        }
        for (k, v) in self.dependentRequired ?? [:] {
            if self.properties?[k] == nil {
                throw(JsonDecodeError(message: "Required dependentRequired key is missing key \(k)"))
            }
            for x in v {
                if self.properties?[x] == nil {
                    throw(JsonDecodeError(message: "Required dependentRequired value is missing key \(k)"))
                }
            }
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            if let t = title { Text(t) }
            if let d = description { Text(d) }
            if let p = properties {
                ForEach(p.sorted(by: {$0.0 < $1.0}), id: \.key) { k, v in
                    Text(k).bold()
                    v
                }
            }
        }
    }
}
