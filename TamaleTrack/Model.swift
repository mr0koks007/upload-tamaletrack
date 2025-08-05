import Foundation
import SwiftUI

// MARK: - 1. TamaleBatchLog (Enhanced with 4 new fields)
struct TamaleBatchLog: Identifiable, Codable {
    var id = UUID()
    var datePrepared: Date
    var fillingType: String                   // e.g., Chicken, Pork, Sweet
    var quantityMade: Int
    var preparationTimeMinutes: Int
    var masaBrand: String
    var masaHydrationRatio: String            // e.g., "2:1 Water:Masa"
    var wrappingType: String                  // e.g., Corn husk, Banana leaf
    var spiceLevel: String                    // e.g., Mild, Medium, Hot
    var cookingMethod: String                 // Steamed, Oven-Baked
    var cookDurationMinutes: Int
    var batchSupervisor: String
    var tasteTested: Bool
    var qualityNotes: String?
    var allergens: [String]                   // e.g., Nuts, Dairy
    var isForPreorder: Bool
    var shelfLifeDays: Int
    var regionalStyle: String                 // e.g., Oaxacan, Salvadoran, Yucateco
    var wrappingSource: String                // Farm Source, Store-Bought, Market
    var humidityLevelDuringPrep: Double       // e.g., 45.0%
    var electricityUsedKwh: Double            // Power consumption tracking
}

// MARK: - 2. TamaleOrder (Enhanced with 4 new fields)
struct TamaleOrder: Identifiable, Codable {
    var id = UUID()
    var customerName: String
    var contactNumber: String
    var orderDate: Date
    var deliveryDate: Date?
    var fillingType: String
    var quantityOrdered: Int
    var wrappingType: String
    var spiceLevel: String
    var deliveryMethod: String
    var address: String?
    var paymentStatus: String
    var totalAmount: Double
    var promoCodeUsed: String?
    var orderTakenBy: String
    var deliveryPerson: String?
    var feedbackRating: Int?
    var feedbackNotes: String?
    var isRepeatCustomer: Bool
    var specialInstructions: String?
    var orderSource: String                   // e.g., Phone, WhatsApp, Street Stall
    var deliveryStatus: String                // Pending, Out for Delivery, Delivered
    var packagingType: String                 // Paper Wrap, Foil, Eco Box
    var estimatedPrepTimeMinutes: Int
}

// MARK: - 3. IngredientStockItem (Enhanced with 4 new fields)
struct IngredientStockItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var quantityAvailable: Double
    var unit: String
    var isPerishable: Bool
    var expiryDate: Date?
    var supplierName: String?
    var restockThreshold: Double
    var autoReorderEnabled: Bool
    var lastRestockedDate: Date
    var receivedBy: String
    var storageLocation: String
    var reorderStatus: String
    var costPerUnit: Double
    var stockNotes: String?
    var organicCertified: Bool                // For health-conscious kitchens
    var batchLotCode: String                  // Traceability
    var stockVerifiedBy: String               // Double-checking restock
    var moistureSensitive: Bool              // Storage sensitivity
}

// MARK: - 4. EquipmentCleaningLog (Enhanced with 4 new fields)
struct EquipmentCleaningLog: Identifiable, Codable {
    var id = UUID()
    var equipmentName: String
    var cleanedDate: Date
    var cleanedBy: String
    var cleaningProductsUsed: String
    var sanitationLevel: String
    var issuesFound: String?
    var isSanitized: Bool
    var requiresRepairs: Bool
    var repairNotes: String?
    var cleaningDurationMinutes: Int
    var nextScheduledCleaning: Date
    var approvedBy: String
    var cleaningFrequencyDays: Int            // Recurrence plan
    var equipmentMaterial: String             // Steel, Aluminum, Plastic
    var postCleanSmellCheck: Bool             // Odor verified?
    var tempCheckPassed: Bool                 // Sanitization heat requirement
}



extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64

        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
