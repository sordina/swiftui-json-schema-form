
import SwiftUI

// This exists to allow ForEach to have a stable ID reference for ordering/deletion, etc.
struct ArrayItem<T> {
    public var id: UUID = UUID()
    public var item: T
}

public struct ArrayType: Encodable, Decodable, View, Copy {
    @State var collection: Array<ArrayItem<JsonType>> = [] // TODO: Use Environment instead of state
    
    var common: CommonProperties<Array<JsonValue>>
    var items: Box<JsonType>
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    
    public init(from decoder: Decoder) throws {
        self.common = try CommonProperties(from: decoder)
        let kv = try decoder.container(keyedBy: CodingKeys.self)
        self.items = Box(value: try kv.decode(JsonType.self, forKey: CodingKeys.items))
    }
    
    public func jsonValue() throws -> JsonValue {
        return .JsonArray(value: try self.collection.map {x in try x.item.jsonValue()})
    }
    
    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(self.items.value, forKey: .items)
    }
    
    private func removeItems(at offsets: IndexSet) {
        collection.remove(atOffsets: offsets)
    }
    
    public var body: some View {
        // TODO: Include the title if appropriate
        List {
            ForEach(collection, id: \.id) { x in
                x.item
            }
            .onDelete(perform: removeItems)
            // ^ https://www.hackingwithswift.com/books/ios-swiftui/deleting-items-using-ondelete
            
            if let i = items.value { // removes the need for Hashable w/ ForEach
                Button {
                    let j = i.copy()
                    collection.append(ArrayItem(item: j))
                } label: {
                    Image(systemName: "plus") // (title ?? "New Item")
                }.buttonStyle(.bordered)
            }
        }
    }
}
