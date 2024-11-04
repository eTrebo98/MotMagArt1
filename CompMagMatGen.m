function [imMag, ifail] = CompMagMatGen(im1,im2,alpha)
    %This function perform a magnification between two images which differs
    %from each other by a certain amount of motion expressed in pixels. The
    %function can receive as input two images with dimensions which can be even
    %or odd. The magnified frame is performed by creating its DFT, which has a
    %precise symmetry when the dimensions are even or odd numbers.
    %   INPUT: im1: first frame
    %          im2: second (shifted) frame
    %          alpha: magnification factor
    %   OUTPUT: imMag: Magnified frame
    %           ifail: integer scalar, ifail = 0 unless the function detects
    %                 an error (ifail = 1 the two images have different
    %                 sizes, ifail = 2 if one N or M are not odd)

    
    %calculate the sizes of the two frames
    ifail = 0;

    [r_1,c_1] = size(im1);
    [r_2,c_2] = size(im2);
    
    %if the frames have different sizes we can't compute this task.
    if r_1 ~= r_2 || c_1 ~= c_2
        ifail = 1;
        return;
    end

    dimR = r_1;
    dimC = c_1;
    
    %compute the Discrete Fourier Transform of the two frames.
    fftIm1 = fft2(im2double(im1));
    fftIm2 = fft2(im2double(im2));
    
    fftImMag = zeros(dimR,dimC); %matrix which contains the DFT of the magnified frame.
    
    flag_r = 0;
    flag_c = 0;
    r = ceil(dimR/2);
    c = ceil(dimC/2);
    
    if mod(dimR,2) == 0
        flag_r = 1;
        r = r + 1;
    end
    
    if mod(dimC,2) == 0
        flag_c = 1;
        c = c + 1;
    end
    
    for k=1:r
        for l=1:c
            if (k == 1) %we have a symmetry in the first row of the matrix
                %calling the function which compute the magnification
                if (l==1)
                    [fftImMag(k,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                else
                    if (l ~= c)
                        refl = dimC -l +2;
                        [fftImMag(k,l), fftImMag(k,refl)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                    else
                        if(flag_c == 0)
                            refl = dimC - c +2;
                            [fftImMag(k,c), fftImMag(k,refl)] = CompElemMag(fftIm1(k,c),fftIm2(k,c),alpha);
                        else
                            %no symmetric if flag_c is 1
                            [fftImMag(k,c)] = CompElemMag(fftIm1(k,c),fftIm2(k,c),alpha);
                        end
                    end
                end
            else
                if (k ~= r)
                    %Hermitian symmetry along the first column
                    if (l == 1)
                        %calling the function which compute the magnification
                        refk = dimR - k +2;
                        [fftImMag(k,l), fftImMag(refk,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                    else %now the symmetry is respect the centre of the matrix
                        if (l ~= c)
                            
    
                            refk = dimR - k +2;
                            refl = dimC - l +2;
                            [fftImMag(k,l), fftImMag(refk,refl)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
    
                            [fftImMag(k,refl), fftImMag(refk,l)] = CompElemMag(fftIm1(k,refl),fftIm2(k,refl),alpha);
                        else
                            if (flag_c == 0)
                                refk = dimR - k +2;
                                refl = dimC - l +2;
                                [fftImMag(k,l), fftImMag(refk,refl)] = CompElemMag(fftIm1(k,dimC),fftIm2(k,dimC),alpha);
    
                                [fftImMag(k,refl), fftImMag(refk,l)] = CompElemMag(fftIm1(k,refl),fftIm2(k,refl),alpha);
                            else
                                refk = dimR - k +2;
                                [fftImMag(k,l), fftImMag(refk,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                            end
                        end
                    end
                else
                    if (l == 1)
                        if (flag_r == 0)
                            refk = dimR - k +2;
                            [fftImMag(k,l), fftImMag(refk,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                        else
                            [fftImMag(k,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                        end
                    else
                        if (l ~= c)
                            if (flag_r == 0)
                                refk = dimR - k +2;
                                refl = dimC - l +2;
                                [fftImMag(dimR,l), fftImMag(refk,refl)] = CompElemMag(fftIm1(dimR,l),fftIm2(dimR,l),alpha);
    
                                [fftImMag(dimR,refl), fftImMag(refk,l)] = CompElemMag(fftIm1(dimR,refl),fftIm2(dimR,refl),alpha);
                            else
                                refl = dimC - l +2;
                                [fftImMag(dimR,l), fftImMag(dimR,refl)] = CompElemMag(fftIm1(dimR,l),fftIm2(dimR,l),alpha);
                            end
                        else
                            if (flag_r == 0 && flag_c == 0)
                                refk = dimR - k +2;
                                refl = dimC - l +2;
                                [fftImMag(dimR,dimC), fftImMag(refk,refl)] = CompElemMag(fftIm1(dimR,dimC),fftIm2(dimR,dimC),alpha);
    
                                [fftImMag(dimR,refl), fftImMag(refk,dimC)] = CompElemMag(fftIm1(dimR,refl),fftIm2(dimR,refl),alpha);
                            else
                                if (flag_r == 1 && flag_c == 1)
                                    [fftImMag(dimR,dimC)] = CompElemMag(fftIm1(dimR,dimC),fftIm2(dimR,dimC),alpha);
                                else
                                    if (flag_r == 1)
                                        refl = dimC - l +2;
                                        [fftImMag(dimR,l), fftImMag(dimR,refl)] = CompElemMag(fftIm1(dimR,l),fftIm2(dimR,l),alpha);
                                    else
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
    %compute the ifft of the magnified Frame
    imMag = im2uint8(ifft2(fftImMag));
end

