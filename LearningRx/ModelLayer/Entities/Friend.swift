import Foundation

struct Friend: CustomStringConvertible {
    var firstName: String
    var lastName: String
    
    var description: String { return "\(firstName) \(lastName)" }
}
