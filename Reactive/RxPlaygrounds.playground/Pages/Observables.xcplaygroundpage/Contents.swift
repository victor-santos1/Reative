import UIKit
import RxSwift
import SwiftUI

public func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

example(of: "subscribe") {
    // 1
    let one = 1
    let two = 2
    let three = 3
    
    // 2
    let observable = Observable<Int>.just(two)
    let observable1 = Observable.of(one, two, three)
    let observable2 = Observable.from([one, two, three])
    let observable3 = Observable.of([one, two, three])
    
    observable.subscribe(onNext: { element in
        print(element)
    })
    
    observable1.subscribe { event in
        if let element = event.element {
            print(element)
        }
    }
    
    observable2.subscribe { event in
        print(event)
    }
    
    observable3.subscribe { event in
        print(event)
    }
    
}

example(of: "empty") {
    let observable = Observable<Void>.empty()
    
    observable.subscribe(onNext: { element in
        print(element)
    }, onCompleted: { print("Faz nada alem de imprimir quando esta pronto") })
    
    
}

example(of: "never") {
    let observable = Observable<Void>.never()
    
    observable.subscribe(
        onNext: { element in
            print(element)
            
        }, onCompleted: { print("Completed") })
}

example(of: "range") {
    let observable = Observable<Int>.range(start: 1, count: 10)
    
    observable.subscribe(onNext: { i in
        let n = Double(i)
        
        let fibonacci = Int(
            ((pow(1.61803, n) - pow(0.61803, n)) /
             2.23606).rounded()
        )
        
        print(fibonacci)
    })
}

example(of: "dispose") {
    let observable = Observable.of("A", "B", "C")
    let subscription = observable.subscribe { event in print(event) }
    subscription.dispose()
}

example(of: "DisposeBag") {
    let disposeBag = DisposeBag()
    Observable.of("A", "B", "C").subscribe( {
        print($0)
    }).disposed(by: disposeBag)
}

example(of: "create") {
    enum MyError: Error {
        case anError
    }
    
    let disposeBag = DisposeBag()
    
    Observable<String>.create { observer in
        // 1
        observer.onNext("1")
        
        //    observer.onError(MyError.anError)
        
        // 2
        //    observer.onCompleted()
        
        // 3
        observer.onNext("?")
        
        // 4
        return Disposables.create()
    }
    .subscribe(
        onNext: { print($0) },
        onError: { print($0) },
        onCompleted: { print("Completed") },
        onDisposed: { print("Disposed") }
    )
    .disposed(by: disposeBag)
}

example(of: "deferred") {
    
    let disposeBag = DisposeBag()
    var flip = false
    let factory: Observable<Int> = Observable.deferred {
        
        flip.toggle()
        if flip {
            return Observable.of(1, 2, 3)
        } else {
            return Observable.of(4, 5, 6)
        }
    }
    
    for _ in 0...3 {
        factory.subscribe(onNext: {
            print($0, terminator: "")
        }).disposed(by: disposeBag)
    }
}

let bag = DisposeBag()
let numero = Observable.of(1)
var str = PublishSubject<String>()

numero.subscribe(
    onNext: { print("\($0) - Numero com ação") },
    onCompleted: { print("terminou") }
).disposed(by:  bag)


str.on(.next("Algo"))
