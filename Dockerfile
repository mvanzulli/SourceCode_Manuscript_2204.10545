# Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
#
# Development and implementation of a consistent co-rotational 
# formulation for aerodynamic nonlinear analysis of frame structures.
#
# Docker images to reproduce the results using GNU Octave <https://www.octave.org>.

# Start with
FROM gnuoctave/octave:7.3.0

# Add the repo folder to the container
ADD . ./

# Download ONSAS
WORKDIR . 

# Downlowad ONSAS
RUN ./download_ONSAS.sh

# Create a volume 
VOLUME /data

# Run the scripts and copy the 
CMD ["./generate_all_examples_results.sh"] 

# Copy out form the container
COPY SourceCode_Manuscript_2204.10545-main/numerical_results/BladeCantForcesStatic.tex ./