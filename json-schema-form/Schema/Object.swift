//
//  JSON.swift
//  Agent Dashboard
//
//  Created by Lyndon Maydwell on 25/7/2022.
//  Implements json-schema: https://json-schema.org/draft/2020-12/json-schema-core.html
//

import SwiftUI

public struct ObjectType: Encodable, Decodable, View {
    let type: SchemaType = SchemaType.object
    var title: String?
    var description: String?
    var properties: Dictionary<String, JsonType>?
    // NOTE: `required` and `dependentRequired` are validated to be present in properties.
    var required: Array<String>?
    var dependentRequired: Dictionary<String, Array<String>>?
    
    @State private var advanced: Bool = false

    enum CodingKeys: String, CodingKey {
        case type
        case title
        case description
        case properties
        case required
        case dependentRequired
    }
    
    public func jsonValue() throws -> JsonValue {
        if let p = properties {
            let q = try p.sorted(by: { $0.key < $1.key}).map { k,v in
                (k, try v.jsonValue())
            }
            return .JsonObject(value: Dictionary(uniqueKeysWithValues: q))
        }
        return .JsonObject(value: [:]);
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
    
    @ViewBuilder private func item(_ k: String, _ v: JsonType) -> some View {
        switch v {
        case .boolean(_): v
        default:
            Section(header: Text(k)) {
                v
            }
        }
    }
    
    public var body: some View {
        if let t = title {
            if let d = description {
                Section(header: Text(t)) {
                    Text(d).italic()
                }
            }
        } else if let d = description {
            Text(d).italic()
        }
        
        if let p = properties {
            // TODO: Do this more efficiently. Also just have required default to [] if missing.
            let reqs = p.filter({ (required ?? []).contains($0.key) })
            let opts = p.filter({ !(required ?? []).contains($0.key) })
            ForEach(reqs.sorted(by: {$0.0 < $1.0}), id: \.key) { k, v in
                // Bools can be toggled inline... But
                // TODO: Need to find a way to pass through the key if the title is missing
                // TODO: Find a way to share this code
                item(k,v)
            }

            if opts.count > 0 {
                Section(header: HStack {
                    Text("Additional Options").italic()
                    Toggle("", isOn: $advanced).font(.system(size: 14).weight(.bold))
                }) {
                    EmptyView()
                }
                
                if advanced {
                    ForEach(opts.sorted(by: {$0.0 < $1.0}), id: \.key) { k, v in
                        item(k,v)
                    }
                }
            }
        }
    }
}
