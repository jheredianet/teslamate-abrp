# TeslaMate: MQTT to ABRP

## Use as Docker container
### Requirements
For this to work, you need a working instance of TeslaMate with MQTT enabled. See the [official TeslaMate doc](https://docs.teslamate.org/docs/installation/docker) as a reference on how this might look like.

### Getting an USER TOKEN from ABRP
Inside the ABRP (web)app, navigate to your car settings and use the "generic" card (last one at the very bottom) to generate your user token. Make a note of that token and keep it to yourself.

### Adding the service to docker-compose.yml
In your TeslaMate docker-compose.yml, add the teslamate-abrp service by adding the following lines in the "services:" section:
```
  ABRP:
    container_name: TeslaMate_ABRP
    image: fetzu/teslamate-abrp:latest
    environment:
      - MQTT_SERVER=mosquitto
      - USER_TOKEN=y0ur-4p1-k3y
      - CAR_NUMBER=1
      - CAR_MODEL=s100d
```
  
Make sure to adapt the following lines:
- The first value MQTT_SERVER corresponds to the name of your MQTT service name ("mosquitto" in the doc).  
- The second values (USER_TOKEN) correspond to the value provided by ABRP.
- The third value corresponds to your car number (1 if you only have a single car).
- The last value corresponds to your car model; you need to find your car model on https://api.iternio.com/1/tlm/get_carmodels_list. Use the corresponding key as a value for CAR_MODEL (e.g. "s100d" for a 2012-2018 S100D).
- Additionally, MQTT_PASSWORD and/or MQTT_USERNAME can be set to use authentication on the MQTT server.
  
Then from the command line, navigate to the folder where your docker-compose.yml is located and run:
```
docker-compose pull ABRP
docker-compose up ABRP -d
```
  
If all goes well, your car should be shown as online in ABRP after a minute. The logs should  show "Connected with result code 0".

## Use as python script
The script can also be run directly on a machine with Python 3.x. Please note that the machine needs to have access to your MQTT server on port 1883.

### Installing requirements
To install the requirements, run
```
pip install -r requirements.txt
```

### Running

To run, you can either use the CLI. Please note that USER_TOKEN, CAR_NUMBER, CAR_MODEL and MQTT_SERVER are required arguments.  
  
If you are using a MQTT server with username or authentication, pass the -l (to use MQTT_USERNAME only) or -a (for authentication with MQTT_USERNAME and MQTT_PASSWORD) options.

  
```
  Usage: 
    teslamate_mqtt2abrp.py [-hlap] [USER_TOKEN] [CAR_NUMBER] [CAR_MODEL] [MQTT_SERVER] [MQTT_USERNAME] [MQTT_PASSWORD]
  
  Arguments:
    USER_TOKEN          User token generated by ABRP.
    CAR_NUMBER          Car number from TeslaMate (usually 1).
    CAR_MODEL           Car model (from https://api.iternio.com/1/tlm/get_carmodels_list, e.g. "s100d" for a 2012-2018 S100D).
    MQTT_SERVER         MQTT server address (e.g. "192.168.1.1").
    MQTT_USERNAME       MQTT username (e.g. "teslamate") - use with -l or -a.
    MQTT_PASSWORD       MQTT password (e.g. "etamalset") - use with -a.
  Options:
    -h                  Show this screen.
    -l                  Use username to connect to MQTT server.
    -a                  Use authentification (user and password) to connect to MQTT server.
```
**Note: All arguments can also be passed as corresponding OS environment variables.** Arguments passed through the CLI will always supersede OS environment variables.

