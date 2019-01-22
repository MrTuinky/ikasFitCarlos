//
//  PrimerViewController.swift
//  ikasFit
//
//  Created by Carlos Hernández on 22/01/2019.
//  Copyright © 2019 Carlos Hernández. All rights reserved.
//

import UIKit

// PAsar el nombre de la clase al ViewController principal

class PrimerViewController: UIViewController {
    
    @IBOutlet weak var textNombreClase: UITextField!
    
    var nombreClase1 = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func botonComenzar(_ sender: Any) {
        
        self.nombreClase1 = textNombreClase.text!
        performSegue(withIdentifier: "nombreClaseIdentificador", sender: self)
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
