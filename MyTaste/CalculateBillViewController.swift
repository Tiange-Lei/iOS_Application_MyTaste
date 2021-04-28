//
//  CalculateBillViewController.swift
//  MyTaste
//
//  Created by Ahmad on 27/1/21.

import UIKit

class CalculateBillViewController: UIViewController, UITextFieldDelegate {
    
    // The following lines of code add variable Outlet to the different items of the view
    @IBOutlet weak var TipSplitTextField: UITextField!
    @IBOutlet weak var TotalTextField: UITextField!
    @IBOutlet weak var TipPercentageLabel: UILabel!
    @IBOutlet weak var TotalBillTextField: UITextField!
    @IBOutlet weak var TipTextField: UITextField!
    @IBOutlet weak var TotalSplitTextField: UITextField!
    @IBOutlet weak var SplitLabel: UILabel!
    var TotalBill: Double? {
        return Double(TotalBillTextField.text!)
    }
    
    var tipPercentage: Double = 0.10;
    var numbOfPeople: Double = 1.0;
    private var formatter: NumberFormatter!;
    
    // The below function is the entry function of this view. It will load with the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize the amount with 0.00 before the user enter a decimal value
        TotalBillTextField.text = "0.00";
        // The below code will work to dissmiss the Keyboard once the user finish editing and touch outside the textfield
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dissmissKeyboard(_:)));
        self.view.addGestureRecognizer(tapGesture);
        TotalBillTextField.delegate = self;
        // The below code is to format the amount value as a decimal
        formatter = NumberFormatter();
        formatter.numberStyle = NumberFormatter.Style.decimal;
        formatter.minimum = 0;
        // The below function will update values
        updateValsOnChange();
    }
    
    // This function in used to dissmiss the keyboard
    @objc func dissmissKeyboard(_ sender: UITapGestureRecognizer) {
        TotalBillTextField.resignFirstResponder();
    }
    
    // The below action will run the updateValuesOnChange() when the Ttotal Bill field is edited
    @IBAction func TotalBillTexyFieldChanged(_ sender: UITextField) {
        updateValsOnChange();
    }
    
    // The below code is from the textfield delegate and it clear the TotalValue before the user enter a new one
    func textFieldDidBeginEditing(_ textField: UITextField) {
        TotalBillTextField.text = "";
    }
    
    // The below code will put 0.00 if the user don't enter/change the value in the field
    func textFieldDidEndEditing(_ textField: UITextField) {
        if TotalBillTextField.text == "" {
            TotalBillTextField.text = "0.00"
        }
    }
    
    // The below code will automatically change the value of the different fields on the vue on any changes
    func updateValsOnChange() {
        if let totalBillVal = self.TotalBill {
            TipTextField.text = String(format: "$%.2f", (totalBillVal * tipPercentage));
            TotalTextField.text = String(format: "$%.2f", (totalBillVal * tipPercentage) + totalBillVal);
            TipSplitTextField.text = String(format: "$%.2f", (totalBillVal * tipPercentage) / numbOfPeople);
            TotalSplitTextField.text = String(format: "$%.2f", ((totalBillVal * tipPercentage) + totalBillVal) / numbOfPeople)
        }
    }
    
    // The below code changes the Tip slider and run the updatevalsonchange to calculate the values accordingly
    @IBAction func TipSliderChanged(_ sender: UISlider) {
        let sliderVal = Int(sender.value);
        TipPercentageLabel.text = "\(sliderVal)%";
        tipPercentage = Double(Int(sender.value)) * 0.01;
        updateValsOnChange();
    }
    
    
    // The below code changes the split stepper to change how many people to split the bill between
    @IBAction func SplitStepper(_ sender: UIStepper) {
        let stepperVal = Int(sender.value);
        SplitLabel.text = "\(stepperVal)";
        numbOfPeople = Double(stepperVal);
        updateValsOnChange();
    }
}

