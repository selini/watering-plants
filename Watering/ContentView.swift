//
//  ContentView.swift
//  Watering
//
//  Created by Selini Kyriazidou on 18/6/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    var body: some View {
        VStack() {
            HStack() {
                Text("Is Summer?")
                    .font(.largeTitle)
                VStack {
                    Toggle("", isOn: $viewModel.isSummer)
                }
            }
           
            Text(viewModel.daysForWatering)
            
            DatePicker(selection: $viewModel.wateringDate, in: ...Date.now, displayedComponents: .date) {
                Text("Watering Date")
            }
            Text(viewModel.wateringDateString)
            Spacer()
        }
        .padding()
        .onAppear(perform: {
            viewModel.getSavedValues()
        })
    }
}

#Preview {
    ContentView()
}
