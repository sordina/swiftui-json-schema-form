//
//  JSON.swift
//  Agent Dashboard
//
//  Created by Lyndon Maydwell on 25/7/2022.
//  Implements json-schema: https://json-schema.org/draft/2020-12/json-schema-core.html
//

import SwiftUI

public struct RefSchemaMap {
    var entries: Dictionary<String, JsonSchema> = [:]
    public init(files: Array<String>) {
        var items: Array<(String, JsonSchema)> = []
        for p in files {
            let bundle = Bundle.main
            if let path = bundle.path(forResource: p, ofType: "json") {
                let data = try! Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                let decoded = try! decoder.decode(JsonSchema.self, from: data)
                items.append((decoded.id, decoded))
            }
        }
        self.entries = Dictionary(uniqueKeysWithValues: items)
        print("RefSchemaMap Keys:", self.entries.keys) // TODO: Remove debugging
    }
}

public struct RefType: Encodable, Decodable, View {
    @EnvironmentObject var settings: SchemaEnvironment

    var ref: String

    enum CodingKeys: String, CodingKey {
        case ref = "$ref"
    }
    
    public func jsonValue() throws -> JsonValue {
        return .JsonNull // TODO: Store an actual referenced value
    }
    
    public var body: some View {
        if let s = settings.refs.entries[ref] {
            s.type
        } else {
            Text("Couldn't find referenced schema").foregroundColor(.red).italic()
        }
    }
}

