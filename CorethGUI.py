import PySimpleGUI as sg
import CorethBLL as bll
import csv

def format_rows(rows):
    return [list(map(str, r)) for r in (rows or [])]
#ensures row is never None, turns each row into a list, and converted every cell to string

#helper function for csv export:
def _save_csv(cols, rows, filename):
    path = sg.popup_get_file(
        'Save CSV As…',
        save_as=True,
        default_extension='.csv',
        file_types=(('CSV Files', '*.csv'),),
        no_window=True,
        default_path=filename
    )
# https://docs.pysimplegui.com/en/latest/call_reference/tkinter/popups/popup_get_file/
    # I used this site for insight on how to write the popup window to save a file

    if not path:
        return # user canceled

    try:
        with open(path, 'w', newline='', encoding='utf-8') as f:
            w = csv.writer(f)
            if cols:
                w.writerow(cols) #write header row from SQL
            w.writerows(rows) #write data rows
        sg.popup_ok("Exported")
    except Exception as e:
        sg.popup_error('Export failed')
# https://docs.python.org/3/library/csv.html
# I used this site for insight on how to write the function that will export my CSV file


# --- Controls row (login + action buttons) ---
top_row = [
    [sg.Text("Welcome to the Eagles App...GO BIRDS", font=('Any', 16))],
    [sg.Text('User:'), sg.InputText('root', key='-USER-', size=(18,1)),
     sg.Text('Password:'), sg.InputText('', key='-PASS-', password_char='•', size=(18,1)),
     sg.Text('Database:'), sg.InputText('eagles_db', key='-DB-', size=(14,1)),
     sg.Button('Login'), sg.Button('Exit')],
    [sg.HorizontalSeparator()],
    [sg.Button('All Players'), sg.Button('Salary by Position'),
     sg.Button('Colleges'), sg.Button('Players (List)'),
     sg.Button('Games'), sg.Button('Appearances'),
     sg.Button('Contracts'), sg.Button('Add Player'),
     sg.Button('Update Status'), sg.Button('Delete Player'),
     sg.Button('Export CSV')],
]

# --- The stack of frames (each with its own fixed table) ---
tables_stack = [
    [sg.Frame('Players View', [[
        sg.Table(values=[], headings=['Player Name','Position','College and Location'],
                 key='-PLAYERS-', justification='left', auto_size_columns=True,
                 expand_x=True, expand_y=True, num_rows=8)
    ]], expand_x=True)],

    [sg.Frame('Salary by Position', [[
        sg.Table(values=[], headings=['Position','Players Count','Avg Salary','Total Cap Hit'],
                 key='-SALARY-', justification='left', auto_size_columns=True,
                 expand_x=True, expand_y=True, num_rows=8)
    ]], expand_x=True)],

    [sg.Frame('Colleges', [[
        sg.Table(values=[], headings=['college_id','college_name','state'],
                 key='-COLLEGES-', justification='left', auto_size_columns=True,
                 expand_x=True, expand_y=True, num_rows=8)
    ]], expand_x=True)],

    [sg.Frame('Players (List)', [[
        sg.Table(values=[], headings=['player_id','first_name','last_name','player_position','college_id','isplayer_active'],
                 key='-PLAYERSLIST-', justification='left', auto_size_columns=True,
                 expand_x=True, expand_y=True, num_rows=8)
    ]], expand_x=True)],

    [sg.Frame('Games', [[
        sg.Table(values=[], headings=['game_id','opponent','location','kickoff','result'],
                 key='-GAMES-', justification='left', auto_size_columns=True,
                 expand_x=True, expand_y=True, num_rows=8)
    ]], expand_x=True)],

    [sg.Frame('Appearances', [[
        sg.Table(values=[], headings=['game_id','player_id'],
                 key='-APPEARANCES-', justification='left', auto_size_columns=True,
                 expand_x=True, expand_y=True, num_rows=8)
    ]], expand_x=True)],

    [sg.Frame('Contracts', [[
        sg.Table(values=[], headings=['contract_id','player_id','start_date','end_date','salary','cap_hit'],
                 key='-CONTRACTS-', justification='left', auto_size_columns=True,
                 expand_x=True, expand_y=True, num_rows=8)
    ]], expand_x=True)],
]

# --- Scrollable column that contains the whole stack of tables ---
tables_column = sg.Column(
    tables_stack,
    scrollable=True,
    vertical_scroll_only=True,
    size=(900, 480),
    expand_x=True,
    expand_y=True,
    pad=(0, 0)
)

# final layout: top controls + tables + status bar
layout = [
    *top_row,
    [tables_column],
    [sg.StatusBar('', size=(80,1), key='-STATUS-', relief=sg.RELIEF_SUNKEN , expand_x=True)]
    #relief sunken gives the bottom bar that status bar look
]

window = sg.Window("Eagles DB APP", layout, resizable=True, finalize=True)

