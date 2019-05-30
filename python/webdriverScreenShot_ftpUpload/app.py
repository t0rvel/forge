# from selenium import webdriver
import src.script_MD as ss
import models.ftpConfiguration as fftp

###webDriver path
# d = webdriver.Chrome(executable_path='c:\chrome_webdriver\chromedriver.exe')
# d.get("http://www.google.com")
# d.maximize_window()


def screen_shot_ftp_feature(driver, close_driver):
    file_path = 'value'
    ftp_configuration = fftp.FTPConfiguration("value", "value", "value", "shared/automation/screenShots")

    fn = ss.generate_file_name()
    ss.screen_shot_feature(driver, fn, ftp_configuration, file_path)
    if close_driver:
        driver.close()


def clear_ftp_folder():
    ftp_configuration = fftp.FTPConfiguration("value", "value", "value", "shared/automation/screenShots")
    ss.clear_ftp_folder(ftp_configuration)
