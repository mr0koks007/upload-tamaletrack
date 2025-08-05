import Foundation
import SwiftUI

class EquipmentCleaningLogManager: ObservableObject {
    @Published private(set) var items: [EquipmentCleaningLog] = [] {
        didSet {
            saveData()
            print("🧽 EquipmentCleaningLog updated: \(items.count) entry(ies)")
        }
    }

    private let storageKey = "EquipmentCleaningLogEntries"

    // MARK: - Init
    init() {
        loadData()
        if items.isEmpty {
         //   loadSampleData()
        }
    }

    // MARK: - Load
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([EquipmentCleaningLog].self, from: data) {
            self.items = decoded
        }
    }

    // MARK: - Save
    private func saveData() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    // MARK: - CRUD
    func addOrUpdate(_ log: EquipmentCleaningLog) {
        if let index = items.firstIndex(where: { $0.id == log.id }) {
            items[index] = log
        } else {
            items.append(log)
        }
    }

    func delete(log: EquipmentCleaningLog) {
        if let index = items.firstIndex(where: { $0.id == log.id }) {
            items.remove(at: index)
        }
    }

    func clearAll() {
        items.removeAll()
    }

    // MARK: - Sample Data
    private func loadSampleData() {
        items = [
            EquipmentCleaningLog(
                equipmentName: "Tamale Steamer Unit A",
                cleanedDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                cleanedBy: "Lupita",
                cleaningProductsUsed: "EcoSafe Degreaser, SteamJet",
                sanitationLevel: "High",
                issuesFound: "Minor residue at base",
                isSanitized: true,
                requiresRepairs: false,
                repairNotes: nil,
                cleaningDurationMinutes: 40,
                nextScheduledCleaning: Calendar.current.date(byAdding: .day, value: 7, to: Date())!,
                approvedBy: "Supervisor Ana",
                cleaningFrequencyDays: 7,
                equipmentMaterial: "Steel",
                postCleanSmellCheck: true,
                tempCheckPassed: true
            ),
            EquipmentCleaningLog(
                equipmentName: "Mixing Bowl Station B",
                cleanedDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                cleanedBy: "Jorge",
                cleaningProductsUsed: "Citrus Enzyme Cleaner",
                sanitationLevel: "Moderate",
                issuesFound: "Handle cracked, leaking seal",
                isSanitized: true,
                requiresRepairs: true,
                repairNotes: "Schedule maintenance next week.",
                cleaningDurationMinutes: 30,
                nextScheduledCleaning: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
                approvedBy: "Supervisor Mateo",
                cleaningFrequencyDays: 5,
                equipmentMaterial: "Aluminum",
                postCleanSmellCheck: true,
                tempCheckPassed: false
            )
        ]
        saveData()
    }
}
