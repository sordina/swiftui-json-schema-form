
import SwiftUI

struct ContentView: View {
    @State var path = "geographical-location.schema"
    @State var schema: JsonSchema?
    @State var loading = "Loading..."
    @StateObject var environment = SchemaEnvironment(refs: RefSchemaMap(
        files: ["address.schema","calendar.schema","card.schema","geographical-location.schema"]),
        value: .JsonString(value: "lol"))
    
    func setSchema() {
        let bundle = Bundle.main
        if let path = bundle.path(forResource: self.path, ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            self.schema = try! decoder.decode(JsonSchema.self, from: data)
        } else {
            self.schema = nil
            self.loading = "Error finding schema file..."
        }
    }
    
    var body: some View {
        NavigationView {
            Group {
                switch self.schema {
                case .some(let s):
                    s
                case .none:
                    Text(loading)
                        .padding()
                        .onAppear {
                            setSchema()
                        }
                    Spacer()
                }
            }
            .navigationBarItems(leading:
                TextField("Path", text: $path).onChange(of: path) { s in
                    setSchema()
                }
            )
        }.environmentObject(environment)
    }
}

struct ContentView_Previews: PreviewProvider {
    // TODO: Find some way to include geographical-location.schema in preview assets instead of main bundle
    static var previews: some View {
        ContentView()
    }
}
