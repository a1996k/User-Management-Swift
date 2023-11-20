import Foundation
import SwiftUI

struct UserRowView: View {
    let user: User

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("First Name: \(user.firstName)")
                    .font(.headline)
                Text("Last Name: \(user.lastName)")
                    .font(.subheadline)
                Text("Email: \(user.email)")
                    .font(.subheadline)
                Text("Phone Number: \(user.phoneNumber)")
                    .font(.subheadline)
            }
        }
    }
}
