import mysql.connector


config = {'user': None, 'password': None, 'database': None, 'host': None, 'port': None}
config2 = {'user': 'root', 'password': 'harrypotter', 'database': 'eagles_db', 'host': 'localhost', 'port': 3306}


players_cache = []

class Credentials:
    def __init__(self, user = None, password = None, database = None, host = 'localhost', port = 3306):
        self.user = user
        self.password = password
        self.database = database
        self.host = host
        self.port = port
        self.config = {'user': self.user, 'password': self.password, 'database': self.database, 'host': self.host, 'port': self.port}

    def setCredentials(self, user, password, database, host='localhost', port=3306):
        self.user = user
        self.password = password
        self.database = database
        self.host = host
        self.port = port
        self.config = {'user': self.user, 'password': self.password, 'database': self.database, 'host': self.host, 'port': self.port}

    def getCredentials(self):
        return self.config

class DBConnection:
    def __init__(self, user, password, database, host='localhost', port=3306):
        self.user = user
        self.password = password
        self.database = database
        self.host = host
        self.port = port
        self.credentials = Credentials()
        self.db = None
        self.cursor = None

    def connect(self):
        self.db = mysql.connector.connect(user = self.user, password=self.password, database=self.database, host=self.host, port=self.port)
        self.cursor = self.db.cursor()
        print('Connected to DB')

    def commit(self):
        self.db.commit()
        print('Changes committed.')

class roster_DAL:

    #get Views
    def getPlayersView(cnx = DBConnection(**config2)):
        #get players view (NOT LIST)
        cnx.connect()
        cursor = cnx.cursor
        cursor.execute("SELECT `Player Name`, `Position`, `College and Location` FROM `All Players`;")
        rows = cursor.fetchall()
        cursor.close()
        return rows

    def getSalaryView(cnx = DBConnection(**config2)):
        #get player salary by position VIEW and the cap hit to the team (not the contract list)
        cnx.connect()
        cursor = cnx.cursor
        cursor.execute("SELECT `Position`, `Players Count`, `Avg Salary`, `Total cap hit` FROM `Salary by Position`;")
        rows = cursor.fetchall()
        cursor.close()
        return rows

    #get Lists
    def getCollegesList(cnx = DBConnection(**config2)):
        #get colleges list
        cnx.connect()
        cursor = cnx.cursor
        cursor.callproc("getCollegesList", [])
        rows = []
        for result in cursor.stored_results():
            rows.extend(result.fetchall())
        cursor.close()
        return rows

    def getPlayerList(cnx = DBConnection(**config2)):
        #get player list(NOT VIEW)
        cnx.connect()
        cursor = cnx.cursor
        cursor.callproc("getPlayerList", [])
        rows = []
        for result in cursor.stored_results():
            rows.extend(result.fetchall())
        cursor.close()
        return rows

    def getGamesList(cnx = DBConnection(**config2)):
        #get games list
        cnx.connect()
        cursor = cnx.cursor
        cursor.callproc("getGamesList", [])
        rows = []
        for result in cursor.stored_results():
            rows.extend(result.fetchall())
        cursor.close()
        return rows

    def getAppearancesList(cnx = DBConnection(**config2)):
        #get appearances for players in specific games by their game and player id's
        cnx.connect()
        cursor = cnx.cursor
        cursor.callproc("getAppearancesList", [])
        rows = []
        for result in cursor.stored_results():
            rows.extend(result.fetchall())
        cursor.close()
        return rows

    def getContractsList(cnx = DBConnection(**config2)):
        #get contracts list
        cnx.connect()
        cursor = cnx.cursor
        cursor.callproc("getContractsList", [])
        rows = []
        for result in cursor.stored_results():
            rows.extend(result.fetchall())
        cursor.close()
        return rows

    #mutations

    def addPlayer(first_name, last_name, position, cnx = DBConnection(**config2)):
        #calls the addplayer procedure
        cnx.connect()
        cursor = cnx.cursor
        try:
            cursor.callproc("addPlayer",[first_name, last_name, position])
            #drain results
            for _ in cursor.stored_results():
                pass
            cnx.commit()
        except Exception as e:
            cursor.close()
            return "There was an error", e
        else:
            cursor.close()
            return "Player added successfully"

    def updateStatus(first_name, last_name, cnx = DBConnection(**config2)):
        #calls update status procedure
        cnx.connect()
        cursor = cnx.cursor
        try:
            cursor.callproc("updateStatus", [first_name, last_name])
            updated = []
            for result in cursor.stored_results():
                updated.extend(result.fetchall())
            cnx.commit()
        except Exception as e:
            cursor.close()
            return "There was an error updating status", e
        else:
            cursor.close()
            return updated

    def deletePlayer(first_name, last_name, cnx = DBConnection(**config2)):
        #calls delete player procedure
        cnx.connect()
        cursor = cnx.cursor
        try:
            cursor.callproc("deletePlayer", [first_name, last_name])
            #drain results
            for _ in cursor.stored_results():
                pass
            cnx.commit()
        except Exception as e:
            cursor.close()
            return "There was an error deleting player", e
        else:
            cursor.close()
            return "Player deleted!"

    #advanced feature: export button for CVS file
    def getExport(dataset, cnx = DBConnection(**config2)):
        #calls the getexport procedure to produce the csv file

        cnx.connect()
        cursor = cnx.cursor
        cursor.callproc("getExport", [dataset])
        rows = [] #will hold all data rows returned
        cols = None #will hold column names (for CVS headers)
        for result in cursor.stored_results(): #iterate result sets returned by the proc
            rows = result.fetchall() #pull all rows from the result set into a list
            if hasattr(result, "column_names") and result.column_names: #if connector exposes names
                cols = list(result.column_names) #take column names directly
            else: #incase they dont take the column names
                cols = [d[0] for d in result.description] #take names form metadata
        cursor.close()
        return cols, rows #return headers + data for CSV in GUI


def main():
    mydb = DBConnection('root', 'harrypotter', 'eagles_db')
    mydb.connect()


if __name__ == '__main__':
    main()










