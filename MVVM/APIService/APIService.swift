//
//  APIService.swift
//  MVVM
//
//  Created by dhanasekaran on 29/09/21.
//

import Foundation
import Combine

enum APIError: Error
{
    case decodingError
    case httpError(Int)
    case unknown
}
protocol APIRequestProtocol {
    var request: URLRequest { get }
}
protocol APIServiceProtocol {
    func request<T: Decodable>(with request: APIRequestProtocol) -> AnyPublisher<T, APIError>
}

struct APISession: APIServiceProtocol
{
    func request<T>(with request: APIRequestProtocol) -> AnyPublisher<T, APIError> where T : Decodable {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return URLSession.shared.dataTaskPublisher(for: request.request)
            .receive(on: DispatchQueue.main)
            .mapError { _ in .unknown }
            .flatMap { data, response -> AnyPublisher<T, APIError> in
                if let response = response as? HTTPURLResponse {
                    if (200...299).contains(response.statusCode) {
                        return Just(data).decode(type: T.self, decoder: decoder).mapError {_ in .decodingError}.eraseToAnyPublisher()
                    } else {
                        return Fail(error: APIError.httpError(response.statusCode)).eraseToAnyPublisher()
                    }
                } else {
                    return Fail(error: APIError.unknown).eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
}

enum APIEndPoint
{
    case apiList
}
extension APIEndPoint: APIRequestProtocol {
    var request: URLRequest {
        switch self
        {
        case .apiList:
            return URLRequest(url: URL(string: "https://api.publicapis.org/entries")!)
        }
    }
}

protocol ServiceListAPIService {
    var apiSession: APISession { get }
    
    func getApiServiceList() -> AnyPublisher<PublicAPIList, APIError>
}
extension ServiceListAPIService {
    
    func getApiServiceList() -> AnyPublisher<PublicAPIList, APIError> {
        return apiSession.request(with: APIEndPoint.apiList)
    }
    
}
class APIService
{
    static let shared = APIService()
    
    func fetchPublicApiList(completion: @escaping (PublicAPIList?, Error?) -> ()) {
        let url = URL(string: "https://api.publicapis.org/entries")!
        
        URLSession.shared.dataTask(with: url) { data, urlResposne, error in
            if let data = data, let apiList = try? JSONDecoder().decode(PublicAPIList.self, from: data) {
                completion(apiList, nil)
            } else if let error = error {
                completion(nil, error)
            } else {
                completion(nil, APIError.decodingError)
            }
        }.resume()
    }
}
