#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'equal' function below.
#
# The function is expected to return an INTEGER.
# The function accepts INTEGER_ARRAY arr as parameter.
#

def equal(arr):
    # Write your code here
    # use dynamic programming - come up with recursive solution first, then memoize
    # recursive:
    # so for example, you would need to do a for loop for each step?
    n = 5
    # j to skip

    # TODO isn't this step n^2?????
    # add everything in r except if it's the same index
    for i in range(len(arr)):
        # make a copy of the array
        arr1 = arr
        arr2 = arr
        arr5 = arr
        for j in range(len(arr)):
            if i != j:
                arr1[i] += 1
                arr2[i] += 2
                arr5[i] += 5
        # Check if the array fulfils the requirements
        b = True
        f = arr1[0]
        for i in arr1:
            if i != f:
                b = False
        
        
                
    

if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    t = int(input().strip())

    for t_itr in range(t):
        n = int(input().strip())

        arr = list(map(int, input().rstrip().split()))

        result = equal(arr)

        fptr.write(str(result) + '\n')

    fptr.close()
