from flask import Flask, Response, request
import subprocess
import json
app = Flask(__name__)

@app.route("/", methods=['POST'])
def execute_query():
    create_executables()
    input_args = request.get_json(force=True)['args']
    
    # Use subprocess to execute laky.exe and pass input args
    p = subprocess.Popen(['laky.exe'] + input_args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    # Decode the output and error messages into strings
    output, error = p.communicate()
    eval_output = output.decode('utf-8')
    eval_error = error.decode('utf-8')


    # status
    # 200 -> good
    # 400 -> errors
    
    # output object
    output_data = {
        'status': 200,
        'res': '',
    }
    
    # if there is an error, return error and change status otherwise return the query result 
    if eval_error != '':
        output_data['res'] = eval_error
        output_data['status'] = 400
    else:
        output_data['res'] = eval_output.strip()
    
    return output_data

def create_executables():
    # Create exe file from pl using swipl
    subprocess.run(['swipl.exe','-o','laky.exe','-g','main','-c','../src/laky.pl'])
