# MotMagArt1
The **MotMagArt1** repository includes MATLAB code for three functions - `CompMagMatrix`, `CompMagMatGen`, and `CompElemMag` - used to perform Motion Magnification on synthetic grayscale images. 
It also contains two folders: **Test Images**, which provides images for testing the magnification procedure, and **Videos**, which holds three videos – the original input, the magnified result, 
and a comparison video displaying both input and magnified videos side-by-side.

## `CompMagMatrix`
- **Syntax.** *[imMag, ifail] = CompMagMatrix(im1,im2,alpha)*
- **Purpose.** Computes the digital image containing the magnified motion.
- **Description.** *[imMag, ifail] = CompMagMatrix(im1,im2,alpha)*, takes two gray-scale odd-sized images *im1* and *im2*, and computes the magnified digital image *imMag* with a magnification factor *alpha* by 
                    applying a magnification procedure via frequency domain.
- **Parameters.**
    - **input** *im1*, *im2* - gray-scale images of data type uint8 with values in the interval $[0,255]$.
    - **input** *alpha* - double scalar specifying the magnification factor applied to the subtle motion
    - **output** *imMag* - uint8 matrix of the same size as *im1* and *im2* representing the digital image with the magnified motion.
    - **output** *ifail* - integer scalar. *ifail = 0* unless the function detects an error (see Error Indicators and Warnings)
- **Error Indicators and Warnings.** Here is the list of errors or warnings detected by the function:
    - *ifail = 1* - if the size of *im1* and *im2* differs.
    - *infail = 2* - if *im1* and *im2* are not odd-sized.

## `CompMagMatGen`
- **Syntax.** *[imMag, ifail] = CompMagMatGen(im1,im2,alpha)*
- **Purpose.** Computes the digital image containing the magnified motion.
- **Description.** *[imMag, ifail] = CompMagMatGen(im1,im2,alpha)*, takes two gray-scale images *im1* and *im2* <ins>of any size</ins>, and computes the magnified digital image *imMag* with a magnification factor 
                   *alpha* by applying a magnification procedure via frequency domain.
- **Parameters.**
    - **input** *im1*, *im2* - gray-scale images of data type uint8 with values in the interval $[0,255]$.
    - **input** *alpha* - double scalar specifying the magnification factor applied to the subtle motion
    - **output** *imMag* - uint8 matrix of the same size as *im1* and *im2* representing the digital image with the magnified motion.
    - **output** *ifail* - integer scalar. *ifail = 0* unless the function detects an error (see Error Indicators and Warnings)
- **Error Indicators and Warnings.** Here is the list of errors or warnings detected by the function:
    - *ifail = 1* - if the size of *im1* and *im2* differs.

## `CompElemMag`
- **Syntax.** *[elemMag, elemConj] = CompElemMag(fft1,fft2,alpha)*
- **Purpose.** Computes the element of the DFT of the magnified frame.
- **Description.** *[elemMag, elemConj] = CompElemMag(fft1,fft2,alpha)*, takes the current two elements of the DFTs of *im1* and *im2*, and computes the formula: <br/>
                  <p align="center"> $$\widehat{\tilde{J_2}}(k,l) = \hat{J}_2(k,l) (E(k,l))^{\alpha}$$</p> <br/>
  where $E(k,l)$ is given by <br/>
  <p align="center">$$E(k,l) = \dfrac{\hat{J}_2(k,l)/ |\hat{J}_2(k,l)|}{\hat{J}_1(k,l)/ |\hat{J}_1(k,l)|} = e^{2\pi \iota (\delta_1 \frac{k}{N} + \delta_2 \frac{l}{M})}$$</p>
- **Parameters.**
    - **input** *fft1*, *fft2* - complex scalars representing the current element of DFTs of the images.
    - **input** *alpha* - double scalar specifying the magnification factor applied to the subtle motion
    - **output** *elemMag* - complex scalar representing the current element of the magnified DFT.
    - **output** *elemConj* - complex scalar representing the symmetric conjugate of the current element of the magnified DFT
