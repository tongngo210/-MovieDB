import Foundation
import RxSwift

protocol ViewModel {
    associatedtype Input
    associatedtype Output
        
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output
}
