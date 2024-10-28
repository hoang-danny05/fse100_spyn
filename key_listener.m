% Known key codes
% up-arrow: 30
% left : 28
% right : 29
% escape: 27
manualControl(brick);c

function manualControl(brick)

%gcf refrerences a figure (get current figure)
clc
gcf



% PORTS
colorPort = 1;
gyroPort = 2;
ultraPort = 3;

speed = 100;
turning_speed = 25;
motors = MotorController(brick, colorPort, gyroPort, ultraPort);

brick.GyroCalibrate(gyroPort);


%control loop!
while true
    %pauses the program until the next button press
    try
        key_press = waitforbuttonpress;
        ASCII_val = get(gcf,'CurrentCharacter');
    catch
        disp("Figure closed, returning");
        ASCII_val = 27;
    end

    % gui.displayControl(ASCII_val);wa
    
    % handle current character
    switch ASCII_val
        case 27
            break;
        case 'w'
            disp("going forward");
            motors.driveForward(speed);
            continue;
        case 'a'
            disp("turning left");
            motors.turnLeft(speed);
            continue;
        case 's'
            disp("going backward");
            motors.driveBackward(speed);
            continue;
        case 'd'
            disp("turning right");
            motors.turnRight(speed);
            continue;
        case 30 % up arrow
            motors.moveGrabber(10);
            pause(0.25);
            disp("test")
            motors.moveGrabber(1);
        case 31 % down arrow
            motors.moveGrabber(-10);
            pause(0.25)
            motors.moveGrabber(-1);
        case ' '
            disp("stopping");
            motors.neutralInput();
        case 'c'
            colorChar = getColorChar(brick, colorPort)
        case 'g'
            brick.GyroAngle(gyroPort)
        case 'r'
            motors.autoRight(turning_speed);
        case 'l'
            motors.autoLeft(turning_speed);
        case 'u'
            brick.UltrasonicDist(ultraPort)
        case 'f'
            motors.autoForward(speed);
        otherwise
            %unhandled character'
            disp("doing nothing")
            motors.neutralInput();
            continue;
    end
end

%close the figure once done
close(gcf);


end
%%
% ABSTRACT:
% handling the GUI
% get window size
%     get(gcf, position) returns [x,y,w,h]

