//
//  JsonSchema.swift
//
//  Created by Lyndon Maydwell on 25/7/2022.
//  Implements json-schema: https://json-schema.org/draft/2020-12/json-schema-core.html
//

import SwiftUI

struct JsonSchema_Previews: PreviewProvider {
    // TODO: Find some way to include schemas in preview assets instead of main bundle
    static var previews: some View {
        let bundle = Bundle.main
        if let path = bundle.path(forResource: "card.schema", ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            try! decoder.decode(JsonSchema.self, from: data)
        } else {
            Text("Preview Schema could not be loaded.").padding()
        }
    }
}

// A JsonSchema is just a JsonType with additional metadata - $id, $schema
public struct JsonSchema: Encodable, Decodable, View {
    var id: String
    var schema: String
    var title: String?
    var description: String?
    var type: JsonType
    var defs: Dictionary<String, JsonType>?

    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case schema = "$schema"
        case title = "title"
        case description = "description"
        case defs = "$defs"
    }
    
    public init(from decoder: Decoder) throws {
        let kv = try decoder.container(keyedBy: CodingKeys.self)
        let c = try decoder.singleValueContainer()
        
        self.id = try kv.decode(String.self, forKey: .id)
        self.schema = try kv.decode(String.self, forKey: .schema)
        self.title = try kv.decodeIfPresent(String.self, forKey: .title)
        self.description = try kv.decodeIfPresent(String.self, forKey: .description)
        self.type = try c.decode(JsonType.self)
        self.defs = try kv.decodeIfPresent(Dictionary<String, JsonType>.self, forKey: .defs)
    }
    
    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(self.id, forKey: CodingKeys.id)
        try c.encode(self.schema, forKey: CodingKeys.schema)
        try c.encode(self.title, forKey: CodingKeys.title)
        try c.encode(self.description, forKey: CodingKeys.description)
        try self.type.encode(to: encoder) // neat
    }
    
    public func encodeString() throws -> String {
        let encoder = JSONEncoder()
        let _ = encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        let str = String(data: data, encoding: .utf8)!
        return str
    }
    
    public var body: some View {
        Form {
            Section(header: Text(title ?? id)) {
                VStack(alignment: .leading) {
                    Link(schema, destination: URL(string: schema)!).font(.system(size: 10).italic())
                    Link(id, destination: URL(string: id)!).font(.system(size: 10).italic())
                }
                if let d = description { Text(d).italic() }
            }
            type
        }
    }
}

