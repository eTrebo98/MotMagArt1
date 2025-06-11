function [imMag, ifail] = CompMagMatGen(im1,im2,alpha)

    %This function performs a magnification between two images which differs
    %from each other by a certain amount of motion expressed in pixels. The
    %function can receive as input two images with dimensions which can be even
    %or odd. The magnified frame is performed by creating its DFT, which has a
    %precise symmetry when the dimensions are even or odd numbers.
    %   INPUT: im1: first frame
    %          im2: second (shifted) frame
    %          alpha: magnification factor
    %   OUTPUT: imMag: Magnified frame in gray-scale
    %           ifail: integer scalar, ifail = 0 unless the function detects
    %                 an error (ifail = 1 the two images have different
    %                 sizes, ifail = 2 if alpha < 0)
    %
    % Copyright (c) 2024-2025 University of Camerino, 2T System srl
    %
    % Authors: Nadaniela Egidi, Josephin Giacomini, Paolo Leonesi, Pierluigi Maponi, Federico Mearelli, Edin Trebovic 
    %
    % Date: Dec 2024
    %
    % Version: 1.0
    %

    %setting ifail = 0, no errors occurred
    ifail = 0;
    %calculate the sizes of the two frames
    [N_1,M_1] = size(im1);
    [N_2,M_2] = size(im2);
    
    %if the frames have different sizes we can not compute this task.
    if N_1 ~= N_2 || M_1 ~= M_2
        ifail = 1;
        return;
    end

    %if the magnification parameter is less than zero, we can not compute this task.
    if alpha < 0
        ifail = 2;
        return;
    end

    %setting the effective dimension of the two images
    N = N_1; %weight of the images
    M = M_1; %width of the images
    
    %compute the Discrete Fourier Transform of the two frames, after
    %converting the two images to double precision, for better results.
    fftIm1 = fft2(im2double(im1));
    fftIm2 = fft2(im2double(im2));
    
    fftImMag = zeros(N,M); %initializing the matrix which contains 
    % the DFT of the magnified frame.
    
    %initializing the flags which are used to handle even sizes (0 odd, 1
    %even)
    flag_r = 0;
    flag_c = 0;
    %getting the half dimension of the images, remembering that the DFT
    %it by considering its symmetries
    N2 = ceil(N/2);
    M2 = ceil(M/2);
    
    %checking if the height of the matrix is even
    if mod(N,2) == 0
        flag_r = 1; %true: setting the flag to 1
        N2 = N2 + 1; %adding 1 to r in order to handle the central row
    end
    
    %checking if the width of the matrix is even
    if mod(M,2) == 0
        flag_c = 1; %true: setting the flag to 1
        M2 = M2 + 1; %adding 1 to c in order to handle the central column
    end
    
    %cycle on the half dimension of the matrix
    for k=1:N2
        for l=1:M2
            if (k == 1) %symmetry in the first row of the matrix
                if (l==1) 
                    %the first element is real (no conjugate symmetric)
                    [fftImMag(k,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha); %computing the magnification of the current element
                else
                    if (l ~= M2) %for the next indices, consider the (k,l) element and its symmetric (k,refl)
                        refl = M -l + 2; %getting the symmetric index for the current row
                        [fftImMag(k,l), fftImMag(k,refl)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha); %computing the magnification of the current element
                    else
                        if(flag_c == 0) %if the width of the images is odd (there is no a real central element)
                            refl = M - l +2; %getting the symmetric index for the current row
                            [fftImMag(k,M2), fftImMag(k,refl)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha); %computing the magnification of the current element
                        else %otherwise, M is even and so there is a real central element
                            [fftImMag(k,M2)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha); %computing the magnification of the current element
                        end
                    end
                end
            else
                if (k ~= N2)
                    if (l == 1) %symmetry in the first column of the DFT matrix
                        refk = N - k +2; %getting the symmetric index for the current column
                        [fftImMag(k,l), fftImMag(refk,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha); %computing the magnification of the current element
                    else %now the symmetry is respect the center of the DFT matrix
                        if (l ~= M2)
                            %getting the reflected indices
                            refk = N - k +2;
                            refl = M - l +2;
                            %computing the magnification of the current
                            %element (k,l) and the (k,refl)
                            [fftImMag(k,l), fftImMag(refk,refl)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                            [fftImMag(k,refl), fftImMag(refk,l)] = CompElemMag(fftIm1(k,refl),fftIm2(k,refl),alpha);
                        else %if l == c
                            if (flag_c == 0) %checking if M is odd. If so the symmetry is respect to the center of the DFT matrix
                                %getting the reflected indices
                                refk = N - k +2;
                                refl = M - l +2;
                                %computing the magnification of the current
                                %element (k,l) and the (k,refl)
                                [fftImMag(k,l), fftImMag(refk,refl)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                                [fftImMag(k,refl), fftImMag(refk,l)] = CompElemMag(fftIm1(k,refl),fftIm2(k,refl),alpha);
                            else %otherwise M is even, and the center column show a symmetry it self
                                refk = N - k +2; %getting the reflected index for the center column
                                [fftImMag(k,l), fftImMag(refk,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha); %computing the magnification of the current element
                            end
                        end
                    end
                else %if k = r
                    if (l == 1) %for the first column
                        if (flag_r == 0) %check if N is odd. If so continue the symmetry for the first column of the DFT matrix
                            refk = N - k +2; %getting the reflected indices for the current column
                            [fftImMag(k,l), fftImMag(refk,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha); %compute the magnification of the current
                            %element
                        else
                            %otherwise, if N is even, the central element
                            %of the first column is real
                            [fftImMag(k,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha); %compute the magnification of the current
                            %element
                        end
                    else
                        if (l ~= M2)
                            if (flag_r == 0) %checking if N is odd. if so, continue the symmetry with respect the center of the DFT matrix
                                %getting the reflected indicies
                                refk = N - k +2;
                                refl = M - l +2;
                                %compute the magnification of the current
                                %element (k,l) and (k,refl).
                                [fftImMag(k,l), fftImMag(refk,refl)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                                [fftImMag(k,refl), fftImMag(refk,l)] = CompElemMag(fftIm1(k,refl),fftIm2(k,refl),alpha);
                            else %otherwise N is even, the center row has an own symmetry
                                refl = M - l +2; %getting the symmetric index for the center row
                                %compute the magnification of the current
                                %element
                                [fftImMag(k,l), fftImMag(k,refl)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                            end
                        else
                            if (flag_r == 0 && flag_c == 0) %if both N and M are odd, continue to consider
                                % the symmetry with respect to the center of the DFT matrix
                                %getting the reflected indices
                                refk = N - k +2;
                                refl = M - l +2;
                                %computing the magnification of the current
                                %element (k,l), (k,refl)
                                [fftImMag(k,l), fftImMag(refk,refl)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                                [fftImMag(k,refl), fftImMag(refk,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                            else
                                if (flag_r == 1 && flag_c == 1) %if both N and M are even, then the center element of the DFT is real
                                    [fftImMag(k,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                                else
                                    if (flag_r == 1) %if only N is even, then consider the symmetry of the center row
                                        refl = M - l +2;
                                        [fftImMag(k,l), fftImMag(k,refl)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                                    else %otherwise only M is even. Consider the symmetry of the center column
                                        refk = N - k +2;
                                        [fftImMag(k,l), fftImMag(refk,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    %compute the ifft of the magnified Frame, and converting into 
    %gray-scale [0, 255]
    imMag = im2uint8(ifft2(fftImMag));
end

