%% THINGS TO DO
% 1) make sure turning left and right is consistent
% 2) make sure that we can do something to adjust for the robot's
% misalignment during turning
%     - engineer the robot so it balances only on the two motor wheels
%     - make the robot account for each position offset itself
%     - change the algorithm so it tolerates offset. 
% 3) make sure the robot stays looking straight when going forward
%% CONSTANTS

MANUAL_CONTROL = false;

grandma_picked_up = false;
grandma_dropped_off = false;

colorPort = 1;
gyroPort = 2;
ultraPort = 3;



%motor control
% polarization = -1 
p = -1;

leftMotor   ='A';
rightMotor  ='B';
grabMotor   = 'C';
bothMotors  = 'AB';

movementSpeed = 25;
automaticSpeed = 25;
turningSpeed = 75;
distanceCutoff = 40;
tooCloseDistanceCutoff = 7;

brick.SetColorMode(1, 2);

% brick = ConnectBrick("MOTO");

% other functions
forward_distance    = 0;
left_distance       = 0;
right_distance      = 0;



%% Motor Control Code
%↑
%↓
%⏹
%←
%→

% ///////////////////////////////////////////////////////////////////////////////
% AUTOMATIC FUNCTIONS
% ///////////////////////////////////////////////////////////////////////////////

function autoLeft(brick, p, gyroPort, leftMotor, rightMotor, turningSpeed) 
    % angle = 270; without any rubber wheels
    angle = 750;

    disp("Calibrating")
    brick.GyroCalibrate(gyroPort);
    original_pos = brick.GyroAngle(gyroPort);
    while (isnan(original_pos))
        original_pos = brick.GyroAngle(gyroPort);
        pause(.25)
    end

    % the actual turn
    brick.MoveMotorAngleRel(leftMotor, p * -1 * turningSpeed, angle, "Brake");
    brick.MoveMotorAngleRel(rightMotor, p * 1 * turningSpeed, angle, "Brake");
    brick.WaitForMotor('AB');
    % this.brick.WaitForMotor(this.rightMotor);

    pause(3)
    % this.brick.StopAllMotors("Brake")

    deviation = 90;
    while (abs(deviation) > 0) 
        deviation = adjustGyroTo(-90, turningSpeed, 2, brick, p, gyroPort, leftMotor, rightMotor);
    end

    % this.adjustGyroTo(-90,turningSpeed,2);

    final_pos = brick.GyroAngle(gyroPort)
    % if difference positive, new angle is positive
    % brick.MoveMotorAngleRel('AB', p * -1 * 50, 90, "Brake")
    % brick.WaitForMotor('AB');
end

function autoRight(brick, p, gyroPort, leftMotor, rightMotor, turningSpeed) 
    % angle = 270;
    angle = 700;


    disp("Calibrating")
    brick.GyroCalibrate(gyroPort);
    original_pos = brick.GyroAngle(gyroPort);
    while (isnan(original_pos))
        original_pos = brick.GyroAngle(gyroPort);
        pause(.25)
    end

    % the actual turn
    brick.MoveMotorAngleRel(leftMotor, p * 1 * turningSpeed, angle, "Brake");
    brick.MoveMotorAngleRel(rightMotor, p * -1 * turningSpeed, angle, "Brake");
    brick.WaitForMotor('AB');
    % this.brick.WaitForMotor(this.rightMotor);

    pause(3)
    % this.brick.StopAllMotors("Brake")

    deviation = 90;
    while (abs(deviation) > 0) 
        deviation = adjustGyroTo(90, turningSpeed, 2, brick, p, gyroPort, leftMotor, rightMotor);
    end
    

    % this.adjustGyroTo(-90,turningSpeed,2);

    final_pos = brick.GyroAngle(gyroPort)
    % if difference positive, new angle is positive
    % brick.MoveMotorAngleRel('AB', p * -1 * 50, 90, "Brake")
end

