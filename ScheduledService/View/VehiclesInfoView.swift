//
//  VehiclesInfoView.swift
//  Motorvate
//
//  Created by Motorvate on 1.4.23..
//  Copyright © 2023 motorvate. All rights reserved.
//

import SwiftUI

class VehiclesInfoViewModel: ObservableObject {
    @Published var selectedIndex = -1
    
    var shopSize: Int? {
        switch selectedIndex {
        case -1: return nil
        default: return selectedIndex + 1
        }
    }
}

struct VehiclesInfoView: View {
    @ObservedObject var viewModel: VehiclesInfoViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 12) {
                Text("How many vehicles can be serviced at the same time?")
                    .font(Font(AppFont.archivo(.semiBold, ofSize: 18)))
                    .foregroundColor(Color(R.color.c141414() ?? .black))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                VStack(alignment: .leading) {
                    HStack(spacing: 10) {
                        ChoiceButton(title: "No more than 1", background: ChoiceButtontyle.background(isSelected: viewModel.selectedIndex == 0), action: {
                            viewModel.selectedIndex = 0
                        })
                        
                        ChoiceButton(title: "2 Vehicles", background: ChoiceButtontyle.background(isSelected: viewModel.selectedIndex == 1), action: {
                            viewModel.selectedIndex = 1
                        })
                    }
                    
                    HStack(spacing: 10) {
                        ChoiceButton(title: "3 Vehicles", background: ChoiceButtontyle.background(isSelected: viewModel.selectedIndex == 2), action: {
                            viewModel.selectedIndex = 2
                        })
                        
                        ChoiceButton(title: "4 Vehicles", background: ChoiceButtontyle.background(isSelected: viewModel.selectedIndex == 3), action: {
                            viewModel.selectedIndex = 3
                        })
                        
                        ChoiceButton(title: "5 Vehicles", background: ChoiceButtontyle.background(isSelected: viewModel.selectedIndex == 4), action: {
                            viewModel.selectedIndex = 4
                        })
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .onAppear {
            if let shopSize = UserSession.shared.shop?.shopSize {
                viewModel.selectedIndex = shopSize - 1
            }
        }
    }
}
