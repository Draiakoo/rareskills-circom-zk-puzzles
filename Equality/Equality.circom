pragma circom 2.1.4;

// Input 3 values using 'a'(array of length 3) and check if they all are equal.
// Return using signal 'c'.

template isZero() {
   signal input in;
   signal output out;

   signal inv;

   inv <-- in!=0 ? 1/in : 0;

   out <== -in*inv + 1;
   out * in === 0;
}

template Equality() {
   signal input a[3];
   signal output c;

   component isz1 = isZero();
   component isz2 = isZero();

   isz1.in <== a[1] - a[0];
   isz2.in <== a[2] - a[1];
   
   c <== isz1.out * isz2.out;
}

component main = Equality();