# --- Event loop ---
while True:
    event, values = window.read()
    if event in (sg.WINDOW_CLOSED, 'Exit'):
        break

    if event == 'Login':
        bll.setCredentials(values['-USER-'], values['-PASS-'], values['-DB-'])
        window['-STATUS-'].update(f"Connected to {values['-DB-']} ✔")

    elif event == 'All Players':
        rows = bll.getPlayersView()
        window['-PLAYERS-'].update(format_rows(rows))
        window['-STATUS-'].update(f"Loaded {len(rows)} players")

    elif event == 'Salary by Position':
        rows = bll.getSalaryView()
        window['-SALARY-'].update(format_rows(rows))
        window['-STATUS-'].update(f"Loaded {len(rows)} rows")

    elif event == 'Colleges':
        rows = bll.getCollegesList()
        window['-COLLEGES-'].update(format_rows(rows))
        window['-STATUS-'].update(f"Loaded {len(rows)} colleges")

    elif event == 'Players (List)':
        rows = bll.getPlayerList()
        window['-PLAYERSLIST-'].update(format_rows(rows))
        window['-STATUS-'].update(f"Loaded {len(rows)} players")

    elif event == 'Games':
        rows = bll.getGamesList()
        window['-GAMES-'].update(format_rows(rows))
        window['-STATUS-'].update(f"Loaded {len(rows)} games")

    elif event == 'Appearances':
        rows = bll.getAppearancesList()
        window['-APPEARANCES-'].update(format_rows(rows))
        window['-STATUS-'].update(f"Loaded {len(rows)} appearances")

    elif event == 'Contracts':
        rows = bll.getContractsList()
        window['-CONTRACTS-'].update(format_rows(rows))
        window['-STATUS-'].update(f"Loaded {len(rows)} contracts")

    #add player popup
    elif event == 'Add Player':
        popup_layout = [
            [sg.Text('First Name'), sg.Input(key='-FIRST-', size=(30,1))],
            [sg.Text('Last Name'), sg.Input(key='-LAST-', size=(30,1))],
            [sg.Text('Position'), sg.Input(key='-POS-', size=(30,1))],
            [sg.Button('Submit'), sg.Button('Cancel')]
        ]
        popup = sg.Window('Add Player', popup_layout, modal=True)

        while True:
            ev, vals = popup.read()
            if ev in (sg.WIN_CLOSED, 'Cancel'):
                break
            elif ev == 'Submit':
                first = vals['-FIRST-']
                last = vals['-LAST-']
                pos = vals['-POS-']

                result = bll.addPlayer(first, last, pos)

                sg.popup("Player Added! Refresh list!")
                break
        popup.close()

    #delete player popup
    elif event == 'Delete Player':
        popup_layout = [
            [sg.Text('First name'), sg.Input(key='-FIRST-', size=(30,1))],
            [sg.Text('Last Name'), sg.Input(key='-LAST-', size=(30,1))],
            [sg.Button('Submit'), sg.Button('Cancel')]
        ]
        popup = sg.Window('Delete Player', popup_layout, modal=True)

        while True:
            ev, vals = popup.read()
            if ev in (sg.WIN_CLOSED, 'Cancel'):
                break
            elif ev == 'Submit':
                first = vals['-FIRST-']
                last = vals['-LAST-']

                result = bll.deletePlayer(first, last)

                sg.popup("Player deleted! Refresh List")
                break
        popup.close()

    #update status popup
    elif event == 'Update Status':
        popup_layout = [
            [sg.Text('First name'), sg.Input(key='-FIRST-', size=(30,1))],
            [sg.Text('Last Name'), sg.Input(key='-LAST-', size=(30,1))],
            [sg.Button('Submit'), sg.Button('Cancel')]
        ]
        popup = sg.Window('Update Status', popup_layout, modal=True)
        while True:
            ev, vals = popup.read()
            if ev in (sg.WIN_CLOSED, 'Cancel'):
                break
            elif ev == 'Submit':
                first = vals['-FIRST-']
                last = vals['-LAST-']

                result = bll.updateStatus(first, last)

                sg.popup("Status updated! Refresh list!")
                break
        popup.close()

    #advanced feature: CSV


    elif event == 'Export CSV':
        popup_layout = [
            [sg.Text("What do you want to export?")],
            [sg.Radio('All Players', 'EXPORTCHOICE', key='-EXP_PLAYERS-', default=True),
             sg.Radio('Salary by Position', 'EXPORTCHOICE', key='-EXP_SALARY-')],
            [sg.Button('Export'), sg.Button('Cancel')]
        ]

        popup = sg.Window("CSV Export", popup_layout, modal=True)

        while True:
            ev, vals = popup.read()

            if ev in (sg.WIN_CLOSED, 'Cancel'):
                break
            elif ev == 'Export':
                if vals['-EXP_PLAYERS-']:
                    cols, rows = bll.getExport('all_players')
                    filename = 'players.csv'

                else:
                    cols, rows = bll.getExport('salary_by_position')
                    filename = 'salary_by_position.csv'
                #save it
                _save_csv(cols, rows, filename) #connects to the CSV helping function at top of page
                break
        popup.close()

window.close()