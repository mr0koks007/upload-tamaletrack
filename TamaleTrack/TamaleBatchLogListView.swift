import SwiftUI


struct TamaleBatchLogListView: View {
    @ObservedObject var manager: TamaleBatchLogManager
    @State private var showingAddEdit = false
    @State private var selectedLog: TamaleBatchLog? = nil

    var body: some View {
        NavigationView {
            ZStack {
                // Background with subtle gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#FFF8DC"),
                        Color(hex: "#FFE4C4")
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                if manager.items.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.init(hex: "#6B4E31"))
                        Text("🌽 No tamale batches yet.\nTap + to add a new one.")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 22, weight: .medium, design: .default))
                            .foregroundColor(.init(hex: "#4A3728"))
                            .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 30)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(manager.items) { log in
                                TamaleCardView(log: log)
                                    .onTapGesture {
                                        selectedLog = log
                                        showingAddEdit = true
                                    }
                                    .contextMenu {
                                        Button(action: {
                                            manager.delete(log: log)
                                        }) {
                                            Label("Delete", systemImage: "trash.fill")
                                                .foregroundColor(.init(hex: "#DC143C"))
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
                            selectedLog = nil
                            showingAddEdit = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 28, weight: .bold, design: .default))
                                .frame(width: 64, height: 64)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(hex: "#006400"),
                                            Color(hex: "#228B22")
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
            .navigationBarTitle("Tamale Batches", displayMode: .large)
            .sheet(isPresented: $showingAddEdit) {
                AddEditTamaleBatchLogView(manager: manager, log: $selectedLog)
            }
        }
    }
}

struct TamaleCardView: View {
    let log: TamaleBatchLog

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Text(log.fillingType)
                    .font(.system(size: 22, weight: .bold, design: .default))
                    .foregroundColor(.init(hex: "#F5F5F5"))
                Spacer()
                Image(systemName: log.isForPreorder ? "calendar.badge.plus" : "leaf.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.init(hex: "#FFD700"))
            }
            
            Divider()
                .background(Color(hex: "#F5F5F5").opacity(0.4))
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Label(log.datePrepared.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                    Label(log.batchSupervisor, systemImage: "person.fill")
                }
                .font(.system(size: 15, weight: .medium, design: .default))
                .foregroundColor(.init(hex: "#F5F5F5"))
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Label(log.spiceLevel, systemImage: "flame.fill")
                    Label(log.cookingMethod, systemImage: "cooktop.fill")
                }
                .font(.system(size: 15, weight: .medium, design: .default))
                .foregroundColor(.init(hex: "#F5F5F5"))
            }
            
            Divider()
                .background(Color(hex: "#F5F5F5").opacity(0.4))
            
            HStack(spacing: 16) {
                Label("\(log.quantityMade)", systemImage: "number")
                Spacer()
                Label("\(log.preparationTimeMinutes) min", systemImage: "timer")
                Spacer()
                Label("\(log.shelfLifeDays) days", systemImage: "clock")
            }
            .font(.system(size: 15, weight: .medium, design: .default))
            .foregroundColor(.init(hex: "#F5F5F5"))
            
            if !log.allergens.isEmpty {
                Divider()
                    .background(Color(hex: "#F5F5F5").opacity(0.4))
                Label("Allergens: \(log.allergens.joined(separator: ", "))", systemImage: "exclamationmark.triangle.fill")
                    .font(.system(size: 13, weight: .medium, design: .default))
                    .foregroundColor(.green)
            }
        }
        .padding(20)
        .background(
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#A52A2A"),
                        Color(hex: "#CD5C5C")
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

