//
//  Callback.swift
//  AssignmentTestApp
//
//  Created by akash on 26/02/20.
//  Copyright © 2020 akash. All rights reserved.
//

import Foundation

public class Callback<T, V> {
    
    private let successBlock: (T) -> Void
    private let failureBlock: (V) -> Void
    
    public init(onSuccess: @escaping (T) -> Void, onFailure: @escaping (V) -> Void) {
        self.successBlock = onSuccess
        self.failureBlock = onFailure
    }
    
    public func onSuccess(_ successResponse: T) {
        successBlock(successResponse)
    }
    
    public func onFailure(_ failureResponse: V) {
        failureBlock(failureResponse)
    }
    
}
