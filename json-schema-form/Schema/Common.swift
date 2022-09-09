
import SwiftUI

class SchemaEnvironment: ObservableObject {
    @Published var refs: RefSchemaMap
    @Published var value: JsonValue
    
    init(refs: RefSchemaMap, value: JsonValue) {
        self.refs = refs
        self.value = value
    }
}

protocol Copy {
    func copy() -> Self
}

extension Copy {
  func copy() -> Self {
    return self
  }
}

public struct CommonProperties<T: Encodable & Decodable>: Encodable, Decodable {
    var type: SchemaType
    var title: String?
    var description: String?
    var defaultValue: T?

    private enum CodingKeys: String, CodingKey {
        case type
        case title
        case description
        case defaultValue = "default"
    }
}

final class Box<T> {
    var value: T

    init(value: T) {
        self.value = value
    }
}

class Key: ObservableObject {
    var key: String?
    
    init(_ key: String) {
        self.key = key
    }
}
