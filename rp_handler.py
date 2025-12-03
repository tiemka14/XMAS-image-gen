import runpod
import time  
import base64
import os
import sys

print(f"RP Handler loaded successfully.", flush=True)
# Ensure the repository root (the directory containing this file) is on sys.path
project_root = os.path.dirname(os.path.abspath(__file__))
if project_root not in sys.path:
    sys.path.insert(0, project_root)

from app_wo_gradio import start_tryon

def handler(event):
#   This function processes incoming requests to your Serverless endpoint.
#
#    Args:
#        event (dict): Contains the input data and request metadata
#       
#    Returns:
#       Any: The result to be returned to the client
    
    # Extract input data
    print(f"Worker Start")
    input = event['input']
    
    imgs = base64.b64decode(input.get('imgs'))
    garm_img = base64.b64decode(input.get('garm_img'))
    prompt = input.get('prompt') 
    is_checked = input.get('is_checked',True)
    is_checked_crop = input.get('is_checked_crop',False)
    denoise_steps = input.get('denoise_steps',30)
    seed  = input.get('seed',42)
    seconds = input.get('seconds', 0)  
    
    print(f"start_tryon called")
    image_out,masked_img = start_tryon(imgs,garm_img,prompt,is_checked,is_checked_crop,denoise_steps,seed) 
    print("start_tryon finished")
    
    return base64.b64encode(image_out) 

# Start the Serverless function when the script is run
if __name__ == '__main__':
    runpod.serverless.start({'handler': handler })