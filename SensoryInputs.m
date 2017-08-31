function [VisualInput, OlfactoryInput] = SensoryInputs(mouseCoord, arena, odor)
    % Create the mouse field of view -- pretend the mouse can see 20 pixels
    % away in each direction except backwards
    FOVrange = 20;
    global rewardReached
    global foodCoord
    global completed
    global reset
    if(abs(foodCoord(1,1)-mouseCoord(1,1))<10 && abs(foodCoord(1,2)-mouseCoord(1,2))<10)
        rewardReached=1;
        completed = completed + 1;
        disp('Found the food!')
    end
   % Check there is no wall on our right
    if(mouseCoord(1,2)+FOVrange < size(arena,2))
        if(mouseCoord(1,1)-FOVrange > 1) % if there is no wall in front of us
            % Similar to "Odor Supported Place cell Model" paper, noise
            % must be added to the visual input
            OlfactoryInput = odor(mouseCoord(1,1)-FOVrange:mouseCoord(1,1), mouseCoord(1,2)-FOVrange:mouseCoord(1,2)+FOVrange);
            % OlfactoryInput = odor(mouseCoord(1,1)-FOVrange:mouseCoord(1,1)+FOVrange, mouseCoord(1,2)-FOVrange:mouseCoord(1,2)+FOVrange);
            %VisualInput = zeros(size(OlfactoryInput));
            %VisualInput(1:FOVrange+1,1:end) = arena(mouseCoord(1,1)-FOVrange:mouseCoord(1,1), mouseCoord(1,2)-FOVrange:mouseCoord(1,2)+FOVrange);
            VisualInput = arena(mouseCoord(1,1)-FOVrange:mouseCoord(1,1), mouseCoord(1,2)-FOVrange:mouseCoord(1,2)+FOVrange);
            noise = rand([size(VisualInput,1) size(VisualInput,2)]);
            VisualInput = VisualInput + noise;
        else
            VisualInput = 0; 
            OlfactoryInput = 0;
            reset = 1;
        end
    else % reset the simulation
        VisualInput = 0; 
        OlfactoryInput = 0;
        reset = 1;
    end

% Uncomment to show sensory inputs
%     figure(2);
%     subplot(2,2,1);
%     odor_opposite = abs(OlfactoryInput-max(OlfactoryInput(:)));% Convert to match arena -- JUST FOR VISUALIZATION NOT CALCULATION
%     % imshow(mat2gray(OlfactoryInput));
%     imshow(mat2gray(odor_opposite));
%     title('OlfactoryInput');
% 
%     subplot(2,2,2);
%     imshow(mat2gray(VisualInput));
%     title('VisualInput');
% 
%     subplot(2,2,3);
%     imshow(mat2gray(odor_opposite+VisualInput));
%     title('OlfactoryInput+VisualInput'); 

end