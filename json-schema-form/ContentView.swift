//
//  ContentView.swift
//  json-schema-form
//
//  Created by Lyndon Maydwell on 31/7/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    // TODO: Find some way to include geographical-location.schema in preview assets instead of main bundle
    static var previews: some View {
        let bundle = Bundle.main
        if let path = bundle.path(forResource: "geographical-location.schema", ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            try! decoder.decode(JsonSchema.self, from: data)
        } else {
            Text("Preview Schema could not be loaded.").padding()
        }
    }
}
