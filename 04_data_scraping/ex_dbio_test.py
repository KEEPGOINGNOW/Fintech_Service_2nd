from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from sqlalchemy import create_engine
import pymysql
pymysql.install_as_MySQLdb()
import pandas as pd
from datetime import datetime
import requests
from bs4 import BeautifulSoup as bs
import time

def new_col(df):
    new_cols = []
    for col in df.columns:
        if col[0] == col[1] == col[2]:
            new_cols.append(col[0].replace(" ", "_"))
        else:
            new_cols.append(" ".join(col).strip().replace(" ", "_"))
    return new_cols

def dbconnect():
    engine = create_engine('mysql+pymysql://root:1234@localhost:3306/exchange_db')
    conn = engine.connect()
    return conn

def to_exdb_today(df, today):
    conn = dbconnect()
    time.sleep(1)
    df.to_sql(f'exchange_rate_{today.month}_{today.day}', con=conn, if_exists='append', index=False)
    conn.close()
    return
