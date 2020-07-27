//
//  listController.swift
//  notatnik
//
//  Created by Kuba on 19/04/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import UIKit
import CoreData
import TableViewReloadAnimation




class listController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    var toRemove : Bool = false
    var listArray = [Notes]()
    
    
        
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName:"TableViewCell", bundle: nil), forCellReuseIdentifier: "noteCell")
        // Do any additional setup after loading the view.
        loadNotes()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! TableViewCell
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.dateFormat = "dd-MMM-yyyy"
        //let myStringafd = formatter.string(from: yourDate!)
        let listNotes = listArray[indexPath.row]
       cell.titleText.text = listNotes.value
        cell.data.text = formatter.string(from: listNotes.date!)
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
       
        /*
        self.tableView.backgroundColor = UIColor.clear

        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //blurEffectView.frame = self.view.frame

        cell.backgroundView = blurEffectView
        
        self.tableView.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
        */
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
          if toRemove == true {
            // listArray[indexPath.row].saved = !listArray[indexPath.row].saved
            removeNote(row: indexPath.row)
            
            
              saveNotes()
              tableView.deselectRow(at: indexPath, animated: false)
          }else{
            performSegue(withIdentifier: "goToEdit", sender: self)
            var value = listArray[indexPath.row].value
           
        }
        tableView.reloadData()
      }
         
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          let destinationVC = segue.destination as! editController
             
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedNote = listArray[indexPath.row]
             }
         }
 
    @IBAction func trashButtonPressed(_ sender: UIBarButtonItem) {
        if toRemove == false{
            toRemove = true
            trashButton.tintColor = UIColor.yellow
        }else{
            toRemove = false
            trashButton.tintColor = UIColor.label
        }
        
    }
    
  
          
    
    func loadNotes(with request: NSFetchRequest<Notes> = Notes.fetchRequest(), predicate: NSPredicate? = nil) {
         let request : NSFetchRequest<Notes> = Notes.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Notes.date), ascending: false)
               request.sortDescriptors = [sort]
               do{
                   listArray = try context.fetch(request)
               } catch {
                   print("Error loading notes \(error)")
               }
              
           }
    

func saveNotes() {
    
    do {
      try context.save()
    } catch {
       print("Error saving context \(error)")
    }
    
}
    
    func removeNote(row:Int){
        do {
                      context.delete(listArray[row])
                              listArray.remove(at: row)
                   } catch {
                       print("Error fetching data from context \(error)")
                   }
    }
    
    func newNote(value: String){
        
              let newNote = Notes(context: self.context)
              newNote.value  = value
              newNote.date = Date()
             self.listArray.append(newNote)
        saveNotes()
        
        //loadNotes()
       // tableView.reloadData()
        
      
        
    }
    
       override func viewWillAppear(_ animated: Bool) {
        saveNotes()
        loadNotes()
        tableView.reloadData(
        with: .simple(duration: 0.45, direction: .left(useCellsFrame: true),
        constantDelay: 0))
        
    }
                        
    

    
}



           
           
           
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


