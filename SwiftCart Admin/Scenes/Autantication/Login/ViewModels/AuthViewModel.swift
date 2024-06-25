//
//  ViewModel.swift
//  SwiftCart
//
//  Created by Mac on 30/05/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel{
        
    func login(email: String, password: String, complation: @escaping (Result<String,Error>) -> ()){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            guard self != nil else { return }
            
            if let error = error {
                print("Error signing in:", error.localizedDescription)
                complation(.failure(error))
                return
            }
            
            if user != nil {
                if email == K.Enums.Auth.adminMail {
                    complation(.success("Admin"))
                }
            }
        }
    }
}
