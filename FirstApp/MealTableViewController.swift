//
//  MealTableViewController.swift
//  FirstApp
//
//  Created by Philip Gurr on 08.11.20.
//

import UIKit

class MealTableViewController: UITableViewController {
    
    // MARK: Properties
    var meals = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem
        
        if let diskMeals = loadMealsFromDisk() {
            meals += diskMeals
        } else {
            loadMeals()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "MealTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MealTableViewCell else {
            fatalError("No cell could be created.")
        }
        
        let meal = meals[indexPath.row]
        cell.mealName.text = meal.name
        cell.mealImage.image = meal.photo

        // Configure the cell...

        return cell
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            meals.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
        saveMeals()
    }

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "ShowDetail":
            guard let mealDetailVC = segue.destination as? MealViewController else { return }
            
            guard let selectedCell = sender as? MealTableViewCell else { return }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else { return }
            
            let meal = meals[indexPath.row]
            mealDetailVC.meal = meal
        default:
            break
        }
    }
    
    
    // MARK: Actions
    @IBAction func unwindMealList(sender: UIStoryboardSegue) {
        if let sourceVC = sender.source as? MealViewController, let meal = sourceVC.meal {
            if let indexPath = tableView.indexPathForSelectedRow {
                meals[indexPath.row] = meal
                tableView.reloadRows(at: [indexPath], with: .bottom)
            } else {
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        
        saveMeals()
    }

    func loadMeals() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        
        guard let meal1 = Meal.init(name: "Lasagne", photo: photo1),
              let meal2 = Meal.init(name: "Pizza", photo: photo2) else {
            return
        }
        
        meals += [meal1, meal2]
    }
    
    private func saveMeals() {
        NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveUrl.path)
    }
    
    private func loadMealsFromDisk() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveUrl.path) as? [Meal]
    }
}
