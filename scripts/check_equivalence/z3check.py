#!/usr/bin/env python

from z3 import Or, And, Implies, ForAll
from z3 import Ints
from z3 import solve

import sys
import constraints

def david():
    i,x,n,pos = Ints('i x n pos')

    precond = And(x>=0, x<n, pos>=0, pos<n)

    error = Or(And(n>=pos+1, x<=pos-1, x>=0),
               And(x>=pos+1, n>=x+2, pos>=0),
               And(n==x+1, x>=pos+1, pos>=0))

    error_q = And(precond, ForAll(x, Implies(precond, error)))

    solve(error_q) # no solution

    final = Or(
        And(pos==x, i<=x-1, i>=0, n>=x+1),
        And(i==x, i>=0, n>=pos+1, i<=pos-1),
        And(x>=pos+1, i<=x-1, i>=0, n>=x+1, pos>=0),
        And(i==x, i<=n-1, i>=pos+1, pos>=0),
        And(i>=x+1, n>=pos+1, i<=n-1, x<=pos-1, x>=0),
        And(i<=x-1, i>=0, n>=pos+1, x<=pos-1),
        And(i==x, i==pos, i>=0, i<=n-1),
        And(x>=pos+1, i>=x+1, i<=n-1, pos>=0))

    final_q = And(precond, ForAll(x, Implies(precond, final)))
    
    solve(And(final,i>pos))
    solve(final_q)
    solve(And(i>pos, n>0, ForAll(x, Implies(And(0<=x, x<n), final))))
    solve(And(final_q, i>pos))
    return

def main( argv ):
    cons = constraints.getConstraints( argv[1] )
    print cons
    param = constraints.getParameters( argv[1] )
    print param
    return

if __name__ == "__main__":
    if len( sys.argv ) < 2:
        printUsage( sys.argv )
        exit( -1 )
    main( sys.argv )
        
