
import SwiftUI

public struct CommonProperties<T: Encodable & Decodable>: Encodable, Decodable {
    var type: SchemaType
    var title: String?
    var description: String?
    var defaultValue: T?

    private enum CodingKeys: String, CodingKey {
        case type
        case title
        case description
        case defaultValue = "default"
    }
}

final class Box<T> {
    var value: T

    init(value: T) {
        self.value = value
    }
}
