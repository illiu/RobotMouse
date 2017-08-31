clc; clear all; close all;
% set up a 1000x1000 arena/maze
arena = zeros(500,500);
% set up the walls of the arena
arena(1,:) = 1000;
arena(500,:) = 1000;
arena(:,1) = 1000;
arena(:,500) = 1000;

mapView = zeros(size(arena,1),size(arena,2),3); % Creating an RGB display!
%mapView(:) = 255; % Create the whole view as white
pathTaken = zeros(size(arena,1),size(arena,2),3);
pathTaken(:) = 255;
pathTaken(:,:,1) = 0;

completionTime = zeros(1,10);
completionTime(:) = 100;
global reset
reset = 0;

for i=1:3 % Walls
    mapView(1,:,i) = 255;
    mapView(500,:,i) = 255;
    mapView(:,1,i) = 255;
    mapView(:,500,i) = 255;
end

% goal destination
food(1:20,1:20) = 1000;
% put our food into our arena -- for now, it's hard coded to upper left of
% the arena
row = 100;
col = 50;
arena(row:row+19,col:col+19) = food;
global foodCoord;
foodCoord = [row+9 col+9];
disp(['Food is located at (' num2str(foodCoord(1,1)) ',' num2str(foodCoord(1,2)) ')'])

% odor matrix -- each element denotes the strength
odor = zeros(size(arena));
% Compute distance from each element to our food source
disp('Creating odor gradient. Please wait...')
% for r=1:size(odor,1)
%     for c=1:size(odor,2)
%         odor(r,c) = pdist([foodCoord(1,1),foodCoord(1,2);r,c],'euclidean');
%     end
% end
for r=1:250
    for c=1:250
        odor(r,c) = pdist([foodCoord(1,1),foodCoord(1,2);r,c],'euclidean');
    end
end

% odor = abs(odor-max(odor(:))); % Flipping so that highest values are near the food source

% Display odor gradient
odor_opposite = zeros(size(odor));
odor_opposite(1:250,1:250) = abs(odor(1:250,1:250)-max(odor(:)));% Convert to match arena -- JUST FOR VISUALIZATION NOT CALCULATION
figure(3);
imshow(mat2gray(odor_opposite))
% imshow(mat2gray(odor));

% put our mouse into the arena
% mouse = imread('dirty_mouse_sm.png');
mouse = ones(20,20); 
global mouseCoord;
% mouseCoord = [410 380]; % hard coded to lower right
mouseCoord = [410 200]; 
global mouseDim;
mouseDim = [size(mouse,1) size(mouse,2)];
arena(mouseCoord(1,1):mouseCoord(1,1)+19,mouseCoord(1,2):mouseCoord(1,2)+19) = mouse;

% Display arena
% figure(1)
% imshow(arena);

% Put in the cheese into our RGB image
cheese = im2double(imread('cheese.png'));
for i=1:3
    mapView(foodCoord(1,1):foodCoord(1,1)+size(cheese,1)-1,foodCoord(1,2):foodCoord(1,2)+size(cheese,2)-1,i) = cheese(:,:,i);
end
mapWOMouse = mapView;

% Put the mouse into our RGB image
mouse2 = im2double(imread('dirty_mouse_sm.png'));
for i=1:3
    mapView(mouseCoord(1,1):mouseCoord(1,1)+size(mouse2,1)-1,mouseCoord(1,2):mouseCoord(1,2)+size(mouse2,2)-1,i) = mouse2(:,:,i);
end

% Display our maze
figure(1)
imshow(mapView);
global rewardReached;
rewardReached = 0;

% Initialize a weight matrix -- randomly from a uniform distribution
W = rand([size(arena,1) size(arena,2)]);

time = 0;
global completed;
completed = 0;
% RUN CODE
while(completed~=20)
%     if(completed == 0)
%         mouseCoord = [410 200]; 
%     elseif(completed==1)
%         mouseCoord = [410 380];
%     elseif(completed==2)
%         mouseCoord = [120 380];
%     end

    % Reset variables
    mouseCoord = [410 200]; % temp variable -- remove later
    time = 0;
    rewardReached = 0;
    
    arena = zeros(500,500);
    food(1:20,1:20) = 1000;
    row = 100;
    col = 50;
    arena(row:row+19,col:col+19) = food;
    
    while(rewardReached~=1)
        time = time+1;
        arena(mouseCoord(1,1):mouseCoord(1,1)+19,mouseCoord(1,2):mouseCoord(1,2)+19) = 0; % Ignore the mouse when we use arena matrix
        % Compute and show our sensory inputs
        [VisualInput, OlfactoryInput] = SensoryInputs(mouseCoord, arena, odor);

        if(reset == 1)
            rewardReached = 1;
            time = 100;
            reset = 0;
        else
            % Pass our inputs into EC/Place cell model
            MotorInput = PlaceCells(VisualInput,OlfactoryInput,W);

            % Pass our place cells and map it to Motor Neurons
            MotorOutput = MotorNeurons(MotorInput,W);

            if(MotorOutput==0)
                disp('error')
            end
           
            % Update the path taken image
            pathTaken(mouseCoord(1,1)-5:mouseCoord(1,1)+5,mouseCoord(1,2)-5:mouseCoord(1,2)+5,1) = pathTaken(mouseCoord(1,1),mouseCoord(1,2),1)+50;
            %pathTaken(mouseCoord(1,1)-5:mouseCoord(1,1)+5,mouseCoord(1,2)-5:mouseCoord(1,2)+5,3) = pathTaken(mouseCoord(1,1),mouseCoord(1,2),2)-20;

            % Uncomment to show paths taken by the mouse
            % figure(4);
            % imshow(rgb2hsv(pathTaken));

            pause(1);
            % Update our arena
            arena(mouseCoord(1,1):mouseCoord(1,1)+19,mouseCoord(1,2):mouseCoord(1,2)+19) = mouse;

            % Update our RGB image
            mapView = mapWOMouse;
            for i=1:3
                mapView(mouseCoord(1,1):mouseCoord(1,1)+size(mouse2,1)-1,mouseCoord(1,2):mouseCoord(1,2)+size(mouse2,2)-1,i) = mouse2(:,:,i);
            end

            figure(1);
            %imshow(arena);
            imshow(mapView);
            
        end
        
    end
    completionTime(1,completed+1) = time;
    fprintf('Time it took to complete=%d \n',time)
end
disp('Finished!')

