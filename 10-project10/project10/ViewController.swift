//
//  ViewController.swift
//  project10
//
//  Created by Joseph Zhu on 31/10/2022.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var people: [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] {
                people = decodedPeople
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let imageName = UUID().uuidString
            let imagePath = self?.getDocumentsDirectory().appendingPathComponent(imageName)
            
            if let jpegData = image.jpegData(compressionQuality: 0.8) {
                guard let imagePath = imagePath else { return }
                try? jpegData.write(to: imagePath)
            }
            
            let person = Person(name: "Unknown", image: imageName)
            self?.people.append(person)
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.save()
                self?.dismiss(animated: true)
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Person", message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Rename person", style: .default) { [weak self] _ in
            self?.renamePersonTapped(person)
        })
        
        ac.addAction(UIAlertAction(title: "Delete person", style: .destructive) { [weak self] _ in
            self?.deletePersonTapped(at: indexPath)
        })

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        //provide source for ipad compatibility
        if let popoverController = ac.popoverPresentationController {
            guard let cellView = collectionView.cellForItem(at: indexPath) else { return }
            popoverController.sourceView = cellView
            popoverController.sourceRect = CGRect(x: cellView.bounds.midX, y: cellView.bounds.midY, width: 0, height: 0)
        }
        
        present(ac, animated: true)
    }
    
    func renamePersonTapped(_ person: Person) {
        let ac = UIAlertController(title: "Person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [unowned self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName
            
            self.collectionView?.reloadData()
            self.save()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func deletePersonTapped(at indexPath: IndexPath) {
        let ac = UIAlertController(title: "Confirmation", message: "Delete  \(people[indexPath.item].name) ?", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.deletePerson(at: indexPath)
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func deletePerson(at indexPath: IndexPath) {
        DispatchQueue.global().async { [weak self] in
            guard let image = self?.people[indexPath.item].image else {
                self?.showDeleteError()
                return
            }
            
            guard let imagePath = self?.getDocumentsDirectory().appendingPathComponent(image) else {
                self?.showDeleteError()
                return
            }
            
            do {
                try FileManager.default.removeItem(at: imagePath)
            } catch {
                self?.showDeleteError()
                return
            }
            
            self?.people.remove(at: indexPath.item)
            
            DispatchQueue.main.async {
                self?.collectionView.deleteItems(at: [indexPath])
            }
        }
    }
    
    func showDeleteError() {
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Error", message: "Person could not be deleted", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            
            self?.present(ac, animated: true)
        }
    }
    
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        }
    }
}
