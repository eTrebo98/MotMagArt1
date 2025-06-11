function [elemMag, elemConj] = CompElemMag(fft1,fft2,alpha)
    %This function computes the element wise DFT of the magnified frame.
    %   INPUT: fft1, the current element of the fft matrix of the first frame
    %          fft2, the current element of the fft matrix of the first frame
    %   OUTPUT: elemMag, the element of the fft of the magnified frame
    %           elemConj, the conjugate element of elemMag
    %
    % Copyright (c) 2024-2025 University of Camerino, 2T System srl
    %
    % Authors: Nadaniela Egidi, Josephin Giacomini, Paolo Leonesi, Pierluigi Maponi, Federico Mearelli, Edin Trebovic 
    %
    % Date: Dec 2024
    %
    % Version: 1.0
    %

    
    %computing the normalized ratio between the current fft elements of the
    %consecutive frame
    E = (fft2/(abs(fft2)))/(fft1/abs(fft1));
    
    elemMag = fft2*((E)^alpha); %compute the magnification
    
    %if the imaginary part of elemMag is not zero, perform the conjugate
    %element.
    if (imag(elemMag) ~= 0)
        elemConj = conj(elemMag);
    else
        elemConj = 0; %else set it to 0
    end
end
