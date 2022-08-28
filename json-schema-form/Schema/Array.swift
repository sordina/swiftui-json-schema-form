//
//  JSON.swift
//  Agent Dashboard
//
//  Created by Lyndon Maydwell on 25/7/2022.
//  Implements json-schema: https://json-schema.org/draft/2020-12/json-schema-core.html
//

import SwiftUI

public struct ArrayType: Encodable, Decodable, View {
    @State var collection: Array<JsonValue> = [] // TODO: Use Environment instead of state
    
    var type: SchemaType = SchemaType.array
    var items: Array<JsonType> = []
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
    
    public func jsonValue() throws -> JsonValue {
        return .JsonArray(value: self.collection)
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
        VStack(alignment: .leading) {
            ForEach(collection, id: \.self) { x in
                Text(try! x.encodeString())
            }
            if let i = items[0] { // removes the need for Hashable w/ ForEach
                i
                Button(title ?? "Add") {
                    collection.append(try! i.jsonValue()) // TODO: Make this try safe.
                }.buttonStyle(.borderless)
            }
        }.padding().background(Color(.systemGray6))
    }
}
