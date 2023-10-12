//
//  JobDataStore.swift
//  Motorvate
//
//  Created by Emmanuel on 7/20/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

public final class JobDataStore {
    private enum Identifier {
        static let collectionTag = "jobCollectionTag"
    }
    
    static let shared = JobDataStore()

    private init() {}

    private var jobList = [String: [Job]]()

}

extension JobDataStore: JobPersisting {
    func insert(_ jobs: [Job], completion: @escaping JobPersistingCompletion) {
        let identifier = Identifier.collectionTag
        jobList[identifier] = jobs

        completion(.success(jobs))
    }

    func fetchJobList() -> JobFetchResult {
        guard let list = jobList[Identifier.collectionTag] else { return nil }
        return list
    }
}
