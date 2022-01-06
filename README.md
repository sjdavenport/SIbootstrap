# Selective peak inference: Unbiased estimation of raw and standardized effect size at local maxima
The code here can be used to calculate the bias at peak locations, fit big data analyses and simulations as well as to 
reproduce all figures from the paper available at: https://www.sciencedirect.com/science/article/pii/S1053811919309668.
Please feel free to use any and all of the code from this repository in your own work
however if you do please cite our paper and please include a link to this repository.


## Table of contents
* [Introduction](#introduction)
* [Folder Structure](#folderstruct)
    * [Bias Calculations](#biascalcs)
    * [Linear Modelling](#linmod)
    * [Power](#power)
    * [Results](#results)
    * [Results Figures](#resfigs)
    * [Simulations](#sims)
    * [Statistical Functions](#statfns)
* [Dependencies](#dependencies)
* [Citation](#cite)

## Introduction <a name="introduction"></a>
The spatial signals in neuroimaging mass univariate analyses can be characterized 
in a number of ways, but one widely used approach is peak inference: the 
identification of peaks in the signal. Peak locations and magnitudes provide 
a useful summary of activation and are routinely reported, however, the 
magnitudes reflect selection bias as these points have both survived a threshold 
and are local maxima. In this toolbox we provide resampling methods 
to estimate and correct this bias in order to estimate both the raw units 
change as well as standardized effect size measured with Cohen’s d and 
partial R2. 

The details and performance of our methods can be found in our paper:
Selective peak inference: Unbiased estimation of raw and standardized effect size at local maxima.
There we evaluate our method with a massive open dataset, and discuss 
how the corrected estimates can be used to perform power analyses.

## Folder Structure <a name="folderstruct"></a>

### Bias Calculations <a name="biascalcs"></a>

This folder contains the functions used to implement the bootstrap, 
circular inference and data-splitting to compute estiamtes of the mean, 
Cohen's d and partial R^2 estimates for the General Linear Model.

### Linear Modelling <a name="linmod"></a>
This folder contains MVlm_multivar which fits a multivariate linear model 
at every voxel (when the total number of subjects can fit into memory). 
It also includes examples of how large scale linear models can be run.

### Power <a name="power"></a>
This folder contains powercalcT and powercalcF which calculate power for
one-sample and general linear model respectively based on estimates of 
Cohen's d and Cohen's f^2.

### Results <a name="results"></a>
This folder contains the results of applying the bootstrap, 
circular inference and data-splitting to the UK biobank fMRI and VBM data
as well as functions to load and display these results.

### Results Figures <a name="resfigs"></a>
This folder contains code to reproduce all results figures from the paper 
as well as pdfs of the figures themselves. 

In order to run it you must first edit startup.m so that SIbootstrap_loc 
is the location of the SIbootstrap repository and then run startup.m to 
define SIbootstrap_loc and the variable def_col (which provides coloring 
for the plots). (Note that a prefix of S denotes a figure from the 
supplementary material.)

The simulations data can be regenerated from scratch (this has already been 
run, but see the code in the Simulations folder in order to re-run it if 
you would like to). And using the data from the Results folder (already 
calculated) we can produce the figures corresponding to the real data.

Here we plot the results for bias, standard deviation and root mean squared error, see the paper for more details. 

![alt tag](Results_Figures/Figures_9_11_13_S3/Figure_11_bias.pdf)
![alt tag](Results_Figures/Figures_9_11_13_S3/Figure_11_std.pdf)
![alt tag](Results_Figures/Figures_9_11_13_S3/Figure_11_rmse.pdf)

### Simulations <a name="sims"></a>
This folder contains code to generate the simulations for the paper as well
as the thresholds used. This requires the RFTtoolbox (see [Dependencies](#rftbox))
in order to run.

The subfolder Thresholds contains code to calculate the thresholds used in 
the one-sample and GLM simulations in the paper. store_thresh_nsubj.mat
stores these thresholds in a .mat file (as they take a non-trivial amount 
of time to run).

calcests_sims_thresh can be used to run the simulations and 
dispres_sims_thresh can be used to display the simulation results.

### Statistical Functions <a name="statfns"></a>
This folder contains general statistical functions used in modelling.

## Dependencies <a name="dependencies"></a>

### RFTtoolbox <a name="rftbox"></a>
In order to run most of this code you will need the RFTtoolbox package.  
This can be downloaded at: https://github.com/sjdavenport/RFTtoolbox.
This package is used to generate the simulations, perform RFT inference 
and perform general inference on local maxima.

### MATLAB
All code was run in matlab2015a.

### export_fig
Figures were printed to pdfs using the export_fig matlab package. This can be 
downloaded at https://uk.mathworks.com/matlabcentral/fileexchange/23629-export_fig

## Citation <a name="dependencies"></a>
Please feel free to use any and all of the code from this repository in your own work
however if you do please cite our paper:
Davenport, Samuel, and Nichols, Thomas E. "Selective peak inference: Unbiased estimation of raw and standardized effect size at local maxima." NeuroImage 209 (2020): 116375
and please include a link to this repository.


```
Mag = [1, repmat(0.5, 1, 6), 0.7, 0.3];
Rad = [repmat(10, 1, 5), 6, 8, 6, 10];
stdsize = [91,109,91];
Sig = gensig( Mag, Rad, 6, stdsize, {[45.5, 54.5, 45.5], [20,20,20], [71,20,20], [20,20,71], [20,89,20], [71,89,20], [71,20, 71], [20, 89, 71], [71, 89, 71]} );
surf(Sig(:,:,80))
```

```
Sig = Sig(:)';
B = 100;
nsubj = 20;
data = zeros(nsubj, prod(stdsize));
subject_mask = ones(stdsize);

FWHM = 3; %FWHM in voxels.
noise = noisegen(stdsize, nsubj, FWHM, 3 );
for I = 1:nsubj
    data(I, :) = Sig + noise(I,:);
end

[ est, estwas, trueval, top_lm_indices ] = tbias_thresh(1, B, data, subject_mask, Sig );
```
