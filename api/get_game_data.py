import json

from shared import api_tools, data_dictionaries, db_tools
from datetime import datetime
game_data = api_tools.get_mlb_game_data(verbose=False)

#print(json.dumps(game_data, indent=4))
db_tools.write_to_db(data=game_data,
                     data_schema=data_dictionaries.get_schema('gameData'),
                     db_schema='baseball_raw',
                     table_name='gameData',
                     write_mode='replace')