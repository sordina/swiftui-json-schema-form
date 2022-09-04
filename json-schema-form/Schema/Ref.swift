
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

public struct RefType: Encodable, Decodable, View, Copy {
    @EnvironmentObject var settings: SchemaEnvironment

    // Note: RefType doesn't need a type field, since refs are indicated by a "$ref" key, not a "type" key.
    var ref: String

    enum CodingKeys: String, CodingKey {
        case ref = "$ref"
    }
    
    public func jsonValue() throws -> JsonValue {
        return .JsonNull // TODO: Store an actual referenced value
    }
    
    public var body: some View {
        if let s = settings.refs.entries[ref] {
            NavigationLink(try! s.type.jsonValue().encodeString()) {
                Form {
                    s.type
                }
            }
        } else {
            Text("Couldn't find referenced schema").foregroundColor(.red).italic()
        }
    }
}

