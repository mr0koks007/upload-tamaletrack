import SwiftUI

struct TamaleOrderListView: View {
    @ObservedObject var manager: TamaleOrderManager
    @State private var showingAddEdit = false
    @State private var selectedOrder: TamaleOrder? = nil

    var body: some View {
        NavigationView {
            ZStack {
                // Background with subtle gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#F0FFF0"),
                        Color(hex: "#D4E4D4")
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                if manager.items.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "cart.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.init(hex: "#355E3B"))
                        Text("🌮 No tamale orders yet.\nTap + to add a new one.")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 22, weight: .medium, design: .default))
                            .foregroundColor(.init(hex: "#2A4B2F"))
                            .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 30)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(manager.items) { order in
                                OrderCardView(order: order)
                                    .onTapGesture {
                                        selectedOrder = order
                                        showingAddEdit = true
                                    }
                                    .contextMenu {
                                        Button(action: {
                                            withAnimation {
                                                manager.delete(order: order)
                                            }
                                        }) {
                                            Label("Delete", systemImage: "trash.fill")
                                                .foregroundColor(.init(hex: "#B22222"))
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                    }
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            selectedOrder = nil
                            showingAddEdit = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 28, weight: .bold, design: .default))
                                .frame(width: 64, height: 64)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(hex: "#556B2F"),
                                            Color(hex: "#8FBC8F")
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .foregroundColor(.init(hex: "#F5F5F5"))
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 4)
                        }
                        .padding(.all, 22)
                    }
                }
            }
            .navigationBarTitle("Tamale Orders", displayMode: .large)
            .sheet(isPresented: $showingAddEdit) {
                AddEditTamaleOrderView(order: $selectedOrder, manager: manager)
            }
        }
    }
}

struct OrderCardView: View {
    let order: TamaleOrder

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Text(order.customerName)
                    .font(.system(size: 22, weight: .bold, design: .default))
                    .foregroundColor(.init(hex: "#F5F5F5"))
                Spacer()
                Image(systemName: order.isRepeatCustomer ? "repeat.circle" : "cart.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.init(hex: "#FFD700"))
            }
            
            Divider()
                .background(Color(hex: "#F5F5F5").opacity(0.4))
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Label(order.orderDate.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                    Label(order.orderTakenBy, systemImage: "person.fill")
                }
                .font(.system(size: 15, weight: .medium, design: .default))
                .foregroundColor(.init(hex: "#F5F5F5"))
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Label(order.spiceLevel, systemImage: "flame.fill")
                    Label(order.deliveryMethod, systemImage: "truck.box.fill")
                }
                .font(.system(size: 15, weight: .medium, design: .default))
                .foregroundColor(.init(hex: "#F5F5F5"))
            }
            
            Divider()
                .background(Color(hex: "#F5F5F5").opacity(0.4))
            
            HStack(spacing: 16) {
                Label("\(order.quantityOrdered)", systemImage: "number")
                Spacer()
                Label("\(order.estimatedPrepTimeMinutes) min", systemImage: "timer")
                Spacer()
                Label("$\(String(format: "%.2f", order.totalAmount))", systemImage: "dollarsign.circle")
            }
            .font(.system(size: 15, weight: .medium, design: .default))
            .foregroundColor(.init(hex: "#F5F5F5"))
            
            if order.specialInstructions != nil || order.feedbackNotes != nil {
                Divider()
                    .background(Color(hex: "#F5F5F5").opacity(0.4))
                if let instructions = order.specialInstructions, !instructions.isEmpty {
                    Label("Instructions: \(instructions)", systemImage: "note.text")
                        .font(.system(size: 13, weight: .medium, design: .default))
                        .foregroundColor(.init(hex: "#32CD32"))
                }
                if let feedback = order.feedbackNotes, !feedback.isEmpty {
                    Label("Feedback: \(feedback)", systemImage: "star.fill")
                        .font(.system(size: 13, weight: .medium, design: .default))
                        .foregroundColor(.init(hex: "#32CD32"))
                }
            }
        }
        .padding(20)
        .background(
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#2E8B57"),
                        Color(hex: "#3CB371")
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color(hex: "#FFD700").opacity(0.5), lineWidth: 1.5)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
        )
        .foregroundColor(.init(hex: "#F5F5F5"))
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
        .padding(.horizontal, 4)
    }
}

