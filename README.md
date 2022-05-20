# PKOptimization
Optimization of a pharmacokinetic model using propranolol for the preventative treatment of migraines

These files can be used to simulate treatment of migraines with propranolol by using pharma_dose and propranolol_pharma. There is an option to display a graph of the simulation and it will output the average brain concentration of propranolol over a specified amount of time.

For optimizing the dose of the medication all files are used. PKOpt has a set up of initial conditions and the functions will optimize first based off minimizing cost then by maximizing dose. The maximizing dose functions require inputs from the minimizing costs functions. However, it is possible to set it to minimize cost without then attempting to maximize the dose.
