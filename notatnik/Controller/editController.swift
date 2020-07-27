
import UIKit

class editController: UIViewController {
    @IBOutlet weak var noteText: UITextView!
    
    var selectedNote : Notes? {
        didSet{
            selectedNote?.value
        }
    }
    let vc = listController()
    weak var delegate: listController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteText.text = selectedNote?.value
    }
    
    //MARK: - SAVE BUTTON PRESSED
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let myString = noteText.text!
        if selectedNote?.value == nil {
            vc.newNote(value: myString)
        } else {
            selectedNote?.value = myString
            selectedNote?.date = Date()
        }
        _ = navigationController?.popViewController(animated: true)
    }
}
