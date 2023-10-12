//
//  BusinessHoursView.swift
//  Motorvate
//
//  Created by Motorvate on 7.3.23..
//  Copyright © 2023 motorvate. All rights reserved.
//

import SwiftUI

class BusinessHoursViewModel: ObservableObject {
    @Published var sunday = BusinessHoursDay(day: "Sunday", isOpen: true)
    @Published var monday = BusinessHoursDay(day: "Monday", isOpen: true)
    @Published var tuesday = BusinessHoursDay(day: "Tuesday", isOpen: true)
    @Published var wednesday = BusinessHoursDay(day: "Wednesday", isOpen: true)
    @Published var thursday = BusinessHoursDay(day: "Thursday", isOpen: true)
    @Published var friday = BusinessHoursDay(day: "Friday", isOpen: true)
    @Published var saturday = BusinessHoursDay(day: "Saturday", isOpen: true)
    
    var scheduledData: [ScheduledData] {
        [
            ScheduledData(weekDay: 0, isOpen: sunday.isOpen, openTime: sunday.openTime, closeTime: sunday.closeTime),
            ScheduledData(weekDay: 1, isOpen: monday.isOpen, openTime: monday.openTime, closeTime: monday.closeTime),
            ScheduledData(weekDay: 2, isOpen: tuesday.isOpen, openTime: tuesday.openTime, closeTime: tuesday.closeTime),
            ScheduledData(weekDay: 3, isOpen: wednesday.isOpen, openTime: wednesday.openTime, closeTime: wednesday.closeTime),
            ScheduledData(weekDay: 4, isOpen: thursday.isOpen, openTime: thursday.openTime, closeTime: thursday.closeTime),
            ScheduledData(weekDay: 5, isOpen: friday.isOpen, openTime: friday.openTime, closeTime: friday.closeTime),
            ScheduledData(weekDay: 6, isOpen: saturday.isOpen, openTime: saturday.openTime, closeTime: saturday.closeTime)
        ]
    }
    
    func configure(with scheduledData: [ScheduledData]) {
        scheduledData.forEach({
            switch $0.weekDay {
            case 0: self.sunday = BusinessHoursDay(day: self.sunday.day, isOpen: $0.isOpen, openTime: $0.openTime, closeTime: $0.closeTime)
            case 1: self.monday = BusinessHoursDay(day: self.monday.day, isOpen: $0.isOpen, openTime: $0.openTime, closeTime: $0.closeTime)
            case 2: self.tuesday = BusinessHoursDay(day: self.tuesday.day, isOpen: $0.isOpen, openTime: $0.openTime, closeTime: $0.closeTime)
            case 3: self.wednesday = BusinessHoursDay(day: self.wednesday.day, isOpen: $0.isOpen, openTime: $0.openTime, closeTime: $0.closeTime)
            case 4: self.thursday = BusinessHoursDay(day: self.thursday.day, isOpen: $0.isOpen, openTime: $0.openTime, closeTime: $0.closeTime)
            case 5: self.friday = BusinessHoursDay(day: self.friday.day, isOpen: $0.isOpen, openTime: $0.openTime, closeTime: $0.closeTime)
            case 6: self.saturday = BusinessHoursDay(day: self.saturday.day, isOpen: $0.isOpen, openTime: $0.openTime, closeTime: $0.closeTime)
            default: break
            }
        })
    }
}

struct BusinessHoursView: View {
    @ObservedObject var viewModel: BusinessHoursViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 12) {
                Text("Operational Hours")
                    .font(Font(AppFont.archivo(.bold, ofSize: 20)))
                    .foregroundColor(Color(R.color.c141414() ?? .black))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Select the days of the week you would like automated scheduling to be active.\n\nCustomers will request available times for vehicle drop-off using your Service Form. Once requested, your shop will receive a notification to confirm the scheduled service.")
                    .font(Font(AppFont.archivo(.regular, ofSize: 16)))
                    .foregroundColor(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(spacing: 12) {
                BusinessHoursDayView(businessHoursDay: $viewModel.sunday)
                BusinessHoursDayView(businessHoursDay: $viewModel.monday)
                BusinessHoursDayView(businessHoursDay: $viewModel.tuesday)
                BusinessHoursDayView(businessHoursDay: $viewModel.wednesday)
                BusinessHoursDayView(businessHoursDay: $viewModel.thursday)
                BusinessHoursDayView(businessHoursDay: $viewModel.friday)
                BusinessHoursDayView(businessHoursDay: $viewModel.saturday)
            }
        }
        .padding()
        .background(Color.white)
    }
}
