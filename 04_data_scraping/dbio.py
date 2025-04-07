from sqlalchemy import create_engine
import pymysql
pymysql.install_as_MySQLdb()
import pandas as pd
from datetime import datetime
import requests
from bs4 import BeautifulSoup as bs
import time


def year_month():
    from datetime import datetime
    today = datetime.today()
    return today.year, today.month

def dbconnect():
    engine = create_engine('mysql+pymysql://root:1234@localhost:3306/stock_info')
    conn = engine.connect()
    return conn

def stock_codes():
    """
    MySQL에 접속하여 상장 정보를 가져와 데이터프레임으로 반환해주는 함수
    상장 회사의 종목 코드 6자리를 반환
    """
    conn = dbconnect()
    data = pd.read_sql('stock_company_info_2025_04_04', con=conn)
    conn.close()
    stock_code = data['종목 코드'].apply(lambda x: x+'0')
    return stock_code

def to_stock_db(idx, stock_code, stock_name, df):
    """
    idx, stock_code, stock_name, df를 입력받아
    stock_price_{year}_{month:02d} 형식의 테이블을 mysql DB에 저장
    """
    # DataBase 쿼리창 오픈
    year, month = year_month()
    # DataBase 쿼리창 오픈
    conn=dbconnect()
    df.to_sql(f'stock_price_{year}_{month:02d}', con=conn, if_exists='append', index=False)
    conn.close()
    print(f"{idx+1}/{len(stock_code)} 수집 중, {stock_name} DB에 저장되었습니다.", end='\r')
    return

def stock_info_get(code):
    url = f'https://finance.naver.com/item/main.naver?code={code}'
    r = requests.get(url)
    soup = bs(r.content, 'lxml')

    # 종목명
    stock_name = soup.select_one('dl.blind > dd:nth-child(3)').text[4:]

    # 현재가
    today_price = int(soup.select_one('dl.blind > dd:nth-child(5)').text.split()[1].replace(',',''))

    # 변동금액
    change = soup.select_one('dl.blind > dd:nth-child(5)').text.split(" ")[3:5]
    change = -int(change[1].replace(',','').replace('\n','')) if change[0] == '하락' else int(change[1].replace(',','').replace('\n',''))

    # 변동률
    percent = ''.join(soup.select_one('dl.blind > dd:nth-child(5)').text.split(" ")[16:30])
    percent = percent.replace('마이너스','-').replace('퍼센트','%').replace('\n','') if percent[:4] == '마이너스' else percent.replace('플러스','').replace('퍼센트','%').replace('\n','')

    # 전일가
    yesterday_price = int(soup.select_one('dl.blind > dd:nth-child(6)').text[4:].replace(',',''))

    #  고가
    high = int(soup.select_one('dl.blind > dd:nth-child(8)').text[4:].replace(',',''))

    # 상한가
    top = int(soup.select_one('dl.blind > dd:nth-child(9)').text[4:].replace(',',''))

    # 저가
    low = int(soup.select_one('dl.blind > dd:nth-child(10)').text[4:].replace(',',''))

    # 하한가
    bottom = int(soup.select_one('dl.blind > dd:nth-child(11)').text[4:].replace(',',''))

    # 거래량
    volume = int(soup.select_one('dl.blind > dd:nth-child(12)').text[4:].replace(',',''))

    result = (code, stock_name, today_price, change, percent, yesterday_price, high, top, low, bottom, volume)
    columns = ['종목코드','종목명','현재가', '변동금액', '변동률',  '전일가', '고가', '상한가', '저가', '하한가', '거래량']
    df = pd.DataFrame([result], columns=columns)

    time.sleep(5)
    
    return df, stock_name
