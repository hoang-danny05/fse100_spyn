classdef ultrasonicSensor
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        brick Brick
        sensorPort

        %constant that is the barrier between close and far
        % too close/far returns 255. 
        % cm
        FAR_DISTANCE = 10;
    end

    methods
        function obj = ultrasonicSensor(brick, sensorPort)
            %ultrasonicSensor Instantiates sensor with control brick and
            %   port
            obj.brick = brick;
            obj.sensorPort = sensorPort;
        end

        function far = isFar(this)
            %isFar returns boolean if front wall is far or not
            %   compares the distance with FAR_DISTANCE constant.
            distance = this.brick.UltrasonicDist(); 
            far = distance >= this.FAR_DISTANCE;
        end
    end
end