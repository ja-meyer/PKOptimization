%=========================================================================%
% Objective function for optimizing the dosing of propranolol for         %
%       migraine treatment based on minimizing cost of medication         %
% This function uses the results from propranolol_pharma as inputs        %
%                                                                         %
% Inputs:                                                                 %
% n_tot - the number of times medication is taken each day                %
% num_tabs - the number of 10mg,20mg,40mg,60mg and 80mg tablets taken,    %
%       respectively, in an array                                         %
% Days - The total number of days over which the dosage is checked        %
% avg - The average concentration of medication in the brain after it     %
%       reaches a steady range                                            %
% w - optional array input for the weight of the cost of medication,      %
%       concentration of medication in brain and number of times each     %
%       day that medication is taken, respectively. All values set to 1   %
%       if there is no input                                              %
%                                                                         %
% Output:                                                                 %
% x - the objective function value                                        %
%=========================================================================%


function [z1,grad] = CostMinObj(num_tabs,w)
    % Applies 1 to each weight if there is no input for w
    if (~exist('w','var'))
        w = [1, 1, 1];
    end
    
    % Average cost of 10mg, 20mg, 40mg, 60mg and 80mg, respectively, 
    % divided by the mg amount to find cost per mg (found at drugs.com)
    %C_tab = [0.021, 0.012, 0.009, 0.010, 0.005];
    % Original Cost:
    %C_tab = [0.21, 0.24, 0.36, 0.61, 0.41];
    
    %C_tab = [0.22, 0.24, 0.21, 0.61, 0.42];
    %C_tab = [0.21, 0.24, 0.15, 0.61, 0.41];
    
    C_tab = [0.16, 0.12, 0.24, 0.36, 0.74];
    
    %Record this one
    %C_tab = [0.11, 0.24, 0.05, 0.27, 0.1];
    
    %C_tab = [0.09, 0.08, 0.16, 0.24, 0.41];
    
    % Cost of the dose
    Cd = C_tab(1)*num_tabs(1) + C_tab(2)*num_tabs(2) ...
       + C_tab(3)*num_tabs(3) + C_tab(4)*num_tabs(4) ...
       + C_tab(5)*num_tabs(5);
    
    %x = w(1)*Cd - w(2)*avg + w(3)*n_tot;
    z1 = w(1)*Cd;
    
    
    grad = [C_tab];
    
end