% Sweep of Al mole fraction in AlGaAs cladding layers
% Simplified analytical diode model (trend study)

al_fractions = linspace(0.1, 0.9, 9);
num_simulations = length(al_fractions);
Jsc_results = zeros(1, num_simulations);
Voc_results = zeros(1, num_simulations);
efficiency_results = zeros(1, num_simulations);
normarea = 1;
P_AM15G = 100;
bias_voltages = linspace(0, 1.13, 50);
for i = 1:num_simulations
al_frac = al_fractions(i);
J0 = 32.2 * (1 - 0.1*al_frac);
V0 = 1.12 * (1 - 0.05*al_frac);
J = J0 * (1 - exp((bias_voltages - V0)/0.026));
Jsc_results(i) = J0;
Voc_results(i) = V0;
power = J .* bias_voltages;
max_power = max(power);
efficiency_results(i) = (max_power / P_AM15G) * 100;
end

figure;
subplot(2,1,1);
yyaxis left;
plot(al_fractions, Jsc_results, '-o', 'LineWidth', 2);
ylabel('J_{sc} (mA/cm^2)');
yyaxis right;
plot(al_fractions, Voc_results, '-s', 'LineWidth', 2);
ylabel('V_{oc} (V)');
xlabel('Fracción molar de Al en AlGaAs');
title('Parámetros eléctricos vs Fracción molar');
grid on;
legend('J_{sc}', 'V_{oc}', 'Location', 'best');
subplot(2,1,2);
plot(al_fractions, efficiency_results, '-d', 'LineWidth', 2, 'Color', [0.8 0.2 0.2]);
hold on;
yline(32.8, '--', 'Límite SQ para GaAs', 'LineWidth', 2, 'Color', [0.2 0.6 0.2]);
yline(33.7, '--', 'Límite SQ teórico', 'LineWidth', 2, 'Color', [0.2 0.2 0.8]);
ylabel('Eficiencia (%)');
xlabel('Fracción molar de Al en AlGaAs');
title('Eficiencia vs Fracción molar');
grid on;
legend('Eficiencia', 'Location', 'best');
fprintf('\nResultados del barrido de fracciones molares:\n');
fprintf('--------------------------------------------\n');
fprintf('Al Frac\t Jsc (mA/cm2)\t Voc (V)\t Eficiencia (%%)\n');
fprintf('--------------------------------------------\n');
for i = 1:num_simulations
fprintf('%.2f\t %.2f\t\t %.3f\t %.2f\n', ...
al_fractions(i), Jsc_results(i), Voc_results(i), efficiency_results(i));
end
fprintf('--------------------------------------------\n');
