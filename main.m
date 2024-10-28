
mins = [255 255 255];
maxs = [0 0 0];
accum = zeros(50, 3);

for i = 1:50
    temp = getColorChar(brick, 1);
    accum(i, 1:3) = temp;

    for col = 1:3
        if (mins(col) > temp(col))
            mins(col) = temp(col);
        end
        if (maxs(col) < temp(col))
            maxs(col) = temp(col);
        end
    end

end
mins
maxs

avg = [mean(accum(:, 1)), mean(accum(:, 2)), mean(accum(:, 3))]

  