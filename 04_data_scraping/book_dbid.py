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


def book_page(keyword):
    options = Options()
    options.add_experimental_option("detach", True)
    options.add_argument("start-maximized")
    options.add_argument("Chrome/135.0.0.0")
    options.add_argument("lang=ko_KR")

    driver = webdriver.Chrome(
        service=Service(ChromeDriverManager().install()),
        options=options
        )
    url = "https://search.shopping.naver.com/book/home"
    driver.get(url)
    wait = WebDriverWait(driver, 10)
    search_text_box = wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, "._searchInput_search_text_83jy9._searchInput_placeholder_AG5yA._nlog_click")))
    search_text_box.send_keys(f"{keyword}")
    search_text_box.send_keys(Keys.ENTER)
    return driver 

def scroll_page(driver):
    for scroll in range(0, 8001, 1000):
            driver.execute_script(f"window.scrollTo({0}, {scroll})")
            time.sleep(2)
    return


def book_info_collect(driver):
    book_list = driver.find_elements(By.CSS_SELECTOR, ".bookListItem_item_book__RbpgP")
    data = []
    
    for book in book_list:
        title = book.find_element(By.CSS_SELECTOR, ".bookListItem_title__1mWGq").text
        detail_link = book.find_element(By.CSS_SELECTOR, ".bookListItem_item_inner__edK7P > a").get_attribute("href")
        author = book.find_element(By.CSS_SELECTOR, ".bookListItem_define_item__jqcW8 > .bookListItem_define_data__fu2A5").text
        publisher = book.find_element(By.CSS_SELECTOR, ".bookListItem_publish__6XykH .bookListItem_define_data__fu2A5").text
        pub_date = book.find_element(By.CSS_SELECTOR, ".bookListItem_detail_date__6_wYJ").text
        
        try:
            grade = float(book.find_element(By.CSS_SELECTOR, ".bookListItem_grade__e60mi").text[2:5])
        except Exception:
            grade = 0.0
        
        try:
            price = int(book.find_element(By.CSS_SELECTOR, ".bookPrice_price__Nv4Ee > em").text.replace(",", ""))
        except Exception:
            price = 0
        
        data.append([title, detail_link, author, publisher, pub_date, grade, price])
    
    columns = ("title", "detail_link", "author", "publisher", "pub_date", "grade", "price")
    return pd.DataFrame(data, columns=columns)

def save_csv(result):
    result.to_csv("./scraping_results/네이버책_selenium.csv", mode="w", header=True, index=False, encoding="utf-8-sig")
    return

def dbconnect():
    engine = create_engine('mysql+pymysql://root:1234@localhost:3306/naver_book')
    conn = engine.connect()
    return conn

def save_MySQL_table(keyword, result):
    """
    keyword와 df를 입력받아 네이버 도서에서 검색하고 5페이지 결과를
    {검색어 명}_book_info 테이블을 MySQL에 저장 
    """
    conn = dbconnect()
    result.to_sql(f'{keyword}_book_info', con=conn, if_exists='append', index=False)
    conn.close()
    print(f'{keyword}_book_info 테이블이 MySQL DB에 저장되었습니다.')
    return

def pagenavigator(driver, num):
    paginator = driver.find_element(By.CSS_SELECTOR, ".Paginator_list_paging__XbuO8")
    paginator.find_element(By.LINK_TEXT, f"{num+1}").click()
