import SwiftUI

struct OverviewTabView: View {
    @ObservedObject var batchManager: TamaleBatchLogManager
    @ObservedObject var orderManager: TamaleOrderManager
    @ObservedObject var ingredientManager: IngredientStockManager
    @ObservedObject var cleaningManager: EquipmentCleaningLogManager

    var body: some View {
        NavigationView {
            ZStack {
                // Background with subtle gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#F3E5F5"),
                        Color(hex: "#E1BEE7")
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                if batchManager.items.isEmpty && orderManager.items.isEmpty && ingredientManager.items.isEmpty && cleaningManager.items.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.init(hex: "#4A2F5C"))
                        Text("📊 No data available yet.\nAdd batches, orders, stock, or cleaning logs to see insights.")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 22, weight: .medium, design: .default))
                            .foregroundColor(.init(hex: "#3C254A"))
                            .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 30)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            overviewCard(
                                title: "Total Batches Logged",
                                value: "\(batchManager.items.count)",
                                systemIcon: "leaf.fill"
                            )
                            overviewCard(
                                title: "Total Orders Received",
                                value: "\(orderManager.items.count)",
                                systemIcon: "cart.fill"
                            )
                            overviewCard(
                                title: "Total Revenue",
                                value: "$\(String(format: "%.2f", orderManager.items.map { $0.totalAmount }.reduce(0, +)))",
                                systemIcon: "dollarsign.circle.fill"
                            )
                            overviewCard(
                                title: "Low Stock Items",
                                value: "\(ingredientManager.items.filter { $0.quantityAvailable <= $0.restockThreshold }.count)",
                                systemIcon: "cube.box.fill"
                            )
                            overviewCard(
                                title: "Cleanings Due Soon",
                                value: "\(cleaningManager.items.filter { $0.nextScheduledCleaning <= Calendar.current.date(byAdding: .day, value: 2, to: Date())! }.count)",
                                systemIcon: "wrench.and.screwdriver.fill"
                            )
                            let allergens = Set(batchManager.items.flatMap { $0.allergens })
                            if !allergens.isEmpty {
                                overviewCard(
                                    title: "Allergens in Batches",
                                    value: allergens.joined(separator: ", "),
                                    systemIcon: "exclamationmark.triangle.fill"
                                )
                            }
                            overviewCard(
                                title: "Repeat Customers",
                                value: "\(orderManager.items.filter { $0.isRepeatCustomer }.count)",
                                systemIcon: "person.2.fill"
                            )
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                    }
                }
            }
            .navigationBarTitle("Overview", displayMode: .large)
        }
    }

    private func overviewCard(title: String, value: String, systemIcon: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Text(title)
                    .font(.system(size: 22, weight: .bold, design: .default))
                    .foregroundColor(.init(hex: "#F5F5F5"))
                Spacer()
                Image(systemName: systemIcon)
                    .font(.system(size: 24))
                    .foregroundColor(.init(hex: "#FFD700"))
            }
            
            Divider()
                .background(Color(hex: "#F5F5F5").opacity(0.4))
            
            Label(value, systemImage: "info.circle")
                .font(.system(size: 15, weight: .medium, design: .default))
                .foregroundColor(.init(hex: "#F5F5F5"))
        }
        .padding(20)
        .background(
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#6A1B9A"),
                        Color(hex: "#8E24AA")
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

