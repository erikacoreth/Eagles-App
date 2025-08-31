import CorethDAL as dal

def hello():
    print("Hello! Welcome to the 2024-2025 Philadelphia Eagles app!")

def setCredentials(user, password, database="eagles_db", host="localhost", port=3306):
    print('Setting',database,'credentials for', user)
    dal.config = {'user': user, 'password': password, 'database': database, 'host': host, 'port': port}

# views
def getPlayersView():
    return dal.roster_DAL.getPlayersView()

def getSalaryView():
    return dal.roster_DAL.getSalaryView()

#lists

def getCollegesList():
    return dal.roster_DAL.getCollegesList()

def getPlayerList():
    return dal.roster_DAL.getPlayerList()

def getGamesList():
    return dal.roster_DAL.getGamesList()

def getAppearancesList():
    return dal.roster_DAL.getAppearancesList()

def getContractsList():
    return dal.roster_DAL.getContractsList()

#mutations

def addPlayer(first_name, last_name, position):
    return dal.roster_DAL.addPlayer(first_name, last_name, position)

def updateStatus(first_name, last_name):
    return dal.roster_DAL.updateStatus(first_name, last_name)

def deletePlayer(first_name, last_name):
    return dal.roster_DAL.deletePlayer(first_name, last_name)


#advanced feature

def getExport(dataset):
    return dal.roster_DAL.getExport(dataset)

def main():
    hello()
    setCredentials('root','harrypotter','eagles_db')



if __name__ == '__main__':
    main()






