Gourab Ghosh Roy, Raabid Hussain, Mohammad Rami Koujan
Image Visibility Clarification and Enhancement
Robotics Project



For RGB Images and Videos
(Some methods work on grayscale too, some work only in color space)
---------------------

Image Dehazing

Image Dehazing using 3 state of the art methods - Non Local Dehazing, Dark Channel Prior and Screened Poisson (see references)

Main file imageDehazing.m 
Change method and/or parameters 


---------------------

---------------------

Image Evaluation Metrics

Image Evaluation Metrics from Qing et al. (see references)
File imageEvaluationMetrics.m 


---------------------

Video Dehazing

Use static frame by frame approach or Spatial Temporal Information Fusion (see references)

Main file videoDehazing.m 
Change methods and/or parameters


---------------------

Video Evaluation Metrics

Video Evaluation Metrics from Qing et al. (see references)
File videoEvaluationMetrics.m 


---------------------

------------------------------------------------------------------------

References

1. Qing, C., Yu, F., Xu, X., Huang, W. and Jin, J., Underwater video dehazing based on spatial–temporal information fusion. Multidimensional Systems and Signal Processing, pp.1-16, 2016

Ideas used from this paper implemented in videoDehazing.m and files in
folder spatial_temporal_information_fusion_video

Also metrics used from this paper implemented


2. Jean-Michel Morel, Ana-Belen Petro, and Catalina Sbert, Screened Poisson Equation for Image Contrast Enhancement, Image Processing On Line, 4 (2014), pp. 16–29. https://doi.org/10.5201/ipol.2014.84

C code obtained from 
http://www.ipol.im/pub/art/2014/84/

Converted into MATLAB (folder screened_poisson_enhancement)


3. Single Image Haze Removal Using Dark Channel Prior
Kaiming He, Jian Sun and Xiaoou Tang
IEEE Transactions on Pattern Analysis and Machine Intelligence
Volume 30, Number 12, Pages 2341-2353
2011

MATLAB Implementation (folder Dark-Channel-Haze-Removal-master) obtained from 
https://github.com/sjtrny/Dark-Channel-Haze-Removal


4. Non-Local Image Dehazing. Berman, D. and Treibitz, T. and Avidan S., CVPR 2016 

MATLAB Code (folder non_local_dehazing) obtained from 
http://www.eng.tau.ac.il/~berman/NonLocalDehazing/








