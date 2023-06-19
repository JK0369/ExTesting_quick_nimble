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

protocol ViewModelable {
    var output: Observable<State> { get }
    
    func input(_ action: Action)
}

final class ViewModel: ViewModelable {
    struct Dependency {
        let count: Int?
    }
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
        guard let count = dependency.count else { return }
        countOfViewDidLoadAtDisk = count
        countOfViewDidLoadAtMemory = count
    }
    
    // MARK: Output
    var output: RxSwift.Observable<State> {
        outputSubject
    }
    private var outputSubject = PublishSubject<State>()
    private var countOfViewDidLoadAtDisk: Int {
        get {
            UserDefaults.standard.integer(forKey: "countOfViewDidLoad")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "countOfViewDidLoad")
        }
    }
    var countOfViewDidLoadAtMemory = 0
    
    // MARK: Input
    func input(_ action: Action) {
        switch action {
        case .viewDidLoad:
            countOfViewDidLoadAtDisk += 1
            countOfViewDidLoadAtMemory += 1
            outputSubject.onNext(.updateCountOfViewDidLoad(count: countOfViewDidLoadAtDisk))
        }
    }
}
