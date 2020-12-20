# Bavaria-Covid
All code is written in VIPER clean architecture model.

According to folder structure, folder and classes are like following:-
- ViewController(this folder contains all the V from VIPER, which is Viewcontroller)
  - MapVC.swift :- this class contains all the map related stuffs, like update map with trafic colors:- Green, Red, Dark Red and yellow.
  - BottomSheetVC.swift :-  this class is for showing bottomsheet while loading data and info for the user zone, like in Greenm red or Dark red zone
- Interactor(As the name suggest from VIPER, it represents for Interactor )
  - MapInteractor.swift :- as the name suggests it fetch data from backend and pass it to presenter, so it can display data in MapVC.
- Presenter (From VIPER, Presenter is responsible to display data in app)
  - AlertControl.swift :- all the alert related stuffs are defined here.
  - LocationPresenter.swift :- location related stuff, from defination to implementaion is defined in this class.
  - MapPresenter.swift :- Updating map screen after fetching data from Interactor.
- Entity(all models what is used to parse data)
- Router(In VIPER model Router is used to navigate from one screen to another but here we only have one screen so no need to code here.)
- Protocols(protocol are the classes what are connecting Interactor with presenter.
- Storyboard:- All the storyboard files defined here.
- SystemDefaults:- Appdelegate and Scenedelegate are defined here.
- Webservice:- Helper class for Interactor.
- Extension:- Extension and constant files are deinfed.


Note:- Code is only tested on iPhone 12 pro max, so smaller devices may have some issues with bottom sheet.
