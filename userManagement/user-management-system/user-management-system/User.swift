import Foundation
import RealmSwift

class User: Object, Identifiable {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var phoneNumber: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}

