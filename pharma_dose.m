%=========================================================================%
%  Function to assign the tablets and dosage over the specified number of % 
%           times the medication is taken each day                        %
%  The results of this function can be fed into propranolol_pharma to     %
%  evaluate the effectiveness of the dosing                               %
%                                                                         %
%  Inputs:                                                                %
%  n10, n20, n40, n60, n80 are the number of tablets required of size     %
%  10,20,40,60 and 80 mg, respectively                                    %
%  d_total - the total mg dose per day                                    %
%  n_tot - the number of times medication is taken each day (1-4)         %
%                                                                         %
%  Outputs:                                                               %
%  D - an array of the amount (in mg) of drug taken at each dosing time   %
%                                                                         %
%=========================================================================%

function D = pharma_dose(n10,n20,n40,n60,n80,n_tot)

% creating array of the number of each tablet size
n_tablet = [n80, n60, n40, n20, n10]; 
% Dose amount per tablet in mg
tab_dose = [80, 60, 40, 20, 10]; 
d_total = 0;

for i = 1:length(n_tablet)
    d_total = d_total + n_tablet(i).*tab_dose(i);
end

for i = 1:length(n_tablet)       
    if mod(n_tablet(i),1) ~= 0
        error('The number of tablets must be an iteger')
    end
end
    
msg = ['The number of times medication is taken each day must be an'...
        ' integer between 0 and 4'];
if mod(n_tot,1) ~= 0 || n_tot < 0 || n_tot > 4
    error(msg)
end

% if d_total < 30
%     disp(['The daily dosage is lower than the minimum recommended'...
%       ' dosing'])
%     D = [];
%     return
% end
% 
% if d_total > 640
%     disp(['The daily dosage is higher than the maximum dosing'])
%     D = [];
%     return
% end


% Evenly divides total mg/day into an exact mg/dose
dose = d_total/n_tot; 
% Initializes an array for the doses
D = [];
n_tablet;
% This for loop uses any tablets that are a larger dose size than the
% dose variable as a single dose
for i = 1:length(n_tablet)
    while tab_dose(i) >= dose && n_tablet(i) > 0
            D = [D; tab_dose(i)];
            n_tablet(i) = n_tablet(i) - 1;
    end
end
%D
%n_tablet

% This for loop checks the remaining tablets to get a dose size that 
% does not exceed the dose variable
for i = 1:length(n_tablet)
    %fprintf('n_tablet %d = %d',i,n_tablet(i));
    
    while n_tablet(i) > 0
        D_temp = tab_dose(i);
        for j = i:length(n_tablet)
            tab_dose(j);
            n_tablet(j);
            % The following if statement adds the tablet to the dose if it 
            % meets the criteria
            if D_temp + tab_dose(j) <= dose && n_tablet(j) > 0
            	D_temp = D_temp+tab_dose(j);
            	n_tablet(j) = n_tablet(j) - 1;
                n_tablet(j);
                % The following if statement checks to see if an additional
                % tablet can be added
                if D_temp + tab_dose(j) <= dose && n_tablet(j) > 0
                    D_temp = D_temp+tab_dose(j);
                    n_tablet(j) = n_tablet(j) - 1;
                end
            end
        end
        n_tablet(i) = n_tablet(i) - 1;
        D_extra = [];
        if length(D) < n_tot
            % Assigns D_temp to the next available position of D
            D = [D;D_temp]; 
        else
            D_extra = [D_extra;D_temp];
        end
    end
    if length(D) == n_tot
        break
    end
end

%disp(n_tablet);

% Assigning remaining tablets to the smallest dose in D
for i = 1:length(n_tablet) 
    while n_tablet(i) > 0
        if n_tablet(i) > 0
            c = find(D == min(D));
            D(c(1)) = D(c(1)) + tab_dose(i);
            n_tablet(i) = n_tablet(i) - 1;
        end
    end
end

if length(D) < n_tot
    for i = length(D)+1:n_tot
        D(i) = 0;
    end
end

%disp(D);