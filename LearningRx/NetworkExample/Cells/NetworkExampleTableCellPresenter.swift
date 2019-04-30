import Foundation

struct NetworkExampleTableCellPresenter {
    var message: Message
    
    var idLabel: String { return "\(message.id)"}
    var userId: String { return "\(message.userId)"}
    var title: String { return message.title }
    var body: String { return message.body }
}

