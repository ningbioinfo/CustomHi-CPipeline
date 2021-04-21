# compute q-value using Benjamini-Hochberg correction
import sys
import pandas as pd
import numpy as np

def p_adjust_bh(p):
    """Benjamini-Hochberg p-value correction for multiple hypothesis testing."""
    p = np.asfarray(p)
    by_descend = p.argsort()[::-1]
    by_orig = by_descend.argsort()
    steps = float(len(p)) / np.arange(len(p), 0, -1)
    q = np.minimum(1, np.minimum.accumulate(steps * p[by_descend]))
    return q[by_orig]

infile = sys.argv[1]
outfile = sys.argv[2]

df = pd.read_csv(infile, delimiter='\t', header=0)

df2 = df
df2['neg_ln_q_val'] = -np.log(p_adjust_bh(np.exp(-df2['neg_ln_p_val'].values)))

df2.to_csv(outfile, sep = '\t', header=True, index=False)
