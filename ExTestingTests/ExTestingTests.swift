//
//  ExTestingTests.swift
//  ExTestingTests
//
//  Created by 김종권 on 2023/06/17.
//

import Quick
import Nimble
import RxSwift
@testable import ExTesting

final class ExTestingTests: QuickSpec {
    override func spec() {
        var viewModel: ViewModelable!
        var viewController: Presentable!
        
        func setUp(dependency: ViewModel.Dependency) {
            viewModel = ViewModel(dependency: dependency)
            viewController = ViewControllerMock(viewModel: viewModel)
        }
        
        describe("ExTesting 모듈의 ViewController에서") {
            beforeEach {
                setUp(dependency: .init(count: 7))
            }
            
            context("viewDidLoad가 발생하면") {
                beforeEach {
                    viewModel.input(.viewDidLoad)
                }
                
                it("디스크에 저장되는 count값 +1하여 viewController에게 전달") {
                    let expectedResult = State.updateCountOfViewDidLoad(count: 8)
                    
                    expect(viewController.stateObservable)
                        .toEventually(equal(expectedResult))
                }
                
                it("메모리에 저장되는 count값 +1하여 viewController에게 전달") {
                    let expectedResult = State.updateCountOfViewDidLoad(count: 8)
                    expect(viewModel.output)
                        .toEventually(expectedResult)
                }
            }
            
            context("viewModel이 메모리 해제된 후 다시 만들어지면") {
                beforeEach {
                    viewModel = ViewModel(dependency: .init(count: nil))
                }
                
                it("디스크에 저장되는 count값은 이전에 저장된 값이 적용되며 이를 viewController에게 전달") {
                    let expectedResult = State.updateCountOfViewDidLoad(count: 8)
                    expect(viewModel.output)
                        .toEventually(expectedResult)
                }
                
                it("count값을 1로하여 viewController에게 전달") {
                    let expectedResult = State.updateCountOfViewDidLoad(count: 1)
                    expect(viewModel.output)
                        .toEventually(expectedResult)
                }
            }
        }
    }
}
