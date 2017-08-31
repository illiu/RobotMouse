function MotorOut = MotorNeurons(PlaceCells, Weight)
    
    % WTA competition -- find the min value
    [value,index] = min(PlaceCells(:));
    [r,c] = ind2sub(size(PlaceCells),index);
    
    % Variables
    global mouseCoord
    FOVrange = 20;
    rStart = mouseCoord(1,1)-FOVrange;
    rEnd = mouseCoord(1,1);
    cStart = mouseCoord(1,2)-FOVrange;
    cEnd = mouseCoord(1,2)+FOVrange;
    
    % Hebbian Learning -- Update weight for the winner
    k = 0.1; % Learning rate
    winnerRow = rStart+r-1;
    winnerCol = cStart+c-1;
    W = Weight(rStart:rEnd, cStart:cEnd);
    for i=winnerRow-10:winnerRow+10
        for j=winnerCol-10:winnerCol+10
            Weight(i,j) = Weight(i,j) + k*(PlaceCells(r,c));
        end
    end
    
    % Weight(winnerRow,winnerCol) = W(r,c) + k*(PlaceCells(r,c));
    % Idea:Increase weights for set of 10x10 since our map is so big
    
    
    %figure(4);
    %subplot(1,2,1);
    %imshow(mat2gray(Weight*10));
    %subplot(1,2,2);
    %imshow(mat2gray(W));
    
    % Print out the direction that corresponds to the winning place cell
    % There are 8 directions: NW, N, NE, E, SE, S, SW, W
    rowDiff = mouseCoord(1,1) - winnerRow;
    colDiff = mouseCoord(1,2) - winnerCol;
    
    stepSize = 10;
    
    if(abs(rowDiff)<5) % Consider no shift in up or down
        if(abs(colDiff)<5) % No Shift in left or right
            mouseCoord(1,1) = mouseCoord(1,1)-stepSize; % Move in a random direction -- hardcode up
            MotorOut = 'N';
        elseif(colDiff<0) % Shift right
            mouseCoord(1,2) = mouseCoord(1,2)+stepSize;
            MotorOut = 'E';
        elseif(colDiff>0)
            mouseCoord(1,2) = mouseCoord(1,2)-stepSize;
            MotorOut = 'W';
        end
    elseif(rowDiff<0) % Shift down
        mouseCoord(1,1) = mouseCoord(1,1)+stepSize;
        if(abs(colDiff)<5) % No Shift in left or right
            MotorOut = 'S';
        elseif(colDiff<0) % Shift right
            mouseCoord(1,2) = mouseCoord(1,2)+stepSize;
            MotorOut = 'SE';
        elseif(colDiff>0) % Shift left
            mouseCoord(1,2) = mouseCoord(1,2)-stepSize;
            MotorOut = 'SW';
        end
    elseif(rowDiff>0) % Shift up
        mouseCoord(1,1) = mouseCoord(1,1)-stepSize;
        if(abs(colDiff)<5) % No Shift in left or right
            MotorOut = 'N';
        elseif(colDiff<0) % Shift right
            mouseCoord(1,2) = mouseCoord(1,2)+stepSize;
            MotorOut = 'NE';
        elseif(colDiff>0) % Shift left
            mouseCoord(1,2) = mouseCoord(1,2)-stepSize;
            MotorOut = 'NW';
        end
        % fprintf('Motor Output: %s \n',MotorOut);
    else 
        MotorOut = 0;
    end
end