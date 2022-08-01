//
//  ContentView.swift
//  json-schema-form
//
//  Created by Lyndon Maydwell on 31/7/2022.
//

import SwiftUI

struct SchemaView: View {
    var schema: JsonSchema
    var body: some View {
        VStack(alignment: .leading) {
            Text("JSON Schema Form!")
            Text(schema.schema).font(.system(size: 12))
            Text(schema.id).font(.system(size: 12))
            Divider()
            TypeView(type: schema.type)
        } // .environment(schema.defs)
    }
}

struct TypeView: View {
    var type: JsonType
    var body: some View {
        Text("lol")
    }
}

struct SchemaView_Previews: PreviewProvider {
    var schema: JsonSchema?

    static var previews: some View {
        let bundle = Bundle.main
        if let path = bundle.path(forResource: "geographical-location.schema", ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            let schema = try! decoder.decode(JsonSchema.self, from: data)
            SchemaView(schema: schema)
        } else {
            Text("Preview Schema could not be loaded.").padding()
        }
    }
}

