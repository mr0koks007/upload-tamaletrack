import Foundation
import SwiftUI

class TamaleBatchLogManager: ObservableObject {
    @Published private(set) var items: [TamaleBatchLog] = [] {
        didSet {
            saveData()
            print("🌽 TamaleBatchLog updated: \(items.count) entry(ies)")
        }
    }

    private let storageKey = "TamaleBatchLogEntries"

    // MARK: - Init
    init() {
        loadData()
        if items.isEmpty {
          //  loadSampleData()
        }
    }

    // MARK: - Load
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([TamaleBatchLog].self, from: data) {
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
    func addOrUpdate(_ log: TamaleBatchLog) {
        if let index = items.firstIndex(where: { $0.id == log.id }) {
            items[index] = log
        } else {
            items.append(log)
        }
    }

    func delete(log: TamaleBatchLog) {
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
            TamaleBatchLog(
                datePrepared: Date(),
                fillingType: "Chicken Verde",
                quantityMade: 120,
                preparationTimeMinutes: 180,
                masaBrand: "Masa Harina Premium",
                masaHydrationRatio: "2:1 Water:Masa",
                wrappingType: "Corn husk",
                spiceLevel: "Medium",
                cookingMethod: "Steamed",
                cookDurationMinutes: 90,
                batchSupervisor: "Lupita",
                tasteTested: true,
                qualityNotes: "Excellent flavor and texture.",
                allergens: ["Dairy"],
                isForPreorder: true,
                shelfLifeDays: 4,
                regionalStyle: "Oaxacan",
                wrappingSource: "Local Market",
                humidityLevelDuringPrep: 48.5,
                electricityUsedKwh: 3.2
            ),
            TamaleBatchLog(
                datePrepared: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                fillingType: "Sweet Pineapple",
                quantityMade: 80,
                preparationTimeMinutes: 120,
                masaBrand: "El Molino Blanco",
                masaHydrationRatio: "1.5:1 Water:Masa",
                wrappingType: "Banana leaf",
                spiceLevel: "Mild",
                cookingMethod: "Oven-Baked",
                cookDurationMinutes: 75,
                batchSupervisor: "Mateo",
                tasteTested: false,
                qualityNotes: "Needs more sweetness next time.",
                allergens: ["Nuts"],
                isForPreorder: false,
                shelfLifeDays: 3,
                regionalStyle: "Salvadoran",
                wrappingSource: "Farm Source",
                humidityLevelDuringPrep: 52.0,
                electricityUsedKwh: 2.6
            )
        ]
        saveData()
    }
}
