import os
from pathlib import Path



def get_folder_path():
    path = input("""Enter the path and name of your notes folder. 
Just push Enter if you want to use your home folder with "notes" as its name:
EX) /home/user/notes 
""")
    if path == "":
        path = str(Path.home()) + "/notes"

    if os.path.exists(path) and os.path.isdir(path):
        print(f"The folder {path} already exists")
        exit()
    return path

def get_github_account():
    account = input()
    return account

def update_bashrc():
    pass

def update_vimrc():
    pass

def create_notes_folder():
    pass


def main():
    path = get_folder_path()
    account = get_github_account()
    print(path)
    print(account)

    update_bashrc()
    update_vimrc()

    create_notes_folder()
    

if __name__ == "__main__":
    main()
