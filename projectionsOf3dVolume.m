clear 
close all
clc

%% Volume loading 
%Loading the original volume.mat file 
disp('Loading the volume...')
R = load('volume.mat');
% loading the 3d volume data 
volume = R.r;
% getting some information about the loaded volume 
volDim = size(volume);
sliceHeight = volDim(1);
sliceWidth = volDim(2);
nbOfSlices = volDim(3);
fprintf('There are %d slices of size %dx%d in the volume. \n', nbOfSlices, sliceHeight, sliceWidth);

%% Angles and Projections directory 
% Define the angles to take the projections 
angles2Rotate = 0:0.18:179.82;
fprintf('angles(degree) to rotate %.1f:%.2f:%.2f \n',...
    angles2Rotate(1),angles2Rotate(2)-angles2Rotate(1), angles2Rotate(end));

%creating a directory to store the projections and curresponding angles 
folderName = '2dProjections';
mkdir(folderName);
fprintf('Folder "%s" is created to store the projections and angles.\n', folderName);
save([sprintf('%s/angles', folderName),'.mat'], 'angles2Rotate');

%% Projections 
%
% Iterating over all the angles to take the projections
%
disp('Saving the Projections...');
for step = 1: length(angles2Rotate)
    % the degree of rotation
    rotInDeg = angles2Rotate(step);
    % rotation in radian
    rotInRad = rotInDeg * pi / 180.0;
    % initializing a projection
    projection2D = zeros(nbOfSlices, sliceWidth);
    
    for sliceNb = 1:nbOfSlices
        % extracting a Slice
        aSlice = volume(:, :, sliceNb);
        rotatedSlice = zeros(size(aSlice));
        
        % keeping rotated slice dimension is the same as original slice
        rotatedSliceHeight = sliceHeight;
        rotatedSliceWidth = sliceWidth;
        
        % rotation from the center of the slice
        midHeight = rotatedSliceHeight/2;
        midWidth = rotatedSliceWidth/2;
        
        for rotRow = 1:rotatedSliceHeight
           for rotCol = 1:rotatedSliceWidth
              % rotation
              y = (rotRow-midWidth)*cos(rotInRad) + (rotCol-midHeight)*sin(rotInRad);
              x = -(rotRow-midWidth)*sin(rotInRad) + (rotCol-midHeight)*cos(rotInRad);
              
              % adding offset 
              y = y + midWidth;
              x = x + midHeight;
              
              % getting matiching index(nearest)
              y = round(y);
              x = round(x);
              
              if ((x >= 1) && (y >= 1) && (x < sliceWidth) && (y < sliceHeight))
                  % putting the value from original to rotated slice  
                  rotatedSlice(rotRow, rotCol) = aSlice(y, x);
              end % end if 
              
           end % end of rotCols
        end % end of rotRows
        
    % sum of intensities of a slice (~Radon Transform)
    projection2D(sliceNb,:) = sum(rotatedSlice);
        
    end % end of slices
    
    % adding gaussian noise to the projection.
    projection2D = awgn(projection2D,15,'measured');
    % adding shift 
    projection2D = simpleshift(projection2D, 0, 1);
    % saving the projection to the directory
    save([sprintf('%s/projection%d',folderName, step), '.mat'], 'projection2D');
    
    %progress
    if mod(step, 100) == 0
       fprintf('Saved %d out of %d projections...\n ', step, length(angles2Rotate)) 
    end
    
end % end of angles 

fprintf('Done saving %d projections to the "%s" folder\n', length(angles2Rotate), folderName);

%% Plot Projections

% loading all the projection files
projectionFiles = dir(sprintf('%s/p*.mat', folderName));
% 15 random integers in range 1 to Nb. of projections  
radomIntegers = randi([1, length(angles2Rotate)], 1, 15);
figure(1)
% looping through random integers
for aNum = 1:15 
    loadedProjection = load(sprintf('%s/%s',folderName,projectionFiles(radomIntegers(aNum)).name));
    projectionMat = loadedProjection.projection2D;
    subplot(3,5,aNum);
    imshow(projectionMat, 'DisplayRange', [min(min(projectionMat)), max(max(projectionMat))])
    title(sprintf('angle = %.2f', angles2Rotate(radomIntegers(aNum))), 'FontSize', 8);
    axis on
end
