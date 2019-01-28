//
//  PrimerViewController.swift
//  ikasFit
//
//  Created by Carlos Hernández on 22/01/2019.
//  Copyright © 2019 Carlos Hernández. All rights reserved.
//

import UIKit

// Pasar el nombre de la clase al ViewController principal
// UITextFieldDelegate para ocultar el teclado al tocar cualquier zona de la pantalla
class PrimerViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textNombreClase: UITextField!
    
    var nombreClase1 = ""
    
    
    @IBOutlet weak var botonC: UIButton!
    
    // TODO:
    // Hacer que cuando los ajustes del iPhone se abran, se habra en salud
    // Cambiar color de fila del tableviewcontroller en el que estoy
    // Hacer que todos los días se borren los datos de firestore o hacer un asegunda subdivisión por fecha
    // TODO Hacer un label que ponga: Ganador de pasos de la semana: "Clase: 222"
    // TODO Autenticar con facebook

    override func viewDidLoad() {
        super.viewDidLoad()
        
        botonC.layer.cornerRadius = 10
        
        textNombreClase.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
    @IBAction func botonComenzar(_ sender: Any) {
        
        // TODO Añadir un listener...
        if(textNombreClase.text?.isEmpty ?? true){
            
            let alert = UIAlertController(title: "¡Ups!", message: "Debes escribir el nombre o número de tu clase antes de comenzar.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
        } else {
            
            
        
        self.nombreClase1 = textNombreClase.text!
        performSegue(withIdentifier: "nombreClaseIdentificador", sender: self)
        
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! ViewController
        vc.finalClase = self.nombreClase1
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
