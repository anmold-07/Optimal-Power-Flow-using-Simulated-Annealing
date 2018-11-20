# Optimal-Power-Flow-using-Simulated-Annealing

The codes for this mini-project are part of the assignment for the course EEPE40 - Modern Optimization Techniques for Electrical Power Systems at NIT Tiruchirappalli, India.

This mini-projects mainly contains three files:   
The first file "Newton Raphson Implementation" solves an OPF problem using Newton Raphson load flow solution.  

The Second file "SAA implementation on standard functions" finds the optimum solutions to standard functions like Ackley, Easom and Himmelblau.  

The third file "SAA-OPF implementation using MATPOWER loadflow" solves an OPF for an IEEE-14 and IEEE-30 Bus System with an objective to minimize losses in the network, using a MATPOWER load flow solution techniques from the MATPOWER package.  
In order to keep a check on the constraints, a penalty function is added "penalty=penalty_slack+penalty_V+penalty_Qgen" in order to keep the real, reactive-power and the voltages under limits. 
