from flask import Flask, render_template, request, jsonify
import os
import subprocess
import json
import threading
import time


app = Flask(__name__)

# Add the execute_script function definition here
def execute_script(script_name):
    try:
        result = subprocess.run(['bash', script_name], capture_output=True, text=True)
        if result.returncode == 0:
            return True, result.stdout
        else:
            return False, result.stderr
    except Exception as e:
        return False, str(e)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/run_script', methods=['POST'])
def run_script():
    output = ""
    success = False
    success, output = execute_script('rpc.sh')
    return jsonify({"success": success, "output": output})

@app.route('/api/generate_data', methods=['GET'])
def generate_data():
    output = subprocess.check_output(['datagenerator'])
    return jsonify(data=output.decode('utf-8').strip())

@app.route('/api/submit_pfb', methods=['POST'])
def submit_pfb():
    namespace_id = request.form.get('namespace_id')
    data = request.form.get('data')

    cmd = f'source $HOME/.bash_profile; export CELESTIA_NODE_AUTH_TOKEN=$(celestia $NODETYPE auth admin --p2p.network $NETWORK); celestia rpc state SubmitPayForBlob {namespace_id} {data} 2000 100000'
    process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True, text=True)
    stdout, stderr = process.communicate()

    if process.returncode == 0:
        response_json = json.loads(stdout)
        height, txhash = response_json.get('result', {}).get('height'), response_json.get('result', {}).get('txhash')
        if height is not None and txhash is not None:
            return jsonify(success=True, height=height, txhash=txhash)
        else:
            return jsonify(success=False, error="Error: Unable to find 'height' and 'txhash' in the JSON response.", stdout=stdout, stderr=stderr)
    else:
        return jsonify(success=False, error="Error submitting PayForBlob transaction.", stdout=stdout, stderr=stderr)



@app.route('/api/start_interval', methods=['POST'])
def start_interval():
    interval_minutes = float(request.form.get('interval_minutes', '0'))
    if interval_minutes > 0:
        interval_seconds = interval_minutes * 60
        def run_pfb_repeater():
            while True:
                subprocess.run(['bash', os.path.expanduser('~/pfb-repeater.sh')])
                time.sleep(interval_seconds)

        # Start a new thread to run the pfb-repeater.sh script at the specified interval
        pfb_thread = threading.Thread(target=run_pfb_repeater, daemon=True)
        pfb_thread.start()

        return jsonify(success=True)
    else:
        return jsonify(success=False, error="Invalid interval value.")

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
