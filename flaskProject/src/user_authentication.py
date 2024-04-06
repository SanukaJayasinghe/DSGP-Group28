import sqlite3
import os

class UserAuthenticator:
    path = os.path.join("database","user_credentials.db")

    def __init__(self):
        print("User Authentication Class initialized")
        self.db_file = self.path

    def authenticate_user(self, username, password):
        try:
            with sqlite3.connect(self.db_file) as conn:
                cursor = conn.cursor()
                cursor.execute('''SELECT COUNT(*) FROM users WHERE username=? AND password=?''', (username, password))
                result = cursor.fetchone()[0]
                return result > 0

        except sqlite3.Error as e:
            print("SQLite error:", e)
            return False
        except OSError as e:
            print("OS error:", e)
            return False