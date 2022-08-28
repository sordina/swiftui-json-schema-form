
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

