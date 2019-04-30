import Foundation
import CoreData

class TranslationLayer {
    
    static var shared = TranslationLayer() //normally injected and not singleton
    
    private var photoDescriptionTranslation = PhotoDescriptionTranslation()
    
    func convert(messagesJson json: [[String: Any]]) -> [Message] {
        let messages = json.flatMap { try? Message(object: $0) }
            messages.forEach { $0.doSomeFinalBusinessLogic() }
        
        return messages
    }
    
    func convert(entity: PhotoDescriptionEntity, context: NSManagedObjectContext) -> PhotoDescription {
        return photoDescriptionTranslation.convert(entity: entity, context: context)
    }
    
    func convert(photoDescription: PhotoDescription) -> PhotoDescriptionEntity {
        return photoDescriptionTranslation.convert(photoDescription: photoDescription)
    }
}

private extension Message {
    func doSomeFinalBusinessLogic() {
        //do something like normalize dates, etc
    }
}
