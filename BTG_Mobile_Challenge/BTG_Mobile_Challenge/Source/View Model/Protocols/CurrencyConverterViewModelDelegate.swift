//
//  CurrencyConverterViewModelDelegate.swift
//  BTG_Mobile_Challenge
//
//  Created by Pedro Henrique Guedes Silveira on 19/12/20.
//

import Foundation

protocol CurrencyConverterViewModelDelegate: class {
    func updateUI()
    func shouldShowLoading(_ isLoading: Bool)
    func showError(_ error: String)
}