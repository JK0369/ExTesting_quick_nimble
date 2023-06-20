//
//  ExTestingMock.swift
//  ExTestingTests
//
//  Created by 김종권 on 2023/06/17.
//

import UIKit
@testable import RxSwift
@testable import ExTesting

// MARK: - ViewController
final class ViewControllerMock: Presentable {
    var viewModel: ViewModelable
    var stateObservable: Observable<State> {
        stateReplay
    }
    // 주의: ReplaySubject<State>.createUnbounded()와 ReplaySubject<State>()은 다름
    private let stateReplay = ReplaySubject<State>.createUnbounded()
    
    init(viewModel: ViewModelable) {
        self.viewModel = viewModel
        
        viewModel.output
            .observe(on: MainScheduler.instance)
            .bind(to: stateReplay)
    }
}

extension State: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.updateCountOfViewDidLoad(lhsCount), .updateCountOfViewDidLoad(rhsCount)):
            return lhsCount == rhsCount
        case let (.updateCountOfViewDidLoadOnMemory(lhsCount), .updateCountOfViewDidLoadOnMemory(rhsCount)):
            return lhsCount == rhsCount
        default:
            return false
        }
    }
}
