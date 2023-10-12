//
//  JobsPersisting.swift
//  Motorvate
//
//  Created by Emmanuel on 7/20/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

typealias JobPersistingCompletion = (Result<[Job], Error>) -> Void
typealias JobFetchResult = [Job]?

protocol JobPersisting {
    func insert(_ jobs: [Job], completion: @escaping JobPersistingCompletion)
    func fetchJobList() -> JobFetchResult
}
