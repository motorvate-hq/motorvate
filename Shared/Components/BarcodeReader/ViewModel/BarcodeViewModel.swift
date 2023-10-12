//
//  BarcodeViewModel.swift
//  Motorvate
//
//  Created by Emmanuel on 8/23/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import Foundation

struct BarcodeViewModel {
    fileprivate let service: JobService
    var jobID: String?
    var vehicleVin: String = ""

    init(service: JobService = JobService()) {
        self.service = service
    }

    func decodeVehicle(vin: String, jobID: String, completion: @escaping (Job?) -> Void) {
        service.decodeVehicle(vin: vin, jobID: jobID) { (result) in
            switch result {
            case .success(let job):
                completion(job)
            case .failure:
                completion(nil)
            }
        }
    }
}
