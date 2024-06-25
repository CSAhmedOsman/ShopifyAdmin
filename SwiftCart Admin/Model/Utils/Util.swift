//
//  Util.swift
//  SwiftCart Admin
//
//  Created by Mac on 19/06/2024.
//

import UIKit
    
public struct Utils {
    
    static func encode<T: Encodable>(_ value: T) -> Data? {
        do {
            let data = try JSONEncoder().encode(value)
            return data
        } catch {
            print("Error encoding Obj: \(error)")
            return nil
        }
    }
    
    static func decode<T: Decodable>(from data: Data) -> T? {
        do {
            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .iso8601
            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
    static func showAlert(title: String?,
                          message: String?,
                          preferredStyle: UIAlertController.Style,
                          from viewController: UIViewController,
                          actions: [UIAlertAction]? = nil)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        if let actions {
            for action in actions {
                alertController.addAction(action)
            }
        } else {
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
        }
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
    // MARK: here how to use showAlert
/*
    func showMyAlert() {
        // Define actions
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
             
        // Show alert
        AlertManager.showAlert(title: "Alert",
            message: "SkipBtn is tapped",
            preferredStyle: .alert,
            actions: [defaultAction, cancelAction],
            from: self)
         }
        
/////////////////// OR \\\\\\\\\\\\\\\\\\\\
     
    @IBAction func btnTapped(_ sender: Any) {
        let defaultAction = UIAlertAction(title: "Save", style: .default, handler: { _ in print("Logic here")})
        let destructiveAction = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        AlertManager.showAlert(title: "Alert",
            message: "SkipBtn is tapped",
            preferredStyle: .alert,
            actions: [defaultAction, destructiveAction, cancelAction],
            from: self)
        }
 
 /////////////////// OR \\\\\\\\\\\\\\\\\\\\
 AlertManager.showAlert(title: "Error!", message: "Pleas enter both email and password", preferredStyle: .alert, actions: [], from: self)
*/
