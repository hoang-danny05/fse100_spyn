classdef MotorController
    %Motorcontroller Provides control methods for controlling all motors 
    %   Stores motor constants and provvides easy things 

    properties
        brick Brick

        leftMotor =     'A';
        rightMotor =    'B';
        grabMotor =     'C';

        drivingSpeed =  50;
        grabbingSpeed = 10;
        
        %polarizations: when going forward, either the left or right motor
        %   must turn "backwards". These are constants to easily change
        %   polarizations.
        lp =    -1;
        rp =    -1;

  
        brakeMode = "Coast";

        % sensor ports
        colorPort
        gyroPort
        ultraPort
    end

    methods
        %% Navigation Control
        function controller = MotorController(brick, color, gyro, ultra)
            %MotorController: A class to organize all motor controls
            %   Collects all motor-related constants
            %   Collectes all motor control methods
            controller.brick = brick;
            controller.colorPort = color;
            controller.gyroPort = gyro;
            controller.ultraPort = ultra;
        end

        %↑
        function void = driveForward(this, MovementSpeed)
            %driveForward: Controls the motor when pressing W 
            %   Both motors moving at indicated speed
            %   
            this.brick.MoveMotor(this.leftMotor,    this.lp * MovementSpeed);
            this.brick.MoveMotor(this.rightMotor,   this.rp * MovementSpeed);
            void = 0;
        end

        %↓
        function void = driveBackward(this, MovementSpeed)
            %driveForward: Controls the motor when pressing S
            %   Both motors moving at indicated speed,backwards
            %   i could have just done this.driveForward(-1 * speed)
            this.brick.MoveMotor(this.leftMotor,    -1 * this.lp * MovementSpeed);
            this.brick.MoveMotor(this.rightMotor,   -1 * this.rp * MovementSpeed);
            void = 0;
        end

        %⏹
        function void = neutralInput(this)
            %neutralInput: Controls the motor when pressing nothing
            %   Both motors not moving
            %   Can be either "coast" or "brake"
            this.brick.StopMotor(this.leftMotor, this.brakeMode);
            this.brick.StopMotor(this.rightMotor, this.brakeMode);
            this.brick.StopMotor(this.grabMotor, this.brakeMode);
            void = 0;
        end

        %←
        function void = turnLeft(this, MovementSpeed)
            %driveForward: Controls the motor when pressing S
            %   Both motors moving at indicated speed 
            %   Left should be moving backward, right should be moving forward
            this.brick.MoveMotor(this.leftMotor,    -1 * this.lp * MovementSpeed);
            this.brick.MoveMotor(this.rightMotor,   1  * this.rp * MovementSpeed);

            
            void = 0;
        end

        %→
        function void = turnRight(this, MovementSpeed)
            %driveForward: Controls the motor when pressing S
            %   Both motors moving at indicated speed 
            %   Left should be moving forward, right should be moving backward
            this.brick.MoveMotor(this.leftMotor,    1 * this.lp * MovementSpeed);
            this.brick.MoveMotor(this.rightMotor,   -1  * this.rp * MovementSpeed);
            void = 0;
        end

        %% Pickup Control
        
        function void = moveGrabber(this, GrabbingSpeed)
            %driveForward: Starts picking up the person at the indicated speed
            %   Bidirectional: accepts negative inputs. 
            this.brick.MoveMotor(this.grabMotor, GrabbingSpeed);
            void = 0;
        end

        % ///////////////////////////////////////////////////////////////////////////////
        % AUTOMATIC FUNCTIONS
        % ///////////////////////////////////////////////////////////////////////////////

        function autoLeft(this, speed) 
            angle = 270;
            % angle = 600;

            disp("Calibrating")
            this.brick.GyroCalibrate(this.gyroPort);
            original_pos = this.brick.GyroAngle(this.gyroPort);
            while (isnan(original_pos))
                original_pos = this.brick.GyroAngle(this.gyroPort);
                pause(.25)
            end

            % the actual turn
            this.brick.MoveMotorAngleRel(this.leftMotor, this.lp * -1 * speed, angle, "Brake");
            this.brick.MoveMotorAngleRel(this.rightMotor, this.rp * 1 * speed, angle, "Brake");
            % this.brick.WaitForMotor(this.leftMotor);
            % this.brick.WaitForMotor(this.rightMotor);
 
            pause(3)
            % this.brick.StopAllMotors("Brake")

            this.adjustGyroTo(-90,speed,2);

            final_pos = this.brick.GyroAngle(this.gyroPort)
            % if difference positive, new angle is positive


        end

        function autoRight(this, speed) 
            speed = speed * -1;
            angle = 270;
            % angle = 600;

            disp("Calibrating")
            this.brick.GyroCalibrate(this.gyroPort);
            original_pos = this.brick.GyroAngle(this.gyroPort);
            while (isnan(original_pos))
                original_pos = this.brick.GyroAngle(this.gyroPort);
                pause(.25)
            end


            this.brick.MoveMotorAngleRel(this.leftMotor, this.lp * -1 * speed, angle, "Brake");
            this.brick.MoveMotorAngleRel(this.rightMotor, this.rp * 1 * speed, angle, "Brake");
            % this.brick.WaitForMotor(this.leftMotor);
            % this.brick.WaitForMotor(this.rightMotor);
            % 
            
            pause(5)
            % this.brick.StopAllMotors("Brake")

            this.adjustGyroTo(90,speed,2);
            
            final_pos = this.brick.GyroAngle(this.gyroPort)
            % if difference positive, new angle is positive        
        end

        function autoForward(this, speed)
            angle = 1200;
            this.brick.MoveMotorAngleRel(this.leftMotor, this.lp * 1 * speed, angle, "Brake");
            this.brick.MoveMotorAngleRel(this.rightMotor, this.lp * 1 * speed, angle, "Brake");
            % getColorChar(this.colorPort)
            this.brick.WaitForMotor(this.leftMotor);
            this.brick.WaitForMotor(this.rightMotor);
        end

        function adjustGyroTo(this, targetAngle, speed, waitTime)
            disp("Final pos")
            current_pos = this.brick.GyroAngle(this.gyroPort)
            % should be -90
            % if its < -90 turn right
            % if its > -90 turn left more
            difference = current_pos + 90;
            % if difference positive, turn left
            % if difference negative, turn right

            new_angle = difference * 3;
            this.brick.MoveMotorAngleRel(this.leftMotor, this.lp * -1 * speed, new_angle, "Brake");
            this.brick.MoveMotorAngleRel(this.rightMotor, this.rp * 1 * speed, new_angle, "Brake");
            pause(waitTime)
        end
        
    end
end