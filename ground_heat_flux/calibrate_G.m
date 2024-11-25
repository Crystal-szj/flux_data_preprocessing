function [G_corr, energyStore] = calibrate_G(G_z, satTheta, theta, soilT, depth)
% This function is used to calibrate ground heat fluxes to land surface.
%{
Author
    name : Zengjing Song
    email: z.song@utwente.nl
Input
    G_z     : [W/m2]     A n*1 array of observed G at the depth (m) of z
    satTheta: [m3/m3]    saturated soil moisture 
    theta   : [m3/m3]    A n*1 array of soil moisture 
    soilT   : [degree C] A n*1 array of soil temperature (degree). In my case, we used
                         soilT = 0.5 * (soilT_5cm + lst)
    depth   : [m]        depth of sensor

Output
    G_corr     : [W/m2] A n*1 array of land surface ground heat flux
    energyStore: [W/m2] Energy store in the soil layer 

References
    [1] Gao, Z. et al. A novel approach to evaluate soil heat flux calculation: An analytical review of nine methods. 
        Journal of Geophysical Research: Atmospheres 122, 6934-6949 (2017). https://doi.org/https://doi.org/10.1002/2017JD027160
    [2] Liebethal, C., Huwe, B. & Foken, T. Sensitivity analysis for two ground heat flux calculation approaches. 
        Agricultural and Forest Meteorology 132, 253-262 (2005). https://doi.org/https://doi.org/10.1016/j.agrformet.2005.08.001
    [3] Murray, T. & Verhoef, A. Moving towards a more mechanistic approach in the determination of soil heat flux from remote measurements: I. A universal approach to calculate thermal inertia. 
        Agricultural and Forest Meteorology 147, 80-87 (2007). https://doi.org/https://doi.org/10.1016/j.agrformet.2007.07.004

%}
%% Define constant
% RHO_S = 1.5*10^6;       % soil bulk density (g/m3) 
% C_S = 0.83;             % specific heat of soil solids (J/g/K)
RHO_W = 1;              % density of water (g/m3)
C_W = 4.2*10^6;         % specific heat of water (J/m3/K)

% cv = RHO_S * C_S * (1 - satTheta) + RHO_W * C_W .* theta;
cv = 2*10^6 * (1 - satTheta) + RHO_W * C_W .* theta; % 2e6 from eq.13 in ref[3]

%% The change of soil temperature
deltaSoilT(1)= 0;       % set the first diff as 0
deltaSoilT = [deltaSoilT;diff(soilT)];
deltaSoilTdeltat = deltaSoilT./(30*60); % dTemperature/dtime
energyStore = cv .* deltaSoilTdeltat .* depth;
G_corr = G_z + energyStore;
end