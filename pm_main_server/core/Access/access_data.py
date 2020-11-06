import xml.etree.ElementTree as ET
tree = ET.parse('.//core//Access//access.xml')
access = tree.getroot()


def access_db():
    user_val = access[0][1].text
    password_val = access[0][2].text
    database_val = access[0][0].text
    access_db = user_val, password_val, database_val
    return access_db

def access_ad():
    login_ad = access[1][1].text
    password_ad = access[1][2].text
    server_ad = access[1][0].text
    access_ad = login_ad, password_ad, server_ad
    return access_ad

def install_path():
    drive_letter = access[2][0].text
    path_to_setup = access[2][1].text
    install_path = drive_letter, path_to_setup
    return install_path