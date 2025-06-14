import os
from datetime import datetime, timedelta
from dotenv import load_dotenv
import requests


def get_mlb_stats_api_response(endpoint, version='v1', params=None, is_full_endpoint=False,
                               verbose=False) -> requests.Response:
    load_dotenv()
    url = os.getenv("API_BASE_URL")

    if is_full_endpoint:
        url += f'{endpoint}'
    else:
        url += f'/api/{version}{endpoint}'

    if params:
        url += params

    if verbose:
        print(f'requesting /get {url}:\n')

    r = requests.get(url)

    if verbose:
        print(f'API Response for {url}: {r.status_code}')

    return r


def get_mlb_teams(verbose=False):
    endpoint = '/teams'
    params = '?sportId=1'
    resp = get_mlb_stats_api_response(endpoint, params=params, verbose=verbose)

    teams = []
    if resp.status_code == 200:
        teams = resp.json()


    return teams


def get_mlb_schedule(start_date=(datetime.now().date() - timedelta(days=1)).strftime('%Y-%m-%d'),
                     end_date=datetime.now().date().strftime('%Y-%m-%d'),
                     season=None, verbose=False):
    endpoint = "/schedule/games"
    params = f'?sportId=1'

    if start_date > end_date:
        raise ValueError("start_date must be before end_date.")

    if season:
        params += f'&season={season}'

    params += f'&startDate={start_date}&endDate={end_date}'

    resp = get_mlb_stats_api_response(
        endpoint=endpoint,
        params=params,
        verbose=verbose)

    schedule = []
    if resp.status_code == 200 and 'dates' in resp.json():
        schedule = resp.json()['dates']

    return schedule


def get_mlb_game_data(start_date=(datetime.now().date() - timedelta(days=1)).strftime('%Y-%m-%d'),
                      end_date=datetime.now().date().strftime('%Y-%m-%d'),
                      verbose=True):

    # get the games scheduled for yesterday
    schedule = get_mlb_schedule(start_date=start_date,
                                end_date=end_date,
                                verbose=verbose)

    # initialize lists
    game_ids = []
    game_data = []

    #get all game ids so we can properly query the api
    for date, value in enumerate(schedule):
        for game_id in schedule[date]['games']:

            #can get duplicate gamePks in source if game is cancelled then rescheduled
            #keep dupes out of the list
            if game_id['gamePk'] not in game_ids:
                game_ids.append(game_id['gamePk'])

    if game_ids:
        for game_id in game_ids:
            endpoint = f'/game/{game_id}/feed/live'
            resp = get_mlb_stats_api_response(endpoint=endpoint,
                                              version='v1.1',
                                              verbose=verbose,
                                              is_full_endpoint=False)
            if resp.status_code == 200 and resp.json()['gameData']:
                game_data.append({'gamePk': resp.json()['gamePk'],
                                  'schedule': resp.json()['gameData']['datetime'],
                                  'teams': resp.json()['gameData']['teams'],
                                  'venue': resp.json()['gameData']['venue'],
                                  'weather': resp.json()['gameData']['weather'],
                                  'gameInfo': resp.json()['gameData']['gameInfo']})
            else:
                print(f'No game data for game {game_id}')
                print(resp.status_code)
                print(resp.text)

    return game_data


def get_mlb_at_bats(start_date=None,
                    end_date=datetime.now().date().strftime('%Y-%m-%d'),
                    season=datetime.now().year,
                    verbose=False):
    if season and len(str(season)) != 4:
        raise ValueError("Season must be in YYYY format (e.g., 2023).")
    if season and not start_date:
        start_date = f'{season}-01-01'
    elif not start_date:
        start_date = datetime.now().date().strftime('%Y-%m-%d')

    # get the games scheduled for yesterday
    schedule = get_mlb_schedule(start_date=start_date,
                                end_date=end_date,
                                verbose=verbose)

    # initialize lists
    game_ids = []
    game_plays = []

    #get all game ids so we can properly query the api
    for date, value in enumerate(schedule):
        for game_id in schedule[date]['games']:

            #can get duplicate gamePks in source if game is cancelled then rescheduled
            #keep dupes out of the list
            if game_id['gamePk'] not in game_ids:
                game_ids.append(game_id['gamePk'])

    if game_ids:
        print(f'fetching at bats for {len(game_ids)} games')
        for game_id in game_ids:
            endpoint = f'/game/{game_id}/feed/live'
            resp = get_mlb_stats_api_response(endpoint=endpoint,
                                              version='v1.1',
                                              verbose=verbose,
                                              is_full_endpoint=False)

            live_data = resp.json()["liveData"]
            plays =  live_data["plays"]['allPlays']

            #append all plays in a list for each game played
            at_bats = []
            if plays:
                for play in plays:
                    at_bat = {
                            'about': play['about'],
                            'matchup': play['matchup'],
                            'result': play['result'],
                            'runners': play['runners'],
                            'playOutcome': play['playEvents']
                        }
                    at_bats.append(at_bat)
            game_plays.append({'gamePk': resp.json()['gameData']['game']['pk'], 'plays': at_bats})

    else:
        print('no games to process.')

    return game_plays


def get_mlb_players(season=datetime.now().year,
                    start_date=(datetime.now().date() - timedelta(days=7)).strftime('%Y-%m-%d'),
                    end_date=datetime.now().date().strftime('%Y-%m-%d'),
                    verbose=True):

    # get list of scheduled games data to parse the active players in each
    if season and not start_date and not end_date:
        schedule = get_mlb_schedule(season=season, verbose=verbose)
    else:
        schedule = get_mlb_schedule(season=season, start_date=start_date, end_date=end_date, verbose=verbose)

    game_ids = []
    for date, value in enumerate(schedule):
        for game_id in schedule[date]['games']:
            if game_id['gamePk'] not in game_ids:
                game_ids.append(game_id['gamePk'])

    if verbose:
        print(f'number of games: {len(game_ids)}')

    players_data = []
    player_links = []
    if game_ids:
        for game_id in game_ids:
            game_endpoint = f'/game/{game_id}/feed/live'
            resp = get_mlb_stats_api_response(endpoint=game_endpoint,
                                              version='v1.1',
                                              verbose=False)
            roster = [list(resp.json()["liveData"]["boxscore"]["teams"]["away"]["players"].values()),
                      list(resp.json()["liveData"]["boxscore"]["teams"]["home"]["players"].values())]

            for team_players in roster:
                for player in team_players:
                    if 'parentTeamId' not in player:
                        player_dict = {'link': player['person']['link'], 'teamId': 0}
                    else :
                        player_dict = {'link': player['person']['link'], 'teamId': player['parentTeamId']}

                    if player_dict['link'] not in player_links:
                        players_data.append(player_dict)
                        player_links.append(player_dict['link'])
        for link in player_links:
            resp = get_mlb_stats_api_response(link,
                                              is_full_endpoint=True,
                                              verbose=True)
            if resp.status_code == 200:
                players_data.update(resp.json()['people'][0])

            if player not in players_data:
                players_data.append(player)
    print(f'number of players: {len(players_data)}')

    return players_data
