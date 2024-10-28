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
    tolerance_r = [20 10 9];
    tolerance_g = [5 9 9];
    tolerance_b = [5 9 9];
    tolerance_y = [20 15 10];

    typical_r = [166, 41, 29];
    typical_g = [33, 119, 54];
    typical_b = [33, 95, 138];
    typical_y = [287, 189, 46];

    possible_chars = ['R', 'G', 'B', 'Y'];
    tolerances = [tolerance_r;tolerance_g;tolerance_b;tolerance_y];
    typical_values = [typical_r;typical_g;typical_b;typical_y];

    brick.SetColorMode(sensorPort, 4); %ColorCode Mode

    color = brick.ColorRGB(sensorPort)
    colorChar = 'N';

    for row = 1:4
        fits_lower = true;
        fits_upper = true;
        % check lower tolerance
        lower_bounds = typical_values(row,:) - tolerances(row,:);
        for col = 1:3
            if lower_bounds(col) > color(col)
                fits_lower = false;
                break
            end
        end
        % check upper tolerance
        upper_bounds = typical_values(row,:) + tolerances(row,:);
        for col = 1:3
            if upper_bounds(col) < color(col)
                fits_upper = false;
                break
            end
        end

        if (fits_lower & fits_upper)
            colorChar = possible_chars(row);
        end
    end
    

    
end