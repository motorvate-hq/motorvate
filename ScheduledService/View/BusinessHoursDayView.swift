//
//  BusinessHoursDayView.swift
//  Motorvate
//
//  Created by Motorvate on 7.3.23..
//  Copyright © 2023 motorvate. All rights reserved.
//

import SwiftUI

struct ColoredToggleStyle: ToggleStyle {
    var onColor = Color(R.color.cDADADA() ?? .white)
    var offColor = Color(R.color.cDADADA() ?? .white)
    var thumbColor = Color.white
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 16, style: .circular)
                .fill(configuration.isOn ? onColor : offColor)
                .frame(width: 50, height: 29)
                .overlay(
                    Circle()
                        .strokeBorder(.white, lineWidth: 2)
                        .background(Circle().fill(thumbColor))
                        .padding(1.5)
                        .offset(x: configuration.isOn ? 10 : -10)
                )
                .onTapGesture { configuration.isOn.toggle() }
        }
        .font(.title)
        .padding(0)
    }
}

struct BusinessHoursDayView: View {
    @Binding var businessHoursDay: BusinessHoursDay
    
    @State private var openTime = Date()
    @State private var closeTime = Date()
    @State private var showDatePicker = false
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    HStack(spacing: 5) {
                        HStack(spacing: 5) {
                            clockImageView(color: Color((businessHoursDay.isOpen ? R.color.cFFAE13() : R.color.c613CBB()) ?? .gray))
                            
                            Button {
                                showDatePicker.toggle()
                            } label: {
                                dayView(day: businessHoursDay)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(!businessHoursDay.isOpen)
                        }
                        .frame(maxHeight: .infinity)
                        
                        HStack(spacing: 5) {
                            Text(businessHoursDay.isOpen ? "Active" : "Inactive")
                                .font(Font(AppFont.archivo(.medium, ofSize: 17)))
                                .opacity(businessHoursDay.isOpen ? 1.0 : 0.5)
                                .layoutPriority(1000)
                            
                            Toggle("", isOn: $businessHoursDay.isOpen)
                                .tint(Color(R.color.cDADADA() ?? .gray))
                                .toggleStyle(ColoredToggleStyle(thumbColor: Color((businessHoursDay.isOpen ? R.color.c5B9104() : R.color.cEF3434()) ?? .white)))
                        }
                        .frame(maxHeight: .infinity)
                    }
                    
                    if showDatePicker {
                        HStack(spacing: 0) {
                            DatePicker(
                                "",
                                selection: $openTime,
                                displayedComponents: .hourAndMinute
                            )
                            .labelsHidden()
                            .environment(\.locale, Locale.init(identifier: "en_US"))
                            .datePickerStyle(.wheel)
                            .frame(maxWidth: 140, maxHeight: 240)
                            .compositingGroup()
                            .scaleEffect(x: 0.6, y: 0.7)
                            .clipped()
                            .onAppear {
                                UIDatePicker.appearance().minuteInterval = 5
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "h:mm a"
                                
                                openTime = dateFormatter.date(from: businessHoursDay.openTime ?? "") ?? Date()
                            }
                            
                            DatePicker(
                                "",
                                selection: $closeTime,
                                displayedComponents: .hourAndMinute
                            )
                            .labelsHidden()
                            .environment(\.locale, Locale.init(identifier: "en_US"))
                            .datePickerStyle(.wheel)
                            .frame(maxWidth: 140, maxHeight: 240)
                            .compositingGroup()
                            .scaleEffect(x: 0.6, y: 0.7)
                            .clipped()
                            .onAppear {
                                UIDatePicker.appearance().minuteInterval = 5
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "h:mm a"
                                
                                closeTime = dateFormatter.date(from: businessHoursDay.closeTime ?? "") ?? Date()
                            }
                        }
                        .padding(.vertical, -40)
                    }
                }
                .padding(15)
                .padding(.top, 6)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(R.color.cDFDFDF() ?? .gray), lineWidth: 3)
                )
                .padding(.top, 10)
                
                dayView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onChange(of: businessHoursDay.isOpen) { newValue in
            if !newValue {
                showDatePicker = false
            }
        }
        .onChange(of: openTime) { newValue in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            
            businessHoursDay.openTime = dateFormatter.string(from: newValue)
        }
        .onChange(of: closeTime) { newValue in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            
            businessHoursDay.closeTime = dateFormatter.string(from: newValue)
        }
    }
    
    @ViewBuilder
    var dayView: some View {
        VStack {
            HStack {
                Text(businessHoursDay.day)
                    .font(Font(AppFont.archivo(.bold, ofSize: 17)))
                    .padding(.horizontal, 5)
                    .background(Color.white)
                
                Spacer()
            }
            
            Spacer()
        }
        .padding(.leading, 10)
    }
    
    @ViewBuilder
    func clockImageView(color: Color) -> some View {
        ZStack {
            color
            
            Image("clock")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(5)
        }
        .frame(width: 34, height: 32)
    }
    
    @ViewBuilder
    func dayView(day: BusinessHoursDay) -> some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                Text("Hours")
                    .font(Font(AppFont.archivo(.regular, ofSize: 16)))
                    .foregroundColor(Color(R.color.c141414() ?? .black))
                
                arrowView(name: "arrow-down")
                    .padding(.top, 2)
                    .opacity(businessHoursDay.isOpen ? 1.0 : 0.0)
            }
            
            Text(day.formatted)
                .font(Font(AppFont.archivo(.regular, ofSize: 13)))
                .foregroundColor(Color(R.color.c1B34CE() ?? .black))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    @ViewBuilder
    func arrowView(name: String) -> some View {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 18, height: 7)
    }
}
