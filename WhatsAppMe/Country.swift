//
//  Country.swift
//  WhatsAppMe
//
//  Created by Anmol Jain on 15/08/21.
//

import Foundation

struct Country: Decodable, Identifiable {
	let id: UUID = UUID()
	let code: String
	let flag: String
	let alpha2: String
	let name: String
}
