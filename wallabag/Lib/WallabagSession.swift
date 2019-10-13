//
//  WallabagSession.swift
//  wallabag
//
//  Created by Marinel Maxime on 13/10/2019.
//

import Foundation

class WallabagSession: ObservableObject {
    enum State {
        case unknown
        case connecting
        case connected
        case error
        case offline
    }

    @Published var state: State = .unknown

    lazy var kit: WallabagKit = {
        WallabagKit(host: WallabagUserDefaults.host)
    }()

    func requestSession() {
        _ = kit.requestAuth(
            clientId: WallabagUserDefaults.clientId,
            clientSecret: WallabagUserDefaults.clientSecret,
            username: WallabagUserDefaults.login,
            password: WallabagUserDefaults.password
        ).sink(receiveCompletion: { completion in
            if case .failure = completion {
                self.state = .error
            }
        }, receiveValue: { token in
            WallabagUserDefaults.refreshToken = token.refreshToken
            WallabagUserDefaults.accessToken = token.accessToken
            self.kit.bearer = token.accessToken
            self.state = .connected
        })
    }
}
