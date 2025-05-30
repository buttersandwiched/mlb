from azure.storage.blob import BlobServiceClient


def setup_azure_connection(account_name, account_key):
    con = f"DefaultEndpointsProtocol=https;AccountName={account_name};AccountKey={account_key}"

    return BlobServiceClient.from_connection_string(con)


def write_to_blob(container_name, blob_name, data, overwrite=True):
    blob_service_client = setup_azure_connection(account_name="arittleanalytics",
                                                 account_key="Ajpp8FXP5NO8SzQ2ILy+yoFldEgTYV6i58Sp/Zyvkg7/zJhHWpFGZmWKJYjV29X8Pp9lTazhRlc9+AStPBb1AA==")

    container_client = blob_service_client.get_container_client(container_name)
    blob_client = container_client.get_blob_client(blob_name)

    return blob_client.upload_blob(data, overwrite=overwrite)

