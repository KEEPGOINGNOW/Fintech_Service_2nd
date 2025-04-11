from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from datetime import datetime, timedelta
import time
import pandas as pd
from io import StringIO
from ex_dbio_test import to_exdb_today, new_col

options = Options()
options.add_experimental_option("detach", True)
options.add_argument('start_maximized')
options.add_argument('Chrome/134.0.0.0')
options.add_argument('lang=ko_KR')
# 웹브라우저가 백그라운드에서 작동하도록 설정
options.add_argument('--headless')
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')

driver = webdriver.Chrome(
    service=Service(ChromeDriverManager().install()),
    options=options
)

url = 'https://www.kebhana.com/cms/rate/index.do?contentUrl=/cms/rate/wpfxd651_01i.do'
driver.get(url)
wait = WebDriverWait(driver, 10)

# 오늘 날짜 확인
today = datetime.now()
print(f"{today.strftime('%Y-%m-%d')} 기준 환율 데이터 수집 시작", end='\r')

# 날짜 입력
#tmpInqStrDt
date_input = WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.CSS_SELECTOR, '#tmpInqStrDt')))
date_input.clear()
date_input.send_keys(today.strftime('%Y%m%d'))
date_input.send_keys(Keys.ENTER)

# 조회버튼 클릭
#HANA_CONTENTS_DIV > div.btnBoxCenter > a
search_button = driver.find_element(By.CSS_SELECTOR, '#HANA_CONTENTS_DIV > div.btnBoxCenter > a')
search_button.click()
time.sleep(2)

df = pd.read_html(StringIO(driver.find_element(By.CSS_SELECTOR, '.tblBasic.leftNone').get_attribute('outerHTML')))[0]
df['date'] = today.date()

new_columns = new_col(df)
df.columns = new_columns
required_columns = ['date', '통화', '현찰_사실_때_환율', '현찰_사실_때_Spread',
                '현찰_파실_때_환율', '현찰_파실_때_Spread', '송금_보낼_때_보낼_때',
                '송금_받을_때_받을_때', '외화_수표_파실때', '매매_기준율', '환가_료율',
                '미화_환산율']
df = df[required_columns]

to_exdb_today(df, today)
print(f"{today.date()} 기준 {len(df)}개의 환율 데이터프레임을 MySQL DB에 테이블로 저장하였습니다.", end='\r')
