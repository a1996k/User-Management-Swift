import Foundation
import RealmSwift
import Combine

class RealmDatabaseManager: ObservableObject {
    static let shared = RealmDatabaseManager()

    private var realm: Realm
    private var cancellables: Set<AnyCancellable> = []
    private var notificationToken: NotificationToken?

    @Published var users: Results<User>

    internal init() {
        realm = try! Realm()
        users = realm.objects(User.self)
        observeUsers()
    }

    private func observeUsers() {
        notificationToken = users.observe { [weak self] (changes: RealmCollectionChange) in
            DispatchQueue.main.async {
                switch changes {
                case .initial, .update:
                    self?.objectWillChange.send()
                default:
                    break
                }
            }
        }
    }

    func addUser(_ user: User) {
        do {
            try realm.write {
                realm.add(user)
            }
        } catch {
            print("Error adding user: \(error)")
        }
    }

    func updateUser(_ user: User, firstName: String, lastName: String, email: String, phoneNumber: String) {
        do {
            try realm.write {
                user.firstName = firstName
                user.lastName = lastName
                user.email = email
                user.phoneNumber = phoneNumber
            }
        } catch {
            print("Error updating user: \(error)")
        }
    }

    func deleteUser(_ user: User) {
        do {
            try realm.write {
                realm.delete(user)
            }
        } catch {
            print("Error deleting user: \(error)")
        }
    }

    deinit {
        notificationToken?.invalidate()
    }
}