function autoForward(brick, leftMotor, rightMotor, p, automaticSpeed)
    brick.ResetMotorAngle('AB');
    angle = 1200;
    brick.MoveMotorAngleRel(leftMotor, p * 1 * automaticSpeed, angle, "Brake");
    brick.MoveMotorAngleRel(rightMotor, p * 1 * automaticSpeed, angle, "Brake");
    tic;
    timeToWait = 5;
    sawRed = false;
    while (toc < timeToWait) 
        colorChar = getColorChar(brick, 1);
        if (colorChar == 'R')
            disp('AHHHAHHHHHHHH')
            brick.StopAllMotors();
            pause(2);
            sawRed = true;
            break;
        end
        switch colorChar
        case 'B'
            disp("BLUE SENSED")
            brick.StopAllMotors();
            brick.beep();
            pause(1);
            brick.beep();
            break;
        case 'G'
            disp("GREEN SENSED")
            brick.StopAllMotors();
            brick.beep();
            pause(1);
            brick.beep();
            pause(1);
            brick.beep();
            break;
        case 'Y'
            disp("YELLOW SENSED")
        end
    end
    if (sawRed) 
        brick.GetMotorAngle('A')
        brick.MoveMotorAngleRel('AB', p * 1 * automaticSpeed, angle + brick.GetMotorAngle('AB'), "Brake")
    end
        % getColorChar(this.colorPort)
    brick.WaitForMotor(leftMotor);
    brick.WaitForMotor(rightMotor);
end

function deviation = adjustGyroTo(targetAngle, speed, waitTime, brick, p, gyroPort, leftMotor, rightMotor)
    % disp("Final pos")
    current_pos = brick.GyroAngle(gyroPort);
    % should be -90
    % if its < -90 turn right
    % if its > -90 turn left more
    difference = current_pos - targetAngle;
    % if difference positive, turn left
    % if difference negative, turn right

    new_angle = difference * 8;
    brick.MoveMotorAngleRel(leftMotor, p * -1 * speed, new_angle, "Brake");
    brick.MoveMotorAngleRel(rightMotor, p * 1 * speed, new_angle, "Brake");
    brick.WaitForMotor('AB'); 
    % pause(waitTime)
    deviation = brick.GyroAngle(gyroPort) - targetAngle;
end

%% Manual Control Code


function manualControl(brick, p, leftMotor, rightMotor, bothMotors, grabMotor, movementSpeed)
    global key;
    InitKeyboard();
    
    while 1
        pause(0.1);
        switch key
            case 'w'
                disp('w');
                brick.MoveMotor(bothMotors,    p * movementSpeed);
            case 'a'
                disp('a');
                brick.MoveMotor(leftMotor, -1 * p * movementSpeed);
                brick.MoveMotor(rightMotor, p * movementSpeed);
            case 's'
                disp('s');
                brick.MoveMotor(bothMotors, -1 * p * movementSpeed);
            case 'd'
                disp('d');
                brick.MoveMotor(leftMotor, p * movementSpeed);
                brick.MoveMotor(rightMotor, -1 * p * movementSpeed);
            case 'uparrow'
                disp('Up Arrow Pressed!');
                brick.MoveMotor(grabMotor, 10);
                pause(0.25);
                brick.MoveMotor(grabMotor, 1);
            case 'downarrow'
                disp('Down Arrow Pressed!');
                brick.MoveMotor(grabMotor, -10);
                pause(0.25);
                brick.MoveMotor(grabMotor, -1);
            % case 'leftarrow'
            %     disp('Left Arrow Pressed!');
            % case 'rightarrow'
            %     disp('Right Arrow Pressed!');
            case 'space'
                disp('space');
            case 'escape'
                disp('escape!')
                break;
            case 0
                disp('No Key Pressed!');
                brick.StopAllMotors();
            case 'q'
                break;
        end
    end
    
    CloseKeyboard();
end

%% GetColorChar

function colorChar = getColorChar(brick, sensorPort)
%   getColorChar
%       Returns a character representation of the color being sensed by the
%       color sensor. Possible chars reflect the different unique decisions
%       to be made based on the char. 
%   Possible outputs:
%       N: Not anything significant
%       R: Red
%       G: Green
%       B: Blue
%       Y: Yellow

