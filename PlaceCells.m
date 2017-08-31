function [MotorNeurons] = PlaceCells(VisIn, OlfIn, Weights)
    % Place cell formation that relies on visual and olfactory cues
    % X represents our place cells
    X = VisIn + OlfIn;
    
    % Every neuron in the input layer is connected to every neuron in the
    % output layer via connection weights 

    % Modify the weights in our network according to winner-takes-all
    % mechanism
    global mouseCoord
    FOVrange = 20;
    
    % Grab the weights
    rStart = mouseCoord(1,1)-FOVrange;
    rEnd = mouseCoord(1,1);%+FOVrange;
    cStart = mouseCoord(1,2)-FOVrange;
    cEnd = mouseCoord(1,2)+FOVrange;
    W = Weights(rStart:rEnd, cStart:cEnd);
    
    MotorNeurons = X-W;
    % MotorNeurons = X;
%     pause(2);
%     imshow(mat2gray(Weights));
    
end