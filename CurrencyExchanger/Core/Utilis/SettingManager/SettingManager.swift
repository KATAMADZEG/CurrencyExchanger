//
//  SettingManager.swift
//  CurrencyExchanger
//
//  Created by Giorgi Katamadze on 4/18/23.
//

import Foundation

final class SettingManager {
    static let shared = SettingManager()
    private init() {}
    var transferCount = 0
}
