clc;
clear;
close all;

%% Read images
img1 = imread('Normal cornea.png');
img2 = imread('Keratoconus cornea.png');

%% Resize
img1 = imresize(img1, [400 400]);
img2 = imresize(img2, [400 400]);

%% Convert to HSV
hsv1 = rgb2hsv(img1);
hsv2 = rgb2hsv(img2);

Z1 = hsv1(:,:,3);
Z2 = hsv2(:,:,3);

% Advanced smoothing
Z1 = medfilt2(Z1,[7 7]);
Z2 = medfilt2(Z2,[7 7]);

Z1 = imgaussfilt(Z1, 3);
Z2 = imgaussfilt(Z2, 3);

%% Dome
n = size(Z1,1);
[x,y] = meshgrid(linspace(-1,1,n), linspace(-1,1,n));
r = sqrt(x.^2 + y.^2);

dome = sqrt(1 - r.^2);
dome(r>1) = NaN;

%% دمج
Z1 = Z1 .* dome;
Z2 = Z2 .* dome;

edge_mask = r < 0.95;
Z1(~edge_mask) = NaN;
Z2(~edge_mask) = NaN;

%% Plot
figure('Color','w','Position',[100 100 1200 500]);

subplot(1,2,1)
surf(Z1,'EdgeColor','none');
colormap jet
title('Normal Cornea','FontWeight','bold')
axis off
view(45,30)
shading interp
lighting phong
camlight headlight

subplot(1,2,2)
surf(Z2,'EdgeColor','none');
colormap jet
title('Keratoconus Cornea','FontWeight','bold')
axis off
view(45,30)
shading interp
lighting phong
camlight headlight

%% Save HD
exportgraphics(gcf,'cornea_3D_final.png','Resolution',400);