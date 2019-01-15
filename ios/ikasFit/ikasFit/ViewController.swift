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

let healthStore = HKHealthStore()




class ViewController: UIViewController {
    
    
    

    @IBOutlet weak var labelPasos: UILabel!
    
    @IBAction func botonActualizar(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        autorizar()
        
        
        
    }
    
    // Para dar permisos
    // Idea para el codigo: https://developer.apple.com/documentation/healthkit/setting_up_healthkit
    
    func autorizar(){
        
        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        
        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            if !success {
                print("errooooooooooooooooooor")
            }
        }

        
    }
    
    
    
    
    
    

}


