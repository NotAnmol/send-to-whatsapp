//
//  String.swift
//  WhatsAppMe
//
//  Created by Anmol Jain on 15/08/21.
//

import Foundation

extension String {
	var isNumber: Bool {
		NSPredicate(format: "SELF MATCHES %@", "^[0-9]{8,12}$").evaluate(with: self)
	}
}
