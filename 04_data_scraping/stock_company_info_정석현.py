import os
import requests
import time
import pandas as pd
from bs4 import BeautifulSoup as bs
from datetime import datetime
from sqlalchemy import create_engine, text
import pymysql
pymysql.install_as_MySQLdb()

url = 'https://kind.krx.co.kr/corpgeneral/corpList.do?'
payload = dict(method='searchCorpList',pageIndex=1,currentPageSize=100,orderMode=3,orderStat='D',searchType=13,fiscalYearEnd='all',location='all')
r = requests.post(url, params=payload)
soup = bs(r.content, 'lxml')
time.sleep(2)

n_data = int(soup.select_one('.info.type-00 em').text.replace(',',''))
total_page = (n_data//100)+1

td_list = []
page = 1

for idx, page in enumerate(range(1, total_page+1)):

    print(f'{page}/{total_page} 작업중', end="\r")
    url = 'https://kind.krx.co.kr/corpgeneral/corpList.do?'
    payload = dict(method='searchCorpList',pageIndex=page,currentPageSize=100,orderMode=3,orderStat='D',searchType=13,fiscalYearEnd='all',location='all')
    r = requests.post(url, params=payload)
    time.sleep(0.2)
    soup = bs(r.content, 'lxml')
    
    tbody = soup.select('tbody')
    td_data = {'Market_classification':[], 'Company_Name': [], 'Stock_Code': [],
               'Type_of_Work': [], 'Main_Product': [], 'Listing_Date': [], 'Settlement_Month': [], 
               'CEO_Name': [], 'Company_URL': [], 'Region': []}

    for td in tbody:
    #     print(td)
        results = []
        for td in soup.select('td.first'):
            img_alts = [img['alt'] for img in td.select('img')]
            if len(img_alts) > 1:
                results.append(', '.join(img_alts))
            elif img_alts:
                results.append(img_alts[0])
            else:
                results.append('None')
            
        for result in results:
            td_data['Market_classification'].append(result)

        for title in soup.select('td:nth-child(1) a'):
            td_data['Company_Name'].append(title['title'])

        for onclick in soup.select('td.first a'):
            td_data['Stock_Code'].append(onclick['onclick'].split(';')[0][-7:-2])

        for Type in soup.select('td:nth-child(2)'):
            td_data['Type_of_Work'].append(Type.text)

        for product in soup.select('td:nth-child(3)'):
            td_data['Main_Product'].append(product.text)

        for date in soup.select('td:nth-child(4)'):
            td_data['Listing_Date'].append(date.text)

        for month in soup.select('td:nth-child(5)'):
            td_data['Settlement_Month'].append(month.text)

        for td in soup.select('td.txc'):
            if 'title' in td.attrs:
                td_data['CEO_Name'].append(td['title'])

        for td in soup.select('td:nth-child(7)'):
            a_tags = td.find('a')
            if a_tags:
                td_data['Company_URL'].append(a_tags['href']) 
            else:
                td_data['Company_URL'].append('None')

        for region in soup.select('td:nth-child(8)'):
            td_data['Region'].append(region.text)

#     for key, value in td_data.items():
#         print(f"{key} : {len(value)}")
    td_list.append(pd.DataFrame(td_data))
    time.sleep(2)

#컬럼명 지정
company_info_df = pd.concat(td_list,ignore_index=True)
columns = soup.select_one('table')['summary'].split(', ')
columns.insert(0,'증권종류')
columns.insert(2, '종목코드')
company_info_df.columns = columns

print(f"\n총 {len(company_info_df)}개 데이터 수집")
# display(company_info_df)

# mysql
engine = create_engine('mysql+pymysql://root:1234@127.0.0.1:3306/korean_stock')
conn = engine.connect()
company_info_df.to_sql("company_info", con=conn, if_exists='replace', index=False)
print(f"company_info 테이블이 MySQL Database의 korean_stock에 저장되었습니다.")
conn.close()

