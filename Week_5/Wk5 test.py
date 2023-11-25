#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 22 19:38:15 2023

@author: wanida
"""

from statsmodels.datasets.fertility.data import load_pandas
import numpy as np

df = load_pandas().data
df.columns
np.round(np.mean(df['1963']),2)

