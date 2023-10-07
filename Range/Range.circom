pragma circom 2.1.4;

// In this exercise , we will learn how to check the range of a private variable and prove that 
// it is within the range . 

// For example we can prove that a certain person's income is within the range
// Declare 3 input signals `a`, `lowerbound` and `upperbound`.
// If 'a' is within the range, output 1 , else output 0 using 'out'

template Num2Bits(n) {
    signal input in;
    signal output out[n];
    var lc1=0; 
    var e2=1;
    for (var i = 0; i<n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] -1 ) === 0;
        lc1 += out[i] * e2;
        e2 = e2+e2;
    }

    lc1 === in;
}

template LessThan(n) {
    assert(n <= 252);
    signal input in[2];
    signal output out;

    component n2b = Num2Bits(n+1);

    n2b.in <== in[0]+ (1<<n) - in[1];

    out <== 1-n2b.out[n];
}

template Range() {
    signal input a;
    signal input lowerbound;
    signal input upperbound;
    signal output out;

    // Looking at the test, the maximum number to compare is 20, so 5 bits is enough
    component greaterThanLowerBound = LessThan(5);
    greaterThanLowerBound.in[0] <== lowerbound;
    greaterThanLowerBound.in[1] <== a;

    component lowerThanUpperBound = LessThan(5);
    lowerThanUpperBound.in[0] <== a;
    lowerThanUpperBound.in[1] <== upperbound;

    out <== greaterThanLowerBound.out * lowerThanUpperBound.out;
}

component main  = Range();


