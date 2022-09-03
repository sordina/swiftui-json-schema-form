
import SwiftUI

public struct NumberType: Encodable, Decodable, View, Copy {
    @State private var number: Float?
    
    var type: SchemaType = SchemaType.number
    var minimum: Float?
    var maximum: Float?
    var title: String?
    var description: String?
    var defaultValue: Float?

    private enum CodingKeys: String, CodingKey {
        case type
        case minimum
        case maximum
        case title
        case description
        case defaultValue = "default"
    }
    
    public func jsonValue() throws -> JsonValue {
        if let n = number {
            return .JsonNumber(value: Double(n))
        } else {
            return .JsonNull
        }
    }
    
    public var body: some View {
        Section {
            if let t = title { Text(t) }
            if let d = description { Text(d) }
            TextField("Number", value: $number, format: .number)
                .onChange(of: number) { nM in
                    if let n = nM {
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
}

