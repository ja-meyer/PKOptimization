%=========================================================================%
% Dosage propogate down function - checks to see if it is more cost       %
% effective to switch to a smaller tablet size if there are multiples of  %
% larger tablet sizes that add up to the same mg amount. Used in          %
% pharmasteep.m                                                           %
%                                                                         %
% Inputs: xp - the current amount of each tablet size found using         %
%         pharmasteep.m                                                   %
%         grad - the gradient vector from PharmaObj.m used to calculate   %
%                the cost of the dose                                     %
%                                                                         %
% Output: X - The new number of each tablet size, used in pharmasteep.m   %
%             to calculate the objective function value                   %
%=========================================================================%

function X = DosePropDown(xp,grad)

% Checks cost per tablet, PharmaObj give the gradient in cost per mg
%cost = [grad(1)*10 grad(2)*20 grad(3)*40 grad(4)*60 grad(5)*80];
cost = grad;

if xp(5) > 0
    x_temp3 = xp(3) + 2*xp(5);
    x_temp5 = 0;
    
    c_temp1 = 0;
    for i = 1:length(xp)
        c_temp1 = c_temp1 + cost(i)*xp(i);
    end
    
    c_temp2 = cost(1)*xp(1) + cost(2)*xp(2) + cost(3)*x_temp3 ...
            + cost(4)*xp(4) + cost(5)*x_temp5;
    
    if c_temp1 >= c_temp2
        xp(3) = x_temp3;
        xp(5) = x_temp5;
    end
end

if xp(5) > 0
    x_temp2 = xp(2) + xp(5);
    x_temp4 = xp(4) + xp(5);
    x_temp5 = 0;
    
    c_temp1 = 0;
    for i = 1:length(xp)
        c_temp1 = c_temp1 + cost(i)*xp(i);
    end
    
    c_temp2 = cost(1)*xp(1) + cost(2)*x_temp2 + cost(3)*xp(3) ...
            + cost(4)*x_temp4 + cost(5)*x_temp5;
    
    if c_temp1 >= c_temp2
        xp(2) = x_temp2;
        xp(4) = x_temp4;
        xp(5) = x_temp5;
    end
end

if xp(4) > 0
    x_temp2 = xp(2) + xp(4);
    x_temp3 = xp(3) + xp(4);
    x_temp4 = 0;
    
    c_temp1 = 0;
    for i = 1:length(xp)
        c_temp1 = c_temp1 + cost(i)*xp(i);
    end
    c_temp2 = cost(1)*xp(1) + cost(2)*x_temp2 + cost(3)*x_temp3 ...
            + cost(4)*x_temp4 + cost(5)*xp(5);
    
    if c_temp1 > c_temp2
        xp(2) = x_temp2;
        xp(3) = x_temp3;
        xp(4) = x_temp4;
    end
end

if xp(3) > 0
    x_temp2 = xp(2) + 2*xp(3);
    x_temp3 = 0;
    
    c_temp1 = 0;
    for i = 1:length(xp)
        c_temp1 = c_temp1 + cost(i)*xp(i);
    end
    c_temp2 = cost(1)*xp(1) + cost(2)*x_temp2 + cost(3)*x_temp3 ...
            + cost(4)*xp(4) + cost(5)*xp(5);
    
    if c_temp1 > c_temp2
        xp(2) = x_temp2;
        xp(3) = x_temp3;
    end
end

if xp(2) > 0
    x_temp1 = xp(1) + 2*xp(2);
    x_temp2 = 0;
    
    c_temp1 = 0;
    for i = 1:length(xp)
        c_temp1 = c_temp1 + cost(i)*xp(i);
    end
    c_temp2 = cost(1)*x_temp1 + cost(2)*x_temp2 + cost(3)*xp(3) ...
            + cost(4)*xp(4) + cost(5)*xp(5);
    
    if c_temp1 > c_temp2
        xp(1) = x_temp1;
        xp(2) = x_temp2;
    end
end

X = xp;

end