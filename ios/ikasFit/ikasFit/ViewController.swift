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
    
    var uid: String!
    
    var listasGlobal: [String] = []
    var listasClase: [String] = []
    
    var pasosT: String!
    
    
    
    @IBOutlet weak var labelClase: UILabel!
    var finalClase = ""
    
    //Botón para regresar de la tabla a la vista principal
    
    @IBAction func volverALaVistaPrincipal(segue: UIStoryboardSegue){
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        autorizar()
        
        pasosDeHoy { (result) in
            print("\(result)")
            DispatchQueue.main.async {
                // Redondeo porque sino al dar muchos pasos me sube tropeciontos decimaes y en un iPhone de pantalla pequeña no caben tantos decimales.
                // No hacen falta decimales
                
                
                self.labelPasos.text = "\(floor(result))"
            }
        }
        
        self.labelClase.text = self.finalClase
        
        
        
        
    }
    
    
    //Botón para ir a Salud del iPhone y activar que deje leer los pasos
    //Fuente https://stackoverflow.com/questions/28152526/how-do-i-open-phone-settings-when-a-button-is-clicked/52103305
    
    
    @IBAction func botonAjustes(_ sender: Any) {
        
        //UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        
        
        let alertController = UIAlertController (title: "Autorizar", message: "¿Deseas que la aplicación abra los Ajustes del iPhone?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Ajustes", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Ajustes abiertos: \(success)") // Prints true
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
                // TODO que elboton de ajustes redirija directamente a "Salud"
                
                
                
                
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
    
    
    
    @IBOutlet weak var labelPosicionClase: UILabel!
    
    
    @IBOutlet weak var labelPosicionGlobal: UILabel!
    
    
    @IBOutlet weak var labelPasos: UILabel!
    
    @IBAction func botonActualizar(_ sender: Any) {
        
        
        
        
        pasosDeHoy { (result) in
            print("\(result)")
            DispatchQueue.main.async {
                self.labelPasos.text = "\((result * 10000).rounded() / 10000)"
                
            }
            
            
            
        }
        
        self.pasosT = self.labelPasos.text ?? "?"
        
        // Add a new document with a generated ID
        //Fuente: https://firebase.google.com/docs/firestore/quickstart?authuser=0
        
        /////////////////////////////////// AUTENTICACIÓN //////////////////////////////////////////////
        Auth.auth().signInAnonymously() { (authResult, error) in
            
            
            let uid = Auth.auth().currentUser!.uid
            //print("Usuario: \(uid)")
            
            
            
            // Añadir un nuevo documento en la colección "Alumnos", que es la que engloba todas las clases
            
            
                
                db.collection("alumnos").document(uid).setData([
                    "pasos": self.labelPasos.text ?? "?",
                    "usuario": uid,
                    "clase": self.finalClase
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    }
                }
                
            
            
            
            
            // Añadir un nuevo documento en la colección "Clase"
            
            
                
                db.collection(self.finalClase).document(uid).setData([
                    "pasos": self.labelPasos.text ?? "?",
                    "usuario": uid,
                    "clase": self.finalClase
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    }
                }
            
            
            
            // A continuación creo codigo para llenar el label de posición de la clase (2/30)
            
            db.collection(self.finalClase).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    //Recuperar los datos de la lista y crear el objeto
                    for document in querySnapshot!.documents {
                        let  datos = document.data()
                        //Si "pasos" tiene valor, obtengo el contenido, si no, aparecerá una interrogación
                        let pasos = datos["pasos"] as? String ?? "?"
                        let lista = pasos
                        self.listasClase.append(lista)
                        
                        
                    }
                    
                    // Ordenar y recargar la tabla
                    // Fuente: https://www.hackingwithswift.com/example-code/arrays/how-to-sort-an-array-using-sort
                    
                    // Ordenar aray
                    self.listasClase.sort{
                        $0 > $1
                    }
                    
                    for i in 0 ..< self.listasClase.count {
                        
                        
                        if(self.listasClase[i].caseInsensitiveCompare(self.labelPasos.text ?? "?")  == .orderedSame){
                            
                            
                            
                            self.labelPosicionClase.text = "\(i + 1) / \(self.listasClase.count)"
                            
                            
                        }
                        
                        print("Posición \(i + 1): \(self.listasClase[i])")
                        
                    }
                    
                    self.listasClase.removeAll()
                    
                    
                    
                }
            }
            
            
            
            
            // A continuación creo codigo para llenar el label de posición global (2/1000)
            
            db.collection("alumnos").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    //Recuperar los datos de la lista y crear el objeto
                    for document in querySnapshot!.documents {
                        let  datos = document.data()
                        //Si "pasos" tiene valor, obtengo el contenido, si no, aparecerá una interrogación
                        let pasos = datos["pasos"] as? String ?? "?"
                        let lista = pasos
                        self.listasGlobal.append(lista)
                        
                        
                    }
                    
                    // Ordenar y recargar la tabla
                    // Fuente: https://www.hackingwithswift.com/example-code/arrays/how-to-sort-an-array-using-sort
                    
                    // Ordenar aray
                    self.listasGlobal.sort{
                        $0 > $1
                    }
                    
                    for i in 0 ..< self.listasGlobal.count {
                        
                        
                        if(self.listasGlobal[i].caseInsensitiveCompare(self.labelPasos.text ?? "?")  == .orderedSame){
                            
                            
                            
                            self.labelPosicionGlobal.text = "\(i + 1) / \(self.listasGlobal.count)"
                            
                            
                        }
                        
                        print("Posición \(i + 1): \(self.listasGlobal[i])")
                        
                    }
                    
                    self.listasGlobal.removeAll()
                    
                    
                    
                }
            }
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
}





