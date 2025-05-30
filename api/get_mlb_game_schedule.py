import json

from shared import api_tools, data_dictionaries, db_tools
from datetime import datetime
schedule = api_tools.get_mlb_game_data(verbose=False)
