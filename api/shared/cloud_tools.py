from azure.storage.blob import BlobServiceClient
from dotenv import load_dotenv
import os

def setup_azure_connection(account_name, account_key):
    load_dotenv()
    con = f"DefaultEndpointsProtocol=https;AccountName={account_name};AccountKey={account_key}"

    return BlobServiceClient.from_connection_string(con)


def write_to_blob(container_name, blob_name, data, overwrite=True):
    blob_service_client = setup_azure_connection(account_name=os.getenv("AZ_ACCOUNT_NAME"),
                                                 account_key=os.getenv("AZ_ACCOUNT_KEY"))

    container_client = blob_service_client.get_container_client(container_name)
    blob_client = container_client.get_blob_client(blob_name)

    return blob_client.upload_blob(data, overwrite=overwrite)

