import os
from datetime import datetime, timedelta
from dotenv import load_dotenv
import requests


def get_mlb_stats_api_response(endpoint, version='v1', params=None, is_full_endpoint=False,
                               verbose=False) -> requests.Response:
    load_dotenv()
    url = os.getenv("API_BASE_URL")

    # endpoint contains api/{version}
    if is_full_endpoint:
        url += f'{endpoint}'
    else:
        url += f'/api/{version}{endpoint}'

    if params:
        url += params

    if verbose:
        print(f'/GET {url}:\n')

    r = requests.get(url)

    if verbose:
        print(f'API Response from {url}: {r.status_code}')

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


def get_gamePks(start_date=(datetime.now().date() - timedelta(days=7)).strftime('%Y-%m-%d'),
                             end_date=datetime.now().date().strftime('%Y-%m-%d'),
                             verbose=False):
    schedule = get_mlb_schedule(start_date=start_date,
                                end_date=end_date,
                                verbose=verbose)
    game_pks = []
    for date, value in enumerate(schedule):

        for game_pk in schedule[date]['games']:

            #can get duplicate gamePks if game is cancelled then rescheduled
            if game_pk['gamePk'] not in game_pks:
                game_pks.append(game_pk['gamePk'])

    return game_pks


def get_mlb_game_data(start_date=(datetime.now().date() - timedelta(days=1)).strftime('%Y-%m-%d'),
                      end_date=datetime.now().date().strftime('%Y-%m-%d'),
                      verbose=False):

    # get the list of gamePks from /schedule for the time period requested
    game_ids = get_gamePks(start_date=start_date,end_date=end_date,verbose=verbose)

    if not game_ids and verbose:
        print(f'No game data for {start_date} thru {end_date}')

    #fetch /game data
    game_data = []
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

        elif not resp.json()['gameData'] and verbose:
            print(f'No game data for game {game_id}')

    return game_data


def get_mlb_at_bats(start_date=None,
                    end_date=datetime.now().date().strftime('%Y-%m-%d'),
                    season=datetime.now().year,
                    verbose=False):

    # get the games scheduled for time period requested
    schedule = get_mlb_schedule(start_date=start_date,
                                end_date=end_date,
                                verbose=verbose)

    # initialize lists
    game_plays = []
    game_ids = get_gamePks(start_date=start_date,end_date=end_date,verbose=verbose)

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


def get_mlb_players(start_date=(datetime.now().date() - timedelta(days=7)).strftime('%Y-%m-%d'),
                    end_date=datetime.now().date().strftime('%Y-%m-%d'),
                    verbose=True):

    game_ids = get_gamePks(start_date=start_date,end_date=end_date,verbose=verbose)

    players = []
    player_links = []
    persons = []
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
                        players.append(player_dict)
                        player_links.append(player_dict['link'])

        print(f'number of active players: {len(players)}')

        for player_data in players:
            resp = get_mlb_stats_api_response(player_data['link'],
                                              is_full_endpoint=True,
                                              verbose=False)
            if resp.status_code == 200:
                person = resp.json()['people'][0]
                person['teamId'] = player_data['teamId']
                persons.append(person)


    return persons
