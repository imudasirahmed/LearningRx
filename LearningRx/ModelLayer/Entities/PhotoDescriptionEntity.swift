//

import Foundation
import Outlaw

struct PhotoDescriptionEntity: Deserializable {
    var albumId: Int?
    var id: Int?
    var title: String?
    var url: String?
    var thumbnailUrl: String?
    
    init(albumId: Int?, id: Int?, title: String?, url: String?, thumbnailUrl: String?) {
        self.albumId = albumId
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailUrl = thumbnailUrl
    }
    
    init(object: Extractable) throws {
        albumId = try? object.value(for: "albumId")
        id = try? object.value(for: "id")
        title = try? object.value(for: "title")
        url = try? object.value(for: "url")
        thumbnailUrl = try? object.value(for: "thumbnailUrl")
    }
}
