import runpod
import os
from dotenv import load_dotenv
import base64

load_dotenv()

runpod.api_key = os.getenv("RUNPOD_API_KEY")
endpoint = runpod.Endpoint(os.getenv("ENDPOINT_ID"))

person = base64.b64encode(open("person.png", "rb").read())
sweater = base64.b64encode(open("sweater.png", "rb").read())

try:
    run_request = endpoint.run_sync(
        {"imgs": person, 
        "garm_img": sweater,
        "prompt": "A nice sweater with a Christmas theme"},
        timeout=60,  # Client timeout in seconds
    )
    print(run_request)

except TimeoutError:
    print("Job timed out.")