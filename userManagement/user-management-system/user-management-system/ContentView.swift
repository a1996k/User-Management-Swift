import SwiftUI
struct ContentView: View {
    @StateObject private var userManager = UserManager.shared
    @State private var isCreateUserViewPresented = false
    @State private var shouldResetCreateUserForm = false

    var body: some View {
        TabView {
            UserListView()
                .tabItem {
                    Label("User List", systemImage: "list.bullet")
                }

            NavigationView {
                CreateUserView(createUserManager: userManager, shouldReset: $shouldResetCreateUserForm)
                    .environmentObject(userManager)
            }
            .tabItem {
                Label("Create User", systemImage: "person.badge.plus")
            }
        }
    }
}

@main
struct UserManagementApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
