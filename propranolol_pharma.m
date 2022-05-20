%=========================================================================% 
%  Pharmacokinetic Solver in a for loop (14 Days) using PROPRANOLOL data  %
%  This function takes input of mg per dose (1-4 per day) as well as the  %
%  length of time in the day that the doses will be evenly distributed    %
%  This function uses  the results from pharma_dose as input              %
%                                                                         %
%  Inputs:                                                                %
%  D - This will be calculated using the function pharma_dose             %
%  time - user defined between 12 and 16 hours                            %
%                                                                         %
%  Outputs:                                                               %
%  ypharm_tot (mg/kg) - column one is the GI tract drug concentration     %
%  over time, column two is the blood drug concentration over time, and   %
%  column three is the brain drug concentration over time (mg/kg)         %
%  tpharm_tot - an array with all times that are calculated from 0 to 14  %
%  days given in hours.                                                   %
%=========================================================================%

function [avg, ypharm_tot, tpharm_tot, Days] = propranolol_pharma(D,time)

if time < 12 || time > 16
    error(['The time does not fall within the specified time interval of'...
         ' 12 to 16 hours'])
    ypharm_tot = [];
    tpharm_tot = [];
    Days = [];
    avg = [];
end

if length(D) == 0
    ypharm_tot = [];
    tpharm_tot = [];
    Days = [];
    avg = [];
    return
end

Days = 14; % Number of days that the function is defined for
D_norm = zeros(1,length(D));
for i = 1:length(D)
    % Standardize the dosage amounts to mg/kg using the minimum weight 
    % requirement for an adult dose

    D_norm(1,i) = D(i)/35; 
    end

t_int = time/(length(D)-1);
% time after each dose
tspan_pharm = [0 t_int; 0 t_int; 0 t_int; 0 24-time]; 
y0_pharm=[D_norm(1) 0 0]; % initial conditions for first dose

if length(D_norm(1,:)) ==1 % Initial day for a once a day dose

    [tpharm,ypharm]=ode45(@pharmfun,tspan_pharm(1,:),y0_pharm);
    y0_pharm2 = [D(2)+ypharm(end,1) ypharm(end,2) ypharm(end,3)];
    
    tpharm_tot = tpharm;
    ypharm_tot = ypharm;
    
    d_time = [0];
else
    if length(D_norm(1,:)) == 2 % Initial day for a twice a day dose
        d_time = [0 tspan_pharm(1,2)];

        [tpharm,ypharm]=ode45(@pharmfun,tspan_pharm(1,:),y0_pharm);
        y0_pharm2 = [D(2)+ypharm(end,1) ypharm(end,2) ypharm(end,3)];

        [tpharm2,ypharm2] = ode45(@pharmfun,tspan_pharm(2,:),y0_pharm2);
        tpharm2 = tpharm2 + d_time;

        tpharm_tot = [tpharm; tpharm2];
        ypharm_tot = [ypharm; ypharm2];
    
    else
        if length(D_norm(1,:)) == 3 % Initial day for a 3 times a day dose
            d_time = [0 tspan_pharm(1,2) tspan_pharm(1,2)...
                +tspan_pharm(2,2)];

            [tpharm,ypharm]=ode45(@pharmfun,tspan_pharm(1,:),y0_pharm);
            y0_pharm2 = [D_norm(2)+ypharm(end,1) ...
                ypharm(end,2) ypharm(end,3)];

            [tpharm2,ypharm2] = ode45(@pharmfun,tspan_pharm(2,:),...
                y0_pharm2);
            tpharm2 = tpharm2 + d_time(1,2);

            y0_pharm3 = [D_norm(3)+ypharm2(end,1) ypharm2(end,2) ...
                ypharm2(end,3)];

            [tpharm3,ypharm3] = ode45(@pharmfun,tspan_pharm(3,:),...
                y0_pharm3);
            tpharm3 = tpharm3 + d_time(1,3);

            tpharm_tot = [tpharm;tpharm2;tpharm3];
            ypharm_tot = [ypharm;ypharm2;ypharm3];
        
        else
            % Initial day for a 4 times a day dose
            if length(D_norm(1,:)) == 4 
                d_time = [0 tspan_pharm(1,2) tspan_pharm(1,2)...
                    +tspan_pharm(2,2) tspan_pharm(1,2)+tspan_pharm(2,2)...
                    +tspan_pharm(3,2)];

                [tpharm,ypharm]=ode45(@pharmfun,tspan_pharm(1,:),...
                    y0_pharm);
                y0_pharm2 = [D_norm(2)+ypharm(end,1) ypharm(end,2) ...
                    ypharm(end,3)];

                [tpharm2,ypharm2] = ode45(@pharmfun,tspan_pharm(2,:),...
                    y0_pharm2);
                tpharm2 = tpharm2 + tspan_pharm(1,end);

                y0_pharm3 = [D_norm(3)+ypharm2(end,1) ypharm2(end,2) ...
                    ypharm2(end,3)];

                [tpharm3,ypharm3] = ode45(@pharmfun,tspan_pharm(3,:),...
                    y0_pharm3);
                tpharm3 = tpharm3 + tspan_pharm(1,end) ...
                    + tspan_pharm(2,end);

                y0_pharm4 = [D_norm(4)+ypharm3(end,1) ypharm3(end,2) ...
                    ypharm3(end,3)];

                [tpharm4,ypharm4] = ode45(@pharmfun,tspan_pharm(4,:),...
                    y0_pharm4);
                tpharm4 = tpharm4 + tspan_pharm(1,end) + ...
                    tspan_pharm(2,end) + tspan_pharm(3,end);

                tpharm_tot = [tpharm;tpharm2;tpharm3;tpharm4];
                ypharm_tot = [ypharm;ypharm2;ypharm3;ypharm4];

            end
        end
    end
