function [imMag, ifail] = CompMagMatGen(im1,im2,alpha)

    %This function perform a magnification between two images which differs
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
    %                 sizes)

    %setting ifail = 0, no errors occurred
    ifail = 0;
    %calculate the sizes of the two frames
    [r_1,c_1] = size(im1);
    [r_2,c_2] = size(im2);
    
    %if the frames have different sizes we can't compute the magnification.
    if r_1 ~= r_2 || c_1 ~= c_2
        ifail = 1;
        return;
    end

    %setting the effective dimension of the two images
    dimR = r_1; %weight of the images
    dimC = c_1; %width of the images
    
    %compute the Discrete Fourier Transform of the two frames, after
    %converting the two images to double precision, for better results.
    fftIm1 = fft2(im2double(im1));
    fftIm2 = fft2(im2double(im2));
    
    fftImMag = zeros(dimR,dimC); %initializing the matrix which contains 
    % the DFT of the magnified frame.
    
    %initializing the flags which are used to handle even sizes (0 odd, 1
    %even)
    flag_r = 0;
    flag_c = 0;
    %getting the half dimension of the images, remembering that the DFT
    %it by considering its symmetries
    r = ceil(dimR/2);
    c = ceil(dimC/2);
    
    %checking if the height of the matrix is even
    if mod(dimR,2) == 0
        flag_r = 1; %true: setting the flag to 1
        r = r + 1; %adding 1 to r in order to handle the central row
    end
    
    %checking if the width of the matrix is even
    if mod(dimC,2) == 0
        flag_c = 1; %true: setting the flag to 1
        c = c + 1; %adding 1 to c in order to handle the central column
    end
    
    %cycle on the half dimension of the matrix
    for k=1:r
        for l=1:c
            if (k == 1) %symmetry in the first row of the matrix
                if (l==1) 
                    %the first element is real (no conjugate symmetric)
                    [fftImMag(k,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha); %computing the magnification of the current element
                else
                    if (l ~= c) %for the next indices, consider the (k,l) element and its symmetric (k,refl)
                        refl = dimC -l + 2; %getting the symmetric index for the current row
                        [fftImMag(k,l), fftImMag(k,refl)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha); %computing the magnification of the current element
                    else
                        if(flag_c == 0) %if the width of the images is odd (there is no a real central element)
                            refl = dimC - l +2; %getting the symmetric index for the current row
                            [fftImMag(k,c), fftImMag(k,refl)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha); %computing the magnification of the current element
                        else %otherwise, M is even and so there is a real central element
                            [fftImMag(k,c)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha); %computing the magnification of the current element
                        end
                    end
                end
            else
                if (k ~= r)
                    if (l == 1) %symmetry in the first column of the DFT matrix
                        refk = dimR - k +2; %getting the symmetric index for the current column
                        [fftImMag(k,l), fftImMag(refk,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha); %computing the magnification of the current element
                    else %now the symmetry is respect the center of the DFT matrix
                        if (l ~= c)
                            %getting the reflected indices
                            refk = dimR - k +2;
                            refl = dimC - l +2;
                            %computing the magnification of the current
                            %element (k,l) and the (k,refl)
                            [fftImMag(k,l), fftImMag(refk,refl)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                            [fftImMag(k,refl), fftImMag(refk,l)] = CompElemMag(fftIm1(k,refl),fftIm2(k,refl),alpha);
                        else %if l == c
                            if (flag_c == 0) %checking if M is odd. If so the symmetry is respect to the center of the DFT matrix
                                %getting the reflected indices
                                refk = dimR - k +2;
                                refl = dimC - l +2;
                                %computing the magnification of the current
                                %element (k,l) and the (k,refl)
                                [fftImMag(k,l), fftImMag(refk,refl)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                                [fftImMag(k,refl), fftImMag(refk,l)] = CompElemMag(fftIm1(k,refl),fftIm2(k,refl),alpha);
                            else %otherwise M is even, and the center column show a symmetry it self
                                refk = dimR - k +2; %getting the reflected index for the center column
                                [fftImMag(k,l), fftImMag(refk,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha); %computing the magnification of the current element
                            end
                        end
                    end
                else %if k = r
                    if (l == 1) %for the first column
                        if (flag_r == 0) %check if N is odd. If so continue the symmetry for the first column of the DFT matrix
                            refk = dimR - k +2; %getting the reflected indices for the current column
                            [fftImMag(k,l), fftImMag(refk,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha); %compute the magnification of the current
                            %element
                        else
                            %otherwise, if N is even, the central element
                            %of the first column is real
                            [fftImMag(k,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha); %compute the magnification of the current
                            %element
                        end
                    else
                        if (l ~= c)
                            if (flag_r == 0) %checking if N is odd. if so, continue the symmetry with respect the center of the DFT matrix
                                %getting the reflected indicies
                                refk = dimR - k +2;
                                refl = dimC - l +2;
                                %compute the magnification of the current
                                %element (k,l) and (k,refl).
                                [fftImMag(k,l), fftImMag(refk,refl)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                                [fftImMag(k,refl), fftImMag(refk,l)] = CompElemMag(fftIm1(k,refl),fftIm2(k,refl),alpha);
                            else %otherwise N is even, the center row has an own symmetry
                                refl = dimC - l +2; %getting the symmetric index for the center row
                                %compute the magnification of the current
                                %element
                                [fftImMag(k,l), fftImMag(k,refl)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                            end
                        else
                            if (flag_r == 0 && flag_c == 0) %if both N and M are odd, continue to consider
                                % the symmetry with respect to the center of the DFT matrix
                                %getting the reflected indices
                                refk = dimR - k +2;
                                refl = dimC - l +2;
                                %computing the magnification of the current
                                %element (k,l), (k,refl)
                                [fftImMag(k,l), fftImMag(refk,refl)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                                [fftImMag(k,refl), fftImMag(refk,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                            else
                                if (flag_r == 1 && flag_c == 1) %if both N and M are even, then the center element of the DFT is real
                                    [fftImMag(k,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                                else
                                    if (flag_r == 1) %if only N is even, then consider the symmetry of the center row
                                        refl = dimC - l +2;
                                        [fftImMag(k,l), fftImMag(k,refl)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                                    else %otherwise only M is even. Consider the symmetry of the center column
                                        refk = dimR - k +2;
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
