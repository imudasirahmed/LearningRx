import Foundation
import Outlaw

class Message: Deserializable {
    
    var id: Int
    var body: String
    var title: String
    var userId: Int
    
    init(id: Int, body: String, title: String, userId: Int) {
        self.id = id
        self.body = body
        self.title = title
        self.userId = userId
    }
    
    required init(object: Extractable) throws {
        id = try object.value(for: "id")
        body = try object.value(for: "body")
        title = try object.value(for: "title")
        userId = try object.value(for: "userId")
    }
}

