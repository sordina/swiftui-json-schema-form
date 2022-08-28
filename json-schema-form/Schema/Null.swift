
import SwiftUI

public struct NullType: Encodable, Decodable, Copy {
    var type: SchemaType = SchemaType.null
    var title: String?
    var description: String?
}

