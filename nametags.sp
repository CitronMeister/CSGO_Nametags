#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <sdkhooks>
#include <clientprefs>

public OnPluginStart()
{
	LoadTranslations("nametags.phrases");
		
	HookEvent("player_team", Action_HandlePlayer);
	HookEvent("player_spawn", Action_HandlePlayer);
	
	RegServerCmd("reloadtags", Action_ReloadTags);
	
}

public Action:Action_ReloadTags(int args)
{
	LoadTranslations("nametags.phrases");
}

public Action:Action_HandlePlayer(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	CreateTimer(0.5, HandleTag, client, TIMER_FLAG_NO_MAPCHANGE);
		
	return Plugin_Continue
}

public Action:HandleTag(Handle:timer, any:clientid)
{	
	if(clientid != 0 && IsClientInGame(clientid)) {
			
		char name[32], buffer[128];
		new String:SteamID[32];
		
		GetClientAuthString(clientid, SteamID, sizeof(SteamID));
		GetClientName(clientid, name, sizeof(name));
			
		Format(buffer, sizeof(buffer), "%T", SteamID, LANG_SERVER, name);
		
		if(strlen(buffer) > 2)
			CS_SetClientClanTag(clientid, buffer);
	}
}

