class FTPConfiguration(object):
    def __init__(self, server, user, password, ftpFolder, securityType):
        self.server = server
        self.user = user
        self.password = password
        self.ftpFolder = ftpFolder
        self.securityType = securityType