% TWO MODES:
%   ColorCode(2): easier
%   ColorRGB(4): harder but gives more control
    % tolerance_r = [30 30 20];
    % tolerance_g = [5 9 9];
    % tolerance_b = [5 9 9];
    % tolerance_y = [20 15 10];
    %
    % typical_r = [166, 41, 23];
    % typical_g = [33, 119, 54];
    % typical_b = [33, 95, 138];
    % typical_y = [287, 189, 46];
    %
    % possible_chars = ['R', 'G', 'B', 'Y'];
    % tolerances = [tolerance_r;tolerance_g;tolerance_b;tolerance_y];
    % typical_values = [typical_r;typical_g;typical_b;typical_y];
    %
    % brick.SetColorMode(sensorPort, 4); %ColorCode Mode
    %
    % color = brick.ColorRGB(sensorPort);
    % colorChar = 'N';
    %
    % for row = 1:4
    %     fits_lower = true;
    %     fits_upper = true;
    %     % check lower tolerance
    %     lower_bounds = typical_values(row,:) - tolerances(row,:);
    %     for col = 1:3
    %         if lower_bounds(col) > color(col)
    %             fits_lower = false;
    %             break
    %         end
    %     end
    %     % check upper tolerance
    %     upper_bounds = typical_values(row,:) + tolerances(row,:);
    %     for col = 1:3
    %         if upper_bounds(col) < color(col)
    %             fits_upper = false;
    %             break
    %         end
    %     end
    %
    %     if (fits_lower & fits_upper)
    %         colorChar = possible_chars(row);
    %     end
    % end

    switch brick.ColorCode(1) 
      case 5
        colorChar = 'R';
      case 3
        colorChar = 'G';
      case 2 
        colorChar = 'B';
      case 4
        colorChar = 'Y';
      otherwise
        colorChar = 'N';
    end
end


%% Algorithm (main func)


while true
    if MANUAL_CONTROL
        break;
    end

    % check every color except red
    colorChar = getColorChar(brick, colorPort);
    switch colorChar
        case 'B'
            disp("BLUE SENSED")
            brick.beep();
            pause(1);
            brick.beep();
            break;
        case 'G'
            disp("GREEN SENSED")
            brick.beep();
            pause(1);
            brick.beep();
            pause(1);
            brick.beep();
            manualControl(brick, p, leftMotor, rightMotor, bothMotors, grabMotor, movementSpeed)
            break;
        case 'Y'
            disp("YELLOW SENSED")
    end

    forward_distance = brick.UltrasonicDist(ultraPort)
    if (forward_distance <= tooCloseDistanceCutoff)
        brick.MoveMotorAngleRel('AB', p * -1 * movementSpeed, 360, "Brake");
    end



    autoLeft(brick, p, gyroPort, leftMotor, rightMotor, turningSpeed);
    left_distance = brick.UltrasonicDist(ultraPort);
    
    % if left is far
    if left_distance >= distanceCutoff
        autoForward(brick, leftMotor, rightMotor, p, automaticSpeed)
        continue
    end

    % if forward is far
    if forward_distance >= distanceCutoff
        autoRight(brick, p, gyroPort, leftMotor, rightMotor, turningSpeed);
        autoForward(brick, leftMotor, rightMotor, p, automaticSpeed)
        continue
    else 
        % 180
        autoRight(brick, p, gyroPort, leftMotor, rightMotor, turningSpeed);
        autoRight(brick, p, gyroPort, leftMotor, rightMotor, turningSpeed);
    end

    % facing right
    right_distance = brick.UltrasonicDist(ultraPort);
    if (right_distance >= distanceCutoff) 
        % rightPath
        autoForward(brick, leftMotor, rightMotor, p, automaticSpeed);
        continue
    else
        % backwards path
        autoRight(brick, p, gyroPort, leftMotor, rightMotor, turningSpeed);
        autoForward(brick, leftMotor, rightMotor, p, automaticSpeed);
    end 
end

%% MAIN

% autoLeft(brick, p, gyroPort, leftMotor, rightMotor, turningSpeed)
% autoRight(brick, p, gyroPort, leftMotor, rightMotor, turningSpeed);
% autoForward(brick, leftMotor, rightMotor, p, automaticSpeed)
% getColorChar(brick,1)
