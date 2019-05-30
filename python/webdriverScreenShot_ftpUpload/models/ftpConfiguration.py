class FTPConfiguration(object):
    server = ""
    user = ""
    password = ""
    ftpFolder = ""

    def __init__(self, server, user, password, ftpFolder):
        self.server = server
        self.user = user
        self.password = password
        self.ftpFolder = ftpFolder
