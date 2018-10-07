//
//  TonsserAPI.swift
//  ListChallenge
//
//  Created by Norberto Vasconcelos on 03/10/2018.
//  Copyright © 2018 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import Moya

// MARK: - Provider setup
private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

let tonsserProvider = MoyaProvider<Tonsser>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

// MARK: - Provider support
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum Tonsser {
    case getFollowers(String)
}

extension Tonsser: TargetType {
    public var baseURL: URL { return URL(string: "http://api.tonsser.com")! }
    public var path: String {
        switch self {
        case .getFollowers(_):
            return "/49/users/christian-planck/followers"
        }
    }
    public var method: Moya.Method {
        return .get
    }
    
    public var parameters: [String: Any] {
        switch self {
        case .getFollowers(let slug):
            return slug.isEmpty ? [:] : ["current_follow_slug": slug.urlEscaped]
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .getFollowers(_):
            return "[]".data(using: String.Encoding.utf8)!
        }
    }
    
    public var task: Task {
        switch self {
        case .getFollowers(_):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    public var validationType: ValidationType {
        return .none
    }
    
    public var headers: [String: String]? {
        return nil
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

// MARK: - Response Handlers
extension Moya.Response {
    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}
