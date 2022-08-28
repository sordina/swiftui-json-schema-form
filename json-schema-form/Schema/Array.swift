
import SwiftUI

// This exists to allow ForEach to have a stable ID reference for ordering/deletion, etc.
struct ArrayItem<T> {
    public var id: UUID = UUID()
    public var item: T
}

public struct ArrayType: Encodable, Decodable, View {
    @State var collection: Array<ArrayItem<JsonType>> = [] // TODO: Use Environment instead of state
    
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
        self.title = try kv.decodeIfPresent(String.self, forKey: CodingKeys.title)
        self.description = try kv.decodeIfPresent(String.self, forKey: CodingKeys.description)
        if let v = try kv.decodeIfPresent(JsonType.self, forKey: CodingKeys.items) {
            self.items = [ v ]
        }
    }
    
    public func jsonValue() throws -> JsonValue {
        return .JsonArray(value: try self.collection.map {x in try x.item.jsonValue()})
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
    
    private func removeItems(at offsets: IndexSet) {
        collection.remove(atOffsets: offsets)
    }
    
    public var body: some View {
        // TODO: Include the title if appropriate
        List {
            ForEach(collection, id: \.id) { x in
                x.item
            }.onDelete(perform: removeItems)
            
            if let i = items[0] { // removes the need for Hashable w/ ForEach
                Button {
                    let j = i // TODO: Figure out how to do a "deep-copy" of this value
                    collection.append(ArrayItem(item: j))
                } label: {
                    Image(systemName: "plus") // (title ?? "New Item")
                }.buttonStyle(.bordered)
            }
        }
    }
}
