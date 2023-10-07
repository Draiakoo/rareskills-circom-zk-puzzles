pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/comparators.circom";


/*
    Given a 4x4 sudoku board with array signal input "question" and "solution", check if the solution is correct.

    "question" is a 16 length array. Example: [0,4,0,0,0,0,1,0,0,0,0,3,2,0,0,0] == [0, 4, 0, 0]
                                                                                   [0, 0, 1, 0]
                                                                                   [0, 0, 0, 3]
                                                                                   [2, 0, 0, 0]

    "solution" is a 16 length array. Example: [1,4,3,2,3,2,1,4,4,1,2,3,2,3,4,1] == [1, 4, 3, 2]
                                                                                   [3, 2, 1, 4]
                                                                                   [4, 1, 2, 3]
                                                                                   [2, 3, 4, 1]

    "out" is the signal output of the circuit. "out" is 1 if the solution is correct, otherwise 0.                                                                               
*/

template Multiplier2(){
   signal input in1;
   signal input in2;
   signal output out;

   out <== in1 * in2;
}

template MultiplierN (N){
   signal input in[N];
   signal output out;
   component comp[N-1];

   for(var i = 0; i < N-1; i++){
       comp[i] = Multiplier2();
   }
   comp[0].in1 <== in[0];
   comp[0].in2 <== in[1];
   for(var i = 0; i < N-2; i++){
       comp[i+1].in1 <== comp[i].out;
       comp[i+1].in2 <== in[i+2];

   }
   out <== comp[N-2].out; 
}

template Sudoku () {
    // Question Setup 
    signal input question[16];
    signal input solution[16];
    signal output out;
    
    // Checking if the question is valid
    for(var v = 0; v < 16; v++){
        log(solution[v],question[v]);
        assert(question[v] == solution[v] || question[v] == 0);
    }
    
    var m = 0 ;
    component row1[4];
    for(var q = 0; q < 4; q++){
        row1[m] = IsEqual();
        row1[m].in[0]  <== question[q];
        row1[m].in[1] <== 0;
        m++;
    }
    3 === row1[3].out + row1[2].out + row1[1].out + row1[0].out;

    m = 0;
    component row2[4];
    for(var q = 4; q < 8; q++){
        row2[m] = IsEqual();
        row2[m].in[0]  <== question[q];
        row2[m].in[1] <== 0;
        m++;
    }
    3 === row2[3].out + row2[2].out + row2[1].out + row2[0].out; 

    m = 0;
    component row3[4];
    for(var q = 8; q < 12; q++){
        row3[m] = IsEqual();
        row3[m].in[0]  <== question[q];
        row3[m].in[1] <== 0;
        m++;
    }
    3 === row3[3].out + row3[2].out + row3[1].out + row3[0].out; 

    m = 0;
    component row4[4];
    for(var q = 12; q < 16; q++){
        row4[m] = IsEqual();
        row4[m].in[0]  <== question[q];
        row4[m].in[1] <== 0;
        m++;
    }
    3 === row4[3].out + row4[2].out + row4[1].out + row4[0].out; 

    // Write your solution from here.. Good Luck!

    component iseq[8];
    component multiplication[8];
    for(var n; n<8; n++){
        iseq[n] = IsEqual();
        multiplication[n] = MultiplierN(4);
    }
    var i;
    for(var n; i<4; i++){
        multiplication[i].in[0] <== solution[n];
        multiplication[i].in[1] <== solution[n+1];
        multiplication[i].in[2] <== solution[n+2];
        multiplication[i].in[3] <== solution[n+3];
        iseq[i].in[0] <== multiplication[i].out;
        iseq[i].in[1] <== 24;
        n += 4;
    }

    for(var n; i<8; i++){
        multiplication[i].in[0] <== solution[n];
        multiplication[i].in[1] <== solution[n+4];
        multiplication[i].in[2] <== solution[n+8];
        multiplication[i].in[3] <== solution[n+12];
        iseq[i].in[0] <== multiplication[i].out;
        iseq[i].in[1] <== 24;
        n++;
    }

    component finalMultiplication = MultiplierN(8);
    for(var i; i<8; i++){
        finalMultiplication.in[i] <== iseq[i].out;
    }

    out <== finalMultiplication.out;
}


component main = Sudoku();

