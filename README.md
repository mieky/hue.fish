# hue.fish

Fish command to toggle [Hue](https://www.philips-hue.com/en-us) lighting scenes via [Home Assistant API](https://developers.home-assistant.io/docs/api/rest/).

## Prequisites:

- Fish shell
- jq
- curl
- Home Assistant reachable via network

## Installation

1. Copy or symlink:

    - `functions/hue.fish` to `~/.config/fish/functions`
    - `completions/hue.fish` to `~/.config/fish/completions`

1. Configure with environment variables:

    - `HA_API_TOKEN`: the [Home Assistant API token](https://developers.home-assistant.io/docs/auth_api/#long-lived-access-token) to use (required)

    - `HA_API_URL`: home assistant URL to call (defaults to `http://homeassistant.local:8123/api`)

    - `HA_SCENE_PREFIX`: scene prefix to look up room lights (defaults to `scene.office`)
      - The scene name gets appended to this prefix, e.g. `scene.office_frosty_dawn`
      - With the token and URL configured, you can use `hue-states` to list your scene names

## Usage

```sh
# List available Hue scenes
$ hue
arctic_aurora
emerald_isle
frosty_dawn
galaxy
soho

# Set Hue scene to 'galaxy'
$ hue galaxy
```

## License

[MIT](LICENSE)
