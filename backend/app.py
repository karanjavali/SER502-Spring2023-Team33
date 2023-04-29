from flask import Flask, Response, request
import subprocess
import json
app = Flask(__name__)

@app.route("/", methods=['POST'])
def execute_query():
    create_executables()
    input_args = request.get_json(force=True)['args']
    print(input_args)
    
    

    p = subprocess.Popen(['laky.exe'] + input_args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    # Decode the output and error messages into strings
    output, error = p.communicate()
    eval_output = output.decode('utf-8')
    eval_error = error.decode('utf-8')

    print('parse tree -> ',eval_output)
    print('parse tree err -> ',eval_error)


    # 200 -> good
    # 400 -> errors

    output_data = {
        'status': 200,
        'res': '',
    }

    if eval_error != '':
        output_data['res'] = eval_error
        output_data['status'] = 400
    else:
        output_data['res'] = eval_output.strip()
    
    return output_data

def create_executables():
    subprocess.run(['swipl.exe','-o','laky.exe','-g','main','-c','../src/laky.pl'])