import SwiftUI

struct AddEditTamaleBatchLogView: View {
    @ObservedObject var manager: TamaleBatchLogManager
    @Binding var log: TamaleBatchLog?
    @Environment(\.presentationMode) var presentationMode

    // MARK: - Form State
    @State private var datePrepared = Date()
    @State private var fillingType = ""
    @State private var quantityMade = ""
    @State private var preparationTimeMinutes = ""
    @State private var masaBrand = ""
    @State private var masaHydrationRatio = ""
    @State private var wrappingType = "Corn husk"
    @State private var spiceLevel = "Mild"
    @State private var cookingMethod = "Steamed"
    @State private var cookDurationMinutes = ""
    @State private var batchSupervisor = ""
    @State private var tasteTested = false
    @State private var qualityNotes = ""
    @State private var allergens: [String] = []
    @State private var allergenInput = ""
    @State private var isForPreorder = false
    @State private var shelfLifeDays = ""
    @State private var regionalStyle = "Oaxacan"
    @State private var wrappingSource = "Local Market"
    @State private var humidityLevelDuringPrep = ""
    @State private var electricityUsedKwh = ""

    private let spiceLevels = ["Mild", "Medium", "Hot"]
    private let cookingMethods = ["Steamed", "Oven-Baked"]
    private let wrappingTypes = ["Corn husk", "Banana leaf", "Plantain leaf"]
    private let regionalStyles = ["Oaxacan", "Salvadoran", "Yucateco", "Tex-Mex"]
    private let wrappingSources = ["Local Market", "Farm Source", "Store-Bought"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Batch Info")) {
                    TextField("Filling Type", text: $fillingType)
                    DatePicker("Prepared Date", selection: $datePrepared, displayedComponents: .date)
                    TextField("Quantity Made", text: $quantityMade).keyboardType(.numberPad)
                    TextField("Prep Time (min)", text: $preparationTimeMinutes).keyboardType(.numberPad)
                }

                Section(header: Text("Ingredients & Cooking")) {
                    TextField("Masa Brand", text: $masaBrand)
                    TextField("Hydration Ratio", text: $masaHydrationRatio)
                    Picker("Wrapping Type", selection: $wrappingType) {
                        ForEach(wrappingTypes, id: \.self) { Text($0) }
                    }
                    Picker("Spice Level", selection: $spiceLevel) {
                        ForEach(spiceLevels, id: \.self) { Text($0) }
                    }
                    Picker("Cooking Method", selection: $cookingMethod) {
                        ForEach(cookingMethods, id: \.self) { Text($0) }
                    }
                    TextField("Cook Duration (min)", text: $cookDurationMinutes).keyboardType(.numberPad)
                }

                Section(header: Text("Supervisor & Quality")) {
                    TextField("Supervisor", text: $batchSupervisor)
                    Toggle("Taste Tested", isOn: $tasteTested)
                    TextField("Quality Notes", text: $qualityNotes)
                }

                Section(header: Text("Allergens")) {
                    HStack {
                        TextField("Add Allergen", text: $allergenInput)
                        Button(action: {
                            if !allergenInput.isEmpty {
                                allergens.append(allergenInput)
                                allergenInput = ""
                            }
                        }) {
                            Image(systemName: "plus.circle.fill").foregroundColor(.green)
                        }
                    }
                    ForEach(allergens, id: \.self) { allergen in
                        HStack {
                            Text(allergen)
                            Spacer()
                            Button {
                                if let index = allergens.firstIndex(of: allergen) {
                                    allergens.remove(at: index)
                                }
                            } label: {
                                Image(systemName: "minus.circle.fill").foregroundColor(.red)
                            }
                        }
                    }
                }

                Section(header: Text("Logistics")) {
                    Toggle("For Preorder", isOn: $isForPreorder)
                    TextField("Shelf Life (days)", text: $shelfLifeDays).keyboardType(.numberPad)
                    Picker("Regional Style", selection: $regionalStyle) {
                        ForEach(regionalStyles, id: \.self) { Text($0) }
                    }
                    Picker("Wrapping Source", selection: $wrappingSource) {
                        ForEach(wrappingSources, id: \.self) { Text($0) }
                    }
                    TextField("Humidity Level (%)", text: $humidityLevelDuringPrep).keyboardType(.decimalPad)
                    TextField("Electricity Used (kWh)", text: $electricityUsedKwh).keyboardType(.decimalPad)
                }
            }
            .navigationBarTitle(log == nil ? "Add Batch" : "Edit Batch", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save", action: saveEntry)
            )
            .onAppear(perform: populateForm)
        }
    }

    // MARK: - Populate Form
    private func populateForm() {
        guard let log = log else { return }

        datePrepared = log.datePrepared
        fillingType = log.fillingType
        quantityMade = "\(log.quantityMade)"
        preparationTimeMinutes = "\(log.preparationTimeMinutes)"
        masaBrand = log.masaBrand
        masaHydrationRatio = log.masaHydrationRatio
        wrappingType = log.wrappingType
        spiceLevel = log.spiceLevel
        cookingMethod = log.cookingMethod
        cookDurationMinutes = "\(log.cookDurationMinutes)"
        batchSupervisor = log.batchSupervisor
        tasteTested = log.tasteTested
        qualityNotes = log.qualityNotes ?? ""
        allergens = log.allergens
        isForPreorder = log.isForPreorder
        shelfLifeDays = "\(log.shelfLifeDays)"
        regionalStyle = log.regionalStyle
        wrappingSource = log.wrappingSource
        humidityLevelDuringPrep = "\(log.humidityLevelDuringPrep)"
        electricityUsedKwh = "\(log.electricityUsedKwh)"
    }

    // MARK: - Save Entry
    private func saveEntry() {
        guard !fillingType.isEmpty, !batchSupervisor.isEmpty else { return }

        let updated = TamaleBatchLog(
            id: log?.id ?? UUID(),
            datePrepared: datePrepared,
            fillingType: fillingType,
            quantityMade: Int(quantityMade) ?? 0,
            preparationTimeMinutes: Int(preparationTimeMinutes) ?? 0,
            masaBrand: masaBrand,
            masaHydrationRatio: masaHydrationRatio,
            wrappingType: wrappingType,
            spiceLevel: spiceLevel,
            cookingMethod: cookingMethod,
            cookDurationMinutes: Int(cookDurationMinutes) ?? 0,
            batchSupervisor: batchSupervisor,
            tasteTested: tasteTested,
            qualityNotes: qualityNotes.isEmpty ? nil : qualityNotes,
            allergens: allergens,
            isForPreorder: isForPreorder,
            shelfLifeDays: Int(shelfLifeDays) ?? 0,
            regionalStyle: regionalStyle,
            wrappingSource: wrappingSource,
            humidityLevelDuringPrep: Double(humidityLevelDuringPrep) ?? 0.0,
            electricityUsedKwh: Double(electricityUsedKwh) ?? 0.0
        )

        manager.addOrUpdate(updated)
        presentationMode.wrappedValue.dismiss()
    }
}
