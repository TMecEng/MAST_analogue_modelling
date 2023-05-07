clear all
close all
clc
%this code lets you first filter one frame of data in the first section before repeating that
%filtering over all the data and producing an animation of all the data
%which is then recorded as a video please read through all the data and
%fill out all the recommendations before running the code, in particular
%please name you files so they can be found by the convention
%E:example\path\to\file(1), E:example\path\to\file(2).. etc
%the filter is indicated in ---- and requiures download the additional
%gaussian filter function in the same directory



%setfilter size
filtersize=100;


%%Initial file
prechange = csvread("E:example\path\to\file(x)")*10^3;
%%choose area of interest within file
prechange=prechange(1:280,250:658);

%%file after deformation
change=csvread("E:example\path\to\file(x)")*10^3;
%%choose area of interest within file (must be same size as prechange file)
change=change(1:280,250:658);

%%find difference
resized=(prechange-change);
changesize=(size(change));

% Prefiltering plot
figure
surf(resized)
% xlim([0 340])
% ylim([0 325])
% caxis([0,6]);
%caxis([0, 2.5]);
h = colorbar; h.Label.String = 'Displacement (mm)'; %add a colour bar with title
zlabel('z displacement (mm)')

% convert the 2D data into the frequency domain
F=fft2(resized,changesize(1),changesize(2));
%visualise this data in the frequency domain
figure
plot(abs(F))
figure
%%move data into the centre
Shifted_F=fftshift(F);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hold on
%%visualise data in the y direction
plot(abs(Shifted_F),LineWidth=1)
%create filter in the y direction
freqfilter1=fn_gaussian(changesize(1),(0.502),((filtersize)/(changesize(1))))*max(max(abs(Shifted_F)));
%%visualise the filter
plot(freqfilter1,'r--','linewidth',2)
xlabel('Pixel Position')
ylabel('Amplitude')
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
hold on
%%visualise data in the x direction
plot(abs(Shifted_F).')
%create filter in the x direction
freqfilter2=fn_gaussian(changesize(2),(0.501),((filtersize)/(changesize(2))))*max(max(abs(Shifted_F)));
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
plot(abs(filtered_F))
figure
imagesc(abs(filtered_F))
%inverse the shift and fourier transform
unshifted=ifftshift(filtered_F);
untransformed=ifft2(unshifted,changesize(1),changesize(2));

%plot the final filtered data back in the time domain
figure

surf(real(untransformed))
% xlim([0 340])
% ylim([0 325])

% caxis([0,6]); 


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
v=VideoWriter('nameofvideo.avi');
%choose data range and step size
i=[150:1:350];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
untransformed_new=zeros(sizing(1),sizing(2), length(i));

open(v);
%loop through the data it is important to set up the file names so they
%read with the same name bu a number varying in the bracket this can be
%achieved by selecting all the data then pressing fn and f2 simultaneously
for n=1:1:length(i)

    prechange = csvread("E:example\path\to\file(x)");
    %set the area of interest again
    prechange=prechange(1:280,250:658);

    change=csvread("E:example\path\to\file("+num2str(i(n))+").csv");
    %set the area of interest again
    change=change(1:280,250:658);
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
    pause(0.1); % Delay between frames
end


close(v);