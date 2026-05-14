% Step 1: Define the plant
G = tf([1], [5 1]);

% Step 2: Open loop step response
figure
step(G)
title('Open Loop Response')

% Step 3: Close the loop with unity feedback
T = feedback(G, 1);
figure
step(T)
title('Closed Loop - No Controller')
stepinfo(T)

% Step 4: Auto-design PID controller
C = pidtune(G, 'PID');
T_pid = feedback(C*G, 1);
figure
step(T_pid)
title('Closed Loop - With PI (pidtune)')
info = stepinfo(T_pid)

% Step 5: Manual PID with Kd added
C_manual = pid(2, 0.519, 0.1);
T_manual = feedback(C_manual*G, 1);
figure
step(T_manual)
title('Tuned PID')
stepinfo(T_manual)

% Step 6: Corrected disturbance at plant input
t = 0:0.1:50;
dist = zeros(size(t));
dist(t>=10) = -0.1;
dist_response = lsim(feedback(C_manual*G,1), ones(size(t)), t) ...
              + lsim(feedback(G, C_manual), dist, t);
figure
plot(t, dist_response)
yline(1, 'r--', 'Target')
title('Response with Disturbance at t=10s (Corrected)')
xlabel('Time (s)')
ylabel('Speed')

% Step 7: Controller comparison
figure
hold on
step(feedback(G,1))
step(feedback(pid(1.43,0.519,0)*G,1))
step(feedback(pid(2,0.519,0.1)*G,1))
legend('No Controller','PI','Tuned PID')
title('Controller Comparison')
hold off

% Step 8: Bode plot
figure
margin(C_manual*G)
title('Bode Plot - Gain and Phase Margin')

% Step 9: Multiple disturbances - original Ki
figure
hold on
for d = [0.1, 0.2, 0.3]
    dist = zeros(size(t));
    dist(t>=10) = -d;
    lsim(feedback(G*C_manual,1), ones(size(t))+dist, t)
end
legend('Slope -0.1','Slope -0.2','Slope -0.3')
title('Disturbance Rejection - Multiple Slopes')
hold off

% Step 10: Higher Ki tradeoff
figure
hold on
for d = [0.1, 0.2, 0.3]
    dist = zeros(size(t));
    dist(t>=10) = -d;
    C_highKi = pid(2, 1.5, 0.1);
    lsim(feedback(G*C_highKi,1), ones(size(t))+dist, t)
end
legend('Slope -0.1','Slope -0.2','Slope -0.3')
title('Improved Disturbance Rejection - Higher Ki')
hold off

