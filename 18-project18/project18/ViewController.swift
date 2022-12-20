//
//  ViewController.swift
//  project18
//
//  Created by Joseph Zhu on 8/11/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(1,2,3, separator: "-", terminator: ".")
        //assert (1==1, "Math failure!")
        
        //step over: fn+f6
        //continue: ctrl+cmd+y
        //back trace
        //lldb debugger window
        //breakpt navigator, exception = unhandled errors crash
        //capture view hierachy
        for i in 1...20 {
            print("Got number \(i)")
        }
    }


}

