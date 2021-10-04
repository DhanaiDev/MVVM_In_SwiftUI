# MVVM_In_SwiftUI

Model: Hold Data which is purely Data Structure in this Project we have a List of Public API corresponding to the Journal and respective Link.\n
View: In this Project, we Hold SwiftUI View which shows a List of API titled as API Name and Description on tap of List it Open Corresponding Public API Documentation.
ViewModel: This is the Place where View will communicate to ViewModel whereas ViewModel Communicate the Server and Update Data to Model. Here we complete the Business logic for the module with help of the raw Model to View.

Each Architecture Hold different Pros and Cons as similar MVVM Holds Pros and Cons. We cant able to implement MVVM for All Modules. But MVVM apts well for SwfitUI because we use View in Swift Which is a direct View where else UIKit hold UIViewController Which hold View reference and View Reference Take care of ViewModel Reference.
