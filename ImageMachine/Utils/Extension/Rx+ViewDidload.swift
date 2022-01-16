//
//  Rx+ViewDidload.swift
//  ImageMachine
//
//  Created by mac on 16/1/22.
//

import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController {
  var viewDidLoad: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
    return ControlEvent(events: source)
  }
}
