import Foundation
import SwiftUI

class IngredientStockManager: ObservableObject {
    @Published private(set) var items: [IngredientStockItem] = [] {
        didSet {
            saveData()
            print("🧂 IngredientStock updated: \(items.count) item(s)")
        }
    }

    private let storageKey = "IngredientStockEntries"

    // MARK: - Init
    init() {
        loadData()
        if items.isEmpty {
           // loadSampleData()
        }
    }

    // MARK: - Load
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([IngredientStockItem].self, from: data) {
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
    func addOrUpdate(_ item: IngredientStockItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        } else {
            items.append(item)
        }
    }

    func delete(item: IngredientStockItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items.remove(at: index)
        }
    }

    func clearAll() {
        items.removeAll()
    }

    // MARK: - Sample Data
    private func loadSampleData() {
        items = [
            IngredientStockItem(
                name: "Corn Flour",
                quantityAvailable: 25.0,
                unit: "kg",
                isPerishable: false,
                expiryDate: nil,
                supplierName: "Harina Mills",
                restockThreshold: 5.0,
                autoReorderEnabled: true,
                lastRestockedDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                receivedBy: "Carlos",
                storageLocation: "Pantry Shelf 3",
                reorderStatus: "Stock OK",
                costPerUnit: 1.25,
                stockNotes: "Stored in airtight container",
                organicCertified: true,
                batchLotCode: "CF-0327-HM",
                stockVerifiedBy: "Lucia",
                moistureSensitive: false
            ),
            IngredientStockItem(
                name: "Fresh Jalapeños",
                quantityAvailable: 4.5,
                unit: "kg",
                isPerishable: true,
                expiryDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
                supplierName: "GreenFarm Supply",
                restockThreshold: 2.0,
                autoReorderEnabled: false,
                lastRestockedDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                receivedBy: "Mateo",
                storageLocation: "Refrigerated Bin A",
                reorderStatus: "Monitor Closely",
                costPerUnit: 3.40,
                stockNotes: "Use oldest stock first",
                organicCertified: false,
                batchLotCode: "JLP-9053-GF",
                stockVerifiedBy: "Diana",
                moistureSensitive: true
            )
        ]
        saveData()
    }
}
