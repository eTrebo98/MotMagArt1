function [imMag, ifail] = CompMagMatrix(im1,im2,alpha)

    %This function performs a magnification between two images (matrices) which differs
    %from each other by a certain amount of motion. The procedure is
    %constructed in such a way to work with odd-sized images.
    %   INPUT: im1: first frame in greyscale
    %          im2: second frame shifted, in greyscale
    %          alpha: magnification factor
    %   OUTPUT:imMag: Magnified frame
    %          ifail: integer scalar, ifail = 0 unless the function detects
    %                 an error (ifail = 1 the two images have different
    %                 sizes, ifail = 2 if one N or M are not odd, ifail = 3 if alpha < 0)
    
    %calculate the sizes of the two frames
    ifail = 0;

    [N_1,M_1] = size(im1);
    [N_2,M_2] = size(im2);
    
    %if the frames have different sizes we can't compute this task.
    if N_1 ~= N_2 || M_1 ~= M_2
        ifail = 1;
        return;
    end

    %if one of N or M is even we can't compute this task.
    if mod(N_1,2) == 0 || mod(M_1,2) == 0
        ifail = 2;
        return;
    end

    %if the magnification parameter is less than zero, we can compute the task.
    if alpha < 0
        ifail = 3;
        return;
    end
    
    %initialize the dimension of the image
    N = N_1;
    M = M_1;

    fftImMag = zeros(N,M); %matrix which contains the DFT of the magnified frame

    %compute the Discrete Fourier Transform of the two frames. Converting
    %to double the images since they are expressed in greyscale (values from 0
    %to 255).
    fftIm1 = fft2(im2double(im1));
    fftIm2 = fft2(im2double(im2));

    %the Cycle is performed only for the half-size of the matrix, because of
    %the hermitian symmetry of the DFT.
    for k=1:ceil(N/2)
        for l=1:ceil(M/2)
            if (k == 1) %we have a symmetry in the first row of the matrix
                if (l == 1) %the first element of the matrix has no symmetric
                    %calling ComputeMag function, which computes the DFT of the
                    %current (k,l) element of the magnified DFT
                    [fftImMag(k,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                else
                    refl = M-l+2;%take the reflected index for the symmetry
                    [fftImMag(k,l), fftImMag(k,refl)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
                end
            else
                %Hermitian symmetry along the first column
                if (l == 1)
                    refk = N-k+2; %take the reflected index for the symmetry
                    [fftImMag(k,l), fftImMag(refk,l)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
    
                else %now the symmetry is respect the centre of the matrix
    
                    %computing the reflected indices for the symmetry
                    refk = N-k+2;
                    refl = M-l+2;
    
                    %calling the ComputeMag function, which performs the
                    %magnification of the (k,l) element of the matrix and its
                    %conjugate symmetric
                    [fftImMag(k,l), fftImMag(refk,refl)] = CompElemMag(fftIm1(k,l),fftIm2(k,l),alpha);
    
                    %compute the magnification of the (k,refl) element and its
                    %conjugate symmetric.
                    [fftImMag(k,refl), fftImMag(refk,l)] = CompElemMag(fftIm1(k,refl),fftIm2(k,refl),alpha);
                end
            end
        end
    end
    %compute the ifft of the magnified Frame
    imMag = im2uint8(ifft2(fftImMag));
    
end
