# SourceCode_Manuscript_2204.10545
This repository contains the source codes used to generate the numerical results presented in the manuscript entitled: **"A Consistent Co-rotational Formulation for Quasi-Steady Aerodynamic Nonlinear Analysis of Frame Structure"** by M. Vanzulli and J. M. Pérez Zerpa . The manuscript is available at [this arxiv link](https://arxiv.org/abs/2204.10545).


## How to generate the numerical results


In linux: open a bash terminal and run the script

```
$ ./generate_all_examples_results.sh 
```


## Reproducibility 
The results [in this paper](https://arxiv.org/abs/2204.10545) were| produced using a computer with a Linux OS, a 64-bit architecture, an Intel i7-11370H CPU and 16 Gb of RAM. To reproduce the results you must have installed a bash O.S, [Octave 7-3-0](https://github.com/gnu-octave/octave/releases/tag/release-7-3-0) and the ONSAS software commit [d7ac74](https://github.com/ONSAS/ONSAS.m/tree/d7ac74f9d3a13b3b20338ea157cba915b421332d). Otherwise, you can use the [docker container](https://github.com/mvanzulli/SourceCode_Manuscript_2204.10545/blob/main/Dockerfile) and extract the .pdf compiled by [numerical_results.tex](https://github.com/mvanzulli/SourceCode_Manuscript_2204.10545/blob/main/numerical_results/numerical_results.tex) in the container. 

