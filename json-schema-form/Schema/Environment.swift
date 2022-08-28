//
//  Environment.swift
//
//  Created by Lyndon Maydwell on 25/7/2022.
//  Implements json-schema: https://json-schema.org/draft/2020-12/json-schema-core.html
//

import SwiftUI

class SchemaEnvironment: ObservableObject {
    @Published var refs: RefSchemaMap
    @Published var value: JsonValue
    
    init(refs: RefSchemaMap, value: JsonValue) {
        self.refs = refs
        self.value = value
    }
}
