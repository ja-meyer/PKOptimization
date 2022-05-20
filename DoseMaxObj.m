%=========================================================================%
% Objective function for optimizing the dosing of propranolol for         %
%       migraine treatment based on maximizing total daily dosage in      %
%       order to maximize the average brain concentration, subject to     %
%       constraints of first objective function
% This function uses the results from propranolol_pharma                  %
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
% z2 - the objective function value                                       %
%=========================================================================%

function [z2, grad] = DoseMaxObj(num_tabs,w)
    % Applies 1 to each weight if there is no input for w
    if (~exist('w','var'))
        w = [1, 1, 1];
    end 
   
    % mg size of tablets
    D_tabs = [10 20 40 60 80];
    
    % Total mg dose per day
    D_sum = D_tabs(1)*num_tabs(1) + D_tabs(2)*num_tabs(2) ...
          + D_tabs(3)*num_tabs(3) + D_tabs(4)*num_tabs(4) ...
          + D_tabs(5)*num_tabs(5);
    
    grad = D_tabs;
    z2 = w(2)*D_sum;

end
