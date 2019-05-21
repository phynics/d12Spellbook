//
//  Observable+IgnoreNil.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 16.05.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where Element == Optional<Any> {
    public static func ignoreNil() {
        return self.flatMap { Observable.from(optional: $0) }
    }
}
