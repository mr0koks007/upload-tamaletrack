import SwiftUI

struct EquipmentCleaningLogListView: View {
    @ObservedObject var manager: EquipmentCleaningLogManager
    @State private var showingAddEdit = false
    @State private var selectedLog: EquipmentCleaningLog? = nil

    var body: some View {
        NavigationView {
            ZStack {
                // Background with subtle gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#FFF3E0"),
                        Color(hex: "#FFE0B2")
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                if manager.items.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "wrench.and.screwdriver.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.init(hex: "#6D4C41"))
                        Text("🧽 No cleaning logs yet.\nTap + to add a new one.")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 22, weight: .medium, design: .default))
                            .foregroundColor(.init(hex: "#4E342E"))
                            .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 30)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(manager.items) { log in
                                EquipmentCardView(log: log)
                                    .onTapGesture {
                                        selectedLog = log
                                        showingAddEdit = true
                                    }
                                    .contextMenu {
                                        Button(action: {
                                            withAnimation {
                                                manager.delete(log: log)
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
                            selectedLog = nil
                            showingAddEdit = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 28, weight: .bold, design: .default))
                                .frame(width: 64, height: 64)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(hex: "#D84315"),
                                            Color(hex: "#F4511E")
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
            .navigationBarTitle("Cleaning Logs", displayMode: .large)
            .sheet(isPresented: $showingAddEdit) {
                AddEditEquipmentCleaningLogView(log: $selectedLog, manager: manager)
            }
        }
    }
}

struct EquipmentCardView: View {
    let log: EquipmentCleaningLog

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Text(log.equipmentName)
                    .font(.system(size: 22, weight: .bold, design: .default))
                    .foregroundColor(.init(hex: "#F5F5F5"))
                Spacer()
                Image(systemName: log.isSanitized ? "checkmark.shield.fill" : "wrench.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.init(hex: "#FFD700"))
            }
            
            Divider()
                .background(Color(hex: "#F5F5F5").opacity(0.4))
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Label(log.cleanedDate.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                    Label(log.cleanedBy, systemImage: "person.fill")
                }
                .font(.system(size: 15, weight: .medium, design: .default))
                .foregroundColor(.init(hex: "#F5F5F5"))
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Label(log.sanitationLevel, systemImage: "drop.fill")
                    Label(log.equipmentMaterial, systemImage: "gearshape.fill")
                }
                .font(.system(size: 15, weight: .medium, design: .default))
                .foregroundColor(.init(hex: "#F5F5F5"))
            }
            
            Divider()
                .background(Color(hex: "#F5F5F5").opacity(0.4))
            
            HStack(spacing: 16) {
                Label("\(log.cleaningDurationMinutes) min", systemImage: "timer")
                Spacer()
                Label("\(log.cleaningFrequencyDays) days", systemImage: "calendar")
                Spacer()
                Label(log.requiresRepairs ? "Yes" : "No", systemImage: "wrench")
            }
            .font(.system(size: 15, weight: .medium, design: .default))
            .foregroundColor(.init(hex: "#F5F5F5"))
            
            if log.issuesFound != nil || log.repairNotes != nil || !log.postCleanSmellCheck || !log.tempCheckPassed {
                Divider()
                    .background(Color(hex: "#F5F5F5").opacity(0.4))
                if let issue = log.issuesFound, !issue.isEmpty {
                    Label("Issue: \(issue)", systemImage: "exclamationmark.triangle.fill")
                        .font(.system(size: 13, weight: .medium, design: .default))
                        .foregroundColor(.init(hex: "#FFA500"))
                }
                if let repairNote = log.repairNotes, !repairNote.isEmpty {
                    Label("Repair: \(repairNote)", systemImage: "wrench.fill")
                        .font(.system(size: 13, weight: .medium, design: .default))
                        .foregroundColor(.init(hex: "#FFA500"))
                }
                if !log.postCleanSmellCheck {
                    Label("Odor Detected", systemImage: "nose.fill")
                        .font(.system(size: 13, weight: .medium, design: .default))
                        .foregroundColor(.init(hex: "#FFA500"))
                }
                if !log.tempCheckPassed {
                    Label("Temp Check Failed", systemImage: "thermometer")
                        .font(.system(size: 13, weight: .medium, design: .default))
                        .foregroundColor(.init(hex: "#FFA500"))
                }
            }
        }
        .padding(20)
        .background(
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#BF360C"),
                        Color(hex: "#E64A19")
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

