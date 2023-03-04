# Google calendar API usage example

### Get Google OAuth
Follow this: https://developers.google.com/identity/protocols/oauth2/web-server#ruby_4

### Notes

Create a `token.yaml` and a `credentials.json` file.

- Example of token.yaml:
```
default: '{"client_id":"XXXX831201-3tkhnjfuhqknjd99fb4br8nsaqv3ogtp.apps.googleusercontent.com","access_token":"ya29.a0AVvZVsr-xGYtzrfJi2lolhp7cYkuJnB3AcdD-16aOLSnyy00UEClPv1_dhLxcKRlNE250jMWeWt8PJvUpBp-l37lQpF-6GoS5mB-MTGntHQC7DVwIYFIlJb3sjrTC2FcTJRQl6ZKff08e81MZNcGo-a3dz0dYrQYaCgYKAWISARMSFQGbdwaI4wp45me3-tIm7oRfb8XXXX","refresh_token":"1//0eTTQ-2oeUnJUCgYIARAAGA4SNwF-L9IrAVRy3Fy6AyGlcQrCUIOc622BvM9iSV55VOdOuWnNErYUmMjpL0vGOpj-XrEItBuXXXX","scope":["https://www.googleapis.com/auth/calendar"],"expiration_time_millis":1677890890000}'
```

- Example of credentials.json:
```
{"web":{"client_id":"XXXX831201-3tkhnjfuhqknjd99fb4br8nsaqv3ogtp.apps.googleusercontent.com","project_id":"ocr-test-377505","auth_uri":"https://accounts.google.com/o/oauth2/auth","token_uri":"https://oauth2.googleapis.com/token","auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs","client_secret":"GOCSPX-_cujIbUwnPPtLw3PV7RtXXXXX","redirect_uris":["http://localhost:3000"],"javascript_origins":["http://localhost:3000"]}}
```