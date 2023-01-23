# Copyright (C) 2022, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
#
# Development and implementation of a consistent co-rotational 
# formulation for aerodynamic nonlinear analysis of frame structures.
#
# Docker images to reproduce the results using GNU Octave <https://www.octave.org>.

# Start with
FROM gnuoctave/octave:7.3.0

# Clone the repo  
RUN wget https://github.com/mvanzulli/SourceCode_Manuscript_2204.10545/archive/refs/heads/main.zip
# Unizp in a folder named ONSAS with the following command:
RUN unzip main.zip
# Remove zip file
RUN rm main.zip
# Enter into the repo
# WORKDIR /SourceCode_Manuscript_2204.10545-main

# Give permission to all .ssh file
RUN find ./ -type f -iname "*.sh" -exec chmod +x {} \;

# Downlowad ONSAS
RUN cd SourceCode_Manuscript_2204.10545-main && ./download_ONSAS.sh

# Reproduce all examples results
RUN  cd SourceCode_Manuscript_2204.10545-main && ./generate_all_examples_results.sh

# Copy out form the container
# COPY SourceCode_Manuscript_2204.10545-main/numerical_results/BladeCantForcesStatic.tex ./