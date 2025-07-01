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
        VStack {
            Text("Watering The plants")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            VStack(alignment: .leading) {
                HStack() {
                    Text("Is Summer?")
                        .font(.title)
                    Toggle("", isOn: $viewModel.isSummer  )
                }
                Text(viewModel.daysForWatering)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                VStack(alignment: .leading) {
                    DatePicker(selection: $viewModel.wateringDate, displayedComponents: .date) {
                        Text("Watering Date")
                    }
                    Text(viewModel.nextWateringDateString)
                }
                .padding(.top, 20)
                Spacer()
            }
        }
        .padding()
        .onAppear(perform: {
            viewModel.getSavedValues()
            viewModel.requestNotificationPermission()
        })
    }
}

#Preview {
    ContentView()
}
