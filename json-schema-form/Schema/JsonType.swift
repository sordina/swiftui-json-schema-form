
import SwiftUI

public enum SchemaType: String, Encodable, Decodable {
    case object
    case array
    case string
    case number
    case boolean
    case null
}

public enum JsonType: Encodable, Decodable, View, Copy {
    
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
    
    public func jsonValue() throws -> JsonValue {
        switch self {
        case .object(let o): return try o.jsonValue()
        case .number(let n): return try n.jsonValue()
        case .array(let a): return try a.jsonValue()
        case .string(let s): return try s.jsonValue()
        case .null(_): return .JsonNull
        case .boolean(let b): return try b.jsonValue()
        case .ref(let r): return try r.jsonValue()
        }
    }
    
    public func copy() -> JsonType {
        switch self {
        case .object(let o): return .object(o.copy())
        case .number(let n): return .number(n.copy())
        case .array(let a): return .array(a.copy())
        case .string(let s): return .string(s.copy())
        case .null(let n): return .null(n.copy())
        case .boolean(let b): return .boolean(b.copy())
        case .ref(let r): return .ref(r.copy())
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
        case .string(let s): return AnyView(s)
        case .null(_): return AnyView(EmptyView()) // Null doesn't need a form
        case .boolean(let b): return AnyView(b)
        case .ref(let r): return AnyView(r)
        }
    }
}
