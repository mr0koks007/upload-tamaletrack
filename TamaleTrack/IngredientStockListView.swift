import SwiftUI

struct IngredientStockListView: View {
    @ObservedObject var manager: IngredientStockManager
    @State private var showingAddEdit = false
    @State private var selectedItem: IngredientStockItem? = nil

    var body: some View {
        NavigationView {
            ZStack {
                // Background with subtle gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#E6F3FA"),
                        Color(hex: "#B3DDE8")
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                if manager.items.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "archivebox.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.init(hex: "#1C4A6B"))
                        Text("🧂 No ingredient stock yet.\nTap + to add a new item.")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 22, weight: .medium, design: .default))
                            .foregroundColor(.init(hex: "#143C5C"))
                            .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 30)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(manager.items) { item in
                                IngredientCardView(item: item)
                                    .onTapGesture {
                                        selectedItem = item
                                        showingAddEdit = true
                                    }
                                    .contextMenu {
                                        Button(action: {
                                            withAnimation {
                                                manager.delete(item: item)
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
                            selectedItem = nil
                            showingAddEdit = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 28, weight: .bold, design: .default))
                                .frame(width: 64, height: 64)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(hex: "#2A607A"),
                                            Color(hex: "#4682B4")
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
            .navigationBarTitle("Ingredient Stock", displayMode: .large)
            .sheet(isPresented: $showingAddEdit) {
                AddEditIngredientStockView(item: $selectedItem, manager: manager)
            }
        }
    }
}

struct IngredientCardView: View {
    let item: IngredientStockItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Text(item.name)
                    .font(.system(size: 22, weight: .bold, design: .default))
                    .foregroundColor(.init(hex: "#F5F5F5"))
                Spacer()
                Image(systemName: item.organicCertified ? "leaf.fill" : "archivebox.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.init(hex: "#FFD700"))
            }
            
            Divider()
                .background(Color(hex: "#F5F5F5").opacity(0.4))
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Label(item.lastRestockedDate.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                    Label(item.receivedBy, systemImage: "person.fill")
                }
                .font(.system(size: 15, weight: .medium, design: .default))
                .foregroundColor(.init(hex: "#F5F5F5"))
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Label(item.storageLocation, systemImage: "location.fill")
                    Label(item.reorderStatus, systemImage: "arrow.clockwise")
                }
                .font(.system(size: 15, weight: .medium, design: .default))
                .foregroundColor(.init(hex: "#F5F5F5"))
            }
            
            Divider()
                .background(Color(hex: "#F5F5F5").opacity(0.4))
            
            HStack(spacing: 16) {
                Label("\(item.quantityAvailable, specifier: "%.1f") \(item.unit)", systemImage: "number")
                Spacer()
                Label("$\(item.costPerUnit, specifier: "%.2f")", systemImage: "dollarsign.circle")
                Spacer()
                Label("\(item.restockThreshold, specifier: "%.1f")", systemImage: "exclamationmark.triangle")
            }
            .font(.system(size: 15, weight: .medium, design: .default))
            .foregroundColor(.init(hex: "#F5F5F5"))
            
            if item.stockNotes != nil || item.batchLotCode != "" || item.moistureSensitive {
                Divider()
                    .background(Color(hex: "#F5F5F5").opacity(0.4))
                if let notes = item.stockNotes, !notes.isEmpty {
                    Label("Notes: \(notes)", systemImage: "note.text")
                        .font(.system(size: 13, weight: .medium, design: .default))
                        .foregroundColor(.init(hex: "#00CED1"))
                }
                if !item.batchLotCode.isEmpty {
                    Label("Lot: \(item.batchLotCode)", systemImage: "barcode")
                        .font(.system(size: 13, weight: .medium, design: .default))
                        .foregroundColor(.init(hex: "#00CED1"))
                }
                if item.moistureSensitive {
                    Label("Moisture Sensitive", systemImage: "drop.fill")
                        .font(.system(size: 13, weight: .medium, design: .default))
                        .foregroundColor(.init(hex: "#00CED1"))
                }
            }
        }
        .padding(20)
        .background(
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#1C4A6B"),
                        Color(hex: "#2F769C")
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

