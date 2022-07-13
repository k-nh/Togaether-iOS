//
//  GatherListReactor.swift
//  App
//
//  Created by Hani on 2022/05/01.
//

import UIKit

import ReactorKit
import RxSwift

final class GatherListReactor: Reactor {
    enum Action {
        case segmentIndex(index: Int)
        case gatherListCellDidTap(clubID: Int)
    }
    
    enum Mutation {
        case readyToListInfo(GatherListInfo)
        case readyToProceedDetailGatherView(Int)
    }
    
    struct State {
        var gatherListInfo = GatherListInfo(hasNotClub: false)
        var isReadyToProceedDetailGatherView = (false, 0)
    }
    
    private let disposeBag = DisposeBag()
    private let gatherListRepository: GatherListRepositoryInterface
    private let keychainUseCase: KeychainUseCaseInterface
    
    init(gatherListRepository: GatherListRepositoryInterface, keychainUseCase: KeychainUseCaseInterface) {
        self.gatherListRepository = gatherListRepository
        self.keychainUseCase = keychainUseCase
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .segmentIndex(index: let index):
            guard let gatherCondition = Gather.init(rawValue: index) else {
                return Observable.empty()
            }
            
            return getGatherList(gatherCondition)
        case .gatherListCellDidTap(clubID: let clubID):
            return Observable.just(Mutation.readyToProceedDetailGatherView(clubID))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .readyToListInfo(let data):
            newState.gatherListInfo = data
            newState.isReadyToProceedDetailGatherView = (false, 0)
        case .readyToProceedDetailGatherView(let clubID):
            newState.isReadyToProceedDetailGatherView = (true, clubID)
        }
        
        return newState
    }
    
    
    private func getGatherList(_ gather: Gather) -> Observable<Mutation> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                return Disposables.create()
            }
            
            self.keychainUseCase.getAccessToken()
                .subscribe(with: self,
                   onSuccess: { this, token in
                    
                    
                    
                    this.gatherListRepository.requestGatherList(lastID: nil, endDate: nil, gatherCondition: gather, accessToken: token)
                        .subscribe { result in
                        switch result {
                        case .success(let gatherListInfo):
                            observer.onNext(Mutation.readyToListInfo(GatherListInfo(hasNotClub: gatherListInfo.hasNotClub, clubInfos: gatherListInfo.clubInfos)))
                        case .failure(let error):
                            print("RESULT FAILURE: ", error.localizedDescription)
                        }
                    }.disposed(by: self.disposeBag)
                },
                onFailure: { _,_ in
                     return
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
