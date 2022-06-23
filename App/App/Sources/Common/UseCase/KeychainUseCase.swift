//
//  KeychainUseCase.swift
//  App
//
//  Created by Hani on 2022/06/24.
//

import Foundation

import RxSwift

final class KeychainUsecase: KeychainUseCaseInterface {
    private let keychainProvider: KeychainProvidable
    private let networkManager: NetworkManageable
    private let disposeBag = DisposeBag()
    
    init(keychainProvider: KeychainProvidable, networkManager: NetworkManageable) {
        self.keychainProvider = keychainProvider
        self.networkManager = networkManager
    }
    
    internal func getAccessToken() -> Single<Data> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(NSError()))
                return Disposables.create()
            }
            
            if let accessToken = try? self.keychainProvider.read(service: KeychainService.apple, account: KeychainAccount.accessToken) {
                single(.success(accessToken))
                return Disposables.create()
                
            } else if let refreshToken = try? self.keychainProvider.read(service: KeychainService.apple, account: KeychainAccount.refreshToken) {
                guard let url = URL(string: "https://yapp-togather.com/api/tokens/re-issuance") else {
                    single(.failure(NSError()))
                    return Disposables.create()
                }
                
                var urlRequest = URLRequest(url: url)
                urlRequest.httpBody = refreshToken
                
                let response: Single<TokenResponseDTO> = self.networkManager.requestDataTask(with: urlRequest)
                
                response.subscribe { result in
                    switch result {
                    case .success(let dto):
                        let tokens = dto.toDomain()
                        
                        guard let accessToken = tokens.accessToken.data(using: .utf8, allowLossyConversion: false),
                              let refreshToken = tokens.refreshToken.data(using: .utf8, allowLossyConversion: false) else {
                            single(.failure(NSError()))
                            return
                        }
                        
                        do {
                            try self.keychainProvider.create(accessToken, service: KeychainService.apple, account: KeychainAccount.accessToken)
                            try self.keychainProvider.delete(service: KeychainService.apple, account: KeychainAccount.refreshToken)
                            try self.keychainProvider.create(refreshToken, service: KeychainService.apple, account: KeychainAccount.refreshToken)
                        } catch {
                            single(.failure(NSError()))
                            return
                        }
                    case .failure(_):
                        single(.failure(NSError()))
                        return
                    }
                }.disposed(by: self.disposeBag)
                
            } else {
                single(.failure(NSError()))
                return Disposables.create()
            }
            
            single(.failure(NSError()))
            return Disposables.create()
        }
    }
}
