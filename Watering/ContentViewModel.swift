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
    @Published var nextWateringDateString: String = ""
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
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]) { _ , _ in }
    }
    
    private func handlePublished() {
        $isSummer
            .removeDuplicates()
            .dropFirst()
            .sink(receiveValue: { [weak self] isSummer in
                guard let self else { return }
                self.daysForWatering = isSummer ? "Every other day" : "Once a week"
                UserDefaults.standard.setValue(isSummer, forKey: self.isSummerKey)
                self.isSummer = isSummer
                calculateNextWatering()
            }).store(in: &cancellables)
        
        $wateringDate
            .removeDuplicates()
            .dropFirst()
            .sink(receiveValue: { [weak self] wateringDate in
                guard let self else { return }
                UserDefaults.standard.setValue(wateringDate, forKey: wateringDateKey)
                self.wateringDate = wateringDate
                calculateNextWatering()
            }).store(in: &cancellables)
    }
    
    private func calculateNextWatering() {
        if let nextWateringDate = Calendar.current.date(
            byAdding: .day,
            value: isSummer ? 2 : 7,
            to: wateringDate
        ) {
            nextWateringDateString = "Next watering date is \(nextWateringDate.formatted(date: .long, time: .omitted))"
            scheduleNotificationOnSpecific(date: nextWateringDate)
        }
    }
    
    private func scheduleNotificationOnSpecific(date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Watering App"
        content.body = "Please water the plants"
        content.sound = .default
        
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.hour = 8
        components.minute = 30
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.add(request) { _ in }
    }
}
