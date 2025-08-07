import Foundation
import SwiftUI

class TamaleOrderManager: ObservableObject {
    @Published private(set) var items: [TamaleOrder] = [] {
        didSet {
            saveData()
            print("📦 TamaleOrder updated: \(items.count) order(s)")
        }
    }

    private let storageKey = "TamaleOrderEntries"

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
           let decoded = try? JSONDecoder().decode([TamaleOrder].self, from: data) {
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
    func addOrUpdate(_ order: TamaleOrder) {
        if let index = items.firstIndex(where: { $0.id == order.id }) {
            items[index] = order
        } else {
            items.append(order)
        }
    }

    func delete(order: TamaleOrder) {
        if let index = items.firstIndex(where: { $0.id == order.id }) {
            items.remove(at: index)
        }
    }

    func clearAll() {
        items.removeAll()
    }

    // MARK: - Sample Data
    private func loadSampleData() {
        items = [
            TamaleOrder(
                customerName: "María López",
                contactNumber: "123-456-7890",
                orderDate: Date(),
                deliveryDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
                fillingType: "Beef Mole",
                quantityOrdered: 24,
                wrappingType: "Foil",
                spiceLevel: "Medium",
                deliveryMethod: "Home Delivery",
                address: "456 Fiesta Lane, Puebla",
                paymentStatus: "Paid",
                totalAmount: 72.0,
                promoCodeUsed: "TAMALE10",
                orderTakenBy: "Lucia",
                deliveryPerson: "Carlos",
                feedbackRating: 5,
                feedbackNotes: "Absolutely delicious!",
                isRepeatCustomer: true,
                specialInstructions: "Extra mole on the side.",
                orderSource: "WhatsApp",
                deliveryStatus: "Delivered",
                packagingType: "Eco Box",
                estimatedPrepTimeMinutes: 90
            ),
            TamaleOrder(
                customerName: "Jorge Rivera",
                contactNumber: "555-987-6543",
                orderDate: Date(),
                deliveryDate: nil,
                fillingType: "Vegetarian",
                quantityOrdered: 12,
                wrappingType: "Paper Wrap",
                spiceLevel: "Mild",
                deliveryMethod: "Pickup",
                address: nil,
                paymentStatus: "Pending",
                totalAmount: 30.0,
                promoCodeUsed: nil,
                orderTakenBy: "Manuel",
                deliveryPerson: nil,
                feedbackRating: nil,
                feedbackNotes: nil,
                isRepeatCustomer: false,
                specialInstructions: nil,
                orderSource: "Street Stall",
                deliveryStatus: "Pending",
                packagingType: "Paper Wrap",
                estimatedPrepTimeMinutes: 45
            )
        ]
        saveData()
    }
}
