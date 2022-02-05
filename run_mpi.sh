process=0

if [ "$1" = "--init" ]; then
    rm -f -r sod/
    git clone https://github.com/symisc/sod.git
    exit 0
fi

make

mpicc sod.o -D_DEFAULT_SOURCE -lm -o mpi_filtro mpi_filtro.c 

if [ $process = 0 ]; then
    process=$(($1-0));
else
    process=1
fi


echo " "
echo "MPI - Running using $process process..."
echo " "


echo "MPI ($process process)" >> tmp.log

echo " "
echo "MPI - Imagen 720P"
/usr/bin/time --format="%E real" mpirun -np $process ./mpi_filtro img/input1.png img/output1.png 8

echo " "
echo "MPI - Imagen 1080P"
/usr/bin/time --format="%E real" mpirun -np $process ./mpi_filtro img/input2.png img/output2.png 8

echo " "
echo "MPI - Imagen 4K"
/usr/bin/time --format="%E real" mpirun -np $process ./mpi_filtro img/input3.png img/output3.png 8

echo " "
cat tmp.log
cat tmp.log >> cache.log
rm -f tmp.log
echo "#######################################" >> cache.log