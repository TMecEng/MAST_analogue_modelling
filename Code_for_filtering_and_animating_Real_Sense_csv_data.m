clear all
close all
clc

%this code lets you first filter one frame of data in the first section thus allowing for the filter to be tailored to the data 
% before it is repeated over all the data and produces an animation of all the data which is then recorded as a video 

%the filter is indicated by a ---- and requiures download the additional
%gaussian filter function in the same directory


% please fill out all the variables before running the code, in particular
%please name your files so they can be found by the convention
%E:example\path\to\file(1), E:example\path\to\file(2).. etc
% To set up the file names so they read with the same name but a number varying in the bracket can be
%achieved by selecting all the data then pressing fn and f2 simultaneously


%% 

%all the variables you need to set

%setfilter size
filtersize=100;
%set filter position as a fraction of the overall length of the data
%in x
fracx=0.5;
%in y
fracy=0.5;

%file to set as the original surface
originalsurface="E:example\path\to\file(x).csv";
%file of surface once deformation has occured that will be used as the test for filtering
deformedsurface="E:example\path\to\file(x).csv";

%Over the whole image what is the area of interset in x and y?
xstart=1;
xend=380;
ystart=50;
yend=300;

%To animate through the surface you need to name the files as E:example\path\to\file(1), E:example\path\to\file(2).. etc
%Once this is done please add the path of the files replacing the ----E:example\path\to\file---- in the animation variable
animation= "E:example\path\to\file("+num2str(i(n))+").csv";

%how many files do you want to animate through?
animationlength=500;
%what rate of animation?
videorate=0.1;
% name of animation video
nameofvideo='nameofvideo.avi';





%% 






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Initial file
prechange = csvread(originalsurface)*10^3;
%%choose area of interest within file
prechange=prechange(ystart:yend,xstart:xend);

%%file after deformation
change=csvread(deformedsurface)*10^3;
%%choose area of interest within file (must be same size as prechange file)
change=change(ystart:yend,xstart:xend);

%%find difference
resized=(prechange-change);
changesize=(size(change));

% Prefiltering plot
figure
title("original data")
surf(resized)
h = colorbar; h.Label.String = 'Displacement (mm)'; %add a colour bar with title
zlabel('z displacement (mm)')

% convert the 2D data into the frequency domain
F=fft2(resized,changesize(1),changesize(2));
%visualise this data in the frequency domain
figure
title("original in frequency domain")
plot(abs(F))
figure
%%move data into the centre
Shifted_F=fftshift(F);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hold on
%%visualise data in the y direction
title("noisy data in y  direction with filter indicated by the ----")
plot(abs(Shifted_F),LineWidth=1)
%create filter in the y direction
freqfilter1=fn_gaussian(changesize(1),(fracy),((filtersize)/(changesize(1))))*max(max(abs(Shifted_F)));
%%visualise the filter
plot(freqfilter1,'r--','linewidth',2)
xlabel('Pixel Position')
ylabel('Amplitude')
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
hold on
%%visualise data in the x direction
title("noisy data in x  direction with filter indicated by the ----")
plot(abs(Shifted_F).')
%create filter in the x direction
freqfilter2=fn_gaussian(changesize(2),(fracx),((filtersize)/(changesize(2))))*max(max(abs(Shifted_F)));
%%visualise the filter
plot(freqfilter2,'r--','linewidth',2)
xlim([0 536])
xlabel('Pixel Position')
ylabel('Amplitude')
hold off
filtered_F=freqfilter1.*Shifted_F;
freqfilter2=freqfilter2.';
filtered_F=freqfilter2.*filtered_F;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%visualise filtered data
figure
title("filtered data in freq domain")
plot(abs(filtered_F))
figure
imagesc(abs(filtered_F))
%inverse the shift and fourier transform
unshifted=ifftshift(filtered_F);
untransformed=ifft2(unshifted,changesize(1),changesize(2));

%plot the final filtered data back in the time domain
figure
title("filtered data back in spatial domain")
surf(real(untransformed))

zlabel('z displacement (mm)')
h = colorbar; h.Label.String = 'Displacement (mm)'; %add a colour bar with title
%%



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %using these chosen filters apply it to all the data in a folder
%
%
%
%
%set up variables
n=1;
sizing=size(resized);
axisheight=5;
%%choose the name of your video
v=VideoWriter(nameofvideo);
%choose data range and step size
i=[1:1:500];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
untransformed_new=zeros(sizing(1),sizing(2), length(i));

open(v);

%looping through the data it is important to set up the file names so they
%read with the same name bu a number varying in the bracket this can be
%achieved by selecting all the data then pressing fn and f2 simultaneously
for n=1:1:length(i)

    prechange = csvread(originalsurface);
    %set the area of interest again
    prechange=prechange(ystart:yend,xstart:xend);

    change=csvread(animation);
    %set the area of interest again
    change=change(ystart:yend,xstart:xend);
    resized=(prechange-change)*10^3;
    
    changesize=(size(change));

    F=fft2(resized,changesize(1),changesize(2));
    Shifted_F=fftshift(F);
    filtered_F=freqfilter1.*Shifted_F;
    filtered_Free=freqfilter2.*filtered_F;
    unshifted=ifftshift(filtered_Free);
    %stores it in a 3d matrix where each 2d is from a different time frame
    untransformed_new(:,:,n)=ifft2(unshifted,changesize(1),changesize(2));


end

%%%%%%%%%%%%
%this code produces an animation which runs through all the data in time
%visualising it using a contour plot or surface as you choose

% Create figure and axis
fig = figure();
ax = axes('Parent', fig);

% Set up initial plot
title("animation of filtered surface over time")
surf(ax, real(untransformed_new(:,:,1)),'EdgeColor', 'none');
%contour(ax, real(untransformed_new(:,:,1)));

zlim(ax, [0 axisheight]);

% Loop through data and update plot
for ii = 2:size(untransformed_new,3)
    surf(ax, real(untransformed_new(:,:,ii)),'EdgeColor', 'none');
    %contour(ax, real(untransformed_new(:,:,ii)));
    title(i(ii))
    zlim(ax, [0 axisheight]);
    %saves each frame into a video
    frame=getframe(gcf);
    writeVideo(v,frame);
    pause(videorate); % Delay between frames
end


close(v);