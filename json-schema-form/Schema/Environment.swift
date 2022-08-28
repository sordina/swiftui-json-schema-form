
import SwiftUI

class SchemaEnvironment: ObservableObject {
    @Published var refs: RefSchemaMap
    @Published var value: JsonValue
    
    init(refs: RefSchemaMap, value: JsonValue) {
        self.refs = refs
        self.value = value
    }
}
