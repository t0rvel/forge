import ftplib
import datetime
from pathlib import Path
import random
import models.ftpConfiguration as fft
import sys


def generate_file_name():
    rand = random.randint(1000010, 99999940)
    return datetime.datetime.now().strftime("%f") + str(rand) + '.png'


file_name = generate_file_name()


def path_with_file_name(file_path):
    return file_path + file_name


def save_screen_shot(driver, file_path):
    print("Getting the screen shot.....")
    return driver.save_screenshot(file_path + file_name)


def upload_to_ftp(fn, ftp_configuration, file_path):
    print("Connecting to the server... - " + ftp_configuration.server)
    fp = path_with_file_name(file_path)
    ftp = ftplib.FTP()
    host = ftp_configuration.server
    try:
        ftp.connect(host)
        print(ftp.getwelcome())
        print("Successfully connected.")
        print("Checking for credentials....")
    except:
        sys.exit("Unable to connect to: " + ftp_configuration.server + " -- Bad gateway or server doesn't exist.")

    print("Logging in to the FTP...")
    try:
        ftp.login(ftp_configuration.user, ftp_configuration.password)
        print("Successfully logged in.")
    except:
        sys.exit("Bad username or password.")
    try:
        ftp.cwd(ftp_configuration.ftpFolder)
        print("Folder to upload: " + ftp_configuration.ftpFolder)
    except:
        sys.exit("Folder doesn't exist.")

    try:
        file = open(fp, 'rb')
        ftp.storbinary(f'STOR {fn}', file)
        print("File Name generated ---- " + fn)
        print("File uploaded successfully")
    except:
        sys.exit("Unable to store file to the FTP. Please, check for permissions.")
    try:
        a = get_screenshot_url(fn)
        print("Published Image URL: " + a)
        file.close()
        ftp.quit()
        return a
        # SPACE RESERVED FOR META DATA FOR SENDING TO THE REST SERVICE (URL, FILENAME)
    except:
        ftp.quit()
        sys.exit("Failed to upload.")


def get_screenshot_url(fn):
    # http://www.tron.rs/andy/shared/automation/screenShots/ ---new one DEV env
    return 'http://www.tron.rs/andy/shared/automation/screenShots/' + fn


def screen_shot_feature(driver, fn, ftp_configuration, file_path):
    save_screen_shot(driver, file_path)
    return upload_to_ftp(fn, ftp_configuration, file_path)


def clear_ftp_folder(ftp_configuration):
    print("Connecting to the server... --" + ftp_configuration.server)
    ftp = ftplib.FTP()
    host = ftp_configuration.server
    try:
        ftp.connect(host)
        print("Successfully connected.")
        print(ftp.getwelcome())
        print("Checking for credentials....")
    except:
        sys.exit("Unable to connect to: " + ftp_configuration.server + " -- Bad gateway or server doesn't exist.")

    try:
        ftp.login(ftp_configuration.user, ftp_configuration.password)
        print("Successfully logged in.")
    except:
        sys.exit("Bad username or password.")
    try:
        ftp.cwd(ftp_configuration.ftpFolder)
        print("Removing all from '" + ftp_configuration.ftpFolder + "' folder....")
    except:
        sys.exit("FTP folder - '" + ftp_configuration.ftpFolder + "' - doesn't exist.")

    try:
        for s in ftp.nlst():
            ftp.delete(s)
        print("Done.")
    except:
        sys.exit("Removing failed. Please, check for permissions.")
