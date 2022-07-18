#!/usr/bin/env bash

curl \
	-Ss \
	-H "Content-Type: application/json" \
	--data $(jq -cMnr --arg id ${XRAY_CLIENT_ID} --arg sec ${XRAY_CLIENT_SECRET} '{ client_id: $id, client_secret: $sec }') \
	https://xray.cloud.getxray.app/api/v2/authenticate | tr -d '"'
