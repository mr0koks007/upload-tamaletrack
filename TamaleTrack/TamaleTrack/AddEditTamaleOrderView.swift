import SwiftUI

struct AddEditTamaleOrderView: View {
    @Binding var order: TamaleOrder?
    @ObservedObject var manager: TamaleOrderManager
    @Environment(\.presentationMode) var presentationMode

    // MARK: - Form State
    @State private var customerName = ""
    @State private var contactNumber = ""
    @State private var orderDate = Date()
    @State private var deliveryDate: Date? = nil
    @State private var fillingType = ""
    @State private var quantityOrdered = ""
    @State private var wrappingType = "Paper Wrap"
    @State private var spiceLevel = "Mild"
    @State private var deliveryMethod = "Pickup"
    @State private var address = ""
    @State private var paymentStatus = "Pending"
    @State private var totalAmount = ""
    @State private var promoCodeUsed = ""
    @State private var orderTakenBy = ""
    @State private var deliveryPerson = ""
    @State private var feedbackRating = ""
    @State private var feedbackNotes = ""
    @State private var isRepeatCustomer = false
    @State private var specialInstructions = ""
    @State private var orderSource = "Phone"
    @State private var deliveryStatus = "Pending"
    @State private var packagingType = "Paper Wrap"
    @State private var estimatedPrepTimeMinutes = ""

    // MARK: - Picker Options
    private let spiceOptions = ["Mild", "Medium", "Hot"]
    private let paymentStatuses = ["Paid", "Pending", "Partial"]
    private let deliveryMethods = ["Pickup", "Home Delivery"]
    private let orderSources = ["Phone", "WhatsApp", "Street Stall"]
    private let deliveryStatuses = ["Pending", "Out for Delivery", "Delivered"]
    private let packagingOptions = ["Paper Wrap", "Foil", "Eco Box"]
    private let wrappingOptions = ["Paper Wrap", "Foil", "Eco Box"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Customer Info")) {
                    TextField("Customer Name", text: $customerName)
                    TextField("Contact Number", text: $contactNumber)
                        .keyboardType(.phonePad)
                    Toggle("Repeat Customer", isOn: $isRepeatCustomer)
                }

                Section(header: Text("Order Details")) {
                    TextField("Filling Type", text: $fillingType)
                    TextField("Quantity", text: $quantityOrdered)
                        .keyboardType(.numberPad)
                    Picker("Wrapping Type", selection: $wrappingType) {
                        ForEach(wrappingOptions, id: \.self) { Text($0) }
                    }
                    Picker("Spice Level", selection: $spiceLevel) {
                        ForEach(spiceOptions, id: \.self) { Text($0) }
                    }
                    Picker("Packaging Type", selection: $packagingType) {
                        ForEach(packagingOptions, id: \.self) { Text($0) }
                    }
                    TextField("Prep Time (min)", text: $estimatedPrepTimeMinutes)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Delivery")) {
                    Picker("Method", selection: $deliveryMethod) {
                        ForEach(deliveryMethods, id: \.self) { Text($0) }
                    }
                    DatePicker("Order Date", selection: $orderDate, displayedComponents: .date)
                    DatePicker("Delivery Date", selection: Binding(
                        get: { deliveryDate ?? Date() },
                        set: { deliveryDate = $0 }
                    ), displayedComponents: .date)

                    TextField("Address", text: $address)
                }

                Section(header: Text("Staff & Status")) {
                    TextField("Order Taken By", text: $orderTakenBy)
                    TextField("Delivery Person", text: $deliveryPerson)
                    Picker("Delivery Status", selection: $deliveryStatus) {
                        ForEach(deliveryStatuses, id: \.self) { Text($0) }
                    }
                    Picker("Order Source", selection: $orderSource) {
                        ForEach(orderSources, id: \.self) { Text($0) }
                    }
                    Picker("Payment Status", selection: $paymentStatus) {
                        ForEach(paymentStatuses, id: \.self) { Text($0) }
                    }
                }

                Section(header: Text("Payment & Promo")) {
                    TextField("Total Amount", text: $totalAmount)
                        .keyboardType(.decimalPad)
                    TextField("Promo Code", text: $promoCodeUsed)
                }

                Section(header: Text("Feedback & Notes")) {
                    TextField("Feedback Rating (1-5)", text: $feedbackRating)
                        .keyboardType(.numberPad)
                    TextField("Feedback Notes", text: $feedbackNotes)
                    TextField("Special Instructions", text: $specialInstructions)
                }
            }
            .navigationBarTitle(order == nil ? "Add Order" : "Edit Order", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveEntry()
                }
            )
            .onAppear {
                populateForm()
            }
        }
    }

    // MARK: - Populate
    private func populateForm() {
        guard let existing = order else { return }

        customerName = existing.customerName
        contactNumber = existing.contactNumber
        orderDate = existing.orderDate
        deliveryDate = existing.deliveryDate
        fillingType = existing.fillingType
        quantityOrdered = "\(existing.quantityOrdered)"
        wrappingType = existing.wrappingType
        spiceLevel = existing.spiceLevel
        deliveryMethod = existing.deliveryMethod
        address = existing.address ?? ""
        paymentStatus = existing.paymentStatus
        totalAmount = "\(existing.totalAmount)"
        promoCodeUsed = existing.promoCodeUsed ?? ""
        orderTakenBy = existing.orderTakenBy
        deliveryPerson = existing.deliveryPerson ?? ""
        feedbackRating = existing.feedbackRating.map { "\($0)" } ?? ""
        feedbackNotes = existing.feedbackNotes ?? ""
        isRepeatCustomer = existing.isRepeatCustomer
        specialInstructions = existing.specialInstructions ?? ""
        orderSource = existing.orderSource
        deliveryStatus = existing.deliveryStatus
        packagingType = existing.packagingType
        estimatedPrepTimeMinutes = "\(existing.estimatedPrepTimeMinutes)"
    }

    // MARK: - Save
    private func saveEntry() {
        guard !customerName.isEmpty, !fillingType.isEmpty, !orderTakenBy.isEmpty else { return }

        let newOrder = TamaleOrder(
            id: order?.id ?? UUID(),
            customerName: customerName,
            contactNumber: contactNumber,
            orderDate: orderDate,
            deliveryDate: deliveryDate,
            fillingType: fillingType,
            quantityOrdered: Int(quantityOrdered) ?? 0,
            wrappingType: wrappingType,
            spiceLevel: spiceLevel,
            deliveryMethod: deliveryMethod,
            address: address.isEmpty ? nil : address,
            paymentStatus: paymentStatus,
            totalAmount: Double(totalAmount) ?? 0.0,
            promoCodeUsed: promoCodeUsed.isEmpty ? nil : promoCodeUsed,
            orderTakenBy: orderTakenBy,
            deliveryPerson: deliveryPerson.isEmpty ? nil : deliveryPerson,
            feedbackRating: Int(feedbackRating),
            feedbackNotes: feedbackNotes.isEmpty ? nil : feedbackNotes,
            isRepeatCustomer: isRepeatCustomer,
            specialInstructions: specialInstructions.isEmpty ? nil : specialInstructions,
            orderSource: orderSource,
            deliveryStatus: deliveryStatus,
            packagingType: packagingType,
            estimatedPrepTimeMinutes: Int(estimatedPrepTimeMinutes) ?? 0
        )

        manager.addOrUpdate(newOrder)
        presentationMode.wrappedValue.dismiss()
    }
}
