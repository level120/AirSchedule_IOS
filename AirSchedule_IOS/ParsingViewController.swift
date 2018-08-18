//
//  ParsingViewController.swift
//  AirSchedule_IOS
//
//  Created by Chenny on 18/08/2018.
//  Copyright © 2018  Gusam Park. All rights reserved.
//

import UIKit

class ParsingViewController: UITableViewController {
    
    private var parse: PublicDataParse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        parse = PublicDataParse()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.parse.airItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "parseCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = self.parse.airItems[indexPath.row].title()
        
        return cell
    }
    
}

