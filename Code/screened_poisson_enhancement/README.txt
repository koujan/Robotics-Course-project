% Screened Poisson Equation 

# ABOUT

* Author    : Catalina Sbert  <catalina.sbert@uib.es>
              Ana Belén Petro <anabelen.petro@uib.es>
* Copyright : (C) 2009-2013 IPOL Image Processing On Line http://www.ipol.im/
* License   : GPL v3+, see GPLv3.txt

* Version 1, released on November 15, 2013

# OVERVIEW

Given an image f, the algorithm computes a new image $u$ with the same gradient and with minimum variance. The solution is obtained by solving a Screened Poisson Equation using the Fast Fourier Transform as described in IPOL
     http://www.ipol.im/pub/algo/mps_screened_poisson_equation/

This program reads a PNG image, given L the tradeoff parameter between the two terms of the functional, and  s the percentage of saturation of the simplest color balance the program computes a new PNG image as the solution of the screened Poisson equation.
The program works on each color channel independently.

# REQUIREMENTS

The code is written in ANSI C, and should compile on any system with
an ANSI C compiler.

The io_png library is required for read and write a png image.

The libpng header and libraries are required on the system for
compilation and execution. See http://www.libpng.org/pub/png/libpng.html

The fftw3 header and libraries are required on the system for
compilation and execution. See http://www.fftw.org/

# COMPILATION

Simply use the provided makefile, with the command `make`.

# USAGE

screened_poisson L  input   sim_input  output [s]
	L 		the tradeoff parameter of the functional in (0, 2]
	input	 	input file
	sim_input	simplest color balance of the input
	output  	the solution after a simplest color balance with s% 			of saturation
        [s]		optional parameter, the percentage of saturation of 			the simplest color balance, by default 0.1.


#EXAMPLE

./screened_poisson 0.003 bias.png sbc_bias.png bias_output.png 
 

#CREDITS AND ACKNOWLEDGMENTS

The author of io_png library is Nicolas Limare.
 
# ABOUT THIS FILE

Copyright 2009-2013 IPOL Image Processing On Line http://www.ipol.im/
Author: Catalina Sbert <catalina.sbert@uib.es>

Copying and distribution of this file, with or without modification,
are permitted in any medium without royalty provided the copyright
notice and this notice are preserved.  This file is offered as-is,
without any warranty.
