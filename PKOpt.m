% Initial Conditions
n10 = 0; % Number of 10mg tablets taken per day
n20 = 0; % Number of 20mg tablets taken per day
n40 = 2; % Number of 40mg tablets taken per day
n60 = 2; % Number of 60mg tablets taken per day
n80 = 0; % Number of 80mg tablets taken per day
n_tot = 3; % number of times per day medication is taken

%d = [10 20 40 60 80];


% Finding first objective function value
[Xs,z1,avg1] = CostMinSteep(n10,n20,n40,n60,n80,n_tot);

% Finding Second Objective function value
[Xs2,D,z2] = DoseMaxSteep(Xs,n_tot,z1,avg1);