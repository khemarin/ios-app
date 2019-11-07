//
//  ClientIdClientSecretView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import SwiftUI

struct ClientIdClientSecretView: View {
    @ObservedObject var clientIdClientSecretValidator = ClientIdClientSecretTextFieldValidator()

    var body: some View {
        Form {
            Section(header: Text("Client id")) {
                TextField("Client id", text: $clientIdClientSecretValidator.clientId).disableAutocorrection(true).autocapitalization(.none)
            }
            Section(header: Text("Client secret")) {
                TextField("Client secret", text: $clientIdClientSecretValidator.clientSecret).disableAutocorrection(true).autocapitalization(.none)
            }
            NavigationLink("Next", destination: LoginView()).disabled(!clientIdClientSecretValidator.isValid)
        }.navigationBarTitle("Client id & secret")
    }
}

#if DEBUG
    struct ClientIdClientSecretView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                ClientIdClientSecretView()
            }
        }
    }
#endif
