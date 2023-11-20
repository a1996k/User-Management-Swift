import SwiftUI

struct CreateUserView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phoneNumber = ""

    @ObservedObject var createUserManager: UserManager
    @Environment(\.presentationMode) var presentationMode

    // Regular expression patterns
    let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
    let phoneNumberRegex = #"^\d{10}$"#
    let nameRegex = #"^[a-zA-Z]+$"#

    @State private var isShowingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @Binding var shouldReset: Bool

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Information")) {
                    TextField("First Name", text: $firstName)
                        .textContentType(.givenName)
                        .keyboardType(.namePhonePad)
                        .padding(.vertical, 8)

                    TextField("Last Name", text: $lastName)
                        .textContentType(.familyName)
                        .keyboardType(.namePhonePad)
                        .padding(.vertical, 8)

                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                        .padding(.vertical, 8)

                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.numberPad)
                        .padding(.vertical, 8)
                }

                Section {
                    Button("Create User") {
                        // Check for valid email and phone number before creating user
                        if isValidInput(email, regex: emailRegex) && isValidInput(phoneNumber, regex: phoneNumberRegex) {
                            // Check for valid first name and last name
                            if isValidInput(firstName, regex: nameRegex) && isValidInput(lastName, regex: nameRegex) {
                                createUserManager.createUser(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber)

                                // Show success alert with completion to switch view
                                showAlertWithCompletion(title: "Success", message: "User created successfully") {
                                    shouldReset = true // Set the flag to reset the form
                                    presentationMode.wrappedValue.dismiss()
                                }
                            } else {
                                // Handle invalid first name or last name
                                alertTitle = "Invalid Name"
                                alertMessage = "Please enter a valid first name and last name."
                                isShowingAlert = true
                            }
                        } else {
                            // Handle invalid input, e.g., show an alert or update UI
                            if !isValidInput(email, regex: emailRegex) {
                                alertTitle = "Invalid Email"
                                alertMessage = "Please enter a valid email address."
                                isShowingAlert = true
                            }

                            if !isValidInput(phoneNumber, regex: phoneNumberRegex) {
                                alertTitle = "Invalid Phone Number"
                                alertMessage = "Please enter a valid 10-digit phone number."
                                isShowingAlert = true
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Create User")
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onDisappear {
                if shouldReset {
                    resetForm()
                }
            }
        }
    }

    func showAlertWithCompletion(title: String, message: String, completion: @escaping () -> Void) {
        alertTitle = title
        alertMessage = message
        isShowingAlert = true

        // Call the completion handler when OK is tapped
        completion()
    }

    func isValidInput(_ input: String, regex: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: input)
    }

    private func resetForm() {
        // Reset the form values
        firstName = ""
        lastName = ""
        email = ""
        phoneNumber = ""
        shouldReset = false
    }
}

