
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
        loadNotes()
    }
    
    //MARK: - TABLEVIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! TableViewCell
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.dateFormat = "dd-MMM-yyyy"
        let listNotes = listArray[indexPath.row]
        cell.titleText.text = listNotes.value
        cell.data.text = formatter.string(from: listNotes.date!)
        cell.layer.backgroundColor = UIColor.clear.cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if toRemove == true {
            removeNote(row: indexPath.row)
            saveNotes()
            tableView.deselectRow(at: indexPath, animated: false)
        } else {
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
    
    //MARK: - LOAD NOTES FROM DATABASE
    
    func loadNotes(with request: NSFetchRequest<Notes> = Notes.fetchRequest(), predicate: NSPredicate? = nil) {
        let request : NSFetchRequest<Notes> = Notes.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Notes.date), ascending: false)
        request.sortDescriptors = [sort]
        do {
            listArray = try context.fetch(request)
        } catch {
            print("Error loading notes \(error)")
        }
    }
    
    //MARK: - SAVE CURRENT NOTE
    
    func saveNotes() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    //MARK: - TRASH BUTTON PRESSED
    
    @IBAction func trashButtonPressed(_ sender: UIBarButtonItem) {
        if toRemove == false {
            toRemove = true
            trashButton.tintColor = UIColor.yellow
        } else {
            toRemove = false
            trashButton.tintColor = UIColor.label
        }
    }
    
    //MARK: - DELETE NOTE
    
    func removeNote(row:Int) {
        do {
            context.delete(listArray[row])
            listArray.remove(at: row)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    //MARK: - CREATE NEW NOTE
    
    func newNote(value: String) {
        let newNote = Notes(context: self.context)
        newNote.value  = value
        newNote.date = Date()
        self.listArray.append(newNote)
        saveNotes()
    }
    
    //MARK: - VIEW WILL APPEAR
    
    override func viewWillAppear(_ animated: Bool) {
        saveNotes()
        loadNotes()
        tableView.reloadData(
            with: .simple(duration: 0.45, direction: .left(useCellsFrame: true),
                          constantDelay: 0))
    }
}

