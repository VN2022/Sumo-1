clear; clc; close all;

%% Ego vehicle at origin
egoX = 0;
egoY = 0;

%% Sensor definitions (body-fixed frame)
% R = range (m)
% Span = field of view (deg)
% Offset = mounting angle wrt vehicle x-axis (deg, CCW positive)
S(1) = struct('R', 15, 'Span', 60,    'Offset',   0, 'Col', [1.0 0.9 0.0]); % Front
S(2) = struct('R', 10, 'Span', 34.92, 'Offset',  90, 'Col', [0.2 0.6 1.0]); % Left
S(3) = struct('R', 12, 'Span', 53.14, 'Offset', 180, 'Col', [0.6 1.0 0.6]); % Rear
S(4) = struct('R', 10, 'Span', 73.74, 'Offset', -90, 'Col', [1.0 0.4 0.4]); % Right

%% Two yaw states
yaws = [0 40]; % degrees

for k = 1:length(yaws)

    yawDeg = yaws(k);
    yawRad = deg2rad(yawDeg);

    figure('Color','w','Name',sprintf('Yaw %d deg',yawDeg));
    hold on; grid on; axis equal;

    %% Draw ego vehicle
    scatter(0,0,120,'k','filled');
    text(0,0,' Ego','FontWeight','bold','VerticalAlignment','bottom');

    %% Draw sensors
    for i = 1:4

        % Sensor orientation = mount offset + ego yaw
        centerAngle = deg2rad(S(i).Offset) + yawRad;
        halfSpan    = deg2rad(S(i).Span/2);

        theta = linspace(centerAngle-halfSpan, ...
                         centerAngle+halfSpan, 100);

        % Sensor footprint in world coordinates
        x = [0, S(i).R*cos(theta), 0];
        y = [0, S(i).R*sin(theta), 0];

        fill(x, y, S(i).Col, ...
             'FaceAlpha',0.3, ...
             'EdgeColor',S(i).Col*0.7);
    end

    %% Reference axes
    line([-20 20],[0 0],'Color','k');
    line([0 0],[-20 20],'Color','k');

    xlabel('X (m)');
    ylabel('Y (m)');
    title(sprintf('Ego Vehicle Sensor FOVs | Yaw = %d°',yawDeg));

    xlim([-20 20]);
    ylim([-20 20]);

    hold off;
end
