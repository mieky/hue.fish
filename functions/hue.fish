#!/usr/bin/env fish
# Fish command to set Hue lighting scenes
# Usage: hue [scene_name]
#
# Configure with environment variables:
# - HA_API_TOKEN: the home assistant token to use (required)
# - HA_API_URL: home assistant URL to call (defaults to "http://homeassistant.local:8123/api")
# - HA_SCENE_PREFIX: scene prefix to look up room lights (defaults to "scene.office")

function hue
    if test "$HA_API_TOKEN" = ""
        echo "hue.fish: set Home Assistant token into environment variable HA_API_TOKEN"
        return
    end

    if not command -q jq
        echo "hue.fish: please install jq to use"
        return
    end

    if test "$argv[1]" = ""
        hue-scenes
    else
        hue-scene $argv
    end
end

function ha-api-url -d "Resolve Home Assistant API URL"
    set -g ha_api_url $HA_API_URL
    set -q ha_api_url[1] || set -g ha_api_url "http://homeassistant.local:8123/api"
    echo $ha_api_url
end

function ha-scene-prefix -d "Resolve Home Assistant scene prefix"
    set -g ha_scene_prefix $HA_SCENE_PREFIX
    set -q ha_scene_prefix[1] || set -g ha_scene_prefix "scene.office"
    echo $ha_scene_prefix
end

function hue-states -d "Show available HA states and entities"
    curl --silent \
        -H "Authorization: Bearer $HA_API_TOKEN" \
        -H "Content-Type: application/json" \
        (ha-api-url)/states | jq
end

function hue-scenes -d "List available Hue scenes"
    # note: $() syntax required around variables or the newlines will be eaten/converted to arrays
    set --local entity_id (ha-scene-prefix)
    set --local curl_result "$(curl --silent \
        -H "Authorization: Bearer $HA_API_TOKEN" \
        -H "Content-Type: application/json" \
        (ha-api-url)/states)"

    # Output just the scene names
    echo $curl_result | jq | grep "\"entity_id\": \"$entity_id" | cut -d'.' -f2 | cut -d'"' -f1 | cut -d_ -f2- | sort
end

function hue-scene -d "List or set scene"
    set --local scene $argv[1]
    set --local entity_id (ha-scene-prefix)_$scene

    curl -X POST \
        --silent \
        -H "Authorization: Bearer $HA_API_TOKEN" \
        -H "Content-Type: application/json" \
        -d "{ \"entity_id\": \"$entity_id\", \"dynamic\": true }" \
        (ha-api-url)/services/hue/activate_scene >/dev/null
end
