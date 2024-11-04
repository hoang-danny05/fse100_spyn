%% THINGS TO DO
% 1) make sure turning left and right is consistent
% 2) make sure that we can do something to adjust for the robot's
% misalignment during turning
%     - engineer the robot so it balances only on the two motor wheels
%     - make the robot account for each position offset itself
%     - change the algorithm so it tolerates offset. 
% 3) make sure the robot stays looking straight when going forward
%% CONSTANTS

grandma_picked_up = false;
grandma_dropped_off = false;

colorPort = 1;
gyroPort = 2;
ultraPort = 3;

speed = 25;
turning_speed = 25;
distance_cutoff = 40;

motors = MotorController(brick, colorPort, gyroPort, ultraPort);
% brick = ConnectBrick("MOTO");

% other functions
forward_distance = 0
left_distance = 0
right_distance = 0

%% Algorithm


while true
    % check every color except red
    colorChar = getColorChar(brick, colorPort)
    switch colorChar
        case 'B'
            disp("BLUE SENSED")
        case 'G'
            disp("GREEN SENSED")
        case 'Y'
            disp("YELLOW SENSED")
    end

    forward_distance = brick.UltrasonicDist(ultraPort)

    motors.autoLeft(turning_speed);
    left_distance = brick.UltrasonicDist(ultraPort)
    
    % if left is far
    if left_distance >= distance_cutoff
        motors.autoForward(speed);
        continue
    end

    % if forward is far
    if forward_distance >= distance_cutoff
        motors.autoRight(turning_speed);
        motors.autoForward(speed);
        continue
    else 
        % 180
        motors.autoRight(turning_speed);
        motors.autoRight(turning_speed);
    end

    % facing right
    right_distance = brick.UltrasonicDist(ultraPort);
    if (right_distance >= distance_cutoff) 
        % rightPath
        motors.autoForward(speed)
        continue
    else
        % backwards path
        motors.autoRight(turning_speed)
        motors.autoForward(speed)
    end
    
    % check forward
    % check right
    
end


%% Motor Control Code


%% Manual Control Code