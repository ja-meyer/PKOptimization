%% Function for steepest descent for second objective function            %
% requires pharma_dose.m, PharmaObj2.m, propranolol_pharma.m              %
%                                                                         %
% Inputs: X     - initial tablet numbers                                  %
%         n_tot - number of times medication is taken each day            %
%         z1    - Objective function value from first objective function  %
% Output: Xs    - The optimized number of tablets of each type to take in %
%                 a day                                                                   %
%         D     - Objective function value for second objective function  %
%         z2    - New objective function value for first objective        %
%                 function                                                %
%-------------------------------------------------------------------------%

function [Xs,D,z2,avg2] = DoseMaxSteep(X,n_tot,z1,avg1)

%disp('** Starting pharmasteep2 **')
z = z1;
D = DoseMaxObj(X);
Xm = X;
average = avg1;

for i = length(X):-1:1  
    %disp(['i=',num2str(i)])
   
    X_temp = X;
    X_temp(i) = X_temp(i) + 1;
    time = 16;
    %disp(['X_temp = ', num2str(X_temp)])
    
    zp = CostMinObj(X_temp);
    dose2 = pharma_dose(X_temp(1),X_temp(2),X_temp(3),X_temp(4),...
            X_temp(5),n_tot);
    [avg2] = propranolol_pharma(dose2,time);
    
    
    % If beneficial, X_temp is stored as Xs, if not then steepest descent
    % is used
    if (z >= zp) && (avg2 >= average)
        Xs = X_temp;
        % Store Xs in X for next iteration
        X = Xs;
        average = avg2;
    else
        Xp = X_temp;
        delt = zeros(length(Xp),1);
        for j = 1:length(Xp)
            if (i == j) || (Xp(j) == 0)
                delt(j) = 0;
            else
                delt(j) = 1;
            end
            Xp(j) = Xp(j) - delt(j);
        end
        %disp(['Xp=',num2str(Xp)])
        
        % Recalculate daily dose
        dose = pharma_dose(Xp(1),Xp(2),Xp(3),Xp(4),Xp(5),n_tot); 
        % Amount of time per day available for all doses to be taken. 
           % Ex: We want all doses to be evenly spaced from 6am and 9pm
        time = 16; 
        [avg] = propranolol_pharma(dose,time);

           % Feasibility check for Xs
        while (avg < 0.2825 || avg > 1.6967)
                while avg < 0.2825
                    %disp('*avg<0.2825 so add tablets')
                        Xp(i) = Xp(i) + 1;
                        dose = pharma_dose(Xp(1),Xp(2),Xp(3),Xp(4),...
                               Xp(5),n_tot);
                        [avg] = propranolol_pharma(dose,time);
                end 
                %disp(['Xp = ',num2str(Xp)])
        
                % If the average is too large, take away a tablet from the 
                % smallest options, if there are any
                while avg > 1.6967 
                %disp('*avg>1.6967 so take away tablets')
                if Xp(1) > 0
                    Xp(1) = Xp(1) - 1;
                elseif Xp(2) > 0
                    Xp(2) = Xp(2) - 1;
                elseif Xp(3) > 0
                    Xp(3) = Xp(3) - 1;
                elseif Xp(4) > 0
                    Xp(4) = Xp(4) - 1;
                elseif Xp(5) > 0
                    Xp(5) = Xp(5) - 1;
                end
                %disp(['Xp = ',num2str(Xp)])
                dose = pharma_dose(Xp(1),Xp(2),Xp(3),Xp(4),Xp(5),n_tot);
                [avg] = propranolol_pharma(dose,time);
            end
        end
        
        % Check objective function value from first objective function and
        % store Xs as Xp if beneficial
        zp = CostMinObj(Xp);
        dose_temp = pharma_dose(Xp(1),Xp(2),Xp(3),Xp(4),Xp(5),n_tot);
        [avg_temp] = propranolol_pharma(dose_temp,time);
        
        if (z >= zp) && (avg_temp >= average)
            Xs = Xp;
            % Store Xs in X for next iteration
            X = Xs;
            average = avg_temp;
        else
            Xs = X;
        end
        
        for j = 1:length(Xp)
            if j ~= i
                if Xp(j) > 0
                    Xp(j) = Xp(j) - 1;
                end
            end
        end
        
        zp = CostMinObj(Xp);
        dose2 = pharma_dose(Xp(1),Xp(2),Xp(3),Xp(4),Xp(5),n_tot);
        [avg2] = propranolol_pharma(dose2,time);
        
        if (z >= zp) && (avg2 >= average)
            Xs = Xp;
            % Store Xs in X for next iteration
            X = Xs;
            average = avg2;
        else
            Xs = X;
        end
    end
    
end

    D = DoseMaxObj(Xs);
    [z2,grad] = CostMinObj(Xs);
    dose = pharma_dose(Xs(1),Xs(2),Xs(3),Xs(4),Xs(5),n_tot);
    [avg2] = propranolol_pharma(dose,time);
    
    % Print out results from both objective functions %
    fmtcost = ['\n****RESULTS**** \nWith a cost vector of \ncost = [' ...
              repmat(' %1.2f ',1,numel(grad)) ']\n\n'];
    fmt = ['Xs =' repmat(' %1.0f ',1,numel(Xs)) '\n'];
    fmt2 = ['with an objective function value of z = %2.2f \n'];
    fmt3 = ['and an average brain concentration of %2.4f. \n\n'];

    fprintf(fmtcost,grad)
    fprintf('****Results of CostMinSteep****\n')
    fprintf(fmt,Xm)
    fprintf(fmt2,z1)
    fprintf(fmt3,avg1)
    
    fmt4 = ['with an objective function value for CostMinObj of z = %2.2f,'... 
           '\n'];
    fmt5 = ['an objective function value for DoseMaxObj of D = %2.2f,\n'];
    fmt6 = ['and an average brain concentration of %2.4f.\n'];
    
    fprintf('****Results of DoseMaxSteep:****\n')
    fprintf(fmt,Xs)
    fprintf(fmt4,z2)
    fprintf(fmt5,D)
    fprintf(fmt6,avg2)
    fprintf('****End Results****\n')

end

