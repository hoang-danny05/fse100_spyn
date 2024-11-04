global key;
InitKeyboard();

while 1
    pause(0.1);
    switch key
        case 'w'
            disp('w');
        case 'a'
            disp('a');
        case 's'
            disp('s');
        case 'd'
            disp('d');
        case 'uparrow'
            disp('Up Arrow Pressed!');
        case 'downarrow'
            disp('Down Arrow Pressed!');
        % case 'leftarrow'
        %     disp('Left Arrow Pressed!');
        % case 'rightarrow'
        %     disp('Right Arrow Pressed!');
        case 'space'
            disp('space');
        case 0
            disp('No Key Pressed!');
        case 'q'
            break;
    end
end

CloseKeyboard();