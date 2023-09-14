# #!/usr/bin/env python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.common.by import By
import datetime

# Start the browser and perform the test
def start ():
    print (timestamp() + 'Open chrome')
    # --uncomment when running in Azure DevOps.
    options = ChromeOptions()
    
    options.add_argument("--headless")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--no-sandbox")
    options.add_argument("--remote-debugging-port=9222")

    driver = webdriver.Chrome(options=options)
    # driver = webdriver.Chrome()

    # Login
    login(driver, 'standard_user', 'secret_sauce')

    # Add cart
    add_cart(driver)

    # Remove cart
    remove_cart(driver)

# Login method
def login (driver, user, password):
    print (timestamp() + 'Browser started successfully. Navigating to the demo page to login.')
    driver.get('https://www.saucedemo.com/')

    print (timestamp() + 'Enter username standard_user')
    driver.find_element(By.CSS_SELECTOR, "input[id = 'user-name']").send_keys(user)

    print (timestamp() + 'Enter password secret_sauce')
    driver.find_element(By.CSS_SELECTOR, "input[id = 'password']").send_keys(password)

    print (timestamp() + 'Click login button')
    driver.find_element(By.CSS_SELECTOR, "input[id = 'login-button']").click()

    logoElements = driver.find_elements(By.CSS_SELECTOR, ".app_logo")
    assert len(logoElements) > 0, "Element not found"

    print (timestamp() + 'Login success')

# Add cart
def add_cart(driver):
    print (timestamp() + 'Add 6 product')
    productElements = driver.find_elements(By.CSS_SELECTOR, ".inventory_item")

    for product in productElements:
        productButton = product.find_element(By.CSS_SELECTOR, ".btn_inventory")
        productName = product.find_element(By.CSS_SELECTOR, ".inventory_item_name")

        print(timestamp() + f"Product {productName.text} was added to cart")
        productButton.click()

    cartCount = int(driver.find_element(By.CSS_SELECTOR, ".shopping_cart_badge").text)
    assert cartCount == len(productElements), 'The cart count does not correct'

    print(timestamp() + 'Cart count = ' + str(cartCount))

# Remove all product
def remove_cart(driver):
    print (timestamp() + 'Cart page')
    driver.find_element(By.CSS_SELECTOR, ".shopping_cart_link").click()

    print (timestamp() + 'Remove all product')
    removeButtons = driver.find_elements(By.CSS_SELECTOR, ".cart_button")
    for remove in removeButtons:
        remove.click()

    cartCountElement = driver.find_elements(By.CSS_SELECTOR, ".shopping_cart_badge")
    assert len(cartCountElement) == 0, "Remove failed"

    print(timestamp() + 'Remove success or not')

def timestamp():
    ts = datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%SZ")
    return (ts + ' ')

start()