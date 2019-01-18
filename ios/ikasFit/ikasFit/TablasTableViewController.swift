//
//  TablasTableViewController.swift
//  ikasFit
//
//  Created by Carlos Hernández on 16/01/2019.
//  Copyright © 2019 Carlos Hernández. All rights reserved.
//

import UIKit

import Firebase

class TablasTableViewController: UITableViewController {
    
    //ID de usuario generado por Firebase
    var uid: String!
    
    
    var listas = [ListaDePasos]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //let lista = ListaDePasos(titulo:"Pasos")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        Auth.auth().signInAnonymously() { (authResult, error) in
            
            
            // Fuente: https://stackoverflow.com/questions/44391706/firebase-how-to-get-user-uid
            let uid = Auth.auth().currentUser!.uid
            
            print("Usuario: \(uid)")
            
            db.collection("alumnos").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    //Recuperar los datos de la lista y crear el objeto
                    for document in querySnapshot!.documents {
                        let  datos = document.data()
                        let pasos = datos["pasos"] as? String ?? "?"
                        let lista = ListaDePasos(pasos: pasos)
                        self.listas.append(lista)
                    }
                    
                    // Recargar la tabla
                    self.tableView.reloadData()
                }
            }
            
            
            /*
            
            db.collection("alumnos").document(uid)
                .addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    
                    //Limpiar el array de objetos
                    self.listas.removeAll()
                    
                    //Recuperar los datos de la lista y crear el objeto
                    let datos = document.data()
                    let pasos = datos["pasos"] as? String ?? "?"
                    let lista = ListaDePasos(pasos: pasos)
                    self.listas.append(lista)
                    
                    
                    // Recargar la tabla
                    self.tableView.reloadData()

                    
                    
            }
            
            */
            
            /*
            db.collection("alumnos").whereField("usuario", isEqualTo: uid)
                .addSnapshotListener { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching documents: \(error!)")
                        return
                    }
                    
                    //Limpiar el array de objetos
                    self.listas.removeAll()
                    
                    for document in documents {
                        //Recuperar los datos de la lista y crear el objeto
                        let datos = document.data()
                        let pasos = datos["pasos"] as? String ?? "?"
                        let lista = ListaDePasos(pasos: pasos)
                        self.listas.append(lista)
                    }
                    
                    
                    // Recargar la tabla
                    self.tableView.reloadData()
                    
                    
            }
            
            */
            
        }
        
        
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listas.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        // Este texto tiene que coincidir con
        // el identificador de Table View Cell
        // Configure the cell...
        
        cell.textLabel?.text = listas[indexPath.row].pasos
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
