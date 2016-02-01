# Project 2
The purpose of this project is to design an interlock system between a moderday bathysphere
and an experimental ocean bottom habitat.


## Authors

| Name              | Role          |
| -------------     | ------------- |
| Minh Khuu         | Member        |
| Denny Ly          | Member        |
| Ruchira Kulkarni  | Member        |

## Specification
* On Arrival
  * Bathysphere must signal the docking port 5 minutes before arrival
  * If interlock chamber is empty, the signal from the bathysphere should cause inner and outer ports of the interlock to be closed and sealed
  * After ports are closed a sealed, chamber is filled and pressured to a pressure difference between the chamber interior and the outside of the port to less than 0.1 atm.
  * When the pressure difference between the inside and exterior of the chamber reaches less than 0.1, the outer port shall be opened.
  * Filling and pressurizing the chamber takes 7 minutes.
  * When the outer port is fully opened, bathysphere can enter the interlock.
  * When the bathysphere is fully inside the interlock, the outer port is closed and sealed.
  * After the ports are closed and sealed, the chamber shall be evacuated and managed to pressure difference between the chamber interior and the outside of the inner port to less than 0.1 atm.
  * When the chamber has been evacuated and the pressure difference between the chamber interior and the exterior of the inner port reaches less than 0.1 atm, the inner port shall be opened.
  * Emptying and depressurizing the chamber takes 8 minutes.
  * When the inner port is opened, the aquanauts can exit the bathysphere.
* On Departure
  * When the bathysphere is to leave the interlock, the outer port must be closed and sealed.
  * After the outer port is closed and sealed and if the interlock chamber is empty and the pressure difference between the exterior of the inner port and the interlock chamber is less than 0.1 atm, the inner port can be opened and the aquanauts can enter the interlock and the bathysphere.
  * The bathysphere must signal the docking station 5 minutes prior to departure. The signal from the bathysphere should cause inner and outer ports of the interlock to be closed and sealed.
  * After the ports are closed and sealed and the chamber flooded, the pressure difference between the chamber interior and the exterior of the outer port shall be managed and controlled to less than 0.1 atm.
  * When the pressure difference between the interior of the chamber and the exterior of the outer ports reaches less than 0.1 atm, the outer port shall be opened.
  * Filling and pressurizing the chamber takes 7 minutes.
  * When the outer port is fully opened, the bathysphere can exit the interlock.
  * When the bathysphere is fully outside the interlock, the outer port is closed and sealed and the interlock emptied and depressurized to 1 atm.
  * When the pressure difference between the chamber interior and the exterior of the inner port reaches less than 0.1 atm, the inner port can be opened.
  * Pressurizing the chamber takes 8 minutes.

## Notes
Board Model Number
* 5CSEMA5F31C6
