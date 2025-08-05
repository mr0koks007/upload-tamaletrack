import SwiftUI

struct AddEditIngredientStockView: View {
    @Binding var item: IngredientStockItem?
    @ObservedObject var manager: IngredientStockManager
    @Environment(\.presentationMode) var presentationMode

    // MARK: - Form State
    @State private var name = ""
    @State private var quantityAvailable = ""
    @State private var unit = "kg"
    @State private var isPerishable = false
    @State private var expiryDate: Date? = nil
    @State private var supplierName = ""
    @State private var restockThreshold = ""
    @State private var autoReorderEnabled = false
    @State private var lastRestockedDate = Date()
    @State private var receivedBy = ""
    @State private var storageLocation = ""
    @State private var reorderStatus = "Stock OK"
    @State private var costPerUnit = ""
    @State private var stockNotes = ""
    @State private var organicCertified = false
    @State private var batchLotCode = ""
    @State private var stockVerifiedBy = ""
    @State private var moistureSensitive = false

    private let unitOptions = ["kg", "g", "lb", "L", "ml"]
    private let statusOptions = ["Stock OK", "Monitor Closely", "Reorder Needed"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Info")) {
                    TextField("Ingredient Name", text: $name)
                    TextField("Quantity Available", text: $quantityAvailable)
                        .keyboardType(.decimalPad)
                    Picker("Unit", selection: $unit) {
                        ForEach(unitOptions, id: \.self) { Text($0) }
                    }
                    TextField("Cost per Unit", text: $costPerUnit)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Storage & Status")) {
                    TextField("Storage Location", text: $storageLocation)
                    Picker("Reorder Status", selection: $reorderStatus) {
                        ForEach(statusOptions, id: \.self) { Text($0) }
                    }
                    Toggle("Perishable", isOn: $isPerishable)
                    if isPerishable {
                        DatePicker("Expiry Date", selection: Binding(
                            get: { expiryDate ?? Date() },
                            set: { expiryDate = $0 }
                        ), displayedComponents: .date)
                    }
                    Toggle("Organic Certified", isOn: $organicCertified)
                    Toggle("Moisture Sensitive", isOn: $moistureSensitive)
                }

                Section(header: Text("Restocking")) {
                    TextField("Restock Threshold", text: $restockThreshold)
                        .keyboardType(.decimalPad)
                    Toggle("Auto Reorder Enabled", isOn: $autoReorderEnabled)
                    DatePicker("Last Restocked", selection: $lastRestockedDate, displayedComponents: .date)
                    TextField("Received By", text: $receivedBy)
                    TextField("Verified By", text: $stockVerifiedBy)
                }

                Section(header: Text("Extra Info")) {
                    TextField("Batch/Lot Code", text: $batchLotCode)
                    TextField("Supplier Name", text: $supplierName)
                    TextField("Notes", text: $stockNotes)
                }
            }
            .navigationBarTitle(item == nil ? "Add Ingredient" : "Edit Ingredient", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save", action: saveEntry)
            )
            .onAppear(perform: populateForm)
        }
    }

    private func populateForm() {
        guard let existing = item else { return }

        name = existing.name
        quantityAvailable = "\(existing.quantityAvailable)"
        unit = existing.unit
        isPerishable = existing.isPerishable
        expiryDate = existing.expiryDate
        supplierName = existing.supplierName ?? ""
        restockThreshold = "\(existing.restockThreshold)"
        autoReorderEnabled = existing.autoReorderEnabled
        lastRestockedDate = existing.lastRestockedDate
        receivedBy = existing.receivedBy
        storageLocation = existing.storageLocation
        reorderStatus = existing.reorderStatus
        costPerUnit = "\(existing.costPerUnit)"
        stockNotes = existing.stockNotes ?? ""
        organicCertified = existing.organicCertified
        batchLotCode = existing.batchLotCode
        stockVerifiedBy = existing.stockVerifiedBy
        moistureSensitive = existing.moistureSensitive
    }

    private func saveEntry() {
        guard !name.isEmpty, !receivedBy.isEmpty else { return }

        let newItem = IngredientStockItem(
            id: item?.id ?? UUID(),
            name: name,
            quantityAvailable: Double(quantityAvailable) ?? 0,
            unit: unit,
            isPerishable: isPerishable,
            expiryDate: expiryDate,
            supplierName: supplierName.isEmpty ? nil : supplierName,
            restockThreshold: Double(restockThreshold) ?? 0,
            autoReorderEnabled: autoReorderEnabled,
            lastRestockedDate: lastRestockedDate,
            receivedBy: receivedBy,
            storageLocation: storageLocation,
            reorderStatus: reorderStatus,
            costPerUnit: Double(costPerUnit) ?? 0,
            stockNotes: stockNotes.isEmpty ? nil : stockNotes,
            organicCertified: organicCertified,
            batchLotCode: batchLotCode,
            stockVerifiedBy: stockVerifiedBy,
            moistureSensitive: moistureSensitive
        )

        manager.addOrUpdate(newItem)
        presentationMode.wrappedValue.dismiss()
    }
}
