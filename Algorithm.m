
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
foward_distance
left_distance
right_distance


% place in center

while true
    % check every color except red
    colorChar = getColorChar(colorPort)
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
    if left_distance >= tolerance
        motors.autoForward(speed);
        continue
    end

    % if forward is far
    if forward_distance >= tolerance
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
    if (right_distance >= tolerance) 
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