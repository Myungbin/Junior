# -*- coding: utf-8 -*-
"""
Created on Mon Feb  1 13:33:08 2021

@author: wbspf
"""

import requests
import pandas as pd


grandmaster = 'http://ddragon.leagueoflegends.com/cdn/11.2.1/data/ko_KR/item.json'
r = requests.get(grandmaster)#그마데이터 호출

r= r.json()['data']


item_df = pd.DataFrame(r)
a=item_df[0:1]

    
a.to_csv('아이템.csv',index=False,encoding = 'cp949')

