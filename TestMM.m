%Test the MM algorithm

close all
clear all

%this script uses the images and the video sequence to test the MM 
%algorithm

%reading and showing the images (please check your path)
im1 = imread("Test Figures\Ref_1.jpg");
figure(1);
imshow(im1);

im2 = imread("Test Figures\Shift_1.jpg");
figure(2);
imshow(im2);

alpha = 25;
[imMag, ifail] = CompMagMatrix(im1,im2,alpha); %calling CompMagMatrix to compute the magnified frame

if ifail == 0
    figure(3);
    imshow(imMag); %showing the magnified frame
else
    disp("An error occurs! Can not compute the procedure!\n");
end

pause = input("To move on to the next test, press any key: ");

close all
clear all

%reading and showing the images (please check your path)
im1 = imread("Test Figures\Ref_4.jpg");
figure(1);
imshow(im1);

im2 = imread("Test Figures\Shift_4.jpg");
figure(2);
imshow(im2);

alpha = 50;
[imMag, ifail] = CompMagMatGen(im1,im2,alpha); %calling CompMagMatGen to compute the magnified frame

if ifail == 0
    figure(3);
    imshow(imMag); %showing the magnified frame
else
    disp("An error occurs! Can not compute the procedure!\n");
end



