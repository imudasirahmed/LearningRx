import Foundation
import RxSwift

typealias MessagesClosure = ([Message]) -> Void
typealias VoidClosure = () -> Void
typealias PhotoDescriptionsClosure = ([PhotoDescription]) -> Void

class ModelLayer {
    
    let photoDescriptions = Variable<[PhotoDescriptionEntity]>([])
    let messages = Variable<[Message]>([])
    
    static let shared = ModelLayer()
    
    private var bag = DisposeBag()
    private var networkLayer = NetworkLayer() //normally injected as an interface
    private var persistanceLayer = PersistanceLayer.shared
    private var translationLayer = TranslationLayer()

    func initDatabase() {
        persistanceLayer.initDatabase()
    }
}

//MARK: - Database Example
extension ModelLayer {

    func loadAllPhotodescriptions() { //result may immediate, but use async callbacks
        persistanceLayer.loadAllPhotoDescriptions { photoDescriptions in //[weak self] //assuming that we have bigger problems if the model layer doesn't exist
            
            let entities = photoDescriptions.map(self.translationLayer.convert)
            self.photoDescriptions.value = entities
        }
    }
    
}

//MARK: - Network Example
extension ModelLayer {
    func loadMessage() {
        loadMessage { [weak self] messages in
            self?.messages.value = messages
        }
    }

    func loadMessage(finished: @escaping MessagesClosure) {
        networkLayer.loadMessages()
                    .subscribe(onNext: { [weak self] result, json in
                        guard let messsagesJson = json as? [[String: Any]] else { return }
                        
                        self?.parse(messagesJson: messsagesJson, finished: finished)
                    }, onError: { error in
                        //Handle Error differently
                        print(error.localizedDescription)
                    }).disposed(by: bag)
    }
    
    private func parse(messagesJson: [[String: Any]], finished: @escaping MessagesClosure) {
        let messages = translationLayer.convert(messagesJson: messagesJson)
        finished(messages)
    }
    
}

//MARK: - Tasks
extension ModelLayer {
    func loadInfo(for people: [Person]) -> Observable<[String]> {
        return networkLayer.loadInfo(for: people)
    }
}



