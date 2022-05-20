%% Function for steepest descent for first objective function             %
% requires pharma_dose.m, PharmaObj1.m, propranolol_pharma.m,             %
% DosePropUp.m and DosePropDown.m                                         %
%                                                                         %
% Inputs: n10,n20,n40,n60,n80 and n_tot as initial conditions             %
%         tol - optional input, set to 10^-4 by default                   %
% Output: Xs - The optimized number of tablets of each type to take in a  %
% day                                                                     %
%-------------------------------------------------------------------------%

function [Xs,z,avg] = CostMinSteep(n10,n20,n40,n60,n80,n_tot,tol)

if (~exist('tol','var'))
    tol = 10^-4;
end

%disp(['With initial conditions'])

D = pharma_dose(n10,n20,n40,n60,n80,n_tot); % Calculates daily dosage
time = 16; % Amount of time per day available for all doses to be taken. 
           % Ex: We want all doses to be evenly spaced from 6am and 9pm
% To calculate average brain concentration on initial dosage
[avg] = propranolol_pharma(D,time); 
xc = [n10,n20,n40,n60,n80]; % Current number of tablets

[OpVal, grad] = CostMinObj(xc); % Calculate objective function value
%fprintf('Objective function value is %6.4f\n',OpVal);

lambda = zeros(length(grad),1); % Set up array for lambda values

for i=1:length(grad)
    % Calculate the lambda values as 1/gradient values
    lambda(i) = 1/grad(i); 
end

OpValp = 0; % initializes an objective function value

itercount1 = 0; % Initializes a count for each iteration

while abs(OpVal - OpValp) > tol
    
    OpVal = OpValp;
    xp = xc - round(lambda'.*grad,0); % Find the next tablet amounts
    for i=1:length(xp)
        if xp(i) < 0
            xp(i) = 0; % sets any negative values to zero
        end
    end
    
    %fprintf('\n');
    %fprintf('With updated tablet numbers');
    %fprintf('%2d',xp);
    %fprintf('\n');

    % Recalculate daily dose
    D = pharma_dose(xp(1),xp(2),xp(3),xp(4),xp(5),n_tot); 
    % For new average brain concentration
    [avg] = propranolol_pharma(D,time); 
    
    itercount = 0;
    % Checking for feasibility of dose
    while (avg < 0.2825 || avg > 1.6967)
        while avg < 0.2825
            xp(1) = xp(1) + 1;
            D = pharma_dose(xp(1),xp(2),xp(3),xp(4),xp(5),n_tot);
            [avg] = propranolol_pharma(D,time);
        end
        %Check objective function value
        [ObjVal_temp,grad] = CostMinObj(xp);
        
        %Call dosage propogate function - print updated tablet numbers
        xp = DosePropUp(xp,grad);
        %fprintf('New tablet numbers:');
        %fprintf('%2d',xp);
        %fprintf('\n');
        
        %Check obj function value again for comparison
        [ObjVal_temp,grad] = CostMinObj(xp);
        %fprintf('New objective function value is %6.4f\n',ObjVal_temp);
        
        % If the average is too large, take away a tablet from the smallest 
        % options, if there are any
        while avg > 1.6967 
            if xp(1) > 0
                xp(1) = xp(1) - 1;
            elseif xp(2) > 0
                xp(2) = xp(2) - 1;
            elseif xp(3) > 0
                xp(3) = xp(3) - 1;
            elseif xp(4) > 0
                xp(4) = xp(4) - 1;
            elseif xp(5) > 0
                xp(5) = xp(5) - 1;
            end
            D = pharma_dose(xp(1),xp(2),xp(3),xp(4),xp(5),n_tot);
            [avg] = propranolol_pharma(D,time);
        end
        % Check obj function value
        [ObjVal_temp,grad] = CostMinObj(xp);
        %fprintf('New objective function value is %6.4f\n',ObjVal_temp);
        
        % DO WE NEED TO PROPOGATE DOWN? Print updated tablet numbers
        xp = DosePropDown(xp,grad);
        %fprintf('New tablet numbers:');
        %fprintf('%2d',xp);
        %fprintf('\n');
        
        % Check obj function value again for comparison
        [ObjVal_temp,grad] = CostMinObj(xp);
        %fprintf('New objective function value is %6.4f\n',ObjVal_temp);
        
        % Adds to the iteration count, ensuring that there is no infinite
        % loop happening
        itercount = itercount + 1;
        if itercount >= 100
            disp(['Average brain concentration not getting within'...
                ' feasible range'])
            break
        end
    end
     % Find a new objective function value with updated info
    [OpValp, grad] = CostMinObj(xp);
    %fprintf('Objective function value is %6.4f\n',OpValp);
    xc = xp;
    itercount1 = itercount1 + 1;
    
    if itercount1 >= 100
        disp(['Something`s wrong'])
        break
    end
end

Xs = xp; % Optimal number of tablets
z = OpValp; % Objective function value
D = pharma_dose(Xs(1),Xs(2),Xs(3),Xs(4),Xs(5),n_tot);
avg = propranolol_pharma(D,time);

end
