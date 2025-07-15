#define Server:%0(%1)                   Server_%0(%1)

Server:Init()
{
    Server:InitWorldTime();
    Server:InitServerSettings();
    Server:InitStreamer();

    SetTimer_("OnSecondTimer", 1000, 0, -1);
}

Server:InitWorldTime()
{
    new hour;
	gettime(hour);

	SetWorldTime(hour);
}

Server:InitServerSettings()
{
    AddPlayerClass(0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);

	SendRconCommand("hostname "SERVER_NAME" RolePlay");
	SendRconCommand("weburl www."SERVER_SITE"");
	SendRconCommand("mapname "SERVER_MAP_NAME"");
	
	ShowNameTags(true);
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(false);
	ManualVehicleEngineAndLights();
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_STREAMED);
	SetNameTagDrawDistance(30.0);

    SetGameModeText(GAME_MODE_TEXT);
}

Server:InitStreamer()
{
    Streamer_SetVisibleItems(STREAMER_TYPE_MAP_ICON, 98);
    Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT, 650);

    Streamer_SetTypePriority
    (
        {
            STREAMER_TYPE_OBJECT, 
            STREAMER_TYPE_CP,
            STREAMER_TYPE_AREA,
            STREAMER_TYPE_3D_TEXT_LABEL,
            STREAMER_TYPE_MAP_ICON,
            STREAMER_TYPE_RACE_CP,
            STREAMER_TYPE_PICKUP
        }
    );

    Streamer_ToggleErrorCallback(true);
    Streamer_SetTickRate(40);
}