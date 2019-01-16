//
//  ViewController.swift
//  ikasFit
//
//  Created by Carlos Hernández on 15/01/2019.
//  Copyright © 2019 Carlos Hernández. All rights reserved.
//

import UIKit
import HealthKit
import HealthKitUI
import Firebase

let healthStore = HKHealthStore()




class ViewController: UIViewController {
    
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        autorizar()
        
        
        pasosDeHoy { (result) in
            print("\(result)")
            DispatchQueue.main.async {
                self.labelPasos.text = "\(result)"
            }
        }
        
        
        
        
        
        
    }
    
    
    //Botón para ir a Salud y activar que deje leer los pasos
    //Fuente https://stackoverflow.com/questions/28152526/how-do-i-open-phone-settings-when-a-button-is-clicked/52103305
    
    
    @IBAction func botonAjustes(_ sender: Any) {
    
    //UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        
        
        let alertController = UIAlertController (title: "Autorizar", message: "¿Quieres que la aplicación abra los Ajustes del iPhone?", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Ajustes", style: .default) { (_) -> Void in
                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Ajstes abiertos: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    
    // Para dar permisos
    // Idea para el codigo: https://developer.apple.com/documentation/healthkit/setting_up_healthkit
    
    func autorizar(){
        
        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        
        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            if success {
                print("Bien leído")
            }
        }
        
        

        
    }
    
    // Para que recoja los pasos hechos en todo el día
    // Fuente: https://stackoverflow.com/questions/36559581/healthkit-swift-getting-todays-steps
    
    func pasosDeHoy(completion: @escaping (Double) -> Void) {
        
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var resultCount = 0.0
            guard let result = result else {
                
                //En caso de que al iniciar la aplicación el usuario le de a no permitir...
                // TODO implementar botón en los ajustes "Autorizar HealthKit"
                
                print("Error al obtener los pasos de healthkit (posiblemente porque no le hayan dado acceso)")
                completion(resultCount)
                return
            }
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        healthStore.execute(query)
    }
    
    
    
    @IBOutlet weak var labelPasos: UILabel!
    
    @IBAction func botonActualizar(_ sender: Any) {
        
        
        
        pasosDeHoy { (result) in
            print("\(result)")
            DispatchQueue.main.async {
                self.labelPasos.text = "\(result)"
            }
            
            // Add a new document with a generated ID
            //Fuente: https://firebase.google.com/docs/firestore/quickstart?authuser=0
            
            var ref: DocumentReference? = nil
            ref = db.collection("alumnos").addDocument(data: [
                "pasos": self.labelPasos.text
                
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        
        
        
    }
    
   
    }
    
    
    
    
    
    
}
    




