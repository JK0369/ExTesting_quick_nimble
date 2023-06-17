//
//  ViewModel.swift
//  ExTesting
//
//  Created by 김종권 on 2023/06/17.
//

import RxSwift
import RxCocoa

enum State {
    case updateCountOfViewDidLoad(count: Int)
}

final class ViewModel: ViewModelable {
    // MARK: State
    
    // MARK: Output
    var output: RxSwift.Observable<State> {
        outputSubject
    }
    private var outputSubject = PublishSubject<State>()
    private var countOfViewDidLoad: Int {
        get {
            UserDefaults.standard.integer(forKey: "countOfViewDidLoad")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "countOfViewDidLoad")
        }
    }
    
    // MARK: Input
    func input(_ action: Action) {
        switch action {
        case .viewDidLoad:
            countOfViewDidLoad += 1
            outputSubject.onNext(.updateCountOfViewDidLoad(count: countOfViewDidLoad))
        }
    }
}
