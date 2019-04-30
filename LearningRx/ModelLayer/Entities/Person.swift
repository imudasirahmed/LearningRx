import Foundation

struct Person: CustomStringConvertible {
    var firstName: String
    var lastName: String
    var age: Int
    
    var description: String { return "\(firstName) \(lastName) - age: \(age)" }
}