end

% for loop for the remaining 13 days, regardless of number of doses
for i = 1:Days-1
    for j = 1:length(D_norm(1,:))
        y0_pharm_temp = [D_norm(j)+ypharm_tot(end,1) ypharm_tot(end,2) ...
            ypharm_tot(end,3)];
        [tpharm_temp,ypharm_temp] = ode45(@pharmfun,tspan_pharm(j,:),...
            y0_pharm_temp);
        tpharm_app = tpharm_temp + 24*i + d_time(j);
        
        tpharm_tot = [tpharm_tot; tpharm_app];
        ypharm_tot = [ypharm_tot; ypharm_temp];
    end

end

% Drug reaches a steady concentration range after around 48 hours, c 
% gives the index of 24 hours in tpharm_tot
c = find(tpharm_tot == 48); 
% Time interval over which the average will be taken
T = tpharm_tot(end) - tpharm_tot(c(1)); 
a = 0; % Initializing for summation
for i = 1:(length(ypharm_tot(:,3))-1)
    delt = tpharm_tot(i+1) - tpharm_tot(i);
    a = a + (ypharm_tot(i,3)*delt);
end

avg = a/T; % Average drug concentration in brain
% Maximum drug concentration in brain
[maxnum, maxind] = max(ypharm_tot(:,3)); 
% Minimum drug concentration in brain, calculated after 2 days
[minnum, minind] = min(ypharm_tot(c(1):end,3)); 

%disp(['The minimum concentration in the brain is ',num2str(minnum),'.']);
%disp(['The average concentration in the brain is ',num2str(avg),'.']);
%disp(['The maximum concentration in the brain is ',num2str(maxnum),'.']);

%if minnum < 0.2825
%    disp(['Minimum brain concentration is below the minimum recommended'...
%       ' long-term effective concentration']);
%end

%if maxnum > 3.3860
%    disp(['Maximum brain concentration is above the maximum recommended'...
%       ' short-term allowable concentration']);
%else if maxnum > 1.6967
%        disp(['Maximum brain concentration is above the maximum'...
%           ' recommended long-term allowable concentration']);
%    end
%end

d_tot = 0;
for i = 1:length(D)
    d_tot = d_tot + D(i);
end

tt = length(D);

%plot(tpharm,ypharm(:,2:3),'LineWidth',2)
%xlabel('time (h)','FontSize',16)
%ylabel('drug concentrations (mg/L)','FontSize',16)
%legend('Bloodstream','Brain','FontSize',12)
%cap = sprintf('Levels of Drug in GI Tract, Bloodstream, and Brain \n'...
%       'after one dose');
%title(cap,'FontSize',18)

%if 0.2825 < minnum && maxnum < 3.3860
%    h=figure;
%    plot(tpharm_tot./24,ypharm_tot(:,2:3))
%    xlim([0 Days])
%    ylim([0 maxnum+0.1])
%    xlabel('time (days)','FontSize',16)
%    ylabel('drug concentrations mg/L','FontSize',16)
%    legend('Bloodstream','Brain','FontSize',12)
%    caption = sprintf('Level of drug in bloodstream and brain \n %.0f'...
%       ' mg per day, %.0f doses',d_tot, tt);
%    title(caption,'FontSize',18)
    %saveas(h,strcat('fig640_6uneven.png'));
%end

end
% -------------------------------
function dydt = pharmfun(t,y)

% Defining Parameters
k=.9; % absorption
r=.75; % clearance rate Liters
vp = 4; % volume of plasma distribution Liters
PS = 4.5; % Permeability surface area product
vb = 1.1904; % brain volume
fp = 0.1; % unbound fraction of drug in plasma
fb = 0.036; % Unbound fraction of drug in brain

% Initializing derivative vector
dydt = zeros(3,1);

% Assigning derivatives
dydt(1)= -k*y(1);
dydt(2)=(k*y(1)-r*y(2))/vp;
dydt(3) = (PS*fp*y(2) - PS*fb*y(3))/vb;

end
