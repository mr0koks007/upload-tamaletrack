import SwiftUI

struct TamaleMainTabBarView: View {
    @StateObject private var tamaleBatchManager = TamaleBatchLogManager()
    @StateObject private var tamaleOrderManager = TamaleOrderManager()
    @StateObject private var ingredientStockManager = IngredientStockManager()
    @StateObject private var equipmentCleaningLogManager = EquipmentCleaningLogManager()

    var body: some View {
        TabView {
   

            // Tab 1: Tamale Batches
            TamaleBatchLogListView(manager: tamaleBatchManager)
                .tabItem {
                    Image(systemName: "leaf.fill")
                    Text("Batches")
                }

            // Tab 2: Orders
            TamaleOrderListView(manager: tamaleOrderManager)
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Orders")
                }

            // Tab 3: Ingredient Stock
            IngredientStockListView(manager: ingredientStockManager)
                .tabItem {
                    Image(systemName: "cube.box.fill")
                    Text("Ingredients")
                }

            // Tab 4: Equipment Cleaning
            EquipmentCleaningLogListView(manager: equipmentCleaningLogManager)
                .tabItem {
                    Image(systemName: "wrench.and.screwdriver.fill")
                    Text("Cleaning")
                }
            
            // Tab 5: Overview
            OverviewTabView(
                batchManager: tamaleBatchManager,
                orderManager: tamaleOrderManager,
                ingredientManager: ingredientStockManager,
                cleaningManager: equipmentCleaningLogManager
            )
            .tabItem {
                Image(systemName: "rectangle.grid.2x2.fill")
                Text("Overview")
            }
        }
        .accentColor(.green)
    }
}
