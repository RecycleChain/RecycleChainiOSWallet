//
//  ApiTask.swift
//  HiveOnline
//
//  Created by Kirill Kirikov on 5/30/17.
//  Copyright © 2017 Seductive. All rights reserved.
//

import Foundation
import Alamofire

class ApiTask<T, E> {
    
    var dataRequest: DataRequest? {
        didSet {
            if let r = dataRequest as? UploadRequest {
                r.uploadProgress(queue: DispatchQueue.main) { [weak self] progress in
                    self?.runProgress(with: progress)
                }
            }
        }
    }
    
    private var successPool = [(T)->()]()
    private var failurePool = [(E)->()]()
    private var progressPool = [(Progress)->()]()
    private var completionPool = [()->()]()
    private var isCallbackReturned: Bool = false
    
    init(dataRequest: DataRequest? = nil) {
        self.dataRequest = dataRequest
    }
    
    @discardableResult
    func addSuccess(_ success: @escaping (T)->()) -> ApiTask<T, E> {
        successPool.append(success)
        return self
    }
    
    @discardableResult
    func addFailure(_ failure: @escaping (E)->()) -> ApiTask<T, E> {
        failurePool.append(failure)
        return self
    }
    
    @discardableResult
    func addCompletion(_ completion: @escaping ()->()) -> ApiTask<T, E> {
        completionPool.append(completion)
        return self
    }
    
    @discardableResult
    func addProgress(_ completion: @escaping (Progress)->()) -> ApiTask<T, E> {
        progressPool.append(completion)
        return self
    }
    
    func runSuccess(withResult result: T) {
        checkReturnedCallback()
        for block in successPool {
            block(result)
        }
        runCompletion()
    }
    
    func runFailure(withError error: E) {
        checkReturnedCallback()
        for block in failurePool {
            block(error)
        }
        runCompletion()
    }
    
    private func runCompletion() {
        for block in completionPool {
            block()
        }
        isCallbackReturned = true
    }
    
    func runProgress(with progress: Progress) {
        for block in progressPool {
            block(progress)
        }
    }
    
    private func checkReturnedCallback() {
        assert(isCallbackReturned == false, "Error, calback has already been called")
    }
    
    deinit {
        print("ApiTask deinited")
    }
}

extension ApiTask where E: InternalApiErrorConvertible {
    func defaultHandler(success: @escaping (T) -> Void = { _ in },
                        failure: @escaping (E) -> Void = { _ in }) -> (DataResponse<T>) -> Void {
        return { response in
            switch response.result {
            case .failure(let error):
                let err = E.from(error: InternalApiError.serverError(errors: [error.localizedDescription]))
                failure(err)
                self.runFailure(withError: err)
            case .success(let value):
                success(value)
                self.runSuccess(withResult: value)
            }
        }
    }
}

extension ApiTask: Hashable {
    var hashValue: Int {
        return unsafeBitCast(self, to: Int.self)
    }
    
    static func ==(a: ApiTask<T, E>, b: ApiTask<T, E>) -> Bool {
        return a.hashValue == b.hashValue
    }
}
