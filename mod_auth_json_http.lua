-- HTTP authentication using REST-like json based API authentication
-- e.g. node.js passport local strategy
--
-- author: Sebastian Castillo <castillobuiles@gmail.com>
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

local name = "HTTP json auth";
local log = require "util.logger".init("auth_json_http");
local json = require "util.json";
local http = require "socket.http";
local ltn12 = require "ltn12";
local util_sasl_new = require "util.sasl".new;


local auth_url = module:get_option_string("auth_json_http_url", "127.0.0.1/api/v1/auth/local");
log("debug", "auth_url: %s", auth_url);

assert(auth_url, "HTTP URL is needed");

-- for 0.9
-- local provider = {};

provider = {
	name = module.name:gsub("^auth_","");
};

function provider.get_sasl_handler()
   local getpass_authentication_profile = {
      plain_test = function(sasl, username, password, realm)
         local credentials = json.encode({ username = username, password = password });
         local respbody = {};
         local result, respcode, respheaders, respstatus = http.request{
            method = "POST",
            url = auth_url,
            headers = {
               ["Content-Type"] = "application/json",
               ["Content-Length"] = tostring(#credentials)
            },
            source = ltn12.source.string(credentials),
            sink = ltn12.sink.table(respbody)
         }
         log("debug", "respcode: %s", respcode);
         return respcode == 200, true;
      end,
   };
   return util_sasl_new(module.host, getpass_authentication_profile);
end


-- Non implemented

function provider.create_user(username, password)
   return nil, "Not implemented"
end

function provider.delete_user(username)
   return nil, "Not implemented"
end

function provider.set_password(username, password)
   return nil, "Not implemented"
end

function provider.test_password(username, password)
   return nil, "Not implemented"
end

function provider.get_password(username)
   return nil, "Not implemented"
end

function provider.user_exists(username)
   return true;
end


module:add_item("auth-provider", provider);
-- for 0.9
-- module:provides("auth", provider)
