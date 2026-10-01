%% Cessna 172 Skyhawk Performance Analysis
% Use Cessna 172 Skyhawk as parameters:
m = 1157; % Mass (kg)
g = 9.81; % Gravity (m/s^2)
rho = 1.225; % Air density at sea-level (kg/m^3)
W = m * g; % Weight (N) '1.135e4'

S = 16.17; % Wing area (m^2)
Ws = 11; % Wing span (m)
Ar = Ws^2 / S; % Aspect Ratio '7.4830'

CL_max = 1.6; % Maximum lift coefficient
CD0 = 0.0341; % Zero-lift drag coefficient
e = 0.7; % Oswald efficieny factor

V = linspace(10, 150, 9000); % Airspeed (m/s)

% For steady flight, L = W
% L = (1/2)*rho*V.^2*Wa*CL
% Solve for CL in terms of W
CL = (2*W) ./ (rho*V.^2*S); % Lift coefficient

% Drag Polar Equation
k = 1 / (pi*e*Ar); % Induced drag factor
CD_i = k .* CL.^2;
CD = CD0 + CD_i; % Drag coefficient

L = 0.5 * rho .* V.^2 * S .* CL;
D = 0.5 * rho .* V.^2 * S .* CD;
LD = L ./ D; % Efficiency 

V_s = sqrt(2*W / (rho * S * CL_max)); % Stall Speed (m/s) '26.76'
fprintf('Stall Speed: %.4f m/s\n', V_s)

% The maximum L/D efficiency
[LD_max, index] = max(LD);
V_at_LD_max = V(index);
fprintf('Max LD: %.4f\n', LD_max)
fprintf('Airspeed at Max LD: %.4f m/s\n', V_at_LD_max)

% Plot 1 (Lift and Drag vs Airspeed)
figure;
plot(V, L, V, D, 'LineWidth', 2);
xlabel('Airspeed (m/s)');
ylabel('Force (N)');
title('Lift and Drag vs Airspeed');
legend('Lift', 'Drag');

% Plot 2 (Lift/Drag vs Airspeed)
figure;
plot(V, LD, 'LineWidth', 2);
xlabel('Airspeed (m/s)');
ylabel('L/D');
title('Lift/Drag vs Airspeed');

D_induced = 0.5 * rho .* V.^2 * S .* CD_i;
D_parasite = 0.5 * rho .* V.^2 * S * CD0;
% Plot 3 (Drag vs Airspeed)
figure;
plot(V, D_induced, V, D_parasite, V, D, 'LineWidth', 2);
xlabel('Airspeed (m/s)');
ylabel('Force (N)');
title('Drag vs Airspeed');
legend('D_i', 'D_p', 'Total Drag');

% Plot 4 (Effects of Air Density)
rho_s = [0.9, 1.225, 1.5];
figure;
hold on;
for i = 1:length(rho_s)
    CL_rho = (2 * W) ./ (rho_s(i) * V.^2 * S);
    CD_rho = CD0 + k .* CL_rho.^2;
    D_rho = 0.5 * rho_s(i) .* V.^2 * S .* CD_rho;
    plot(V, D_rho, 'LineWidth', 2);
end
xlabel('Airspeed [m/s]');
ylabel('Drag [N]');
title('Effect of Air Density on Drag');
legend('\rho = 0.9', '\rho = 1.225', '\rho = 1.5');



%% Source of Research
% http://www.temporal.com.au/c172.pdf
% https://www.aerostudents.com/courses/intro-to-aerospace-1/aerodynamics-and-aircraft-limits.pdf
