import requests
from typing import Dict
from datetime import datetime
import configparser

class APIHandler:
    def __init__(self, request_params):
        self.base_url = "https://www.alphavantage.co/query?"
        self.request_params  = request_params 

    def _read_api_key(self) -> str:
        config = configparser.ConfigParser()
        config.read("./stockETL/config/config.ini")
        api_key = config["API"]["api_key"]
        return api_key

    def request_data(self) -> dict: 
        query_string = "&".join([f"{k}={v}" for k,v in self.request_params.items()])
        full_url = f"{self.base_url}{query_string}&apikey={self._read_api_key()}"
        try:
            response = requests.get(full_url)
            payload = response.json()
            response.raise_for_status()
            return payload
        except requests.exceptions.RequestException as e:
            print(f"API request failed: {e}")
            return {}