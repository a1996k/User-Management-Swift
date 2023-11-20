import Foundation
import RealmSwift
import Combine

class UserManager: ObservableObject {
    static let shared = UserManager()

    private var notificationToken: NotificationToken?
    private var cancellables: Set<AnyCancellable> = []

    @Published var users: Results<User>

    private let realm = try! Realm()

    init() {
        // Initialize the users property with the current users in the Realm
        users = realm.objects(User.self)

        // Observe changes to the User objects in the Realm
        notificationToken = users.observe { changes in
            switch changes {
            case .initial, .update:
                // The realm has changed, update the users property
                self.users = self.realm.objects(User.self)
            case .error(let error):
                // Handle error
                fatalError("\(error)")
            }
        }
    }

    deinit {
        // Invalidate the notification token when the UserManager is deallocated
        notificationToken?.invalidate()
    }

    func createUser(firstName: String, lastName: String, email: String, phoneNumber: String) {
        let newUser = User()
        newUser.firstName = firstName
        newUser.lastName = lastName
        newUser.email = email
        newUser.phoneNumber = phoneNumber

        try! realm.write {
            realm.add(newUser)
        }
    }

    func editUser(user: User, firstName: String, lastName: String, email: String, phoneNumber: String) {
        try! realm.write {
            user.firstName = firstName
            user.lastName = lastName
            user.email = email
            user.phoneNumber = phoneNumber
        }
    }

    func deleteUser(user: User) {
        guard !user.isInvalidated else {
            print("User is already deleted or invalidated.")
            return
        }

        do {
            try realm.write {
                realm.delete(user)
            }
        } catch {
            print("Error deleting user: \(error)")
        }
    }

    func resetUser() {
        guard let user = users.first else {
            print("No users available to reset.")
            return
        }

        guard !user.isInvalidated else {
            print("User is already deleted or invalidated.")
            return
        }

        // Reset the user object
        do {
            try realm.write {
                user.firstName = ""
                user.lastName = ""
                user.email = ""
                user.phoneNumber = ""
            }
        } catch {
            print("Error resetting user: \(error)")
        }
    }
}
