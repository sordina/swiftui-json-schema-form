//
//  JSON.swift
//  Agent Dashboard
//
//  Created by Lyndon Maydwell on 25/7/2022.
//  Implements json-schema: https://json-schema.org/draft/2020-12/json-schema-core.html
//

import SwiftUI

public struct NullType: Encodable, Decodable {
    var type: SchemaType = SchemaType.null
    var title: String?
    var description: String?
}

