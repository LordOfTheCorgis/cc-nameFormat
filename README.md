# cc-nameFormat

Simple FiveM resource that checks if a player's in-game name matches their Discord nickname, and optionally enforces whitelist or bypass roles.

## Features

- Verifies a player's Discord nickname matches their in-game name on connect
- Optional whitelist enforcement via Discord role IDs
- Optional bypass role IDs to exempt users from name checks

## Requirements

- FiveM server
- Discord Bot token with guild members intent enabled
- Guild ID (server ID)
- Add the bot to your Discord guild with the appropriate permissions

## Installation

1. Place the resource folder in your `resources` directory (e.g. `resources/cc-nameFormat`).
2. Add `ensure cc-nameFormat` to your server.cfg (or start manually).

## Configuration

Create a `config.lua` in the resource folder with the following fields:

<img width="986" height="672" alt="image" src="https://github.com/user-attachments/assets/6f0773bb-2419-4bc5-999c-2408857b8b0d" />


Notes:
- `RequiredWhitelistRoleIDs` will enforce that players must have one of the listed roles to join.
- `NameBypassRoleIDs` contains roles that can bypass the name check.

## Usage / Testing

- When a player connects, the server will check their Discord linked ID and compare the nickname to their FiveM player name.
- If the nickname and player name do not match, and the player does not have a bypass role (or the whitelist is not passed), they will be denied.

## Debugging

- Ensure `DiscordBotToken` and `guildID` are correct.
- Verify the bot has the `guilds.members.read` permission and server members intent if needed.
- Monitor the FiveM console logs for any `PerformHttpRequest` or authentication errors.
