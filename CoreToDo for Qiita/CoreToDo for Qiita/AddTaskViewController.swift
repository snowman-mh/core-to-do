//
//  AddTaskViewController.swift
//  CoreToDo for Qiita
//
//  Created by Masaya Hayashi on 2017/01/28.
//  Copyright © 2017年 Masaya Hayashi. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var categorySegmentedControl2: UISegmentedControl!
    @IBOutlet weak var categoryTextField: UITextField!
    
    // MARK: -
    
    var taskCategory = "ToDo"
    
    // MARK: -
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var task: Task?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add segment of added categories into categorySegmentedControl
        if taskCategories.count > firstNumberOfTaskCategories {
            for addedCategoryIndex in firstNumberOfTaskCategories..<taskCategories.count {
                if addedCategoryIndex <= 4 {
                    categorySegmentedControl.insertSegment(withTitle: taskCategories[addedCategoryIndex], at: addedCategoryIndex, animated: false)
                } else if addedCategoryIndex == 5 || addedCategoryIndex == 6 {
                    categorySegmentedControl2.setEnabled(true, forSegmentAt: addedCategoryIndex-5)
                    categorySegmentedControl2.setTitle(taskCategories[addedCategoryIndex], forSegmentAt: addedCategoryIndex-5)
                } else {
                    categorySegmentedControl2.isEnabled = true
                    categorySegmentedControl2.insertSegment(withTitle: taskCategories[addedCategoryIndex], at: addedCategoryIndex-5, animated: false)
                }
            }
        }
        
        // set information of selected task (got from segue)
        if let task = task {
            taskTextField.text = task.name
            taskCategory = task.category!
            if let taskCategoryIndex = taskCategories.index(of: task.category!) {
                categorySegmentedControl.selectedSegmentIndex = taskCategoryIndex
            } else {
                categorySegmentedControl.selectedSegmentIndex = 0
            }
        }
    }
    
    // MARK: - Actions of Buttons
    
    @IBAction func categoryChosen(_ sender: UISegmentedControl) {
        // choose category of task
        taskCategory = taskCategories[sender.selectedSegmentIndex]
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        
        let taskName = taskTextField.text
        if taskName == "" {
            dismiss(animated: true, completion: nil)
            return
        }
        
        if task == nil {
            task = Task(context: context)
        }
        
        if let task = task {
            task.name = taskName
            task.category = taskCategory
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewCategory(_ sender: Any) {
        // dismiss if no category is input
        let newCategory = categoryTextField.text
        if newCategory == "" {
            dismiss(animated: true, completion: nil)
            return
        }
        
        // add new category into core data
        let addedCategory = AddedCategory(context: context)
        addedCategory.category = newCategory!
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        dismiss(animated: true, completion: nil)
    }
    
}
