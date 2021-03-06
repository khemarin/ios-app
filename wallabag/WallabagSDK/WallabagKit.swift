//
//  WallabagKit.swift
//  wallabag
//
//  Created by Marinel Maxime on 10/10/2019.
//

import Combine
import Foundation

public class WallabagKit {
    typealias Parameters = [String: Any]
    private var host: String
    private var decoder: JSONDecoder
    private let session: URLSession
    var bearer: String?

    init(host: String, session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.host = host
        self.decoder = decoder
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.session = session
    }

    func requestAuth(clientId: String, clientSecret: String, username: String, password: String) -> AnyPublisher<WallabagToken, Error> {
        send(decodable: WallabagToken.self, to: WallabagOauth.request(clientId: clientId, clientSecret: clientSecret, username: username, password: password))
    }

    // swiftlint:disable force_cast
    func send<T: Decodable>(decodable: T.Type, to: WallabagKitEndpoint, onQueue: DispatchQueue = .main) -> AnyPublisher<T, Error> {
        var urlRequest = URLRequest(url: URL(string: "\(host)\(to.endpoint())")!)
        urlRequest.httpMethod = to.method().rawValue
        urlRequest.httpBody = to.getBody()
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if to.requireAuth() {
            urlRequest.setValue("Bearer \(bearer!)", forHTTPHeaderField: "Authorization")
        }

        let publisher = session.dataTaskPublisher(for: urlRequest)
            .subscribe(on: onQueue)
            .tryMap { data, response in
                // print(String(data: data, encoding: .utf8))
                let res = response as! HTTPURLResponse
                if res.statusCode == 400 {
                    if let poc = try? self.decoder.decode(WallabagJsonError.self, from: data) {
                        throw WallabagKitError.jsonError(json: poc)
                    } else {
                        throw WallabagKitError.unknown
                    }
                }
                // Log(res.statusCode)
                // print(String(data: data, encoding: .utf8))
                return data
            }
            .decode(type: decodable, decoder: decoder)
            .eraseToAnyPublisher()

        return publisher
    }
}
