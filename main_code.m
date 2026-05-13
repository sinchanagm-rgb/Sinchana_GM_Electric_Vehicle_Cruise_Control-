% Step 1: Define the plant
G = tf([1], [5 1]);

% Step 2: Open loop step response
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
title('Closed Loop - With PID')
info = stepinfo(T_pid)
% Step 5: Manual PID with Kd added
C_manual = pid(2, 0.519, 0.1);
T_manual = feedback(C_manual*G, 1);
figure
step(T_manual)
title('Tuned PID')
stepinfo(T_manual)
% Step 6: Disturbance at t=10s
t = 0:0.1:50;
dist = zeros(size(t));
dist(t>=10) = -0.1;  % slope reduces speed by 10%

C_manual = pid(2, 0.519, 0.1);
sys_dist = feedback(G, C_manual);

figure
lsim(feedback(G*C_manual,1), ones(size(t)) + dist, t)
title('Response with Disturbance at t=10s')
xlabel('Time (s)'), ylabel('Speed')
figure
hold on
step(feedback(G,1))
step(feedback(pid(1.43,0.519,0)*G,1))
step(feedback(pid(2,0.519,0.1)*G,1))
legend('No Controller','PI','Tuned PID')
title('Controller Comparison')
hold off
figure
margin(C_manual*G)
title('Bode Plot - Gain and Phase Margin')
t = 0:0.1:50;
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
C_highKi = pid(2, 1.5, 0.1);  % Ki increased from 0.519 to 1.5
T_highKi = feedback(C_highKi*G, 1);

t = 0:0.1:50;
figure
hold on
for d = [0.1, 0.2, 0.3]
    dist = zeros(size(t));
    dist(t>=10) = -d;
    lsim(feedback(G*C_highKi,1), ones(size(t))+dist, t)
end
legend('Slope -0.1','Slope -0.2','Slope -0.3')
title('Improved Disturbance Rejection - Higher Ki')
hold off
