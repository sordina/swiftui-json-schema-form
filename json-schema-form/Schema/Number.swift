
import SwiftUI

public struct NumberType: Encodable, Decodable, View {
    @State private var number: Float = 69 // TODO: Defaults, Environment Variable
    
    var type: SchemaType = SchemaType.number
    var minimum: Float?
    var maximum: Float?
    var title: String?
    var description: String?
    
    private enum CodingKeys: String, CodingKey {
        case type
        case minimum
        case maximum
        case title
        case description
    }
    
    public func jsonValue() throws -> JsonValue {
        return .JsonNumber(value: Double(self.number))
    }
    
    public var body: some View {
        Section {
            if let t = title { Text(t) }
            if let d = description { Text(d) }
            TextField("Number", value: $number, format: .number)
                .onChange(of: number) { n in
                    if let m = minimum {
                        if n < m {
                            number = m
                        }
                    }
                    if let m = maximum {
                        if n > m {
                            number = m
                        }
                    }
                }
        }
    }
}

