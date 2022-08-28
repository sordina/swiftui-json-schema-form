
import SwiftUI

public struct NullType: Encodable, Decodable {
    var type: SchemaType = SchemaType.null
    var title: String?
    var description: String?
}

