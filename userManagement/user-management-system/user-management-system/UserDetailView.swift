import SwiftUI

struct UserDetailView: View {
    let user: User
    let userManager: RealmDatabaseManager
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section {
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                TextField("Email", text: $email)
                TextField("Phone Number", text: $phoneNumber)
            }

            Section {
                Button("Save") {
                    if !user.isInvalidated {
                        userManager.updateUser(user, firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber)
                    }
                    presentationMode.wrappedValue.dismiss()
                }

                Button("Delete") {
                    if !user.isInvalidated {
                        userManager.deleteUser(user)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .foregroundColor(.red)
            }
        }
        .onAppear {
            if !user.isInvalidated {
                firstName = user.firstName
                lastName = user.lastName
                email = user.email
                phoneNumber = user.phoneNumber
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationBarTitle(user.isInvalidated ? "" : "\(user.firstName) \(user.lastName)", displayMode: .inline)
    }
}
