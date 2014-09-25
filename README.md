Prosody mod_auth_json_http
==========================

A prosody authentication module with a rest-like api as backend.

## Notes

  * Only tested on 0.8
  * Only tested with node, connect, passport local strategy as backend
  * Assumes a response 200 OK if auth succeed
  * Once it get more tested I promise uploading this to prosody modules repo

## Config

* Put the module lua file on a place discoverable by prosody (`/usr/lib/prosody/modules` on Debian like systems)
* To setup the http auth url use this in `prosody.cfg.lua`:

  ```lua
  authentication = "json_http"
  auth_json_http_url = "http://192.168.50.1:3000/api/v1/auth/local"
  ```
