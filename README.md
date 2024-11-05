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
