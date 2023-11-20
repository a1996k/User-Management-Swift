import SwiftUI

struct UserListView: View {
    @ObservedObject private var userManager = RealmDatabaseManager()

    var body: some View {
        NavigationView {
            List {
                ForEach(userManager.users) { user in
                    if !user.isInvalidated {
                        NavigationLink(destination: UserDetailView(user: user, userManager: userManager)) {
                            UserRowView(user: user)
                        }
                    }
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: addUser) {
//                        Image(systemName: "plus")
//                    }
                }
            }
        }
    }

    private func addUser() {
        let newUser = User()
        newUser.firstName = "New User"
        newUser.lastName = ""
        newUser.email = ""
        newUser.phoneNumber = ""
        userManager.addUser(newUser)
    }
}
