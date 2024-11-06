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
    brick.SetColorMode(1, 2)
   brick.ColorCode(1)    

   switch (brick.ColorCode(1))
       case 5
           colorChar = 'R';
       otherwise
           colorChar = 'N';
   end

    
end