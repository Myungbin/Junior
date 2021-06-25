# -*- coding: utf-8 -*-
"""
Created on Thu Feb  4 10:23:36 2021

@author: wbspf
"""



import requests
import pandas as pd
import time


api_key = 'RGAPI-ac0f4fe8-87c6-42e8-8465-33951daa26cf'


sohwan = "https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-name/" +'미드 아트록스' +'?api_key=' + api_key
r = requests.get(sohwan)
sohwan1 = "https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-name/" +'아트는못말려' +'?api_key=' + api_key
r1 = requests.get(sohwan1)
sohwan2 = "https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-name/" +'솔로랭크이외트롤' +'?api_key=' + api_key
r2 = requests.get(sohwan2)
sohwan3 = "https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-name/" +'철괴로단단해지기' +'?api_key=' + api_key
r3 = requests.get(sohwan3)
sohwan4 = "https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-name/" +'조금 일찍 뜬 달' +'?api_key=' + api_key
r4 = requests.get(sohwan4)

season = str(13)
atrox= str(266)
atrox1 = [266]


match_info_df = pd.DataFrame()
accountid = pd.DataFrame()
accountid = [r.json()['accountId'],r1.json()['accountId'],r2.json()['accountId'],r3.json()['accountId'],r4.json()['accountId']]


for i in range(len(accountid)):
    match3 = 'https://kr.api.riotgames.com/lol/match/v4/matchlists/by-account/'+accountid[i] +'?champion='+atrox + '&season='+season + '&api_key=' + api_key
    r3 = requests.get(match3)
    a = r3.json()
    a1 = list(a['matches'])
    match_info_df = match_info_df.append(a1)

op_df_atrox = pd.DataFrame()
for i in range(len(match_info_df)):
    api_url='https://kr.api.riotgames.com/lol/match/v4/matches/' + str(match_info_df['gameId'].iloc[i]) + '?api_key=' + api_key
    r4 = requests.get(api_url)
    if r4.status_code == 200:
        final = list(r4.json()['participants'])
    elif r4.status_code == 429:
        print('과부화가 걸렸어요')
        print('loop location : ',i)
        start_time = time.time()

        while True: # 429error가 끝날 때까지 무한 루프
            if r4.status_code == 429:

                print('4초만 기다리세요')
                time.sleep(4)

                r4 = requests.get(api_url)
                print(r4.status_code)

            elif r4.status_code == 200: # 200나옴 원상복귀
                print('소요시간(단위: 초) : ', time.time() - start_time)
                print('회복했어요 다시 시작할게요')
                break

    elif r4.status_code == 503: # 잠시 서비스를 이용하지 못하는 에러
        print('우리의 잘못이 아니에요')

        while True:
            if r4.status_code == 503 or r4.status_code == 429:

                print('4초만 기다리세요')
                time.sleep(4)

                r4 = requests.get(api_url)
                print(r4.status_code)

            elif r4.status_code == 200:
                final = list(r4.json()['participants']) # 200나왔으니 다시 시작
                break
    elif r.status_code == 403: # api갱신
        print('api 갱신하세요')
        break
    league_df = pd.DataFrame(final)
    league_stats_df = pd.DataFrame(dict(league_df['stats'])).T #dict구조로 되어 있는 stats컬럼 풀어주기
    league_df = pd.concat([league_df, league_stats_df], axis=1) #열끼리 결합
    league_df = league_df.drop(['spell1Id','spell2Id', 'stats', 'timeline', 'participantId'] , axis=1)


    team1 = (league_df['championId'][0]==atrox1) 
    team2 = (league_df['championId'][1]==atrox1) 
    team3 = (league_df['championId'][2]==atrox1) 
    team4 = (league_df['championId'][3]==atrox1) 
    team5 = (league_df['championId'][4]==atrox1) 
    teamsel = bool((team1 | team2 | team3 | team4 | team5))
    team = (teamsel==True)

    
    
    if teamsel == True :
        op_df = league_df[5:10]
        op_df_atrox = op_df_atrox.append(op_df)
    else:
        op_df = league_df[0:5]
        op_df_atrox =op_df_atrox.append(op_df)
        
op_df_atrox.to_excel("match.xlsx")