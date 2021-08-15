//
//  AddPhoneNumber.swift
//  WhatsAppMe
//
//  Created by Anmol Jain on 15/08/21.
//

import SwiftUI
import Combine

struct AddPhoneNumberView: View {
	@StateObject var phoneNumber: PhoneNumberObserver = PhoneNumberObserver(countries: Bundle.main.decode([Country].self, from: "CountryData.json").sorted { $0.name < $1.name })
	
	@State private var selectCountry: Bool = false
	
	var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			Text("Send message to?")
				.font(.largeTitle.bold())
			Text("Enter the number you'd like to send WhatsApp message")
				.font(.subheadline)
				.foregroundColor(.secondary)
			
			phoneNumberTextField
				.padding(.top, 30)
			Spacer()
			sendButton
		}
		.padding(.horizontal)
		.navigationBarTitleDisplayMode(.inline)
		.sheet(isPresented: $selectCountry) {
			SelectCountryCodeView()
				.environmentObject(phoneNumber)
		}
	}
	
	private var phoneNumberTextField: some View {
		HStack(spacing: 0) {
			Button(action: { selectCountry.toggle() }) {
				Text(phoneNumber.code.flag)
					.font(.title)
					.padding()
			}
			
			Divider()
				.padding(.vertical)

			TextField("9953314438", text: $phoneNumber.number)
				.keyboardType(.phonePad)
				.padding()
			
			Image(systemName: "exclamationmark.circle")
				.foregroundColor(.suraasaRed.opacity(phoneNumber.isValid ? 0 : 1))
				.padding()
		}
		.frame(height: 60)
		.background(Color.suraasaAluminium)
		.cornerRadius(10)
	}
	
	private var sendButton: some View {
		Button(action: {
			let urlWhats = "whatsapp://send?phone=+\(phoneNumber.code.code)\(phoneNumber.number)&abid=12354&text=Hey"
			if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
				if let whatsappURL = URL(string: urlString) {
					if UIApplication.shared.canOpenURL(whatsappURL) {
						UIApplication.shared.open(whatsappURL, options: [:])
					} else {
						print("Install Whatsapp")
					}
				}
			}
		}) {
			Text("Send")
				.font(.headline)
				.foregroundColor(.suraasaWhite)
				.frame(maxWidth: .infinity, maxHeight: 60)
				.background(phoneNumber.number.isNumber ? Color.suraasaBlue : Color.suraasaBlack20)
				.cornerRadius(10)
		}
		.padding(.bottom)
		.disabled(!phoneNumber.number.isNumber)
	}
}

extension AddPhoneNumberView {
	struct SelectCountryCodeView: View {
		@Environment(\.presentationMode) var presentationMode
		@EnvironmentObject var phoneNumber: PhoneNumberObserver
		
		var body: some View {
			NavigationView {
				List(phoneNumber.searchResults, rowContent: listItem)
					.listStyle(.plain)
					.navigationBarTitle("Country Code", displayMode: .inline)
					.toolbar {
						ToolbarItem(placement: .cancellationAction) {
							cancelButton
						}
					}
					.searchable(text: $phoneNumber.searchText)
			}
		}
		
		private func listItem(_ country: Country) -> some View {
			Button(action: {
				phoneNumber.code = country
				presentationMode.wrappedValue.dismiss()
			}) {
				HStack {
					Text(country.flag).font(.title2)
					Text(country.name).font(.callout)
					Spacer()
					Text(country.code)
						.font(.headline)
						.foregroundColor(.blue)
				}
			}
		}
		
		private var cancelButton: some View {
			Button(action: { presentationMode.wrappedValue.dismiss() }) {
				Text("Cancel")
			}
		}
	}
}

extension AddPhoneNumberView {
	class PhoneNumberObserver: ObservableObject {
		let countries: [Country]
		
		@Published var number: String = ""
		@Published var code: Country
		@Published var isValid: Bool = true
		
		@Published var searchText: String = ""
		
		private var subscriptions = Set<AnyCancellable>()
		
		init(countries: [Country]) {
			self.countries = countries
			code = countries.first { $0.name == "India" }!
			
			$number
				.debounce(for: .milliseconds(1000), scheduler: DispatchQueue.main)
				.sink(receiveValue: validate(number:))
				.store(in: &subscriptions)
		}
		
		func validate(number: String) {
			isValid = (number.isNumber || number.isEmpty)
		}
		
		var searchResults: [Country] {
			if searchText.isEmpty {
				return countries
			} else {
				return countries.filter { $0.name.contains(searchText) || $0.code.contains(searchText) }
			}
		}
	}
}

struct AddPhoneNumber_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			AddPhoneNumberView()
		}
    }
}
