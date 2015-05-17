
A = [10 20 30 40 50 60;
     10 20 30 40 50 60];
B = [100 200 300 400 500 600;
     100 200 300 400 500 600];
 
 
 correspondence = [3 4;
                   1 2];
               
 [ corrPts1,corrPts2,rest1,rest2 ] = spliceConcensus(A,B,correspondence)