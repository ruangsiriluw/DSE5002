#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Nov 20 20:59:04 2023

@author: wanida
"""

from statsmodels.datasets.interest_inflation.data import load_pandas

import numpy as np

df = load_pandas().data
df.head()



import scipy as sp
import numpy as np

np.mean(df['Dp'])
sp.mean(df['Dp'])


np.var(df['Dp'])
sp.var(df['Dp'])


import statsmodels.api as sm
import numpy as np
import pandas as pd

y = df['Dp'] 
x = sm.add_constant(df['R'])

res1 = sm.OLS(y, x).fit()
res1_coefs = res1.params

res1.summary()

res2 = sm.QuantReg(y, x).fit(q = 0.5)
res2_coefs = res2.params
res2.summary()

type(res1_coefs)
type(res2_coefs)

res1_coefs > res2_coefs


ols_coefs = res1_coefs
qreg_coefs = res2_coefs

ols_coefs.tolist() > qreg_coefs.tolist()

