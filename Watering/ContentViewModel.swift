//
//  ContentViewModel.swift
//  Watering
//
//  Created by Selini Kyriazidou on 18/6/25.
//
import SwiftUI
import Combine

class ContentViewModel: ObservableObject {
    @Published var isSummer: Bool = false
    @Published var wateringDate: Date = .now
    @Published var wateringDateString: String = ""
    @Published var daysForWatering = ""
    
    private let isSummerKey = "summer"
    private let wateringDateKey = "wateringDate"
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        handlePublished()
    }
    
    func getSavedValues() {
        isSummer = UserDefaults.standard.bool(forKey: isSummerKey)
        wateringDate = UserDefaults.standard.object(forKey: wateringDateKey) as? Date ?? .now
    }
    
    private func handlePublished() {
        $isSummer
            .removeDuplicates()
            .dropFirst()
            .sink(receiveValue: { [weak self] value in
            guard let self else { return }
            if value {
                self.daysForWatering = "Every other day"
            } else {
                self.daysForWatering = "Once a week"
            }
            UserDefaults.standard.setValue(value, forKey: self.isSummerKey)
        }).store(in: &cancellables)
         
        $wateringDate
            .removeDuplicates()
            .dropFirst()
            .sink(receiveValue: { [weak self] value in
             guard let self else { return }
             UserDefaults.standard.setValue(value, forKey: wateringDateKey)
             wateringDateString = "Last watering date is \(value.formatted(date: .long, time: .omitted))"
          }).store(in: &cancellables)
    }
}
