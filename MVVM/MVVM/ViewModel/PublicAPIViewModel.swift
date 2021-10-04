//
//  PublicAPIViewModel.swift
//  MVVM
//
//  Created by dhanasekaran on 02/10/21.
//

import Foundation
import SwiftUI
import Combine

class PublicAPIViewModel: ObservableObject, ServiceListAPIService
{
    @Published var publishedResult: Result<[PublicAPIModel], APIError>? = nil
    
    var apiSession: APISession
    var cancellables = Set<AnyCancellable>()
    
    init(apiSession: APISession = APISession())
    {
        self.apiSession = apiSession
    }
    
    func getAPIList() {
        let cancellable = self.getApiServiceList().sink { result in
            switch result
            {
            case .failure(let apiError):
                self.publishedResult = .failure(apiError)
            case .finished:
                break
            }
        } receiveValue: { (publicAPI) in
                self.publishedResult = .success(publicAPI.entries)
        }
        cancellables.insert(cancellable)
    }
    
}
