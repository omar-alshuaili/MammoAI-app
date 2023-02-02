//
//  KeyBoardHandler.swift
//  project400
//
//  Created by Omar Alshuaili on 09/12/2022.
//

import SwiftUI
import Combine

final class KeyBoardHandler: ObservableObject{
    @Published private(set) var KeyBoardHeight:CGFloat = 0
    
    private var cancellable : AnyCancellable?
    
    private let keyBoardWillShow = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .compactMap{ ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height }
    
    private let keyBoardWillHide = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .map{ _ in CGFloat.zero }
    
    
    init() {
        cancellable = Publishers.Merge(keyBoardWillShow, keyBoardWillHide)
            .subscribe(on: DispatchQueue.main)
            .assign(to: \.self.KeyBoardHeight, on: self)
    }
    
    
    
    
}
