from flask import Flask, Response, request
import subprocess
app = Flask(__name__)

@app.route("/", methods=['POST'])
def execute_query():
    data = request.get_json(force=True)

    p = subprocess.Popen(data, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    # Decode the output and error messages into strings
    out, err = p.communicate()
    out_str = out.decode('utf-8')
    err_str = err.decode('utf-8')

    # Print the output and error messages
    print('Output:', out_str)
    print('Error:', err_str)
    return out_str