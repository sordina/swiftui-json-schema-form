
import SwiftUI

struct NestedFormView: View {
    @State private var text = "Blabla"
    
    var body: some View {
        NavigationView {
            Form {
                Section("Foo") {
                    TextField("Foo", text: $text)
                }
                NavigationLink("Over there") {
                    Form {
                        Section("Next") {
                            Text("Other")
                        }
                    }
                }
            }
            .navigationTitle("My Form")
        }
    }
}

struct NestedFormView_Previews: PreviewProvider {
    // TODO: Find some way to include geographical-location.schema in preview assets instead of main bundle
    static var previews: some View {
        NestedFormView()
    }
}
