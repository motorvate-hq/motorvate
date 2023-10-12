//
//  JobsViewControllerStatusUpdating.swift
//  Motorvate
//
//  Created by Emmanuel on 6/8/20.
//  Copyright © 2020 motorvate. All rights reserved.
//

import Foundation

extension JobsViewController {
    func presentActionController(at indexPath: IndexPath?, job: Job?) {
        guard let indexPath = indexPath, let job = job else { return }
        let context = viewModel.updateContext(for: indexPath)
        
        let jobStatusController = JobStatusPopupController(status: context.status) { [weak self] status in
            if status == .completed {
                self?.showCompleteJobPopupController(job: job)
            } else {
                self?.setAsLoading(true)
                self?.viewModel.update(jobID: context.jobID, with: status)
            }
        }
        self.present(jobStatusController, animated: false)
    }
    
    func showCompleteJobPopupController(job: Job) {
        let completeJobPopupController = CompleteJobPopupController(
            handleSendInvoice: { [weak self] in
                guard let customerID = job.customerID else { return }
                self?.presentMessageViewController(customerID, jobId: job.jobID, sendInvoice: true)
            },
            handleComplete: { [weak self] in
                self?.completeJob(jobID: job.jobID)
            }
        )
        present(completeJobPopupController, animated: false)
    }
    
    private func completeJob(jobID: String) {
        setAsLoading(true)
        viewModel.update(jobID: jobID, with: .completed)
    }
}
