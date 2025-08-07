import SwiftUI

struct AddEditEquipmentCleaningLogView: View {
    @Binding var log: EquipmentCleaningLog?
    @ObservedObject var manager: EquipmentCleaningLogManager
    @Environment(\.presentationMode) var presentationMode

    // MARK: - Form Fields
    @State private var equipmentName = ""
    @State private var cleanedDate = Date()
    @State private var cleanedBy = ""
    @State private var cleaningProductsUsed = ""
    @State private var sanitationLevel = "High"
    @State private var issuesFound = ""
    @State private var isSanitized = true
    @State private var requiresRepairs = false
    @State private var repairNotes = ""
    @State private var cleaningDurationMinutes = ""
    @State private var nextScheduledCleaning = Date()
    @State private var approvedBy = ""
    @State private var cleaningFrequencyDays = ""
    @State private var equipmentMaterial = "Steel"
    @State private var postCleanSmellCheck = true
    @State private var tempCheckPassed = true

    private let levels = ["High", "Moderate", "Low"]
    private let materials = ["Steel", "Aluminum", "Plastic"]

    // MARK: - View
    var body: some View {
        NavigationView {
            Form {
                Section(header: Label("Equipment Info", systemImage: "gearshape")) {
                    TextField("Equipment Name", text: $equipmentName)
                    TextField("Cleaned By", text: $cleanedBy)
                    DatePicker("Cleaned Date", selection: $cleanedDate, displayedComponents: .date)
                    
                    Picker("Sanitation Level", selection: $sanitationLevel) {
                        ForEach(levels, id: \.self) { level in
                            Text(level).tag(level)
                        }
                    }

                    Picker("Material", selection: $equipmentMaterial) {
                        ForEach(materials, id: \.self) { material in
                            Text(material).tag(material)
                        }
                    }
                }

                Section(header: Label("Cleaning Details", systemImage: "sparkles")) {
                    TextField("Products Used", text: $cleaningProductsUsed)
                    TextField("Issues Found", text: $issuesFound)
                    TextField("Duration (minutes)", text: $cleaningDurationMinutes)
                        .keyboardType(.numberPad)

                    Toggle("Is Sanitized", isOn: $isSanitized)
                    Toggle("Smell Check Passed", isOn: $postCleanSmellCheck)
                    Toggle("Temp Check Passed", isOn: $tempCheckPassed)
                }

                Section(header: Label("Scheduling & Approval", systemImage: "calendar")) {
                    DatePicker("Next Scheduled Cleaning", selection: $nextScheduledCleaning, displayedComponents: .date)
                    TextField("Cleaning Frequency (days)", text: $cleaningFrequencyDays)
                        .keyboardType(.numberPad)
                    TextField("Approved By", text: $approvedBy)
                }

                Section(header: Label("Repair", systemImage: "wrench.and.screwdriver")) {
                    Toggle("Requires Repairs", isOn: $requiresRepairs)
                    if requiresRepairs {
                        TextField("Repair Notes", text: $repairNotes)
                    }
                }
            }
            .navigationBarTitle(log == nil ? "Add Cleaning Log" : "Edit Cleaning Log", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveEntry()
                }
            )
            .onAppear(perform: populateForm)
        }
    }

    // MARK: - Populate Form
    private func populateForm() {
        guard let l = log else { return }
        equipmentName = l.equipmentName
        cleanedDate = l.cleanedDate
        cleanedBy = l.cleanedBy
        cleaningProductsUsed = l.cleaningProductsUsed
        sanitationLevel = levels.contains(l.sanitationLevel) ? l.sanitationLevel : levels[0]
        issuesFound = l.issuesFound ?? ""
        isSanitized = l.isSanitized
        requiresRepairs = l.requiresRepairs
        repairNotes = l.repairNotes ?? ""
        cleaningDurationMinutes = "\(l.cleaningDurationMinutes)"
        nextScheduledCleaning = l.nextScheduledCleaning
        approvedBy = l.approvedBy
        cleaningFrequencyDays = "\(l.cleaningFrequencyDays)"
        equipmentMaterial = materials.contains(l.equipmentMaterial) ? l.equipmentMaterial : materials[0]
        postCleanSmellCheck = l.postCleanSmellCheck
        tempCheckPassed = l.tempCheckPassed
    }

    // MARK: - Save Entry
    private func saveEntry() {
        guard !equipmentName.isEmpty,
              !cleanedBy.isEmpty,
              !cleaningProductsUsed.isEmpty,
              !cleaningDurationMinutes.isEmpty,
              !cleaningFrequencyDays.isEmpty,
              !approvedBy.isEmpty,
              Int(cleaningDurationMinutes) != nil,
              Int(cleaningFrequencyDays) != nil else {
            return
        }

        let updatedLog = EquipmentCleaningLog(
            id: log?.id ?? UUID(),
            equipmentName: equipmentName,
            cleanedDate: cleanedDate,
            cleanedBy: cleanedBy,
            cleaningProductsUsed: cleaningProductsUsed,
            sanitationLevel: sanitationLevel,
            issuesFound: issuesFound.isEmpty ? nil : issuesFound,
            isSanitized: isSanitized,
            requiresRepairs: requiresRepairs,
            repairNotes: repairNotes.isEmpty ? nil : repairNotes,
            cleaningDurationMinutes: Int(cleaningDurationMinutes) ?? 0,
            nextScheduledCleaning: nextScheduledCleaning,
            approvedBy: approvedBy,
            cleaningFrequencyDays: Int(cleaningFrequencyDays) ?? 0,
            equipmentMaterial: equipmentMaterial,
            postCleanSmellCheck: postCleanSmellCheck,
            tempCheckPassed: tempCheckPassed
        )

        manager.addOrUpdate(updatedLog)
        presentationMode.wrappedValue.dismiss()
    }
}
