from shared import cloud_tools, api_tools, db_tools, data_dictionaries
from datetime import timedelta, datetime

start_time = datetime.now()

'''
print ('fetching mlb team data...')
mlb_teams = api_tools.get_mlb_teams(verbose=True)
if mlb_teams:
    print('writing to db...')
    db_tools.write_to_db(data=mlb_teams["teams"],
                         data_schema=data_dictionaries.get_schema('team'),
                         db_schema='baseball_raw',
                         table_name='team',
                         write_mode='reload')
else:
    print('no teams data to process.')
print('done.')

#cloud_tools.write_to_blob('mlb', 'teams/teams.json', json.dumps(teams, indent=4))
'''

print ('fetching mlb player data...')
players = api_tools.get_mlb_players(verbose=True, start_date=(datetime.now() - timedelta(days=7)).strftime('%Y-%m-%d'))
print ('done.')
print('writing to db...')
db_tools.write_to_db(data=players,
                     data_schema=data_dictionaries.get_schema('player'),
                     db_schema='baseball_raw',
                     table_name='player',
                     write_mode='reload')
print('done.')
#cloud_tools.write_to_blob('mlb', 'players/players.json', json.dumps(players, indent=4))

print(f'fetching MLB schedule for season 2025...')
schedule = api_tools.get_mlb_schedule(start_date=(datetime.now().date() - timedelta(days=64)).strftime('%Y-%m-%d'),
                                      end_date=datetime.now().date().strftime('%Y-%m-%d'),verbose=False)
print(f'done.')
if schedule:
    #cloud_tools.write_to_blob('mlb', 'schedule/schedule.json', json.dumps(schedule, indent=4))
    db_tools.write_to_db(data=schedule,
                         data_schema=data_dictionaries.get_schema('schedule'),
                         db_schema='baseball_raw',
                         table_name='schedule',
                         write_mode='reload')
    print('done.')
else:
    print('no scheduled games to process...done.')

print('fetching game data...')
game_data = api_tools.get_mlb_game_data(start_date=(datetime.now() - timedelta(days=64)).strftime('%Y-%m-%d')
                                       ,end_date=datetime.now().strftime('%Y-%m-%d')
                                       ,verbose=False)
if game_data:
    db_tools.write_to_db(data=game_data,
                         data_schema=data_dictionaries.get_schema('game'),
                         db_schema='baseball_raw',
                         table_name='game',
                         write_mode='reload')
print('done.')

print('fetching mlb at bats data...')
at_bats = api_tools.get_mlb_at_bats(start_date=(datetime.now() - timedelta(days=64)).strftime('%Y-%m-%d')
                                    ,end_date=datetime.now().strftime('%Y-%m-%d')
                                    ,verbose=False)

if at_bats:
    db_tools.write_to_db(data=at_bats,
                         data_schema=data_dictionaries.get_schema('play'),
                         db_schema='baseball_raw',
                         table_name='play',
                         write_mode='reload')
    print('done.')
else:
    print('no at bats data to process...done.')

end_time = datetime.now()

print(f'elapsed time: {((end_time - start_time).total_seconds()):.2f}s')
