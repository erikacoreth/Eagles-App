import CorethDAL as dal

#module-level singleton for the DAL instance
_roster = None

def _get_roster():
    global _roster
    if _roster is None:
        #DAL will read dal.config
        _roster = dal.roster_DAL()
    return _roster

def hello():
    print("Hello! Welcome to the 2024-2025 Philadelphia Eagles app!")

def setCredentials(user, password, database="eagles_db", host=None, port=None):
    """
      Update DAL config. Host/port can be None; DAL will default to localhost:3306.
      Rebuild the DAL instance so new creds take effect.
      """
    print('Setting',database,'credentials for', user)
    dal.config = {'user': user, 'password': password, 'database': database, 'host': host, 'port': port}
    global _roster
    _roster = dal.roster_DAL()

# views
def getPlayersView():
    return _get_roster().getPlayersView()

def getSalaryView():
    return _get_roster().getSalaryView()

#lists

def getCollegesList():
    return _get_roster().getCollegesList()

def getPlayerList():
    return _get_roster().getPlayerList()

def getGamesList():
    return _get_roster().getGamesList()

def getAppearancesList():
    return _get_roster().getAppearancesList()

def getContractsList():
    return _get_roster().getContractsList()

#mutations

def addPlayer(first_name, last_name, position):
    return _get_roster().addPlayer(first_name, last_name, position)

def updateStatus(first_name, last_name):
    return _get_roster().updateStatus(first_name, last_name)

def deletePlayer(first_name, last_name):
    return _get_roster().deletePlayer(first_name, last_name)


#advanced feature

def getExport(dataset):
    return _get_roster().getExport(dataset)

def main():
    hello()
    #call host/port as None; DAL will default them.
    setCredentials('root','harrypotter','eagles_db', host=None, port=None)
    #test
    #print(getPlayersView())



if __name__ == '__main__':
    main()






