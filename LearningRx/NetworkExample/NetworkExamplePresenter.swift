import Foundation
import RxSwift

class NetworkExamplePresenter {

    fileprivate let modelLayer = ModelLayer.shared
    
    public var messages: Variable<[Message]> { return modelLayer.messages }
    
    init() {
        modelLayer.loadMessage()
    }
    
}

