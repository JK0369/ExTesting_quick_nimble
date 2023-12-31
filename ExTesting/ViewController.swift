//
//  ViewController.swift
//  ExTesting
//
//  Created by 김종권 on 2023/06/17.
//

import UIKit
import RxCocoa
import RxSwift

enum Action {
    case viewDidLoad
}

protocol Presentable {
    var viewModel: ViewModelable { get }
    var stateObservable: Observable<State> { get }
}

class ViewController: UIViewController, Presentable {
    // MARK: UI
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    private let stateSubject = PublishSubject<State>()
    let viewModel: ViewModelable
    var stateObservable: Observable<State> {
        stateSubject
    }
    
    // MARK: Init
    init(viewModel: ViewModelable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bind()
        viewModel.input(.viewDidLoad)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func bind() {
        viewModel.output
            .observe(on: MainScheduler.instance)
            .bind(to: stateSubject)
            .disposed(by: disposeBag)
        
        stateSubject
            .observe(on: MainScheduler.instance)
            .bind(with: self) { ss, state in
                ss.handleOutput(state)
            }
            .disposed(by: disposeBag)
    }
    
    private func handleOutput(_ state: State) {
        switch state {
        case let .updateCountOfViewDidLoad(count):
            label.text = "\(count)"
        case let .updateCountOfViewDidLoadOnMemory(count):
            print("memory:\(count)")
        }
    }
}
