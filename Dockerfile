FROM python:3.11-alpine AS build

WORKDIR /usr/src/teslamate-abrp

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

######################################################

FROM python:3.11-alpine

WORKDIR /usr/src/teslamate-abrp

# Create a non-root user
RUN adduser -D toor
USER toor

COPY --from=build /usr/src/teslamate-abrp .

CMD [ "python", "-u", "./teslamate_mqtt2abrp.py" ]
