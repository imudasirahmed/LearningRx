//
//  LearningRx
//
//  Created by Mudasir Ahmed on 4/30/19.
//  Copyright © 2019 Mudasir Ahmed. All rights reserved.
//
//

import Foundation
import CoreData
import Outlaw

class PhotoDescriptionTranslation {
    func convert(entity: PhotoDescriptionEntity, context: NSManagedObjectContext) -> PhotoDescription {
        
        let photoDescription = PhotoDescription(context: context)
            photoDescription.url = entity.url
            photoDescription.title = entity.title
            photoDescription.thumbnailUrl = entity.thumbnailUrl

        if let id = entity.id {
            photoDescription.id = Int64(id)
        }
        
        if let albumId = entity.albumId {
            photoDescription.albumId = Int64(albumId)
        }
        
        return photoDescription
    }
    
    func convert(photoDescription: PhotoDescription) -> PhotoDescriptionEntity {
        let entity = PhotoDescriptionEntity(albumId: Int(photoDescription.albumId),
                                            id: Int(photoDescription.id),
                                            title: photoDescription.title,
                                            url: photoDescription.url,
                                            thumbnailUrl: photoDescription.thumbnailUrl)
        return entity
    }

}
