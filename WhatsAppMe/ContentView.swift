//
//  ContentView.swift
//  WhatsAppMe
//
//  Created by Anmol Jain on 15/08/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        List {
            ForEach(items) { item in
				HStack {
					Text("+\(item.code ?? "") \(item.number ?? "")")
						.font(.headline)
					
					Spacer()
					
					sendTimestamp(item.timestamp!)
						.font(.callout)
						.foregroundColor(.secondary)
					
				}
				.padding(.vertical, 5)
            }
            .onDelete(perform: deleteItems)
        }
		.listStyle(.plain)
        .toolbar {
			NavigationLink(destination: AddPhoneNumberView().environment(\.managedObjectContext, viewContext)) {
				Label("Add Item", systemImage: "plus")
			}
        }
		.navigationTitle("WhatsApp Me")
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
	
	private func sendTimestamp(_ date: Date) -> Text {
		let distance: Int = Int(date.distance(to: Date()))
		if distance > 86400 {
			return Text("\(date, formatter: dateTimeFormatter)")
		} else {
			return Text("\(date, formatter: timeFormatter)")
		}
	}
	
	private let dateTimeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short
		return formatter
	}()
	
	private let timeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.timeStyle = .short
		return formatter
	}()
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
		}
    }
}
