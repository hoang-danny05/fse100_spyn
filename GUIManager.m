classdef GUIManager
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        size = [2, 2]
        w = rectangle("Position", [5,5, 2 2], "FaceColor", "r");
        a = rectangle("Position", [2,2, 2 2], "FaceColor", "r");
        s = rectangle("Position", [5,2, 2 2], "FaceColor", "r");
        d = rectangle("Position", [8,2, 2 2], "FaceColor", "r");
        up
        down
    end

    methods
        function this = GUIManager()
            gcf;
            
            bg = rectangle("Position", [0,0, 16, 12], "FaceColor", "w");

            resetWASD(this);
        end

        function this = resetWASD(this)
            w = rectangle("Position", [5,5, this.size], "FaceColor", "r");
            a = rectangle("Position", [2,2, this.size], "FaceColor", "r");
            s = rectangle("Position", [5,2, this.size], "FaceColor", "r");
            d = rectangle("Position", [8,2, this.size], "FaceColor", "r");
        end

        function this = displayControl(this,controlCodeChar)
            % Takes in a control char, displays it on the canvas. 
            this.resetWASD();
            disp(controlCodeChar)

            switch controlCodeChar
                case 'w'
                    this.w
                    this.w.FaceColor = 'g';
                    this.w
                    return;
                   case 'a'
                    this.a = rectangle("Position", [5,5, this.size], "FaceColor", "g");
                    return;
                   case 's'
                    this.s = rectangle("Position", [5,5, this.size], "FaceColor", "g");
                    return;
                   case 'd'
                    this.d = rectangle("Position", [5,5, this.size], "FaceColor", "g");
                    return;
                otherwise
                    return;
            end

        end
    end
end