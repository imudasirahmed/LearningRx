import Foundation
import RxSwift
import Alamofire
import RxAlamofire

extension NetworkLayer {
    func loadMessages() -> RxSwift.Observable<(HTTPURLResponse, Any)> {
        return RxAlamofire.requestJSON(.get, "https://jsonplaceholder.typicode.com/posts")
    }
}
