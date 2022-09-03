
import SwiftUI

public struct NumberType: Encodable, Decodable, View, Copy {
    @State private var number: Float?
    
    var common: CommonProperties<Float>
    var minimum: Float?
    var maximum: Float?

    private enum CodingKeys: String, CodingKey {
        case minimum
        case maximum
    }
    
    public init(from decoder: Decoder) throws {
        let kv = try decoder.container(keyedBy: CodingKeys.self)
        self.common = try CommonProperties(from: decoder)
        self.minimum = try kv.decodeIfPresent(Float.self, forKey: .minimum)
        self.maximum = try kv.decodeIfPresent(Float.self, forKey: .maximum)
        self.number = common.defaultValue
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
            if let t = common.title { Text(t) }
            if let d = common.description { Text(d) }
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

