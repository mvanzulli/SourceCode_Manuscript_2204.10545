# Copyright (C) 2023, Mauricio C. Vanzulli, Jorge M. Perez Zerpa.
#
#
if [ -d "ONSAS" ] 
then
  echo "ONSAS dir found." 
else
  echo "Downloading ONSAS"
  ./download_ONSAS.sh
fi
# Run all examples
#
for i in {1..4}
do
  echo "generating Example${i}"
  cd examples/Example_${i}
  ./reproduce_Example_${i}.sh
  cd ..
done
