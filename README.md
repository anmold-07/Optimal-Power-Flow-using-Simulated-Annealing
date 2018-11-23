# Optimal-Power-Flow-using-Simulated-Annealing

The codes for this mini-project are part of the assignment for the course EEPE40 - Modern Optimization Techniques for Electrical Power Systems at NIT Tiruchirappalli, India.

# This mini-project mainly contains three files:   
The first file "Newton Raphson Implementation" solves an OPF problem using Newton Raphson load flow solution.  

The Second file "SAA implementation on standard functions" finds the optimum solutions to standard functions like Ackley, Easom and Himmelblau.  

The third file "SAA-OPF implementation using MATPOWER loadflow" solves an OPF for an IEEE-14 and IEEE-30 Bus System with an objective to minimize losses in the network, using a MATPOWER load flow solution techniques from the MATPOWER package. In order to keep a check on the constraints, a penalty function is added "penalty=penalty_slack+penalty_V+penalty_Qgen" to keep the real, reactive powers and the voltages under limits. A suitable function in the file "sph.m" is used to keep the variables under limits.


# How to Run the Files?
Add the following files in the MATPOWER package so that you don't miss any load-flow file. The file named "sa1.m" is the main file, which upon execution calls all the other sub-routines responsible to run the OPF. You can modify/control all the parameters of Simuated Annealing from the sa1.m. The result are finally displayed in the form of a graph. 
