/*
	! ���������� ��������� ���� (���� ������)

	- ������� !��������(�������� ��� ���� ��������), �����
	- ������ (������������)
	- ��������
	- �������� (������� ������ �� ���������� [�����])
	- ����� (���. ������ [������� ��������])
*/

@___If_u_can_read_this_u_r_nerd();		// 10 different ways to crash DeAMX
@___If_u_can_read_this_u_r_nerd()		// and also a nice tag for exported functions table in the AMX file
{ // by Daniel_Cortez, exclusively for pro-pawn.ru (who cares anyway? -_-)
    #emit	stack	0x7FFFFFFF	// wtf (1) (stack over... overf*ck!?)
    #emit	inc.s	cellmax		// wtf (2) (this one should probably make DeAMX allocate all available memory and lag forever)
    static const ___[][] = {"pro-pawn", ".ru"};	// pretty old anti-deamx trick
    #emit	retn
    #emit	load.s.pri	___		// wtf (3) (opcode outside of function?)
    #emit	proc				// wtf (4) (if DeAMX hasn't crashed already, it would think it is a new function)
    #emit	proc				// wtf (5) (a function inside of another function!?)
    #emit	fill		cellmax	// wtf (6) (fill random memory block with 0xFFFFFFFF)
    #emit	proc
    #emit	stack		1		// wtf (7) (compiler usually allocates 4 bytes or 4*N for arrays of N elements)
    #emit	stor.alt	___		// wtf (8) (...)
    #emit	strb.i		2    	// wtf (9)
    #emit	switch		4
    #emit	retn    			// wtf (10) (no "casetbl" opcodes before retn - invalid switch statement?)
L1:
    #emit	jump	L1			// avoid compiler crash from "#emit switch"
    #emit	zero	cellmin		// wtf (11) (nonexistent address)
}

#include <a_samp>

#include "library\a_mysql.inc"
#include "library\sscanf2.inc"
#include "library\streamer.inc"
#include "library\dc_cmd.inc"
#include "library\foreach.inc"
#include "library\crashdetect.inc"
#include "library\timerfix.inc"
#include "library\profiler.inc"
#include "library\zones.inc"
#include "library\mxdate.inc"
#include "library\yom_buttons.inc"

// config.pwn � defines, macros, enums, vars
// object.pwn � Create / Remove Object functions
// server.pwn � server commands, utilities
// database.pwn � MySQL functions

#include "modules\core\config.pwn"
#include "modules\core\object.pwn"
#include "modules\core\server.pwn"
#include "modules\core\database.pwn"

#include "modules\system\cp.pwn"
#include "modules\system\cp_race.pwn"
#include "modules\system\pickup.pwn"
#include "modules\system\vehicle.pwn"

// ------------------------------------------
main()
{
	print("\n--------------------------------------");
	print("Development: jesus.christ, Vito_Jaims");
	print("Game mode is the property of: jesus.christ.");
	print("--------------------------------------\n");
}

// ------------------------------------------

#define AUTH_CAMERA_POS 			236.4, 810.1, 20.0 // ������� ������ ��� �����������/�����������
#define AUTH_CAMERA_LOOK 			-400.0, 400.0, 5.0 // ������� ������ ��� �����������/�����������

#define MAX_FLOOD_RATE	(3000)	
#define FLOOD_RATE_INC	(1000)
#define FLOOD_RATE_KICK	(5000)

//#define RAND_WEATHER				// ������� ��������� ������
#define ATM_CREATED_PICKUP			// ��������� �� ������ ��� ����������
#define FUEL_ST_CREATED_PICKUP		// ��������� �� ������ ��� ���

#define ENTER_PASSWORD_ATTEMPS 	(3)  // ���-�� ������� �� ���� ������
#define REFER_BONUS_MONEY		(50_000) // ����� ������ ����� ������

#define MAX_AFK_TIME 			(30) // ������������ ����� ��� (� �������)
#define MAX_BANK_ACCOUNTS 		(8)	 // ������������ ��� ������ � �����
#define MAX_PHONE_BOOK_CONTACTS (20) // ����. ���-�� ��������� ��� ���������� �����
#define MAX_AUTHORIZATION_TIME	(25) // ����� �� ����������� (� ��������)
#define MAX_FUEL_STATIONS		(18) // ������������ ���-�� ��������
#define MAX_BUSINESS			(200)// ������������ ���-�� �����������
#define MAX_BUSINESS_GPS		(50) // ������������ ���-�� ����������� � GPS
#define MAX_HOUSES				(900)// ������������ ���-�� �����
#define MAX_HOUSE_ROOMS			(5)	 // ������������ ���-�� ������ � ����
#define MAX_GATES				(2)	 // ������������ ���-�� ��������/�����
#define MAX_ENTRANCES			(50) // ������������ ���-�� ���������
#define MAX_ENTRANCE_FLOORS		(5)	 // ������������ ���-�� ������ � ��������
#define MAX_HOTELS 				(3)	 // ������������ ���-�� ������
#define MAX_HOTEL_FLOORS 		(7)  // ������������ ���-�� ������ �����
#define MAX_HOTEL_ROOMS 		(MAX_HOTEL_FLOORS * 12) // ������������ ���-�� ������� � �����
#define MAX_OWNABLE_CARS		(1000)// ������������ ���-�� ������ ��
#define MAX_VEHICLE_TRUNK_SLOTS	(5)	 // ������������ ���-�� ������ ���������

#define BIZ_HEALTH_SERVICE_PRICE (150)	// ��������� ������������� ������� � �������

#define MAP_ICON_STREAM_DISTANCE (200.0) // ���������� ������ �� ����� (������)

// ------------------------------------------
#define VEHICLE_COORD_TYPE_BOOT		(1)
#define VEHICLE_COORD_TYPE_BONNET	(2)

// ------------------------------------------
#define SELECT_PANEL_TYPE_NONE		0
#define SELECT_PANEL_TYPE_CLOTHING	1
#define SELECT_PANEL_TYPE_REG_SKIN	2

// ------------------------------------------
#define GATE_STATUS_OPEN	true
#define GATE_STATUS_CLOSE	false

// ------------------------------------------
#define GPS_STATUS_ON	true
#define GPS_STATUS_OFF	false

// ------------------------------------------
#define ADMIN_TYPE_NONE 	0

// ------------------------------------------
#define CONVERT_TIME_TO_SECONDS 	1
#define CONVERT_TIME_TO_MINUTES 	2
#define CONVERT_TIME_TO_HOURS 		3
#define CONVERT_TIME_TO_DAYS 		4
#define CONVERT_TIME_TO_MONTHS 		5
#define CONVERT_TIME_TO_YEARS 		6

// ------------------------------------------
#define ACCOUNT_STATE_NONE 		0
#define ACCOUNT_STATE_REGISTER 	1
#define ACCOUNT_STATE_LOGIN 	2
#define ACCOUNT_STATE_REG_SKIN 	3

// ------------------------------------------
#define REQUEST_TYPE_OFF		-1
#define REQUEST_TYPE_SUBNET		1
#define REQUEST_TYPE_IP			2

// ------------------------------------------
#define PIN_CODE_STATE_NONE 	0
#define PIN_CODE_STATE_SET 		1 // ��������� ��� ����
#define PIN_CODE_STATE_CHECK	2 // �������� ��� ����
#define PIN_CODE_STATE_CHANGE	3 // ����� ��� ����
#define PIN_CODE_STATE_LOGIN_CHECK 4 // �������� ��� ���� ��� �����������

// ------------------------------------------
#define HOUSE_TYPE_NONE		(-1) 	// ���
#define HOUSE_TYPE_HOME		(0) 	// ���
#define HOUSE_TYPE_ROOM		(1) 	// ������ �������
#define HOUSE_TYPE_HOTEL	(2) 	// �����

// ------------------------------------------
#define REALTOR_TYPE_NONE	(0)
#define REALTOR_TYPE_HOUSE	(1) // ���
#define REALTOR_TYPE_BIZ	(2) // ���

// ------------------------------------------
#define GetItemInfo(%0,%1) 		g_item_type[%0][%1]

// ------------------------------------------
#define GetTrunkData(%0,%1,%2) 			g_vehicle_trunk[%0][%1][%2]
#define SetTrunkData(%0,%1,%2,%3) 		g_vehicle_trunk[%0][%1][%2] = %3
#define AddTrunkData(%0,%1,%2,%3,%4) 	g_vehicle_trunk[%0][%1][%2] %3= %4

#define IsTrunkFreeSlot(%0,%1)			!GetTrunkData(%0, %1, VT_SQL_ID)

// ------------------------------------------
#define GetOwnableCarData(%0,%1) 		g_ownable_car[%0][%1]
#define SetOwnableCarData(%0,%1,%2)		g_ownable_car[%0][%1] = %2
#define AddOwnableCarData(%0,%1,%2,%3)	g_ownable_car[%0][%1] %2= %3

#define IsOwnableCarOwned(%0)			(GetOwnableCarData(%0, OC_OWNER_ID) > 0)

// ------------------------------------------
#define GetHotelData(%0,%1,%2) 			g_hotel[%0][%1][%2]
#define SetHotelData(%0,%1,%2,%3) 		g_hotel[%0][%1][%2] = %3
#define AddHotelData(%0,%1,%2,%3,%4) 	g_hotel[%0][%1][%2] %3= %4

#define IsHotelRoomOwned(%0,%1)		(GetHotelData(%0, %1, H_OWNER_ID) > 0) // ����� �� ����� �����

// ------------------------------------------
#define GetEntranceData(%0,%1) 			g_entrance[%0][%1]
#define SetEntranceData(%0,%1,%2) 		g_entrance[%0][%1] = %2
#define AddEntranceData(%0,%1,%2,%3) 	g_entrance[%0][%1] %2= %3

// ------------------------------------------
#define GetGateData(%0,%1)			g_gate[%0][%1]
#define SetGateData(%0,%1,%2)		g_gate[%0][%1] = %2
#define AddGateData(%0,%1,%2,%3)	g_gate[%0][%1] %2= %3

// ------------------------------------------
#define GetOrderData(%0,%1)			g_order[%0][%1]
#define SetOrderData(%0,%1,%2)		g_order[%0][%1] = %2
#define AddOrderData(%0,%1,%2,%3)	g_order[%0][%1] %2= %3

// ------------------------------------------
#define AntiFloodPlayerInit(%0) 			g_player_flood[%0] = g_flood_default_values

#define GetPlayerAntiFloodData(%0,%1) 		g_player_flood[%0][%1]
#define SetPlayerAntiFloodData(%0,%1,%2)	g_player_flood[%0][%1] = %2
#define AddPlayerAntiFloodData(%0,%1,%2,%3)	g_player_flood[%0][%1] %2= %3

// ------------------------------------------
#define GetPlayerPhoneBook(%0,%1,%2) 	g_player_phone_book[%0][%1][%2]
#define SetPlayerPhoneBook(%0,%1,%2,%3)	g_player_phone_book[%0][%1][%2] = %3

#define IsPlayerPhoneBookInit(%0) 			g_player_phone_book_init[%0]
#define SetPlayerPhoneBookInitStatus(%0,%1) g_player_phone_book_init[%0] = %1

#define GetPlayerPhoneBookContacts(%0) 		g_player_phone_book_contacts[%0]
#define SetPlayerPhoneBookContacts(%0,%1) 	g_player_phone_book_contacts[%0] = %1

#define GetPlayerPhoneBookSelectContact(%0) 		g_player_phone_book_select_cont[%0]
#define SetPlayerPhoneBookSelectContact(%0,%1) 		g_player_phone_book_select_cont[%0] = %1

// ------------------------------------------
#define GetPlayerPhoneCall(%0,%1) 		g_player_phone_call[%0][%1]
#define SetPlayerPhoneCall(%0,%1,%2)	g_player_phone_call[%0][%1] = %2

#define ClearPlayerPhoneCall(%0) g_player_phone_call[%0] = g_phone_call_default_values

// ------------------------------------------
#define GetPlayerOfferInfo(%0,%1) 		g_player_offer[%0][%1]
#define SetPlayerOfferInfo(%0,%1,%2) 	g_player_offer[%0][%1] = %2

#define SetPlayerOfferValue(%0,%1,%2) g_player_offer[%0][O_INCOMING_VALUE][%1] = %2
#define ClearPlayerOffer(%0) g_player_offer[%0] = g_offer_default_values

// ------------------------------------------
#define GetRepositoryData(%0,%1,%2) 	g_repository[%0][%1][%2]
#define SetRepositoryData(%0,%1,%2,%3)	g_repository[%0][%1][%2] = %3

// ------------------------------------------
#define GetPlayerListitemValue(%0,%1) 		g_player_listitem[%0][%1]
#define SetPlayerListitemValue(%0,%1,%2) 	g_player_listitem[%0][%1] = %2

#define ClearPlayerListitemValues(%0)		g_player_listitem[%0] = g_listitem_values

// ------------------------------------------
#define GetBankAccountData(%0,%1,%2)		g_bank_account[%0][%1][%2]
#define SetBankAccountData(%0,%1,%2,%3) 	g_bank_account[%0][%1][%2] = %3

#define GetPlayerUseListitem(%0) 		g_player_listitem_use[%0]
#define SetPlayerUseListitem(%0,%1) 	g_player_listitem_use[%0] = %1

#define GetPlayerBankTransfer(%0,%1) 	g_player_bank_transfer[%0][%1]
#define SetPlayerBankTransfer(%0,%1,%2)	g_player_bank_transfer[%0][%1] = %2

// ------------------------------------------
#define GetInfoPickupData(%0,%1) info_pickup[%0][%1]

// ------------------------------------------
#define GetTempJobInfo(%0,%1) g_temp_jobs[%0][%1]

// ------------------------------------------
#define GetMonthName(%0) 	month_name[%0 - 1]
#define GetDayName(%0) 		day_name[%0 - 1]

// ------------------------------------------
#define GetNumericName(%0)	numeric_name[%0 - 1]

// ------------------------------------------
#define GetATMInfo(%0,%1)	g_atm[%0][%1]

// ------------------------------------------
#define GetPlayerDrivingExamInfo(%0,%1) 	g_player_driving_exam[%0][%1]
#define SetPlayerDrivingExamInfo(%0,%1,%2) 	g_player_driving_exam[%0][%1] = %2
#define ClearPlayerDrivingExamInfo(%0) 		g_player_driving_exam[%0] = g_driving_exam_default_values

// ------------------------------------------
#define GetTeleportData(%0,%1)		g_teleport[%0][%1]
#define SetTeleportData(%0,%1,%2)	g_teleport[%0][%1] = %2

// ------------------------------------------
#define GetServerRadioData(%0,%1)	g_server_radio[%0][%1]
#define GetHelpInfoData(%0,%1) 		help_info[%0][%1]
#define GetAnimListData(%0,%1) 		anim_list[%0][%1]
#define GetMapIconsData(%0,%1) 		map_icons[%0][%1]

// ------------------------------------------
#define GetPlayerGPSInfo(%0,%1) 	g_player_gps[%0][%1]
#define SetPlayerGPSInfo(%0,%1,%2) 	g_player_gps[%0][%1] = %2

// ------------------------------------------
#define GetPlayerImprovementInfo(%0,%1) g_player_improvements[%0][%1]

// ------------------------------------------
#define GetPlayerPinCodeState(%0) 		pin_code_state[%0]
#define SetPlayerPinCodeState(%0,%1) 	pin_code_state[%0] = %1

#define GetPlayerPinCodeValue(%0,%1) 	pin_code_value[%0][%1]
#define SetPlayerPinCodeValue(%0,%1,%2)	pin_code_value[%0][%1] = %2

// ------------------------------------------
#define GetPlayerSettingData(%0,%1)		g_player_setting[%0][%1]
#define SetPlayerSettingData(%0,%1,%2)	g_player_setting[%0][%1] = %2
#define AddPlayerSettingData(%0,%1,%2)	g_player_setting[%0][%1] += %2

// ------------------------------------------
#define GetPlayerData(%0,%1) 	g_player[%0][%1]
#define SetPlayerData(%0,%1,%2)	g_player[%0][%1] = %2
#define AddPlayerData(%0,%1,%2,%3) g_player[%0][%1] %2= %3

#define GetPlayerAccountID(%0)	GetPlayerData(%0, P_ACCOUNT_ID) 	// �� ��������
#define GetPlayerIpEx(%0)		GetPlayerData(%0, P_IP) 			// �� ������
#define GetPlayerNameEx(%0)		GetPlayerData(%0, P_NAME) 			// ��� ������
#define GetPlayerColorEx(%0)	GetPlayerData(%0, P_COLOR)			// ���� ������
#define GetPlayerSelectSkin(%0)	GetPlayerData(%0, P_SELECT_SKIN) 	// �������� ����
#define GetPlayerSkinEx(%0)		GetPlayerData(%0, P_SKIN) 			// ���� ������
#define GetPlayerLevel(%0)		GetPlayerData(%0, P_LEVEL)			// ������� ������
#define GetPlayerExp(%0)		GetPlayerData(%0, P_EXP)			// ���� ����� ������
#define GetPlayerSuspect(%0)	GetPlayerData(%0, P_SUSPECT)		// ������� ������� ������
#define GetExpToNextLevel(%0)	((GetPlayerData(%0, P_LEVEL)+1)*4) 	// ����� ����� � ���������� ������
#define GetPlayerPhone(%0)		GetPlayerData(%0, P_PHONE)			// ����� �������� ������
#define GetPlayerSex(%0)		GetPlayerData(%0, P_SEX)			// ��� ������
#define GetPlayerSexName(%0)	GetPlayerData(%0, P_SEX) ? ("�������") : ("�������") // �������� ����
#define GetPlayerChatType(%0)	GetPlayerData(%0, P_CHAT_TYPE) 		// ��� ����
#define	GetPlayerAdminEx(%0)	GetPlayerData(%0, P_ADMIN) 			// ������� �������
#define GetPlayerMoneyEx(%0)	GetPlayerData(%0, P_MONEY) 			// ������ ������
#define GetPlayerBankMoney(%0)	GetPlayerData(%0, P_BANK) 			// ������ ������
#define GetPlayerAFKTime(%0)	GetPlayerData(%0, P_AFK_TIME) 		// ����� ���
#define GetPlayerLastVehicle(%0) GetPlayerData(%0, P_LAST_VEHICLE) 	// �� ���������� ���� � ������� �����
#define GetPlayerJobCar(%0)		GetPlayerData(%0, P_JOB_CAR) 		// ������� ���������
#define GetPlayerJob(%0)		GetPlayerData(%0, P_JOB) 			// ������
#define GetPlayerInBiz(%0)		GetPlayerData(%0, P_IN_BUSINESS) 	// � ����� ������ �����\���������
#define GetPlayerInHouse(%0)	GetPlayerData(%0, P_IN_HOUSE) 		// � ����� ���� �����\���������
#define GetPlayerTeamEx(%0)		GetPlayerData(%0, P_TEAM)			// ����������� � ������� ������� �����

#define GetPlayerInEntrance(%0)			GetPlayerData(%0, P_IN_ENTRANCE)		// � ����� ��������	
#define GetPlayerInEntranceFloor(%0)	GetPlayerData(%0, P_IN_ENTRANCE_FLOOR)	// �� ����� ����� � ��������

#define GetPlayerJobName(%0) 	job_name[GetPlayerData(%0, P_JOB)]

#define GetPlayerTempJob(%0) 			GetPlayerData(%0, P_TEMP_JOB) 		// ��������� ������
#define GetPlayerTempJobState(%0) 		GetPlayerData(%0, P_TEMP_JOB_STATE) // ��� ������
#define GetPlayerTempJobCheckAnim(%0)	GetPlayerData(%0, P_TEMP_JOB_CHECK) // �������� ������
#define GetPlayerJobLoadItems(%0) 		GetPlayerData(%0, P_JOB_LOAD_ITEMS) // ��������� (...)
#define GetPlayerJobWage(%0) 			GetPlayerData(%0, P_JOB_WAGE) 		// ��������

#define GetPlayerOwnableCar(%0)			GetPlayerData(%0, P_OWNABLE_CAR)	// �� ������� ��
#define GetPlayerUseTrunk(%0)			GetPlayerData(%0, P_USE_TRUNK)		// �� ���� ������������� ���������

#define SetPlayerUseTrunk(%0,%1)			SetPlayerData(%0, P_USE_TRUNK,	%1)	// ���������� �� ���� ������������� ���������
#define SetPlayerLogged(%0,%1)				SetPlayerData(%0, P_LOGGED, %1) 	// ���������� ������ �����������
#define SetPlayerChatType(%0,%1)			SetPlayerData(%0, P_CHAT_TYPE, %1) 	// ���������� ��� ����

#define SetPlayerInBiz(%0,%1)				SetPlayerData(%0, P_IN_BUSINESS, %1)	// ���������� ��� � ������� ���������
#define SetPlayerInHouse(%0,%1)				SetPlayerData(%0, P_IN_HOUSE, %1)		// ���������� ��� � ������� ���������

#define SetPlayerInEntrance(%0,%1)			SetPlayerData(%0, P_IN_ENTRANCE, %1)		// ���������� ������� � ������� ���������
#define SetPlayerInEntranceFloor(%0,%1)		SetPlayerData(%0, P_IN_ENTRANCE_FLOOR, %1)  // ���������� ���� � ������� ������� ���������

#define SetPlayerTempJob(%0,%1) 			SetPlayerData(%0, P_TEMP_JOB, %1) 		// ��������� ������
#define SetPlayerTempJobState(%0,%1) 		SetPlayerData(%0, P_TEMP_JOB_STATE, %1)	// ��� ������
#define SetPlayerTempJobCheckAnim(%0,%1)	SetPlayerData(%0, P_TEMP_JOB_CHECK, %1) // �������� ������
#define SetPlayerJobLoadItems(%0,%1) 		SetPlayerData(%0, P_JOB_LOAD_ITEMS, %1)	// ��������� (...)

#define IsPlayerLogged(%0)		GetPlayerData(%0, P_LOGGED)		// ������ �����������
#define IsPlayerUseAnim(%0)		GetPlayerData(%0, P_USE_ANIM)	// ���������� �� ������ (/anim)
#define IsPlayerInJob(%0)		GetPlayerData(%0, P_IN_JOB)		// �� ������ ��
#define IsPlayerAFK(%0)			(GetPlayerData(%0, P_AFK_TIME) >= 5) // ��� �� �����

// ------------------------------------------
#define GetHouseTypeInfo(%0,%1)		g_house_type[%0][%1]
#define SetHouseTypeInfo(%0,%1,%2)	g_house_type[%0][%1] = %2

#define GetHouseData(%0,%1)			g_house[%0][%1]
#define SetHouseData(%0,%1,%2)		g_house[%0][%1] = %2
#define AddHouseData(%0,%1,%2,%3)	g_house[%0][%1] %2= %3
	
#define IsHouseOwned(%0)			(GetHouseData(%0, H_OWNER_ID) > 0) // ������ �� ���

// ------------------------------------------
#define GetHouseRenterInfo(%0,%1,%2) 		g_house_renters[%0][%1][%2]
#define SetHouseRenterInfo(%0,%1,%2,%3) 	g_house_renters[%0][%1][%2] = %3
#define AddHouseRenterInfo(%0,%1,%2,%3,%4)	g_house_renters[%0][%1][%2] %3= %4

#define GetHouseRentersCount(%0)			g_house_renters_count[%0]
#define SetHouseRentersCount(%0,%1)			g_house_renters_count[%0] = %1
#define AddHouseRentersCount(%0,%1,%2)		g_house_renters_count[%0] %1= %2

#define IsHouseRoomOwned(%0,%1)				(GetHouseRenterInfo(%0, %1, HR_OWNER_ID) > 0)

// ------------------------------------------
#define GetBusinessInteriorInfo(%0,%1)	 	g_business_interiors[%0][%1]
#define SetBusinessInteriorInfo(%0,%1,%2) 	g_business_interiors[%0][%1] = %2

#define GetBusinessData(%0,%1) 			g_business[%0][%1]
#define SetBusinessData(%0,%1,%2) 		g_business[%0][%1] = %2
#define AddBusinessData(%0,%1,%2,%3) 	g_business[%0][%1] %2= %3

#define IsBusinessOwned(%0)				(GetBusinessData(%0, B_OWNER_ID) > 0)

#define GetBusinessGPSInfo(%0,%1)		g_business_gps[%0][%1]
#define SetBusinessGPSInfo(%0,%1,%2)	g_business_gps[%0][%1] = %2
#define AddBusinessGPSInfo(%0,%1,%2,%3) g_business_gps[%0][%1] %2= %3

// ------------------------------------------
#define GetFuelStationData(%0,%1)		g_fuel_station[%0][%1]
#define SetFuelStationData(%0,%1,%2)	g_fuel_station[%0][%1] = %2
#define AddFuelStationData(%0,%1,%2,%3)	g_fuel_station[%0][%1] %2= %3

#define IsFuelStationOwned(%0)			(GetFuelStationData(%0, FS_OWNER_ID) > 0) // ������� �� ��������

// ------------------------------------------
stock Float: GetAngleToPoint(Float:x1, Float:y1, Float:x2, Float:y2) 
{
	return atan2(y1-y2, x1-x2)-90.0;
}

// ------------------------------------------
enum E_PLAYER_STRUCT // ��������� ������
{
	P_ACCOUNT_ID, 	// �� ��������
	P_REFER,		// �����
	P_SEX,			// ��� ������
	P_PASSWORD[16], // ������ ������
	P_EMAIL[60 + 1],// ����� ������
	bool: P_CONFIRM_EMAIL,// ����������� �� �����
	P_SKIN,			// ���� ������
	P_MONEY,		// ������ ������
	P_BANK,			// ������ � �����
	P_ADMIN,		// ������� ������� 
	P_DRIVING_LIC,	// �������� �� ���������� ����
	P_WEAPON_LIC,	// �������� �� ������
	P_REG_TIME,		// ����� �����������
	P_REG_IP[16],	// �� ��� �����������
	P_LAST_IP[16],	// �� ��� ��������� �����
	P_LEVEL,		// ������� ������
	P_EXP,			// ���� ����� ������
	P_SUSPECT,		// ������� �������
	P_PHONE,		// ����� ��������
	P_PHONE_BALANCE,// �� ����� ��������
	P_PHONE_COLOR,	// ���� ��������
	P_LAW_ABIDING,	// �����������������
	P_IMPROVEMENTS, // ��������� 
	P_POWER,		// ����
	P_DRUGS,		// ���������
	P_AMMO,			// �������
	P_METALL,		// ������
	P_WIFE,			// ����
	P_TEAM,			// �����������
	P_SUBDIVISON,	// �������������
	P_WAGE,			// ��������
	P_JOB,			// ������ / ���������(����) 
	P_HOUSE_TYPE,	// ��� ����� (���/�����/� ������)
	P_HOUSE_ROOM,	// ������� � ����
	P_HOUSE,		// ���
	P_BUSINESS,		// ������
	P_FUEL_ST,	 	// ��������
	P_SETTING_PHONE[13],// �������� ������� ������
	P_SETTING_PIN[5], 	// ��� ���
	P_REQUEST_PHONE,	// ������ �������� ��� �����������
	P_REQUEST_PIN,		// ������ ��� ���� ��� �����������
	// -------------------------
	P_LAST_LOGIN_TIME,	// ����� ���������� �����\������ 
	// -------------------------
	P_GAME_FOR_HOUR,	// ����� ���� �� ���
	P_GAME_FOR_DAY,		// ����� ���� �� ����
	P_GAME_FOR_DAY_PREV,// ����� ���� �� ��������� ����
	// -------------------------
	P_COLOR,		// ���� ������
	P_SELECT_SKIN, 	// �������� ����
	P_CHAT_TYPE,	// ��� ����
	P_AFK_TIME,		// ����� ���
	P_LAST_VEHICLE,	// �� ���������� ���� � ������� �����
	P_LAST_DIALOG,	// �� ���������� �������
	P_USE_ANIM_TYPE,// ��� ������ ������� ����������
	P_PASS_ATTEMPS, // ���-�� ������� �� �����������
	P_TARGET_ID,	// ������� �� ������
	Float: P_HEALTH,// �� ������
	// -------------------------
	P_TEMP_JOB,				// ��������� ������
	P_TEMP_JOB_STATE,		// �������� ��� ���� ������
	P_TEMP_JOB_CHECK,		// �������� ������
	// -------------------------
	P_JOB_SERVICE_NAME[17],	// �������� ������
	P_JOB_TARIFF,			// �����
	P_JOB_WAGE,				// ��������
	P_JOB_LOAD_ITEMS,		// ���������/���������� (�����/����)
	P_JOB_CAR,				// ������� ���������
	P_END_JOB_TIMER,		// ������ ��������� ������
	P_FACTORY_USE_DESK,		// ����� ���� ���������� �� ������
	P_BUS_ROUTE, 			// ������� ��������
	P_BUS_ROUTE_STEP,		// ��� ��������
	P_MECHANIC_FILL_PAY,	// ���������� �� N ���
	P_MECHANIC_REPAIR_PAY,	// ��������������� �� N ��� 
	bool: P_IN_JOB,			// �� ������ ��
	// -------------------------
	bool: P_LOGGED,				// ������ �����������
	bool: P_USE_ANIM,			// ���������� �� ������ (/anim)
	bool: P_BLOCK_LEAVE_AREA, 	// ������������� ����� OnPlayerLeaveDynamicArea
	bool: P_ANIMS_INIT,			// ���������� �� ������ ��� ������
	bool: P_ANIM_LIST_INIT,		// ��������� �� ��������
	bool: P_SNACK,				// ���� �� � ������ �������
	// -------------------------
	P_AUTH_TIME,		// ����� �� ����������
	P_IN_BUSINESS,		// � ����� ������ �����
	P_IN_HOUSE,			// � ����� ��� �����
	P_IN_ENTRANCE,		// � ����� ��������
	P_IN_ENTRANCE_FLOOR,// �� ����� ����� � ��������
	P_LAST_PICKUP,		// �� ������ �� ������� ����� ��������� ���
	P_IN_HOTEL_ROOM,	// � ����� ������ � �����
	P_IN_HOTEL_FLOOR,	// �� ����� ����� � �����
	P_MED_CHEST,		// �������
	P_MASK,				// �����
	P_LOTTERY,			// ���������� �����
	P_DRINK_STEP,		// ���-�� ������������� �������
	P_REALTOR_TYPE,		// ���������
	P_USE_SELECT_PANEL,	// ���������� �� ������ ������
	P_OWNABLE_CAR,		// �� ������� ��
	P_USE_TRUNK,		// �� ���� ������������� ���������
	// -------------------------
	P_IP[16], 		// �� ������
	P_NAME[20 + 1], // ��� ������
	P_WIFE_NAME[21],// ��� ����
	// -------------------------
	P_ACCOUNT_STATE, 		// ������ �������� (����������/�����������)
	P_ACCOUNT_STEP_STATE, 	// ��� (�����������/�����������)
};
	
// ------------------------------------------
enum E_OWNABLE_CAR_STRUCT
{
	OC_SQL_ID, 			// �� � ����
	OC_OWNER_ID,		// �� ���������
	OC_OWNER_NAME[21],	// ��� ���������
	OC_NUMBER[8],		// ����� ��
	OC_MODEL_ID,		// ������
	OC_COLOR_1,			// ���� 1
	OC_COLOR_2,			// ���� 2	
	Float: OC_POS_X,	// ������� ��
	Float: OC_POS_Y,	// ������� ��
	Float: OC_POS_Z,	// ������� ��
	Float: OC_ANGLE,	// ������� �� (���� ��������)
	bool: OC_ALARM,		// ������������
	bool: OC_KEY_IN,	// �������� �� ����
	Float: OC_CREATE	// ����� ��������
};

// ------------------------------------------
enum E_VEHICLE_TRUNK_STRUCT
{
	VT_SQL_ID, 
	VT_ITEM_TYPE, 		// ��� ��������
	VT_ITEM_AMOUNT,		// ���-��
	VT_ITEM_VALUE
};

// ------------------------------------------
enum E_ITEM_STRUCT
{
	I_NAME[16],
	I_NAME_COUNT[8],
	bool: I_COMBINATION
};

// ------------------------------------------
enum E_ENTRANCE_STRUCT
{
	E_SQL_ID,		// �� � ����
	E_CITY, 		// �����
	E_ZONE, 		// ����� / �����
	E_FLOORS,		// ���-�� ������
	Float: E_POS_X, // ���� (�����)
	Float: E_POS_Y, // ���� (�����)
	Float: E_POS_Z, // ���� (�����)
	Float: E_EXIT_POS_X,// �����
	Float: E_EXIT_POS_Y,// �����
	Float: E_EXIT_POS_Z,// �����
	Float: E_EXIT_ANGLE,// ����� (����)
	E_PICKUP_ID,		// �� ������
	E_MAP_ICON,			// ������ �� �����
	Text3D: E_LABEL,	// 3� �����
	E_STATUS			// ������ (������� �� ��� ��������)
};

// ------------------------------------------
enum E_HOTEL_STRUCT
{
	H_SQL_ID,
	H_OWNER_ID,
	H_RENT_DATE,
	bool: H_STATUS,
	H_OWNER_NAME[21]
};

enum E_HOTEL_CAR_PARK_STRUCT
{
	Float: HC_POS_X,
	Float: HC_POS_Y,
	Float: HC_POS_Z,
	Float: HC_ANGLE,
	HC_VEHICLE_ID
};

// ------------------------------------------
enum E_HOUSE_STRUCT
{
	H_SQL_ID,			// �� � ���� ������
	H_NAME[20],			// �������� \ ���
	H_OWNER_ID,			// �� �������� ���������
	H_CITY,				// �� ������
	H_ZONE,				// �� ������
	H_IMPROVEMENTS,		// ������� ���������
	H_RENT_DATE,		// ������ �� n �������
	H_PRICE,			// ��������� ����
	H_RENT_PRICE,		// ����� �� ������ � ����
	H_LOCK_STATUS,		// ������ (�������/�������)
	H_ENTRACE,			// �� ��������
	H_TYPE,				// ��� ���� (��������)
	Float: H_POS_X,		// ������� ������ �����
	Float: H_POS_Y,		// ������� ������ �����
	Float: H_POS_Z,		// ������� ������ �����
	Float: H_EXIT_POS_X,// ������� ����� ������ �� ����
	Float: H_EXIT_POS_Y,// ������� ����� ������ �� ����
	Float: H_EXIT_POS_Z,// ������� ����� ������ �� ����
	Float: H_EXIT_ANGLE,// ���� ��������
	Float: H_CAR_POS_X,	// ������� ����������
	Float: H_CAR_POS_Y,	// ������� ����������
	Float: H_CAR_POS_Z,	// ������� ����������
	Float: H_CAR_ANGLE,	// ���� �������� ����������
	Float: H_STORE_X,	// ������� �����
	Float: H_STORE_Y,	// ������� �����
	Float: H_STORE_Z,	// ������� �����
	// -------------------------
	H_OWNER_NAME[20 + 1],	// ��� ���������
	Text3D: H_STORE_LABEL,	// 3� ����� (����)
	H_ENTER_PICKUP,			// ����� �����
	H_HEALTH_PICKUP,		// ����� �������
	H_MAP_ICON,				// ������ �� �����
	H_FLAT_ID				// ����� ��������
};

enum E_HOUSE_TYPE_STRUCT
{
	HT_NAME[20],
	Float: HT_ENTER_POS_X,		// ������� ����� ����� � ���������
	Float: HT_ENTER_POS_Y,		// ������� ����� ����� � ���������
	Float: HT_ENTER_POS_Z,		// ������� ����� ����� � ���������
	Float: HT_ENTER_POS_ANGLE,	// ������� ����� ����� � ���������
	Float: HT_HEALTH_POS_X,		// ������� �������
	Float: HT_HEALTH_POS_Y,		// ������� �������
	Float: HT_HEALTH_POS_Z,		// ������� �������
	Float: HT_STORE_POS_X,		// ������� �����
	Float: HT_STORE_POS_Y,		// ������� �����
	Float: HT_STORE_POS_Z,		// ������� �����
	HT_INTERIOR,				// �� ���������
	HT_ROOMS					// ���-�� ������
};

enum E_HOUSE_ROOM_STRUCT
{
	HR_SQL_ID,			// �� � ���� 
	HR_OWNER_ID,		// �� ������
	HR_RENT_DATE,		// ��������� ���������� �������
	HR_RENT_TIME,		// ����� ���������
	HR_OWNER_NAME[21]	// ��� ����������
};

enum // ���������� �����
{
	HOUSE_OPERATION_PARAMS, 		// ��������� ���������� ����
	HOUSE_OPERATION_LOCK,			// ������� / �������
	HOUSE_OPERATION_IMPROVEMENTS,	// ��������� 
	HOUSE_OPERATION_CAR_DELIVERY,	// ��������� �� � ����
	HOUSE_OPERATION_CAR_GPS,		// �������� ��������� �� GPS
	HOUSE_OPERATION_RENTERS			// ������ �����������
}

// ------------------------------------------
enum E_BUSINESS_STRUCT
{
	B_SQL_ID,			// �� � ���� ������
	B_NAME[24],			// ��������
	B_OWNER_ID,			// �� �������� ���������
	B_CITY,				// �� ������
	B_ZONE,				// �� ������
	B_ENTER_PRICE,		// ���� �� ���� � ���
	B_ENTER_MUSIC,		// ���� ��� �����
	B_IMPROVEMENTS,		// ������� ���������
	B_PRODS,			// ���������� ���������
	B_PROD_PRICE,		// ��������� 1 ��������
	B_BALANCE,			// ������ �������
	B_RENT_DATE,		// ������ �� n �������
	B_PRICE,			// ��������� �������
	B_RENT_PRICE,		// ����� �� ������ � ����
	B_LOCK_STATUS,		// ������ (�������/�������)
	B_TYPE,				// ��� �������
	B_INTERIOR,			// ��������
	Float: B_POS_X,		// ������� �������
	Float: B_POS_Y,		// ������� �������
	Float: B_POS_Z,		// ������� �������
	Float: B_EXIT_POS_X,// ������� ����� ������ �� �������
	Float: B_EXIT_POS_Y,// ������� ����� ������ �� �������
	Float: B_EXIT_POS_Z,// ������� ����� ������ �� �������
	Float: B_EXIT_ANGLE,// ���� ��������
	// -------------------------
	B_OWNER_NAME[20 + 1],	// ��� ���������
	Text3D: B_LABEL,		// 3� �����
	B_ORDER_ID,				// ���� ������
	B_HEALTH_PICKUP,		// �� ������ �������
};

enum // ���� ��������
{
	BUSINESS_TYPE_SHOP_24_7 = 1, 	// ������� 24/7
	BUSINESS_TYPE_CLUB = 2, 		// ���� (��������)
	BUSINESS_TYPE_REALTOR_BIZ = 3, 	// ���������� ���������� (�������)
	BUSINESS_TYPE_REALTOR_HOME = 4,	// ����������� �������� (����)
	BUSINESS_TYPE_CLOTHING_SHOP = 5,// ������� ������
	BUSINESS_TYPE_HOTEL = 6,		// �����
};

enum //
{
	BIZ_OPERATION_PARAMS = 0,		// ���������� ���������
	BIZ_OPERATION_LOCK,				// ������� / �������
	BIZ_OPERATION_ENTER_PRICE,		// ���������� ���� �� ����
	BIZ_OPERATION_PROD_PRICE,		// ���������� ��������� ��������
	BIZ_OPERATION_PROD_ORDER,		// �������� ��������
	BIZ_OPERATION_PROD_ORDER_CANCEL,// �������� �����
	BIZ_OPERATION_PROFIT_STATS,		// ���������� ����������	
	BIZ_OPERATION_IMPROVEMENTS		// ���������	
};

enum E_BUSINESS_INTERIOR_STRUCT
{
	Float: BT_EXIT_POS_X, 	// ������� ������ ������
	Float: BT_EXIT_POS_Y, 	// ������� ������ ������
	Float: BT_EXIT_POS_Z, 	// ������� ������ ������
	// -------------------
	Float: BT_ENTER_POS_X, 	// ������� �����
	Float: BT_ENTER_POS_Y, 	// ������� �����
	Float: BT_ENTER_POS_Z, 	// ������� �����
	Float: BT_ENTER_ANGLE, 	// ���� ��������
	BT_ENTER_INTERIOR,		// ��������
	// -------------------
	Float: BT_HEALTH_POS_X,	// ������� �������
	Float: BT_HEALTH_POS_Y,	// ������� �������
	Float: BT_HEALTH_POS_Z,	// ������� �������
	// -------------------
	Float: BT_BUY_POS_X, 	// ������� �������
	Float: BT_BUY_POS_Y, 	// ������� �������
	Float: BT_BUY_POS_Z, 	// ������� �������
	// -------------------
	Float: BT_LABEL_POS_X,	// ������� 3� ������
	Float: BT_LABEL_POS_Y,	// ������� 3� ������
	Float: BT_LABEL_POS_Z,	// ������� 3� ������
	BT_BUY_CHECK_ID			// �� ���������
}; 

enum E_BUSINESS_GPS_STRUCT // ������ �������� � GPS
{
	BG_SQL_ID,
	BG_BIZ_ID,
	BG_POS,
	BG_TIME
};

// ------------------------------------------

enum E_FUEL_STATION_STRUCT
{
	FS_SQL_ID,			// �� � ���� ������
	FS_NAME[20],		// ��������
	FS_OWNER_ID,		// �� �������� ���������
	FS_CITY,			// �� ������
	FS_ZONE,			// �� ������
	FS_IMPROVEMENTS,	// ������� ���������
	FS_FUELS,			// ���������� �������
	FS_FUEL_PRICE,		// ���� ������� �� 1 � 
	FS_BUY_FUEL_PRICE,	// ���������� ���� �� 1 �
	FS_BALANCE,			// ������ ��������
	FS_RENT_DATE,		// ������ �� n �������
	FS_PRICE,			// ��������� ��������
	FS_RENT_PRICE,		// ����� �� ������ � ����
	FS_LOCK_STATUS,		// ������ (�������/�������)
	Float: FS_POS_X,	// ������� ��������	
	Float: FS_POS_Y,	// ������� ��������
	Float: FS_POS_Z,	// ������� ��������
	// -------------------------
	FS_OWNER_NAME[20 + 1],	// ��� ���������
	Text3D: FS_LABEL,		// 3� �����
	FS_ORDER_ID,			// ���� ������
	FS_AREA					// ����
};

enum //
{
	FUEL_ST_OPERATION_PARAMS = 0,		// ���������� ���������
	FUEL_ST_OPERATION_LOCK,				// ������� / �������
	FUEL_ST_OPERATION_NEW_NAME,			// ����� ��������
	FUEL_ST_OPERATION_FUEL_PRICE,		// ���������� ���� �� �������
	FUEL_ST_OPERATION_BUY_FUEL_PRIC,	// ���������� ���������� ���� �������
	FUEL_ST_OPERATION_FUEL_ORDER,		// �������� �������
	FUEL_ST_OPERATION_FUEL_ORDER_CA, 	// �������� �����
	FUEL_ST_OPERATION_PROFIT_STATS,		// ���������� ����������	
	FUEL_ST_OPERATION_IMPROVEMENTS		// ���������	
};

// ------------------------------------------
enum E_WEATHER_STRUCT
{
	W_NAME[16],
	W_ID,
	W_DEGREES
};

// ------------------------------------------
enum E_ORDER_STRUCT
{
	O_SQL_ID, 		// �� ������
	O_TYPE,			// ��� (���,���)
	O_COMPANY_ID,	// �� �����������
	O_AMOUNT,		// ���-��
	O_PRICE,		// ���� �� 1 (�������/� �������/...)
	O_TIME,			// ����� ����������
	O_USED			// ����������� ��
};

enum 
{
	ORDER_TYPE_FUEL_STATION = 1, // ��������
	ORDER_TYPE_BUSINESS 		// ������
};

// ------------------------------------------
// 			������ ���������

enum E_PLAYER_SETTINGS_STRUCT 
{
	S_CHAT_TYPE,	// ��� ���� (��������,��������,Advance)
	S_TEAM_CHAT,	// ����������� ���� �����������
	S_PLAYERS_NICK,	// ����������� ����� ��� ��������
	S_NICK_IN_CHAT,	// ����������� ����� � ����
	S_ID_IN_CHAT,	// ����������� �� ������ � ����
	S_VEH_CONTROL	// ���������� ����������� (������� � �������/�������)
};

enum
{
	SETTING_CHAT_OFF = 0,
	SETTING_CHAT_STANDART,
	SETTING_CHAT_ADVANCE,
	SETTING_TYPE_OFF = 0,
	SETTING_TYPE_ON
};

// ------------------------------------------
enum E_IMPROVEMENTS_STRUCT
{
	I_NAME[32],
	I_PRICE,
	I_LEVEL
};

// ------------------------------------------
enum E_PLAYER_GPS_STRUCT
{
	bool: G_ENABLED,
	Float: G_POS_X,
	Float: G_POS_Y,
	Float: G_POS_Z
};

enum E_GPS_STURCT
{
	Float: G_POS_X,
	Float: G_POS_Y,
	Float: G_POS_Z,
	G_MARKET_TYPE
};

// ------------------------------------------
enum E_HELP_INFO_STRUCT
{
	H_TITLE[64],
	H_INFO[1024]
};

// ------------------------------------------
enum E_SERVER_RADIO_STRUCT
{
	SR_CHANNEL_NAME[32],
	SR_CHANNEL_URL[64]
};

// ------------------------------------------
enum E_ANIM_LIST_STRUCT
{
	AL_DESCRIPTION[32],
	AL_LIB[32],
	AL_NAME[32],
	Float: AL_DELTA,
	AL_LOOP,
	AL_LOCK_X,
	AL_LOCK_Y,
	AL_FREEZE,
	AL_TIME
};

// ------------------------------------------
enum E_MAP_ICONS_STRUCT 
{
	Float: MI_POS_X,
	Float: MI_POS_Y,
	Float: MI_POS_Z,
	MI_TYPE
};

// ------------------------------------------
enum E_TELEPORT_STRUCT
{
	T_NAME[64],
	Float: T_PICKUP_POS_X,
	Float: T_PICKUP_POS_Y,
	Float: T_PICKUP_POS_Z,
	T_PICKUP_VIRTUAL_WORLD,
	Float: T_POS_X,
	Float: T_POS_Y,
	Float: T_POS_Z,
	Float: T_ANGLE,
	T_INTERIOR,
	T_VIRTUAL_WORLD,
	T_ACTION_TYPE,
	Text3D: T_LABEL
};

enum // ���� ���������
{
	T_ACTION_TYPE_BLOCK_LEAVE_AREA = 1, // ������������� ����� ������� OnPlayerLeaveDynamicArea
	T_ACTION_TYPE_END_JOB,	// ����������� ������ �� ��������� ������ ���� ������� �� ����
};

// ------------------------------------------
enum E_DRIVING_TUTORIAL_STRUCT
{
	DT_TITLE[64],
	DT_INFO[2048]
};

enum E_PLAYER_DRIVING_EXAM_STRUCT
{
	DE_POINTS, // ����
	DE_EXAM_STEP, // ������
	DE_ROUTE_STEP // ��������
};

// ------------------------------------------
enum E_DRIVING_EXAM_STRUCT
{
	DE_TITLE[64],
	DE_LIST_ITEMS[256],
	DE_CORRECT_ANSWER
};

// ------------------------------------------
enum E_ATM_STRUCT
{
	Float: A_POS_X,
	Float: A_POS_Y,
	Float: A_POS_Z,
	Float: A_ROT_Z
};

// ------------------------------------------
enum E_GATE_STRUCT
{
	G_DESCRIPTION[16],	// �������� (������. ��-�����/��-�����)
	G_TYPE,				// ��� (��������,������)
	Float: G_POS_X,		// �������
	Float: G_POS_Y,		// �������
	Float: G_POS_Z,		// �������
	Float: G_ANGLE,		// ����
	Float: G_OPEN_POS_X, // ������� ��������
	Float: G_OPEN_POS_Y, // ������� ��������
	Float: G_OPEN_POS_Z, // ������� ��������
	Float: G_OPEN_ANGLE, // ���� �������� (��� ������)
	bool: G_STATUS,		// ������
	G_OBJECT_ID[2]		// ��� ��������
};

enum 
{
	GATE_TYPE_BARRIER = 1,		// ��������
	GATE_TYPE_BARRIER_MSG,		// �������� (� ����������)
	GATE_TYPE_BARRIER_BUTTON,	// �������� (�� ������)
	GATE_TYPE_NORMAL,	 		// ������
}

// ------------------------------------------
enum E_BANK_ACCOUNT_STRUCT
{
	BA_ID,
	BA_NAME[20 + 1],
	BA_PIN_CODE[9],
	BA_BALANCE,
	BA_REG_TIME
};

enum E_BANK_TRANSFER_STRUCT 
{
	BT_ID,
	BT_NAME[20 + 1]
};

// ------------------------------------------
enum E_PHONE_CALL_STRUCT
{
	PC_INCOMING_PLAYER,		// ��������� �����
	PC_OUTCOMING_PLAYER,	// �������� �����
	PC_TIME,				// ����� ������
	bool:PC_ENABLED		// ����� �������� (���\����)
};

// ------------------------------------------
enum E_PHONE_BOOK_STRUCT
{
	PB_SQL_ID,
	PB_NAME[21],
	PB_NUMBER[10],
	PB_TIME
};

enum 
{
	PHONE_BOOK_OPERATION_OPTIONS = 0,	// ��������
	PHONE_BOOK_OPERATION_CALL,			// ���������
	PHONE_BOOK_OPERATION_SEND_SMS,		// ��������� ���
	PHONE_BOOK_OPERATION_CHANGE_NAM,	// �������� ���
	PHONE_BOOK_OPERATION_CHANGE_NUM,	// �������� �����
	PHONE_BOOK_OPERATION_DELETE_CON,	// ������� �������
};
// ------------------------------------------
enum E_INFO_PICKUP_STRUCT
{
	IP_TITLE[64],
	IP_INFO[1024],
	IP_LABEL_INFO[64],
	IP_TITLE_COLOR,
	Float: IP_POS_X,
	Float: IP_POS_Y,
	Float: IP_POS_Z
};

// ------------------------------------------
enum E_MINER_CARRIAGE_STRUCT
{
	Float: MC_START_POS_X,
	Float: MC_START_POS_Y,
	Float: MC_START_POS_Z,
	Float: MC_END_POS_X,
	Float: MC_END_POS_Y,
	Float: MC_END_POS_Z,
	bool: MC_STATUS,
	MC_OBJECT_ID
};

// ------------------------------------------
enum E_FACTORY_DESK_STRUCT
{
	Float: FD_POS_X,
	Float: FD_POS_Y,
	Float: FD_POS_Z,
	FD_CHEK_ID,
	FD_OBJECT_ID,
	bool: FD_USED,
	Text3D: FD_LABEl
};

// ------------------------------------------
enum E_REPOSITORY_STRUCT
{
	R_AMOUNT, // ���-��
	Text3D: R_LABEL,
	Text3D: R_LABEL_2,
	bool: R_NOT_SAVE
};

enum // ���� �������
{
	REPOSITORY_TYPE_MINER, 		// �����	
	REPOSITORY_TYPE_FACTORY, 	// �����
	REPOSITORY_TYPE_OIL_FACTORY, // ����������
};

enum
{
	// �����
	REPOSITORY_ACTION_MINER_METAL = 0,	// ������ �����
	REPOSITORY_ACTION_MINER_ORE,		// ����
	REPOSITORY_ACTION_MINER_REMELTI,	// �� ����������
	
	// �����
	REPOSITORY_ACTION_FACTORY_METAL = 0, // ������ 
	REPOSITORY_ACTION_FACTORY_FUEL,		// �������
	REPOSITORY_ACTION_FACTORY_PROD,		// ��������
	
	// ����������
	REPOSITORY_ACTION_OIL_FACTORY_F = 0, // ������� �� ����������� 
};
new g_repository[3][3][E_REPOSITORY_STRUCT]; // ������

// ------------------------------------------
enum E_BUS_ROUTE_STRUCT
{
	BR_NAME[32],
	BR_COLOR,
	BR_IN_JOB
};

enum E_BUS_ROUTE_STEP_STRUCT
{
	Float: BRS_POS_X,
	Float: BRS_POS_Y,
	Float: BRS_POS_Z,
	bool: BRS_STOP
};

// ------------------------------------------
enum // ��� ��������
{
	INVALID_DIALOG_ID,
	// ---------------
	DIALOG_LOGIN,					// �����������
	DIALOG_REGISTER,				// �����������
	// ---------------
	DIALOG_PLAYER_MENU,  			// ���� ������
	DIALOG_PLAYER_STATS, 			// ���������� ������
	DIALOG_PLAYER_CMDS,  			// ������ ������ 
	DIALOG_PLAYER_SETTINGS,			// ������ ��������� 
	DIALOG_PLAYER_SECURITY_SETTINGS,// ��������� ������������
	// ---------------
	DIALOG_SECURITY_SETTING_INFO,	// ���������� � ����������
	DIALOG_SECURITY_SETTING_PHONE,	// ������ �������� ��� ����������� 
	DIALOG_SECURITY_SETTING_PHONE_S,// ���������� ������ �������� ��� ����������� 
	DIALOG_SECURITY_SETTING_PIN,	// ������ ��� ���� ��� ����������� 
	DIALOG_SECURITY_SETTING_PIN_SET,// ���������� ������ ��� ���� ��� ����������� 
	DIALOG_SECURITY_SETTING_PASS_1, // ����� ������ (�������� ��������)
	DIALOG_SECURITY_SETTING_PASS_2, // ����� ������ (�����)
	DIALOG_SECURITY_SETTING_EMAIL,	// ������������� ������
	// ---------------
	DIALOG_REPORT,					// ������
	// ---------------
	DIALOG_PLAYER_IMPROVEMENTS, 	// ���������
	// ---------------
	DIALOG_CHANGE_NAME, 			// ����� ����
	// ---------------
	DIALOG_GPS, 					// gps
	DIALOG_GPS_PUBLIC_PLACES, 		// ������������ �����
	DIALOG_GPS_TRANSPORT, 			// ������������ ����
	DIALOG_GPS_STATE_ORGANIZATIONS, // ��������������� �����������
	DIALOG_GPS_GANGS,				// ���� ���� � �����
	DIALOG_GPS_JOBS,				// �� ������
	DIALOG_GPS_BANKS,				// �� ������
	DIALOG_GPS_ENTERTAINMENT,		// �����������
	DIALOG_GPS_BUSINESS,			// ������� �������
	// ---------------
	DIALOG_HELP,					// ������ �� ����
	DIALOG_HELP_SECTION,			// ������ 
	// ---------------
	DIALOG_SERVER_RADIO, 			// ����� (/play)
	// ---------------
	DIALOG_ANIM_LIST, 				// ���� ���� (/anim) 
	// ---------------
	DIALOG_OPEN_HOOD_OR_TRUNK,		// ���������� �������/����������
	// ---------------
	DIALOG_DRIVING_TUTORIAL_START,	// ������ � ���������
	DIALOG_DRIVING_TUTORIAL,	 	// ������ � ���������
	DIALOG_DRIVING_TUTORIAL_END, 	// ������ � ���������
	DIALOG_DRIVING_EXAM_INFO, 		// ������� �� ��������
	DIALOG_DRIVING_EXAM_START,		// ������� �� ��������
	DIALOG_DRIVING_EXAM, 			// ������� �� ��������
	DIALOG_DRIVING_EXAM_RESULT, 	// ������� �� ��������
	// ---------------
	DIALOG_ATM, 					// ��������
	DIALOG_ATM_TAKE_MONEY, 			// ����� ������
	DIALOG_ATM_TAKE_OTHER_MONEY,	// ����� ������ (������ ����)
	DIALOG_ATM_PUT_MONEY, 			// �������� ������
	DIALOG_ATM_PUT_OTHER_MONEY, 	// �������� ������ (������ ����)
	DIALOG_ATM_BALANCE, 			// ������ � �����
	DIALOG_ATM_PHONE_BALANCE,		// ��������� ������ ��������

	DIALOG_ATM_SELECT_COMPANY_TAKE,	// ������� ����������� � �������� ����� ������
	DIALOG_ATM_SELECT_COMPANY_PUT,	// ������� ����������� �� ������� �������� ������
	DIALOG_ATM_FUEL_ST_TAKE_MONEY,	// ����� ������ � ����������� �������
	DIALOG_ATM_FUEL_ST_PUT_MONEY,	// �������� ������ �� ���� ����������� �������
	DIALOG_ATM_BIZ_TAKE_MONEY,		// ����� ������ � �����������
	DIALOG_ATM_BIZ_PUT_MONEY,		// �������� ������ �� ���� �����������
	
	DIALOG_ATM_TRANSFER_MONEY_1, 	// ������� �� ���������� ����
	DIALOG_ATM_TRANSFER_MONEY_2, 	// ������� �� ���������� ����
	DIALOG_ATM_CHARITY, 			// �������������������
	// ---------------
	DIALOG_PAY_FOR_RENT,			// ������ ������ (���,���,���)
	DIALOG_PAY_FOR_RENT_FUEL_ST,	// ������ �� ���
	DIALOG_PAY_FOR_RENT_BIZ,		// ������ �� ������
	DIALOG_PAY_FOR_RENT_HOUSE,		// ������ �� ���
	// ---------------
	DIALOG_BANK,					// ����
	DIALOG_BANK_ACCOUNTS, 			// ��� �����
	DIALOG_BANK_ACCOUNT_LOGIN, 		// ����������� 
	DIALOG_BANK_ACCOUNT_OPERATION,	// ������ ��������
	DIALOG_BANK_ACCOUNT_INFO, 		// ���������� � �����
	DIALOG_BANK_ACCOUNT_TAKE_MONEY,	// ����� ������
	DIALOG_BANK_ACCOUNT_PUT_MONEY,	// �������� ������
	DIALOG_BANK_ACCOUNT_TRANSFER_1, // ������� ����� �� ������ ���� 1
	DIALOG_BANK_ACCOUNT_TRANSFER_2, // ������� ����� �� ������ ���� 2
	DIALOG_BANK_ACCOUNT_CHANGE_NAME,// ���������������� �����
	DIALOG_BANK_ACCOUNT_CHANGE_PIN,	// ����� ���-����
	
	DIALOG_BANK_CREATE_ACCOUNT, 	// �������� �����
	DIALOG_BANK_CREATED_ACCOUNT, 	// �������� �����
	// ---------------
	DIALOG_PHONE_CALL,				// ������ ��������������� �����������
	DIALOG_PHONE_CALL_BALANCE,		// ������ ������ ����������
	// ---------------
	DIALOG_ACTION,					// ���� ��������
	// ---------------
	DIALOG_VIEV_JOBS_LIST,			// ���������� ������ �����
	DIALOG_JOIN_TO_JOB,				// ��������� �� ������
	// ---------------
	DIALOG_END_JOB,					// ��������� ������
	// ---------------
	
	DIALOG_BUS_RENT_CAR,			// ���������� �������
	DIALOG_BUS_ROUTE_COST,			// ������ ��������� �������
	DIALOG_BUS_ROUTE_SELECTION,		// ������� �������
	//---
	DIALOG_TAXI_RENT_CAR,			// ���������� �����
	DIALOG_TAXI_NAME,				// �������� �����
	DIALOG_TAXI_TARIFF,				// �����
	//---
	DIALOG_MECHANIC_RENT_CAR,		// ���������� ���������
	DIALOG_MECHANIC_START_JOB,		// ������ ������ ��������
	DIALOG_MECHANIC_NAME,			// �������� ������
	
	// ---------------
	DIALOG_PHONE_BOOK,				// ���������� �����
	DIALOG_PHONE_BOOK_OPTION,		// ��������
	DIALOG_PHONE_BOOK_SEND_SMS,		// ��������� ���
	DIALOG_PHONE_BOOK_CHANGE_NAME,	// ������� ��� ��������
	DIALOG_PHONE_BOOK_CHANGE_NUMBER,// ������� ����� ��������
	
	DIALOG_PHONE_BOOK_ADD_CONTACT,	// ���������� ����� (�������� �������)
	// ---------------
	DIALOG_MINER_BUY_METALL, 		// ������� ������� �� �����
	// ---------------
	DIALOG_TEMP_JOB_LOADER_START,	// ������ ������ ��������
	DIALOG_TEMP_JOB_LOADER_END,		// ��������� ������ ��������
	DIALOG_TEMP_JOB_MINER_START,	// ������ ������ �������
	DIALOG_TEMP_JOB_MINER_END,		// ��������� ������ �������
	DIALOG_TEMP_JOB_FACTORY_TRUCKER,// ������ �������� ������
	DIALOG_TEMP_JOB_FACTORY,		// ���������������� ���
	// ---------------
	DIALOG_FUEL_STATION_BUY,		// ������� ����������� �������
	DIALOG_FUEL_STATION_INFO,		// ���� � ����������� �������
	DIALOG_FUEL_STATION_PARAMS,		// ���� ���������� ����������� ��������
	DIALOG_FUEL_STATION_NAME,		// ����� �������� 
	DIALOG_FUEL_STATION_PRICE_FUEL,	// ���� �������
	DIALOG_FUEL_STATION_BUY_FUEL_PR,// ���������� ����
	DIALOG_FUEL_STATION_ORDER_FUELS,// ����� �������
	DIALOG_FUEL_STATION_ORDER_CANCE,// ������ ������
	DIALOG_FUEL_STATION_IMPROVEMENT,// ��������� ���
	DIALOG_FUEL_STATION_SELL,		// ������� ��� �����������
	DIALOG_FUEL_STATION_BUY_JERRICA,// ������� �������� �� ���
	DIALOG_FUEL_STATION_BUY_FUEL_M,	// ������� ������� (�������)
	// ---------------
	DIALOG_JERRICAN_FILL_CAR,		// �������� ���� � ��������
	// ---------------
	DIALOG_BIZ_BUY,					// ������� �������
	DIALOG_BIZ_INFO,				// ���� � �������
	DIALOG_BIZ_PARAMS,				// ���� ���������� ��������
	DIALOG_BIZ_ENTER_PRICE,			// ���������� ���� �� ����
	DIALOG_BIZ_PROD_PRICE,			// ���������� ��������� ��������
	DIALOG_BIZ_ORDER_PRODS,			// ����� ���������
	DIALOG_BIZ_ORDER_CANCEL,		// ������ ������
	DIALOG_BIZ_IMPROVEMENT,			// ���������
	DIALOG_BIZ_SELL,				// ������� ������� �����������
	DIALOG_BIZ_ENTER_MUSIC,			// ���������� ���� ��� �����
	DIALOG_BIZ_ENTER,				// ������� ����
	
	DIALOG_BIZ_SHOP_24_7,			// ������� 24\7
	DIALOG_BIZ_CHANGE_PHONE_NUMBER,	// ����� ������ ��������
	DIALOG_BIZ_CHANGE_PHONE_COLOR,	// ����� ���� ��������
	DIALOG_BIZ_LOTTERY,				// �������
	
	DIALOG_BIZ_CLUB,				// ���� ���� (����)
	
	DIALOG_BIZ_REALTOR_BIZ_LIST,	// ������ ��������� �������� (���������� ����������)
	DIALOG_BIZ_REALTOR_BIZ_INFO,	// ���� �������
	
	DIALOG_BIZ_REALTOR_HOME_GET,	// ����� ���������� � ����
	DIALOG_BIZ_REALTOR_HOME_INFO,	// ���� ����
	
	DIALOG_BIZ_CLOTHING_BUY,		// ������� ������
	// ---------------
	DIALOG_HOUSE_BUY,				// ������� ����
	DIALOG_HOUSE_SELL,				// ������� ����
	DIALOG_HOUSE_INFO,				// ���� � ����
	DIALOG_HOUSE_PARAMS,			// ���� ���������� �����
	DIALOG_HOUSE_IMPROVEMENTS,		// ��������� ��� ����
	DIALOG_HOUSE_RENTERS,			// ������ �����������
	DIALOG_HOUSE_RENTER_INFO,		// ���������� � ����������
	DIALOG_HOUSE_RENTER_EVICT,		// ��������� ����������
	DIALOG_HOUSE_EVICT,				// ��������� ���������� (/liveout)
	DIALOG_HOUSE_MOVE_STORE,		// ����������� ���� (/makestore)
	
	DIALOG_HOUSE_ENTER,				// ���� � ���
	// ---------------
	DIALOG_ENTRANCE_LIFT,			// ���� ��������
	// ---------------
	DIALOG_HOTEL,					// ���� �����
	DIALOG_HOTEL_FLOOR_SELECT,		// ������� ���� (�������� ���� � �������)
	DIALOG_HOTEL_FLOOR_INFO,		// ���������� � ������� �����
	DIALOG_HOTEL_FLOOR_LIFT,		// ���� � �����
	DIALOG_HOTEL_REG_ROOM,			// ����������� � ������
	DIALOG_HOTEL_CLIENT_MENU,		// ���� �������
	DIALOG_HOTEL_PAY_FOR_ROOM,		// ������ �� �������
	DIALOG_HOTEL_OUT,				// ����������
	// ---------------
	DIALOG_OWNABLE_CAR,				// ������� ���������� �����������
	DIALOG_OWNABLE_CAR_SELL,		// ������� ������� ��
	// ---------------
	DIALOG_VEHICLE_TRUNK,			// ��������
	DIALOG_VEHICLE_TRUNK_PUT,		// �������� �������
};

// ------------------------------------------
enum // ��� ����� (�����������)
{
	JOB_BUS_DRIVER = 1, // �������� ��������
	JOB_TAXI_DRIVER,	// �������
	JOB_MECHANIC,		// �������
	JOB_TRUCKER			// ������������
};

// ------------------------------------------
enum // ���� �������
{
	PICKUP_ACTION_TYPE_TELEPORT = 1, 	// �������� (�����/������)
	PICKUP_ACTION_TYPE_DRIVING_TUTO, 	// ������ � ���������
	PICKUP_ACTION_TYPE_ATM,				// ��������
	PICKUP_ACTION_TYPE_BANK, 			// ����
	PICKUP_ACTION_TYPE_TEMP_JOB, 		// ��������� ������
	PICKUP_ACTION_TYPE_INFO_PICKUP, 	// ���� �����
	PICKUP_ACTION_TYPE_MINER_SELL_M, 	// ������� ������� �� �����
	PICKUP_ACTION_TYPE_FACTORY_MET,		// ����� ������ (�����)
	PICKUP_ACTION_TYPE_FUEL_STATION,	// ������� �������� �� ���
	PICKUP_ACTION_TYPE_BIZ_ENTER,		// ���� � ������
	PICKUP_ACTION_TYPE_BIZ_EXIT,		// ����� � ������
	PICKUP_ACTION_TYPE_BIZ_HEALTH,		// ������� � �������
	PICKUP_ACTION_TYPE_BIZ_SHOP_247,	// ������� � 24\7
	PICKUP_ACTION_TYPE_HOUSE,			// ���� � ���
	PICKUP_ACTION_TYPE_HOUSE_HEALTH,	// ������� ����
	PICKUP_ACTION_TYPE_REALTOR_HOME,	// ����������� ��������
	PICKUP_ACTION_TYPE_BIZ_CLOTHING,	// ������� ������
	PICKUP_ACTION_TYPE_ENTRANCE_ENT,	// ���� � �������
	PICKUP_ACTION_TYPE_ENTRANCE_EXI,	// ����� �� ��������
	PICKUP_ACTION_TYPE_ENTRANCE_LIF,	// ���� � ��������
	PICKUP_ACTION_TYPE_ENTRANCE_FLA,	// �������� � ��������
	PICKUP_ACTION_TYPE_HOTEL_ROOM,		// ����� � �����
};

enum // ���� ����
{
	VEHICLE_ACTION_TYPE_DRIVING_SCH = 1, // ������� ��������� (��� ����� �� �����)
	VEHICLE_ACTION_TYPE_OWNABLE_CAR,	// ������ ���������
	VEHICLE_ACTION_TYPE_LOADER, 		// ��������� � �����
	VEHICLE_ACTION_TYPE_FACTORY, 		// ����� (������ ��������)
	VEHICLE_ACTION_TYPE_BUS_DRIVER,		// �������� ��������
	VEHICLE_ACTION_TYPE_TAXI_DRIVER,	// �������
	VEHICLE_ACTION_TYPE_MECHANIC,		// �����������
	VEHICLE_ACTION_TYPE_TRUCKER,		// ������������
};

enum // ���� cp
{
	CP_ACTION_TYPE_LOADER_JOB_TAKE = 1,	// ������� (����� ����)
	CP_ACTION_TYPE_LOADER_JOB_PUT, 		// ������� (������ ����)
	// -------
	CP_ACTION_TYPE_MINER_JOB_TAKE, 		// ������ (����� ����)
	CP_ACTION_TYPE_MINER_JOB_PUT, 		// ������ (������ ����)
};

enum // ���� race_cp
{
	RCP_ACTION_TYPE_DRIVING_EXAM = 1, // ����� �� ����� (��������)
	RCP_ACTION_TYPE_BUS_ROUTE,	// �������� ��������
};

// ------------------------------------------
enum // ���� ������
{
	USE_ANIM_TYPE_NONE,
	USE_ANIM_TYPE_CHAT, // ������ ����
};

// ------------------------------------------
enum // ���� ��������
{
	OBJECT_TYPE_FACTORY = 1,
};

// ------------------------------------------
enum E_PLAYER_OFFER_STURCT
{
	O_OUTCOMIG_PLAYER,  // ����������� ����������� ������
	O_INCOMING_PLAYER, 	// �������� ����������� �� ������
	O_INCOMING_TYPE, 	// �������� �����������
	O_INCOMING_VALUE[2] // �������� ��������� �����������
};

enum // ���� �����������
{
	OFFER_TYPE_NONE = -1,
	OFFER_TYPE_HANDSHAKE, 		// �����������
	OFFER_TYPE_SELL_FUEL_ST, 	// ������� ���
	OFFER_TYPE_FILL_CAR,		// �������� ���� (�������) 
	OFFER_TYPE_REPAIR_CAR,		// ������� ���� (�������)
	OFFER_TYPE_SELL_BUSINESS,	// ������� �������
	OFFER_TYPE_BUSINESS_MANAGER,// ���������� ���������� ���� �� �����������
	OFFER_TYPE_SELL_HOME,		// ������� ��� ������
	OFFER_TYPE_HOME_RENT_ROOM,	// ���������� ���������� � ������� ������ ����
	OFFER_TYPE_SELL_OWNABLE_CAR,// ������� ������ ��
};

// ------------------------------------------
enum E_ANTI_FLOOD_STRUCT
{
	AF_LAST_TICK,
	AF_RATE
}

// ------------------------------------------
enum E_TEMP_JOB_STRUCT // ��������� ������
{
	Float: TJ_POS_X,
	Float: TJ_POS_Y,
	Float: TJ_POS_Z,
	TJ_PAY_FOR_LOAD, // ����� �� 1 ������� (����/�� ����)
	TJ_SKIN[2]		// ���� ������ (0 - �������, 1 - �������) 
};

enum E_LOADER_JOB_ATTACH_OBJ_STRUCT
{
	L_OBJECT,
	Float: L_POS_X,
	Float: L_POS_Y,
	Float: L_POS_Z,
	Float: L_ROT_X,
	Float: L_ROT_Z
};

// ------------------------------------------
enum // ��� ��������� �����
{
	TEMP_JOB_NONE = -1,
	// ----------------
	TEMP_JOB_LOADER = 0, 		// �������
	TEMP_JOB_MINER, 			// ������
	TEMP_JOB_FACTORY_TRUCKER,	// ����� (������ ��������)
	TEMP_JOB_FACTORY			// �����
};

enum //
{
	TEMP_JOB_STATE_NONE, 
	// --------
	TEMP_JOB_STATE_LOADER_LOAD, 	// ����� ����
	TEMP_JOB_STATE_LOADER_UNLOAD, 	// ������ ����
	TEMP_JOB_STATE_LOADER_DROP_LOAD,// ������ ����
	// --------
	TEMP_JOB_STATE_MINER_LOAD, 		// �������� ����
	TEMP_JOB_STATE_MINER_UNLOAD, 	// ����� �� �����
	TEMP_JOB_STATE_MINER_DROP_LOAD, // ������ ����
	// --------
	TEMP_JOB_STATE_FACTORY_TAKE_MET, // ����� ������
	TEMP_JOB_STATE_FACTORY_CREATE_P, // ������ �������
	TEMP_JOB_STATE_FACTORY_CREATED,  // ������ �������
	TEMP_JOB_STATE_FACTORY_PUT_PROD, // ����� ������� �� �����
	TEMP_JOB_STATE_FACTORY_DROP_P,	 // ������ �������
};

// ------------------------------------------
// attached object (TODO)
enum 
{
	A_OBJECT_SLOT_SPINE = 0, 		// ����
	A_OBJECT_SLOT_HEAD, 			// ������
	A_OBJECT_SLOT_ARM, 				// �����
	A_OBJECT_SLOT_HAND, 			// ����
	A_OBJECT_SLOT_THIGH, 			// �����
	A_OBJECT_SLOT_FOOT, 			// ����
	A_OBJECT_SLOT_CALF, 			// ������
	A_OBJECT_SLOT_FOREARM, 			// ����������
	A_OBJECT_SLOT_CLAVICLE,			// �������
	A_OBJECT_SLOT_NECK, 			// ���
	//A_OBJECT_SLOT_JAW				// �������
};

enum 
{
	A_OBJECT_BONE_SPINE = 1, 		// ����
	A_OBJECT_BONE_HEAD, 			// ������
	A_OBJECT_BONE_LEFT_ARM, 		// ����� �����
	A_OBJECT_BONE_RIGHT_ARM, 		// ������ �����
	A_OBJECT_BONE_LEFT_HAND, 		// ����� ����
	A_OBJECT_BONE_RIGHT_HAND, 		// ������ ����
	A_OBJECT_BONE_LEFT_THIGH, 		// ����� �����
 	A_OBJECT_BONE_RIGHT_THIGH,		// ������ �����
	A_OBJECT_BONE_LEFT_FOOT, 		// ����� ����
	A_OBJECT_BONE_RIGHT_FOOT, 		// ������ ����
	A_OBJECT_BONE_RIGHT_CALF, 		// ������ ������
	A_OBJECT_BONE_LEFT_CALF, 		// ����� ������
	A_OBJECT_BONE_LEFT_FOREARM, 	// ����� ����������
	A_OBJECT_BONE_RIGHT_FOREARM,	// ������ ����������
	A_OBJECT_BONE_LEFT_CLAVICLE,	// ����� ������� (�����)
	A_OBJECT_BONE_RIGHT_CLAVICLE,	// ������ ������� (�����)
	A_OBJECT_BONE_NECK, 			// ���
	A_OBJECT_BONE_JAW				// �������
};

// ------------------------------------------
enum // ���� �����������
{
	REGISTER_STATE_PASSWORD = 1, // ���� ������
	REGISTER_STATE_EMAIL, 		// ���� ������
	REGISTER_STATE_REFER, 		// ���� ���� ������������� ������
	REGISTER_STATE_SEX, 		// ����� ����
	REGISTER_STATE_RULES, 		// ������� �������
	REGISTER_STATE_CREATE_ACC 	// �������� ��������
};

enum // ���� �����������
{
	LOGIN_STATE_CHECK_BAN = 0,	// �������� ����
	LOGIN_STATE_PASSWORD, 		// ���� ������
	LOGIN_STATE_PHONE,			// ���� 5 ������. ���� ��������
	LOGIN_STATE_PIN_CODE,		// ���� ��� ����
	//LOGIN_STATE_GOOGLE_CODE,	// ���� ���� �� �����
	LOGIN_STATE_LOAD_ACC	 	// �������� ��������
};

// ------------------------------------------
new Text: server_logo_TD;	// ���� �������
new Text: gps_TD; 			// gps
new Text: anim_TD;			// anim list
new Text: speedometr_TD[2]; // ���������
new Text: wait_panel_TD[4];	// ��������� ��������
new Text: select_TD[8];	// ������ ������

new PlayerText: speedometr_PTD[MAX_PLAYERS][7]; // ���������
new PlayerText: price_select_TD[MAX_PLAYERS][2]; // ���� � ������ ������

// ------------------------------------------
new PlayerText:pin_code_PTD[MAX_PLAYERS][10];
new pin_code_value[MAX_PLAYERS][10];
new pin_code_state[MAX_PLAYERS] = {PIN_CODE_STATE_NONE, ...};
new pin_code_input[MAX_PLAYERS][5];

// ------------------------------------------
//new Menu: reg_select_skin_menu;

// ------------------------------------------
new g_player[MAX_PLAYERS][E_PLAYER_STRUCT];
new 
	g_player_default_values[E_PLAYER_STRUCT] = 
{
	0,		// �� ��������
	0,		// �����
	0,		// ��� ������
	"",		// ������ ������
	"None",	// ����� ������
	false, 	// ����������� �� �����
	0,		// ���� ������
	0,		// ������ ������
	0,		// ������ � �����
	ADMIN_TYPE_NONE, // ������� �������
	false,	// �������� �� ���������� ����
	false,	// �������� �� ������
	0,		// ����� �����������
	"255.255.255.255",	// �� ��� �����������
	"255.255.255.255",	// �� ��� ��������� �����
	1,		// ������� ������
	0,		// ���� ����� ������
	0,		// ������� �������
	0,		// ����� ��������
	0,		// �� ����� ��������
	0,		// ���� ��������
	0,		// �����������������
	0, 		// ��������� 
	0, 		// ����
	0,		// ���������
	0,		// �������
	0,		// ������
	0,		// ����
	0,		// �����������
	0,		// �������������
	0,		// ��������
	0,		// ������ / ���������(����) 
	HOUSE_TYPE_NONE, // ��� ����� (���/�����/� ������)
	-1,		// ������� � ����
	-1,		// ���
	-1,		// ������
	-1,	 	// ��������
	"None", // �������� ������� ������
	"None", // ��� ���
	REQUEST_TYPE_OFF, // ������ �������� ��� �����������
	REQUEST_TYPE_OFF, // ������ ��� ���� ��� �����������
	// -------------------------
	0,					// ����� ���������� �����\������ 
	// -------------------------
	0,					// ����� ���� �� ���
	0,					// ����� ���� �� ����
	0,					// ����� ���� �� ��������� ����
	// -------------------------
	0xFFFFFF11,			// ���� ������
	-1,					// �������� ����
	0,					// ��� ����
	0,					// ����� ���
	INVALID_VEHICLE_ID, // �� ���������� ���� � ������� �����
	INVALID_DIALOG_ID,	// �� ���������� �������
	USE_ANIM_TYPE_NONE,	// ��� ������ ������� ����������
	ENTER_PASSWORD_ATTEMPS,// ���-�� ������� �� �����������
	INVALID_PLAYER_ID,	// ������� �� ������
	100.0,				// �� ������
	// -------------------------
	TEMP_JOB_NONE,		// ��������� ������
	TEMP_JOB_STATE_NONE,// �������� ��� ���� ������
	false,				// �������� ������
	// ---------------------------------
	"",					// �������� ������
	0,					// �����
	0,					// ��������
	0,					// ���������/���������� (�����/����)
	INVALID_VEHICLE_ID,	// ������� ���������
	-1,					// ������ ��������� ������
	-1,					// ����� ���� ���������� �� ������
	0, 					// ������� ��������
	0,					// ��� ��������
	0,					// ���������� �� N 
	0,					// ��������������� �� N ���
	false,				// �� ������ ��
	// -------------------------
	false,				// ������ �����������
	false,				// ���������� �� ������ (/anim)
	false,				// ������������� ����� OnPlayerLeaveDynamicArea
	false,				// ���������� �� ������ ��� ������
	false,				// ��������� �� ��������
	false,				// ���� �� � ������ �������
	// -------------------------
	-1, 				// ����� �� ����������
	-1, 				// � ����� ������ �����
	-1, 				// � ����� ��� �����
	-1,					// � ����� ��������
	-1,					// �� ����� ����� � ��������
	-1,					// �� ������ �� ������� ����� ��������� ���
	-1,					// � ����� ������ � �����
	0,					// �� ����� ����� � �����
	0,					// �������
	0,					// �����
	0,					// ���������� �����
	0,					// ���-�� ������������� �������
	REALTOR_TYPE_NONE,	// ���������
	SELECT_PANEL_TYPE_NONE, // ���������� �� ������ ������
	INVALID_VEHICLE_ID,	// �� ������� ��
	INVALID_VEHICLE_ID,	// �� ���� ������������� ���������
	// -------------------------
	"255.255.255.255", 	// �� ������
	"", 				// ��� ������
	"�", 				// ��� ����/����
	// -------------------------
	ACCOUNT_STATE_NONE, // ������ �������� (����������/�����������)
	0 					// ��� (�����������/�����������)
};


new g_speed_line_update[MAX_PLAYERS] = {-1, ...};

new Float: g_taxi_mileage[MAX_PLAYERS] = {0.0, ...};

// ------------------------------------------
new g_ownable_car[MAX_OWNABLE_CARS][E_OWNABLE_CAR_STRUCT];
new g_ownable_car_loaded;

// ------------------------------------------
new g_vehicle_trunk[MAX_VEHICLES][MAX_VEHICLE_TRUNK_SLOTS][E_VEHICLE_TRUNK_STRUCT];

// ------------------------------------------
new g_hotel[MAX_HOTELS][MAX_HOTEL_ROOMS][E_HOTEL_STRUCT];
new g_hotel_rooms_loaded[MAX_HOTELS];
new g_hotel_loaded;

new g_hotel_lift_CP[2];

new const 
	Float: g_hotel_room_exit_pos[3][3] = 
{
	{1275.9808, -772.4982, 1202.7220},
	{1275.9808, -764.2992, 1202.7220},
	{1275.9808, -756.2681, 1202.7220}
};

new const // ������� ���� (�������� ����� / ��������� �� � �����)
	g_hotel_car_park_pos[1][33][E_HOTEL_CAR_PARK_STRUCT] = 
{
	{
		{-133.1494,	983.9849,	12.1618,	180.4495,	INVALID_VEHICLE_ID},
		{-137.5265,	983.8444,	12.1608,	179.9925,	INVALID_VEHICLE_ID},
		{-139.5423,	975.4324,	12.1614,	269.4506,	INVALID_VEHICLE_ID},
		{-139.2751,	971.6942,	12.1608,	267.8990,	INVALID_VEHICLE_ID},
		{-139.3615,	967.6329,	12.1618,	268.9070,	INVALID_VEHICLE_ID},
		{-139.2914,	963.4075,	12.1611,	270.4609,	INVALID_VEHICLE_ID},
		{-139.2221,	958.7978,	12.1608,	269.5585,	INVALID_VEHICLE_ID},
		{-116.4657,	971.6745,	12.1570,	89.46280,	INVALID_VEHICLE_ID},
		{-116.5386,	967.9235,	12.1557,	90.18910,	INVALID_VEHICLE_ID},
		{-116.5738,	963.9881,	12.1531,	90.00600,	INVALID_VEHICLE_ID},
		{-116.5876,	960.3621,	12.1551,	92.67610,	INVALID_VEHICLE_ID},
		{-116.2813,	950.5233,	12.1536,	90.45550,	INVALID_VEHICLE_ID},
		{-102.8195,	971.5937,	12.1614,	270.0878,	INVALID_VEHICLE_ID},
		{-102.6861,	968.0194,	12.1620,	269.5782,	INVALID_VEHICLE_ID},
		{-102.7776,	964.1411,	12.1621,	270.2165,	INVALID_VEHICLE_ID},
		{-102.9098,	960.6828,	12.1615,	270.6911,	INVALID_VEHICLE_ID},
		{-102.8726,	950.8474,	12.1610,	270.0904,	INVALID_VEHICLE_ID},
		{-116.2799,	950.5248,	12.1551,	90.53890,	INVALID_VEHICLE_ID},
		{-102.5865,	946.5525,	12.1611,	268.3489,	INVALID_VEHICLE_ID},
		{-94.7682,	983.9437,	12.1606,	178.0583,	INVALID_VEHICLE_ID},
		{-89.6837,	983.7529,	12.1627,	180.2712,	INVALID_VEHICLE_ID},
		{-88.7005,	975.4258,	12.1573,	91.58140,	INVALID_VEHICLE_ID},
		{-88.7543,	971.4301,	12.1574,	90.29010,	INVALID_VEHICLE_ID},
		{-88.7361,	968.0562,	12.1570,	90.12850,	INVALID_VEHICLE_ID},
		{-88.7494,	964.4591,	12.1579,	91.67410,	INVALID_VEHICLE_ID},
		{-88.6165,	960.7374,	12.1577,	90.89440,	INVALID_VEHICLE_ID},
		{-88.6389,	957.0118,	12.1556,	91.18100,	INVALID_VEHICLE_ID},
		{-88.5814,	953.0699,	12.1540,	90.86370,	INVALID_VEHICLE_ID},
		{-88.6637,	949.1523,	12.1536,	91.07860,	INVALID_VEHICLE_ID},
		{-88.6821,	945.1238,	12.1542,	91.11890,	INVALID_VEHICLE_ID},
		{-88.8479,	941.1545,	12.1542,	90.08610,	INVALID_VEHICLE_ID},
		{-88.8513,	937.4927,	12.1536,	90.22390,	INVALID_VEHICLE_ID},
		{-88.8047,	933.3365,	12.1541,	90.21220,	INVALID_VEHICLE_ID}
	}
};

// ------------------------------------------
new g_entrance[MAX_ENTRANCES][E_ENTRANCE_STRUCT];
new g_entrance_loaded;

new g_entrance_flat[MAX_ENTRANCES][MAX_ENTRANCE_FLOORS][4];
new g_entrance_flats_loaded[MAX_ENTRANCES];

new const 
	Float: g_entrance_flat_pos[4][6] = 
{
	{ // 1 ��������
		26.6000, 1370.2202, 1508.4100, // x | y | z
		24.1485, 1370.3602, 90.0 // x | y | angle
	},
	{ // 2 ��������
		21.9166, 1372.9000, 1508.4100,
		19.9516, 1370.4508, 90.0
	},
	{ // 3 ��������
		21.7802, 1367.9500, 1508.4100,
		19.9516, 1370.4508, 90.0
	},
	{ // 4 ��������
		15.2799, 1367.9500, 1508.4100,
		15.2469, 1369.9597, 0.0
	}
};

// ------------------------------------------
new g_house[MAX_HOUSES][E_HOUSE_STRUCT];
new g_house_loaded;

new g_house_renters[MAX_HOUSES][MAX_HOUSE_ROOMS][E_HOUSE_ROOM_STRUCT];
new g_house_renters_count[MAX_HOUSES];

new g_house_type[1][E_HOUSE_TYPE_STRUCT] = 
{
	{
		"������� �����", 						// �������� / ���
		235.8167, -137.4595, 998.5732, 268.0, 	// ����� �����
		233.3636, -130.6102, 998.4639, 			// �������
		236.5589, -138.6849, 998.5800,			// ���� 
		1,										// ��������
		2										// ������
	}
};

new const
	g_house_improvements[5][E_IMPROVEMENTS_STRUCT] = 
{
	{"�������������� �����", 	8_000, 	0},
	{"�������� �������", 		14_500, 0},
	{"���������� ����������",	20_000, 0},
	{"���������� ��������",		55_000, 0},
	{"���� ��� �����",			60_000, 0}
	/*,
	{"���� ��� �����",			75_000, 0},
	{"������������",			90_000, 0}
	*/
};

// ------------------------------------------
new g_business[MAX_BUSINESS][E_BUSINESS_STRUCT];
new g_business_loaded;

new const
	g_business_improvements[6][E_IMPROVEMENTS_STRUCT] = 
{
	{"�������������� ��������", 			15_000,		0},
	{"����������� ������������", 			30_000,		0},
	{"���������� ���������������",			80_000,		0},
	{"�������� ������� ��� �����",			150_000,	0},
	{"������. ����� ��� ���������",			300_000,	0},
	{"��������� ��������",					450_000,	0}
};

enum // ��� ����������
{
	BUSINESS_INTERIOR_SHOP_24_7 = 0,	// ������� 24/7
	BUSINESS_INTERIOR_CLUB = 1,			// ����
	BUSINESS_INTERIOR_REALTOR_BIZ = 2,	// ���������� ���������� (�������)
	BUSINESS_INTERIOR_REALTOR_HOME = 3,	// ����������� �������� (����)
	BUSINESS_INTERIOR_CLOTHING_SHOP = 4,// ������� ������
	BUSINESS_INTERIOR_HOTEL = 5,		// �����
};
new const
	g_business_interiors[6][E_BUSINESS_INTERIOR_STRUCT] = 
{
	{ // ������� 27/7
		364.6499, -10.2996, 993.3503, 		// ������� ������ (�����)
		364.6720, -7.65120, 993.3503, 360.0,// ������� �����
		3, 									// ��������
		374.3292, -7.2456, 993.3503, 		// ������� �������	
		369.3871, -5.5610, 993.1000, 		// ������� �������
		0.0, 0.0, 0.0,						// ������� 3� ������
		-1									// ��������\�����
	}, 
	{ // ���� (��������)
		493.3602, -24.8439, 1000.6797, 		// ������� ������ (�����)
		493.3910, -22.7228, 1000.6797, 0.0, // ������� �����
		17, 								// ��������
		503.6340, -11.6332, 1000.6797, 		// ������� �������	
		499.970, -20.697, 1000.680, 		// ������� �������
		498.365, -24.535, 1002.696, 		// ������� 3� ������
		-1									// ��������\�����
	},
	{ // ���������� ����������
		331.4905, 670.0544, 49.7217,		// ������� ������ (�����)
		329.1160, 670.9569, 49.7217, 72.38,	// ������� �����
		0,									// ��������
		323.4736, 671.9888, 49.7217,		// ������� �������	
		326.4846, 662.5015, 49.7217,		// ������� �������
		326.4846, 662.5015, 51.2217,		// ������� 3� ������
		-1									// ��������\�����
	},
	{ // ����������� ��������
		162.4737, 742.7685, 25.8272,		// ������� ������ (�����)
		163.3701, 745.0021, 25.8272, 339.92,// ������� �����
		0,									// ��������
		161.4340, 748.0493, 25.8272,		// ������� �������	
		160.5056, 744.9833, 25.8272,		// ������� �������
		154.5396, 748.7235, 26.9926,		// ������� 3� ������
		-1				
	},
	{ // ������� ������
		334.3175, -151.2997, 999.6627,		// ������� ������ (�����)
		334.2939, -153.6735,999.662, 178.12,// ������� �����
		6,									// ��������
		330.0934, -156.9458, 999.6627,		// ������� �������
		334.6521, -160.5485, 999.6627,		// ������� �������
		0.0, 0.0, 0.0,						// ������� 3� ������
		-1				
	},
	{ // �����
		725.0262, 592.7350, 1002.9598,		// ������� ������ (�����)
		725.0227, 594.9494,1002.9598, 360.0,// ������� �����
		1,									// ��������
		718.5051, 593.9505, 1002.9598,		// ������� �������
		724.8739, 602.2747, 1002.9598,		// ������� �������
		0.0, 0.0, 0.0,						// ������� 3� ������
		-1				
	}
};
// ���������� ����������
new Text3D: g_business_realtor_label;

new g_business_realtor_list[2048];
new g_business_realtor_list_idx[MAX_BUSINESS];
// --------------------

// ����������� ��������
new Text3D: g_house_realtor_label;
new g_house_realtor_list[2048];
// --------------------

// ������� ������
new const
	g_business_clothing_skins[2][16][2] = 
{
	{// �,����� 
		{22, 	10000},
		{7, 	2000}, 
		{14, 	10000},
		{17, 	25000},
		{20, 	10000},
		{21, 	10000},
		{23, 	10000},
		{24, 	10000}, 
		{25, 	10000}, 
		{26, 	12000},
		{59, 	18000},
		{60, 	12000},
		{107, 	10000},
		{184, 	12000},
		{240, 	10000},
		{242, 	12000}
	},
	{// �,�����
		{11, 	15000},
		{12, 	10000},
		{13, 	10000}, 
		{40, 	20000}, 
		{41, 	12000},
		{55, 	15000}, 
		{56, 	12000},
		{76, 	25000},
		{87, 	5000},
		{91, 	25000}, 
		{93, 	12000}, 
		{141, 	20000},
		{150, 	25000},
		{169,	18000},
		{194, 	18000},
		{226, 	12000}
	}
};

new const 
	g_business_sound[5] = 
{
	17001,
	4203,
	21000,
	1135,
	1137
};


new g_business_gps[MAX_BUSINESS_GPS][E_BUSINESS_GPS_STRUCT];
new g_business_gps_count; 
new bool: g_business_gps_init;

// ------------------------------------------
new g_fuel_station[MAX_FUEL_STATIONS][E_FUEL_STATION_STRUCT];
new g_fuel_station_loaded;

new const
	g_fuel_station_improvements[4][E_IMPROVEMENTS_STRUCT] = 
{
	{"������� ��������� ������� I", 	9_500, 	0},
	{"������� ��������� ������� II", 	24_000, 0},
	{"������� ��������� ������� III",	58_000, 0},
	{"������ ��������� �����", 			74_000, 0}
};

// ------------------------------------------
new g_order[MAX_FUEL_STATIONS + MAX_BUSINESS][E_ORDER_STRUCT]; // ������

// ------------------------------------------
#if defined RAND_WEATHER
new const 
	g_weather[5][E_WEATHER_STRUCT] = 
{
	{"����� ������", 18, 	22},
	{"�����", 		 9, 	15},
	{"�����", 		 8, 	17},
	{"����� ������", 3, 	21},
	{"����� ������", 1, 	23}
};
#endif

// ------------------------------------------
new g_player_setting[MAX_PLAYERS][E_PLAYER_SETTINGS_STRUCT];
new 
	g_settings_default_values[E_PLAYER_SETTINGS_STRUCT] =
{
	SETTING_CHAT_ADVANCE,
	SETTING_TYPE_ON,
	SETTING_TYPE_ON,
	SETTING_TYPE_ON,
	SETTING_TYPE_OFF,
	SETTING_TYPE_ON
};

// ------------------------------------------
new g_player_gps[MAX_PLAYERS][E_PLAYER_GPS_STRUCT];
new 
	g_gps_default_values[E_PLAYER_GPS_STRUCT] = 
{
	GPS_STATUS_OFF,
	0.0,
	0.0,
	0.0
};

// ------------------------------------------
new const 
	gps_public_places[19][E_GPS_STURCT] = // ������������ �����
{
	{287.500, -1611.920, 32.957, 	19},	// ������������ �����
	{1481.051, -1800.310, 18.796, 	19},	// ����� ���-�������
	{-2766.552, 375.595, 6.335, 	19},	// ����� ���-������
	{2388.997, 2466.012, 10.820, 	19},	// ����� ���-���������
	{954.032, -909.013, 45.766, 	19},	// ������������� ����������
	{-2026.628, -102.066, 35.164, 	36},	// ���������
	{1040.088, 1303.406, 10.820, 	46},	// ���������
	{543.785, -1285.105, 17.242, 	55},	// ��������� ������-������ (��)
	{-1969.977, 293.892, 35.172, 	55},	// ��������� �������� ������ (��)
	{-1639.857, 1203.093, 7.232, 	55},	// ��������� �������� ������ �2 (��)
	{2467.908, 1344.219, 10.820, 	55},	// ��������� ������� ������ (��)
	{2132.337, -1141.279, 25.148, 	55},  	// ����-���� ����� (��)
	{-2934.215, 472.714, 4.907,   	9},		// �������� ������� ���-������
	{1122.692, -1133.577, 23.828, 	48},	// ���������� ���
	{2695.593, -1704.764, 11.844, 	33},	// ����������� ������� (���-������)
	{-2110.070, -445.780, 38.734, 	33},	// ������� ���-������
	{1094.051, 1597.350, 12.547,  	33},	// ������� ���-���������
	{-1987.333, 1117.820, 54.231, 	21},	// ������� ���-������
	{1124.510, -2037.007, 69.884, 	34}		// ����������
};

new const 
	gps_transport[9][E_GPS_STURCT] = // ������������ ����
{
	{1780.050, -1899.257, 13.389, 	42},	// �/� ������ ���-�������
	{1154.278, -1763.612, 15.240,	42},	// ����������� ����������� 
	{-1984.787, 137.766, 27.688, 	42},	// �/� ������ � �����������
	{2813.671, 1296.610, 10.750, 	42},	// �/� ������ � �����������
	{1433.807, 2628.619, 11.393, 	42},	// �/� ������� ���-���������
	{824.720, -1359.805, -0.508, 	42},	// �/� ������� ���-������-2
	{1685.279, -2326.648, 13.547, 	5}, 	// �������� ���-�������
	{-1423.747, -287.906, 14.148,	5}, 	// �������� ���-������
	{1687.536, 1448.273, 10.768, 	5}		// �������� ���-���������
};

new const 
	gps_state_organizations[17][E_GPS_STURCT] = // ��������������� �����������
{
	{-2057.501, 455.467, 35.172,	30},	// ������������ ���������� ���
	{1555.497, -1675.592, 16.195, 	30},    // ������� ���-�������
	{-1605.628, 710.627, 13.867, 	30},    // ������� ���-������
	{2287.098, 2432.367, 10.820, 	30},    // ������� ���-���������
	{-2440.141, 505.018, 29.945, 	30},    // ���� ���
	{1058.869, 1032.105, 10.162, 	18},    // ������������ �������
	{132.796, 1956.894, 19.443, 	18},    // ���� ���������� �����
	{429.849, 2528.091, 16.641, 	5},     // ���� ������-��������� ���
	{-2243.459, 2383.276, 5.053, 	9},     // ���� ������-�������� �����
	{-2723.119, -318.415, 7.844, 	22},    // ������������ ���������������
	{1172.645, -1323.426, 15.403, 	22},    // �������� ���-�������
	{-2655.147, 636.045, 14.453, 	22},    // �������� ���-������
	{1607.554, 1820.330, 10.828, 	22},    // �������� ���-���������
	{1653.891, -1663.725, 22.516, 	48},    // ���������� ���-�������
	{-1806.481, 539.736, 35.164, 	48},    // ���������� ���-������
	{2127.478, 2354.420, 10.672, 	48},    // ���������� ���-���������
	{1799.015, -1282.714, 13.658, 	42}		// ���������
};

new const 
	gps_gangs[8][E_GPS_STURCT] = // ���� ���� � �����
{
	{2514.307, -1691.615, 14.046, 	62},	// Grove Street
	{2022.918, -1120.268, 26.421, 	59},    // The Ballas
	{2756.306, -1182.799, 69.403, 	60},    // Los Santos Vagos
	{2787.076, -1926.186, 13.547, 	61},    // The Rifa
	{2185.810, -1815.228, 13.547, 	58},    // Varios Los Aztecas
	{1460.141, 2773.327, 10.820, 	44},    // La Cosa Nostra
	{2597.507, 1897.072, 11.031, 	44},    // Yakuza
	{940.928, 1733.190, 8.852, 		43}		// ������� �����
};

new const 
	gps_jobs[13][E_GPS_STURCT] = // �� ������
{
	{2137.558, -2282.534, 20.672, 	11},	// ��������� ����� (������ ��������)
	{-1857.798, -1613.214, 21.758, 	11},    // ����� (������ �������)
	{-90.632, -309.167, 1.430, 		27},    // ����� �� ������������ ���������
	{302.997, 1411.770, 9.272, 		27},    // ����������
	{2291.271, -2324.915, 13.547, 	51},    // �������� ��� ����������� ���������
	{-81.764, -1126.497, 1.078, 	51},    // �������� ��� ����������� �������
	{1755.867, -1471.561, 13.547, 	20},    // �������� ������� ���-�������
	{-2026.678, 67.173, 28.692, 	20},    // �������� ������� ���-������
	{1737.635, 2086.132, 12.355, 	20},    // �������� ������� ���-���������
	{1656.244, -1127.749, 23.906, 	27},    // ������� ������������� ��
	{-2124.356, -95.961, 35.320, 	27},    // ������� ������������� ��
	{2443.318, 1274.526, 10.756, 	27},    // ������� ������������� ��
	{2273.101, -1485.025, 22.586, 	41}		// ��������������� ���� (������� �������)
};

new const 
	gps_banks[6][E_GPS_STURCT] = // �����
{
	{1420.517, -1623.777, 13.547, 	52},	// ���� ���-�������
	{-1497.862, 920.231, 7.188, 	52},	// ���� ���-������
	{2303.827, -16.188, 26.484, 	52},	// ���� Palomino Creek
	{-2164.409, -2417.677, 30.625, 	52},	// ������� ���� Angel Pine
	{-828.056, 1502.750, 19.547, 	52},	// ������� ���� Las Barrancas
	{-180.739, 1133.177, 19.742, 	52}		// ������� ���� Fort Carson
};

new const 
	gps_entertainment[17][E_GPS_STURCT] = // �����������
{
	{-2664.252, -3.571, 6.133, 		6},		// ���
	{-2198.196, -2257.523, 30.747, 	16},    // �������� ������ (�������)
	{-2311.098, -1650.407, 483.703, 25},    // ����������� �����
	{1546.681, 32.278, 24.141, 		53},    // ����� ����� '����������� San Andreas'
	{-2409.204, -2184.985, 33.289, 	53},    // ����� ����� '������ �� ���� ������'
	{2347.639, -1046.048, 53.841, 	53},    // ����� ����� '�������� San Andreas'
	{794.835, 1687.136, 5.281, 		53},    // ����� ����� �� �������
	{2492.300, 2780.692, 10.820, 	18},    // ������-���������� �� ����������� ������
	{2813.656, 892.989, 10.758, 	18},    // ������-���������� �� ������������� ��������
	{-1060.056, -1195.528, 129.464, 18},    // ������-���������� �� ����� ����������
	{2157.665, -98.644, 2.784, 		18},    // ������-���������� ��� �����
	{2021.639, 1007.599, 10.820, 	44},    // ������ '4 �������'
	{2185.625, 1677.538, 11.094, 	44},    // ������ '��������'
	{1022.383, -1124.613, 23.870, 	44},    // ������ '���-������' (�������)
	{1658.561, 2252.557, 11.070, 	44},    // ������ '���-��������' (�������)
	{2453.746, 1497.326, 11.363, 	44},    // ��������� ������ (�������)
	{2016.355, 1104.849, 10.820, 	44}     // ����� ������ (�������)
};

// ------------------------------------------
new help_info[14][E_HELP_INFO_STRUCT] = 
{
	{
		"� �������",
		""SERVER_NAME" RolePlay - ���� �� ����� ���������� ��������\n"\
		"��������������������� GTA San Andreas Multiplayer. � ���������\n"\
		"����� � ��� �������� 9 ��������, � ������������� ����������� ��������\n"\
		"�������� ���������� ��� ������ � ������ ����� �������.\n\n"\
		"�� ����������� ���������� ������ �������� ������� ���� SA-MP �\n"\
		"������ ������ � �������������. �� ������� ������� �������\n"\
		"������, ��� ���� ������� ���� ����������� ������, �����������\n"\
		"�������� ������. ����� ��� ��������� �������� � ���� �� �����������\n"\
		"� ������ ��������� ����. ��� �� ����� ������ ������� ��������\n"\
		"�����, ������ ������� � ������, ��� ������ � �������� � ������� ���.\n\n"\
		"�� �������, ��� "SERVER_NAME" RolePlay ������� ��� ������� �������� ����\n"\
		"��������� ����� �� ������-�����!"
	},
	{
		"������������",
		"��� ������� - ��� ���� �������������. ������ �� ������� ���� ������,\n"\
		"����� �� �������� �������� ��� ���� ����������. �� ����������\n"\
		"�������������� ��������� - ����, ����, ��������. ��� ���\n"\
		"��������� ���������������� ������ � ����� ����� - ����������\n"\
		"������ � ������ ��������.\n\n"\
		"������ "SERVER_NAME" RolePlay ����� ������������ ����������� ���������\n"\
		"������������,  ������� ����������� ��������� ����������� ������.\n"\
		"���������: ������� {66CCFF}/menu > ��������� ������������."
	},
	{
		"������ ����",
		"����� �� �������, �� ��������� ���� �����. ��� ���������� ��\n"\
		"������������� ���������� ���������� ������� �� ��������� �������.\n"\
		"� ������ ����� ������� ����������� ����� ����������� �\n"\
		"���������� �������� ����� ���������� �������.\n\n"\
		"��� ��������� ���������� �������������� �������� /menu. � �������\n"\
		"�������� ��������� ����� ����� ������������ ��������� ���������.\n"\
		"��� �������� � ������� ��� (F6) ����� ����� �����, �������� /anim\n"\
		"/help � �. �. ������� /menu, ����� �������� ����� \"������ ������\". ���\n"\
		"���������� ������ �������� ������, � ����� ������ \"�������� ������\"\n"\
		"��� ��������� ������ �� ���."
	},
	{
		"RolePlay",
		"RolePlay - ��� ����� ��� ����, � ������� � ������� ���� ���� ����. ����\n"\
		"�� �������, �������� �������� ��� ������, ����������� ��� �������,\n"\
		"���� ����� ��� �������. ������ ����� ����������, ��� �� ����� ����.\n\n"\
		"RolePlay (RP) ����� ������������� ������ ��������� ������ �\n"\
		"�������, ������������ ������� ������ �� ����� ���������. � ����\n"\
		"����������� ����� ������������ �� ����� ������, ��� �� �����\n"\
		"������ ��� ������������ ��� ������� �� �������� ��������."
	},
	{
		"������ ����",
		"������ ����� ���������� ���������� ������. � ����������� ����\n"\
		"�����������, ���� �� ������� ���������� �� ������ �����. ��� �����,\n"\
		"����� � ��������� �����. ������� ���, �� �� ������ �������� �������,\n"\
		"�� � ���������� ������������� ������� �����������. � ��� ��\n"\
		"������� ����� ������ � �������� ������ ������������.\n\n"\
		"��� ��� ����� ����� �����, ��������� ������� /gps. ��������� ��\n"\
		"������� ������� ��� ������� ����������  ���������. ����� � ��\n"\
		"������� ����� ������� �� �����, �  �� ������ ����� ���������� �����\n"\
		"��������� �������. ����� ������ ��������� � ���������� ������,\n"\
		"������� ������� /bushelp.\n\n"\
		"����� ����, ��� �� ����������� ������, ������������� � ��������� �\n"\
		"�������� ������� �� �����. ��� �������� ������ ��� ����������\n"\
		"����������, ���������� �� ����� ������������������ � ����������\n"\
		"������. ����� �� ����� ����� 600 ������, ����� �������� � ���������\n"\
		"���������, ��� ������ ����� �����."
	},
	{
		"�������",
		"�� ����� ���� ��� ��������� �������� ����������������� � ������. ���������� 2\n"\
		"���� �����:\n\n"\
		"\t1. IC (In Character) - ������� ������ ���� � ������ ��� ���������� �������\n"\
		"\t��������. ��� ���������� �������� F6.\n"\
		"\t2. OOC (Out Of Character) - ���, ��� �������� ���������, �� �������� ����.\n"\
		"\t������� F6, ����� ������� ������� /n � ���� ���������. ��� ��������� �\n"\
		"\t������� ������.\n\n"\
		"������ �����, ���������� ����� ������ �������� �������. �� ������ ������� ��\n"\
		"�������� ��� ���������� SMS ���������. ������� � �����������, ��������\n"\
		"����������� ����������� � ������������ �� �����, � ����� ����� ������\n"\
		"���������� �������.\n\n"\
		"���������� � �������� ������� ������ ������ � ��������������� ������� ����:\n"\
		"{66CCFF}/menu > ������ ������"
	},
	{
		"���������",
		"������������ ������� - ���� �� ��������� � ������. � �� ������� ��������\n"\
		"���������� ������ ����������� ����������� � �����������.\n\n"\
		"�������� ��� ���������� - ��� �������. �������� ��������� �� �����\n"\
		"����������� � ��������� ��� ���������� ������ � �����������.\n"\
		"����� - �������� ������� ��� ����������. �� ������� ��������� �� ������ �����,\n"\
		"������ ����� ������� ����� ������ ����������� ������, ��� �� ��������.\n"\
		"����� - ������� � ��������� ��� ����������. �� �� ��������� ����� �������\n"\
		"��������� �� ����� �������, �� ������� ��������� �� ��� �����.\n\n"\
		"��������������� ������������ �������� ������ ��������� ����� ���������. �\n"\
		"��������� � ����������� ����� ������ � ��������� ����� (/gps)."
	},
	{
		"��������������� �������",
		"��� ������� ����� �������� ��� ��������� ������������� -\n"\
		"�������� ����������� � �����������. � �� ������ ������ ����� ����\n"\
		"������� � ������������� ����������. ��� � ����� ��������\n"\
		"������, ��� ������ ����� ����� ������. � ����� ���� ���������� ��\n"\
		"����� ���������� ������������� ��������, ��� ��������� �� ����\n"\
		"���������� ���������� ������, �������� � �������, ����������\n"\
		"����� ����� �����������\n\n"\
		"��������������� ������� � �� �������� �� ������� �����������\n"\
		"�������������. ������������ ����� ���������� ����������, � ��\n"\
		"���� ��������� � ���� � ������ ���� ����� � ���!"
	},
	{
		"�����",
		"�� ����� ����������� ����������� ����� ����, ������� ����� ������.\n"\
		"������ ��� ����� ���� ���������, ������� ���������� ���������\n"\
		"��������. ����� ������ �������� �� ��������� ������, ��� ������\n"\
		"�������� �� ��������� ������� � ������� ������.\n\n"\
		"���� � ��� ���� ���, �� �� ������� ���������� ������, ��� ������\n"\
		"�������������� ���������, ����� ��� ���� ��� �������� ����� ���\n"\
		"�������������� �����. � ��� ������ ��������� ����������� �����.\n\n"\
		"� ����������� �� ������������ ����, � ��� ����� ��������� ����������\n"\
		"����������. ���� ������ ����� �� ����� ����� ����������� �������������\n"\
		"������, ���� �����������, ��� ��������� ����� ������� ���."
	},
	{
		"������ � ���",
		"�� ������ ������� ����������� ������, � ������������ ��������\n"\
		"������. ��� ����� ���� ��������� �������, ������� ������ ���\n"\
		"��������������� �����, ��������, ��������������, ���� �������\n"\
		"����������� �����. ��� �� �������� ����� ������������ ������� ����\n"\
		"�������������, ���������� ��� �������. � ����� ������ ����������\n"\
		"�������� ���������� ������������� �����������.\n\n"\
		"���� ������, ����� ���� ��������� ������� ����������� ���\n"\
		"����������� ����� ��������, ��� ����� ��������� �������� ����\n"\
		"������. �� ������� ������������ ����, �������� ���������\n"\
		"�������������� ������ �����������, ������������ ������� ������ �\n"\
		"������������.\n\n"\
		"��� (��������������� �������) - ������ ��� �������, ������ ��\n"\
		"�������� ����������� ����, ��� �� ������� �����������. ���\n"\
		"���������� ������ ��� ����� ��������� ��������� ��������� ��\n"\
		"������� �������� �������. ��������� ����� ������� �������\n"\
		"������������ � ��� ������������."
	},
	{
		"�����, �������� �������",
		"������ ����� �������� ���� ���� � �����. �� ���� �������������\n"\
		"�������� � ������ ������. ���� ���� ���������� ��������, � �������� �\n"\
		"����� ���������.\n\n"\
		"������ �����, �� ������ ��������������� �������� ����������������\n"\
		"������, ����� ������� ������� GPS. ��� ����� ������� �� 8\n"\
		"�������������� ������. ������ �� ��� ����� ���� �����, �������\n"\
		"�������� ������ ��� �������� �����. ���� ���, ����� ����� �����\n"\
		"����������� ��� ������, ���� ���� �� �������. ��������, �����\n"\
		"������� ���� � ��������� \"�������������������\", �������� �� ��������\n"\
		"����������������� ����������� ����� ���, �������� ����� �����, �\n"\
		"����� ������ ����������� �� ���� ������ � ��������� ����� ��� �����\n"\
		"��������.\n\n"\
		"�������������� ����� ����� �����������, ������������� ������\n"\
		"PIN-�����, �������� �������� � ����� ������������� ���������\n"\
		"������� ��������."
	},
	{
		"�����������",
		"� ����� ������ �������� ������� ���������� �����������. ��� �����\n"\
		"���� ��� ������������ (�������������, ���, ���. �������, ���.\n"\
		"���������������, �� � �����), ��� � �������������� (����� � �����).\n\n"\
		"��� ���������� ������������� ������, �� ������ �������� � ����� ��\n"\
		"�����������. ����������� ��������� ����� ��������� � ��������������\n"\
		"���������� ��� ����������. ��������, ���� �� ������ ������� � �����,\n"\
		"�� ��� �������� ������������������ ���� ������ ������� �������. �\n"\
		"���� �� ������ ���� � ���� ��������� ����������, �� ����� ������� �\n"\
		"�������� ������. � �������������� ����������� ������� �����������\n"\
		"����������� �� ����� ������ �����������.\n\n"\
		"����� ����������, ��� ����� �������� ����������� �� ���������\n"\
		"��������, ���������� ��������� ����� �����������. � ������ ����������\n"\
		"����� ������������� ���� �������� � ������ � ��������. �� �������\n"\
		"����� ������, � �� �������� ������� ������ ���� �� �����������\n"\
		"����������. ����� � ����������� ���������� ���������� � �������������!"
	},
	{
		"������",
		"� ����� ������ ������ �������� ����� ���������, ��� �� ������\n"\
		"���������� �� ����� ������. ������� �������� ��������, ��� ���������\n"\
		"������ �������� ��� ���������� ������������� ������. �� �� ������\n"\
		"������������ ���� ����������� �� ������ � ����� � �������� �\n"\
		"�����������.\n\n"\
		"������ �������� ����� ���������� � ��������������. � ��� ���������\n"\
		"������ �� �����, ������ � ������. ����� ������ ����� ��������� �\n"\
		"��������� � ������������ ������ �����. ����������� ������� /gps ���\n"\
		"����, ����� ����� ����� ������������ ��������� �����. �� ����� ��\n"\
		"�������� ��������� ����������, ��� � ��� ������� ������."
	},
	{
		"�����������",
		"���� � ��� ��������� ��������� ����� � �������, �� ����������� ���\n"\
		"�������� ���� �� ��������������� �����������. ������ 3 ����\n"\
		"���������� �����, ������������� � ������� ����� ����� ��������.\n"\
		"������ ������� ������������� ������� ������� � ������, �� �����\n"\
		"���������� �����������!\n\n"\
		"������ ������� �� ����������, �������������� ������� ����� �����\n"\
		"�������� ������� ���� �����������, ����������� � ������� �� ������\n"\
		"���������, �� � ������� - ���������� �������� ������ �������.\n\n"\
		"� ���������� ���� ��� ����� ���������������� ����������� �� �������\n"\
		"������� �� �������������� ��������� � ����� ����."
	}
};
new help_info_items[35 * (sizeof help_info) + 1];
new help_info_CP;

// ------------------------------------------
new info_pickup[9][E_INFO_PICKUP_STRUCT] = 
{
	{
		"������ ��������",
		"��� �� ������ ����������� ���������. ����� ���������� �� ������\n"\
		"�������� � ���������� �����. ��� �� ����� �������� ��������.\n\n"\
		"�� ������ ���������� ������ ������� ��� ���������� �� ����������.\n"\
		"���� � ��� ��� ����, �� ������ ������ ����� ����������.\n\n"\
		"��� ������ �������� ������ ���������� �� ������ � �� ������ ������\n"\
		"��������, ����� �� �������� ������� ���.", 
		"����������\n� ������",
		0x66CCFFFF,
		509.9358, 1639.0743, 12.1895
	},
	// -------------------------------
	{
		"�����",
		"��� �� ������ ���������� �� ������ ��������.\n"\
		"��� ����� ������� ��������� ��������� �� ������ ����� �����,\n"\
		"��� ��� ������� ���������� � ����������� ����������, � �����\n"\
		"��������� ��� ������ ������.\n\n"\
		"����� ���������������� �� ������ �������� ����, �� �������\n"\
		"����� � ������� �������� ������. �� ������ ����������� ��\n"\
		"������ ������������, ������� ���������� ������ ���� ����� �����\n"\
		"��� ��������� �����������.", 
		"� �����",
		0x66CCFFFF,
		2385.3167, 1766.6891, -1.7170
	},
	{
		"� ��������� ������",
		"������ �������� ��� ����, ������� ��������� � ��������� �������\n"\
		"������� ������������ ���,  ������� �������� �� �����������.\n"\
		"������ ������� ���� ������� ������� ��������� ��������\n"\
		"��������� ��� ��������� ������.\n\n"\
		"� ����� �� ���������� ��������� ����� �������� ����������\n"\
		"������ �� ������ ������ ����, ������� ���� ������ ��� ������.", 
		"���������\n������",
		0xFFCD00FF,
		2376.9819, 1729.6956, -2.1078
	},
	{
		"� ���������� �������",
		"���������� �� ����� ������ ���������� ������ �����������\n"\
		"���������� �������������, ������ �������� ����������� - ���\n"\
		"����� �� ������������ ���������. ����� �������� � ����������\n"\
		"����� ����������� ����� ������, ������� ���� (/gps).\n\n"\
		"��� ���������� ������ ������ ��������� ��������� ������,\n"\
		"���������������� �������� ���������� ��� ������ ��������. ��\n"\
		"���� ������ ���������� �������� ������ ��� �����������.",
		"����������\n�������",
		0xFFCD00FF,
		2327.0488, 1741.1315, 0.9221
	},
	// -------------------------------
	{
		"����� �� ������������ ���������",
		"����� ��������� ���� �� ��������� ����������� � ����������� - �����\n"\
		"�� ������������ ���������. �� ��� ���������� ������ �������\n"\
		"������������ ����� �������� �������.\n\n"\
		"� ������ ������ ����� ���������� �� ���� �� ���� �������������� -\n"\
		"�������� ����������������� ���� ��� ������ ��������. �� ����� ��\n"\
		"������� ����� ��������� ���������� � ������ �� ���.",
		"� ������\n�� ������������\n���������",
		0xFFCD00FF,
		-1055.7217, 2142.2402, 38.0322
	},
	{
		"����� - ����� �������� ����������",
		"�� ������ �������� ���������, ������� ������������ ����������� ����\n"\
		"��� ������������ ���������, � ����� ������� ��������. ��������\n"\
		"��������� ������������ �� ����� ��� ������� ��������. �����\n"\
		"���������� ���� �� ������, �������� � ���������� �����, �����\n"\
		"�� ���������� ������ ��������� � �������� ��������� � �����������\n"\
		"�� ����, ��� ������ �� ������ �������� �� �����.\n\n"\
		"��������� ���������� �� ���� ������ ����, � ���� ������� - ���\n"\
		"�������, ������� ������� ��� ������� ���������� ������.",
		"������ �\n������ ��������",
		0xFFCD00FF,
		-1084.9386, 2167.1868, 38.0369
	},
	{
		"����� - ���������������� ���",
		"����� ������ ������� ���� �������� � ����� ����������. ��� ��\n"\
		"����� ��������� ��� � �������� �������. ����� �������� �\n"\
		"������������ ����� (�������� ������� ���������), ��������\n"\
		"������, ����� ���� ������������� �� ����� ��������� ����� � ������\n"\
		"����. �������, ����������� ��� ������������ ��������, �������������\n"\
		"�������� � ������� �����, � ��� �� ����� ����� ��� �������������.\n\n"\
		"��� ������ �� ��������� � ����, ��� ���� ���� ������ ������������,\n"\
		"� ��� ������ ���� ������� ����������� �������. ����� �����\n"\
		"������������� �� ���� �������� ����� ���������.",
		"������ �\n���������������� ����",
		0xFFCD00FF,
		317.1251, -210.3592, 1006.5694
	},
	// -------------------------------
	{
		"����������",
		"�� ����������� ����� ���������� ������� ��� ������ �� ������������\n"\
		"��������� ��� ��� ������� ��� �� ����������� ��������. �������� 2\n"\
		"�����, ������� ������ ��� ������� ���������.\n\n"\
		"������ ��������� ����������� ��������� ����������� �� ����\n"\
		"������ � ������� �����.",
		"����������",
		0xFFCD00FF,
		1023.0947, 637.6918, 12.0272
	},
	// -------------------------------
	{
		"��������� � �����",
		"{FFFFFF}� ���������� ����� ����� ���� �� �������. ��� ����� ��������\n"\
		"����� ��� �������� ����������, ������� ����� ������ �� �����\n"\
		"��������� ��� ����������� � ���. ����� � ������ ��������� � 1000 ���\n\n"\
		"���������� � ��������� ������� ����� ������ � ������ ����� � ����.",
		"",
		0x99CC00FF,
		722.0862, 602.2735, 1002.9598
	}
};

// ------------------------------------------
new g_server_radio[7][E_SERVER_RADIO_STRUCT] = 
{
	{
		"����� �������",
		"http://online-radiomelodia.tavrmedia.ua/RadioMelodia.m3u"
	},
	{
		"Kiss FM (UA)",
		"http://kissfm.ua/v3/kiss-2.m3u"
	},
	{
		"����� ������",
		"http://radio02-cn03.akadostream.ru:8108/shanson128.mp3"
	},
	{
		"����� ������",
		"http://online.radiorecord.ru:8101/rr_128"
	},
	{
		"Sky Radio",
		"http://stream05.akaver.com/skyradio_hi.mp3"
	},
	{
		"DFM Radio",
		"http://striiming.trio.ee/dfm64.mp3.m3u"
	},
	{
		"Rock Online",
		"http://skycast.su:2007/rock-online.m3u"
	}
};
new g_server_radio_items[37 * (sizeof g_server_radio) + 1];

// ------------------------------------------
new anim_list[74][E_ANIM_LIST_STRUCT] = 
{
	{"����� 1",                         "",					"",						0.0, false, 0, 0, 0, 0},
	{"����� 2",                         "",					"",						0.0, false, 0, 0, 0, 0},
	{"����� 3",                         "",					"",						0.0, false, 0, 0, 0, 0},
	{"����� 4", 						"",					"",						0.0, false, 0, 0, 0, 0},
	{"����� 5",							"DANCING",			"DAN_Left_A",			4.0, true,  0, 0, 0, 0},
	{"����� 6",							"DANCING",			"dnce_M_a",				4.0, true,  0, 0, 0, 0},
	{"������ �����",					"ON_LOOKERS",		"wave_loop",			4.0, true,  0, 0, 0, 0},
	{"���� �� �����",					"BEACH",			"bather",				4.0, true,  0, 0, 0, 0},
	{"������� �������",					"PED",				"WALK_DRUNK",			4.0, true,  1, 1, 1, 0},
	{"�����������",						"ped",				"Crouch_Roll_L",		4.0, true,  1, 1, 1, 1},
	{"�����������",						"ped",				"endchat_03",			4.0, true,  1, 1, 1, 0},
	{"������ ���",						"benchpress",		"gym_bp_celebrate",		4.0, true,  0, 1, 1, 0},
	{"��������",						"ped",				"cower", 				3.0, true,  0, 0, 0, 0},
	{"��������� �����",					"BOMBER",			"BOM_Plant",			4.0, false, 0, 0, 0, 0},                    
	{"������ �����",					"SHOP",				"ROB_Shifty",			4.0, false, 0, 0, 0, 0},                       
	{"�������� ���� ����� �����",		"SHOP",				"ROB_Loop_Threat",		4.0, true,  0, 0, 0, 0},          
	{"������� ���� ������",				"COP_AMBIENT",		"Coplook_loop",			4.0, true,  0, 1, 1, 0},                
	{"���� ���-�� �� ��...",			"FOOD",				"EAT_Vomit_P", 			3.0, false, 0, 0, 0, 0},               
	{"����������",						"FOOD",				"EAT_Burger", 			3.0, false, 0, 0, 0, 0},                         
	{"�������� ����-�� �� �������",		"SWEET",			"sweet_ass_slap",		4.0, false, 0, 0, 0, 0},        
	{"���������� ���������",			"DEALER",			"DEALER_DEAL",			4.0, false, 0, 0, 0, 0},               
	{"������ �������������",			"CRACK",			"crckdeth2",			4.0, true,  0, 0, 0, 0},               
	{"������� �������",					"SMOKING",			"M_smklean_loop",		4.0, true,  0, 0, 0, 0},                    
	{"������� �������",					"SMOKING",			"F_smklean_loop",		4.0, true,  0, 0, 0, 0},                    
	{"��������",						"BEACH",			"ParkSit_M_loop",		4.0, true,  0, 0, 0, 0},                           
	{"��������� ������������",			"PARK",				"Tai_Chi_Loop",			4.0, true,  0, 0, 0, 0},             
	{"������ �������",					"BAR",				"dnk_stndF_loop",		4.0, true,  0, 0, 0, 0},                     
	{"����������� �����",				"BLOWJOBZ",			"BJ_COUCH_LOOP_P",		4.0, true,  0, 0, 0, 0},                  
	{"���� �������",					"BSKTBALL",			"BBALL_def_loop",		4.0, true,  0, 0, 0, 0},                       
	{"Facepalm",						"MISC",				"plyr_shkhead",			4.0, false, 0, 0, 0, 0},                           
	{"������� ���������� �����",		"BSKTBALL",			"BBALL_idle",			4.0, true,  0, 0, 0, 0},           
	{"������� ����-��",					"CAMERA",			"camstnd_cmon",			4.0, true,  0, 0, 0, 0},                    
	{"���� �����!",						"PED",				"HANDSUP",				4.0, 2, 1, 0, 1, 0},                        
	{"����� �� ����",					"CRACK",			"crckidle2",			4.0, true,  0, 0, 0, 0},                      
	{"����� �� �����",					"CRACK",			"crckidle4",			4.0, true,  0, 0, 0, 0},                     
	{"�������� �� ��������",			"DEALER",			"DEALER_IDLE",			4.0, true,  0, 0, 0, 0},               
	{"������������ �� ���",				"GANGS",			"leanIDLE",				4.0, true,  0, 0, 0, 0},                
	{"�������� �����",					"GANGS",			"shake_carSH",			4.0, false, 0, 0, 0, 0},                     
	{"��������",						"GANGS",			"smkcig_prtl",			4.0, false, 0, 0, 0, 0},                           
	{"����, ���������� �� ������",		"BEACH",			"ParkSit_W_loop",		4.0, true,  0, 0, 0, 0},         
	{"����� �� ����",					"INT_HOUSE",		"LOU_Loop",				4.0, true,  0, 0, 0, 0},                      
	{"������ �������� �� �����������",	"INT_OFFICE",		"OFF_Sit_Bored_Loop",	4.0, true,  0, 0, 0, 0},     
	{"������ �� ������",				"INT_OFFICE",		"OFF_Sit_Idle_Loop",	4.0, true,  0, 0, 0, 0},                   
	{"������ � ��������",				"INT_OFFICE",		"OFF_Sit_Type_Loop",	4.0, true,  0, 0, 0, 0},                  
	{"����� ���-�� � �����������",		"INT_SHOP",			"shop_shelf",			4.0, false, 0, 0, 0, 0},         
	{"�����, ������� ���� �� ����",		"JST_BUISNESS",		"girl_02",				4.0, true,  0, 0, 0, 0},        
	{"���������� �� ����-����",			"KISSING",			"GF_StreetArgue_02",	4.0, false, 0, 0, 0, 0},            
	{"������� 1",						"KISSING",			"Grlfrd_Kiss_01",		4.0, false, 0, 0, 0, 0},                          
	{"������� 2",						"KISSING",			"Grlfrd_Kiss_02",		4.0, false, 0, 0, 0, 0},                          
	{"������� 3",						"KISSING",			"Grlfrd_Kiss_03",		4.0, false, 0, 0, 0, 0},                          
	{"����������� ������ �� �����",		"LOWRIDER",			"RAP_B_Loop",			4.0, true,  0, 0, 0, 0},        
	{"������������ �������",			"MEDIC",			"CPR",					4.0, false, 0, 0, 0, 0},               
	{"�������� ��� ��������",			"MISC",				"bitchslap",			4.0, true,  0, 0, 0, 0},              
	{"������������ ����� ���-��",		"MISC",				"bng_wndw",				4.0, false, 0, 0, 0, 0},          
	{"�������� ���������",				"MISC",				"KAT_Throw_K",			4.0, false, 0, 0, 0, 0},                 
	{"����� �� ���� (2)",				"MISC",				"SEAT_LR",				4.0, true,  0, 0, 0, 0},                  
	{"����� �� ���� (3)",				"ped",				"SEAT_idle",			4.0, true,  0, 0, 0, 0},                  
	{"�������� ������",					"ON_LOOKERS",		"lkup_loop",			4.0, true,  0, 0, 0, 0},                    
	{"������� ����� ������",			"ON_LOOKERS",		"Pointup_loop",			4.0, true,  0, 0, 0, 0},               
	{"���� � ������",					"ON_LOOKERS",		"panic_loop",			4.0, true,  0, 0, 0, 0},                      
	{"��������� � ����-����",			"ON_LOOKERS",		"shout_02",				4.0, true,  0, 0, 0, 0},              
	{"������� ��-����������",			"PAULNMAC",			"Piss_loop",			4.0, true,  0, 0, 0, 0},              
	{"������������ ����",				"GHANDS",			"gsign1LH", 			3.0, true,  0, 0, 0, 0},                  
	{"���������� �� ���������",			"ped",				"IDLE_taxi", 			3.0, true,  0, 0, 0, 0},            
	{"���� �����",						"POLICE",			"Door_Kick",			4.0, false, 0, 0, 0, 0},                         
	{"��������� � �����",				"POLICE",			"CopTraf_Stop",			4.0, true,  0, 0, 0, 0},                  
	{"�������� ����",					"RIOT",				"RIOT_ANGRY_B",			4.0, true,  0, 0, 0, 0},                      
	{"��������������",					"RAPPING",			"RAP_C_Loop",			4.0, true,  0, 0, 0, 0},                     
	{"���� �� ����� (2)",				"SWAT",				"gnstwall_injurd",		4.0, true,  0, 0, 0, 0},                  
	{"������ ������������",				"SWEET",			"Sweet_injuredloop",	4.0, true,  0, 0, 0, 0},                
	{"����������� 1",					"RIOT",				"RIOT_ANGRY",			4.0, false, 0, 0, 0, 0},                      
	{"����������� 2",					"GHANDS",			"gsign2",				4.0, false, 0, 0, 0, 0},                      
	{"����������� 3",					"GHANDS",			"gsign5",				4.0, false, 0, 0, 0, 0},                      
	{"����������� 4",					"GHANDS",			"gsign4",				4.0, false, 0, 0, 0, 0}
};
new anim_list_items[34 * (sizeof(anim_list)+1) + 1];
new 
	g_anim_libs[38][13] = 
{
	"BAR",
	"BASEBALL",
	"BEACH",
	"BENCHPRESS",
	"BLOWJOBZ",
	"BOMBER",
	"BSKTBALL",
	"CAMERA",
	"CARRY",
	"COP_AMBIENT",
	"CRACK",
	"CRIB",
	"DANCING",		
	"DEALER",
	"FOOD",
	"GANGS",
	"GHANDS",
	"GRAVEYARD",
	"INT_HOUSE",
	"INT_OFFICE",
	"INT_SHOP",
	"JST_BUISNESS",
	"KISSING",
	"LOWRIDER",
	"MEDIC",
	"MISC",
	"ON_LOOKERS",
	"OTB",
	"PARK",
	"PAULNMAC",
	"PED",
	"POLICE",
	"RAPPING",
	"RIOT",
	"SHOP",
	"SMOKING",
	"SWAT",
	"SWEET"
};

// ------------------------------------------
new map_icons[11][E_MAP_ICONS_STRUCT] = 
{
	{514.92100, 1641.4650, 	12.5089, 	11},	// �������
	{2296.8718, 1757.0005, 	1.02340, 	11}, 	// ������
	{1912.0990, 2227.6367, 	16.0831, 	36}, 	// ���������
	{627.24870, 799.35870, 	12.6472, 	52}, 	// ����������� ���� ��������
	{-138.9926, 596.6835, 	12.1355, 	24}, 	// ����� ������ (���������� �� ������)
	{-286.9034, 576.8859, 	12.8447, 	22}, 	// �������� ��������
	{210.2719, 	1472.5919, 	12.6686, 	30},	// ���
	{26.4780, 	279.5637, 	12.5592, 	30},	// ���
	{-402.3015, 928.0378, 	12.5063, 	30},	// ���
	{-104.4065, -304.4529, 	4.2299, 	19}, 	// �������������
	{-1085.168, 2182.3547, 	38.0679, 	51} 	// �����
	
	//{1841.5697, 2535.8357, 15.6639, 20}, 	// ������ ���������
	//{1591.9219, -281.4026, 4.0002, 20}, 	// ������ ���������
	//{-2243.6758, 263.2350, 24.5337, 55}, 	// ����-���� �����
	//{-1511.0200, 1608.1721, 36.7735, 55}, // ��������� "�������"
	//{1757.3501, 2242.5107, 15.8600, 55}, 	// ��������� "��������"
	//{2503.4800, -653.8940, 12.2938, 55}, 	// ��������� "������"
	//{2396.0789, -592.4421, 12.1172, 11}, 	// �������
	/*
	{287.500, -1611.920, 32.957, 	19},	// ������������ �����
	{1481.051, -1800.310, 18.796, 	19},	// ����� ���-�������
	{-2766.552, 375.595, 6.335, 	19},	// ����� ���-������
	{2388.997, 2466.012, 10.820, 	19},	// ����� ���-���������
	{954.032, -909.013, 45.766, 	19},	// ������������� ����������
	{-2026.628, -102.066, 35.164, 	36},	// ���������
	{1040.088, 1303.406, 10.820, 	46},	// ���������
	{543.785, -1285.105, 17.242, 	55},	// ��������� ������-������ (��)
	{-1969.977, 293.892, 35.172, 	55},	// ��������� �������� ������ (��)
	{-1639.857, 1203.093, 7.232, 	55},	// ��������� �������� ������ �2 (��)
	{2467.908, 1344.219, 10.820, 	55},	// ��������� ������� ������ (��)
	{2132.337, -1141.279, 25.148, 	55},  	// ����-���� ����� (��)
	{-2934.215, 472.714, 4.907,   	9},		// �������� ������� ���-������
	{2695.593, -1704.764, 11.844, 	33},	// ����������� ������� (���-������)
	{-2110.070, -445.780, 38.734, 	33},	// ������� ���-������
	{1094.051, 1597.350, 12.547,  	33},	// ������� ���-���������
	{-1987.333, 1117.820, 54.231, 	21},	// ������� ���-������
	{1124.510, -2037.007, 69.884, 	34},	// ����������
	{1685.279, -2326.648, 13.547, 	5}, 	// �������� ���-�������
	{-1423.747, -287.906, 14.148,	5}, 	// �������� ���-������
	{1687.536, 1448.273, 10.768, 	5},		// �������� ���-���������
	{-2057.501, 455.467, 35.172,	30},	// ������������ ���������� ���
	{1555.497, -1675.592, 16.195, 	30},    // ������� ���-�������
	{-1605.628, 710.627, 13.867, 	30},    // ������� ���-������
	{2287.098, 2432.367, 10.820, 	30},    // ������� ���-���������
	{-2440.141, 505.018, 29.945, 	30},    // ���� ���
	{-2723.119, -318.415, 7.844, 	22},    // ������������ ���������������
	{1172.645, -1323.426, 15.403, 	22},    // �������� ���-�������
	{-2655.147, 636.045, 14.453, 	22},    // �������� ���-������
	{1607.554, 1820.330, 10.828, 	22},    // �������� ���-���������
	{2799.1135, -2393.9070, 13.956, 11},	// ��������� ����� (������ ��������)
	{570.8985, 845.2556, -42.0601, 	11},    // ����� (������ �������)
	{25.2571, 2016.1414, 17.6406, 	11},    // ��������� �����
	{1755.867, -1471.561, 13.547, 	20},    // �������� ������� ���-�������
	{-2026.678, 67.173, 28.692, 	20},    // �������� ������� ���-������
	{1737.635, 2086.132, 12.355, 	20},    // �������� ������� ���-���������
	{1420.517, -1623.777, 13.547, 	52},	// ���� ���-�������
	{-1497.862, 920.231, 7.188, 	52},	// ���� ���-������
	{2303.827, -16.188, 26.484, 	52},	// ���� Palomino Creek
	{-2164.409, -2417.677, 30.625, 	52},	// ������� ���� Angel Pine
	{-828.056, 1502.750, 19.547, 	52},	// ������� ���� Las Barrancas
	{-180.739, 1133.177, 19.742, 	52},	// ������� ���� Fort Carson
	{1368.9955, -1279.7224, 13.546,	18},	// ���� ��
	{-2625.8804, 208.2350, 4.8125, 	18}, 	// ���� ��
	{2159.5447, 943.2023, 10.8203, 	18} 	// ���� ��
	*/
};

// ------------------------------------------
/*
new g_teleport[52][E_TELEPORT_STRUCT] =
{
	{"����\n�����", 570.8985,845.2556,-42.0601, 0, 2397.721923, -1506.840820, 1402.199951, 270.0, 1, 1, T_ACTION_TYPE_BLOCK_LEAVE_AREA},
	{"�����\n�����", 2395.729003,-1506.856323,1402.199951, 1, 570.8123,846.9236,-42.1782, 0.0, 0, 0},
	{"��������� �����\n{33CC00}���������������� ���", 25.2571,2016.1414,17.6406, 0, 2575.1948,-1293.1644,1044.1250,180.0, 2, 1},
	{"����� �� ����", 2577.2488,-1289.8835,1044.1250, 1, 21.7136,2016.1512,17.6406,90.0, 0, 0, T_ACTION_TYPE_END_JOB},
	{"����\n�����������", 1033.8883, -325.4606, 73.9922, 0, 2575.3811, -1290.1753, 1044.1250, 180.0, 2, 2},
	{"�����\n�����������", 2577.2488,-1289.8835,1044.1250, 2, 1033.4058,-328.9309,73.9922, 180.0, 0, 0},
	{"����\n������� ������", 461.7169,-1500.8733,31.0444, 0, 206.9517,-138.5365,1003.5078, 0.0, 3, 1},
	{"�����\n������� ������", 207.0709,-140.3752,1003.5078, 1, 459.2207,-1501.2341,31.0386, 100.0, 0, 0},
	{"����\n���� ������������", 1956.732177, -2183.552978, 13.546875, 0, 2477.898437, -1659.801879, 1301.085937, 250.0, 1, 1},
	{"�����\n���� ������������", 2476.794921, -1658.118896, 1301.085937, 1, 1959.842651, -2183.815673, 13.546875, 270.0, 0, 0},
	{"����\n����������� �����", 1455.9126,751.0781,11.0234, 0, 2778.327636, -68.417030, 1318.838989, 180.0, 5, 2},
	{"�����\n����������� �����", 2778.209472, -65.624015, 1318.838989, 1, 1452.3975,751.8056,11.0234, 90.0, 0, 0},
	{"����\n��������� �����", 691.5789,-1275.8549,13.5607, 0, 2778.327636, -68.417030, 1318.838989, 180.0, 5, 3},
	{"�����\n��������� �����", 2778.209472, -65.624015, 1318.838989, 3, 687.0280,-1275.7273,13.5569, 90.0, 0, 0},
    {"����\n������� ����", -2719.3574,-319.1553,7.8438, 0, 2778.327636, -68.417030, 1318.838989, 180.0, 5, 1},
	{"�����\n������� �����", 2778.209472, -65.624015, 1318.838989, 1, -2720.8040,-317.0984,7.8438, 46.0, 0, 0},
	{"����\n����� ��������", -2520.9468,-624.9526,132.7846, 0, 302.0153,309.8619,1003.3047, 270.0, 4, 1},
	{"�����\n����� ��������", -2514.9038,-631.6369,548.1392, 1, 2260.8569,-1020.9139,59.2800, 180.0, 0, 0},
	{"����\n�����", 2259.4182,-1019.1157,59.2972,0, 302.0153,309.8619,1003.3047, 270.0, 4, 1},
	{"�����\n�����", 299.7824,310.0197,1003.3047,1, 2260.8569,-1020.9139,59.2800, 180.0, 0, 0},
	{"����\n����", 2495.3813,-1691.1393,14.7656,0, 2496.049804,-1695.238159,1014.742187, 180.0, 3, 1},
	{"�����\n����", 2495.9705,-1692.0834,1014.7422,1, 2495.2136,-1687.4659,13.5154, 0.0, 0, 0},
	{"����\n������", 2148.9360,-1484.8567,26.6241,0, -42.5746,1407.6147,1084.4297, 0.0, 8, 1},
	{"�����\n������", -42.5770,1405.4683,1084.4297,1, 2144.9917,-1484.8490,25.5391, 90.0, 0, 0},
	{"����\n�����", 1898.9922,-2037.9436,13.5469,0, 223.8624,1239.9827,1082.1406, 90.0, 2, 5},
	{"�����\n�����", 226.7878,1239.9513,1082.1406,5, 1896.7347,-2037.7805,13.5469, 90.0, 0, 0},
	{"����\n����", 2736.6499,-1952.5166,13.5469,0, 2807.7478,-1172.0414,1025.5703, 0.0, 8, 1},
	{"�����\n����", 2807.6338,-1174.7565,1025.5703,1, 2734.1616,-1952.8425,13.5469, 90.0, 0, 0},
	{"����\n���� ��", 	1368.9955,-1279.7224,13.5469, 0, 286.3327,-39.3856,1001.5156, 0.0, 1, 1},
	{"�����\n���� ��", 	285.4695,-41.8051,1001.5156, 1, 1366.2191,-1279.9414,13.5469, 90.0, 0, 0},
	{"����\n���� ��", 	-2625.8804,208.2350,4.8125, 0, 286.3327,-39.3856,1001.5156, 0.0, 2, 1},
	{"�����\n���� ��",	285.4695,-41.8051,1001.5156, 2, -2625.3286,210.9437,4.6314, 360.0, 0, 0},
	{"����\n���� ��", 	2159.5447,943.2023,10.8203, 0, 286.3327,-39.3856,1001.5156, 0.0, 1, 3},
	{"�����\n���� ��", 	285.4695,-41.8051,1001.5156,3, 2156.4705,943.6053,10.8203, 90.0, 0, 0},
	{"����\n���", 1038.8992,1013.1218,11.0000, 0, 207.6686,157.0205,925.4333, 270.0, 1, 1},
	{"�����\n���", 204.9490,157.1571,925.4330, 1, 1041.0848,1014.7623,11.0000, 315.0, 0, 0},
	{"����\n�������", 155.7305,1901.9454,18.6063, 0, -2487.3525,178.0012,2621.0859, 90.0, 1, 1},
	{"�����\n�������", -2485.2573,177.7570,2621.0859, 1, 153.7357,1902.3890,18.9145, 90.0, 0, 0},
	{"����\n����� ������", 206.9499,1923.3923,18.6550, 0, 316.6254,-168.4615,999.5938, 0.0, 6, 6},
	{"�����\n����� ������", 316.3639,-170.2976,999.5938,6, 210.9184,1921.5452,17.6406, 180.0, 0, 0},
	{"���������", -2026.5953,-102.0658,35.1641, 0, 525.1722,-47.5821,712.8599, 270.0, 1, 1},
	{"�����\n���������", 523.1808,-47.5365,712.8599, 1, -2026.3342,-99.7921,35.1641, 0.0, 0, 0},
	{"����\n����", 1465.0688,-1009.9221,26.8438, 0, 1468.7880,-1014.1956,38.1769, 90.0, 0, 0},
	{"�����\n����", 1471.1272,-1014.2170,38.1769, 0, 1465.6125,-1012.0323,26.8438, 180.0, 0, 0},
	{"����\n��������", 1172.0773,-1323.3893,15.4031, 0, 2051.1880,-1417.5800,2070.2959, 0.0, 1, 1},
	{"�����\n��������", 2051.3533,-1419.9624,2070.2959, 1, 1176.6151,-1323.4407,14.0301, 270.0, 0, 0},
	{"�����\n���-�������", 	1482.6595,-1772.2944,18.7958, 0, 406.8736,212.2076,1043.6328, 90.0, 1, 1},
	{"�����\n����� ��", 	410.2859,212.3754,1043.6328, 1, 1482.6603, -1768.4550, 18.7958, 360.0, 0, 0},
	{"�����\n���-������", 	-2766.5405,375.6842,6.3347, 0, 406.8736,212.2076,1043.6328, 90.0, 1, 2},
	{"�����\n����� ��", 	410.2859,212.3754,1043.6328, 2, -2762.1362,375.5802,5.5070, 270.0, 0, 0},
	{"�����\n���-���������", 2388.9978,2466.0266,10.8203, 0, 406.8736,212.2076,1043.6328, 90.0, 1, 3},
	{"�����\n����� ��", 	410.2859,212.3754,1043.6328, 3, 2386.4724,2465.7424,10.8203, 90.0, 0, 0}
};
*/

new g_teleport[34][E_TELEPORT_STRUCT] =
{
	{"�����\n{33CC00}���������������� ���", -1060.9310, 2208.5684, 38.0988, 0, 315.6848, -204.5266, 1006.5694, 90.0, 1, 0, T_ACTION_TYPE_BLOCK_LEAVE_AREA},
	{"", 318.0378,-204.4543,1006.5694, 0, -1060.7987,2203.4385,38.0989, 180.0, 0, 0},
	// -------------------------------------------------------------------------------
	{"", -1102.7938, 2208.4773, 37.8580, 0, 314.6193, -218.8094, 1006.5694, 90.0, 1, 0, T_ACTION_TYPE_BLOCK_LEAVE_AREA}, // �������� �����
	{"", 317.0608, -221.2321, 1006.5694, 0, -1102.7172, 2206.0437, 37.8877, 180.0, 0, 0}, // �������� �����
	// -------------------------------------------------------------------------------
	{"����� ������", -138.9926, 596.6835, 12.1355, 0, 489.8380, -12.5441, 1052.0000, 358.9150, 1, 4},
	{"", 489.8348, -15.8222, 1052.0000, 4, -139.4077, 592.3151, 12.1494, 179.5118, 0, 0},
	// -------------------------------------------------------------------------------
	{"�������� ��������", -286.9034, 576.8859, 12.8447, 0, 1120.3513, -22.6750, 1011.1254, 269.5909, 1, 5},
	{"", 1118.1277, -22.5806, 1011.1254, 5, -286.9034, 579.4, 12.8447, 354.4593, 0, 0},
	// -------------------------------------------------------------------------------
	{"", 538.3043,1672.0179,12.1955, 0, 538.5048,1674.9487,12.0097,356.6738, 0, 0}, // ���� �� ��
	{"", 538.3818,1672.8396,12.0097, 0, 538.1058,1670.1481,12.1955,174.7493, 0, 0}, // ����� �� ��
	// -------------------------------------------------------------------------------
	{"�����������\n���� ��������", 627.2487, 799.3587, 12.6472, 0, 911.2521, -786.0607, 1000.5416, 89.0107, 1, 16}, // ���� � ����������� ���� ��������
	{"", 914.2891, -786.1344, 1000.5416, 16, 623.4645, 800.7191, 12.0192, 69.1266, 0, 0}, // ����� �� ����������� ���� ��������
	// -------------------------------------------------------------------------------
	{"�����", 2377.1404, 1725.7539, -2.1648, 0, -2558.8240, 314.2043, -15.7640, 180.6500, 2, 1, T_ACTION_TYPE_BLOCK_LEAVE_AREA}, // ���� � �����
	{"", -2558.7898, 316.3336, -15.7640, 1, 2379.3459,1725.8730,-2.1649,274.3989, 0, 0}, // ����� �� �����
	// -------------------------------------------------------------------------------
	{"�������� �����\n{33CC00}'��������'", 1841.5697, 2535.8357, 15.6639, 0, 1799.6274, 2513.4370, -5.8868, 182.5208, 6, 2}, // ���� � ���
	{"", 1799.5596, 2515.1777, -5.8868, 2, 1844.3589, 2537.6721, 15.6639, 306.2065, 0, 0}, // ����� �� ���		
	// -------------------------------------------------------------------------------
	{"�������� �����\n{33CC00}'���������'", 1591.9219, -281.4026, 4.0002, 0, 1799.6274, 2513.4370, -5.8868, 182.5208, 6, 3}, // ���� � ���
	{"", 1799.5596, 2515.1777, -5.8868, 3, 1593.8488, -281.4505, 4.0055, 270.6624, 0, 0}, // ����� �� ���		
	// -------------------------------------------------------------------------------
	{"������\n�������-���������� ������", 210.2719, 1472.5919, 12.6686, 0, 431.2317, 58.0819, 996.7030, 88.9639, 1, 5}, // ���� ���
	{"", 433.6407, 57.9804, 996.7030, 5, 207.2138, 1473.2456,12.0191, 75.8276, 0, 0}, // ����� ���
	// -------------------------------------------------------------------------------
	{"������\n���������-�������� ������", 26.4780, 279.5637, 12.5592, 0, 431.2317, 58.0819, 996.7030, 88.9639, 1, 6}, // ���� ���
	{"", 433.6407, 57.9804, 996.7030, 6, 23.4808, 280.7559, 12.0264, 69.2843, 0, 0}, // ����� ���
	// -------------------------------------------------------------------------------
	{"�����������\n������ ������������", -402.3015, 928.0378, 12.5063, 0, 209.4036, -467.8933, 1006.4179, 0.9636, 3, 17},
	{"", 209.4896, -469.7577, 1006.4179, 17, -399.4424, 928.1506,12.1524, 272.3279, 0, 0},
	// -------------------------------------------------------------------------------
	{"", 1163.9615, -443.4521, 4.2487, 0, 792.1524, -126.2730, 1014.2467, 180.3368, 3, 18}, // ����� ���� � �����
	{"", 792.1251, -124.4529, 1014.2467, 18, 1165.9470, -443.2975, 4.2890, 270.8603, 0, 0}, // �����
	// -------------------------------------------------------------------------------
	{"�����", 2275.4463, 1420.2875, 11.7898, 0, 37.2773, 1108.3313, 1007.2911, 90.2186, 3, 19}, // ����� ���� 
	{"", 40.7215, 1108.4600, 1007.2911, 19, 2275.3875, 1416.4816, 11.4501, 181.8038, 0, 0}, // ����� �� �����
	// -------------------------------------------------------------------------------
	{"�����������", 62.7362, 675.2307, 7.9805, 0, 599.9689, -447.8394, 974.5893, 93.5427, 3, 20}, // ����������� ���� 
	{"", 602.1327, -447.7533, 974.5909, 20, 63.4048, 677.4546, 6.7843, 344.1649, 0, 0}, // ����� �� �����������
	// -------------------------------------------------------------------------------
	{"�������������\n�������", -104.4065, -304.4529, 4.2299, 0, 1581.5858, -774.3824, 1114.7073, 90.8444, 3, 21}, // ������������� ���� 
	{"", 1583.7642, -774.3983, 1114.7073, 21, -101.4107, -302.7359, 4.2319, 280.4361, 0, 0}, // ����� �� �������������
	// -------------------------------------------------------------------------------
	{"", -95.6682, -324.0653, 4.2266, 0, 1571.8551, -782.3239, 1114.7073, 358.7234, 3, 21}, // ������������� ���� (�� ����. ��������)
	{"", 1571.8879, -785.3734, 1114.7073, 21, -95.2252, -327.4579, 4.2266, 187.1833, 0, 0} // ����� �� ������������� (�� ����. ��������)
	// -------------------------------------------------------------------------------
};
new g_teleport_object[MAX_PLAYERS][2];

// ------------------------------------------
new driving_tutorial[4][E_DRIVING_TUTORIAL_STRUCT] = 
{
	{
		"���������� ��������� ����������", 
		"{669900}���� �������� �������� ������ ���������� ����������� � �� ��������:\n\n"\
		"{3399FF}����� Ctrl\t{FFFFFF}������� ��� ��������� ���������\n"\
		"{3399FF}����� Alt\t{FFFFFF}�������� ��� ��������� ����\n"\
		"{3399FF}������ Ctrl\t{FFFFFF}������� ��� ������� ������ {9966FF}(������ ��� �������� ������)\n"\
		"{3399FF}Num 4\t\t{FFFFFF}�������� ��� ��������� ������������ ��������\n"\
		"{3399FF}Num 8\t\t{FFFFFF}���������� ������� � ���������� {9966FF}(���� ��� ������� � ������ ������)\n"\
		"{3399FF}Num 2\t\t{FFFFFF}��������� ��������� {9966FF}(��������� � ��������� ��������)\n\n"\
		"{FFFF00}������������ ��������� ���������� ������ ����������\n"\
		"����� ������ ������ ������� \"�����\""
	},
	{
		"������ �����������", 
		"{FFFFFF}������ ����������� ���������� � ������ ������ ���� ������ ��� ������ �� �������� � ����� ���������\n"\
		"��� ����������� �������� � ��� ������� ���������. ����, ���������� �������� �������� ���� ������:\n\n"\
		"\t{3366FF}25 km/h  {00CCFF}Fuel: 45  {006699}1000\n"\
		"\t{00CC00}Open  {FF3300}max  {FFFFFF}E {009933}S   M {FFFFFF}L B\n\n"\
		"{FFFF00}�� ������ ������� ������ ��������� �������� ����������:\n"\
		"{3366FF}25 km/h\t{FFFFFF}���������� ������� �������� ����������\n"\
		"{00CCFF}Fuel: 45\t{FFFFFF}���������� ���������� ������� � ����\n"\
		"{006699}1000\t\t{FFFFFF}���������� \"��������\" ����������. ���� � ���� ��� �����������, �� ��� ����� ����� 1000\n\n"\
		"{FFFF00}�� ������ ������� ��������� �������� ����������:\n"\
		"{00CC00}Open\t\t{FFFFFF}(��� {FF3300}Close{FFFFFF}) ���������� ������ ��� ������ ���������\n"\
		"{FF3300}max\t\t{FFFFFF}���������� ������� ��� ���������� ������������ ��������\n"\
		"E\t\t���������� ������� ��� ������ ������ ������� � ����\n"\
		"{CC99CC}S\t\t{FFFFFF}���������� ��������� ��� ���������� ������������\n"\
		"{009933}M\t\t{FFFFFF}��������� ����������� ���������\n"\
		"L\t\t��������� ����������� ����� ���\n"\
		"B\t\t���������� ������� ��� �������� ��������� ��� ������\n\n"\
		"{9966FF}����������:\n"\
		"1. ������ ����������� ����������� ��� � �������\n"\
		"2. ����������� ���������� �� ������ ���� {FFFFFF}������ {9966FF}�����"
	},
	{
		"�������� � ������",
		"{FFFFFF}��������� ����� �� ������� ���������� ����������. ������� ��� ����� ����� ���������:\n\n"\
		"{FFFF00}1. �� ����������� �������\n"\
		"{FFFFFF}��� ����� ��������� � ��� � ������� {3366FF}Num 2{FFFFFF}. ������ ������� ���������� ��� ��������� �� 10 ������\n\n"\
		"{FFFF00}2. �������� � ��������\n"\
		"{FFFFFF}����� ������ �������� ���� ���������� �� ����� ������ ��-�� ���������� �������\n"\
		"������� ��������� �������� � �������� {3366FF}/buyfuel{FFFFFF}. �� �������� �������� �������� 15 ������\n"\
		"����� ����� ������ ��������� � ����������, ������� ������ ���������. 15 ������ ������ ������ ����� ������� �� ��������� ��������\n\n"\
		"{66CCCC}�������� ������:\n"\
		"1. �������� ����� �������� �������� 150 ������ �������. ��� ������ �� 50 ����� ������������ ������ ���������\n"\
		"2. ������ ���������� ��������� ����� �������� �� ������ ��� ����� ������ �� �����! ���� �� ������� ��������� ������ �������\n"\
		"3. ����� �� ������ �� ��������� ������� ���� �������� ������� ����� ������� �������� (/c)\n\n"\
		"{99CC66}�������� ��������� ����� � ����� ����������� ������ ���� ������ �������� (/c)\n"\
		"�������� ��������, ��� ���� ��������� ��� ������������ ���� ��������� ���������, �� �������� �������� ��� ���������� ��� ������!"
	},
	{
		"������� ��������� ��������",
		"{66CC00}1. ����� ���������\n"\
		"{FFFFFF}����� ������������ ������� �������� ������ � ����� �������\n"\
		"��� ���� �������� ������ ��������� ��� ��������� ������ �������� �� ����������� ��� ������ ����������\n"\
		"��� ��� ��������� ������������� ������� ������� (/c) � ��������� ������� ���\n"\
		"{66CC00}2. �������� ��������\n"\
		"{FFFFFF}����������� �������� �������� � �������� ������� � �������� 50 ��/�\n"\
		"�� ��������� ���������� ������� ����������� �������� ���\n"\
		"��� ���������� ����������� ������ ������������� ������������ ������������� ��������, ������� ���������� �������� {3366FF}Num 4\n"\
		"{66CC00}3. ��������� � �������\n"\
		"{FFFFFF}��������� � ������� ������������ ������� ����������� ������ �� ������� ������ ��� � ���������� ���������� ��� ����� ������\n"\
		"�� ��������� ����� ������� ��� ���������� ����� ���� ��������� �� ������������\n"\
		"{66CC00}4. ���\n"\
		"{FFFFFF}��� ���� ���������� � ���������� ������� �������� ������ ������� �������� � ��������� � �������\n"\
		"�������� ������ ���������� ��������� ��� ���������, ������� �� ��������"
	}
};

new const 
	Float: driving_exam_route[27][3] = // ������� ��������
{
	{1908.1394,2246.4573,15.2793}, // 1
	{1887.2677,2233.8284,15.5133},
	{1827.6771,2229.1616,15.4069},
	{1768.4437,2204.5515,15.5672},
	{1769.0942,2057.4329,15.5118},
	{1876.7019,2053.6848,15.4542},
	{1963.1599,2027.2074,15.4588},
	{1962.9563,1917.6659,15.0649},
	{1984.8197,1902.6099,15.0857},
	{2235.5906,1903.8340,15.4785}, //10
	{2359.4978,1911.4387,15.4939},
	{2382.5203,1892.3778,15.2946},
	{2751.3455,1892.0446,15.8760},
	{2762.2747,2107.1575,17.6485},
	{2755.5586,2339.7378,15.6725},
	{2437.3162,2951.3494,22.6093},
	{2093.8494,2965.3408,11.5355},
	{2070.2361,2940.9878,11.4323},
	{1935.4342,2709.0713,14.7915}, // 20
	{1746.3171,2531.9512,14.9293},
	{1882.4036,2312.2119,15.5184},
	{1888.2998,2255.1619,15.5189},
	{1896.7715,2246.6313,15.3917},
	{1910.5236,2246.4551,15.2868},
	{1919.3710,2248.3159,15.2849},
	{1924.2465,2228.0378,15.7248},
	{0.0, 0.0, 0.0}
};

new driving_exam[12][E_DRIVING_EXAM_STRUCT] = 
{
	{
		"��� �������� ������� ����� \"M\" �� ������ �����������?",
		"���������� ����\n"\
		"����������� ����\n"\
		"���������� ���������\n"\
		"����������� ���������\n"\
		"�������� ��������\n"\
		"�������� ��������\n"\
		"���������� ������������\n"\
		"�������� �����",
		3
	},
	{
		"����� �������� ���. � ����. ����?",
		"����� Ctrl\n"\
		"����� Alt\n"\
		"������ Ctrl\n"\
		"Num 2\n"\
		"Num 4",
		2
	},
	{
		"����������� �������� �������� �� ������:",
		"50 ��/�\n"\
		"60 ��/�\n"\
		"70 ��/�\n"\
		"80 ��/�\n"\
		"90 ��/�",
		1
	},
	{
		"����� ����������� �� ����������� ������� ����:",
		"������� ��������\n"\
		"������ {0099CC}������ Ctrl\n"\
		"������ ������� {0099CC}/fill\n"\
		"������ {0099CC}����� Alt\n"\
		"������ {0099CC}Num 2\n"\
		"�� ���� �� ��������� �� ��������",
		5
	},
	{
		"��� �������� ��� ��������� ���������?",
		"������ ������� {0099CC}/buyfuel\n"\
		"������ {0099CC}����� Ctrl\n"\
		"������ {0099CC}����� Alt\n"\
		"������ ������� {0099CC}/start\n"\
		"������ {0099CC}Num 2\n"\
		"��� ������ �������",
		2
	},
	{
		"��� �������� \"Fuel: 45\" �� ������ �����������?",
		"������� �������� {0099CC}45 ��/�\n"\
		"������� ����������� ���� {0099CC}45 ������\n"\
		"���� ���������� {0099CC}45\n"\
		"� ��������� �������� {0099CC}45 ������\n"\
		"��� ����������� ������",
		4
	},
	{
		"��� ����� �������, ����� ��������� ������ �������?",
		"����� �� ������\n"\
		"��������� ���������\n"\
		"��������� ���� / ������������\n"\
		"�������� ������������ ��������\n"\
		"������� ������\n"\
		"��������������� ���������",
		2
	},
	{
		"��� ������� ��� ������� �������� ������?",
		"������ {0099CC}Num 8\n"\
		"������ {0099CC}����� Ctrl\n"\
		"������ {0099CC}������ Ctrl\n"\
		"������ {0099CC}Num 2\n"\
		"������ ������� {0099CC}/fill\n"\
		"������ ������� {0099CC}/buyfuel\n"\
		"��� ������ �������",
		3
	},
	{
		"��� ������ ��������� ����� ������ ���������?",
		"20 �����\n"\
		"30 �����\n"\
		"40 �����\n"\
		"50 �����\n"\
		"1 ���\n"\
		"����� 1 ����",
		4
	},
	{
		"��� �������� ��� ��������� ������������ ��������?",
		"�������� {0099CC}Num 2\n"\
		"�������� {0099CC}Num 4\n"\
		"�������� {0099CC}H\n"\
		"�������� {0099CC}����� Ctrl\n"\
		"��� ���������� �������",
		2
	},
	{
		"�� ������ ����������� ���������� \"�\". ��� ��� ������?",
		"��� ������� ������������ ��������\n"\
		"��� ������ ����� ��� ��������\n"\
		"���� �������� ������������\n"\
		"������ ������� ������� � ����\n"\
		"������ ������� \"��������\" ����\n"\
		"�������� ����",
		4
	},
	{
		"��� ���� ���������� � ���������� ������� ��:",
		"���������� �������� � ���������� ���������\n"\
		"���������� �������� ������ ��������\n"\
		"��������� ��������\n"\
		"����������� ��������\n"\
		"����� ������������ ��������� ��� �����������",
		5
	}
};
new driving_exam_CP; // ������� ����� �� �����

new g_player_driving_exam[MAX_PLAYERS][E_PLAYER_DRIVING_EXAM_STRUCT];
new g_driving_exam_default_values[E_PLAYER_DRIVING_EXAM_STRUCT] = {-1, ...};

// ------------------------------------------
new const 
	g_atm[8][E_ATM_STRUCT] = 
{
	{-1511.15027, 1636.50964, 36.41260, 90.0},
	{-2464.71216, 2830.91772, 37.48680, 0.0},
	{-2214.18066, 225.81171, 24.06897, -5.7},
	{1602.33472, -249.26440, 3.59900, 90.0},
	{2473.59741, -726.61267, 11.91240, 0.0},
	{1851.37952, 2243.51758, 14.90830, 90.0},
	{1596.67590, 2935.94165, 11.71050, 90.0},
	{-524.22839, -1651.11462, 40.40490, 58.86000}
};
new const 
	atm_item_sum[7] = {100, 200, 500, 1000, 2000, 5000, 10000};
	
// ------------------------------------------
enum 
{
	GATE_ID_DRIVING_SCHOOL = 0, // ���������	
}
new 
	g_gate[MAX_GATES][E_GATE_STRUCT] = 
{
	{"��", GATE_TYPE_BARRIER, 1906.5250, 2248.1470, 14.0, 90.0, 0.0, 0.0, 0.0, 0.0, GATE_STATUS_CLOSE, {0, 0}},
	{"���", GATE_TYPE_BARRIER_BUTTON, 214.5169, 1503.8608, 10.9933, 78.1200, 213.18, 1496.79, 12.66, 260.0, GATE_STATUS_CLOSE, {0, 0}}
};
new g_gate_button[MAX_GATES][2];
new g_gate_buttons_count;

// ------------------------------------------
new g_bank_account[MAX_PLAYERS][MAX_BANK_ACCOUNTS][E_BANK_ACCOUNT_STRUCT];
new g_player_bank_transfer[MAX_PLAYERS][E_BANK_TRANSFER_STRUCT];

// ------------------------------------------
new g_player_listitem[MAX_PLAYERS][32]; 
new g_listitem_values[sizeof(g_player_listitem[])] = {0, ...};

new g_player_listitem_use[MAX_PLAYERS] = {-1, ...};
// ------------------------------------------
new g_player_offer[MAX_PLAYERS][E_PLAYER_OFFER_STURCT];
new const
	g_offer_default_values[E_PLAYER_OFFER_STURCT] = 
{
	INVALID_PLAYER_ID,	// ����������� ����������� ������
	INVALID_PLAYER_ID, 	// �������� ����������� �� ������
	OFFER_TYPE_NONE, 	// �������� �����������
	{-1, -1} 			// �������� ��������� �����������
};

// ------------------------------------------
new g_player_phone_call[MAX_PLAYERS][E_PHONE_CALL_STRUCT];
new 
	g_phone_call_default_values[E_PHONE_CALL_STRUCT] = 
{
	INVALID_PLAYER_ID,
	INVALID_PLAYER_ID,
	-1,
	true
};

// ------------------------------------------
new g_player_phone_book[MAX_PLAYERS][MAX_PHONE_BOOK_CONTACTS][E_PHONE_BOOK_STRUCT];

new g_player_phone_book_contacts[MAX_PLAYERS] = {0, ...};
new g_player_phone_book_select_cont[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...};

new bool: g_player_phone_book_init[MAX_PLAYERS] = {false, ...};

// ------------------------------------------
new g_player_flood[MAX_PLAYERS][E_ANTI_FLOOD_STRUCT];
new const
	g_flood_default_values[E_ANTI_FLOOD_STRUCT] = 
{
	0,
	0
};

// ------------------------------------------
new g_bus_routes[5][E_BUS_ROUTE_STRUCT] = 
{
	{"�� ������ �� � ������� ������",	0, 0},
	{"�� ������ �� � ������� �����", 	0, 0},
	{"�� ������ �� � �������� �����", 	0, 0},
	{"�� ������ �� � �������� ����",	0, 0},
	{"�� ������ �� � ���������", 		0, 0}
};
new g_bus_routes_list[40 * (sizeof g_bus_routes) + 1];

new g_bus_route[sizeof g_bus_routes][20][E_BUS_ROUTE_STEP_STRUCT] = 
{
	{ // �� ������ �� � ������� ������
		{1181.8380,-1837.0826,13.5410, false}, 	
		{1184.6484,-1759.5533,13.6079, true}, // ���������
		{1189.1763,-1714.2538,13.5531, false},
		{1295.2434,-1725.2010,13.5198, false},
		{1301.7908,-1854.7548,13.5090, false},
		{1371.1842,-1874.0991,13.5163, false},
		{1391.9124,-1838.7012,13.5122, false},
		{1379.3752,-1729.9628,13.5138, false},
		{1295.8943,-1844.2878,13.5161, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false}
	},
	{ // �� ������ �� � ������� �����
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false}
	},
	{ // �� ������ �� � �������� ����
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false}
	},
	{ // �� ������ �� � �������� �����
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false}
	},
	{ // �� ������ �� � ���������
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false},
		{0.0, 0.0, 0.0, false}
	}
};

// ------------------------------------------
new g_temp_jobs[4][E_TEMP_JOB_STRUCT] = 
{
	{514.9210, 1641.4650, 12.5089, 		45,	{27, 157}},  	// �������
	{2296.8718, 1757.0005, 1.0234, 		3,	{16, 157}},  	// ������
	{-1088.2688, 2167.4514, 38.0373, 	0,	{16, 157}}, 	// ����� (������ ��������)
	{264.9694, -215.0847, 1006.5694, 	0,	{258, 157}}  	// �����
};

// ---------------------------------------
new const
	Float: loader_job_unload_cp[2][3] = // ������� �������� (�������)
{
	{554.7645, 1621.5302, 12.2395},
	{555.4839, 1624.9852, 12.2395}
};
new const 
	loader_job_attach_obj[15][E_LOADER_JOB_ATTACH_OBJ_STRUCT] = // ����� (�����) (�������)
{
	{912,  0.6,  -0.6,   -0.2, 90.0, 90.0},
	{918,  0.42, -0.25, -0.1,  0.0,  90.0},
	{1271, 0.5,  -0.36,  -0.2, 90.0, 90.0},
	{1578, 0.42, 0.0,   -0.16, 90.0, 90.0},
	{1580, 0.42, 0.0,   0.16,  90.0, 90.0},
	{2060, 0.42, -0.145, -0.2, 90.0, 90.0},
	{2103, 0.45, -0.02, -0.15, 90.0, 90.0},
	{2478, 0.4,  -0.3,   -0.2, 90.0, 90.0},
	{2652, 0.5,  -0.52, -0.18, 90.0, 0.0,},
	{2654, 0.4,  -0.23, -0.18, 89.0, 0.0,},
	{2900, 0.7,  -0.03, -0.2,  90.0, 90.0},
	{2912, 0.55, -0.01, -0.2,  90.0, 90.0},
	{2968, 0.5,  -0.31, -0.2,  90.0, 90.0},
	{3052, 0.4,  -0.13, -0.2,  90.0, 90.0},
	{3057, 0.5,  -0.35, -0.2,  90.0, 0.0}
};
new loader_job_area; // ���� ����� (�������)

// ---------------------------------------
new const
	Float: miner_job_load_cp[4][3] = // ������� �������� (������)
{
	{2631.162109, -1502.657104, 1404.884643},
	{2624.353027, -1493.384765, 1407.405517},
	{2716.633789, -1524.434204, 1406.918457},
	{2725.595458, -1541.467041, 1403.932495}
};
new miner_carriage[2][E_MINER_CARRIAGE_STRUCT] = 
{
	{2429.8066406, -1513.9082031, 1398.1180420, 2545.5380859, -1514.1369629, 1397.7819824, false, 0},
	{2545.5380859, -1518.1899414, 1397.7819824, 2429.8066406, -1517.9755859, 1398.1669922, false, 0}
};
new miner_job_area; // ���� ����� (������)

// ---------------------------------------
new Text3D: factory_store_label[2];

new factory_job_area;
new factory_put_zone;
new
	Float: factory_take_metall_pos[5][3] = 
{
	{305.7406, -199.4771, 1006.5694},
	{300.1811, -199.4061, 1006.5694},
	{316.2808, -215.5371, 1006.5694},
	{306.0207, -219.4838, 1006.5694},
	{264.5123, -208.1692, 1006.5694}
};
new factory_desk[16][E_FACTORY_DESK_STRUCT];

// ------------------------------------------
new Cache: charity_cache_data; 	// ��� �������������
new g_last_pay_day_time; 		// ����� ���������� ������
new g_last_lottery_time; 		// ����� ���������� ��������� �������
new g_last_m_timer_time;		// ����� ���������� 1-��� �������

// ------------------------------------------
new const 
	numeric_name[7][11] = 
{
	"�������",
	"�������", 
	"��������", 
	"����������",
	"������", 
	"�������",
	"��������"
};

new const 
	job_name[5][18] = 
{
	"�����������",
	"�������� ��������",
	"�������",
	"�����������",
	"������������"
};

new const
	month_name[12][8 + 1] = 
{	
	"������", 
	"�������", 
	"�����",
	"������",
	"���",
	"����", 
	"����", 
	"�������",
	"��������", 
	"�������",
	"������", 
	"�������"
};

new const 
	day_name[7][12] =
{
	"�����������",
	"�������",
	"�����",
	"�������",
	"�������",
	"�������",
	"�����������"
};

new speedometr_line[32] = "IIIIIIIIIIIIIIIIIIIIIIIIIIIIII_";
new join_to_job_CP; // ����� �� ������

// ------------------------------------------
new const 
	g_item_type[2][E_ITEM_STRUCT] = 
{
	{"������", "���", true},
	{"��������", "�", false}
};

enum // ���� ���������
{
	ITEM_TYPE_MONEY = 0, // ������
	ITEM_TYPE_JERRICAN, // ��������
}

// ------------------------------------------
new const
	g_player_improvements[5][E_IMPROVEMENTS_STRUCT] = 
{
	{"������������", 	50_000, 	5},
	{"�������������", 	75_000, 	8},
	{"������", 			100_000, 	11},
	{"������ ��������", 125_000, 	15},
	{"������ ����������",150_000, 	17}
};

new chat_message[5][128 + 1];
new const
	reg_skin_data[2][14] = // ����� ��� �����������
{
	{78, 79, 132, 134, 135, 136, 137, 200, 212, 213, 230, 160, 0, 0}, // �������
	{10, 13, 31, 39, 54, 77, 129, 130, 151, 157, 196, 197, 198, 218} // �������
};

new const
	Float: spawn_pos_data[4][4] = // ������� �������
{	
	{538.3125, 1682.2540, 12.0097, 180.0},	// �������
	{-93.5919, 288.62830, 12.8760, 360.0},	// ������� (����-������) / 3 ���
	{1800.764, 2503.5032, 15.8725, 304.8},	// �������� / 5 ���
	{-2459.09, 2840.1787, 38.4074, 90.00}	// ����� / 10 ���
};

new const
	team_colors[1] = // �����
{
	0xFFFFFF11 // ��������� / �����������
};
// ------------------------------------------

public OnGameModeInit()
{
	new count = GetTickCount();

	Server:Init();
	
	CreateDynamic3DTextLabel("����� �� ������", 0xFFFF00FF, 489.7003, 5.9846, 1052.0 + 1.8, 10.0);
	join_to_job_CP = CreateDynamicCP(489.7003, 5.9846, 1052.0, 1.5, _, _, _, 15.0);
	CreatePickup(1210, 23, 489.7003, 5.9846, 1052.0, -1);
	
	g_last_lottery_time =
	g_last_pay_day_time = 
	g_last_m_timer_time = gettime();
	
	CreateTextDraws();
	CreateMenus();
	CreateVehicles();
	
	HelpInfoInit();
	ServerRadioInit();
	AnimListInit();
	BusRoutesInit();
	BanksInit();
	TempJobsInit();
	MapIconsInit();
	InfoPickupsInit();
	TeleportPickupsInit();
	DrivingSchoolInit();
	AtmsInit();
	GatesInit();
	
	#if defined RAND_WEATHER
	SetRandomWeather();
	#endif
	
	Object:Create();
	
	Database:Init();
	
	UpdateCharity();
	RepositoriesLoad();
	
	LoadEntrances();
	LoadHouses();
	LoadHousesRenters();
	EntranceStatusInitAll();
	
	LoadHotels();
	
	LoadFuelStations();
	LoadBusinesses();
	LoadOrders();
	
	LoadOwnableCars();
	LoadTrunks();
	
	SetTimer("ClearBanList", 15_000, false);

	printf("GameMode Initialized for %d (ms)", GetTickCount() - count);
	
	return 1;
}

public OnGameModeExit()
{
	SaveRepository();

	Database:Shutdown();

	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, FLOOD_RATE_INC, FLOOD_RATE_KICK);
	
	if(IsPlayerLogged(playerid))
	{
		SetPlayerSpawnInit(playerid);
	}
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, FLOOD_RATE_INC, FLOOD_RATE_KICK);

	if(!IsPlayerLogged(playerid))
	{
		new a_state = GetPlayerData(playerid, P_ACCOUNT_STATE);
		if(a_state != ACCOUNT_STATE_REG_SKIN)
		{
			new fmt_str[64];
			format(fmt_str, sizeof fmt_str, "{FFFFFF}��� ���� �� ������� �� ������ %s", a_state == ACCOUNT_STATE_REGISTER ? ("������ �����������") : ("����������������"));
			
			Dialog
			(
				playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
				"{FF6600}������",
				fmt_str,
				"�������", ""
			);
			Kick:(playerid);
			SendClientMessage(playerid, 0xFF6600FF, fmt_str[8]);
		}
	}	
	else if(IsPlayerLogged(playerid))
	{
		//SetPlayerSpawnInit(playerid);
		//SpawnPlayer(playerid);
		
		SendClientMessage(playerid, 0xFFFF00FF, "��� ����� ��������� �������� ����� ������� ������");
	}

	return 1;
}

public OnPlayerConnect(playerid)
{
	new hour, minute;
	gettime(hour, minute);
	
	SetPlayerTime(playerid, hour, minute);

	SetPlayerColor(playerid, 0x999999FF);
	TextDrawShowForPlayer(playerid, server_logo_TD);
	
	SetPlayerVirtualWorld(playerid, playerid + 0xFF);
	ClearPlayerInfo(playerid);
	
	GetPlayerName(playerid, g_player[playerid][P_NAME], 20 + 1);
	GetPlayerIp(playerid, g_player[playerid][P_IP], 16);

	#if defined _GANG_ZONES_INC
	ShowForPlayerGangZonesCR(playerid);
	#endif
	
	SetTimerEx("CheckPlayerAccount", 1000, false, "ii", playerid, mysql_race[playerid]);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	new buffer = GetPlayerLastVehicle(playerid);
	
	if(buffer != INVALID_VEHICLE_ID)
	{
		if(GetVehicleData(buffer, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_DRIVING_SCH)
		{
			if(GetPlayerDrivingExamInfo(playerid, DE_POINTS) >= 9)
			{
				SetVehicleToRespawn(buffer);
			}
		}	
	}
	if(IsPlayerInJob(playerid))
	{
		buffer = GetPlayerJobCar(playerid);
		if(buffer != INVALID_VEHICLE_ID)
		{
			SetVehicleToRespawn(buffer);
		}
	}
	KillEndJobTimer(playerid);
	
	buffer = GetPlayerData(playerid, P_FACTORY_USE_DESK);
	SetPlayerFactoryDeskUse(playerid, buffer, false);
	
	SavePlayerAccount(playerid);
	ClearPlayerInfo(playerid);
	return 1;
}

public: SavePlayerAccount(playerid)
{
	new query[155];
	format
	(
		query, sizeof query, 
		"UPDATE accounts SET "\ 
		"last_login=%d,"\ 
		"game_for_hour=%d,"\
		"game_for_day=%d,"\
		"game_for_day_prev=%d"\
		" WHERE id=%d LIMIT 1",
		gettime(),
		GetPlayerData(playerid, P_GAME_FOR_HOUR),
		GetPlayerData(playerid, P_GAME_FOR_DAY),
		GetPlayerData(playerid, P_GAME_FOR_DAY_PREV),
		GetPlayerAccountID(playerid)
	);
	mysql_query(mysql, query, false);
	
	return 1;
}

public OnPlayerSpawn(playerid)
{
	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, 500, FLOOD_RATE_KICK);

	if(!IsPlayerLogged(playerid))
	{
		if(GetPlayerData(playerid, P_ACCOUNT_STATE) == ACCOUNT_STATE_REG_SKIN)
		{
			new sex = bool: GetPlayerSex(playerid);
			
			TogglePlayerControllable(playerid, false);
			SetPlayerSelectSkin(playerid, 0, reg_skin_data[sex][0]);
			
			SetPlayerPosEx(playerid, 332.2033, -174.1066, 999.6743, 1.0, 10);
			SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_FOREARM, 1210, A_OBJECT_BONE_RIGHT_FOREARM, 0.535, 0.01, 0.1, 45.0, 270.0, 318.0, 1.0, 1.0, 1.0, 0);
		
			SetPlayerCameraPos(playerid, 335.067718, -170.856231, 1000.424804);
			SetPlayerCameraLookAt(playerid, 332.006469, -174.727508, 999.623596, 2);

			ShowPlayerSelectPanel(playerid, SELECT_PANEL_TYPE_REG_SKIN);
			ShowPlayerSelectPanelPrice(playerid, -1);
			
			PlayerTextDrawSetString(playerid, price_select_TD[playerid][1], "RM-RP.RU");
			//ShowMenuForPlayer(reg_select_skin_menu, playerid);
		}
	}
	else 
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		
		if(!GetPlayerData(playerid, P_ANIMS_INIT))		
		{
			PreLoadPlayerAnims(playerid);
			SetPlayerData(playerid, P_ANIMS_INIT, true);
		}
		
		if(GetPlayerData(playerid, P_MASK) >= 2)
		{
			SetPlayerColorInit(playerid);
			SetPlayerData(playerid, P_MASK, 0);
		}	
	}
	
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, 500, FLOOD_RATE_KICK);

	if(!IsPlayerLogged(playerid))
	{
		return Kick:(playerid, " ");
	}
	if(IsPlayerInJob(playerid))
	{
		EndPlayerJob(playerid);
	}
	if(GetPlayerTempJob(playerid) == TEMP_JOB_LOADER)
	{
		TogglePlayerDynamicCP(playerid, help_info_CP, true);
	}
	SetPlayerData(playerid, P_JOB_CAR, INVALID_VEHICLE_ID);
	
	SetPlayerDrivingExamInfo(playerid, DE_POINTS, 0);
	SetPlayerFactoryDeskUse(playerid, GetPlayerData(playerid, P_FACTORY_USE_DESK), false);
	
	SetPlayerData(playerid, P_IN_HOUSE, 		-1);
	SetPlayerData(playerid, P_IN_BUSINESS, 		-1);
	SetPlayerData(playerid, P_IN_HOTEL_FLOOR, 	-1);
	SetPlayerData(playerid, P_IN_HOTEL_ROOM, 	-1);
	SetPlayerData(playerid, P_IN_ENTRANCE,		-1);
	SetPlayerData(playerid, P_IN_ENTRANCE_FLOOR,-1);
	
	SetPlayerSkinInit(playerid);

	SetPlayerJobLoadItems(playerid, 0);
	SetPlayerTempJob(playerid, TEMP_JOB_NONE);
	
	SetPlayerSpawnInit(playerid);
	
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	SetVehicleData(vehicleid, V_DRIVER_ID, INVALID_PLAYER_ID);
	
	if(IsAOwnableCar(vehicleid))
	{
		new index = GetVehicleData(vehicleid, V_ACTION_ID);
		
		SetVehiclePos
		(
			vehicleid,
			GetOwnableCarData(index, OC_POS_X),
			GetOwnableCarData(index, OC_POS_Y),
			GetOwnableCarData(index, OC_POS_Z)
		);
		SetVehicleZAngle(vehicleid, GetOwnableCarData(index, OC_ANGLE));
	}
	else 
	{
		DestroyVehicleLabel(vehicleid);
		SetVehicleData(vehicleid, V_FUEL, 40.0);
	}
	SetVehicleData(vehicleid, V_LIMIT, true);
	SetVehicleParamsEx(vehicleid, IsABike(vehicleid) ? VEHICLE_PARAM_ON : VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF);

	switch(GetVehicleData(vehicleid, V_ACTION_TYPE))
	{
		case 
			VEHICLE_ACTION_TYPE_FACTORY, 
			VEHICLE_ACTION_TYPE_BUS_DRIVER, 
			VEHICLE_ACTION_TYPE_TAXI_DRIVER, 
			VEHICLE_ACTION_TYPE_MECHANIC: 
		{
			SetVehicleData(vehicleid, V_ACTION_ID, VEHICLE_ACTION_ID_NONE);
		}
	}
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, FLOOD_RATE_INC);

	if(!IsPlayerLogged(playerid)) return 0;
	if(GetPlayerAntiFloodData(playerid, AF_RATE) >= MAX_FLOOD_RATE)
	{
		SendClientMessage(playerid, 0x6B6B6BFF, "�� �������");

		if(GetPlayerAntiFloodData(playerid, AF_RATE) >= MAX_FLOOD_RATE + 500)
			SendClientMessage(playerid, 0x6B6B6BFF, "����������, ��������� ��������� ������...");

		return 0;
	}
	if(strlen(text) > 90) return 0;
	
	if(GetPlayerPhoneCall(playerid, PC_TIME) != -1)
	{
		new caller = GetPlayerPhoneCall(playerid, PC_INCOMING_PLAYER);
		new call_to = GetPlayerPhoneCall(playerid, PC_OUTCOMING_PLAYER);

		new fmt_str[128];
		format(fmt_str, sizeof fmt_str, "[���] %s: %s", GetPlayerNameEx(playerid), text);
		
		if(call_to != INVALID_PLAYER_ID && playerid == GetPlayerPhoneCall(call_to, PC_INCOMING_PLAYER))
		{
			SendClientMessage(call_to, 0xFFFF00FF, fmt_str);
		}	
		else if(caller != INVALID_PLAYER_ID && playerid == GetPlayerPhoneCall(caller, PC_OUTCOMING_PLAYER))
		{
			SendClientMessage(caller, 0xFFFF00FF, fmt_str);
		}
		SendMessageInLocal(playerid, fmt_str, 0x999999FF, 25.0);
		
		return 0;
	}
	else if(!strcmp(text, "(", true))
	{
		Action(playerid, "�����������", _, false);
	}	
	else if(!strcmp(text, "((", true))
	{
		if(!IsPlayerInAnyVehicle(playerid))
			ApplyAnimation(playerid, "GRAVEYARD", "mrnF_loop", 4.1, false, 0, 0, 0, 0, 0);
				
		Action(playerid, "������ �����������", _, false);
	}
	else if(!strcmp(text, ")", true))
	{
		Action(playerid, "���������", _, false);
	}
	else if(!strcmp(text, "))", true))
	{
		Action(playerid, "������", _, false);
	}	
	else if(!strcmp(text, "=0", true))
	{
		Action(playerid, "��������", _, false);
	}
	else SendMessageInChat(playerid, text);
	
	return 0;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, FLOOD_RATE_INC, FLOOD_RATE_KICK))
	{
		SendClientMessage(playerid, 0x6B6B6BFF, "��� ����������� �� ������ ��������� �� �������");
		
		if(GetPlayerAntiFloodData(playerid, AF_RATE) >= MAX_FLOOD_RATE + 500)
			SendClientMessage(playerid, 0x6B6B6BFF, "����������, ��������� ��������� ������...");
		return 0;
	}
	
	if(!ispassenger)
	{
		if(GetPlayerData(playerid, P_DRIVING_LIC) < 1)
		{
			if(!IsABike(vehicleid))
			{
				ClearAnimations(playerid);
				return SendClientMessage(playerid, 0x999999FF, "� ��� ��� ����");
			}
		}
	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, 500, FLOOD_RATE_KICK);

	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, 500, FLOOD_RATE_KICK);

	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		
		if(vehicleid)
			OnPlayerEnterVehicleEx(playerid, vehicleid, !(newstate % 2));
	}
	if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
	{
		new vehicleid = GetPlayerLastVehicle(playerid);
		
		if(vehicleid != INVALID_VEHICLE_ID)
			OnPlayerExitVehicleEx(playerid, vehicleid, !(oldstate % 2));
	}
	return 1;
}

public: OnPlayerEnterVehicleEx(playerid, vehicleid, is_driver)
{
	SetVehicleData(vehicleid, V_DRIVER_ID, playerid);
	SetPlayerData(playerid, P_LAST_VEHICLE, vehicleid);
	
	new vehicle_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
	new action_id = GetVehicleData(vehicleid, V_ACTION_ID);
	
	if(is_driver)
	{
		if(!GetVehicleParam(vehicleid, V_LOCK))
		{
			if(GetPlayerData(playerid, P_DRIVING_LIC) > 0)
			{
				if(!IsABike(vehicleid))
					SpeedometrShowForPlayer(playerid, vehicleid);
				
				switch(vehicle_type)
				{
					case VEHICLE_ACTION_TYPE_DRIVING_SCH:
					{
						if(GetPlayerDrivingExamInfo(playerid, DE_POINTS) >= 9)
						{
							SetPVarFloat(playerid, "car_damage", 1000.0);
							
							SetVehicleParam(vehicleid, V_LOCK, VEHICLE_PARAM_ON);
							NextDrivingExamRouteCP(playerid);
							
							SendClientMessage(playerid, 0x66CC00FF, "[����������] ���������� ������� �� ������");
							SendClientMessage(playerid, 0xFFFF00FF, "��������! ���� �� �������� � ������ ��� ������� �� ������ ������� ����� ��������");
							SendClientMessage(playerid, 0xFFFFFFFF, "����� ������� ������ ������� {0099FF}�������� ������");
						}
						else 
						{
							RemovePlayerFromVehicle(playerid);
							SendClientMessage(playerid, 0xCECECEFF, "��������� ����������� ���������");
						}
					}
					case VEHICLE_ACTION_TYPE_LOADER:
					{
						if(GetPlayerTempJob(playerid) == TEMP_JOB_LOADER)
						{
							SetVehicleParam(vehicleid, V_LOCK, true);
						
							DisablePlayerCheckpoint(playerid);
						
							SendClientMessage(playerid, 0xFFFFFFFF, "����������� {00CC00}Num 2 {FFFFFF}� {00CC00}Num 8 {FFFFFF}��� ���������� �����������");
							SendClientMessage(playerid, 0xFFFFFFFF, "����� ����� ��� �������� ���� ����� ������������ {3399FF}/take");
						}
						else 
						{
							RemovePlayerFromVehicle(playerid);
							SendClientMessage(playerid, 0xCECECEFF, "�� �� �������");
						}
					}
					case VEHICLE_ACTION_TYPE_FACTORY:
					{
						if(GetPlayerTempJob(playerid) == TEMP_JOB_FACTORY_TRUCKER)
						{
							new job_car = GetPlayerJobCar(playerid);
							
							if(job_car == INVALID_VEHICLE_ID && action_id == VEHICLE_ACTION_ID_NONE)
							{
								new bool: take_car = true;
								switch(GetVehicleData(vehicleid, V_MODELID))
								{
									case 514:
									{
										CreateVehicleLabel(vehicleid, "�������� �������\n{FFFFFF}�������� 0 / 8000 �", 0xFF6600FF, 0.0, 2.1, 2.1, 20.0);

										SendClientMessage(playerid, 0x66CC00FF, "��������� �������� � ������������� �� ���������� ��� ������� �������");
										SendClientMessage(playerid, 0xFFFFFFFF, "���������, ��� ����� �� ����� � ������ ������������� ���������� �������");
									}
									case 498:
									{
										CreateVehicleLabel(vehicleid, "�������� �������\n{FFFFFF}�������� 0 / 500 ��", 0x3399FFFF, 0.0, 0.0, 1.8, 20.0);

										SendClientMessage(playerid, 0x66CC00FF, "������������� �� �����, ����� �������� ������ ��� ������");
										SendClientMessage(playerid, 0xFFFFFFFF, "���������, ��� ����� �� ����� � ������ ������������� ����� ������");				
									}
									default: take_car = false;
								}
								if(take_car)
								{
									SetVehicleData(vehicleid, V_ACTION_ID, true);
									SetPlayerData(playerid, P_JOB_CAR, vehicleid);
								}
							}
							else if(vehicleid != job_car) 
							{
								RemovePlayerFromVehicle(playerid);
								SendClientMessage(playerid, 0xCECECEFF, "�� �� ������ ������������ ���� ��������� � ������ ������");
							}
							else KillEndJobTimer(playerid);
						}
						else 
						{
							RemovePlayerFromVehicle(playerid);
							SendClientMessage(playerid, 0xCECECEFF, "�� �� �������� ������ �������� ������");
						}
					}
					case VEHICLE_ACTION_TYPE_BUS_DRIVER: // �������� ��������
					{
						if(GetPlayerJob(playerid) == JOB_BUS_DRIVER)
						{
							new job_car = GetPlayerJobCar(playerid);
							
							if(!IsPlayerInJob(playerid) && job_car != vehicleid && action_id == VEHICLE_ACTION_ID_NONE)
							{
								Dialog
								(
									playerid, DIALOG_BUS_RENT_CAR, DIALOG_STYLE_MSGBOX,
									"{FFCD00}���������� ����",
									"{FFFFFF}����� ����� ������, ���������� ��������� ���������� ��������� 180 ������\n"\
									"�� ������������� ������ ����� ������� � ������?", 
									"��", "���"
								);
							}
							else if(vehicleid != job_car) 
							{
								RemovePlayerFromVehicle(playerid);
								SendClientMessage(playerid, 0xCECECEFF, "�� �� ������ ������������ ���� ��������� � ������ ������");
							}
							else KillEndJobTimer(playerid);
						}
						else 
						{
							RemovePlayerFromVehicle(playerid);
							SendClientMessage(playerid, 0xCECECEFF, "�� �� �������� ��������");
						}
					}
					case VEHICLE_ACTION_TYPE_TAXI_DRIVER: // �������
					{
						if(GetPlayerJob(playerid) == JOB_TAXI_DRIVER)
						{
							new job_car = GetPlayerJobCar(playerid);
							
							if(!IsPlayerInJob(playerid) && job_car != vehicleid && action_id == VEHICLE_ACTION_ID_NONE)
							{
								Dialog
								(
									playerid, DIALOG_TAXI_RENT_CAR, DIALOG_STYLE_MSGBOX,
									"{FFCD00}���������",
									"{FFFFFF}����� ����� ������, ���������� ��������� ���������� ���������� 200 ������\n"\
									"�� ������������� ������ ��������� ������� ������?", 
									"��", "���"
								);
							}
							else if(vehicleid != job_car) 
							{
								RemovePlayerFromVehicle(playerid);
								SendClientMessage(playerid, 0xCECECEFF, "�� �� ������ ������������ ���� ��������� � ������ ������");
							}
							else KillEndJobTimer(playerid);
						}
						else 
						{
							RemovePlayerFromVehicle(playerid);
							SendClientMessage(playerid, 0xCECECEFF, "�� �� �������");
						}
					}
					case VEHICLE_ACTION_TYPE_MECHANIC: // �����������
					{
						if(GetPlayerJob(playerid) == JOB_MECHANIC)
						{
							new job_car = GetPlayerJobCar(playerid);
							
							if(!IsPlayerInJob(playerid) && job_car != vehicleid && action_id == VEHICLE_ACTION_ID_NONE)
							{
								Dialog
								(
									playerid, DIALOG_MECHANIC_RENT_CAR, DIALOG_STYLE_MSGBOX,
									"{FFCD00}��������",
									"{FFFFFF}����� ����� ������, ���������� ��������� ���������� ��������� 180 ������\n"\
									"�� ������������� ������ ��������� ������� ������?", 
									"��", "���"
								);
							}
							else if(vehicleid != job_car) 
							{
								RemovePlayerFromVehicle(playerid);
								SendClientMessage(playerid, 0xCECECEFF, "�� �� ������ ������������ ���� ��������� � ������ ������");
							}
							else KillEndJobTimer(playerid);
						}
						else 
						{
							RemovePlayerFromVehicle(playerid);
							SendClientMessage(playerid, 0xCECECEFF, "�� �� �����������");
						}
					}
					case VEHICLE_ACTION_TYPE_TRUCKER: // ������������
					{
						if(GetPlayerJob(playerid) == JOB_TRUCKER)
						{
							
						}
						else
						{
							RemovePlayerFromVehicle(playerid);
							SendClientMessage(playerid, 0xCECECEFF, "�� �� ������������");
						}
					}
				}
			}
			else 
			{	
				if(!IsABike(vehicleid))
				{
					RemovePlayerFromVehicle(playerid);
					SendClientMessage(playerid, 0x999999FF, "� ��� ��� ����");
				}
			}
		}
		else RemovePlayerFromVehicle(playerid);
	}
	else 
	{
		switch(vehicle_type)
		{
			case VEHICLE_ACTION_TYPE_BUS_DRIVER, VEHICLE_ACTION_TYPE_TAXI_DRIVER:
			{
				new driver = GetVehicleData(vehicleid, V_DRIVER_ID);
				if(driver != INVALID_PLAYER_ID && IsPlayerInJob(driver) && IsPlayerDriver(driver))
				{
					if(GetPlayerJobCar(driver) == vehicleid && IsPlayerInVehicle(driver, vehicleid))
					{
						new tariff = GetPlayerData(driver, P_JOB_TARIFF);
						
						if(vehicle_type == VEHICLE_ACTION_TYPE_TAXI_DRIVER)
						{
							if(GetPlayerMoneyEx(playerid) >= tariff)
							{
								new fmt_str[90];
								g_taxi_mileage[playerid] = 0.0;
								
								format(fmt_str, sizeof fmt_str, "%s ��� � ���� �����. ������� �������", GetPlayerNameEx(playerid));
								SendClientMessage(driver, 0x3399FFFF, fmt_str);
								
								format(fmt_str, sizeof fmt_str, "�� ���� � ����� %s. �����: %d ������ (������ �� ������ 100 � �������)", GetPlayerNameEx(driver), tariff);
								SendClientMessage(playerid, 0x3399FFFF, fmt_str);
								
								AddPlayerData(driver, P_JOB_LOAD_ITEMS, +, 1);							
							}
							else 
							{
								RemovePlayerFromVehicle(playerid);
								SendClientMessage(playerid, 0xFF6600FF, "������������ ����� ��� ������ ������");
							}
						}
						else 
						{
							if(GetPlayerMoneyEx(playerid) >= tariff)
							{
								AddPlayerData(driver, P_JOB_LOAD_ITEMS, +, 1);
								GivePlayerMoneyEx(driver, tariff, "+ ������ ������� � ��������", true, true);
							}
							else 
							{
								RemovePlayerFromVehicle(playerid);
								SendClientMessage(playerid, 0xFF6600FF, "������������ ����� ��� ������ �������");
							}
						}
					}
				}
			}
		}
	}
	return 1;
}

public: OnPlayerExitVehicleEx(playerid, vehicleid, is_driver)
{
	SetVehicleData(vehicleid, V_DRIVER_ID, INVALID_PLAYER_ID);
	SetPlayerData(playerid, P_LAST_VEHICLE, INVALID_VEHICLE_ID);
	
	if(is_driver)
	{
		if(!IsABike(vehicleid))
			SpeedometrHideForPlayer(playerid);
		
		if(GetPlayerDrivingExamInfo(playerid, DE_POINTS) >= 9)
		{
			DisablePlayerRaceCheckpoint(playerid);
			
			if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_DRIVING_SCH)
			{			
				SetVehicleToRespawn(vehicleid);
			}
			SetPlayerData(playerid, P_DRIVING_LIC, 0);
			ClearPlayerDrivingExamInfo(playerid);
			
			SendClientMessage(playerid, 0xFF6600FF, "�� �������� ������� ����������");
			SendClientMessage(playerid, 0xFF0000FF, "������� ��������!");
			
			DeletePVar(playerid, "car_damage");
		}
		
		switch(GetVehicleData(vehicleid, V_ACTION_TYPE))
		{
			case VEHICLE_ACTION_TYPE_LOADER:
			{
				SetPlayerLoaderJobLoadCP(playerid);
			}
			case VEHICLE_ACTION_TYPE_FACTORY:
			{
				if(GetPlayerTempJob(playerid) == TEMP_JOB_FACTORY_TRUCKER)
				{
					if(GetPlayerJobCar(playerid) == vehicleid)
					{
						StartEndJobTimer(playerid);
						SendClientMessage(playerid, 0xFF6600FF, "� ��� ���� 15 ������ ����� ��������� � ���������");
					}
				}
			}
			case VEHICLE_ACTION_TYPE_BUS_DRIVER:
			{
				if(GetPlayerJob(playerid) == JOB_BUS_DRIVER)
				{
					if(IsPlayerInJob(playerid))
					{
						if(GetPlayerJobCar(playerid) == vehicleid)
						{
							StartEndJobTimer(playerid);
							SendClientMessage(playerid, 0xFF6600FF, "� ��� ���� 15 ������ ����� ��������� � �������");
						}
					}
				}
			}
			case VEHICLE_ACTION_TYPE_TAXI_DRIVER:
			{
				if(GetPlayerJob(playerid) == JOB_TAXI_DRIVER)
				{
					if(IsPlayerInJob(playerid))
					{
						if(GetPlayerJobCar(playerid) == vehicleid)
						{
							StartEndJobTimer(playerid);
							SendClientMessage(playerid, 0xFF6600FF, "� ��� ���� 15 ������ ����� ��������� � ���������");
						}
					}
				}
			}
			case VEHICLE_ACTION_TYPE_MECHANIC:
			{
				if(GetPlayerJob(playerid) == JOB_MECHANIC)
				{
					if(IsPlayerInJob(playerid))
					{
						if(GetPlayerJobCar(playerid) == vehicleid)
						{
							StartEndJobTimer(playerid);
							SendClientMessage(playerid, 0xFF6600FF, "� ��� ���� 15 ������ ����� ��������� � ���������");
						}
					}
				}
			}
		}
	}
	return 1;
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
	if(GetVehicleParam(vehicleid, V_ENGINE) == VEHICLE_PARAM_ON && GetPlayerData(playerid, P_IMPROVEMENTS) < 4)
	{
		SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_OFF);
		GameTextForPlayer(playerid, "~r~~h~engine off", 4000, 6);
		
		switch(GetVehicleData(vehicleid, V_ACTION_TYPE))
		{
			case VEHICLE_ACTION_TYPE_DRIVING_SCH, VEHICLE_ACTION_TYPE_BUS_DRIVER:
			{
				new Float: health = GetPVarFloat(playerid, "car_damage");
				new Float: veh_health;
			
				GetVehicleHealth(vehicleid, veh_health);
				health -= floatabs((health - veh_health));
				
				SetPVarFloat(playerid, "car_damage", health);
			}
		}
	}
    return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, 500, FLOOD_RATE_KICK);

	new action_type = GetPlayerCPInfo(playerid, CP_ACTION_TYPE);
	if(IsPlayerInCheckpoint(playerid))
	{
		switch(action_type)
		{
			case CP_ACTION_TYPE_LOADER_JOB_TAKE:
			{
				if(GetPlayerTempJob(playerid) == TEMP_JOB_LOADER)
				{
					if(GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_LOADER_LOAD)
					{
						if(!IsPlayerInAnyVehicle(playerid))
						{
							DisablePlayerCheckpoint(playerid);
							
							ClearAnimations(playerid);
							ApplyAnimationEx(playerid, "CARRY", "liftup", 4.0, 0, 0, 0, 0, 0, 0, USE_ANIM_TYPE_NONE - 1);
						
							SetTimerEx("SetPlayerLoaderJobLoad", 1000, false, "i", playerid);
						}
					}
				}
			}
			case CP_ACTION_TYPE_LOADER_JOB_PUT:
			{
				if(GetPlayerTempJob(playerid) == TEMP_JOB_LOADER)
				{
					if(GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_LOADER_UNLOAD)
					{
						if(!IsPlayerInAnyVehicle(playerid))
						{
							SetPlayerJobLoadItems(playerid, GetPlayerJobLoadItems(playerid) + 1);
							
							RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_FOREARM);
							ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 0);							

							SetPlayerLoaderJobLoadCP(playerid);
							
							new fmt_str[70];
							format(fmt_str, sizeof fmt_str, "���� ��������� �� �����! ����� ���������� ������: {FF9900}%d", GetPlayerJobLoadItems(playerid));
							SendClientMessage(playerid, 0x66CC00FF, fmt_str);						
						}
					}
				}
			}
			case CP_ACTION_TYPE_MINER_JOB_TAKE:
			{
				if(GetPlayerTempJob(playerid) == TEMP_JOB_MINER)
				{
					if(GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_MINER_LOAD)
					{
						if(!IsPlayerInAnyVehicle(playerid))
						{				
							DisablePlayerCheckpoint(playerid);
							
							ApplyAnimationEx(playerid, "BASEBALL", "Bat_4", 3.1, 1, 1, 1, 0, 0, 0, USE_ANIM_TYPE_NONE - 1);
							SetTimerEx("SetPlayerMinerJobTakeOre", 15_000, false, "ii", playerid, 1);
						}
					}
				}
			}
			case CP_ACTION_TYPE_MINER_JOB_PUT:
			{
				if(GetPlayerTempJob(playerid) == TEMP_JOB_MINER)
				{
					if(GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_MINER_UNLOAD)
					{
						if(!IsPlayerInAnyVehicle(playerid))
						{
							new fmt_str[64];
							
							new rand = random(45) + 16;
							new items = GetPlayerJobLoadItems(playerid) + rand;
							
							RemovePlayerAttachedObjects(playerid);
							SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 18634, A_OBJECT_BONE_RIGHT_HAND, 0.07, 0.03, 0.04, 0.0, 270.0, 270.0, 1.5, 2.1, 1.8, 0);
							
							ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 0);
							SetPlayerJobLoadItems(playerid, items);
							
							format(fmt_str, sizeof fmt_str, "�� ��������� �� ����� {FF9900}%d �� {66CC00}����", rand);
							SendClientMessage(playerid, 0x66CC00FF, fmt_str);
							
							format(fmt_str, sizeof fmt_str, "����� ���������� �������� �����: {FF9900}%d ��", items);
							SendClientMessage(playerid, 0x3399FFFF, fmt_str);
						
							format(fmt_str, sizeof fmt_str, "+ %d ��", rand);
							SetPlayerChatBubble(playerid, fmt_str, 0x66CC00FF, 10.0, 2000);
							
							items = GetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE, R_AMOUNT);
							SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE, R_AMOUNT, items + rand);
							
							UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE);
							
							SetPlayerMinerJobLoadCP(playerid);
						}
					}
				}
			}
		}	
	}
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, 500, FLOOD_RATE_KICK);

	new action_type = GetPlayerRaceCPInfo(playerid, RCP_ACTION_TYPE);
	new vehicleid = GetPlayerVehicleID(playerid);
	
	if(IsPlayerInRaceCheckpoint(playerid))
	{
		switch(action_type)
		{
			case RCP_ACTION_TYPE_DRIVING_EXAM:
			{
				if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_DRIVING_SCH)
				{
					new step = GetPlayerDrivingExamInfo(playerid, DE_ROUTE_STEP);
					
					if(step >= sizeof driving_exam_route - 1)
					{
						ClearPlayerDrivingExamInfo(playerid);
						DisablePlayerRaceCheckpoint(playerid);
						
						new Float: health = GetPVarFloat(playerid, "car_damage");
						SetVehicleToRespawn(vehicleid);
					
						if(health < 900.0)
						{
							SetPlayerData(playerid, P_DRIVING_LIC, 0);
							
							Dialog
							(
								playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
								"{FF9900}������� ��������",
								"{FFFFFF}� ���������, ��� �� ������� ���������� � ������������ ������ ��������.\n"\
								"������� ����������� ������ ������� �������.\n\n"\
								"� ��������� ��� ������������ ����� ����������, �������� ���.\n"\
								"���� ��� �� ���������!",
								"��", ""
							);
						}
						else
						{
							new query[64];
							format(query, sizeof query, "UPDATE accounts SET driving_lic=%d WHERE id=%d LIMIT 1", GetPlayerData(playerid, P_DRIVING_LIC), GetPlayerAccountID(playerid));
							mysql_query(mysql, query, false);
							
							if(!mysql_errno())
							{
								Dialog
								(
									playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
									"{66CC00}������� ������� �������",
									"{FFFFFF}�� ������� ����� ������������ ����� �������� �� ��������\n"\
									"� ��������� ������������ �������������!\n"\
									"{9999FF}�� ����� ������ �� ���������� ������� �����������, ����\n"\
									"��� �������������.\n"\
									"{FFFFFF}�� ��������� ������� ���������� �����������, � �����\n"\
									"������� ��������� ��������. ��� ����� ��������� �����\n"\
									"��� �� ������. ��������� ������ � ��������� ����� ���\n"\
									"����� �������� ���� ����������� �����-���� ������.",
									"��", ""
								);
							}
							else
							{
								SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ���������� � ������������� {FF0000}(equ-code 07)");
							}
						}
					}
					else if(step >= 0) 
					{
						NextDrivingExamRouteCP(playerid);
					}
				}
			}
			case RCP_ACTION_TYPE_BUS_ROUTE:
			{
				if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_BUS_DRIVER)
				{
					if(IsPlayerInJob(playerid))
					{
						new route_id = GetPlayerData(playerid, P_BUS_ROUTE);
						new route_step = GetPlayerData(playerid, P_BUS_ROUTE_STEP);
						
						if(g_bus_route[route_id][route_step][BRS_POS_X] == 0.0)
						{
							SetPlayerData(playerid, P_BUS_ROUTE_STEP, 0);
						}
						
						if(g_bus_route[route_id][route_step - 1][BRS_STOP])
						{
							new fmt_str[90];
							DisablePlayerRaceCheckpoint(playerid);
							
							GameTextForPlayer(playerid, "~r~Stop", 4000, 1);
							SendClientMessage(playerid, 0x66CC00FF, "���������. ����� ����������");
							
							format(fmt_str, sizeof fmt_str, "������� �� �������� %s ������������ ����� 10 ������", g_bus_routes[route_id][BR_NAME]);
							SendMessageInLocal(playerid, fmt_str, 0x669999FF, 45.0);
							
							SetTimerEx("NextBusRouteCP", 10_000, false, "i", playerid);
						}
						else 
						{
							AddPlayerData(playerid, P_JOB_WAGE, +, random(30) + 20);
							NextBusRouteCP(playerid);
						}
					}
				}
			}
			default:
			{
			
			}
		}
	
	}
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id)
{
	if(IsPlayerInRangeOfPoint(playerid, 5.0, GetPickupInfo(pickupid, P_POS_X), GetPickupInfo(pickupid, P_POS_Y), GetPickupInfo(pickupid, P_POS_Z)))
	{
		SetPlayerData(playerid, P_LAST_PICKUP, pickupid);
		
		switch(action_type)
		{
			case PICKUP_ACTION_TYPE_TELEPORT:
			{
				if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_NONE)
				{
					switch(GetTeleportData(action_id, T_ACTION_TYPE))
					{
						case T_ACTION_TYPE_BLOCK_LEAVE_AREA:
						{
							SetPlayerData(playerid, P_BLOCK_LEAVE_AREA, true);
						}
						case T_ACTION_TYPE_END_JOB:
						{
							EndPlayerTempJob(playerid, TEMP_JOB_FACTORY, true);
						}
					}
				
					SetPlayerPosEx
					(
						playerid, 
						GetTeleportData(action_id, T_POS_X), 
						GetTeleportData(action_id, T_POS_Y), 
						GetTeleportData(action_id, T_POS_Z), 
						GetTeleportData(action_id, T_ANGLE),
						GetTeleportData(action_id, T_INTERIOR),
						GetTeleportData(action_id, T_VIRTUAL_WORLD)
					);
				}
			}
			case PICKUP_ACTION_TYPE_DRIVING_TUTO:
			{
				ShowPlayerDrivingTutorial(playerid);
			}
			case PICKUP_ACTION_TYPE_ATM:
			{
				ShowPlayerATMDialog(playerid);
			}
			case PICKUP_ACTION_TYPE_BANK:
			{
				if(action_id)
				{
					cmd::bank(playerid, "");
				}
				else ShowPlayerPayForRentDialog(playerid);
			}
			case PICKUP_ACTION_TYPE_TEMP_JOB:
			{
				new job = GetPlayerTempJob(playerid);
				if(job != action_id && IsPlayerInJob(playerid) || GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_NONE)
				{
					job = TEMP_JOB_NONE - 1;
				}
				
				switch(action_id)
				{
					case TEMP_JOB_LOADER:
					{
						if(job == TEMP_JOB_NONE)
						{
							Dialog
							(
								playerid, DIALOG_TEMP_JOB_LOADER_START, DIALOG_STYLE_MSGBOX,
								"{FFCD00}������ ��������",
								"{FFFFFF}�� ������ ���������� �� ������ ���������?",
								"��", "���"
							);					
						}
						else if(job == action_id)
						{
							Dialog
							(
								playerid, DIALOG_TEMP_JOB_LOADER_END, DIALOG_STYLE_MSGBOX,
								"{FFCD00}������ ��������",
								"{FFFFFF}�� ������� ��� ������ ��������� ������� ����?",
								"��", "���"
							);
						}
						else SendClientMessage(playerid, 0xCECECEFF, "����� ���������� ���� ��������� ������� ������");
					}
					case TEMP_JOB_MINER:
					{
						if(job == TEMP_JOB_NONE)
						{
							Dialog
							(
								playerid, DIALOG_TEMP_JOB_MINER_START, DIALOG_STYLE_MSGBOX,
								"{FFCD00}������ �������",
								"{FFFFFF}�� ������ ���������� �� ������ �������?",
								"��", "���"
							);
						}
						else if(job == action_id)
						{
							Dialog
							(
								playerid, DIALOG_TEMP_JOB_MINER_END, DIALOG_STYLE_MSGBOX,
								"{FFCD00}������ �������",
								"{FFFFFF}�� ������� ��� ������ ��������� ������� ����?",
								"��", "���"
							);
						}
						else SendClientMessage(playerid, 0xCECECEFF, "� ������ ������ ���������� �� ��� ������ ������");
					}
					case TEMP_JOB_FACTORY_TRUCKER:
					{
						if(job == TEMP_JOB_NONE)
						{	
							Dialog
							(
								playerid, DIALOG_TEMP_JOB_FACTORY_TRUCKER, DIALOG_STYLE_MSGBOX,
								"{FFCD00}�����",
								"{FFFFFF}�� ������ ������ ������ � ������ �������� �������� ����������?",
								"��", "���"
							);
						}
						else if(job == action_id)
						{
							Dialog
							(
								playerid, DIALOG_TEMP_JOB_FACTORY_TRUCKER, DIALOG_STYLE_MSGBOX,
								"{FFCD00}�����",
								"{FFFFFF}��������� ������ � ������ �������� �������� ����������?",
								"��", "���"
							);
						}
						else SendClientMessage(playerid, 0xCECECEFF, "� ������ ������ ���������� �� ��� ������ ������");
					}
					case TEMP_JOB_FACTORY:
					{
						if(job == TEMP_JOB_NONE)
						{	
							Dialog
							(
								playerid, DIALOG_TEMP_JOB_FACTORY, DIALOG_STYLE_MSGBOX,
								"{FFCD00}�����",
								"{FFFFFF}�� ������ ������ ������ � ���������������� ����?",
								"��", "���"
							);
						}
						else if(job == action_id)
						{
							Dialog
							(
								playerid, DIALOG_TEMP_JOB_FACTORY, DIALOG_STYLE_MSGBOX,
								"{FFCD00}�����",
								"{FFFFFF}��������� ������ � ���������������� ����?",
								"��", "���"
							);
						}
						else SendClientMessage(playerid, 0xCECECEFF, "� ������ ������ ���������� �� ��� ������ ������");
					}
				}
			}
			case PICKUP_ACTION_TYPE_INFO_PICKUP:
			{
				Dialog
				(
					playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
					GetInfoPickupData(action_id, IP_TITLE),
					GetInfoPickupData(action_id, IP_INFO),
					"��", ""
				);
			}
			case PICKUP_ACTION_TYPE_MINER_SELL_M:
			{
				ShowPlayerBuyMetalDialog(playerid);
			}
			case PICKUP_ACTION_TYPE_FACTORY_MET:
			{
				if(GetPlayerTempJob(playerid) == TEMP_JOB_FACTORY)
				{
					new j_state = GetPlayerTempJobState(playerid);
					switch(j_state)
					{
						case TEMP_JOB_STATE_FACTORY_TAKE_MET:
						{
							new factory_metal = GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL, R_AMOUNT);
							new factory_fuel = GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL, R_AMOUNT);
							
							new take_metall = random(2) + 1;
							if(factory_metal > take_metall && factory_fuel > (take_metall * 6))
							{
								SetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL, R_AMOUNT, factory_metal - take_metall);
								UpdateRepository(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL);
							
								new fmt_str[16];
								SetPVarInt(playerid, "factory_take_metall", take_metall);
								
								format(fmt_str, sizeof fmt_str, "~b~~h~+%d kg", take_metall);
								GameTextForPlayer(playerid, fmt_str, 4000, 1);
								
								SetPlayerTempJobState(playerid, TEMP_JOB_STATE_FACTORY_CREATE_P);
							}
							else GameTextForPlayer(playerid, "~r~no fuel or metal", 4000, 1);
						}
						case TEMP_JOB_STATE_FACTORY_CREATE_P:
						{
							SendClientMessage(playerid, 0x999999FF, "�� ��� ����� ������");
						}
					}
				}
			}
			case PICKUP_ACTION_TYPE_FUEL_STATION:
			{
				ShowPlayerBuyJerricanDialog(playerid, action_id);
			}
			case PICKUP_ACTION_TYPE_BIZ_ENTER:
			{
				if(GetPlayerInBiz(playerid) == -1)
				{	
					new i_paid_biz = GetPlayerUseListitem(playerid);
					
					if(IsBusinessOwned(action_id))
					{
						if(GetBusinessData(action_id, B_OWNER_ID) != GetPlayerAccountID(playerid))
						{
							if(GetBusinessData(action_id, B_LOCK_STATUS))
								return GameTextForPlayer(playerid, "~w~business~n~~r~closed", 4000, 1);
							
							if(GetBusinessData(action_id, B_ENTER_PRICE) > 0 && i_paid_biz != action_id)
							{
								new fmt_str[128];
								SetPVarInt(playerid, "biz_enter", action_id + 1);
							
								format
								(
									fmt_str, sizeof fmt_str, 
									"{FFFFFF}���� ������� � ���������� {FF9900}%d ���\n"\
									"{99FF00}�� ������� ��� ������ ����� ����?", 
									GetBusinessData(action_id, B_ENTER_PRICE)
								);
								return Dialog(playerid, DIALOG_BIZ_ENTER, DIALOG_STYLE_MSGBOX, GetBusinessData(action_id, B_NAME), fmt_str, "��", "���");
							}
						}
					}
					EnterPlayerToBiz(playerid, action_id);
				}
			}
			case PICKUP_ACTION_TYPE_BIZ_EXIT:
			{
				new in_biz = GetPlayerInBiz(playerid);
				if(in_biz != -1)
				{
					new type = GetBusinessData(in_biz, B_INTERIOR);
					if(action_id == type)
					{
						SetPlayerPosEx
						(
							playerid, 
							GetBusinessData(in_biz, B_EXIT_POS_X),
							GetBusinessData(in_biz, B_EXIT_POS_Y),
							GetBusinessData(in_biz, B_EXIT_POS_Z),
							GetBusinessData(in_biz, B_EXIT_ANGLE),
							0,
							0
						);					
						SetPlayerInBiz(playerid, -1);
					}
				}
			}
			case PICKUP_ACTION_TYPE_BIZ_HEALTH:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(businessid == action_id)
					{
						new time = gettime();
						if(GetPVarInt(playerid, "biz_health_use") <= time)
						{
							new price = BIZ_HEALTH_SERVICE_PRICE;
							if(GetPlayerMoneyEx(playerid) >= price)
							{
								new query[155];
							
								format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, GetBusinessData(businessid, B_PRODS) > 0 ? GetBusinessData(businessid, B_PRODS)-1 : 0, GetBusinessData(businessid, B_PRODS) > 0 ? GetBusinessData(businessid, B_BALANCE)+price : 0, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
								mysql_query(mysql, query, false);
								
								if(!mysql_errno())
								{
									GivePlayerMoneyEx(playerid, -price, "������������� ������� � �������", false, true);
									
									if(GetBusinessData(businessid, B_PRODS) >= 1)
									{
										AddBusinessData(businessid, B_PRODS, -, 1);
										AddBusinessData(businessid, B_BALANCE, +, price);
									}
									SetPlayerHealth(playerid, 99.0);
									SetPVarInt(playerid, "biz_health_use", time + 300); // 300 ��� (5 �����)	
									
									mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), time, price, IsBusinessOwned(businessid));
									mysql_query(mysql, query, false);
								}
								else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 24)");
							}
							else SendClientMessage(playerid, 0x999999FF, "������ ��������� ����� 150 ������");
						}
						else SendClientMessage(playerid, 0x999999FF, "������� �� ��� ������������ �������� ���������");	
						
						// SetPlayerHealth(playerid, 95.0); 
					}
				}
			}
			case PICKUP_ACTION_TYPE_BIZ_SHOP_247:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					new type = GetBusinessData(businessid, B_TYPE);
					if(type == BUSINESS_TYPE_SHOP_24_7)
					{
						cmd::buy(playerid, "");
					}	
				}
			}
			case PICKUP_ACTION_TYPE_HOUSE:
			{
				ShowPlayerHouseInfo(playerid, action_id);
			}
			case PICKUP_ACTION_TYPE_HOUSE_HEALTH:
			{
				new houseid = GetPlayerInHouse(playerid);
				if(houseid != -1)
				{
					new type = GetHouseData(houseid, H_TYPE);
				
					if(IsPlayerInRangeOfPoint(playerid, 4.0, GetHouseTypeInfo(type, HT_HEALTH_POS_X), GetHouseTypeInfo(type, HT_HEALTH_POS_Y), GetHouseTypeInfo(type, HT_HEALTH_POS_Z)))
					{
						SetPlayerHealth(playerid, 100.0);
						GameTextForPlayer(playerid, "~b~~h~100 hp", 3000, 1);					
					}
				}
			}
			case PICKUP_ACTION_TYPE_REALTOR_HOME:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					new type = GetBusinessData(businessid, B_TYPE);
					if(type == BUSINESS_TYPE_REALTOR_HOME)
					{
						Dialog
						(
							playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, 
							"{99CC00}������ ��������� �����",
							g_house_realtor_list, 
							"�������", ""
						);
					}
				}
			}
			case PICKUP_ACTION_TYPE_BIZ_CLOTHING:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					new type = GetBusinessData(businessid, B_TYPE);
					if(type == BUSINESS_TYPE_CLOTHING_SHOP)
					{
						ShowPlayerClothingShopPanel(playerid);
					}
				}
			}
			case PICKUP_ACTION_TYPE_ENTRANCE_ENT:
			{
				EnterPlayerToEntrance(playerid, action_id);
			}
			case PICKUP_ACTION_TYPE_ENTRANCE_EXI:
			{
				new entranceid = GetPlayerInEntrance(playerid);
				if(entranceid != -1)
				{
					if(GetPlayerInEntranceFloor(playerid) == 0)
					{
						SetPlayerPosEx
						( 
							playerid,
							GetEntranceData(entranceid, E_EXIT_POS_X),
							GetEntranceData(entranceid, E_EXIT_POS_Y),
							GetEntranceData(entranceid, E_EXIT_POS_Z),
							GetEntranceData(entranceid, E_EXIT_ANGLE),
							0,
							0
						);
						
						SetPlayerInEntrance(playerid, -1);
						SetPlayerInEntranceFloor(playerid, -1);
					}
				}
			}
			case PICKUP_ACTION_TYPE_ENTRANCE_LIF: 
			{
				new entranceid = GetPlayerInEntrance(playerid);
				if(entranceid != -1)
				{
					new floor = GetPlayerInEntranceFloor(playerid);
					if(floor != -1)
					{
						ShowPlayerEntranceFloorsLift(playerid, entranceid, floor);
					}
				}
			}
		}
	}
	return 1;
}

public: HidePlayerSelectPanelPriceTimer(playerid)
{
	if(GetPlayerData(playerid, P_USE_SELECT_PANEL) == SELECT_PANEL_TYPE_NONE)
	{
		HidePlayerSelectPanelPrice(playerid);
	}
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, 500, FLOOD_RATE_KICK);

	/*
	if(GetPlayerMenu(playerid) == reg_select_skin_menu)
    {
		if(!IsPlayerLogged(playerid))
		{
			if(GetPlayerData(playerid, P_ACCOUNT_STATE) == ACCOUNT_STATE_REG_SKIN)
			{
				new sex = GetPlayerSex(playerid);
				new select_skin = GetPlayerSelectSkin(playerid);
		
				switch(row)
				{
					case 0: 
					{
						if(++select_skin >= sizeof reg_skin_data[] || !reg_skin_data[sex][select_skin])
						{
							select_skin = 0;
						}
					}
					case 1:
					{
						if(--select_skin < 0)
						{
							select_skin = sizeof(reg_skin_data[])-1;
							
							if(!sex) 
								select_skin -= 2;
						}
					}
					case 2: 
					{
						SetPlayerData(playerid, P_SKIN, reg_skin_data[sex][select_skin]);
						
						new query[90];
						format(query, sizeof query, "UPDATE accounts SET skin=%d,last_login=%d WHERE id=%d LIMIT 1", GetPlayerSkinEx(playerid), gettime(), GetPlayerAccountID(playerid));
						mysql_query(mysql, query, false);
						
						if(!mysql_errno())
						{
							SetPlayerData(playerid, P_MONEY, 500);
							SetPlayerData(playerid, P_SELECT_SKIN, -1);
							
							HideMenuForPlayer(reg_select_skin_menu, playerid);
							
							SetPlayerSpawnInit(playerid);
							SpawnPlayer(playerid);
			
							RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_FOREARM);
							SetPlayerInit(playerid);
						
							SendClientMessage(playerid, 0xFFFF00FF, "����������� ��������� ������ {FF3300}������ �� ����.{FFFF00} �� ��������� ����� �� ���");
							SendClientMessage(playerid, 0xFFFF00FF, "� ��� �� ������� ��� ������������ ��� ����������. ����� � �������� ����!");
							
							return 1;
						}
						else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 01)");
					}
				}
				
				SetPlayerSelectSkin(playerid, select_skin, reg_skin_data[sex][select_skin]);
				ShowMenuForPlayer(reg_select_skin_menu, playerid);
			}
		}
    }
	*/
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	/*
	if(GetPlayerMenu(playerid) == reg_select_skin_menu)
	{
		if(!IsPlayerLogged(playerid))
		{
			if(GetPlayerData(playerid, P_ACCOUNT_STATE) == ACCOUNT_STATE_REG_SKIN)
			{
				ShowMenuForPlayer(reg_select_skin_menu, playerid);
			}
		}
	}
	*/
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_NO))
		cmd::no(playerid, "");
		
	if(PRESSED(KEY_YES))
		cmd::yes(playerid, "");

	if(IsPlayerInAnyVehicle(playerid))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			if(GetPlayerSettingData(playerid, S_VEH_CONTROL) == SETTING_TYPE_ON)
			{
				if(PRESSED(KEY_HANDBRAKE | KEY_FIRE)) // ������ ctrl
				{
					if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
					{
						cmd::lock(playerid, "1");
					}
				}
				if(PRESSED(KEY_ACTION)) 
				{
					cmd::e(playerid, "");
				}	
				if(PRESSED(KEY_FIRE)) 
				{
					cmd::l(playerid, "");
				}	
				if(PRESSED(KEY_ANALOG_UP)) // num 8
				{
					cmd::b(playerid, "");
				}	
				if(PRESSED(KEY_ANALOG_DOWN)) // num 2
				{
					cmd::i(playerid, "");
				}	
				if(PRESSED(KEY_ANALOG_LEFT)) // num 4
				{
					cmd::sl(playerid, "");
				}
				if(PRESSED(KEY_ANALOG_RIGHT)) // num 6
				{
					cmd::alarm(playerid, "");
				}
			}
			
			if(PRESSED(KEY_SUBMISSION))
			{
				if(!IsPlayerInVehicle(playerid, GetPlayerOwnableCar(playerid)))
				{
					new job_car = GetPlayerJobCar(playerid);
					if(IsPlayerInVehicle(playerid, job_car)) 
					{
						new action_type = GetVehicleData(job_car, V_ACTION_TYPE);
						new car_type = (action_type - VEHICLE_ACTION_TYPE_BUS_DRIVER) + 1; 
						
						new job_id = GetPlayerJob(playerid);
						if(job_id == car_type)
						{
							switch(job_id)
							{
								case JOB_BUS_DRIVER:
								{
									if(IsPlayerInJob(playerid))
									{
										Dialog
										(
											playerid, DIALOG_END_JOB, DIALOG_STYLE_MSGBOX,
											"{FFCD00}��������� ���������", 
											"{FFFFFF}�� ������� ��� ������ ��������� ������� ����?", 
											"��", "���"
										);
									}
									else 
									{
										Dialog
										(
											playerid, DIALOG_BUS_ROUTE_COST, DIALOG_STYLE_INPUT, 
											"{FFCD00}��������� �������", 
											"{FFFFFF}������� ����� ������ ������?\n"\
											"������� ���� �� 0 �� 100 ������", 
											"�����", "������"
										);
									}
								}
								case JOB_TAXI_DRIVER:
								{
									if(IsPlayerInJob(playerid))
									{
										Dialog
										(
											playerid, DIALOG_END_JOB, DIALOG_STYLE_MSGBOX,
											"{FFCD00}��������� ����������", 
											"{FFFFFF}�� ������� ��� ������ ��������� ������� ����?", 
											"��", "���"
										);
									}
									else 
									{
										Dialog
										(
											playerid, DIALOG_TAXI_NAME, DIALOG_STYLE_INPUT, 
											"{FFCD00}�������� �����", 
											"{FFFFFF}���������� �������� ��� ������ �����\n"\
											"������������ ����� 15 ��������\n\n"\
											"���� �� �� ������ ���-�� ����������\n"\
											"������� ������ \"����������\"",
											"�����", "����������"
										);
									}
								}
								case JOB_MECHANIC:
								{
									if(IsPlayerInJob(playerid))
									{
										Dialog
										(
											playerid, DIALOG_END_JOB, DIALOG_STYLE_MSGBOX,
											"{FFCD00}�����������", 
											"{FFFFFF}�� ������� ��� ������ ��������� ������� ����?", 
											"��", "���"
										);
									}
									else 
									{
										Dialog
										(	
											playerid, DIALOG_MECHANIC_START_JOB, DIALOG_STYLE_MSGBOX,
											"{FFCD00}���������", 
											"{FFFFFF}�� ������ ������ ������ ������������?",
											"��", "���"
										);
									}
								}
							}
						}
					}	
				}
				else cmd::car(playerid, "");
			}
			if(HOLDING(KEY_CROUCH))
			{
				CallLocalFunction("CheckNearestGate", "i", playerid);
			}
		}
	}
	else 
	{
		if(PRESSED(KEY_FIRE))
		{
			if(GetPlayerData(playerid, P_SNACK))
			{
				SetPlayerData(playerid, P_SNACK, false);
				
				SetPlayerHealthEx(playerid, 25.0, true);
				GameTextForPlayer(playerid, "~g~~h~+25 hp", 2500, 6);
				
				ApplyAnimation(playerid, "FOOD", "EAT_Chicken", 4.0, 0, 0, 0, 0, 0, 0);
				SetTimerEx("T_RemovePlayerAttachedObject", 3000, false, "ii", playerid, A_OBJECT_SLOT_HAND);
			}
			if(GetPlayerData(playerid, P_DRINK_STEP) >= 1)
			{
				AddPlayerData(playerid, P_DRINK_STEP, -, 1);
				if(!GetPlayerData(playerid, P_DRINK_STEP))
				{
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				}
			}
		}
		if(PRESSED(KEY_SPRINT))
		{
			if(IsPlayerUseAnim(playerid))
			{
				ClearPlayerUseAnim(playerid);
			}
			
			if(GetPlayerData(playerid, P_REALTOR_TYPE) != REALTOR_TYPE_NONE)
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					new type = GetBusinessData(businessid, B_INTERIOR);
					new interior = GetBusinessInteriorInfo(type, BT_ENTER_INTERIOR);
					
					HidePlayerWaitPanel(playerid);
					TogglePlayerSpectating(playerid, false);
					
					if(GetPlayerData(playerid, P_REALTOR_TYPE) == REALTOR_TYPE_BIZ)
					{
						PlayerTeleportInit(playerid, 331.0103, 662.5683, 49.7290, 67.7277);
						SetPlayerPosEx(playerid, 331.0103, 662.5683, 49.7290, 67.7277, interior, businessid + 255);
					}
					else 
					{
						PlayerTeleportInit(playerid, 160.7020, 745.5962, 25.8272, 159.1750);
						SetPlayerPosEx(playerid, 160.7020, 745.5962, 25.8272, 159.1750, interior, businessid + 255);
					}
				}
				SetPlayerData(playerid, P_REALTOR_TYPE, REALTOR_TYPE_NONE);
			}
		}
		if(PRESSED(KEY_WALK))
		{	
			if(GetPlayerNearestATM(playerid) != -1)
			{
				ShowPlayerATMDialog(playerid);
			}
			if(GetPlayerInHouse(playerid) != -1)
			{
				new houseid = GetPlayerInHouse(playerid);
				if(GetHouseData(houseid, H_IMPROVEMENTS) >= 1)
				{
					ExitPlayerFromHouse(playerid, 1.1);
				}
			}
			
			if(GetPlayerData(playerid, P_LAST_PICKUP) != -1)
			{
				new pickupid = GetPlayerData(playerid, P_LAST_PICKUP);
				new action_id = GetPickupInfo(pickupid, P_ACTION_ID);
				
				if(IsPlayerInRangeOfPoint(playerid, 1.7, GetPickupInfo(pickupid, P_POS_X), GetPickupInfo(pickupid, P_POS_Y), GetPickupInfo(pickupid, P_POS_Z)))
				{
					switch(GetPickupInfo(pickupid, P_ACTION_TYPE))
					{
						case PICKUP_ACTION_TYPE_ENTRANCE_FLA:
						{
							new entranceid = GetPlayerInEntrance(playerid);
							new floor = GetPlayerInEntranceFloor(playerid);
							
							if(entranceid != -1 && floor >= 1)
							{
								ShowPlayerHouseInfo(playerid, g_entrance_flat[entranceid][floor - 1][action_id]);
							}						
						}
						case PICKUP_ACTION_TYPE_HOTEL_ROOM:
						{
							new hotel_id = GetPlayerInHotelID(playerid);
							new floor = GetPlayerData(playerid, P_IN_HOTEL_FLOOR);
							
							if(hotel_id != -1 && floor >= 1)
							{
								new room_id = ((floor-1)*12) + action_id;
								EnterPlayerToHotelRoom(playerid, hotel_id, room_id);
							}
						}
					}
				}
				SetPlayerData(playerid, P_LAST_PICKUP, -1);
			}
			if(GetPlayerData(playerid, P_IN_HOTEL_ROOM) != -1)
			{
				ExitPlayerFromHotelRoom(playerid);
			}
		}
		if(PRESSED(KEY_HANDBRAKE | KEY_WALK))
		{
			new targetid = GetPlayerTargetPlayer(playerid);
			//new targetid = playerid;
			
			if(targetid != INVALID_PLAYER_ID && !GetPlayerWeapon(playerid))
			{
				SetPlayerData(playerid, P_TARGET_ID, targetid);
			
				new fmt_str[64];
				format(fmt_str, sizeof fmt_str, "{FFCD00}�������� (%s)", GetPlayerNameEx(targetid));
			
				Dialog
				(
					playerid, DIALOG_ACTION, DIALOG_STYLE_LIST,
					fmt_str,
					"1. �����������\n\
					2. �������� �������\n\
					3. �������� ��������",
					"�������", "�������"
				);
			}	 
		}
		if(PRESSED(KEY_HANDBRAKE))
		{
			if(GetPVarInt(playerid, "have_jerrican") == 1 && GetPlayerSpeed(playerid) == 0.0)
			{
				new vehicleid = GetNearestVehicleID(playerid, 2.3);
				if(vehicleid != INVALID_VEHICLE_ID)
				{
					SetPVarInt(playerid, "jerrican_fill_car", vehicleid);
		
					Dialog
					(
						playerid, DIALOG_JERRICAN_FILL_CAR, DIALOG_STYLE_MSGBOX,
						"{6699FF}��������", 
						"{FFFFFF}�� ������ ��������� ���� ��������� � ��������?",
						"��", "���"
					);
				}			
			}
		}
		if(PRESSED(KEY_CTRL_BACK | KEY_HANDBRAKE))
		{
			if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
			{
				cmd::car(playerid, "");
			}
		}
		else if(PRESSED(KEY_CTRL_BACK))
		{
			CallLocalFunction("cmd_trunk", "i", playerid);
		}
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	SetPlayerData(playerid, P_AFK_TIME, 0);
	SpeedometrLineInit(playerid);
	
	if(GetPlayerTempJobCheckAnim(playerid))
	{
		new anim_index = GetPlayerAnimationIndex(playerid);
		
		/*
			new fmt_str[32];
			
			format(fmt_str, sizeof fmt_str, "index: %d", anim_index);
			SendClientMessage(playerid, 0xCECECEFF, fmt_str);
		*/
		
		switch(GetPlayerTempJob(playerid))
		{
			case TEMP_JOB_LOADER:
			{
				if(!GetPlayerSex(playerid))
				{
					if(!(anim_index == 259 || anim_index == 1189 || anim_index == 1224))
					{
						anim_index = -1;
					}
				}
				else
				{	
					if(!(anim_index == 259 || anim_index == 260 || anim_index == 1275 || anim_index == 1276 || anim_index == 1289))
					{
						anim_index = -1;
					}
				}
				
				if(anim_index == -1)
				{
					SetPlayerTempJobCheckAnim(playerid, false);
					SetPlayerTempJobState(playerid, TEMP_JOB_STATE_LOADER_DROP_LOAD);
				}
			}
			case TEMP_JOB_MINER:
			{
				
			}
			case TEMP_JOB_FACTORY:
			{
				if(!GetPlayerSex(playerid))
				{
					if(!(anim_index == 259 || anim_index == 949 || anim_index == 1189 || anim_index == 1224 || anim_index == 1257 || anim_index == 1269))
					{
						anim_index = -1;
					}
				}
				else
				{	
					if(!(anim_index == 259 || anim_index == 1196 || anim_index == 1275 || anim_index == 1276 || anim_index == 1269 || anim_index == 1283)) 
					{
						anim_index = -1;
					}
				}

				if(anim_index == -1)
				{
					SetPlayerTempJobCheckAnim(playerid, false);
					SetPlayerTempJobState(playerid, TEMP_JOB_STATE_FACTORY_DROP_P);
				}
			}
			default:
			{
				SetPlayerTempJobCheckAnim(playerid, false);
			}
		}
	}
	/*
	if(GetPlayerTempJob(playerid) == TEMP_JOB_MINER)
	{
		if(GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_MINER_UNLOAD)
		{
			new anim_idx = GetPlayerAnimationIndex(playerid);
			
			if(!(anim_idx == 616 || anim_idx == 1189 || anim_idx == 1224))
				SetPlayerTempJobState(playerid, TEMP_JOB_STATE_MINER_DROP_LOAD);
		}
	}
	*/
	
	if(GetPVarInt(playerid, "test") == 1)
	{
		new fmt_str[64];
		
		format(fmt_str, sizeof fmt_str, "a_index: %d", GetPlayerAnimationIndex(playerid));
		SendClientMessage(playerid, 0xCECECEFF, fmt_str);
	}
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, 500, FLOOD_RATE_KICK);
	
	new last_dialog = GetPlayerData(playerid, P_LAST_DIALOG);
	SetPlayerData(playerid, P_LAST_DIALOG, INVALID_DIALOG_ID);
	
	if(last_dialog == dialogid) 
	{
		switch(dialogid)
		{
			case DIALOG_LOGIN: // �����������
			{
				if(GetPlayerData(playerid, P_ACCOUNT_STATE) == ACCOUNT_STATE_LOGIN)
				{
					if(response)
					{
						new login_step = GetPlayerData(playerid, P_ACCOUNT_STEP_STATE);
						new str_len = strlen(inputtext);
						new bool: wrong_password = false;
						
						switch(login_step)
						{
							case LOGIN_STATE_PASSWORD:
							{
								if(1 <= str_len <= 15)
								{
									str_len = strlen(GetPlayerData(playerid, P_PASSWORD));
									if(!str_len || strcmp(inputtext, GetPlayerData(playerid, P_PASSWORD), false, 16) != 0)
									{
										wrong_password = true;
										login_step --;
									}
								}
								else login_step --;
							}
							case LOGIN_STATE_PHONE:
							{
								str_len = strlen(GetPlayerData(playerid, P_SETTING_PHONE));
								if(!str_len || strcmp(GetPlayerData(playerid, P_SETTING_PHONE)[str_len - 5], inputtext) != 0)
								{
									wrong_password = true;
									login_step--;
								}
							}
							default:
								return 1;
						}
						ShowPlayerLoginDialog(playerid, login_step + 1, wrong_password);
					}
					else Kick:(playerid);
				}
			}
			case DIALOG_REGISTER: // �����������
			{
				if(GetPlayerData(playerid, P_ACCOUNT_STATE) == ACCOUNT_STATE_REGISTER)
				{
					new reg_step = GetPlayerData(playerid, P_ACCOUNT_STEP_STATE);
					new str_len = strlen(inputtext);
					
					switch(reg_step)
					{
						case REGISTER_STATE_PASSWORD: // ���� ������
						{
							if(str_len)
							{
								if(!(6 <= str_len <= 15))
								{
									Dialog
									(
										playerid, DIALOG_REGISTER, DIALOG_STYLE_MSGBOX,
										"{FF9900}������",
										"{FFFFFF}����� ������ ������ ���� �� 6 �� 15 ��������\n"\
										"������������� ������������ ������� � ��������� �����, � ����� ����� �����",
										"������", ""
									);
									return PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
								}
								else if(strfind(inputtext, "%") != -1 || strfind(inputtext, " ") != -1)
								{
									Dialog
									(
										playerid, DIALOG_REGISTER, DIALOG_STYLE_MSGBOX,
										"{FF9900}������",
										"{FFFFFF}��������� ���� ������ �������� ������������ ������� ��� �������",
										"������", ""
									);
									return PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
								}
								else if(IsNumeric(GetPlayerNameEx(playerid)))
								{
									Dialog
									(
										playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
										"{FF9900}������",
										"{FFFFFF}��� ��� �� ������ ��������� �����. �������� ��� � ��������� �����������",
										"������", ""
									);
									return Kick:(playerid);
								}
								else 
								{
									format(g_player[playerid][P_PASSWORD], 16, "%s", inputtext);
								}
							}
							else reg_step --;
						}
						case REGISTER_STATE_EMAIL: 		// ���� ������
						{
							if(str_len)
							{
								if(!IsValidMail(inputtext, str_len))
								{
									Dialog
									(
										playerid, DIALOG_REGISTER, DIALOG_STYLE_MSGBOX,
										"{FF9900}������",
										"{FFFFFF}����� ����������� ����� ������ �������",
										"������", ""
									);
									return PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
								}
								new query[128];
								new Cache: result, is_email_exist;
								
								mysql_format(mysql, query, sizeof query, "SELECT email FROM accounts WHERE email='%e' LIMIT 1", inputtext);
								result = mysql_query(mysql, query);
								
								is_email_exist = cache_num_rows();
								cache_delete(result);
								
								if(is_email_exist)
								{
									Dialog
									(
										playerid, DIALOG_REGISTER, DIALOG_STYLE_MSGBOX,
										"{FF9900}������",
										"{FFFFFF}���� ����� ����������� ����� ��� �������� � ������� ��������",
										"������", ""
									);
									return PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
								}
								else 
								{
									format(g_player[playerid][P_EMAIL], 61, "%s", inputtext);
								}
							}
							else reg_step --;
						}
						case REGISTER_STATE_REFER: 		// ���� ���� ������������� ������
						{
							if(response)
							{
								if(2 <= str_len <= 20)
								{
									new query[75];
									new Cache: result;
									
									mysql_format(mysql, query, sizeof query, "SELECT id FROM accounts WHERE name='%e' LIMIT 1", inputtext);
									result = mysql_query(mysql, query);
									
									if(cache_num_rows())
										SetPlayerData(playerid, P_REFER, cache_get_row_int(0, 0));
									
									cache_delete(result);
									
									if(!GetPlayerData(playerid, P_REFER))
									{
										Dialog
										(
											playerid, DIALOG_REGISTER, DIALOG_STYLE_MSGBOX,
											"{FF9900}������",
											"{FFFFFF}������ ������ �� ����������.\n"\
											"���� �� �� ������ ������ ������� ������� ������ \"����������\"",
											"������", "����������"
										);
										return PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
									}
								}
								else reg_step --;
							}
						}
						case REGISTER_STATE_SEX:		// ����� ����
						{
							SetPlayerData(playerid, P_SEX, !response);
						}
					}
					ShowPlayerRegDialog(playerid, reg_step + 1);
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_PLAYER_MENU:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1: ShowPlayerStats(playerid);
						case 2: ShowPlayerCMDSDialog(playerid);
						case 3: ShowPlayerSettings(playerid);
						case 4: ShowPlayerSecuritySettings(playerid);
						case 5: ShowPlayerReportDialog(playerid);
						case 6: ShowPlayerImprovementsDialog(playerid);
						case 7: ShowServerRules(playerid);
						case 8: ShowPlayerChangeNameDialog(playerid);
						case 9:
						{
							// 9. �������������
						}
						default: 
							return 1;
					}
				}
			}
			case DIALOG_PLAYER_STATS:
			{
				if(response)
				{
					cmd::menu(playerid, "");
				}
			}
			case DIALOG_PLAYER_CMDS:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1:
						{
							Dialog
							(
								playerid, INVALID_DIALOG_ID, DIALOG_STYLE_INPUT,
								"{99CC00}�������� �������",
								"{FFFFFF}������� ������������ ��� �������\n"\
								"��� ��������� �� ��������:",
								"��������", "�����"
							);
							return 1;
						}
						case 2:
						{
							SendClientMessage(playerid, 0x99FF00FF, "/menu (/mn)  /gps  /help  /find  /leaders  /buy  /leave  /healme  /pay  /givemet  /givepatr  /charity  /lic  /liclist  /adlist  /play  /style");
							SendClientMessage(playerid, 0x99FF00FF, "/anim(list)  /yes  /no  /cancel  /setspawn  /skill  /eject  /pass  /drugs  /togphone  /book  /wbook  /add  /returnskin  /returnmoney  /hospital");
							SendClientMessage(playerid, 0x99FF00FF, "/fuel  /bushelp  /take  /donat(e)  /blow  /reset  /hreset  /set  /eat  /put  /pick  /id  /unwarn  /radio  /time  /wedding  /divorce  /bank  /history  /dice");
							SendClientMessage(playerid, 0xFFC000FF, "���������: /lock  /buyfuel  /rentcar  /unrent  /tune  /e  /l  /sl  /b  /i  /alarm");
							SendClientMessage(playerid, 0xFFC000FF, "������ ���������: /sellcar  /sellmycar  /key  /car  /allow  /getmycar  /park");
						}
						case 3:
						{
							SendClientMessage(playerid, 0x00CC33FF, "/c(all)  /sms  /p  /h  /f  /r  /me  /do  /try  /s  /w  /ad  /gnews  /n");
						}
						case 4:
						{
							SendClientMessage(playerid, 0x00CCFFFF, "/home  /sellhome  /sellmyhome  /exit  /tv  /makestore  /use  /live  /liveout  /homelock");
						}
						case 5:
						{
							SendClientMessage(playerid, 0x33CC66FF, "������: /business  /buybiz  /sellbiz  /sellmybiz  /bizmusic  /manager");
							SendClientMessage(playerid, 0x33CC66FF, "���: /fuelst  /buyfuelst  /sellfuelst  /sellmyfuelst");
						}
						case 6:
						{
							SendClientMessage(playerid, 0x6699CCFF, "��������: /fire");
							SendClientMessage(playerid, 0x6699CCFF, "���������: /buyprod  /buyf  /bizlist  /fuellist");
							SendClientMessage(playerid, 0x6699CCFF, "�����������: /getfuel  /fill  /repair");
							SendClientMessage(playerid, 0x6699CCFF, "������� ��������: /market");
						}
						case 7:
						{
							SendClientMessage(playerid, 0xCCCC33FF, "�����: /makegun  /sellgun  /selldrugs  /capture  /sellzone  /hack  /robstore  /robcar  /close");
							SendClientMessage(playerid, 0xCCCC33FF, "�����: /affect  /stopaffect  /tie  /bag  /object  /pickammo  /putammo  /takeammo  /bomb  /close");
						}
						case 8:
						{
							SendClientMessage(playerid, 0x99CC33FF, "���. ����������: /smenu  /ap  /court");
							SendClientMessage(playerid, 0x99CC33FF, "��������� ���������: /debtorlist  /debtorsell");
							SendClientMessage(playerid, 0x99CC33FF, "����������: /givelic  /takelic.  ���������: /free");
						}
						case 9:
						{
							SendClientMessage(playerid, 0x0066FFFF, "/search  /remove  /cuff  /uncuff  /clear  /arrest  /su  /m  /ticket");
							SendClientMessage(playerid, 0x0066FFFF, "/takelic  /wanted  /setmark  /putpl  /open  /break  /skip");
							SendClientMessage(playerid, 0x0066FFFF, "���: /fbi  /hack  /follow  /untie");
						}
						case 10:
						{
							SendClientMessage(playerid, 0xCC9900FF, "/makegun  /gate  /gun  /shot  /takem  /putm  /buym");
							SendClientMessage(playerid, 0xCC9900FF, "/pickammo  /putammo  /takeammo");
						}
						case 11:
						{
							SendClientMessage(playerid, 0xFF66FFFF, "/heal  /out  /medhelp  /medskip  /changesex");
						}
						case 12:
						{
							SendClientMessage(playerid, 0xFFCC33FF, "/t  /u  /edit  /bring  /audience  /tvlift  /tvjoin  /camera  /light  /makeskin  /givemic");
						}
						case 13:
						{
							SendClientMessage(playerid, 0xFFFFFFFF, "/newleader  /invite  /uninvite  /rang  /changeskin  /showall  /uninviteoff");
						}
						case 14:
						{
							SendClientMessage(playerid, 0x999999FF, "/buym  /sellm  /buyf  /sellf  /lift  /lifthelp  /tmenu  /card  /showcard");
							SendClientMessage(playerid, 0x999999FF, "/mask  /present  /to  /race  /end  /tp");
						}
						default: 
							return 1;
					}
					ShowPlayerCMDSDialog(playerid);
				}
				else cmd::menu(playerid, "");
			}
			case DIALOG_PLAYER_SETTINGS:
			{
				if(response)
				{
					new E_PLAYER_SETTINGS_STRUCT: setting_id = E_PLAYER_SETTINGS_STRUCT: listitem;
					if(S_CHAT_TYPE <= setting_id <= S_VEH_CONTROL)
					{
						new setting_type = GetPlayerSettingData(playerid, setting_id);
						
						switch(setting_id)
						{
							case S_CHAT_TYPE:
							{
								if(!(SETTING_CHAT_OFF <= ++setting_type <= SETTING_CHAT_ADVANCE))
								{
									setting_type = SETTING_CHAT_OFF;
								}
							}
							case S_TEAM_CHAT..S_VEH_CONTROL:
							{
								setting_type ^= SETTING_TYPE_ON;
							}
						}
						if(setting_id == S_PLAYERS_NICK)
						{
							foreach(new idx : Player)
								ShowPlayerNameTagForPlayer(playerid, idx, setting_type);
						}	
						
						SetPlayerSettingData(playerid, setting_id, setting_type);
						SetPlayerChatInit(playerid);
						
						ShowPlayerSettings(playerid);
					}
					else 
					{
						new query[128];
						
						format
						(
							query, sizeof query,
							"UPDATE accounts SET "\
							"setting1=%d,"\
							"setting2=%d,"\
							"setting4=%d,"\
							"setting5=%d,"\
							"setting6=%d,"\
							" WHERE id=%d LIMIT 1",
							GetPlayerSettingData(playerid, S_CHAT_TYPE),
							GetPlayerSettingData(playerid, S_TEAM_CHAT),
							GetPlayerSettingData(playerid, S_NICK_IN_CHAT),
							GetPlayerSettingData(playerid, S_ID_IN_CHAT),
							GetPlayerSettingData(playerid, S_VEH_CONTROL),
							GetPlayerAccountID(playerid)							
						);
						mysql_query(mysql, query, false);
						
						if(!mysql_errno())
						{
							Dialog
							(
								playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
								"{FFCD00}���������",
								"{FFFFFF}����� ��������� ����� ������������� ��������������� ����� ������ �����������",
								"��", ""
							);
						}
						else 
						{
							SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 02)");
							ShowPlayerSettings(playerid);
						}
					}
				}
				else cmd::menu(playerid, "");
			}
			case DIALOG_PLAYER_SECURITY_SETTINGS:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1:
						{
							Dialog
							(
								playerid, DIALOG_SECURITY_SETTING_INFO, DIALOG_STYLE_MSGBOX,
								"{FFCD00}���������� � ����������",
								"{FFFFFF}��� �� ������ �������� ��������� ������������ ������ ��������. ���\n"\
								"������� �������� ��� �� ������.\n\n"\
								"���������� 3 ���� ������: � �������������� ���������� ����������\n"\
								"{6699FF}Google Authenticator{FFFFFF}, ������� '��������� ���' ��� ������ ����������\n"\
								"��������. ���� �� �������� ������, �� ��� �����������, ������\n"\
								"������, ����� ������������� ���� ���� ��� ����� ������ ��������\n"\
								"(� ����������� �� ����� ��������). ��������� �� ������ ������, ������\n"\
								"������ ����� � ���� ������������.\n\n"\
								"������� ����� ����������� ���� ������ ���� ��� IP ����� ��� �������\n"\
								"(������ 2 ����� IP ������) ������ �� ��������� � ����, ������� ����\n"\
								"�������� ��� �������� ����� � ����. ������� �������, �������\n"\
								"������ ������, ���� ��� ����� ��������� ���������� ����� � �������\n"\
								"����������.",
								"�����", ""
							);
						}
						case 2:
						{
							if(strcmp(GetPlayerData(playerid, P_SETTING_PHONE), "None", true) != 0)
							{
								// ����������
								Dialog
								(
									playerid, DIALOG_SECURITY_SETTING_PHONE, DIALOG_STYLE_LIST,
									"{FFCD00}��� ����������� ����������� ���������...",
									"�� �����������\n"\
									"���� ������� �� ��������� � ����\n"\
									"���� IP �� ��������� � ����",
									"���������", "�����"
								);
							}
							else 
							{
								// �� ����������
								Dialog
								(
									playerid, DIALOG_SECURITY_SETTING_INFO, DIALOG_STYLE_MSGBOX,
									"{FFCD00}��������� �������",
									"{FFFFFF}� ������ ������ �� �������� ���������� ���� ������� ������������.\n"\
									"�������� ���� ��������� �� ��������� ����������.",
									"�����", ""
								);
							}

						}
						case 3:
						{
							if(strcmp(GetPlayerData(playerid, P_SETTING_PIN), "None", true) != 0)
							{
								Dialog
								(
									playerid, DIALOG_SECURITY_SETTING_PIN, DIALOG_STYLE_LIST,
									"{FFCD00}��� ����������� ����������� ��������� PIN-���...",
									"�� �����������\n"\
									"���� ������� �� ��������� � ����\n"\
									"���� IP �� ��������� � ����",
									"���������", "�����"
								);
							}
							else
							{
								Dialog
								(
									playerid, DIALOG_SECURITY_SETTING_PIN_SET, DIALOG_STYLE_MSGBOX,
									"{FFCD00}��������� PIN-���",
									"{FFFFFF}��� �����������, ��� ���������� ��������� � ������� 4-� ������� ���.\n\n"\
									"��� ������� ������������ ������� �������� ��� �������, ���� ��\n"\
									"��������� ������� �����-���������, ������� ������������� ������ �\n"\
									"����������.  ������ ������ ������������� � ��������� �������, ��� �� ����\n"\
									"��������������� ����������� ������ ��� PIN-���.",
									"�����", "�����"
								);
							}
						}
						case 4:
						{
							Dialog
							(
								playerid, DIALOG_SECURITY_SETTING_INFO, DIALOG_STYLE_MSGBOX,
								"{FFCD00}������ � �������������� ���������� Authenticator",
								"{FFFFFF}���� ��� ������ �������� ����� �������� ��� ������ ��������. ����� ��� ������������,\n"\
								"������� � ������ ������� �� ����� {33CCFF}"SERVER_SITE" (��������� > �������� ���.) {FFFFFF}� ��������\n"\
								"�����������.\n\n"\
								"��� ����������� ��������� ���������� � ���������� ��������� ���������� (Android, iOS,\n"\
								"Windows Phone � ������). ����� ��������� ������ �� �����, ��������� � ��� ���� ���\n"\
								"���������� ���������.",
								"�����", ""
							);
						}
						case 5:
						{
							Dialog
							(
								playerid, DIALOG_SECURITY_SETTING_PASS_1, DIALOG_STYLE_INPUT,
								"{FFCD00}��������� ������",
								"{FFFFFF}������� ��� ������� ������ � ���� ����:",
								"�����", "�����"
							);
						}
						case 6:
						{
							if(!strcmp(GetPlayerData(playerid, P_SETTING_PIN), "None", true))
							{
								Dialog
								(
									playerid, DIALOG_SECURITY_SETTING_PIN_SET, DIALOG_STYLE_MSGBOX,
									"{FFCD00}��������� PIN-���",
									"{FFFFFF}��� �����������, ��� ���������� ��������� � ������� 4-� ������� ���.\n\n"\
									"��� ������� ������������ ������� �������� ��� �������, ���� ��\n"\
									"��������� ������� �����-���������, ������� ������������� ������ �\n"\
									"����������.  ������ ������ ������������� � ��������� �������, ��� �� ����\n"\
									"��������������� ����������� ������ ��� PIN-���.",
									"�����", "�����"
								);
							}
							else ShowPlayerPinCodePTD(playerid, PIN_CODE_STATE_CHECK);
						}
						case 7:
						{
							// 7. ������ ������������
							static const 
								setting_status_name[3][64] = 
							{
								"{CC9900}�� �������������",
								"{3399FF}������������� ��� ������������ �������", 
								"{009900}������������� ��� ������������ IP"
							};
							
							new fmt_str[364];
							format
							(
								fmt_str, sizeof fmt_str,
								"{FFFFFF}��� �� ������ ������� ������ ���� ����� �������� ������������.\n"\
								"��� �� ���������, �������� ������ ����� � ���� ��������\n\n"\
								"��������� �������:\t\t%s\n"\
								"{FFFFFF}��������� PIN-���:\t\t%s\n"\
								"{FFFFFF}Google Authenticator:\t\t{CC9900}�� �������������",
								setting_status_name[GetPlayerData(playerid, P_REQUEST_PHONE)],
								setting_status_name[GetPlayerData(playerid, P_REQUEST_PIN)]
							);
							Dialog(playerid, DIALOG_SECURITY_SETTING_INFO, DIALOG_STYLE_MSGBOX, "{FFCD00}������ ������������", fmt_str, "�����", "");
						}
						case 8:
						{
							if(GetPlayerData(playerid, P_CONFIRM_EMAIL))
								return SendClientMessage(playerid, 0xFFFFFFFF, "��� Email-����� ��� �����������");
							
							Dialog
							(
								playerid, DIALOG_SECURITY_SETTING_EMAIL, DIALOG_STYLE_MSGBOX,
								"{6699FF}������������� Email",
								"{FFFFFF}��� ����������� �� ������� �� ���� ����� �� ������� ������ ���\n"\
								"������������� Email. ��� ������������� � ������� 14 ����.\n"\
								"����������, ��������� ����� � ����������� ��.\n\n"\
								"� ������, ���� �� �� �������� ���� ������, ������� ������ \"������\".\n"\
								"�� �������� ��� ����� ������.",
								"�������", "������"
							);
						}
						default: 
							return 1;
					}
				}
				else cmd::menu(playerid, "");
			}
			case DIALOG_SECURITY_SETTING_INFO:
			{
				ShowPlayerSecuritySettings(playerid);
			}
			case DIALOG_SECURITY_SETTING_PHONE:
			{
				if(!strcmp(GetPlayerData(playerid, P_SETTING_PHONE), "None", true)) return 1;
				
				if(response)
				{
					if(0 <= listitem <= 2)
					{
						new query[64 + 1];
						SetPlayerData(playerid, P_REQUEST_PHONE, listitem);
						
						format(query, sizeof query, "UPDATE accounts SET request_phone=%d WHERE id=%d LIMIT 1", listitem, GetPlayerAccountID(playerid));
						mysql_query(mysql, query, false);
				
						if(!mysql_errno())
						{
							SendClientMessage(playerid, 0xFFFFFFFF, "��������� � ���������� ������������ {00FFCC}���������");
							switch(listitem + 1)
							{
								case 1: SendClientMessage(playerid, 0xFF6600FF, "������ �� ���� ���������� �������� ��������");
								case 2: SendClientMessage(playerid, 0xFFFF00FF, "��� ��������� ������� ����� ������������� ��� ������������ �������");
								case 3: SendClientMessage(playerid, 0x66CC00FF, "��������� ������� ����� ������������� ��� ������������ IP �������");
							}
						}
						else 
						{
							SendClientMessage(playerid, 0xFFFFFFFF, "��������� � ���������� ������������ {FF3333}�� ���������");
							SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 03)");
						}
					}
				}
				ShowPlayerSecuritySettings(playerid);
			}
			case DIALOG_SECURITY_SETTING_PHONE_S:
			{
				// ���������� �������
				if(strcmp(GetPlayerData(playerid, P_SETTING_PHONE), "None", true) != 0) return 1;
			}
			case DIALOG_SECURITY_SETTING_PIN:
			{
				if(!strcmp(GetPlayerData(playerid, P_SETTING_PIN), "None", true)) return 1;
				
				if(response)
				{
					if(0 <= listitem <= 2)
					{
						new query[64 + 1];
						SetPlayerData(playerid, P_REQUEST_PIN, listitem);
						
						format(query, sizeof query, "UPDATE accounts SET request_pin=%d WHERE id=%d LIMIT 1", listitem, GetPlayerAccountID(playerid));
						mysql_query(mysql, query, false);
				
						if(!mysql_errno())
						{
							SendClientMessage(playerid, 0xFFFFFFFF, "��������� � ���������� ������������ {00FFCC}���������");
							switch(listitem + 1)
							{
								case 1: SendClientMessage(playerid, 0xFF6600FF, "������ ���������� PIN-���� ��������");
								case 2: SendClientMessage(playerid, 0xFFFF00FF, "��� ��������� PIN-��� ����� ������������� ��� ������������ �������");
								case 3: SendClientMessage(playerid, 0x66CC00FF, "��������� PIN-��� ����� ������������� ��� ������������ IP �������");
							}
						}
						else 
						{
							SendClientMessage(playerid, 0xFFFFFFFF, "��������� � ���������� ������������ {FF3333}�� ���������");
							SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 03)");
						}
					}
				}
				ShowPlayerSecuritySettings(playerid);
			}
			case DIALOG_SECURITY_SETTING_PIN_SET:
			{
				// ���������� ��� ���
				if(strcmp(GetPlayerData(playerid, P_SETTING_PIN), "None", true) != 0) return 1;
				
				if(response)
				{
					ShowPlayerPinCodePTD(playerid, PIN_CODE_STATE_SET);
				}
				else ShowPlayerSecuritySettings(playerid);
			}
			case DIALOG_SECURITY_SETTING_PASS_1:
			{
				if(response)
				{
					if
					(
						strlen(inputtext) 
						&& !strcmp(inputtext, GetPlayerData(playerid, P_PASSWORD), false)
					)
					{
						Dialog
						(
							playerid, DIALOG_SECURITY_SETTING_PASS_2, DIALOG_STYLE_INPUT,
							"{FFCD00}����� ������",
							"{FFFFFF}������� ����� ������ � ���� ����:",
							"��������", "������"
						);
						return 1;
					}
					else SendClientMessage(playerid, 0xFF6600FF, "�� ����� �������� ������");
				}
				ShowPlayerSecuritySettings(playerid);
			}
			case DIALOG_SECURITY_SETTING_PASS_2:
			{
				if(response)
				{
					if(!(1 <= strlen(inputtext) <= 15) || strfind(inputtext, " ") != -1)
					{
						SendClientMessage(playerid, 0xFF6600FF, "����� ������ ������ ���� �� 6 �� 15 ��������");
						SendClientMessage(playerid, 0xFF6600FF, "����� �� ����������� ������������� ��������");
					}
					else 
					{
						new query[85];
						mysql_format(mysql, query, sizeof query, "UPDATE accounts SET password='%e' WHERE id=%d LIMIT 1", inputtext, GetPlayerAccountID(playerid));
						mysql_query(mysql, query, false);
						
						if(!mysql_errno())
						{
							format(g_player[playerid][P_PASSWORD], 16, "%s", inputtext);
							format(query, sizeof query, "��� ����� ������: {3399FF}%s", GetPlayerData(playerid, P_PASSWORD));
							
							SendClientMessage(playerid, 0xFFFF00FF, query);
							SendClientMessage(playerid, 0xFFFFFFFF, "����������� ������� ����� {00CC00}(������� F8) {FFFFFF}����� �� ������ ���");
							
							ShowPlayerSecuritySettings(playerid);
							return 1;
						}
						else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 05)");
					}
					
					Dialog
					(
						playerid, DIALOG_SECURITY_SETTING_PASS_2, DIALOG_STYLE_INPUT,
						"{FFCD00}����� ������",
						"{FFFFFF}������� ����� ������ � ���� ����:",
						"��������", "������"
					);
				}
				else ShowPlayerSecuritySettings(playerid);
			}
			case DIALOG_SECURITY_SETTING_EMAIL:
			{
				if(!response)
				{
					// �������� ���� �� �����
					Dialog
					(
						playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
						"{FFCD00}������ ����������",
						"{FFFFFF}� ������� ���������� ����� �� ���� ����� ������ ������ � ����� �������.\n"\
						"��������� �� ��� ��� ������������� Email.",
						"�������", ""
					);
				}
			}
			case DIALOG_REPORT:
			{
				if(response)
				{
					new len = strlen(inputtext);
					if(1 <= len <= 80)
					{
						new fmt_str[128];
						
						format(fmt_str, sizeof fmt_str, "%s[%d] : {FFCD00}%s", GetPlayerNameEx(playerid), playerid, inputtext);
						SendMessageToAdmins(fmt_str, 0x66CC00FF);
						
						if(GetPlayerAdminEx(playerid) < 1)
							SendClientMessage(playerid, 0x66CC00FF, fmt_str);
							
						SendClientMessage(playerid, 0xFFFFFFFF, "���� ��������� ����������");
						
						return 1;
					}
					else if(len > 80)
					{	
						SendClientMessage(playerid, 0x999999FF, "������� ������� ���������");
					}
					ShowPlayerReportDialog(playerid);
				}
				else cmd::menu(playerid, "");
			}
			case DIALOG_PLAYER_IMPROVEMENTS:
			{
				if(response)
				{
					new my_i_level = GetPlayerData(playerid, P_IMPROVEMENTS);
					
					if(0 <= listitem <= sizeof(g_player_improvements)-1)
					{
						new i_level = GetPlayerImprovementInfo(listitem, I_LEVEL);
						new i_price = GetPlayerImprovementInfo(listitem, I_PRICE);
						
						if(my_i_level < listitem)
						{
							SendClientMessage(playerid, 0xCECECEFF, "��� ��������� ���� �� ��������");
						}
						else if(my_i_level > listitem)
						{
							SendClientMessage(playerid, 0xCECECEFF, "�� ��� ������ ��� ���������");
						}
						else if(GetPlayerLevel(playerid) < i_level || GetPlayerMoneyEx(playerid) < i_price)
						{
							new fmt_str[64 + 1];
							
							format(fmt_str, sizeof fmt_str, "��� ������� ����� ��������� ��������� %d ������� � %d ������", i_level, i_price);
							SendClientMessage(playerid, 0x999999FF, fmt_str);
						}
						else 
						{
							new fmt_str[85];
			
							format(fmt_str, sizeof fmt_str, "UPDATE accounts SET money=%d,improvements=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid) - i_price, my_i_level + 1, GetPlayerAccountID(playerid));
							mysql_query(mysql, fmt_str, false);
							
							if(!mysql_errno())
							{
								GivePlayerMoneyEx(playerid, -i_price, "������� ��������� ��������", false);
								
								AddPlayerData(playerid, P_IMPROVEMENTS, +, 1);
								
								format(fmt_str, sizeof fmt_str, "�� ��������� ��������� {FFCD00}\"%s\"", GetPlayerImprovementInfo(listitem, I_NAME));
								SendClientMessage(playerid, 0x3399FFFF, fmt_str);
							
								switch(listitem + 1)
								{
									case 1: 
										SendClientMessage(playerid, 0xCECECEFF, "������� �������� ����� ����������� ����������� ���������");
								
									case 2: 
										SendClientMessage(playerid, 0xCECECEFF, "������ �� ������ �������� ����������� �� ������������ ������� {33FF33}(/leave)");
									
									case 3: 
										SendClientMessage(playerid, 0xCECECEFF, "������ �� ������ ������ � ����� � 2 ���� ������ �������, �������� � ����������");
									
									case 4: 
										SendClientMessage(playerid, 0xCECECEFF, "-TODO (No Info)-");
									
									case 5: 
										SendClientMessage(playerid, 0xCECECEFF, "-TODO (No Info)-");
								}
							}
							else 
							{
								SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 06)");
								ShowPlayerImprovementsDialog(playerid);
							}
						}
					}
					else 
					{
						Dialog
						(
							playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
							"{0099CC}����������",
							"{FFFFFF}1. ������������ �������� ���������� � ������� ����� ����������\n"\
							"�����. ������� �������� ����� ����������� ���������.\n\n"\
							"2. ������������� �������� ��� �������������� ������� ������� ��\n"\
							"���������� � ����������� (������� /leave). ��� ������������� �� ��\n"\
							"������� �������� ����������� �� ������������ �������.\n\n"\
							"3. ������ ���� ����������� ���������� � ����� ������, ������� �\n"\
							"��������� � ������� ������� ����������.\n\n"\
							"4. ���� �������� ��������, ��������� ���������� ��� ����� �����������\n"\
							"������ �� ����� �������� ��� ��������� ������.\n\n"\
							"5. ������ ���������� ��������� ��� ���� ������ � ������ ������,\n"\
							"��� ������ �� ����.",
							"�������", ""
						);
					}
				}
				else cmd::menu(playerid, "");
			}
			case DIALOG_CHANGE_NAME:
			{
				if(response)
				{
					if(!GetPVarInt(playerid, "change_name_status"))
					{
						new len = strlen(inputtext);
						if(4 <= len <= 20) 
						{
							new bool: valid_name = true;
							for(new idx; idx < len; idx ++)
							{
								switch(inputtext[idx])
								{
									case 'a'..'z', 'A'..'Z', '[', ']', '_': continue;
									default:
										valid_name = false;
								}
							}
							
							if(!strcmp(GetPlayerNameEx(playerid), inputtext, true))
							{
								SendClientMessage(playerid, 0xFF6600FF, "�� ��� ����������� ��� ���");
							}
							else if(valid_name)
							{
								new query[128];
								new Cache: result, rows;
								
								mysql_format(mysql, query, sizeof query, "SELECT id FROM accounts WHERE name='%e' LIMIT 1", inputtext);
								result = mysql_query(mysql, query, true);
								
								rows = cache_num_rows();
								cache_delete(result);
								
								if(!rows)
								{
									SetPVarInt(playerid, "change_name_status", 1);
									SetPVarString(playerid, "change_name", inputtext);
								
									Dialog
									(
										playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
										"{FFCD00}������ �� ��������� �����",
										"{FFFFFF}���� ������� �� ��������� ���� ���������� �������������.\n"\
										"�� �������� ���������, ��� ������ ������ ����� ����������.\n\n"\
										"���� � ������� ���������� ����� ���� ��� �� ���� ��������,\n"\
										"��, ������ �����, ��� �� ������������� RP ��������,\n"\
										"���� �� ��� ����������� RP ���.",
										"��", ""
									);

									format(query, sizeof query, "[����� non rp �����] %s >> %s {FFCD00}| /okay %d ��� ���������" , GetPlayerNameEx(playerid), inputtext, playerid);
									SendMessageToAdmins(query, 0x66CC99FF);
									
								}
								else SendClientMessage(playerid, 0xFF6600FF, "��������� ���� ��� ��� ������������");
								
							}
							else 
							{
								SendClientMessage(playerid, 0xFF6600FF, "��� ��� ������������ ��� �������� ������������ �������");
								SendClientMessage(playerid, 0xFFFFFFFF, "����������� ��������� ����� a-z A-Z, � ����� ������� [ ] _");
							}
						}
						else SendClientMessage(playerid, 0xFF6600FF, "������������ ������ �����");
					}
					else SendClientMessage(playerid, 0xCECECEFF, "�� ��� �������� ������ �� ��������� �����");
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_GPS:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1:
						{
							Dialog
							(
								playerid, DIALOG_GPS_PUBLIC_PLACES, DIALOG_STYLE_LIST,
								"{FFCD00}������������ �����",
								"1. ������������ �����\n"\
								"2. ����� ���-�������\n"\
								"3. ����� ���-������\n"\
								"4. ����� ���-���������\n"\
								"5. ������������� ����������\n"\
								"6. ���������\n"\
								"7. ���������\n"\
								"8. ��������� ������-������ (��)\n"\
								"9. ��������� �������� ������ (��)\n"\
								"10. ��������� �������� ������ �2 (��)\n"\
								"11. ��������� ������� ������ (��)\n"\
								"12. ����-���� ����� (��)\n"\
								"13. �������� ������� ���-������\n"\
								"14. ���������� ���\n"\
								"15. ����������� ������� (���-������)\n"\
								"16. ������� ���-������\n"\
								"17. ������� ���-���������\n"\
								"18. ������� ���-������\n"\
								"19. ����������",
								"��������", "�����"
							);
						}
						case 2:
						{
							Dialog
							(
								playerid, DIALOG_GPS_TRANSPORT, DIALOG_STYLE_LIST,
								"{FFCD00}������������ ����",
								"1. �/� ������ ���-�������\n"\
								"2. ����������� ����������� (���-������)\n"\
								"3. �/� ������ � ����������� ���-������\n"\
								"4. �/� ������ � ����������� ���-���������\n"\
								"5. �/� ������� ���-��������-2\n"\
								"6. �/� ������� ���-������-2\n"\
								"7. �������� ���-�������\n"\
								"8. �������� ���-������\n"\
								"9. �������� ���-���������",
								"��������", "�����"
							);
						}
						case 3:
						{
							Dialog
							(
								playerid, DIALOG_GPS_STATE_ORGANIZATIONS, DIALOG_STYLE_LIST,
								"{FFCD00}��������������� �����������",
								"1. ������������ ���������� ���\n"\
								"2. ������� ���-�������\n"\
								"3. ������� ���-������\n"\
								"4. ������� ���-���������\n"\
								"5. ���� ���\n"\
								"6. ������������ �������\n"\
								"7. ���� ���������� �����\n"\
								"8. ���� ������-��������� ���\n"\
								"9. ���� ������-�������� �����\n"\
								"10. ������������ ���������������\n"\
								"11. �������� ���-�������\n"\
								"12. �������� ���-������\n"\
								"13. �������� ���-���������\n"\
								"14. ���������� ���-�������\n"\
								"15. ���������� ���-������\n"\
								"16. ���������� ���-���������\n"\
								"17. ���������",
								"��������", "�����"
							);
						}
						case 4:
						{
							Dialog
							(
								playerid, DIALOG_GPS_GANGS, DIALOG_STYLE_LIST,
								"{FFCD00}���� ���� � �����",
								"1. Grove Street\n"\
								"2. The Ballas\n"\
								"3. Los Santos Vagos\n"\
								"4. The Rifa\n"\
								"5. Varios Los Aztecas\n"\
								"{CCCC66}6. La Cosa Nostra\n"\
								"{CCCC66}7. Yakuza\n"\
								"{CCCC66}8. ������� �����",
								"��������", "�����"
							);
						}
						case 5:
						{
							Dialog
							(
								playerid, DIALOG_GPS_JOBS, DIALOG_STYLE_LIST,
								"{FFCD00}�� ������",
								"1. ��������� ����� {CC9900}(������ ��������)\n"\
								"2. ����� {CC9900}(������ �������)\n"\
								"3. ����� �� ������������ ���������\n"\
								"4. ����������\n"\
								"5. �������� ��� ����������� ���������\n"\
								"6. �������� ��� ����������� �������\n"\
								"7. �������� ������� ���-�������\n"\
								"8. �������� ������� ���-������\n"\
								"9. �������� ������� ���-���������\n"\
								"10. ������� ������������� ��\n"\
								"11. ������� ������������� ��\n"\
								"12. ������� ������������� ��\n"\
								"13. ��������������� ���� (������� �������)",
								"��������", "�����"
							);
						}
						case 6:
						{
							Dialog
							(
								playerid, DIALOG_GPS_BANKS, DIALOG_STYLE_LIST,
								"{FFCD00}�����",
								"1. ���� ���-�������\n"\
								"2. ���� ���-������\n"\
								"3. ���� Palomino Creek\n"\
								"4. ������� ���� Angel Pine\n"\
								"5. ������� ���� Las Barrancas\n"\
								"6. ������� ���� Fort Carson",
								"��������", "�����"
							);
						}
						case 7:
						{
							Dialog
							(
								playerid, DIALOG_GPS_ENTERTAINMENT, DIALOG_STYLE_LIST,
								"{FFCD00}�����������",
								"1. ���\n"\
								"2. �������� ������ (�������)\n"\
								"3. ����������� �����\n"\
								"{66CC99}4. ����� ����� '����������� San Andreas'\n"\
								"{66CC99}5. ����� ����� '������ �� ���� ������'\n"\
								"{66CC99}6. ����� ����� '�������� San Andreas'\n"\
								"{66CC99}7. ����� ����� �� �������\n"\
								"{FFC065}8. ������-���������� �� ����������� ������\n"\
								"{FFC065}9. ������-���������� �� ������������� ��������\n"\
								"{FFC065}10. ������-���������� �� ����� ����������\n"\
								"{FFC065}11. ������-���������� ��� �����\n"\
								"12. ������ '4 �������'\n"\
								"13. ������ '��������'\n"\
								"14. ������ '���-������' (�������)\n"\
								"15. ������ '���-��������' (�������)\n"\
								"16. ��������� ������ (�������)\n"\
								"17. ����� ������ (�������)",
								"��������", "�����"
							);
						}
						case 8: // 8. ������
						{
							CallLocalFunction("ShowPlayerGPSBusinessList", "i", playerid);
						}
						case 9:
						{
							new fmt_str[128];
							
							new stationid;
							new Float: dist;
							
							stationid = GetNearestFuelStation(playerid, 0.0);
							dist = GetPlayerDistanceFromPoint(playerid, GetFuelStationData(stationid, FS_POS_X), GetFuelStationData(stationid, FS_POS_Y), GetFuelStationData(stationid, FS_POS_Z));
							
							EnablePlayerGPS
							(
								playerid,
								47,
								GetFuelStationData(stationid, FS_POS_X),
								GetFuelStationData(stationid, FS_POS_Y),
								GetFuelStationData(stationid, FS_POS_Z),
								""
							);
							
							format(fmt_str, sizeof fmt_str, "����� ���� � ��� ��������� ��� �%d \"%s\" (���������� %.1f �)", stationid, GetFuelStationData(stationid, FS_NAME), dist);
							SendClientMessage(playerid, 0xFFFF00FF, fmt_str);
						
							SendClientMessage(playerid, 0xFFFF00FF, "��� �������� � ��� ������ {0099CC}Z");
						}
						default: 
							return 1;
					}
				}
			}
			case DIALOG_GPS_PUBLIC_PLACES:
			{		
				if(response)
				{
					if(0 <= listitem <= sizeof gps_public_places-1)
					{
						EnablePlayerGPS
						(
							playerid,
							gps_public_places[listitem][G_MARKET_TYPE],
							gps_public_places[listitem][G_POS_X],
							gps_public_places[listitem][G_POS_Y],
							gps_public_places[listitem][G_POS_Z],
							"����� �������� � ��� �� GPS"
						);
					}
				}
				else cmd::gps(playerid, "");
			}
			case DIALOG_GPS_TRANSPORT:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof gps_transport-1)
					{
						EnablePlayerGPS
						(
							playerid,
							gps_transport[listitem][G_MARKET_TYPE],
							gps_transport[listitem][G_POS_X],
							gps_transport[listitem][G_POS_Y],
							gps_transport[listitem][G_POS_Z],
							"����� �������� � ��� �� GPS"
						);
					}
				}
				else cmd::gps(playerid, "");
			}
			case DIALOG_GPS_STATE_ORGANIZATIONS:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof gps_state_organizations-1)
					{
						EnablePlayerGPS
						(
							playerid,
							gps_state_organizations[listitem][G_MARKET_TYPE],
							gps_state_organizations[listitem][G_POS_X],
							gps_state_organizations[listitem][G_POS_Y],
							gps_state_organizations[listitem][G_POS_Z],
							"�������������� ����������� �������� � ��� �� GPS"
						);
					}
				}
				else cmd::gps(playerid, "");
			}
			case DIALOG_GPS_GANGS:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof gps_gangs-1)
					{
						EnablePlayerGPS
						(
							playerid,
							gps_gangs[listitem][G_MARKET_TYPE],
							gps_gangs[listitem][G_POS_X],
							gps_gangs[listitem][G_POS_Y],
							gps_gangs[listitem][G_POS_Z],
							"����� �������� � ��� �� GPS"
						);
					}
				}
				else cmd::gps(playerid, "");
			}
			case DIALOG_GPS_JOBS:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof gps_jobs-1)
					{
						EnablePlayerGPS
						(
							playerid,
							gps_jobs[listitem][G_MARKET_TYPE],
							gps_jobs[listitem][G_POS_X],
							gps_jobs[listitem][G_POS_Y],
							gps_jobs[listitem][G_POS_Z],
							"����� �������� � ��� �� GPS"
						);
					}
				}
				else cmd::gps(playerid, "");
			}
			case DIALOG_GPS_BANKS:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof gps_banks-1)
					{
						EnablePlayerGPS
						(
							playerid,
							gps_banks[listitem][G_MARKET_TYPE],
							gps_banks[listitem][G_POS_X],
							gps_banks[listitem][G_POS_Y],
							gps_banks[listitem][G_POS_Z],
							"���� ������� � ��� �� GPS"
						);
					}
				}
				else cmd::gps(playerid, "");
			}
			case DIALOG_GPS_ENTERTAINMENT:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof gps_entertainment-1)
					{
						EnablePlayerGPS
						(
							playerid,
							gps_entertainment[listitem][G_MARKET_TYPE],
							gps_entertainment[listitem][G_POS_X],
							gps_entertainment[listitem][G_POS_Y],
							gps_entertainment[listitem][G_POS_Z],
							"����� �������� � ��� �� GPS"
						);
					}
				}
				else cmd::gps(playerid, "");
			}
			case DIALOG_GPS_BUSINESS:
			{
				if(response)
				{
					if(0 <= listitem <= MAX_BUSINESS_GPS-1)
					{
						new idx = GetPlayerListitemValue(playerid, listitem);
						new businessid = GetBusinessGPSInfo(idx, BG_BIZ_ID);
						
						if(GetBusinessGPSInfo(idx, BG_SQL_ID))
						{
							EnablePlayerGPS
							(
								playerid,								
								56,
								GetBusinessData(businessid, B_POS_X),
								GetBusinessData(businessid, B_POS_Y),
								GetBusinessData(businessid, B_POS_Z),
								"������ ������� � ��� �� GPS"
							);
						}
						else cmd::gps(playerid, "");
					}
				}
				else cmd::gps(playerid, "");
			}
			// -----------------------------------------------------------------
			case DIALOG_HELP:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof help_info - 1)
						ShowPlayerHelpSection(playerid, listitem);
				}
				else DeletePVar(playerid, "help_section");
			}
			case DIALOG_HELP_SECTION:
			{
				new sectionid = GetPVarInt(playerid, "help_section");
				
				if(!response && sectionid < sizeof help_info - 1)
				{
					ShowPlayerHelpSection(playerid, sectionid + 1);
				}
				else cmd::help(playerid, "");
			}
			// -----------------------------------------------------------------
			case DIALOG_SERVER_RADIO:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof g_server_radio - 1)
					{
						PlayAudioStreamForPlayer(playerid, GetServerRadioData(listitem, SR_CHANNEL_URL));

						SetPVarInt(playerid, "server_radio_enabled", 1);
						SendClientMessage(playerid, 0x66CC00FF, "������ ����� ��������");
					}
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_ANIM_LIST:
			{
				if(response)
				{
					if(!SetPlayerAnimation(playerid, listitem))
					{
						Dialog
						(
							playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
							"����������",
							"��� �������� ������� ������ �������� ����� ������������ {FFFFFF}/anim(list) [����� �������� �� ������]",
							"�������", ""
						);
					}
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_OPEN_HOOD_OR_TRUNK:
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				if(vehicleid)
				{
					new E_VEHICLE_PARAMS_STRUCT: param = response ? V_BONNET : V_BOOT;
					new set_status = GetVehicleParam(vehicleid, param) ^ VEHICLE_PARAM_ON;
				
					SetVehicleParam(vehicleid, param, set_status);
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_DRIVING_TUTORIAL_START:
			{
				if(response)
					ShowDrivingTutorialSection(playerid, 0);
			}
			case DIALOG_DRIVING_TUTORIAL:
			{
				new step = GetPVarInt(playerid, "driving_tutorial_step");
				if(response)
				{
					step ++;
				}
				else step --;
				
				if(step >= sizeof driving_tutorial)
				{
					Dialog
					(
						playerid, DIALOG_DRIVING_TUTORIAL_END, DIALOG_STYLE_MSGBOX,
						"{0099FF}����������",
						"{FFFFFF}�������� �� ��� ����������� ������ � ������ ���������� � ����� ��������\n"\
						"���� �� ������������ � ���-����, �� ����������� �� ��������� � ��������� ������ ������ ��� ���!\n\n"\
						"{CC9900}������ ��� ����� �� ��������!\n"\
						"��� ����, ����� ��������� �������� ������� \"�����\"",
						"�����", "�����"
					);
				}
				else if(step < 0)
				{
					ShowPlayerDrivingTutorial(playerid);
				}
				else 
				{
					ShowDrivingTutorialSection(playerid, step);
					
					if(step == 1)
					{
						SpeedometrShowForPlayer(playerid);
					}
					else SpeedometrHideForPlayer(playerid);
				}
			}
			case DIALOG_DRIVING_TUTORIAL_END:
			{
				if(!response)
					ShowDrivingTutorialSection(playerid, sizeof driving_tutorial - 1);
			}
			case DIALOG_DRIVING_EXAM_INFO:
			{
				if(response)
				{
					if(GetPlayerData(playerid, P_DRIVING_LIC) < 1)
					{
						if(GetPlayerMoneyEx(playerid) >= 600) 
						{
							GivePlayerMoneyEx(playerid, -600, "����� �� �����");

							Dialog
							(
								playerid, DIALOG_DRIVING_EXAM_START, DIALOG_STYLE_MSGBOX,
								"{CCCC00}������������� �����",
								"{FFFFFF}��� ����� ���������� 12 �������� ��� �������� ������������� ������\n"\
								"����� ����� ��� ����� �������� ���������� �������� ������� �� 9 �� ���\n"\
								"���� ���������� ������� ����� ������, �� �� �� ������ �������� �� ������������ �����\n\n"\
								"{33CCFF}�� ������ ������ ����� ��������� ��������� ������, ���������� �� ������� ������ ����.\n"\
								"� ���������� �� ������� ����� �������� �� ��� 12 ��������", 
								"�����", "������"
							);
							ClearPlayerDrivingExamInfo(playerid);
						}
						else SendClientMessage(playerid, 0xCECECEFF, "����� �� ����� ����� 600 ������");
					}				
					else SendClientMessage(playerid, 0xCECECEFF, "� ��� ��� ���� �����");
				}
			}
			case DIALOG_DRIVING_EXAM_START:
			{
				if(response)
				{
					SetPlayerDrivingExamInfo(playerid, DE_POINTS, 0);	
					ShowPlayerDrivingExam(playerid, 0);
				}
			}
			case DIALOG_DRIVING_EXAM:
			{
				new step = GetPlayerDrivingExamInfo(playerid, DE_EXAM_STEP);
			
				if(driving_exam[step][DE_CORRECT_ANSWER] == (listitem + 1))
				{
					SetPlayerChatBubble(playerid, "+1", 0xFFFF00FF, 5.0, 2000);
					SetPlayerDrivingExamInfo(playerid, DE_POINTS, GetPlayerDrivingExamInfo(playerid, DE_POINTS) + 1);
				}
				ShowPlayerDrivingExam(playerid, step + 1);
			}
			case DIALOG_DRIVING_EXAM_RESULT:
			{
				if(GetPlayerDrivingExamInfo(playerid, DE_POINTS) >= 9)
				{
					Dialog
					(
						playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
						"{CCCC00}������������ �����",
						"{FFFFFF}�������, ������ ��������� � ������������ �����\n"\
						"��� ����� ����� ������� ���������� �� ������ �� ������� ����\n"\
						"����� ��� ����� �� ������� ����� �� ������\n\n"\
						"{FF9900}��������! ���������� ������������ � �� ���������� ��������\n"\
						"���� �� ��������� ���������� ������� ����� ��������",
						"������", ""
					);
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_ATM:
			{
				if(response)
				{
					switch(listitem+1)
					{
						case 1,2: // �����\�������� � ����������� �����
						{
							ShowPlayerATMSelectSumDialog(playerid, !listitem);
						}
						case 3: // ������ ����������� �����
						{
							new fmt_str[64];
							format(fmt_str, sizeof fmt_str, "{FFFFFF}�� ����� ���������� ����� {%s}%d ���", GetPlayerBankMoney(playerid) > 0 ? ("00CC00") : ("FF6633"), GetPlayerBankMoney(playerid));
							
							Dialog
							(
								playerid, DIALOG_ATM_BALANCE, DIALOG_STYLE_MSGBOX, 
								"{FFCD00}������ �����",
								fmt_str, 
								"�����", "�����"
							);
						}
						case 4: // ����� �� ����� �����������
						{
							ShowPlayerATMCompanyDialog(playerid, true);
						}
						case 5: // �������� �� ���� �����������
						{
							ShowPlayerATMCompanyDialog(playerid, false);
						}
						case 6: // ��������� ��������� �������
						{
							if(GetPlayerPhone(playerid) != 0)
							{
								Dialog
								(
									playerid, DIALOG_ATM_PHONE_BALANCE, DIALOG_STYLE_INPUT, 
									"{FFCD00}���������� ���������� ��������", 
									"{FFFFFF}������� �����, �� ������� ������ ��������� ����:",
									"������", "�����"
								);
							}
							else 
							{
								SendClientMessage(playerid, 0x999999FF, "� ��� ��� ��������. ��� ����� ������ � �������� 24/7");
								ShowPlayerATMDialog(playerid);
							}
						}
						case 7: // ����������� �������
						{
							Dialog
							(
								playerid, DIALOG_ATM_TRANSFER_MONEY_1, DIALOG_STYLE_INPUT, 
								"{FFCD00}����������� �������", 
								"{FFFFFF}������� ����� ����������� �����:", 
								"�����", "������"
							);
						}
						case 8: // �������������������
						{
							ShowPlayerATMCharityDialog(playerid);
						}
						default: 
							return 1;
					}
					ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
				}
			}
			case DIALOG_ATM_TAKE_MONEY: // ����� ������
			{
				if(response)
				{
					if(0 <= listitem <= 6)
					{
						new sum = atm_item_sum[listitem];
						if(GetPlayerBankMoney(playerid) >= sum)
						{
							new query[85];
							format(query, sizeof query, "UPDATE accounts SET money=%d,bank=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid) + sum, GetPlayerBankMoney(playerid) - sum, GetPlayerAccountID(playerid));
							mysql_query(mysql, query, false);
							
							if(!mysql_errno())
							{
								AddPlayerData(playerid, P_BANK, -, sum);
								GivePlayerMoneyEx(playerid, sum, "������ ����� � ���������", false, true);
							}
							else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 08)");
						
							ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
							ShowPlayerATMDialog(playerid);
						}
						else
						{
							SendClientMessage(playerid, 0xCECECEFF, "�� ����� ���������� ����� ������������ �������");
							ShowPlayerATMSelectSumDialog(playerid, true);
						}
					}
					else ShowPlayerATMSelectOtherSum(playerid, true);
				}
				else 
				{
					ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					ShowPlayerATMDialog(playerid);
				}
			}
			case DIALOG_ATM_TAKE_OTHER_MONEY: // ����� ������ (������ ����)
			{
				if(response)
				{
					new take_sum = strval(inputtext);
					if(take_sum > 0 && IsNumeric(inputtext))
					{
						if(GetPlayerBankMoney(playerid) >= take_sum)
						{
							new query[85];
							format(query, sizeof query, "UPDATE accounts SET money=%d,bank=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid) + take_sum, GetPlayerBankMoney(playerid) - take_sum, GetPlayerAccountID(playerid));
							mysql_query(mysql, query, false);
							
							if(!mysql_errno())
							{
								AddPlayerData(playerid, P_BANK, -, take_sum);
								GivePlayerMoneyEx(playerid, take_sum, "������ ����� � ��������� (������ �����)", false, true);
							}
							else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 08)");
						
							ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
							ShowPlayerATMDialog(playerid);
						}
						else
						{
							SendClientMessage(playerid, 0xCECECEFF, "�� ����� ���������� ����� ������������ �������");
							ShowPlayerATMSelectOtherSum(playerid, true);
						}
					}
					else ShowPlayerATMSelectOtherSum(playerid, true);
				}
				else
				{
					ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					ShowPlayerATMSelectSumDialog(playerid, true);
				}
			}
			case DIALOG_ATM_PUT_MONEY: // �������� ������
			{
				if(response)
				{
					if(0 <= listitem <= 6)
					{
						new sum = atm_item_sum[listitem];
						if(GetPlayerMoneyEx(playerid) >= sum)
						{
							new query[85];
							format(query, sizeof query, "UPDATE accounts SET money=%d,bank=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid) - sum, GetPlayerBankMoney(playerid) + sum, GetPlayerAccountID(playerid));
							mysql_query(mysql, query, false);
							
							if(!mysql_errno())
							{
								AddPlayerData(playerid, P_BANK, +, sum);
								GivePlayerMoneyEx(playerid, -sum, "���������� ����� � ���������", false, true);
							}
							else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 08)");
						
							ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
							ShowPlayerATMDialog(playerid);
						}
						else
						{
							SendClientMessage(playerid, 0xCECECEFF, "� ��� � ����� ��� ������� �����");
							ShowPlayerATMSelectSumDialog(playerid, false);
						}
					}
					else ShowPlayerATMSelectOtherSum(playerid, false);
				}
				else 
				{
					ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					ShowPlayerATMDialog(playerid);
				}
			}
			case DIALOG_ATM_PUT_OTHER_MONEY: // �������� ������ (������ ����)
			{
				if(response)
				{
					new put_sum = strval(inputtext);
					if(put_sum > 0 && IsNumeric(inputtext))
					{
						if(GetPlayerMoneyEx(playerid) >= put_sum)
						{
							new query[85];
							format(query, sizeof query, "UPDATE accounts SET money=%d,bank=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid) - put_sum, GetPlayerBankMoney(playerid) + put_sum, GetPlayerAccountID(playerid));
							mysql_query(mysql, query, false);
							
							if(!mysql_errno())
							{
								AddPlayerData(playerid, P_BANK, +, put_sum);
								GivePlayerMoneyEx(playerid, -put_sum, "���������� ����� � ��������� (������ �����)", false, true);
							}
							else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 08)");
						
							ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
							ShowPlayerATMDialog(playerid);
						}
						else
						{
							SendClientMessage(playerid, 0xCECECEFF, "� ��� � ����� ��� ������� �����");
							ShowPlayerATMSelectOtherSum(playerid, false);
						}
					}
					else ShowPlayerATMSelectOtherSum(playerid, false);
				}
				else 
				{
					ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					ShowPlayerATMSelectSumDialog(playerid, false);
				}
			}
			case DIALOG_ATM_BALANCE:
			{
				if(response)
				{
					ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					ShowPlayerATMDialog(playerid);
				}
			}
			case DIALOG_ATM_PHONE_BALANCE:
			{
				if(response)
				{
					new sum = strval(inputtext);
					if(sum > 0 && IsNumeric(inputtext))
					{
						if(GetPlayerMoneyEx(playerid) >= sum)
						{
							new query[128];
							
							format(query, sizeof query, "UPDATE accounts SET money=%d,phone_balance=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-sum, GetPlayerData(playerid, P_PHONE_BALANCE)+sum, GetPlayerAccountID(playerid));
							mysql_query(mysql, query, false);
							
							if(!mysql_errno())
							{
								GivePlayerMoneyEx(playerid, -sum, "���������� ����� ��������", false, true);
								AddPlayerData(playerid, P_PHONE_BALANCE, +, sum);
								
								format(query, sizeof query, "�� ��������� ���� ���������� �������� �� {FF9900}%d ���", sum);
								SendClientMessage(playerid, 0x66CC00FF, query);
								
								format(query, sizeof query, "������ �� ����� %d ���", GetPlayerData(playerid, P_PHONE_BALANCE));
								SendClientMessage(playerid, 0x66CC00FF, query);
								
								return 1;
							}
							else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 15)");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "� ��� �� ������� �����");
						
						ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					}
					
					Dialog
					(
						playerid, DIALOG_ATM_PHONE_BALANCE, DIALOG_STYLE_INPUT, 
						"{FFCD00}���������� ���������� ��������", 
						"{FFFFFF}������� �����, �� ������� ������ ��������� ����:",
						"������", "�����"
					);
				}
				else 
				{
					ShowPlayerATMDialog(playerid);
					ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
				}
			}
			case DIALOG_ATM_SELECT_COMPANY_TAKE, DIALOG_ATM_SELECT_COMPANY_PUT:
			{
				if(response)
				{
					new bool: action = (dialogid == DIALOG_ATM_SELECT_COMPANY_TAKE);
					
					switch(listitem + 1)
					{
						case 1:
							ShowPlayerATMBusinessDialog(playerid, action);
							
						case 2:
							ShowPlayerATMFuelStationDialog(playerid, action);
					}
				}
				else 
				{
					ShowPlayerATMDialog(playerid);
					ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
				}
			}
			case DIALOG_ATM_FUEL_ST_TAKE_MONEY:
			{
				new stationid = GetPlayerFuelStation(playerid);
				if(stationid != -1)
				{
					if(response)
					{
						new sum = strval(inputtext);
						if(sum > 0 && IsNumeric(inputtext))
						{
							if(GetFuelStationData(stationid, FS_BALANCE) >= sum)
							{
								new query[128 + 1];
								
								format(query, sizeof query, "UPDATE accounts a, fuel_stations f SET a.money=%d,f.balance=%d WHERE a.id=%d AND f.id=%d", GetPlayerMoneyEx(playerid)+sum, GetFuelStationData(stationid, FS_BALANCE)-sum, GetPlayerAccountID(playerid), GetFuelStationData(stationid, FS_SQL_ID));
								mysql_query(mysql, query, false);
								
								if(!mysql_errno())
								{
									AddFuelStationData(stationid, FS_BALANCE, -, sum);
									GivePlayerMoneyEx(playerid, sum, "+ ������ ������� �� ����� ���", false, true);
									
									ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
									ShowPlayerATMDialog(playerid);
									return 1;
								}
								else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 18)");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "�� ����� ����������� ��� ����� �����");
						}
						ShowPlayerATMFuelStationDialog(playerid, true);
					}
					else 
					{
						ShowPlayerATMDialog(playerid);
						ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					}
				}
			}
			case DIALOG_ATM_FUEL_ST_PUT_MONEY:
			{
				new stationid = GetPlayerFuelStation(playerid);
				if(stationid != -1)
				{
					if(response)
					{
						new sum = strval(inputtext);
						if(sum > 0 && IsNumeric(inputtext))
						{
							if(GetPlayerMoneyEx(playerid) >= sum)
							{
								new query[128 + 1];
								
								format(query, sizeof query, "UPDATE accounts a, fuel_stations f SET a.money=%d,f.balance=%d WHERE a.id=%d AND f.id=%d", GetPlayerMoneyEx(playerid)-sum, GetFuelStationData(stationid, FS_BALANCE)+sum, GetPlayerAccountID(playerid), GetFuelStationData(stationid, FS_SQL_ID));
								mysql_query(mysql, query, false);
								
								if(!mysql_errno())
								{
									AddFuelStationData(stationid, FS_BALANCE, +, sum);
									GivePlayerMoneyEx(playerid, -sum, "���������� ����� ���", false, true);
									
									ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
									ShowPlayerATMDialog(playerid);
									return 1;
								}
								else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 18)");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "� ��� � ����� ��� ������� �����");
						}
						ShowPlayerATMFuelStationDialog(playerid, false);
					}
					else 
					{
						ShowPlayerATMDialog(playerid);
						ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					}
				}
			}
			case DIALOG_ATM_BIZ_TAKE_MONEY:
			{
				new businessid = GetPlayerBusiness(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						new sum = strval(inputtext);
						if(sum > 0 && IsNumeric(inputtext))
						{
							if(GetBusinessData(businessid, B_BALANCE) >= sum)
							{
								new query[128 + 1];
								
								format(query, sizeof query, "UPDATE accounts a, business b SET a.money=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)+sum, GetBusinessData(businessid, B_BALANCE)-sum, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
								mysql_query(mysql, query, false);
								
								if(!mysql_errno())
								{
									AddBusinessData(businessid, B_BALANCE, -, sum);
									GivePlayerMoneyEx(playerid, sum, "+ ������ ������� �� ����� �������", false, true);
									
									ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
									ShowPlayerATMDialog(playerid);
									
									return 1;
								}
								else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 18)");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "�� ����� ����������� ��� ����� �����");
						}
						ShowPlayerATMBusinessDialog(playerid, true);
					}
					else 
					{
						ShowPlayerATMDialog(playerid);
						ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					}
				}
			}
			case DIALOG_ATM_BIZ_PUT_MONEY:
			{
				new businessid = GetPlayerBusiness(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						new sum = strval(inputtext);
						if(sum > 0 && IsNumeric(inputtext))
						{
							if(GetPlayerMoneyEx(playerid) >= sum)
							{
								new query[128 + 1];
								
								format(query, sizeof query, "UPDATE accounts a, business b SET a.money=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-sum, GetBusinessData(businessid, B_BALANCE)+sum, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
								mysql_query(mysql, query, false);
								
								if(!mysql_errno())
								{
									AddBusinessData(businessid, B_BALANCE, +, sum);
									GivePlayerMoneyEx(playerid, -sum, "���������� ����� �������", false, true);
									
									ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
									ShowPlayerATMDialog(playerid);
									return 1;
								}
								else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 18)");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "� ��� � ����� ��� ������� �����");
						}
						ShowPlayerATMBusinessDialog(playerid, false);
					}
					else 
					{
						ShowPlayerATMDialog(playerid);
						ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					}
				}
			}
			case DIALOG_ATM_TRANSFER_MONEY_1:
			{
				if(response)
				{
					new transfer_id = strval(inputtext);
					
					if(transfer_id > 0 && IsNumeric(inputtext))
					{
						SetPlayerBankTransfer(playerid, BT_ID, 0);
						
						new query[64 + 1];
						new Cache: result;
						
						format(query, sizeof query, "SELECT id FROM bank_accounts WHERE id=%d LIMIT 1", transfer_id);
						result = mysql_query(mysql, query);
						
						if(cache_num_rows())
							SetPlayerBankTransfer(playerid, BT_ID, cache_get_row_int(0, 0));
		
						cache_delete(result);
						
						if(GetPlayerBankTransfer(playerid, BT_ID))
						{
							return ShowPlayerATMTransfer(playerid);
						}
						else SendClientMessage(playerid, 0xFF6600FF, "����� � ����� ������� �� ����������");
					}
					
					Dialog
					(
						playerid, DIALOG_ATM_TRANSFER_MONEY_1, DIALOG_STYLE_INPUT, 
						"{FFCD00}����������� �������", 
						"{FFFFFF}������� ����� ����������� �����:", 
						"�����", "������"
					);
				}
				else ShowPlayerATMDialog(playerid);
			}
			case DIALOG_ATM_TRANSFER_MONEY_2:
			{
				new transfer_id = GetPlayerBankTransfer(playerid, BT_ID);
				if(response && transfer_id)
				{
					new transfer_sum = strval(inputtext);
					if(transfer_sum > 0 && IsNumeric(inputtext))
					{
						if(GetPlayerBankMoney(playerid) >= transfer_sum)
						{
							new fmt_str[155];

							format(fmt_str, sizeof fmt_str, "UPDATE accounts a,bank_accounts ba SET a.bank=%d,ba.balance=ba.balance + %d WHERE a.id=%d AND ba.id=%d", GetPlayerBankMoney(playerid)-transfer_sum, transfer_sum, GetPlayerAccountID(playerid), transfer_id);
							mysql_query(mysql, fmt_str, false);
						
							if(!mysql_errno())
							{
								format(fmt_str, sizeof fmt_str, "+ ���������� � ��������� %d ���", transfer_sum);
								BankAccountLog(playerid, transfer_id, fmt_str);
							
								AddPlayerData(playerid, P_BANK, -, transfer_sum);
								format
								(
									fmt_str, sizeof fmt_str,
									"{FFFFFF}������:\t\t\t�������� ����\n"\
									"����:\t\t\t\t���� �%d\n"\
									"�����:\t\t\t\t%d ���\n"\
									"������� �� ����� �����:\t%d ���",
									transfer_id,
									transfer_sum,
									GetPlayerBankMoney(playerid)
								);
								Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{99FF00}������� ��������", fmt_str, "�������", "");
								
								return PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0);
							}
							else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 11)");
						}
						else SendClientMessage(playerid, 0xFF6600FF, "�� �������� ���������� ����� ������������ �����");
					}
					ShowPlayerATMTransfer(playerid);
				}
				else ShowPlayerATMDialog(playerid); 
			}
			case DIALOG_ATM_CHARITY:
			{
				if(response)
				{
					new put_sum = strval(inputtext);
					if(put_sum > 0 && IsNumeric(inputtext))
					{
						if(GetPlayerMoneyEx(playerid) >= put_sum)
						{
							new fmt_str[85];
							format(fmt_str, sizeof fmt_str, "INSERT INTO charity (uid,money,time) VALUES (%d,%d,%d)", GetPlayerAccountID(playerid), put_sum, gettime());
							mysql_query(mysql, fmt_str, false);
							
							GivePlayerMoneyEx(playerid, -put_sum, "�������������������", true, true);
							
							format(fmt_str, sizeof fmt_str, "�� ������� ������������� � ������� %d ������", put_sum);
							SendClientMessage(playerid, 0x3399FFFF, fmt_str);
							
							UpdateCharity();
						}
						else 
						{
							SendClientMessage(playerid, 0xCECECEFF, "� ��� ������������ �����");
							ShowPlayerATMCharityDialog(playerid);
						}
					}
					else ShowPlayerATMCharityDialog(playerid);
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_PAY_FOR_RENT:
			{
				if(response)
				{
					new buffer = -1;
					switch(listitem + 1)
					{
						case 1: // ��������� �� ���
						{
							buffer = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
							if(buffer != -1)
							{
								ShowPlayerHousePayForRent(playerid);
								return 1;
							}
							else SendClientMessage(playerid, 0x999999FF, "� ��� ��� ����");
						}
						case 2: // �������� ������ �������
						{
							buffer = GetPlayerBusiness(playerid);
							if(buffer != -1)
							{
								ShowPlayerBusinessPayForRent(playerid);
								return 1;
							}
							else SendClientMessage(playerid, 0x999999FF, "� ��� ��� �������");
						}
						case 3: // �������� ������ ���
						{
							buffer = GetPlayerFuelStation(playerid);
							if(buffer != -1)
							{
								ShowPlayerFuelStationPayForRent(playerid);
								return 1;
							}
							else SendClientMessage(playerid, 0x999999FF, "� ��� ��� ��������");
						}
					}
					ShowPlayerPayForRentDialog(playerid);
				}
			}
			case DIALOG_PAY_FOR_RENT_FUEL_ST:
			{
				new stationid = GetPlayerFuelStation(playerid);
				if(stationid != -1)
				{
					if(response)
					{
						new days = strval(inputtext);
						if(days > 0 && IsNumeric(inputtext))
						{
							new fmt_str[128 + 1];
						
							new time = gettime();
							new rent_time = GetFuelStationData(stationid, FS_RENT_DATE);
						
							new rent_days = GetElapsedTime(rent_time, time, CONVERT_TIME_TO_DAYS);
							new rent_price = GetFuelStationData(stationid, FS_IMPROVEMENTS) < 4 ? GetFuelStationData(stationid, FS_RENT_PRICE) : GetFuelStationData(stationid, FS_RENT_PRICE) / 2;
							
							new total_price = rent_price * days;
							if((rent_days + days) <= 30)
							{
								if(GetPlayerBankMoney(playerid) >= total_price)
								{
									rent_time = (rent_time - (rent_time % 86400)) + (days * 86400);
								
									format(fmt_str, sizeof fmt_str, "UPDATE accounts a,fuel_stations f SET a.bank=%d,f.rent_time=%d WHERE a.id=%d AND f.id=%d", GetPlayerBankMoney(playerid)-total_price, rent_time, GetPlayerAccountID(playerid), GetFuelStationData(stationid, FS_SQL_ID));
									mysql_query(mysql, fmt_str, false);
									
									if(!mysql_errno())
									{
										AddPlayerData(playerid, P_BANK, -, total_price);
										SetFuelStationData(stationid, FS_RENT_DATE, rent_time);
									
										format(fmt_str, sizeof fmt_str, "� ����������� ����� ����� {3399FF}%d ���", total_price);
										SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
										
										format(fmt_str, sizeof fmt_str, "�� ������� �������� ������ ��� ��� �� {3399FF}%d ����", days);
										SendClientMessage(playerid, 0x66CC00FF, fmt_str);
									}
								}
								else 
								{
									SendClientMessage(playerid, 0xB5B500FF, "�� �������� ���������� ����� �� ������� ����� ��� ������");
									
									format(fmt_str, sizeof fmt_str, "��� ��������� ������ �� %d ���� ���������� %d ���", days, total_price);
									SendClientMessage(playerid, 0x999999FF, fmt_str);
								}
							}
							else SendClientMessage(playerid, 0xB5B500FF, "�� �� ������ �������� �� ������ ������ ��� �� 30 ����");
						}
						ShowPlayerFuelStationPayForRent(playerid);
					}
					else ShowPlayerPayForRentDialog(playerid);
				}
			}
			case DIALOG_PAY_FOR_RENT_BIZ:
			{
				new businessid = GetPlayerBusiness(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						new days = strval(inputtext);
						if(days > 0 && IsNumeric(inputtext))
						{
							new fmt_str[128 + 1];
						
							new time = gettime();
							new rent_time = GetBusinessData(businessid, B_RENT_DATE);
						
							new rent_days = GetElapsedTime(rent_time, time, CONVERT_TIME_TO_DAYS);
							new rent_price = GetBusinessData(businessid, B_IMPROVEMENTS) < 3 ? GetBusinessData(businessid, B_RENT_PRICE) : GetBusinessData(businessid, B_RENT_PRICE) / 2;
							
							new total_price = rent_price * days;
							if((rent_days + days) <= 30)
							{
								if(GetPlayerBankMoney(playerid) >= total_price)
								{
									rent_time = (rent_time - (rent_time % 86400)) + (days * 86400);
								
									format(fmt_str, sizeof fmt_str, "UPDATE accounts a,business b SET a.bank=%d,b.rent_time=%d WHERE a.id=%d AND b.id=%d", GetPlayerBankMoney(playerid)-total_price, rent_time, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
									mysql_query(mysql, fmt_str, false);
									
									if(!mysql_errno())
									{
										AddPlayerData(playerid, P_BANK, -, total_price);
										SetBusinessData(businessid, B_RENT_DATE, rent_time);
									
										format(fmt_str, sizeof fmt_str, "� ����������� ����� ����� {3399FF}%d ���", total_price);
										SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
										
										format(fmt_str, sizeof fmt_str, "�� ������� �������� ������ ������� ��� �� {3399FF}%d ����", days);
										SendClientMessage(playerid, 0x66CC00FF, fmt_str);
									}
								}
								else 
								{
									SendClientMessage(playerid, 0xB5B500FF, "�� �������� ���������� ����� �� ������� ����� ��� ������");
									
									format(fmt_str, sizeof fmt_str, "��� ��������� ������ �� %d ���� ���������� %d ���", days, total_price);
									SendClientMessage(playerid, 0x999999FF, fmt_str);
								}
							}
							else SendClientMessage(playerid, 0xB5B500FF, "�� �� ������ �������� �� ������ ������ ��� �� 30 ����");
						}
						ShowPlayerBusinessPayForRent(playerid);
					}
					else ShowPlayerPayForRentDialog(playerid);
				}
			}
			case DIALOG_PAY_FOR_RENT_HOUSE:
			{
				new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
				if(houseid != -1)
				{
					if(response)
					{
						new days = strval(inputtext);
						if(days > 0 && IsNumeric(inputtext))
						{
							new fmt_str[128 + 1];
						
							new time = gettime();
							new rent_time = GetHouseData(houseid, H_RENT_DATE);
						
							new rent_days = GetElapsedTime(rent_time, time, CONVERT_TIME_TO_DAYS);
							new rent_price = GetHouseData(houseid, H_IMPROVEMENTS) < 4 ? GetHouseData(houseid, H_RENT_PRICE) : GetHouseData(houseid, H_RENT_PRICE) / 2;
							
							new total_price = rent_price * days;
							if((rent_days + days) <= 30)
							{
								if(GetPlayerBankMoney(playerid) >= total_price)
								{
									rent_time = (rent_time - (rent_time % 86400)) + (days * 86400);
								
									format(fmt_str, sizeof fmt_str, "UPDATE accounts a,houses h SET a.bank=%d,h.rent_time=%d WHERE a.id=%d AND h.id=%d", GetPlayerBankMoney(playerid)-total_price, rent_time, GetPlayerAccountID(playerid), GetHouseData(houseid, H_SQL_ID));
									mysql_query(mysql, fmt_str, false);
									
									if(!mysql_errno())
									{
										AddPlayerData(playerid, P_BANK, -, total_price);
										SetHouseData(houseid, H_RENT_DATE, rent_time);
									
										format(fmt_str, sizeof fmt_str, "� ����������� ����� ����� {3399FF}%d ���", total_price);
										SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
										
										format(fmt_str, sizeof fmt_str, "�� ������� �������� ��� ��� �� {3399FF}%d ����", days);
										SendClientMessage(playerid, 0x66CC00FF, fmt_str);
									}
								}
								else 
								{
									SendClientMessage(playerid, 0xB5B500FF, "�� �������� ���������� ����� �� ������� ����� ��� ������");
									
									format(fmt_str, sizeof fmt_str, "��� ��������� ������ �� %d ���� ���������� %d ���", days, total_price);
									SendClientMessage(playerid, 0x999999FF, fmt_str);
								}
							}
							else SendClientMessage(playerid, 0xB5B500FF, "�� �� ������ �������� �� ������ ������ ��� �� 30 ����");
						}
						ShowPlayerHousePayForRent(playerid);
					}
					else ShowPlayerPayForRentDialog(playerid);
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_BANK:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1: 
						{
							ShowPlayerBankAccounts(playerid);
						}
						case 2:
						{
							Dialog
							(
								playerid, DIALOG_BANK_CREATE_ACCOUNT, DIALOG_STYLE_INPUT,
								"{FFCD00}�������� ������ �����",
								"{FFFFFF}������� �������� ��� ������ �����.\n"\
								"������������ ����� 20 ��������:",
								"��", "������"
							);
						}
					}
				}
			}
			case DIALOG_BANK_ACCOUNTS:
			{
				if(response)
				{
					switch(listitem)
					{
						case 0:
						{
							Dialog
							(
								playerid, DIALOG_ATM, DIALOG_STYLE_LIST,
								"{FFCD00}�������� ����",
								"1. ����� � ����������� �����\n"\
								"2. �������� �� ���������� ����\n"\
								"3. ������ ����������� �����\n"\
								"4. ����� �� ����� �����������\n"\
								"5. �������� �� ���� �����������\n"\
								"6. ��������� ��������� �������\n"\
								"7. ����������� �������\n"\
								"8. �������������������",
								"�������", "�����"
							);
						}
						case 1..(MAX_BANK_ACCOUNTS):
						{
							new accountid = GetPlayerListitemValue(playerid, listitem - 1);
							if(IsValidBankAccount(playerid, accountid))
							{
								SetPlayerUseListitem(playerid, accountid);
								Dialog
								(
									playerid, DIALOG_BANK_ACCOUNT_LOGIN, DIALOG_STYLE_PASSWORD,
									"{FFCD00}�����������",
									"{FFFFFF}������� PIN-��� �����:",
									"������", "������"
								);
							}
						}
					}
				}
				else ShowPlayerBankDialog(playerid);
			}
			case DIALOG_BANK_ACCOUNT_LOGIN:
			{
				if(response)
				{
					new accountid = GetPlayerUseListitem(playerid);
					if(IsValidBankAccount(playerid, accountid))
					{
						new len = strlen(inputtext);
						new pin_len = strlen(GetBankAccountData(playerid, accountid, BA_PIN_CODE));
						if(!strcmp(GetBankAccountData(playerid, accountid, BA_PIN_CODE), inputtext, false) && pin_len && len)
						{
							ShowPlayerBankAccountOperation(playerid);
						}
						else 
						{
							Dialog
							(
								playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
								"{FF9900}������",
								"{FFFFFF}�� ��������� ������ ��� ����� PIN-����",
								"�������", ""
							);
						}
					}
				}
			}
			case DIALOG_BANK_ACCOUNT_OPERATION:
			{
				if(response)
				{
					new accountid = GetPlayerUseListitem(playerid);
					if(IsValidBankAccount(playerid, accountid))
					{
						switch(listitem + 1)
						{
							case 1: // ���������� � �����
							{
								UpdateBankAccountData(playerid, accountid);
								
								new fmt_str[128];
								format
								(
									fmt_str, sizeof fmt_str, 
									"{FFFFFF}����� �����:\t\t%d\n"\
									"������������:\t\"%s\"\n"\
									"������:\t\t{00CC66}%d ���",
									GetBankAccountData(playerid, accountid, BA_ID),
									GetBankAccountData(playerid, accountid, BA_NAME),
									GetBankAccountData(playerid, accountid, BA_BALANCE)
								);
								Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{FFCD00}����������", fmt_str, "���������", "");
							}
							case 2: // ������� ��������
							{
								ShowPlayerBankAccountLog(playerid, GetBankAccountData(playerid, accountid, BA_ID));
							}
							case 3: // ����� ������
							{
								Dialog
								(
									playerid, DIALOG_BANK_ACCOUNT_TAKE_MONEY, DIALOG_STYLE_INPUT,
									"{FFCD00}����� ������",
									"{FFFFFF}������� �����:",
									"�����", "������"
								);
							}
							case 4: // �������� ������
							{
								Dialog
								(
									playerid, DIALOG_BANK_ACCOUNT_PUT_MONEY, DIALOG_STYLE_INPUT,
									"{FFCD00}�������� ������",
									"{FFFFFF}������� �����:",
									"��������", "������"
								);
							}
							case 5: // ��������� �� ������ ����
							{
								Dialog
								(
									playerid, DIALOG_BANK_ACCOUNT_TRANSFER_1, DIALOG_STYLE_INPUT,
									"{FFCD00}������� �������",
									"{FFFFFF}������� ����� �����, �� �������\n"\
									"������ ����������� �������:",
									"�����", "������"
								);
							}
							case 6: // ������������� ����
							{
								Dialog
								(
									playerid, DIALOG_BANK_ACCOUNT_CHANGE_NAME, DIALOG_STYLE_INPUT,
									"{FFCD00}�������������� �����",
									"{FFFFFF}������� ����� �������� ��� ����� �����.\n"\
									"������������ ����� 20 ��������:",
									"��", "������"
								);
							}
							case 7: // �������� PIN-���
							{
								Dialog
								(
									playerid, DIALOG_BANK_ACCOUNT_CHANGE_PIN, DIALOG_STYLE_INPUT,
									"{FFCD00}��������� PIN-����",
									"{FFFFFF}������� ����� PIN-���.\n"\
									"����� �� 4 �� 8 ����:",
									"��", "������"
								);
							}
						}
					}
				}
				else ShowPlayerBankDialog(playerid);
			}
			case DIALOG_BANK_ACCOUNT_INFO:
			{
				ShowPlayerBankAccountOperation(playerid);
			}
			case DIALOG_BANK_ACCOUNT_TAKE_MONEY:
			{
				new accountid = GetPlayerUseListitem(playerid);
				if(response)
				{
					if(IsValidBankAccount(playerid, accountid))
					{
						new take_sum = strval(inputtext);
						if(take_sum > 0 && IsNumeric(inputtext))
						{
							UpdateBankAccountData(playerid, accountid);
							
							new fmt_str[155];
							new balance = GetBankAccountData(playerid, accountid, BA_BALANCE);
							
							if(balance >= take_sum)
							{
								format(fmt_str, sizeof fmt_str, "UPDATE accounts a,bank_accounts ba SET a.money=%d,ba.balance=ba.balance - %d WHERE a.id=%d AND ba.id=%d", GetPlayerMoneyEx(playerid)+take_sum, take_sum, GetPlayerAccountID(playerid), GetBankAccountData(playerid, accountid, BA_ID));
								mysql_query(mysql, fmt_str, false);
								
								if(!mysql_errno())
								{
									GivePlayerMoneyEx(playerid, take_sum, "������ � ����. ����� (����)", false, true);
									SetBankAccountData(playerid, accountid, BA_BALANCE, balance - take_sum);
									
									format(fmt_str, sizeof fmt_str, "- ������ �������� %d ���", take_sum);
									BankAccountLog(playerid, GetBankAccountData(playerid, accountid, BA_ID), fmt_str);
									
									format
									(
										fmt_str, sizeof fmt_str,
										"{FFFFFF}����:\t\t�%d\n"\
										"�� �����:\t{FF9900}%d ���\n"\
										"{FFFFFF}�������:\t%d ���",	
										GetBankAccountData(playerid, accountid, BA_ID),
										take_sum,
										GetBankAccountData(playerid, accountid, BA_BALANCE)
									);
									return Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{3399FF}�������� ��������� �������", fmt_str, "���������", "");
								}
								else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 09)");
							}
							else 
							{
								format(fmt_str, sizeof fmt_str, "������������ �������. ������� ������ ����� �%d: {009966}%d ���", GetBankAccountData(playerid, accountid, BA_ID), balance);
								SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
							}
						}
						
						Dialog
						(
							playerid, DIALOG_BANK_ACCOUNT_TAKE_MONEY, DIALOG_STYLE_INPUT,
							"{FFCD00}����� ������",
							"{FFFFFF}������� �����:",
							"�����", "������"
						);
					}
				}
				else ShowPlayerBankAccountOperation(playerid);
			}
			case DIALOG_BANK_ACCOUNT_PUT_MONEY:
			{
				new accountid = GetPlayerUseListitem(playerid);
				if(response)
				{
					if(IsValidBankAccount(playerid, accountid))
					{
						new put_sum = strval(inputtext);
						if(put_sum > 0 && IsNumeric(inputtext))
						{
							UpdateBankAccountData(playerid, accountid);
							
							new fmt_str[155];
							new money = GetPlayerMoneyEx(playerid);
							new balance = GetBankAccountData(playerid, accountid, BA_BALANCE);
							
							if(money >= put_sum)
							{
								format(fmt_str, sizeof fmt_str, "UPDATE accounts a,bank_accounts ba SET a.money=%d,ba.balance=ba.balance + %d WHERE a.id=%d AND ba.id=%d", money-put_sum, put_sum, GetPlayerAccountID(playerid), GetBankAccountData(playerid, accountid, BA_ID));
								mysql_query(mysql, fmt_str, false);
								
								if(!mysql_errno())
								{
									GivePlayerMoneyEx(playerid, -put_sum, "���������� ����. ����� (����)", false, true);
									SetBankAccountData(playerid, accountid, BA_BALANCE, balance + put_sum);
									
									format(fmt_str, sizeof fmt_str, "+ ���������� �� ����� %d ���", put_sum);
									BankAccountLog(playerid, GetBankAccountData(playerid, accountid, BA_ID), fmt_str);
									
									format
									(
										fmt_str, sizeof fmt_str,
										"{FFFFFF}����:\t\t\t�%d\n"\
										"�� ��������:\t{00CC00}%d ���\n"\
										"{FFFFFF}�������� ������:\t%d ���",	
										GetBankAccountData(playerid, accountid, BA_ID),
										put_sum,
										GetBankAccountData(playerid, accountid, BA_BALANCE)
									);
									return Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{3399FF}�������� ��������� �������", fmt_str, "���������", "");
								}
								else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 09)");
							}
							else SendClientMessage(playerid, 0xFFFFFFFF, "������������ �������");
						}
						
						Dialog
						(
							playerid, DIALOG_BANK_ACCOUNT_PUT_MONEY, DIALOG_STYLE_INPUT,
							"{FFCD00}�������� ������",
							"{FFFFFF}������� �����:",
							"��������", "������"
						);
					}
				}
				else ShowPlayerBankAccountOperation(playerid);
			}
			case DIALOG_BANK_ACCOUNT_TRANSFER_1:
			{
				new accountid = GetPlayerUseListitem(playerid);
				if(response)
				{
					if(IsValidBankAccount(playerid, accountid))
					{
						new transfer_id = strval(inputtext);
						if(transfer_id > 0 && IsNumeric(inputtext))
						{
							new fmt_str[64 + 1];
							new Cache: result;
							new rows;
							
							format(fmt_str, sizeof fmt_str, "SELECT id,name FROM bank_accounts WHERE id=%d LIMIT 1", transfer_id);
							result = mysql_query(mysql, fmt_str);
							
							if((rows = cache_num_rows()))
							{
								SetPlayerBankTransfer(playerid, BT_ID, cache_get_row_int(0, 0));
								cache_get_row(0, 1, g_player_bank_transfer[playerid][BT_NAME], mysql, 21);
							}
							cache_delete(result);
							
							if(rows)
							{
								return ShowPlayerBankAccountTransfer(playerid, accountid);
							}
							else SendClientMessage(playerid, 0xFF6600FF, "����� � ����� ������� �� ����������");
						}
					
						Dialog
						(
							playerid, DIALOG_BANK_ACCOUNT_TRANSFER_1, DIALOG_STYLE_INPUT,
							"{FFCD00}������� �������",
							"{FFFFFF}������� ����� �����, �� �������\n"\
							"������ ����������� �������:",
							"�����", "������"
						);
					}
				}
				else ShowPlayerBankAccountOperation(playerid);
			}
			case DIALOG_BANK_ACCOUNT_TRANSFER_2:
			{
				new accountid = GetPlayerUseListitem(playerid);
				if(response)
				{
					if(IsValidBankAccount(playerid, accountid))
					{
						new transfer_sum = strval(inputtext);
						new transfer_id = GetPlayerBankTransfer(playerid, BT_ID);
						
						if(transfer_sum > 0 && IsNumeric(inputtext))
						{
							UpdateBankAccountData(playerid, accountid);
							
							new balance = GetBankAccountData(playerid, accountid, BA_BALANCE);
							if(balance >= transfer_sum)
							{
								new fmt_str[160];
								
								if(GetBankAccountData(playerid, accountid, BA_ID) != transfer_id)
								{
									format(fmt_str, sizeof fmt_str, "UPDATE bank_accounts SET balance=balance-%d WHERE id=%d LIMIT 1", transfer_sum, GetBankAccountData(playerid, accountid, BA_ID));
									mysql_query(mysql, fmt_str, false);
									
									format(fmt_str, sizeof fmt_str, "UPDATE bank_accounts SET balance=balance+%d WHERE id=%d LIMIT 1", transfer_sum, transfer_id);
									mysql_query(mysql, fmt_str, false);
									
									SetBankAccountData(playerid, accountid, BA_BALANCE, balance - transfer_sum);
								}
								format(fmt_str, sizeof fmt_str, "- ������� %d ��� �� ���� �%d", transfer_sum, transfer_id);
								BankAccountLog(playerid, GetBankAccountData(playerid, accountid, BA_ID), fmt_str);
								
								format(fmt_str, sizeof fmt_str, "+ ������� %d ��� �� ����� �%d", transfer_sum, GetBankAccountData(playerid, accountid, BA_ID));
								BankAccountLog(playerid, transfer_id, fmt_str);
			
								SetPlayerBankTransfer(playerid, BT_ID, 0);
								
								format
								(
									fmt_str, sizeof fmt_str,
									"{FFFFFF}�� �����:\t\t\t�%d\n"\
									"�� ����:\t\t\t�%d\n"\
									"C���� ��������:\t\t{FF9900}%d ���\n"\
									"{FFFFFF}������� �� ����� �����:\t{00CC66}%d ���",
									GetBankAccountData(playerid, accountid, BA_ID),
									transfer_id,
									transfer_sum,
									GetBankAccountData(playerid, accountid, BA_BALANCE)
								);
								Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{3399FF}������� ������� ��������", fmt_str, "���������", "");
							}
							else 
							{
								SendClientMessage(playerid, 0xFF6600FF, "�� ����� ������������ ������� ��� ��������");
								ShowPlayerBankAccountTransfer(playerid, accountid);
							}
						}
						else ShowPlayerBankAccountTransfer(playerid, accountid);
					}
				}
				else ShowPlayerBankAccountOperation(playerid);
			}
			case DIALOG_BANK_ACCOUNT_CHANGE_NAME:
			{
				new accountid = GetPlayerUseListitem(playerid);
				if(response)
				{
					if(IsValidBankAccount(playerid, accountid))
					{
						new len = strlen(inputtext);
						
						if(3 <= len <= 20)
						{
							if(!IsABadBankAccountName(inputtext))
							{
								new fmt_str[128];
								
								mysql_format(mysql, fmt_str, sizeof fmt_str, "UPDATE bank_accounts SET name='%e' WHERE id=%d LIMIT 1", inputtext, GetBankAccountData(playerid, accountid, BA_ID));
								mysql_query(mysql, fmt_str, false);
								
								if(!mysql_errno())
								{
									format(g_bank_account[playerid][accountid][BA_NAME], 21, "%s", inputtext);
									
									format(fmt_str, sizeof fmt_str, "* �������������� ����� �� \"%s\"", inputtext);
									BankAccountLog(playerid, GetBankAccountData(playerid, accountid, BA_ID), fmt_str);
									
									format
									(
										fmt_str, sizeof fmt_str,
										"{FFFFFF}���� ������� ������������.\n"\
										"������ �� ����� �������� ��� ��������� \"%s\"",
										GetBankAccountData(playerid, accountid, BA_NAME)
									);
									return Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{FFCD00}����������", fmt_str, "���������", "");
								}
								else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 10)");
							}
							else 
							{
								SendClientMessage(playerid, 0xFF6600FF, "������������ ������� � ����� ��������");
								SendClientMessage(playerid, 0xFF6600FF, "����� ������������ {FFCC15}������� {FF6600}� {FFCC15}���������� {FF6600}�����, � ����� {FFCC15}�����");
							}
						}
						else SendClientMessage(playerid, 0xFF6600FF, "����� �������� ����� ����� ���� �� {FFCC15}3 �� 20 {FF6600}��������");
						
						Dialog
						(
							playerid, DIALOG_BANK_ACCOUNT_CHANGE_NAME, DIALOG_STYLE_INPUT,
							"{FFCD00}�������������� �����",
							"{FFFFFF}������� ����� �������� ��� ����� �����.\n"\
							"������������ ����� 20 ��������:",
							"��", "������"
						);
					}
				}
				else ShowPlayerBankAccountOperation(playerid);
			}
			case DIALOG_BANK_ACCOUNT_CHANGE_PIN:
			{
				new accountid = GetPlayerUseListitem(playerid);
				if(response)
				{
					if(IsValidBankAccount(playerid, accountid))
					{
						new len = strlen(inputtext);
						
						if(4 <= len <= 8 && IsNumeric(inputtext))
						{
							new fmt_str[128];
					
							mysql_format(mysql, fmt_str, sizeof fmt_str, "UPDATE bank_accounts SET pin='%e' WHERE id=%d LIMIT 1", inputtext, GetBankAccountData(playerid, accountid, BA_ID));
							mysql_query(mysql, fmt_str, false);
						
							if(!mysql_errno())
							{
								format(g_bank_account[playerid][accountid][BA_PIN_CODE], 9, "%s", inputtext);
								BankAccountLog(playerid, GetBankAccountData(playerid, accountid, BA_ID), "* ��������� PIN-����");
								
								format
								(
									fmt_str, sizeof fmt_str,
									"{FFFFFF}PIN-��� ������� �������.\n"\
									"����������� ������� ����� (F8) ����� �� ������ ���: {CCFF00}%s",
									GetBankAccountData(playerid, accountid, BA_PIN_CODE)
								);
								return Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{FFCD00}��������� PIN", fmt_str, "���������", "");
							}
							else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 10)");
						}
						
						Dialog
						(
							playerid, DIALOG_BANK_ACCOUNT_CHANGE_PIN, DIALOG_STYLE_INPUT,
							"{FFCD00}��������� PIN-����",
							"{FFFFFF}������� ����� PIN-���.\n"\
							"����� �� 4 �� 8 ����:",
							"��", "������"
						);
					}
				}
				else ShowPlayerBankAccountOperation(playerid);
			}
			case DIALOG_BANK_CREATE_ACCOUNT:
			{
				if(response)
				{
					new len = strlen(inputtext);
					if(3 <= len <= 20)
					{
						if(!IsABadBankAccountName(inputtext))
						{
							new query[128];
							new Cache: result;
							new total_accounts;
							
							format(query, sizeof query, "SELECT COUNT(*) FROM bank_accounts WHERE uid=%d", GetPlayerAccountID(playerid));
							result = mysql_query(mysql, query);
							
							total_accounts = cache_get_row_int(0, 0);
							cache_delete(result);
							
							if(total_accounts < MAX_BANK_ACCOUNTS)
							{
								mysql_format(mysql, query, sizeof query, "INSERT INTO bank_accounts (uid,name,reg_time) VALUES (%d,'%e',%d)", GetPlayerAccountID(playerid), inputtext, gettime());
								mysql_query(mysql, query, false);
								
								if(!mysql_errno())
								{
									Dialog
									(
										playerid, DIALOG_BANK_CREATED_ACCOUNT, DIALOG_STYLE_MSGBOX, 
										"{FFCD00}���� ������",
										"{FFFFFF}�� ������� ����� ���� � �����.\n\n"\
										"��� ������� � ���� ����������� PIN-��� {00FF66}0000{FFFFFF}. ����� �����\n"\
										"������������ ����������� �������� ��� �� ����� �������.\n"\
										"��� ������� �������� ���� �� �������������������� �������.",
										"������", ""
									);
								}
							}
							else Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FFCD00}����� ������", "{FFFFFF}����� ������� �� ����� ������ ���������� ������", "��", "");
						}
						else 
						{
							Dialog
							(
								playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
								"{FF3300}������",
								"{FFFFFF}�������� ���������. ������������ ������� � �������� �����\n"\
								"����� ������������ {FFCC15}������� {FFFFFF}� {FFCC15}���������� {FFFFFF}�����, � ����� {FFCC15}�����",
								"�����", ""
							);
						}
					}
					else 
					{
						Dialog
						(
							playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
							"{FF3300}������",
							"{FFFFFF}����� �������� ����� ����� ���� �� {FFCC15}3 �� 20 {FFFFFF}��������",
							"�������", ""
						);
					}
				}
				else ShowPlayerBankDialog(playerid);
			}
			case DIALOG_BANK_CREATED_ACCOUNT:
			{
				ShowPlayerBankDialog(playerid);
			}
			// -----------------------------------------------------------------
			case DIALOG_PHONE_CALL:
			{
				if(response)
				{
					new number = strval(inputtext);
					
					if(number >= 0 && strlen(inputtext))
					{
						new params[16];
						valstr(params, number);
						
						cmd::c(playerid, params);				
					}
					else SendClientMessage(playerid, 0xCECECEFF, "������ ������");
				}
			}
			case DIALOG_PHONE_CALL_BALANCE:
			{
				SetPlayerPhoneUseState(playerid, false);
			}
			// -----------------------------------------------------------------
			case DIALOG_ACTION:
			{
				if(response)
				{
					if(1 <= (listitem+1) <= 3)
					{
						new targetid = GetPlayerData(playerid, P_TARGET_ID);
						
						if(IsPlayerConnected(targetid) && IsPlayerLogged(targetid)) 
						{
							if(IsPlayerInRangeOfPlayer(playerid, targetid, 10.0)) 
							{
								new params[5];
								valstr(params, targetid);
								
								new cmd[3][16] = {"cmd_hi", "cmd_pass", "cmd_lic"};
								CallLocalFunction(cmd[listitem], "ds", playerid, params);
							}
							else SendClientMessage(playerid, 0x999999FF, "����� ��������� ������� ������");
						}
						else SendClientMessage(playerid, 0x999999FF, "����� ����� �� ����");
					}
					SetPlayerData(playerid, P_TARGET_ID, INVALID_PLAYER_ID);
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_VIEV_JOBS_LIST:
			{
				if(response)
				{
					Dialog
					(
						playerid, DIALOG_JOIN_TO_JOB, DIALOG_STYLE_LIST,
						"{FFCD00}������ ��������� �����", 
						"1. �������� ��������\t\t\t{0099FF}2 ���\n"\
						"2. �������\t\t\t\t{0099FF}3 ���\n"\
						"3. ������������\t\t\t{0099FF}4 ���\n"\
						"4. ������������\t\t\t{0099FF}4 ���",
						
						/*
						"5. ������� ��������\t\t\t{0099FF}6 ���\n"\
						"6. ��������� ���\t\t\t{0099FF}7 ���",
						*/
						"�������", "������"
					);
				}
			}
			case DIALOG_JOIN_TO_JOB:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case JOB_BUS_DRIVER:
						{
							if(GetPlayerLevel(playerid) < 2) 
								return SendClientMessage(playerid, 0xCECECEFF, "����� ���������� �� ������ �������� �������� ��������� 2 �������");
						
							SendClientMessage(playerid, 0xFFFF00FF, "�����������! {66CC00}�� ���������� �� ������ �������� ��������");
							SendClientMessage(playerid, 0xFFFFFFFF, "������� ��������� ��������� �� ���� ������������. ����������� {0099FF}/gps {FFFFFF}����� ����� ��������� � ���");
						}
						case JOB_TAXI_DRIVER:
						{
							if(GetPlayerLevel(playerid) < 3) 
								return SendClientMessage(playerid, 0xCECECEFF, "����� ���������� �� ������ �������� ����� ��������� 3 �������");
						
							SendClientMessage(playerid, 0xFFFF00FF, "�����������! {66CC00}�� ���������� �� ������ ��������");
							SendClientMessage(playerid, 0xFFFFFFFF, "������� ����� ����� ����� ����� �����������, �� �������� � ������ ������ ������");
						}
						case JOB_MECHANIC:
						{
							if(GetPlayerLevel(playerid) < 4) 
								return SendClientMessage(playerid, 0xCECECEFF, "����� ���������� �� ������ ������������ ��������� 4 �������");
						
							SendClientMessage(playerid, 0xFFFF00FF, "�����������! {66CC00}�� ���������� �� ������ ������������");
							SendClientMessage(playerid, 0xFFFFFFFF, "����� ������ ������ ������� ��������� ��������� � ����� ������. ����������� {FF9900}/gps {FFFFFF}��� �������������");
							SendClientMessage(playerid, 0xFFFFFFFF, "�������: /getfuel - �������� �������; /fill - ��������� ���������; /repair - �������� ���������");
						}
						case JOB_TRUCKER:
						{
							if(GetPlayerLevel(playerid) < 4) 
								return SendClientMessage(playerid, 0xCECECEFF, "����� ���������� �� ������ ������������� ��������� 4 �������");
						
							SendClientMessage(playerid, 0xFFFF00FF, "�����������! {66CC00}�� ���������� �� ������ �������������");
							SendClientMessage(playerid, 0xFFFFFFFF, "����������� {FF9900}/gps {FFFFFF}����� ����� ������� ���������� ��� �����������");
							SendClientMessage(playerid, 0xFFFFFFFF, "�������������� ���������� � �������� �� ������ �������� � �������� ������");
						}
						default:
							return 1;
					}
					new query[64];
					
					format(query, sizeof query, "UPDATE accounts SET job=%d WHERE id=%d LIMIT 1", listitem + 1, GetPlayerAccountID(playerid));
					mysql_query(mysql, query, false);
					
					if(!mysql_errno())
					{
						SetPlayerData(playerid, P_JOB, listitem + 1);
					}
					else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 14)");
				}
			}
			case DIALOG_END_JOB:
			{
				if(response)
					EndPlayerJob(playerid);
			}
			case DIALOG_BUS_RENT_CAR:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					
					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);
					
					if(action_type == VEHICLE_ACTION_TYPE_BUS_DRIVER && action_id == VEHICLE_ACTION_ID_NONE)
					{
						if(GetPlayerMoneyEx(playerid) >= 180)
						{
							GivePlayerMoneyEx(playerid, -180, "������ ��������", true, true);
							//SetVehicleData(vehicleid, V_ACTION_ID, true);
							
							SetPlayerData(playerid, P_JOB_CAR, vehicleid);
							return SendClientMessage(playerid, 0x66CC00FF, "��� ����, ����� ������ ������ �������� �������� {FF9900}������� ~k~~TOGGLE_SUBMISSIONS~");
						}
						else SendClientMessage(playerid, 0x999999FF, "� ��� ������������ ����� ����� ��������� ������� ������");
					}
				}
				RemovePlayerFromVehicle(playerid);
			}
			case DIALOG_BUS_ROUTE_COST:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					
					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

					if(action_type == VEHICLE_ACTION_TYPE_BUS_DRIVER && action_id == VEHICLE_ACTION_ID_NONE)
					{
						new route_cost = strval(inputtext);
					
						if(0 <= route_cost <= 100 && IsNumeric(inputtext))
						{
							SetPlayerData(playerid, P_JOB_TARIFF, route_cost);
							
							Dialog
							(
								playerid, DIALOG_BUS_ROUTE_SELECTION, DIALOG_STYLE_LIST, 
								"{FFCD00}�������� �������", 
								g_bus_routes_list,
								"��", "������"
							);
						}
						else 
						{
							Dialog
							(
								playerid, DIALOG_BUS_ROUTE_COST, DIALOG_STYLE_INPUT, 
								"{FFCD00}��������� �������", 
								"{FFFFFF}������� ����� ������ ������?\n"\
								"������� ���� �� 0 �� 100 ������", 
								"�����", "������"
							);
						}
					}
				}
			}
			case DIALOG_BUS_ROUTE_SELECTION:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					
					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

					if(action_type == VEHICLE_ACTION_TYPE_BUS_DRIVER && action_id == VEHICLE_ACTION_ID_NONE)
					{
						if(0 <= listitem <= sizeof g_bus_routes - 1)
						{
							SetPlayerData(playerid, P_BUS_ROUTE_STEP, 0);
							SetPlayerData(playerid, P_BUS_ROUTE, listitem);
				
							StartPlayerJob(playerid, JOB_BUS_DRIVER);
						}
					}
				}
			}
			case DIALOG_TAXI_RENT_CAR:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					
					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);
					
					if(action_type == VEHICLE_ACTION_TYPE_TAXI_DRIVER && action_id == VEHICLE_ACTION_ID_NONE)
					{
						if(GetPlayerMoneyEx(playerid) >= 200)
						{
							GivePlayerMoneyEx(playerid, -200, "������ �����", true, true);
							//SetVehicleData(vehicleid, V_ACTION_ID, true);
							
							SetPlayerData(playerid, P_JOB_CAR, vehicleid);
							return SendClientMessage(playerid, 0x66CC00FF, "��� ����, ����� ������ ������ �������� {FF9900}������� ~k~~TOGGLE_SUBMISSIONS~");
						}
						else SendClientMessage(playerid, 0x999999FF, "� ��� ������������ ����� ����� ��������� ������� ������");
					}
				}
				RemovePlayerFromVehicle(playerid);
			}
			case DIALOG_TAXI_NAME:
			{
				if(response)
				{
					if(!(1 <= strlen(inputtext) <= 15))
					{
						Dialog
						(
							playerid, DIALOG_TAXI_NAME, DIALOG_STYLE_INPUT, 
							"{FFCD00}�������� �����", 
							"{FFFFFF}���������� �������� ��� ������ �����\n"\
							"������������ ����� 15 ��������\n\n"\
							"���� �� �� ������ ���-�� ����������\n"\
							"������� ������ \"����������\"",
							"�����", "����������"
						);
						return 1;
					}
					else format(g_player[playerid][P_JOB_SERVICE_NAME], 17, "%s\n", inputtext);
				}
				else g_player[playerid][P_JOB_SERVICE_NAME][0] = 0;
				
				Dialog
				(
					playerid, DIALOG_TAXI_TARIFF, DIALOG_STYLE_INPUT, 
					"{FFCD00}��������� ��������", 
					"{FFFFFF}������� ����� �� �������� ����� �������� ���� �����\n"\
					"��� ����� ����� ��������� � ��������� ������ 100 � �������\n"\
					"�������� ������ ����� ���� �� 0 �� 200 ������", 
					"��", "������"
				);
			}
			case DIALOG_TAXI_TARIFF:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					
					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);
					
					if(action_type == VEHICLE_ACTION_TYPE_TAXI_DRIVER && action_id == VEHICLE_ACTION_ID_NONE)
					{
						new tariff = strval(inputtext);
						
						if(!(0 <= tariff <= 200) || !IsNumeric(inputtext))
						{
							Dialog
							(
								playerid, DIALOG_TAXI_TARIFF, DIALOG_STYLE_INPUT, 
								"{FFCD00}��������� ��������", 
								"{FFFFFF}������� ����� �� �������� ����� �������� ���� �����\n"\
								"��� ����� ����� ��������� � ��������� ������ 100 � �������\n"\
								"�������� ������ ����� ���� �� 0 �� 200 ������", 
								"��", "������"
							);
							return 1;
						}
						else 
						{
							SetPlayerData(playerid, P_JOB_TARIFF, tariff);
							StartPlayerJob(playerid, JOB_TAXI_DRIVER);
						}
					}
				}
				g_player[playerid][P_JOB_SERVICE_NAME][0] = 0;
			}
			case DIALOG_MECHANIC_RENT_CAR:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					
					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);
					
					if(action_type == VEHICLE_ACTION_TYPE_MECHANIC && action_id == VEHICLE_ACTION_ID_NONE)
					{
						if(GetPlayerMoneyEx(playerid) >= 180)
						{
							GivePlayerMoneyEx(playerid, -180, "������ ����������", true, true);
							//SetVehicleData(vehicleid, V_ACTION_ID, true);
							
							SetPlayerData(playerid, P_JOB_CAR, vehicleid);
							return SendClientMessage(playerid, 0x66CC00FF, "��� ����, ����� ������ ������ ������������ {FF9900}������� ~k~~TOGGLE_SUBMISSIONS~");
						}
						else SendClientMessage(playerid, 0x999999FF, "� ��� ������������ ����� ����� ��������� ������� ������");
					}
				}
				RemovePlayerFromVehicle(playerid);
			}
			case DIALOG_MECHANIC_START_JOB:
			{
				if(response)
				{	
					new vehicleid = GetPlayerVehicleID(playerid);
					
					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);
					
					if(action_type == VEHICLE_ACTION_TYPE_MECHANIC && action_id == VEHICLE_ACTION_ID_NONE)
					{
						Dialog
						(
							playerid, DIALOG_MECHANIC_NAME, DIALOG_STYLE_INPUT,
							"{FFCD00}�����������", 
							"{FFFFFF}������� �������� ��� ����� ���������,\n"\
							"��� �������� ���� ������", 
							"������", "������"
						);	
					}					
				}
			}
			case DIALOG_MECHANIC_NAME:
			{
				if(response)
				{
					new len = strlen(inputtext);
					
					if(len)
					{
						if(!(1 <= len <= 15))
						{
							Dialog
							(
								playerid, DIALOG_MECHANIC_NAME, DIALOG_STYLE_INPUT,
								"{FFCD00}�����������", 
								"{FFFFFF}������� �������� ��� ����� ���������,\n"\
								"��� �������� ���� ������", 
								"������", "������"
							);	
							return SendClientMessage(playerid, 0xCECECEFF, "������� ������� �������� | 15 �������� ��������");
						}
						else format(g_player[playerid][P_JOB_SERVICE_NAME], 17, "%s\n", inputtext);
					}
					else g_player[playerid][P_JOB_SERVICE_NAME][0] = 0;

					StartPlayerJob(playerid, JOB_MECHANIC);
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_PHONE_BOOK:
			{
				if(response && (0 <= listitem <= MAX_PHONE_BOOK_CONTACTS-1))
				{
					ShowPhoneBookOperation(playerid, PHONE_BOOK_OPERATION_OPTIONS, listitem);
				}
			}
			case DIALOG_PHONE_BOOK_OPTION:
			{
				new contactid = GetPlayerPhoneBookSelectContact(playerid);
				if(contactid != INVALID_PLAYER_ID)
				{
					if(response)
					{
						ShowPhoneBookOperation(playerid, listitem + 1, contactid);
					}
					else ShowPlayerPhoneBook(playerid);
				}
			}
			case DIALOG_PHONE_BOOK_SEND_SMS:
			{
				if(response) 
				{
					new len = strlen(inputtext);
					if(len)
					{
						if(len < 65)
						{
							new contactid = GetPlayerPhoneBookSelectContact(playerid);
							new fmt_str[90];

							format(fmt_str, sizeof fmt_str, "%s %s", GetPlayerPhoneBook(playerid, contactid, PB_NUMBER), inputtext);
							cmd::sms(playerid, fmt_str);
							return 1;
						}
						else SendClientMessage(playerid, 0xCECECEFF, "������� ������� ���������");
					}
					else SendClientMessage(playerid, 0xCECECEFF, "������� ��������� ��� ��������");
					
					ShowPhoneBookOperation(playerid, PHONE_BOOK_OPERATION_SEND_SMS);
				}
				else ShowPhoneBookOperation(playerid, PHONE_BOOK_OPERATION_OPTIONS);
			}
			case DIALOG_PHONE_BOOK_CHANGE_NAME:
			{
				if(response) 
				{
					if(3 <= strlen(inputtext) <= 20)
					{
						new contactid = GetPlayerPhoneBookSelectContact(playerid);
						new query[90];
						
						format(g_player_phone_book[playerid][contactid][PB_NAME], 21, "%s", inputtext);

						mysql_format(mysql, query, sizeof query, "UPDATE phone_books SET name='%e' WHERE id=%d LIMIT 1", inputtext, GetPlayerPhoneBook(playerid, contactid, PB_SQL_ID));
						mysql_query(mysql, query, false);
					
						SendClientMessage(playerid, 0x99CC33FF, "��� �������� ��������");
						ShowPlayerPhoneBook(playerid);
					}
					else ShowPhoneBookOperation(playerid, PHONE_BOOK_OPERATION_CHANGE_NAM);				
				}
				else ShowPhoneBookOperation(playerid, PHONE_BOOK_OPERATION_OPTIONS);
			}
			case DIALOG_PHONE_BOOK_CHANGE_NUMBER:
			{
				if(response) 
				{
					if(3 <= strlen(inputtext) <= 9 && strval(inputtext) > 0 && IsNumeric(inputtext)) 
					{
						if(!CheckPhoneBookUsedNumber(playerid, inputtext))
						{
							new contactid = GetPlayerPhoneBookSelectContact(playerid);
							new query[90];
							
							format(g_player_phone_book[playerid][contactid][PB_NUMBER], 10, "%s", inputtext);

							mysql_format(mysql, query, sizeof query, "UPDATE phone_books SET number='%e' WHERE id=%d LIMIT 1", inputtext, GetPlayerPhoneBook(playerid, contactid, PB_SQL_ID));
							mysql_query(mysql, query, false);
						
							SendClientMessage(playerid, 0x99CC33FF, "����� �������� �������");
							ShowPlayerPhoneBook(playerid);
						}		
					}
					else ShowPhoneBookOperation(playerid, PHONE_BOOK_OPERATION_CHANGE_NUM);
				}
				else ShowPhoneBookOperation(playerid, PHONE_BOOK_OPERATION_OPTIONS);
			}
			case DIALOG_PHONE_BOOK_ADD_CONTACT:
			{
				if(response)
				{
					new player_name[20 + 1];
					GetPVarString(playerid, "add_contact_name", player_name, sizeof(player_name));
					
					if(!(3 <= strlen(inputtext) <= 9) || strval(inputtext) < 1 || !IsNumeric(inputtext))
					{
						new fmt_str[64 + 1];
						
						format(fmt_str, sizeof fmt_str, "{FFFFFF}������� ����� �������� ��� �������� %s", player_name);
						Dialog(playerid, DIALOG_PHONE_BOOK_ADD_CONTACT, DIALOG_STYLE_INPUT, "{FFCD00}���������� ������ ��������", fmt_str, "��������", "������");
						
						return 1;
					}
					AddPhoneBookContact(playerid, player_name, inputtext);
				}
				DeletePVar(playerid, "add_contact_name");
			}
			// -----------------------------------------------------------------
			case DIALOG_MINER_BUY_METALL:
			{
				if(response)
				{
					new count = strval(inputtext);
					new metall = GetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL, R_AMOUNT);
					
					if(IsNumeric(inputtext))
					{
						if(metall >= count)
						{
							if(1 <= count <= 50)
							{	
								if((GetPlayerData(playerid, P_METALL) + count) <= 20) 
								{
									new sum = count * 15;
									if(GetPlayerMoneyEx(playerid) >= sum)
									{
										new fmt_str[80];
										
										format(fmt_str, sizeof fmt_str, "UPDATE accounts SET money=%d,metall=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-sum, GetPlayerData(playerid, P_METALL) + count, GetPlayerAccountID(playerid));
										mysql_query(mysql, fmt_str, false);
										
										if(!mysql_errno())
										{
											SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL, R_AMOUNT, metall - count);
											UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL);
										
											AddPlayerData(playerid, P_METALL, +, count);
										
											format(fmt_str, sizeof fmt_str, "�� ������ %d �� �� %d ������", count, count * 15);
											SendClientMessage(playerid, 0x3399FFFF, fmt_str);

											return GivePlayerMoneyEx(playerid, -sum, "������� ������� �� �����", false, true);
										}
										else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 12)");
									}
									else SendClientMessage(playerid, 0xCECECEFF, "������������ ����� ��� ������� ������ ���������� �������");
								}
								else SendClientMessage(playerid, 0xCECECEFF, "�� �� ������ ������ � ����� ����� 20 �� �������");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "����� ������ �� 1 �� 50 �� �������");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "�� ������ ����� ��� ������ ���������� �������");
					}
					ShowPlayerBuyMetalDialog(playerid);
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_TEMP_JOB_LOADER_START:
			{
				if(response)
				{
					if(GetPlayerTempJob(playerid) == TEMP_JOB_NONE)
					{
						TogglePlayerDynamicCP(playerid, help_info_CP, false);
						
						SetPlayerSkin(playerid, GetTempJobInfo(TEMP_JOB_LOADER, TJ_SKIN)[GetPlayerSex(playerid)]);
						SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_THIGH, 18635, A_OBJECT_BONE_RIGHT_THIGH, 0.2, -0.06, 0.1, 0.0, -90.0, 90.0, 1.0, 1.0, 1.0, 0);
						
						SetPlayerJobLoadItems(playerid, 0);
						SetPlayerTempJob(playerid, TEMP_JOB_LOADER);
						
						SetPlayerLoaderJobLoadCP(playerid);
						
						SendClientMessage(playerid, 0x3399FFFF, "�� ������ ������ ��������");
						SendClientMessage(playerid, 0x3399FFFF, "����� �������� ������� �������� {FF0000}�������� {3399FF}���������");
					}
				}
			}
			case DIALOG_TEMP_JOB_LOADER_END:
			{
				if(response)
				{
					EndPlayerTempJob(playerid, TEMP_JOB_LOADER);
				}
			}
			case DIALOG_TEMP_JOB_MINER_START:
			{
				if(response)
				{
					if(GetPlayerTempJob(playerid) == TEMP_JOB_NONE)
					{
						SetPlayerSkin(playerid, GetTempJobInfo(TEMP_JOB_MINER, TJ_SKIN)[GetPlayerSex(playerid)]);
						SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 18634, A_OBJECT_BONE_RIGHT_HAND, 0.07, 0.03, 0.04, 0.0, 270.0, 270.0, 1.5, 2.1, 1.8, 0);
						
						SetPlayerJobLoadItems(playerid, 0);
						SetPlayerTempJob(playerid, TEMP_JOB_MINER);
						
						SetPlayerTempJobState(playerid, TEMP_JOB_STATE_MINER_LOAD);
						SetPlayerMinerJobLoadCP(playerid);
						
						SendClientMessage(playerid, 0x3399FFFF, "�� ������ ������ �������");
						SendClientMessage(playerid, 0x66CC00FF, "����� ������������� �������� ���� �� ���������� �����");
						SendClientMessage(playerid, 0x66CC00FF, "������� ����� �������� �� ����� ��� ����������");
					}
				}
			}
			case DIALOG_TEMP_JOB_MINER_END:
			{
				if(response)
				{
					EndPlayerTempJob(playerid, TEMP_JOB_MINER);
				}
			}
			case DIALOG_TEMP_JOB_FACTORY_TRUCKER:
			{
				if(response)
				{	
					new job = GetPlayerTempJob(playerid);

					switch(job)
					{
						case TEMP_JOB_NONE:
						{
							new skin = GetTempJobInfo(TEMP_JOB_FACTORY_TRUCKER, TJ_SKIN)[GetPlayerSex(playerid)];
							
							ClearAnimations(playerid);
							SetPlayerSkin(playerid, skin);
					
							if(GetPlayerSex(playerid))
								SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HEAD, 18638, A_OBJECT_BONE_HEAD, 0.16, 0.02, 0.0, 0.0, 0.0, 0.0, 1.0, 1.1, 1.12, 0);
				
							SetPlayerJobLoadItems(playerid, 0);
							SetPlayerTempJob(playerid, TEMP_JOB_FACTORY_TRUCKER);
							SetPlayerTempJobState(playerid, TEMP_JOB_STATE_NONE);
						
							SendClientMessage(playerid, 0x3399FFFF, "�� ������ ������ � ������ �������� ������");
							SendClientMessage(playerid, 0x66CC00FF, "��� ��������� ���������� �������������� ����������� ����� � ����");
						
							SetPlayerData(playerid, P_IN_JOB, true);
						}
						case TEMP_JOB_FACTORY_TRUCKER:
						{
							EndPlayerJob(playerid);
						}
					}
				}
			}
			case DIALOG_TEMP_JOB_FACTORY:
			{
				if(response)
				{
					new job = GetPlayerTempJob(playerid);
					
					switch(job)
					{
						case TEMP_JOB_NONE:
						{
							new skin = GetTempJobInfo(TEMP_JOB_FACTORY, TJ_SKIN)[GetPlayerSex(playerid)];
							if(!GetPlayerSex(playerid))
							{	
								skin += random(2);
							}
				
							ClearAnimations(playerid);
							SetPlayerSkin(playerid, skin);
							SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HEAD, 18638, A_OBJECT_BONE_HEAD, 0.16, 0.02, 0.0, 0.0, 0.0, 0.0, 1.0, 1.1, 1.12, 0);
					
							TogglePlayerFactoryCP(playerid, true);
							SetPlayerData(playerid, P_JOB_WAGE, 0);
							
							SetPlayerJobLoadItems(playerid, 0);
							SetPlayerTempJob(playerid, TEMP_JOB_FACTORY);
							
							SetPlayerTempJobState(playerid, TEMP_JOB_STATE_FACTORY_TAKE_MET);
						
							SendClientMessage(playerid, 0x3399FFFF, "�� ������ ������ � ���������������� ���� ������");
							SendClientMessage(playerid, 0x66CC00FF, "��� ��������� ���������� �������������� ����������� � ����� � ���");
						
							DeletePVar(playerid, "factory_skill");
							DeletePVar(playerid, "factory_bad_prods");
							DeletePVar(playerid, "factory_take_metall");
						}
						case TEMP_JOB_FACTORY:
						{
							EndPlayerTempJob(playerid, TEMP_JOB_FACTORY);
						}
					}
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_FUEL_STATION_BUY:
			{
				if(response)
				{
					new stationid = GetPVarInt(playerid, "buy_fuel_st");
					
					if(IsPlayerInRangeOfPoint(playerid, 15.0, GetFuelStationData(stationid, FS_POS_X), GetFuelStationData(stationid, FS_POS_Y), GetFuelStationData(stationid, FS_POS_Z)))
					{
						if(!IsFuelStationOwned(stationid))
						{
							if(GetPlayerMoneyEx(playerid) >= GetFuelStationData(stationid, FS_PRICE))
							{
								SendClientMessage(playerid, 0xFFFFFFFF, "�����������! �� ������ ����������� �������");
								BuyPlayerFuelStation(playerid, stationid);
								
								PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
								Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{3399FF}����� ����������� �������", "{FFFFFF}��� ����� ��������� �� ������ ��� � ��������� ���������� ����� {FFCD00}(/gps)", "��", "");						
							}	
							else SendClientMessage(playerid, 0xCECECEFF, "� ��� ������������ ����� ��� ������� ���� ����������� �������");
						}
						else 
						{
							new fmt_str[75];
							
							format(fmt_str, sizeof fmt_str, "��� ����������� ������� ��� �������. ��������: %s", GetFuelStationData(stationid, FS_OWNER_NAME));
							SendClientMessage(playerid, 0xCECECEFF, fmt_str);
						}	
					}
				}
				DeletePVar(playerid, "buy_fuel_st");
			}
			case DIALOG_FUEL_STATION_INFO:
			{
				if(response)
				{	
					ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_PARAMS);
				}
			}
			case DIALOG_FUEL_STATION_PARAMS:
			{
				if(response)
				{
					ShowPlayerFuelStationDialog(playerid, listitem + 1);
				}
				else cmd::fuelst(playerid, "");
			}
			case DIALOG_FUEL_STATION_NAME:
			{
				new stationid = GetPlayerFuelStation(playerid);
				if(stationid != -1)
				{
					if(response)
					{
						if(3 <= strlen(inputtext) <= 15)
						{
							format(g_fuel_station[stationid][FS_NAME], 20, inputtext, 0);
							UpdateFuelStationLabel(stationid);
							
							SendClientMessage(playerid, 0x66CC00FF, "�������� ����������� ������� ��������");		
						}
						else 
						{
							SendClientMessage(playerid, 0xCECECEFF, "����� �������� ������ ���� �� 3-� �� 15-�� ��������");
							return ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_NEW_NAME);
						}
					}
					ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_PARAMS);
				}
			}
			case DIALOG_FUEL_STATION_PRICE_FUEL:
			{
				new stationid = GetPlayerFuelStation(playerid);
				if(stationid != -1)
				{
					if(response)
					{
						new price = strval(inputtext);
						if(2 <= price <= 15 && IsNumeric(inputtext))
						{
							new fmt_str[75];
							
							SetFuelStationData(stationid, FS_FUEL_PRICE, price);
							UpdateFuelStationLabel(stationid);
							
							format(fmt_str, sizeof fmt_str, "������ ������� �� ����� �������� ����� ����������� �� %d ��� �� 1 ����", price);
							SendClientMessage(playerid, 0x66CC00FF, fmt_str);
							
							format(fmt_str, sizeof fmt_str, "UPDATE fuel_stations SET fuel_price=%d WHERE id=%d LIMIT 1", GetFuelStationData(stationid, FS_FUEL_PRICE), GetFuelStationData(stationid, FS_SQL_ID));
							mysql_query(mysql, fmt_str, false);
						}
						else 
						{
							SendClientMessage(playerid, 0xCECECEFF, "������� ��������� ���� �� 2 �� 15 ������ �� 1 ����");
							return ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_FUEL_PRICE);
						}
					}
					ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_PARAMS);
				}
			}
			case DIALOG_FUEL_STATION_BUY_FUEL_PR:
			{
				new stationid = GetPlayerFuelStation(playerid);
				if(stationid != -1)
				{
					if(response)
					{
						new price = strval(inputtext);
						if(2 <= price <= 10 && IsNumeric(inputtext))
						{
							new fmt_str[90];
							SetFuelStationData(stationid, FS_BUY_FUEL_PRICE, price);
						
							format(fmt_str, sizeof fmt_str, "������ ������� ��� ����� �������� ����� ���������� �� %d ��� �� 1 ����", price);
							SendClientMessage(playerid, 0x66CC00FF, fmt_str);
							
							format(fmt_str, sizeof fmt_str, "UPDATE fuel_stations SET buy_fuel_price=%d WHERE id=%d LIMIT 1", GetFuelStationData(stationid, FS_BUY_FUEL_PRICE), GetFuelStationData(stationid, FS_SQL_ID));
							mysql_query(mysql, fmt_str, false);
						}
						else 
						{
							SendClientMessage(playerid, 0xCECECEFF, "������� ���������� ���� �� 2 �� 10 ������ �� 1 ����");
							return ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_BUY_FUEL_PRIC);
						}
					}
					ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_PARAMS);
				}
			}
			case DIALOG_FUEL_STATION_ORDER_FUELS:
			{
				new stationid = GetPlayerFuelStation(playerid);
				if(stationid != -1)
				{
					if(response)
					{
						if(GetFuelStationData(stationid, FS_ORDER_ID) != -1)
						{
							SendClientMessage(playerid, 0x999999FF, "����� ��� ����� ����������� ������� ��� ��������");
							ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_PARAMS);
							
							return 1;
						}
						
						if(GetFuelStationData(stationid, FS_BUY_FUEL_PRICE) > 0)
						{
							new order_fuels = strval(inputtext);
							new fuel_price = GetFuelStationData(stationid, FS_BUY_FUEL_PRICE);
							new price = order_fuels * fuel_price;
							
							if(order_fuels > 0 && IsNumeric(inputtext))
							{
								new fmt_str[256];
								if(order_fuels <= GetFuelStationMaxFuel(stationid))
								{
									if(GetFuelStationData(stationid, FS_BALANCE) >= price)
									{
										new order_id = CreateOrder(ORDER_TYPE_FUEL_STATION, stationid, order_fuels, fuel_price);
										if(order_id != -1)
										{
											AddFuelStationData(stationid, FS_BALANCE, -, price);
							
											format(fmt_str, sizeof fmt_str, "~w~fuel st. bank~n~~r~-%d rub", price);
											GameTextForPlayer(playerid, fmt_str, 4000, 1);
											
											format(fmt_str, sizeof fmt_str, "UPDATE fuel_stations SET balance=%d WHERE id=%d LIMIT 1", GetFuelStationData(stationid, FS_BALANCE), GetFuelStationData(stationid, FS_SQL_ID));
											mysql_query(mysql, fmt_str, false);
											
											new year, month, day;
											timestamp_to_date(GetOrderData(order_id, O_TIME), year, month, day);
										
											format
											(
												fmt_str, sizeof fmt_str,
												"{FFFFFF}��������� ������:\n\n"\
												"���������� �������:\t\t\t%d �\n"\
												"��������� 1 �����:\t\t\t%d ���\n"\
												"����� ��������� ������:\t\t%d ���\n"\
												"���� ���������� ������:\t\t%02d-%02d-%d\n\n"\
												"������ ���� �������� ������ ����������� �������\n"\
												"�������� ���������� ������ ������", 
												order_fuels,
												fuel_price,
												price,
												day, month, year
											);	
											Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{99CC00}����� ��������", fmt_str, "�������", "");
										}
										else SendClientMessage(playerid, 0x999999FF, "� ������ ������ �� �� ������ �������� �����");
										
										return 1;
									}
									else 
									{
										format(fmt_str, sizeof fmt_str, "����� �������� ����� ���������� ����� %d ��� �� ����� ���", price);
										SendClientMessage(playerid, 0xFF6600FF, fmt_str);
									}
								}
								else 
								{
									format(fmt_str, sizeof fmt_str, "�� �� ������ �������� ����� %d ������ �������", GetFuelStationMaxFuel(stationid));
									SendClientMessage(playerid, 0xCECECEFF, fmt_str);
								}
							}
						}
						else 
						{
							SendClientMessage(playerid, 0xFF6600FF, "����� ��� ��� �������� �����, ���������� ���������� ����");
							ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_BUY_FUEL_PRIC);
							
							return 1;
						}
						ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_FUEL_ORDER);
					}
					else ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_PARAMS);
				}
			}
			case DIALOG_FUEL_STATION_ORDER_CANCE:
			{
				new stationid = GetPlayerFuelStation(playerid);
				if(stationid != -1)
				{
					if(response)
					{
						new order_id = GetFuelStationData(stationid, FS_ORDER_ID);
						if(order_id != -1 && GetOrderData(order_id, O_SQL_ID) > 0)
						{
							if(!GetOrderData(order_id, O_USED))
							{
								new fmt_str[128];
								new return_money = GetOrderData(order_id, O_AMOUNT) * GetOrderData(order_id, O_PRICE);
								
								DeleteOrder(order_id);
								AddFuelStationData(stationid, FS_BALANCE, +, return_money);
								
								format(fmt_str, sizeof fmt_str, "UPDATE fuel_stations SET balance=%d WHERE id=%d LIMIT 1", GetFuelStationData(stationid, FS_BALANCE), GetFuelStationData(stationid, FS_SQL_ID));
								mysql_query(mysql, fmt_str, false);
								
								format
								(
									fmt_str, sizeof fmt_str,
									"{FFFFFF}�� �������� ����� �������\n"\
									"�� ���� ����������� ������� ���� ���������� {00CC00}%d ���",
									return_money
								);
								Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FF9900}������ ������", fmt_str, "�������", "");
								
								format(fmt_str, sizeof fmt_str, "~w~fuel st. bank~n~~g~+%d rub", return_money);
								GameTextForPlayer(playerid, fmt_str, 4000, 1);
							
								return 1;
							}
							else SendClientMessage(playerid, 0xFF6600FF, "��� ����� �����������, ��� ������ ��������");
						}
					}
					ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_PARAMS);
				}
			}
			case DIALOG_FUEL_STATION_IMPROVEMENT:
			{
				new stationid = GetPlayerFuelStation(playerid);
				if(stationid != -1)
				{
					if(response)
					{
						if(0 <= listitem <= sizeof g_fuel_station_improvements - 1)
						{
							new i_level = GetFuelStationData(stationid, FS_IMPROVEMENTS);
							new i_price = g_fuel_station_improvements[listitem][I_PRICE];
							
							if(i_level < listitem)
							{
								SendClientMessage(playerid, 0xCECECEFF, "���� ������� ��������� ���� ����������");
							}
							else if(i_level > listitem) 
							{
								SendClientMessage(playerid, 0xCECECEFF, "�� ��� ������ ���� ������� ���������");
							}
							else if(GetPlayerMoneyEx(playerid) < i_price)
							{
								new fmt_str[64];
								
								format(fmt_str, sizeof fmt_str, "��� ������� %d ������ ��������� ���������� %d ������", listitem + 1, i_price);
								SendClientMessage(playerid, 0xCECECEFF, fmt_str);
							}
							else 
							{
								new fmt_str[128];
								
								format(fmt_str, sizeof fmt_str, "UPDATE accounts a, fuel_stations f SET a.money=%d, f.improvements=%d WHERE a.id=%d AND f.id=%d", GetPlayerMoneyEx(playerid)-i_price, i_level + 1, GetPlayerAccountID(playerid), GetFuelStationData(stationid, FS_SQL_ID));
								mysql_query(mysql, fmt_str, false);
								
								if(!mysql_errno())
								{
									GivePlayerMoneyEx(playerid, -i_price, "������� ��������� ��� ���", false, true);
								
									format(fmt_str, sizeof fmt_str, "�� �������� ���� ����������� ������� �� {FFCD00}%s {3399FF}������", GetNumericName(listitem + 1));
									SendClientMessage(playerid, 0x3399FFFF, fmt_str);
									
									AddFuelStationData(stationid, FS_IMPROVEMENTS, +, 1);
									switch(listitem + 1)
									{
										case 1..3:
										{
											format(fmt_str, sizeof fmt_str, "������� ���������� ��������� ��������� �� %d ������", GetFuelStationMaxFuel(stationid));
											SendClientMessage(playerid, 0x66CC00FF, fmt_str);
											
											SendClientMessage(playerid, 0x999999FF, "������ ����� ������ ���������� � ��� ����������");
										}
										case 4:
										{
											SendClientMessage(playerid, 0x66CC00FF, "�������� ���� �� ������ ������ �� ���������������� �� ���� ����������� �������");
											SendClientMessage(playerid, 0x999999FF, "��������� �����, ����� �� ������ ���������� ��� ��������� � 2 ����");		
										}
									}
								}
								else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 17)");
							}
						}
					}
					ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_PARAMS);
				}
			}
			case DIALOG_FUEL_STATION_SELL:
			{
				new stationid = GetPlayerFuelStation(playerid);
				if(stationid != -1)
				{
					if(response)
					{
						if(GetFuelStationData(stationid, FS_ORDER_ID) != -1)
						{
							Dialog
							(
								playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
								"{FF6600}������� ����������� �������",
								"{FFFFFF}����� ��� ��� ������� ��� �����������\n"\
								"����� ������� ����� {FF3333}��������",
								"�������", ""
							);
						}
						else SellFuelStation(playerid);
					}
				}
			}
			case DIALOG_FUEL_STATION_BUY_JERRICA:
			{
				new stationid = GetPVarInt(playerid, "buy_jerrican_in_fuelst");
				DeletePVar(playerid, "buy_jerrican_in_fuelst");
				
				if(response)
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, GetFuelStationData(stationid, FS_POS_X), GetFuelStationData(stationid, FS_POS_Y), GetFuelStationData(stationid, FS_POS_Z)))
					{
						if(!GetPVarInt(playerid, "have_jerrican")) 
						{
							new price = GetFuelStationData(stationid, FS_FUEL_PRICE) * 15;
							if(GetPlayerMoneyEx(playerid) >= price)
							{
								new query[150];
							
								if(IsFuelStationOwned(stationid))
								{
									if(GetFuelStationData(stationid, FS_FUELS) < 15)
										return SendClientMessage(playerid, 0xCECECEFF, "�� ���� ��� ��� �������");
									
									AddFuelStationData(stationid, FS_FUELS, -, 15);
									AddFuelStationData(stationid, FS_BALANCE, +, price);
									
									format(query, sizeof query, "UPDATE accounts a,fuel_stations f SET a.money=%d,f.fuels=%d,f.balance=%d WHERE a.id=%d AND f.id=%d", GetPlayerMoneyEx(playerid)-price, GetFuelStationData(stationid, FS_FUELS), GetFuelStationData(stationid, FS_BALANCE), GetPlayerAccountID(playerid), GetFuelStationData(stationid, FS_SQL_ID));
								}
								else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
								
								mysql_query(mysql, query, false);
								if(!mysql_errno())
								{
									new buy_fuel_pay = GetPVarInt(playerid, "buy_fuel_pay_j");
									SetPVarInt(playerid, "buy_fuel_pay_j", buy_fuel_pay + price);
									
									GivePlayerMoneyEx(playerid, -price, "������� �������� �� ���", false, true);
									
									SetPVarInt(playerid, "have_jerrican", 1);
									SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 1650, A_OBJECT_BONE_LEFT_HAND, 0.15, 0.0, 0.0, 0.0, -90.0, 180.0, 1.0, 1.0, 1.0, 0);
								
									SendClientMessage(playerid, 0x66CC00FF, "�� ������ �������� � 15 ������� �������");
									SendClientMessage(playerid, 0x3399FFFF, "����� ��������� ���������, ��������� � ���� � ������� ���");
									SendClientMessage(playerid, 0xCECECEFF, "����������: �� �� ������ ��������� �� ����� ��������. ��� - ������ ������ �����");
								}
								else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 19)");
							}
							else SendClientMessage(playerid, 0x999999FF, "������������ ����� ��� ������� ��������");					
						}
						else SendClientMessage(playerid, 0xCECECEFF, "�� ��� ������ ��������");
					}						
				}
			}
			case DIALOG_FUEL_STATION_BUY_FUEL_M:
			{
				new stationid = GetPVarInt(playerid, "nearest_fuel_st");
				
				if(response)
				{
					new buy_fuel_count = strval(inputtext);
					new vehicleid = GetPlayerVehicleID(playerid);
					
					if(GetPlayerJob(playerid) == JOB_MECHANIC && IsPlayerInJob(playerid) && IsPlayerInVehicle(playerid, GetPlayerJobCar(playerid)))
					{
						if(IsPlayerInRangeOfPoint(playerid, 10.0, GetFuelStationData(stationid, FS_POS_X), GetFuelStationData(stationid, FS_POS_Y), GetFuelStationData(stationid, FS_POS_Z)))
						{
							new fmt_str[150];
							
							if((1 <= buy_fuel_count <= 10_000) && IsNumeric(inputtext))
							{
								if(GetFuelStationData(stationid, FS_FUELS) >= buy_fuel_count)
								{
									if(!(buy_fuel_count % 10))
									{
										if((GetPlayerJobLoadItems(playerid) + buy_fuel_count) <= 50)
										{
											new price = buy_fuel_count * GetFuelStationData(stationid, FS_FUEL_PRICE);
											if(GetPlayerMoneyEx(playerid) >= price)
											{
												if(IsFuelStationOwned(stationid))
												{
													AddFuelStationData(stationid, FS_FUELS, -, buy_fuel_count);
													AddFuelStationData(stationid, FS_BALANCE, +, price);
													
													format(fmt_str, sizeof fmt_str, "UPDATE accounts a,fuel_stations f SET a.money=%d,f.fuels=%d,f.balance=%d WHERE a.id=%d AND f.id=%d", GetPlayerMoneyEx(playerid)-price, GetFuelStationData(stationid, FS_FUELS), GetFuelStationData(stationid, FS_BALANCE), GetPlayerAccountID(playerid), GetFuelStationData(stationid, FS_SQL_ID));
												}
												else format(fmt_str, sizeof fmt_str, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
												mysql_query(mysql, fmt_str, false);
												
												if(!mysql_errno())
												{
													GivePlayerMoneyEx(playerid, -price, "������� ������� �� ��� (/getfuel)", false, true);
													SetPlayerJobLoadItems(playerid, GetPlayerJobLoadItems(playerid) + buy_fuel_count);

													new buy_fuel_pay = GetPVarInt(playerid, "buy_fuel_pay_j");
													SetPVarInt(playerid, "buy_fuel_pay_j", buy_fuel_pay + price);
													
													format(fmt_str, sizeof fmt_str, "�� ������ %d � ������� �� %d ������", buy_fuel_count, price);
													SendClientMessage(playerid, 0x66CC00FF, fmt_str);
													
													format(fmt_str, sizeof fmt_str, "%s{FFFFFF}�����������\n{999999}�������: %d �", GetPlayerData(playerid, P_JOB_SERVICE_NAME), GetPlayerJobLoadItems(playerid));
													UpdateVehicleLabel(vehicleid, 0xCC9900FF, fmt_str);
													
													return DeletePVar(playerid, "nearest_fuel_st");
												}
												else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 20)");
											}
											else SendClientMessage(playerid, 0xCECECEFF, "� ��� ������������ ����� ��� ������� ������ ���-�� �������");
										}
										else SendClientMessage(playerid, 0xCECECEFF, "����� ��������� �� ����� 50 � �������");
									}
									else SendClientMessage(playerid, 0xCECECEFF, "���-�� ������� ������ ���� ������ 10");
								}
								else SendClientMessage(playerid, 0xCECECEFF, "�� ��� ��� ������ ���-�� �������");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "�������� ��������");
							
							format
							(
								fmt_str, sizeof fmt_str, 
								"{FFFFFF}������� �� ���:\t\t%d/10000 �\n"\
								"��������� 1 �����:\t%d ���\n\n"\
								"������� ���-�� �������, ������� ������ ��������\n"\
								"(����� ������ ���� ������� 10)",
								GetFuelStationData(stationid, FS_FUELS),
								GetFuelStationData(stationid, FS_FUEL_PRICE)
							);
							Dialog(playerid, DIALOG_FUEL_STATION_BUY_FUEL_M, DIALOG_STYLE_INPUT, "{FFCD00}������� �������", fmt_str, "������", "������");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "�� ������ ��������� ����� ����������� �������");
					}
					else SendClientMessage(playerid, 0xCECECEFF, "�� ������ ��������� � ������� ����������");
				}
				else DeletePVar(playerid, "nearest_fuel_st");
			}
			// -----------------------------------------------------------------
			case DIALOG_JERRICAN_FILL_CAR:
			{
				new vehicleid = GetPVarInt(playerid, "jerrican_fill_car");
				DeletePVar(playerid, "jerrican_fill_car");
				
				if(response && vehicleid)
				{
					new Float: x, Float: y, Float: z;
					GetVehiclePos(vehicleid, x, y, z);
					
					if(IsPlayerInRangeOfPoint(playerid, 2.0, x, y, z)) 
					{
						if((GetVehicleData(vehicleid, V_FUEL) + 15.0) <= 150.0)
						{
							SetVehicleData(vehicleid, V_FUEL, GetVehicleData(vehicleid, V_FUEL) + 15.0);
							ApplyAnimation(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);							
						
							DeletePVar(playerid, "have_jerrican");
							
							RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND);
							SendClientMessage(playerid, 0x66CC00FF, "��������� ���������");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "� �������� ����� ���������� ������� �� ����������");						
					}
					else SendClientMessage(playerid, 0x999999FF, "�� ���������� ������� ������ �� ����������");
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_BIZ_BUY:
			{
				if(response)
				{
					new businessid = GetPVarInt(playerid, "buy_biz_id");
					
					if(IsPlayerInRangeOfPoint(playerid, 7.0, GetBusinessData(businessid, B_POS_X), GetBusinessData(businessid, B_POS_Y), GetBusinessData(businessid, B_POS_Z)))
					{
						if(!IsBusinessOwned(businessid))
						{
							if(GetPlayerMoneyEx(playerid) >= GetBusinessData(businessid, B_PRICE))
							{
								SendClientMessage(playerid, 0xFFFFFFFF, "�����������! �� ������ ������");			
								BuyPlayerBusiness(playerid, businessid);
								
								PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
								Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{3399FF}����� ������", "{FFFFFF}��� ����� ��������� �� ������ ������� � ��������� ���������� ����� {FFCD00}(/gps)", "��", "");
							}	
							else SendClientMessage(playerid, 0xCECECEFF, "� ��� ������������ ����� ��� ������� ����� �������");
						}
						else
						{
							new fmt_str[64];
							
							format(fmt_str, sizeof fmt_str, "���� ������ ��� ������. ��������: %s", GetBusinessData(businessid, B_OWNER_NAME));
							SendClientMessage(playerid, 0xCECECEFF, fmt_str);
						}	
					}
				}
				DeletePVar(playerid, "buy_biz_id");
			}
			case DIALOG_BIZ_INFO:
			{
				if(response)
				{
					ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
				}
			}
			case DIALOG_BIZ_PARAMS:
			{
				if(response)
				{
					ShowPlayerBusinessDialog(playerid, listitem + 1);
				}
				else cmd::business(playerid, "");
			}
			case DIALOG_BIZ_ENTER_PRICE:
			{
				new businessid = GetPlayerBusiness(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						new price = strval(inputtext);
						if(strlen(inputtext))
						{
							if((0 <= price <= 5000) && IsNumeric(inputtext))
							{
								new query[64 + 1];
								SetBusinessData(businessid, B_ENTER_PRICE, price);
								
								format(query, sizeof query, "UPDATE business SET enter_price=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_ENTER_PRICE), GetBusinessData(businessid, B_SQL_ID));
								mysql_query(mysql, query, false);

								UpdateBusinessLabel(businessid);
								SendClientMessage(playerid, 0x66CC00FF, "���� �� ���� � ������ ��������");
								
								return ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
							}
							else SendClientMessage(playerid, 0xCECECEFF, "������ ���� �� 0 �� 5000 ������");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "������� ���� �� ���� � ��� ������");
						
						ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_ENTER_PRICE);
					}
					else ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
				}
			}
			case DIALOG_BIZ_PROD_PRICE:
			{
				new businessid = GetPlayerBusiness(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						new price = strval(inputtext);
						if(strlen(inputtext) && IsNumeric(inputtext))
						{
							if(25 <= price <= 200)
							{
								new query[64 + 1];
								SetBusinessData(businessid, B_PROD_PRICE, price);
								
								format(query, sizeof query, "UPDATE business SET prod_price=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_PROD_PRICE), GetBusinessData(businessid, B_SQL_ID));
								mysql_query(mysql, query, false);
								
								SendClientMessage(playerid, 0x66CC00FF, "��������� �������� ��������");
								return ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
							}
							else SendClientMessage(playerid, 0xCECECEFF, "������� ��������� �� 25 �� 200 ������");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "������� ��������� ��������");
						
						ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PROD_PRICE);
					}
					else ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
				}
			}
			case DIALOG_BIZ_ORDER_PRODS:
			{
				new businessid = GetPlayerBusiness(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						if(GetBusinessData(businessid, B_ORDER_ID) != -1)
						{
							SendClientMessage(playerid, 0x999999FF, "����� ��� ������ ����������� ��� ��������");
							return ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
						}
						
						if(GetBusinessData(businessid, B_PROD_PRICE) > 0)
						{
							new order_prods = strval(inputtext);
							new prod_price = GetBusinessData(businessid, B_PROD_PRICE);
							new price = order_prods * prod_price;
							
							if(order_prods > 0 && IsNumeric(inputtext))
							{
								new fmt_str[256];
								if(order_prods <= GetBusinessMaxProd(businessid))
								{
									if(GetBusinessData(businessid, B_BALANCE) >= price)
									{
										new order_id = CreateOrder(ORDER_TYPE_BUSINESS, businessid, order_prods, prod_price);
										if(order_id != -1)
										{
											AddBusinessData(businessid, B_BALANCE, -, price);
							
											format(fmt_str, sizeof fmt_str, "~w~business bank~n~~r~-%d rub", price);
											GameTextForPlayer(playerid, fmt_str, 4000, 1);
											
											format(fmt_str, sizeof fmt_str, "UPDATE business SET balance=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_BALANCE), GetBusinessData(businessid, B_SQL_ID));
											mysql_query(mysql, fmt_str, false);
											
											new year, month, day;
											timestamp_to_date(GetOrderData(order_id, O_TIME), year, month, day);
											
											format
											(
												fmt_str, sizeof fmt_str,
												"{FFFFFF}��������� ������:\n\n"\
												"���������� ���������:\t\t%d ��.\n"\
												"��������� 1 ��������:\t\t%d ���\n"\
												"����� ��������� ������:\t\t%d ���\n"\
												"���� ���������� ������:\t\t%02d-%02d-%d\n\n"\
												"������ ���� �������� ������ ����������� ���������\n"\
												"�������� ���������� ������ ������", 
												order_prods,
												prod_price,
												price,
												day, month, year
											);
											Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{99CC00}����� ��������", fmt_str, "�������", "");
										}
										else SendClientMessage(playerid, 0x999999FF, "� ������ ������ �� �� ������ �������� �����");
										
										return 1;
									}
									else 
									{
										format(fmt_str, sizeof fmt_str, "����� �������� ����� ���������� ����� %d ��� �� ����� �������", price);
										SendClientMessage(playerid, 0xFF6600FF, fmt_str);
									}
								}
								else 
								{
									format(fmt_str, sizeof fmt_str, "�� �� ������ �������� ����� %d ���������", GetBusinessMaxProd(businessid));
									SendClientMessage(playerid, 0xCECECEFF, fmt_str);
								}
							}
						}
						else 
						{
							SendClientMessage(playerid, 0xFF6600FF, "����� ��� ��� �������� �����, ���������� ��������� ��������");
							return ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PROD_PRICE);
						}
						ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PROD_ORDER);
					}
					else ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
				}
			}
			case DIALOG_BIZ_ORDER_CANCEL:
			{
				new businessid = GetPlayerBusiness(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						new order_id = GetBusinessData(businessid, B_ORDER_ID);
						if(order_id != -1 && GetOrderData(order_id, O_SQL_ID) > 0)
						{
							if(!GetOrderData(order_id, O_USED))
							{
								new fmt_str[128];
								new return_money = GetOrderData(order_id, O_AMOUNT) * GetOrderData(order_id, O_PRICE);
								
								DeleteOrder(order_id);
								AddBusinessData(businessid, B_BALANCE, +, return_money);
								
								format(fmt_str, sizeof fmt_str, "UPDATE business SET balance=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_BALANCE), GetBusinessData(businessid, B_SQL_ID));
								mysql_query(mysql, fmt_str, false);
								
								format
								(
									fmt_str, sizeof fmt_str,
									"{FFFFFF}�� �������� ����� ���������\n"\
									"�� ���� ������� ���� ���������� {00CC00}%d ���",
									return_money
								);
								Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FF9900}������ ������", fmt_str, "�������", "");
								
								format(fmt_str, sizeof fmt_str, "~w~business bank~n~~g~+%d rub", return_money);
								GameTextForPlayer(playerid, fmt_str, 4000, 1);
							
								return 1;
							}
							else SendClientMessage(playerid, 0xFF6600FF, "��� ����� �����������, ��� ������ ��������");
						}
					}
					ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
				}
			}
			case DIALOG_BIZ_IMPROVEMENT:
			{
				new businessid = GetPlayerBusiness(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						if(0 <= listitem <= sizeof g_business_improvements - 1)
						{
							new i_level = GetBusinessData(businessid, B_IMPROVEMENTS);
							new i_price = g_business_improvements[listitem][I_PRICE];
							
							if(i_level < listitem)
							{
								SendClientMessage(playerid, 0xCECECEFF, "���� ������� ��������� ���� ����������");
							}
							else if(i_level > listitem) 
							{
								SendClientMessage(playerid, 0xCECECEFF, "�� ��� ������ ���� ������� ���������");
							}
							else if(GetPlayerMoneyEx(playerid) < i_price)
							{
								new fmt_str[64];
								
								format(fmt_str, sizeof fmt_str, "��� ������� %d ������ ��������� ���������� %d ������", listitem + 1, i_price);
								SendClientMessage(playerid, 0xCECECEFF, fmt_str);
							}
							else 
							{
								new fmt_str[128];
								
								format(fmt_str, sizeof fmt_str, "UPDATE accounts a, business b SET a.money=%d, b.improvements=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-i_price, i_level + 1, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
								mysql_query(mysql, fmt_str, false);
								
								if(!mysql_errno())
								{
									new cur_max_prods = GetBusinessMaxProd(businessid);
									GivePlayerMoneyEx(playerid, -i_price, "������� ��������� ��� �������", false, true);
								
									format(fmt_str, sizeof fmt_str, "�� �������� ���� ������ �� {FFCD00}%s {3399FF}������", GetNumericName(listitem + 1));
									SendClientMessage(playerid, 0x3399FFFF, fmt_str);
									
									AddBusinessData(businessid, B_IMPROVEMENTS, +, 1);
									switch(listitem + 1)
									{
										case 1:
										{
											format(fmt_str, sizeof fmt_str, "���������� ������ ��� ��������� ��������� � %d �� %d", cur_max_prods, GetBusinessMaxProd(businessid));
											SendClientMessage(playerid, 0x66CC00FF, fmt_str);
											
											SendClientMessage(playerid, 0x999999FF, "������ ����� ������� ���� ��������� �� �����");
										}
										case 2:
										{
											SendClientMessage(playerid, 0x66CC00FF, "������ ���� ������� ������ ������������ �������� ��������� �� ���������� �������");
											SendClientMessage(playerid, 0x999999FF, "������ �� ����� ����� ������������� �� ������ �����������");	
										
											BusinessHealthPickupInit(businessid);
										}
										case 3:
										{
											SendClientMessage(playerid, 0x66CC00FF, "��������� ����������� ������, �� ������ ������� �� ������ ��������� � 2 ���� ������");
											SendClientMessage(playerid, 0x999999FF, "��������� �����, �� ������� �������� ������� �������");
										}
										case 4:
										{
											SendClientMessage(playerid, 0x66CC00FF, "������ ���� ������� ����� ������� ���� ��� ����� � ������");
											SendClientMessage(playerid, 0x999999FF, "�� ����� ������ �������� ��� ��������� ��� �������� {FF9900}/bizmusic");
										}
										case 5:
										{
											SendClientMessage(playerid, 0x66CC00FF, "� ����� ������� ��� ���������� �������������� ����� ��������� ���������� �����������");
										
											format(fmt_str, sizeof fmt_str, "���������� ������ ��� ��������� ��������� � %d �� %d", cur_max_prods, GetBusinessMaxProd(businessid));
											SendClientMessage(playerid, 0x999999FF, fmt_str);
										}
										case 6:
										{
											format(fmt_str, sizeof fmt_str, "INSERT INTO business_gps (bid,time) VALUES (%d,%d)", businessid, gettime());
											mysql_query(mysql, fmt_str, false);
										
											g_business_gps_init = false;
											
											SendClientMessage(playerid, 0x66CC00FF, "������ ��� ������ ����� ����� ����� � ������ �������� {FF9900}(/gps > ������)");
											SendClientMessage(playerid, 0x999999FF, "��� �������� �������� �������������� ��������, ��� ����� �������� ������ �����������");	
										}
									}
								}
								else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 23)");
							}
						}
					}
					ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
				}
			}
			case DIALOG_BIZ_SELL:
			{
				new businessid = GetPlayerBusiness(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						if(GetBusinessData(businessid, B_ORDER_ID) != -1)
						{
							Dialog
							(
								playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
								"{FF6600}������� �������",
								"{FFFFFF}����� ��� ��� ������� ������ �����������\n"\
								"����� ��������� ����� {FF3333}��������",
								"�������", ""
							);
						}
						else SellBusiness(playerid);
					}
				}
			}
			case DIALOG_BIZ_ENTER_MUSIC:
			{
				new businessid = GetPlayerBusiness(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						if(0 <= listitem <= sizeof g_business_sound)
						{
							new query[64];
							format(query, sizeof query, "UPDATE business SET enter_music=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_ENTER_MUSIC), GetBusinessData(businessid, B_SQL_ID));
							mysql_query(mysql, query, false);
							
							if(listitem > 0)
								PlayerPlaySound(playerid, g_business_sound[listitem - 1], 0.0, 0.0, 0.0);
								
							SetBusinessData(businessid, B_ENTER_MUSIC, listitem);
							SendClientMessage(playerid, 0x66CC00FF, "���� ��� ����� � ������ �������");						
						}
					}
				}
			}
			case DIALOG_BIZ_ENTER:
			{
				new businessid = GetPVarInt(playerid, "biz_enter") - 1;
				DeletePVar(playerid, "biz_enter");
				
				if(response && GetPlayerInBiz(playerid) == -1)
				{
					if(businessid != -1 && GetBusinessData(businessid, B_ENTER_PRICE) > 0)
					{
						if(IsBusinessOwned(businessid))
						{
							if(IsPlayerInRangeOfPoint(playerid, 5.0, GetBusinessData(businessid, B_POS_X), GetBusinessData(businessid, B_POS_Y), GetBusinessData(businessid, B_POS_Z))) 
							{
								new price = GetBusinessData(businessid, B_ENTER_PRICE);
								new take_prods = GetBusinessEnterProdCount(businessid);
								
								if(GetPlayerMoneyEx(playerid) >= price)
								{
									new query[150];
									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
									}
									else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
									mysql_query(mysql, query, false);
								
									if(!mysql_errno())
									{
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											AddBusinessData(businessid, B_PRODS, -, take_prods);
											AddBusinessData(businessid, B_BALANCE, +, price);
										}
										
										SetPlayerUseListitem(playerid, businessid);
										GivePlayerMoneyEx(playerid, -price, "������ �� ���� � ������", false, true);
									
										EnterPlayerToBiz(playerid, businessid);
									
										mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price, IsBusinessOwned(businessid));
										mysql_query(mysql, query, false);
									}
									else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 22)");
								}
								else SendClientMessage(playerid, 0xCECECEFF, "� ��� ������������ ����� ��� �����");
							}
						}
					}
				}
			}
			case DIALOG_BIZ_SHOP_24_7:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_SHOP_24_7))
						{
							new price;
							new take_prods;
							
							switch(listitem + 1)
							{
								case 1:
								{
									price = 170;
									take_prods = 2;
									
									if(!GetPlayerPhone(playerid))
									{
										if(GetPlayerMoneyEx(playerid) >= price)
										{
											new query[175];
											
											if(GetBusinessData(businessid, B_PRODS) >= take_prods)
											{
												format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,a.phone=%d,b.products=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid) + 1000000, GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)-price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
											}
											else format(query, sizeof query, "UPDATE accounts SET money=%d,phone=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid) + 1000000, GetPlayerAccountID(playerid));
											mysql_query(mysql, query, false);
											
											if(!mysql_errno())
											{	
												if(GetBusinessData(businessid, B_PRODS) >= take_prods)
												{
													AddBusinessData(businessid, B_PRODS, -, take_prods);
													AddBusinessData(businessid, B_BALANCE, +, price);
												}
												
												mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price, IsBusinessOwned(businessid));
												mysql_query(mysql, query, false);
											
												GivePlayerMoneyEx(playerid, -price, "������� ��������", false, true);
												SetPlayerData(playerid, P_PHONE, GetPlayerAccountID(playerid) + 1000000);
												
												SendClientMessage(playerid, 0x66CC00FF, "����������� {0099FF}/c(/call) ��� /call [����� ��������] {66CC00}����� ������� ������.");
												SendClientMessage(playerid, 0x66CC00FF, "��� �������� SMS ��������� ����������� {0099FF}/sms{66CC00}. ������ �������: {0099FF}/menu > ������ ������ > �������");
												
												format
												(
													query, sizeof query, 
													"{FFFFFF}�����������!\n"\
													"�� ������ ��������� �������. ��� �����: {0099FF}%d",
													GetPlayerPhone(playerid)
												);
												Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{66CC00}������� ���������� ��������", query, "�������", "");												
											}
											else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 25)");
										}
										else SendClientMessage(playerid, 0xCECECEFF, "��������� ������� ����� 170 ������");
									}
									else SendClientMessage(playerid, 0x999999FF, "� ��� ��� ���� ��������� �������");
								}
								case 2:
								{
									price = 450;
									if(GetPlayerPhone(playerid))
									{
										if(GetPlayerMoneyEx(playerid) >= price)
										{
											Dialog
											(
												playerid, DIALOG_BIZ_CHANGE_PHONE_NUMBER, DIALOG_STYLE_INPUT,
												"{66CC00}��������� ������",
												"{FFFFFF}������� ����� ����� � ���� ����\n\n"\
												"{FF6633}����������:\n"\
												"{FFCD00}- ����� ������ ���� ������������,\n"\
												"��������: 284411\n"\
												"- ����� �� ������ ���������� � 0\n\n"\
												"{FFFFFF}�� ����� ������ ������� ����\n"\
												"����������� �����. ��� �����\n"\
												"������� � ���� {3399FF}����� 0",
												"�������", "������"
											);																					
										}
										else SendClientMessage(playerid, 0xCECECEFF, "��� ��������� ������ �������� ���������� 450 ������");
									}
									else SendClientMessage(playerid, 0x999999FF, "������� ����� ���������� ��������� �������");
								}
								case 3:
								{
									price = 200;
									if(GetPlayerPhone(playerid))
									{
										if(GetPlayerMoneyEx(playerid) >= price)
										{
											Dialog
											(
												playerid, DIALOG_BIZ_CHANGE_PHONE_COLOR, DIALOG_STYLE_LIST,
												"{66CC00}��������� ����� ��������",
												"1. �����������\n"\
												"2. �����\n"\
												"3. ���������\n"\
												"4. �����������\n"\
												"5. �������\n"\
												"6. �������\n"\
												"7. �������\n"\
												"8. �����-�����\n"\
												"9. ������\n"\
												"10. �����",
												"��������", "������"
											);
										}
										else SendClientMessage(playerid, 0xCECECEFF, "��� ��������� ����� �������� ���������� 200 ������");
									}
									else SendClientMessage(playerid, 0x999999FF, "������� ����� ���������� ��������� �������");
								}
								case 4:
								{
									price = 300;
									take_prods = 2;
									
									if(GetPlayerData(playerid, P_MED_CHEST) < 2)
									{
										if(GetPlayerMoneyEx(playerid) >= price)
										{
											new query[175];
											
											if(GetBusinessData(businessid, B_PRODS) >= take_prods)
											{
												format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
											}
											else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
											mysql_query(mysql, query, false);
											
											if(!mysql_errno())
											{
												if(GetBusinessData(businessid, B_PRODS) >= take_prods)
												{
													AddBusinessData(businessid, B_PRODS, -, take_prods);
													AddBusinessData(businessid, B_BALANCE, +, price);
												}
												
												mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price, IsBusinessOwned(businessid));
												mysql_query(mysql, query, false);
											
												GivePlayerMoneyEx(playerid, -price, "������� �������", false, true);
											
												AddPlayerData(playerid, P_MED_CHEST, +, 2);
												SendClientMessage(playerid, 0x66CC00FF, "�� ������ ����� �������. ����������� {3399FF}/healme {66CC00}��� �� �������������");
												
												format(query, sizeof query, "������� ���������� �������: %d", GetPlayerData(playerid, P_MED_CHEST));
												SendClientMessage(playerid, 0xDD90FFFF, query);												
											}
											else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 28)");
										}
										else SendClientMessage(playerid, 0xCECECEFF, "����� ������� ����� 300 ������");
									}
									else SendClientMessage(playerid, 0x999999FF, "�� �� ������ ������ ������ �������");
								}
								case 5:
								{
									price = 200;
									take_prods = 2;

									if(GetPlayerMoneyEx(playerid) >= price)
									{
										new query[175];
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
										}
										else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
										mysql_query(mysql, query, false);
										
										if(!mysql_errno())
										{
											if(GetBusinessData(businessid, B_PRODS) >= take_prods)
											{
												AddBusinessData(businessid, B_PRODS, -, take_prods);
												AddBusinessData(businessid, B_BALANCE, +, price);
											}
											
											mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price, IsBusinessOwned(businessid));
											mysql_query(mysql, query, false);
											
											GivePlayerMoneyEx(playerid, -price, "������� ������������", false, true);
											
											GivePlayerWeapon(playerid, 43, 15);
											SendClientMessage(playerid, 0x66CC00FF, "�� ������ ����������� �� 15 �������");												
										}
										else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 29)");
									}
									else SendClientMessage(playerid, 0xCECECEFF, "����� ��������� ����� 200 ������");
								}
								case 6:
								{
									price = 150;
									take_prods = 1;
									
									if(GetPlayerMoneyEx(playerid) >= price)
									{
										new query[175];
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
										}
										else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
										mysql_query(mysql, query, false);
										
										if(!mysql_errno())
										{
											if(GetBusinessData(businessid, B_PRODS) >= take_prods)
											{
												AddBusinessData(businessid, B_PRODS, -, take_prods);
												AddBusinessData(businessid, B_BALANCE, +, price);
											}
											
											mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price, IsBusinessOwned(businessid));
											mysql_query(mysql, query, false);
											
											GivePlayerMoneyEx(playerid, -price, "������� ������ ������", false, true);
											GivePlayerWeapon(playerid, WEAPON_FLOWER, 1);
											
											SendClientMessage(playerid, 0x66CC00FF, "�� ������ ����� ������");
											SendClientMessage(playerid, 0x66CC00FF, "����������� {FFCD00}/present {66CC00}����� �������� �� ���� ������");
										}
										else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 30)");
									}
									else SendClientMessage(playerid, 0xCECECEFF, "����� ����� 150 ������");
								}
								case 7:
								{
									price = 600;
									take_prods = 2;
									
									if(GetPlayerMoneyEx(playerid) >= price)
									{
										new query[175];
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
										}
										else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
										mysql_query(mysql, query, false);
										
										if(!mysql_errno())
										{
											if(GetBusinessData(businessid, B_PRODS) >= take_prods)
											{
												AddBusinessData(businessid, B_PRODS, -, take_prods);
												AddBusinessData(businessid, B_BALANCE, +, price);
											}
											
											mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price, IsBusinessOwned(businessid));
											mysql_query(mysql, query, false);
											
											GivePlayerMoneyEx(playerid, -price, "������� ������", false, true);
											GivePlayerWeapon(playerid, WEAPON_CANE, 1);
											
											SendClientMessage(playerid, 0x66CC00FF, "�� ������ ������");
										}
										else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 31)");
									}
									else SendClientMessage(playerid, 0xCECECEFF, "������ ����� 600 ������");
								}
								case 8:
								{
									price = 800;
									take_prods = 5;
									
									if(GetPlayerMoneyEx(playerid) >= price)
									{
										new query[175];
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
										}
										else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
										mysql_query(mysql, query, false);
										
										if(!mysql_errno())
										{
											if(GetBusinessData(businessid, B_PRODS) >= take_prods)
											{
												AddBusinessData(businessid, B_PRODS, -, take_prods);
												AddBusinessData(businessid, B_BALANCE, +, price);
											}
											
											mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price, IsBusinessOwned(businessid));
											mysql_query(mysql, query, false);
											
											GivePlayerMoneyEx(playerid, -price, "������� ��������", false, true);
											GivePlayerWeapon(playerid, WEAPON_PARACHUTE, 1);
											
											SendClientMessage(playerid, 0x66CC00FF, "�� ������ �������");
										}
										else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 31)");
									}
									else SendClientMessage(playerid, 0xCECECEFF, "������� ����� 800 ������");
								}
								case 9:
								{
									price = 400;
									take_prods = 2;
									
									if(GetPlayerMoneyEx(playerid) >= price)
									{
										new query[175];
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
										}
										else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
										mysql_query(mysql, query, false);
										
										if(!mysql_errno())
										{
											if(GetBusinessData(businessid, B_PRODS) >= take_prods)
											{
												AddBusinessData(businessid, B_PRODS, -, take_prods);
												AddBusinessData(businessid, B_BALANCE, +, price);
											}
											
											mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price, IsBusinessOwned(businessid));
											mysql_query(mysql, query, false);
											
											GivePlayerMoneyEx(playerid, -price, "������� ����������� ������", false, true);
											SetPlayerData(playerid, P_LOTTERY, random(900) + 100);
											
											CallLocalFunction("ShowPlayerLotteryDialog", "i", playerid);
											SendClientMessage(playerid, 0x66CC00FF, "�� ������ ���������� �����");
										}
										else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 32)");
									}
									else SendClientMessage(playerid, 0xCECECEFF, "���������� ����� ����� 400 ������");
								}
								case 10:
								{
									price = 110;
									take_prods = 1;
									
									if(!GetPlayerData(playerid, P_MASK)) 
									{
										if(GetPlayerMoneyEx(playerid) >= price)
										{
											new query[175];
											if(GetBusinessData(businessid, B_PRODS) >= take_prods)
											{
												format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
											}
											else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
											mysql_query(mysql, query, false);
											
											if(!mysql_errno())
											{
												if(GetBusinessData(businessid, B_PRODS) >= take_prods)
												{
													AddBusinessData(businessid, B_PRODS, -, take_prods);
													AddBusinessData(businessid, B_BALANCE, +, price);
												}
												
												mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price, IsBusinessOwned(businessid));
												mysql_query(mysql, query, false);
												
												GivePlayerMoneyEx(playerid, -price, "������� �����", false, true);
												SetPlayerData(playerid, P_MASK, 1);
												
												SendClientMessage(playerid, 0x66CC00FF, "�� ������ �����");
												SendClientMessage(playerid, 0x66CC00FF, "����������� {FFCD00}/mask {66CC00}��� ������� ������ ������������ �� ����� (�� 10 �����)");
											}
											else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 33)");
										}
										else SendClientMessage(playerid, 0xCECECEFF, "����� ����� 110 ������");					
									}
									else SendClientMessage(playerid, 0x999999FF, "�� ��� ��������� �����");
								}
								default:
									return 1;
							}
						}
					}				
				}
			}
			case DIALOG_BIZ_CHANGE_PHONE_NUMBER:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_SHOP_24_7))
					{
						if(response)
						{
							new buffer = strlen(inputtext);
							if((1 <= buffer <= 10) && IsNumeric(inputtext))
							{
								new fmt_str[175];
								new number = strval(inputtext);
								
								new price = 450;
								new take_prods = 3;
								
								if(number > 0)
								{
									if(inputtext[0] != '0' && buffer == 6)
									{
										new Cache: result;
										buffer = 0;
										
										format(fmt_str, sizeof fmt_str, "SELECT id FROM accounts WHERE phone=%d LIMIT 1", number);
										result = mysql_query(mysql, fmt_str, true);
										
										buffer = cache_num_rows();
										cache_delete(result);

										if(!buffer)
										{
											if(GetPlayerMoneyEx(playerid) >= price)
											{
												if(GetBusinessData(businessid, B_PRODS) >= take_prods)
												{
													format(fmt_str, sizeof fmt_str, "UPDATE accounts a,business b SET a.money=%d,a.phone=%d,b.products=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, number, GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
												}
												else format(fmt_str, sizeof fmt_str, "UPDATE accounts SET money=%d,phone=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, number, GetPlayerAccountID(playerid));
												mysql_query(mysql, fmt_str, false);
												
												if(!mysql_errno())
												{
													if(GetBusinessData(businessid, B_PRODS) >= take_prods)
													{
														AddBusinessData(businessid, B_PRODS, -, take_prods);
														AddBusinessData(businessid, B_BALANCE, +, price);
													}
													
													mysql_format(mysql, fmt_str, sizeof fmt_str, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price, IsBusinessOwned(businessid));
													mysql_query(mysql, fmt_str, false);
													
													GivePlayerMoneyEx(playerid, -price, "����� ������ ��������[1]", false, true);
													SetPlayerData(playerid, P_PHONE, number);
													
													format
													(
														fmt_str, sizeof fmt_str, 
														"{FFFFFF}����� �������� �������\n"\
														"������ � ����  ����� ��������� �� ������ {0099FF}%d", 
														GetPlayerPhone(playerid)
													);
													return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{66CC00}����� �������", fmt_str, "�������", "");
												}
												else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 26)");	
											}
											else 
											{
												return SendClientMessage(playerid, 0xCECECEFF, "������������ �����");
											}
										}
										else SendClientMessage(playerid, 0xFF6600FF, "��������� ���� ����� ��� �����");
									}
									else SendClientMessage(playerid, 0xFF6600FF, "����� ������ �����������. ��������� �������");
								}
								else 
								{
									if(GetPlayerMoneyEx(playerid) >= price)
									{
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											format(fmt_str, sizeof fmt_str, "UPDATE accounts a,business b SET a.money=%d,a.phone=%d,b.products=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid) + 1000000, GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
										}
										else format(fmt_str, sizeof fmt_str, "UPDATE accounts SET money=%d,phone=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid) + 1000000, GetPlayerAccountID(playerid));
										mysql_query(mysql, fmt_str, false);
									
										if(!mysql_errno())
										{
											if(GetBusinessData(businessid, B_PRODS) >= take_prods)
											{
												AddBusinessData(businessid, B_PRODS, -, take_prods);
												AddBusinessData(businessid, B_BALANCE, +, price);
											}
										
											mysql_format(mysql, fmt_str, sizeof fmt_str, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price, IsBusinessOwned(businessid));
											mysql_query(mysql, fmt_str, false);
											
											GivePlayerMoneyEx(playerid, -price, "����� ������ ��������[2]", false, true);
											SetPlayerData(playerid, P_PHONE, GetPlayerAccountID(playerid) + 1000000);
											
											format(fmt_str, sizeof fmt_str, "{FFFFFF}���������� ��� ����������� �����: {0099FF}%d", GetPlayerPhone(playerid));
											return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{66CC00}����� �������", fmt_str, "�������", "");
										}
										else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 26)");						
									}
									else 
									{
										return SendClientMessage(playerid, 0xCECECEFF, "������������ �����");
									}
								}
							}
						
							Dialog
							(
								playerid, DIALOG_BIZ_CHANGE_PHONE_NUMBER, DIALOG_STYLE_INPUT,
								"{66CC00}��������� ������",
								"{FFFFFF}������� ����� ����� � ���� ����\n\n"\
								"{FF6633}����������:\n"\
								"{FFCD00}- ����� ������ ���� ������������,\n"\
								"��������: 284411\n"\
								"- ����� �� ������ ���������� � 0\n\n"\
								"{FFFFFF}�� ����� ������ ������� ����\n"\
								"����������� �����. ��� �����\n"\
								"������� � ���� {3399FF}����� 0",
								"�������", "������"
							);
						}
						else cmd::buy(playerid, "");
					}
				}
			}
			case DIALOG_BIZ_CHANGE_PHONE_COLOR:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_SHOP_24_7))
					{
						if(response)
						{
							if(0 <= listitem <= 9)
							{
								new price = 200;
								new take_prods = 1;
								
								if(GetPlayerMoneyEx(playerid) >= price)
								{
									new query[185];
									
									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,a.phone_color=%d,b.products=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, listitem, GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
									}
									else format(query, sizeof query, "UPDATE accounts SET money=%d,phone_color=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, listitem, GetPlayerAccountID(playerid));
									mysql_query(mysql, query, false);
									
									if(!mysql_errno())
									{
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											AddBusinessData(businessid, B_PRODS, -, take_prods);
											AddBusinessData(businessid, B_BALANCE, +, price);
										}
										
										mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price, IsBusinessOwned(businessid));
										mysql_query(mysql, query, false);
									
										GivePlayerMoneyEx(playerid, -price, "����� ����� ��������", false, true);
										
										SetPlayerData(playerid, P_PHONE_COLOR, listitem);
										SendClientMessage(playerid, 0x3399FFFF, "�� �������� ���� ������ ���������� ��������");
									}
									else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 27)");						
								}
								else SendClientMessage(playerid, 0xCECECEFF, "��� ��������� ����� �������� ���������� 200 ������");
							}
						}
						else cmd::buy(playerid, "");
					}
				}
			}
			case DIALOG_BIZ_LOTTERY:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_SHOP_24_7))
					{
						if(response)
						{
							if(strlen(inputtext))
							{
								new number = strval(inputtext);
								if(100 <= number <= 999 && IsNumeric(inputtext))
								{
									new fmt_str[64];
									SetPlayerData(playerid, P_LOTTERY, number);
									
									format(fmt_str, sizeof fmt_str, "���������� ����� �������� �� {00CCCC}%d", number);
									SendClientMessage(playerid, 0x66CC00FF, fmt_str);
								}
								else SendClientMessage(playerid, 0xFF6600FF, "���������� ����� �� ���� ��������, �.�. ���� ������� �������");
							}
						}
					}
				}
			}
			case DIALOG_BIZ_CLUB:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_CLUB, 15.0))
					{
						if(response)
						{
							if(0 <= listitem <= 9)
							{
								new const
									item_price[10] = {60, 100, 200, 270, 300, 450, 630, 750, 50, 80};
								
								if(GetPlayerMoneyEx(playerid) >= item_price[listitem])
								{
									new query[150];
									new take_prods = 1;
									
									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-item_price[listitem], GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+item_price[listitem], GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
									}
									else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-item_price[listitem], GetPlayerAccountID(playerid));
									mysql_query(mysql, query, false);
								
									if(!mysql_errno())
									{
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											AddBusinessData(businessid, B_PRODS, -, take_prods);
											AddBusinessData(businessid, B_BALANCE, +, item_price[listitem]);
										}
										GivePlayerMoneyEx(playerid, -item_price[listitem], "������� � �����", false, true);
										GivePlayerDrinkItem(playerid, listitem);
									
										mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), item_price[listitem], IsBusinessOwned(businessid));
										mysql_query(mysql, query, false);
										
										switch(listitem+1)
										{
											case 1: Action(playerid, "�����(�) ����� ��������", 	15.0, false);
											case 2: Action(playerid, "�����(�) ������� ����", 		15.0, false);
											case 3: Action(playerid, "�����(�) ������� ����", 		15.0, false);
											case 4: Action(playerid, "�����(�) ������� �����������",15.0, false);
											case 5: Action(playerid, "�����(�) ������� �����", 		15.0, false);
											case 6: Action(playerid, "�����(�) ������� �������",	15.0, false);		
											case 7: Action(playerid, "�����(�) ������� �����", 		15.0, false);
											case 8: Action(playerid, "�����(�) ������� �������", 	15.0, false);	
											case 9: Action(playerid, "�����(�) �������", 			15.0, false);
											case 10:Action(playerid, "�����(�) ������", 			15.0, false);
										}
									}
									else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 22)");
								}
								else SendClientMessage(playerid, 0x999999FF, "� ��� �� ������� �����");
							}	
						}
					}
				}
			}
			case DIALOG_BIZ_REALTOR_BIZ_LIST:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_REALTOR_BIZ, 15.0))
					{
						if(response)
						{
							if(0 <= listitem <= MAX_BUSINESS-1)
							{
								new price = 70; //
								
								if(GetPlayerMoneyEx(playerid) >= price)
								{
									new fmt_str[300];
									GivePlayerMoneyEx(playerid, -price, "�������� ���� � ������� (���������� ����������)", true, true);
									
									businessid = g_business_realtor_list_idx[listitem];
									SetPlayerUseListitem(playerid, businessid);

									format
									(
										fmt_str, sizeof fmt_str, 
										"{FFFFFF}��������:\t\t\t%s\n"\
										"����� �������:\t\t%d\n"\
										"����� / �������:\t\t%s\n"\
										"�����:\t\t\t\t%s\n"\
										"���������:\t\t\t%d\n\n"\
										"{FFFFFF}�� ����� ������ ���������� ���������� �������.\n"\
										"��� ����� ������� ������ \"����\". {FFCD00}������ ����� 290 ���",
										GetBusinessData(businessid, B_NAME),
										businessid, 
										GetCityName(GetBusinessData(businessid, B_CITY)),
										GetZoneName(GetBusinessData(businessid, B_ZONE)),
										GetBusinessData(businessid, B_PRICE)
									);
									Dialog(playerid, DIALOG_BIZ_REALTOR_BIZ_INFO, DIALOG_STYLE_MSGBOX, "{CC9900}���������� � ��������� �������", fmt_str, "����", "�������");
								}
								else SendClientMessage(playerid, 0x999999FF, "������������ �����");
							}
						}
					}
				}
			}
			case DIALOG_BIZ_REALTOR_BIZ_INFO:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_REALTOR_BIZ, 15.0))
					{
						if(response)
						{
							new price = 290; //
							
							businessid = GetPlayerUseListitem(playerid);
							if(GetPlayerMoneyEx(playerid) >= price)
							{
								GivePlayerMoneyEx(playerid, -price, "�������� ���� ������� (���������� ����������)", true, true);
								
								TogglePlayerSpectating(playerid, true);
								ShowPlayerWaitPanel(playerid);
							
								SetPlayerVirtualWorld(playerid, playerid + 50);
								SendClientMessage(playerid, 0xFFFFFFFF, "����������� {99CC00}~k~~PED_SPRINT~ {FFFFFF}��� ������");
								
								SetPlayerData(playerid, P_REALTOR_TYPE, REALTOR_TYPE_BIZ);
								SetTimerEx("SetRealtorMakePhoto", 1000, false, "iii", playerid, REALTOR_TYPE_BIZ, businessid);
							}
							else SendClientMessage(playerid, 0x999999FF, "������������ �����");						
						}
					}
				}
			}
			case DIALOG_BIZ_REALTOR_HOME_GET:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_REALTOR_HOME, 15.0))
					{
						if(response)
						{
							new price = 50;
							new houseid = strval(inputtext);
							
							if(strlen(inputtext) && IsNumeric(inputtext) && (0 <= houseid <= g_house_loaded-1))
							{
								if(GetPlayerMoneyEx(playerid) >= price)
								{
									GivePlayerMoneyEx(playerid, -price, "�������� ���� � ���� (����������� ��������)", true, true);
								
									new fmt_str[512];
									new type = GetHouseData(houseid, H_TYPE);
									new entranceid = GetHouseData(houseid, H_ENTRACE);
									
									SetPlayerUseListitem(playerid, houseid);
									if(entranceid != -1)
									{
										format
										(
											fmt_str, sizeof fmt_str, 
											"{FFFFFF}��� / ��������:\t\t%s\n"\
											"����� ��������:\t\t%d\n"\
											"����� ��������:\t\t%d\n"\
											"����� / �������:\t\t%s\n"\
											"�����:\t\t\t\t%s\n"\
											"���������:\t\t\t%d\n"\
											"���������� ������:\t\t%d\n"\
											"������:\t\t\t\t%s\n\n"\
											"{FFFFFF}�� ������ ���������� ��� �������� ������� ���� ��������\n"\
											"��� ����� ������� ������ \"����\". {FFCD00}������ ����� 250 ������",
											GetHouseData(houseid, H_NAME),
											GetHouseData(houseid, H_FLAT_ID) + 1, 
											entranceid + 1,
											GetCityName(GetEntranceData(entranceid, E_CITY)),
											GetZoneName(GetEntranceData(entranceid, E_ZONE)),
											GetHouseData(houseid, H_PRICE),
											GetHouseTypeInfo(type, HT_ROOMS),
											IsHouseOwned(houseid) ? ("{FF6600}�������� ������") : ("{00CC33}�������� ��������")
										);
									}
									else 
									{
										format
										(
											fmt_str, sizeof fmt_str, 
											"{FFFFFF}��� / ��������:\t\t%s\n"\
											"����� ����:\t\t\t%d\n"\
											"����� / �������:\t\t%s\n"\
											"�����:\t\t\t\t%s\n"\
											"���������:\t\t\t%d\n"\
											"���������� ������:\t\t%d\n"\
											"������:\t\t\t\t%s\n\n"\
											"{FFFFFF}�� ����� ������ ���������� ��� �������� ���� ��� �������.\n"\
											"��� ����� ������� ������ \"����\". {FFCD00}������ ����� 250 ������",
											GetHouseData(houseid, H_NAME),
											houseid, 
											GetCityName(GetHouseData(houseid, H_CITY)),
											GetZoneName(GetHouseData(houseid, H_ZONE)),
											GetHouseData(houseid, H_PRICE),
											GetHouseTypeInfo(type, HT_ROOMS),
											IsHouseOwned(houseid) ? ("{FF6600}��� �����") : ("{00CC33}��� ��������")
										);
									}
									Dialog(playerid, DIALOG_BIZ_REALTOR_HOME_INFO, DIALOG_STYLE_MSGBOX, "{FF9933}���������� � ��������� ����", fmt_str, "����", "�����");
								}
								else SendClientMessage(playerid, 0x999999FF, "������������ �����");
							}
							else 
							{
								if(!(0 <= houseid <= g_house_loaded-1))
									SendClientMessage(playerid, 0xCECECEFF, "���� ��� ��� �� ���������");
								
								ShowPlayerRealtorHomeDialog(playerid);
							}
						}
					}
				}
			}
			case DIALOG_BIZ_REALTOR_HOME_INFO:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_REALTOR_HOME, 15.0))
					{
						if(response)
						{
							new price = 250; //

							if(GetPlayerMoneyEx(playerid) >= price)
							{
								GivePlayerMoneyEx(playerid, -price, "�������� ���� ���� (����������� ��������)", true, true);
								
								TogglePlayerSpectating(playerid, true);
								ShowPlayerWaitPanel(playerid);
							
								SetPlayerVirtualWorld(playerid, playerid + 3000);
								SendClientMessage(playerid, 0xFFFFFFFF, "����������� {00CC99}~k~~PED_SPRINT~ {FFFFFF}��� ������");
								
								SetPlayerData(playerid, P_REALTOR_TYPE, REALTOR_TYPE_HOUSE);
								SetTimerEx("SetRealtorMakePhoto", 1000, false, "iii", playerid, REALTOR_TYPE_HOUSE, GetPlayerUseListitem(playerid));
							}
							else SendClientMessage(playerid, 0x999999FF, "������������ �����");		
						}
						else ShowPlayerRealtorHomeDialog(playerid);
					}
				}
			}
			case DIALOG_BIZ_CLOTHING_BUY:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_CLOTHING_SHOP, 50.0))
					{
						if(response)
						{
							new select_skin = GetPlayerSelectSkin(playerid);
							if(select_skin != -1)
							{
								new price = g_business_clothing_skins[GetPlayerSex(playerid)][select_skin][1];
								new skinid = g_business_clothing_skins[GetPlayerSex(playerid)][select_skin][0];
								
								new take_prods = random(8) + 6;
								new biz_price = price * 20 / 100;
								
								if(GetPlayerMoneyEx(playerid) >= price)
								{
									new query[180];
									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										format(query, sizeof query, "UPDATE accounts a,business b SET a.skin=%d,a.money=%d,b.products=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", skinid, GetPlayerMoneyEx(playerid)-price, GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+biz_price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
									}
									else format(query, sizeof query, "UPDATE accounts SET skin=%d,money=%d WHERE id=%d LIMIT 1", skinid, GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
									mysql_query(mysql, query, false);
								
									if(!mysql_errno())
									{
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											AddBusinessData(businessid, B_PRODS, -, take_prods);
											AddBusinessData(businessid, B_BALANCE, +, biz_price);
										}
										GivePlayerMoneyEx(playerid, -price, "������� ����� (������� ������)", false, true);
										SetPlayerData(playerid, P_SKIN, skinid);
								
										ExitPlayerClothingShopPanel(playerid);
										SendClientMessage(playerid, 0x66CC00FF, "����������� � �������� ����� ������!");
	
										mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price, IsBusinessOwned(businessid));
										mysql_query(mysql, query, false);
									}
									else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 36)");
								}
								else SendClientMessage(playerid, 0x999999FF, "������������ �����");
							}
						}
					}
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_HOUSE_BUY:
			{
				new houseid = GetPlayerUseListitem(playerid);

				if(houseid >= 0 && response)
				{
					if(GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL) == -1)
					{
						if(GetPlayerHouse(playerid) == -1) 
						{
							if(IsPlayerInRangeOfHouse(playerid, houseid, 5.0))
							{
								if(!IsHouseOwned(houseid))
								{
									if(GetPlayerMoneyEx(playerid) >= GetHouseData(houseid, H_PRICE))
									{
										SendClientMessage(playerid, 0xFFFFFFFF, "�����������! �� ��������� ���");
										BuyPlayerHouse(playerid, houseid);
										
										EnterPlayerToHouse(playerid, houseid);
										PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
										
										GameTextForPlayer(playerid, "~b~welcome ~g~to~n~~y~new ~w~home!", 4000, 1);
										Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{3399FF}����� ���", "{FFFFFF}��� ����� ��������� �� ��� � ��������� ���������� ����� {FFCD00}(/gps)", "��", "");
									}
									else SendClientMessage(playerid, 0xCECECEFF, "� ��� ������������ ����� ��� ������� ����� ����");
								}
								else
								{
									new fmt_str[64];
									
									format(fmt_str, sizeof fmt_str, "���� ��� ��� ������. ��������: %s", GetHouseData(houseid, H_OWNER_NAME));
									SendClientMessage(playerid, 0xCECECEFF, fmt_str);
								}	
							}
						}
						else SendClientMessage(playerid, 0xCECECEFF, "� ��� ��� ���� ���. ����� ������ ����� - ���������� ������� ������");				
					}
					else SendClientMessage(playerid, 0xCECECEFF, "�� �������� ����� � ���������. ����� ���������� ����� �������� ����");
				}
			}
			case DIALOG_HOUSE_SELL:
			{
				new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
				if(houseid != -1)
				{
					if(response)
					{
						SellHouse(playerid);
					}
				}
			}
			case DIALOG_HOUSE_INFO:
			{
				if(response)
				{
					new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
					if(houseid != -1)
					{
						ShowPlayerHouseDialog(playerid, HOUSE_OPERATION_PARAMS);
					}
				}
			}
			case DIALOG_HOUSE_PARAMS:
			{
				new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
				if(houseid != -1)
				{
					if(response)
					{
						ShowPlayerHouseDialog(playerid, listitem + 1);
					}
					else cmd::home(playerid, "");
				}
			}
			case DIALOG_HOUSE_IMPROVEMENTS:
			{
				new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
				if(houseid != -1)
				{
					if(response)
					{
						if(0 <= listitem <= sizeof g_house_improvements - 1)
						{
							new i_level = GetHouseData(houseid, H_IMPROVEMENTS);
							new i_price = g_house_improvements[listitem][I_PRICE];
							
							if(i_level >= sizeof g_house_improvements)
							{
								SendClientMessage(playerid, 0x999999FF, "�� ��� ��������� ��� ��������� ��������� ��� ����");
							}
							else if(i_level < listitem)
							{
								SendClientMessage(playerid, 0xCECECEFF, "���� ������� ��������� ���� ����������");
							}
							else if(i_level > listitem) 
							{
								SendClientMessage(playerid, 0xCECECEFF, "�� ��� ������ ���� ������� ���������");
							}
							else if(GetPlayerMoneyEx(playerid) < i_price)
							{
								new fmt_str[64];
								
								format(fmt_str, sizeof fmt_str, "��� ������� %d ������ ��������� ���������� %d ������", listitem + 1, i_price);
								SendClientMessage(playerid, 0xCECECEFF, fmt_str);
							}
							else 
							{
								new fmt_str[128];
								
								format(fmt_str, sizeof fmt_str, "UPDATE accounts a, houses h SET a.money=%d, h.improvements=%d WHERE a.id=%d AND h.id=%d", GetPlayerMoneyEx(playerid)-i_price, i_level + 1, GetPlayerAccountID(playerid), GetHouseData(houseid, H_SQL_ID));
								mysql_query(mysql, fmt_str, false);
								
								if(!mysql_errno())
								{
									GivePlayerMoneyEx(playerid, -i_price, "������� ��������� ��� ����", false, true);
								
									format(fmt_str, sizeof fmt_str, "�� �������� ���� ��� �� {FFCD00}%s {3399FF}������", GetNumericName(listitem + 1));
									SendClientMessage(playerid, 0x3399FFFF, fmt_str);
									
									AddHouseData(houseid, H_IMPROVEMENTS, +, 1);
									switch(listitem + 1)
									{
										case 1:
										{
											SendClientMessage(playerid, 0x66CC00FF, "������ ����� ����� �� ���� ���������� ������ {FF9900}~k~~SNEAK_ABOUT~{66CC00}, ���� � �����");
											SendClientMessage(playerid, 0x999999FF, "�������������� ����� �������� ����� � ����� ����");
										}
										case 2:
										{
											SendClientMessage(playerid, 0x66CC00FF, "������ � ���� ������ ����� �������� �������");
											SendClientMessage(playerid, 0x999999FF, "�� � ���� ����� � ����� ������ ������ ������������ ��");
										
											HouseHealthInit(houseid);
										}
										case 3:
										{
											SendClientMessage(playerid, 0x66CC00FF, "�� ������ ��������� ����� ��������� � ����� ���� � ������� ������� {FF9900}/live");
											SendClientMessage(playerid, 0x999999FF, "� ���� ����� ������������ ������� ������, ������� � ��� ������");
										}
										case 4:
										{
											SendClientMessage(playerid, 0x66CC00FF, "�� ���� ��� ���� ��������� ��������, ������� ���� ����� ������� ���������� ����������");
											SendClientMessage(playerid, 0x999999FF, "��������� �����, ���������� ���������� ��������� � 2 ����");
										}
										case 5:
										{
											SendClientMessage(playerid, 0x66CC00FF, "����������� {3399FF}/makestore {66CC00}��� ���������� �����. � ��� ����� ����� ������� ��������� ����");
											SendClientMessage(playerid, 0x999999FF, "� ����� ������ ����� ��������� ���� �� ������ �����. ��� �������� ����� �������� {3399FF}/use");
										
											HouseStoreInit(houseid);
										}
										/*
										case 6:
										{
											// ����
										}
										case 7:
										{
											// ������������
										}
										*/
									}
								}
								else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 35)");
							}
						}
					}
					ShowPlayerHouseDialog(playerid, HOUSE_OPERATION_PARAMS);
				}
			}
			case DIALOG_HOUSE_RENTERS:
			{	
				new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
				if(houseid != -1)
				{
					if(response)
					{	
						if(0 <= listitem <= MAX_HOUSE_ROOMS-1)
						{
							new room = GetPlayerListitemValue(playerid, listitem);
							ShowHouseRenterInfo(playerid, houseid, room);
						}
					}
					else ShowPlayerHouseDialog(playerid, HOUSE_OPERATION_PARAMS);
				}
			}
			case DIALOG_HOUSE_RENTER_INFO:
			{
				new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
				if(houseid != -1)
				{
					if(response)
					{	
						new room = GetPlayerUseListitem(playerid);
						if(IsHouseRoomOwned(houseid, room))
						{
							switch(listitem + 1)
							{
								case 4:
								{
									new fmt_str[95];
									format
									(
										fmt_str, sizeof fmt_str, 
										"{FFFFFF}�� ������������� ������ �������� {FFCD00}%s {FFFFFF}�� ������ ����?", 
										GetHouseRenterInfo(houseid, room, HR_OWNER_NAME)
									);
									return Dialog(playerid, DIALOG_HOUSE_RENTER_EVICT, DIALOG_STYLE_MSGBOX, "{33AACC}��������� ����������", fmt_str, "��", "���");
								}
							}
							ShowHouseRenterInfo(playerid, houseid, room);
						}
						else SendClientMessage(playerid, 0x999999FF, "� ���� ������� ��� ����� �� ���������");
					}
					else ShowPlayerHouseDialog(playerid, HOUSE_OPERATION_PARAMS);
				}
			}
			case DIALOG_HOUSE_RENTER_EVICT:
			{
				new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
				if(houseid != -1)
				{
					if(response)
					{
						new room = GetPlayerUseListitem(playerid);
						if(IsHouseRoomOwned(houseid, room))
						{
							new fmt_str[64];
							
							format(fmt_str, sizeof fmt_str, "�� �������� %s �� ������ ����", GetHouseRenterInfo(houseid, room, HR_OWNER_NAME));
							SendClientMessage(playerid, 0x66CC00FF, fmt_str);
							
							EvictHouseRenter(houseid, room, playerid);
						}
						else SendClientMessage(playerid, 0x999999FF, "� ���� ������� ��� ����� �� ���������");
					}
					else ShowPlayerHouseDialog(playerid, HOUSE_OPERATION_PARAMS);
				}
			}
			case DIALOG_HOUSE_EVICT:
			{
				new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
				if(houseid != -1)
				{
					if(response)
					{
						new roomid = GetPlayerData(playerid, P_HOUSE_ROOM);
						new owner_id = GetPlayerID(GetHouseData(houseid, H_OWNER_NAME));
						
						EvictHouseRenter(houseid, roomid, playerid);
						
						if(owner_id != INVALID_PLAYER_ID)
						{
							new fmt_str[45 + 1];
							
							format(fmt_str, sizeof fmt_str, "%s ��������� �� ������ ����", GetPlayerNameEx(playerid));
							SendClientMessage(owner_id, 0x66CC00FF, fmt_str);
						}
						SendClientMessage(playerid, 0x66CC00FF, "�� ���������� �� ����");
					}
				}
			}
			case DIALOG_HOUSE_MOVE_STORE:
			{
				new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
				if(houseid != -1)
				{
					if(response)
					{
						if(GetPlayerInHouse(playerid) == houseid)
						{
							if(GetHouseData(houseid, H_IMPROVEMENTS) >= 5)
							{
								new type = GetHouseData(houseid, H_TYPE);
								if(IsPlayerInRangeOfPoint(playerid, 50.0, GetHouseTypeInfo(type, HT_ENTER_POS_X), GetHouseTypeInfo(type, HT_ENTER_POS_Y), GetHouseTypeInfo(type, HT_ENTER_POS_Z)))
								{
									if(GetHouseData(houseid, H_STORE_LABEL) != Text3D:-1)
									{
										new query[128];
										
										new Float: pos_x, Float: pos_y, Float: pos_z;
										GetPlayerPos(playerid, pos_x, pos_y, pos_z);
										
										SetHouseData(houseid, H_STORE_X, pos_x);
										SetHouseData(houseid, H_STORE_Y, pos_y);
										SetHouseData(houseid, H_STORE_Z, pos_z);
										
										DestroyDynamic3DTextLabel(GetHouseData(houseid, H_STORE_LABEL));
										SetHouseData(houseid, H_STORE_LABEL, Text3D:-1);
										
										HouseStoreInit(houseid);
										
										format(query, sizeof query, "UPDATE houses SET store_x=%f,store_y=%f,store_z=%f WHERE id=%d LIMIT 1", pos_x, pos_y, pos_z, GetHouseData(houseid, H_SQL_ID));
										mysql_tquery(mysql, query, "", "");
									}
								}
							}
						}
					}
				}
			}
			
			case DIALOG_HOUSE_ENTER:
			{
				new houseid = GetPlayerUseListitem(playerid);
	
				if(houseid >= 0 && response)
				{
					if(GetPlayerInHouse(playerid) == -1)
					{
						if(!GetHouseData(houseid, H_LOCK_STATUS) || GetPlayerHouse(playerid, HOUSE_TYPE_HOME) == houseid)
						{
							EnterPlayerToHouse(playerid, houseid);
						}
						else GameTextForPlayer(playerid, "~r~Closed", 3000, 1);
					}
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_ENTRANCE_LIFT:
			{
				if(response)
				{
					new entranceid = GetPlayerInEntrance(playerid);
					if(entranceid != -1)
					{
						new floor = GetPlayerInEntranceFloor(playerid);
						if(floor != -1)
						{
							if(0 <= listitem <= MAX_ENTRANCE_FLOORS-1)
							{
								new to_floor = GetPlayerListitemValue(playerid, listitem);
								if(!to_floor)
								{
									SetPlayerPosEx(playerid, 25.8020, 1403.7086, 1508.4100, 90.0, 1, entranceid + 2500);
								}
								else SetPlayerPosEx(playerid, 11.0535, 1373.1038, 1508.4100, 180.0, to_floor + 1, (entranceid * 100) + to_floor);
								
								SetPlayerInEntranceFloor(playerid, to_floor);
							}
						}
					}
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_HOTEL:
			{
				if(response)
				{
					new hotel_id = GetPlayerInHotelID(playerid);
					if(hotel_id != -1)
					{
						switch(listitem + 1)
						{
							case 1:
							{
								ShowPlayerHotelFloorsInfo(playerid, hotel_id);
							}
							case 2:
							{
								if(GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL) == -1)
								{
									new free_room = GetHotelFreeRoom(hotel_id);
									if(free_room != -1)
									{
										SetPlayerUseListitem(playerid, free_room);
										
										new fmt_str[128];
										format
										(
											fmt_str, sizeof fmt_str, 
											"{FFFFFF}�� ���������� ��� ���������� � ������ %d �� %d �����\n"\
											"����������� ����� 1000 ������. �� �������?", 
											(free_room % 12) + 1,
											(free_room / 12) + 1
										);
										Dialog(playerid, DIALOG_HOTEL_REG_ROOM, DIALOG_STYLE_MSGBOX, "{66CC99}������������� �����������", fmt_str, "�������", "�����");
									}
									else
									{
										Dialog
										(
											playerid, DIALOG_HOTEL_FLOOR_INFO, DIALOG_STYLE_MSGBOX,
											"{66CC99}��������� ������",
											"{FFFFFF}� ���� ��������� ��� ��������� �������", 
											"�����", "�������"
										);
									}
								}
								else 
								{
									Dialog
									(
										playerid, DIALOG_HOTEL_FLOOR_INFO, DIALOG_STYLE_MSGBOX,
										"{66CC99}�����������",
										"{FFFFFF}�� ��� �������� ����� � ���������", 
										"�����", "�������"
									);
								}
							}
							case 3:
							{
								ShowPlayerHotelClientMenu(playerid, hotel_id);
							}
						}
					}
				}
			}
			case DIALOG_HOTEL_FLOOR_SELECT:
			{
				new hotel_id = GetPlayerInHotelID(playerid);
				if(hotel_id != -1)
				{
					if(response)
					{
						ShowPlayerHotelFloorInfo(playerid, hotel_id, listitem);
					}
					else ShowPlayerHotelDialog(playerid);
				}
			}
			case DIALOG_HOTEL_FLOOR_INFO:
			{
				if(response)
				{
					ShowPlayerHotelDialog(playerid);
				}
			}
			case DIALOG_HOTEL_FLOOR_LIFT:
			{
				if(response)
				{
					new hotel_id = GetPlayerInHotelID(playerid);
					if(hotel_id != -1)
					{
						new max_floors = g_hotel_rooms_loaded[hotel_id] / 12;
						if(0 <= listitem <= max_floors-1)
						{
							new to_floor = GetPlayerListitemValue(playerid, listitem);
							
							if(!to_floor)
							{
								new businessid = GetPlayerInBiz(playerid);
								new type = GetBusinessData(businessid, B_INTERIOR);
				
								SetPlayerPosEx(playerid, 730.1479, 599.7930, 1002.9598, 89.9507, GetBusinessInteriorInfo(type, BT_ENTER_INTERIOR), businessid + 255);
							}
							else SetPlayerPosEx(playerid, 1276.0446, -773.2361, 1202.7220, 360.0, to_floor, ((hotel_id + 1) * 200) + (to_floor + 1000));
							
							SetPlayerData(playerid, P_IN_HOTEL_FLOOR, to_floor);
						}
					}
				}	
			}
			case DIALOG_HOTEL_REG_ROOM:
			{
				new hotel_id = GetPlayerInHotelID(playerid);
				if(hotel_id != -1)
				{
					if(response)
					{
						new room_id = GetPlayerUseListitem(playerid);
						new businessid = GetPlayerInBiz(playerid);
						
						if(GetPlayerHouse(playerid) == -1) 
						{
							if(!IsHotelRoomOwned(hotel_id, room_id))
							{
								new price = 1000;
								new take_prods = 2;
								
								if(GetPlayerMoneyEx(playerid) >= price)
								{
									new query[300];
									new time = gettime();
									new rent_time = (time - (time % 86400)) + 86400;
									
									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										format(query, sizeof query, "UPDATE accounts a,hotels h,business b SET a.money=%d,a.house_type=%d,a.house_room=%d,a.house=%d,h.owner_id=%d,h.rent_time=%d,h.status=0,b.products=%d,b.balance=%d WHERE a.id=%d AND h.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, HOUSE_TYPE_HOTEL, room_id, hotel_id, GetPlayerAccountID(playerid), rent_time, GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetHotelData(hotel_id, room_id, H_SQL_ID),GetBusinessData(businessid, B_SQL_ID));
									}
									else format(query, sizeof query, "UPDATE accounts a, hotels h SET a.money=%d,a.house_type=%d,a.house_room=%d,a.house=%d,h.owner_id=%d,h.rent_time=%d,h.status=0 WHERE a.id=%d AND h.id=%d", GetPlayerMoneyEx(playerid)-price, HOUSE_TYPE_HOTEL, room_id, hotel_id, GetPlayerAccountID(playerid), rent_time, GetPlayerAccountID(playerid), GetHotelData(hotel_id, room_id, H_SQL_ID));
									mysql_query(mysql, query, false);
								
									if(!mysql_errno())
									{						
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											AddBusinessData(businessid, B_PRODS, -, take_prods);
											AddBusinessData(businessid, B_BALANCE, +, price);
										}
										SetPlayerData(playerid, P_HOUSE, hotel_id);
										SetPlayerData(playerid, P_HOUSE_ROOM, room_id);
										SetPlayerData(playerid, P_HOUSE_TYPE, HOUSE_TYPE_HOTEL);
										
										SetHotelData(hotel_id, room_id, H_OWNER_ID, 	GetPlayerAccountID(playerid));
										SetHotelData(hotel_id, room_id, H_RENT_DATE, 	rent_time);
										SetHotelData(hotel_id, room_id, H_STATUS, 		false);
										
										format(g_hotel[hotel_id][room_id][H_OWNER_NAME], 21, GetPlayerNameEx(playerid), 0);
										
										GivePlayerMoneyEx(playerid, -price, "������� ������ � �����", false, true);
										EnterPlayerToHotelRoom(playerid, hotel_id, room_id);
										
										SendClientMessage(playerid, 0x3399FFFF, "�� ����� ����� � ���������");
										SendClientMessage(playerid, 0x66CC00FF, "���������: �������� ���������� ����� �� ������ ����� � ��������������� ������");
										SendClientMessage(playerid, 0xFFFFFFFF, "������� {66CC99}~k~~SNEAK_ABOUT~ {FFFFFF}��� ������ �� ������");
									
										mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price, IsBusinessOwned(businessid));
										mysql_query(mysql, query, false);
									}
									else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 37)");
								}
								else SendClientMessage(playerid, 0x999999FF, "� ��� ������������ ����� ����� ����� ���� �����");
							}
							else SendClientMessage(playerid, 0xFF6600FF, "��������, �� ���� ����� ��� �����");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "� ��� ���� �����. ����� ������� ��� ����� �������� ������");
					}
					else ShowPlayerHotelDialog(playerid);
				}
			}
			case DIALOG_HOTEL_CLIENT_MENU:
			{
				new hotel_id = GetPlayerInHotelID(playerid);
				if(hotel_id == GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL))
				{
					if(response)
					{
						switch(listitem + 1)
						{
							case 1: // �������� ����������
							{
								ShowPlayerHotelRoomPayForRent(playerid);
							}
							case 2: // ���������� � ����������
							{
								new vehicleid = GetPlayerOwnableCar(playerid);
								if(vehicleid != INVALID_VEHICLE_ID)
								{
									new model_id = GetVehicleData(vehicleid, V_MODELID);
									if(model_id)
									{
										new fmt_str[64];
										new index = GetVehicleData(vehicleid, V_ACTION_ID);
										
										format(fmt_str, sizeof fmt_str, "������: %s (����� ������ %d)", GetVehicleName(vehicleid), model_id);
										SendClientMessage(playerid, 0x99FF66FF, fmt_str);

										if(!(GetOwnableCarData(index, OC_COLOR_1) == -1 || GetOwnableCarData(index, OC_COLOR_2) == -1))
										{
											format(fmt_str, sizeof fmt_str, "���� 1: ID %d   ���� 2: ID %d", GetOwnableCarData(index, OC_COLOR_1), GetOwnableCarData(index, OC_COLOR_2));
											SendClientMessage(playerid, 0x99FF66FF, fmt_str);
										}
										else SendClientMessage(playerid, 0x99FF66FF, "����� ����������: ���������");

										format(fmt_str, sizeof fmt_str, "���. ���������: %d ���", GetVehicleInfo(model_id - 400, VI_PRICE));
										SendClientMessage(playerid, 0x99FF66FF, fmt_str);								
									}
								}
								else SendClientMessage(playerid, 0x999999FF, "� ��� ��� ������� ����������");
							}
							case 3: // �������� ��������� �� GPS
							{
								cmd::getmycar(playerid, "");
							}
							case 4: // ��������� ��������� � ����� (1000 ���)
							{
								new vehicleid = GetPlayerOwnableCar(playerid);
								if(vehicleid != INVALID_VEHICLE_ID)
								{
									if(!SetVehicleToHotelRespawn(hotel_id, vehicleid))
									{
										SendClientMessage(playerid, 0xCECECEFF, "� ������ ������ �� �� ������ ������������ ��� �������");
									}
								}
								else SendClientMessage(playerid, 0x999999FF, "� ��� ��� ������� ����������");
							}
							case 5: // ������� ���������
							{
								cmd::sellcar(playerid, "");
							}
							case 6: // ���������� �� �����
							{
								Dialog
								(
									playerid, DIALOG_HOTEL_OUT, DIALOG_STYLE_MSGBOX, 
									"{66CC99}���������", 
									"{FFFFFF}�� ������� ��� ������ ���������� �� �����?", 
									"��", "���"
								);
							}
							default:
								return 1;
						}
					}
					else ShowPlayerHotelDialog(playerid);
				}
			}
			case DIALOG_HOTEL_PAY_FOR_ROOM:
			{
				new hotel_id = GetPlayerInHotelID(playerid);
				new room_id = GetPlayerData(playerid, P_HOUSE_ROOM);
				
				if(hotel_id == GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL))
				{
					if(response)
					{
						new days = strval(inputtext);
						if(days > 0 && IsNumeric(inputtext))
						{
							new fmt_str[128 + 1];
						
							new time = gettime();
							new rent_time = GetHotelData(hotel_id, room_id, H_RENT_DATE);
						
							new rent_days = GetElapsedTime(rent_time, time, CONVERT_TIME_TO_DAYS);
							new total_price = days * 1000;

							if((rent_days + days) <= 30)
							{
								if(GetPlayerBankMoney(playerid) >= total_price)
								{
									rent_time = (rent_time - (rent_time % 86400)) + (days * 86400);
								
									format(fmt_str, sizeof fmt_str, "UPDATE accounts a, hotels h SET a.bank=%d,h.rent_time=%d WHERE a.id=%d AND h.id=%d", GetPlayerBankMoney(playerid)-total_price, rent_time, GetPlayerAccountID(playerid), GetHotelData(hotel_id, room_id, H_SQL_ID));
									mysql_query(mysql, fmt_str, false);
									
									if(!mysql_errno())
									{
										AddPlayerData(playerid, P_BANK, -, total_price);
										SetHotelData(hotel_id, room_id, H_RENT_DATE, rent_time);
									
										format(fmt_str, sizeof fmt_str, "� ����������� ����� ����� {3399FF}%d ���", total_price);
										SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
										
										format(fmt_str, sizeof fmt_str, "�� ������� ���������� � ����� ��� �� {3399FF}%d ����", days);
										SendClientMessage(playerid, 0x66CC00FF, fmt_str);
									}
								}
								else 
								{
									SendClientMessage(playerid, 0xB5B500FF, "�� �������� ���������� ����� �� ������� ����� ��� ������");
									
									format(fmt_str, sizeof fmt_str, "��� ��������� ������ �� %d ���� ���������� %d ���", days, total_price);
									SendClientMessage(playerid, 0x999999FF, fmt_str);
								}
							}
							else SendClientMessage(playerid, 0xB5B500FF, "�� �� ������ �������� �� ������ ������ ��� �� 30 ����");
						}
						ShowPlayerHotelRoomPayForRent(playerid);
					}
					else ShowPlayerHotelClientMenu(playerid, hotel_id);
				}
			}
			case DIALOG_HOTEL_OUT:
			{	
				new hotel_id = GetPlayerInHotelID(playerid);
				new room_id = GetPlayerData(playerid, P_HOUSE_ROOM);
				
				if(hotel_id == GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL))
				{
					if(response)
					{
						new query[155];
						
						format(query, sizeof query, "UPDATE accounts a,hotels h SET a.house_type=-1,a.house_room=-1,a.house=-1,h.owner_id=0,h.rent_time=0 WHERE a.id=%d AND h.id=%d", GetPlayerAccountID(playerid), GetHotelData(hotel_id, room_id, H_SQL_ID));
						mysql_query(mysql, query, false);
						
						if(!mysql_errno())
						{
							SetPlayerData(playerid, P_HOUSE, 		-1);
							SetPlayerData(playerid, P_HOUSE_ROOM, 	-1);
							SetPlayerData(playerid, P_HOUSE_TYPE, 	-1);
							
							SetHotelData(hotel_id, room_id, H_OWNER_ID, 	0);
							SetHotelData(hotel_id, room_id, H_RENT_DATE, 	0);
							SetHotelData(hotel_id, room_id, H_STATUS, 		false);
						
							SendClientMessage(playerid, 0x3399FFFF, "�� ���������� �� �����");
						}
					}
					else ShowPlayerHotelClientMenu(playerid, hotel_id);
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_OWNABLE_CAR:
			{
				if(response)
				{
					new vehicleid = GetPlayerOwnableCar(playerid);
					if(vehicleid != INVALID_VEHICLE_ID)
					{
						switch(listitem + 1)
						{
							case 1: // ������� / �������
							{
								cmd::lock(playerid, "1");
							}
							case 2: // �������� / �������� �����
							{
								cmd::key(playerid, "");
							}
							case 3: // �������� ��������� �� GPS 
							{
								cmd::getmycar(playerid, "");
							}
							case 4: // ���������� ���������
							{
								ShowTrunkDialog(playerid, vehicleid, true);
							}
							case 5: // ��������� �� ���������
							{
								ShowOwnableCarPass(playerid, vehicleid);
							}
							case 6: // ������������ ���������
							{
								cmd::park(playerid, "");
							}
							default: 
								return 1;
						}
						//cmd::car(playerid, "");
					}
				}
			}
			case DIALOG_OWNABLE_CAR_SELL:
			{
				if(response)
				{
					new vehicleid = GetPlayerOwnableCar(playerid);
					if(vehicleid != INVALID_VEHICLE_ID)
					{
						if(DestroyOwnableCar(vehicleid))
						{
							new fmt_str[128];
						
							new model_id = GetVehicleData(vehicleid, V_MODELID);
							new car_price = GetVehicleInfo(model_id-400, VI_PRICE);
							new percent = car_price * 20 / 100;
							new price = car_price - percent;
							
							SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);
							AddPlayerData(playerid, P_BANK, +, price);
							
							format(fmt_str, sizeof fmt_str, "UPDATE accounts SET bank=%d WHERE id=%d LIMIT 1", GetPlayerBankMoney(playerid), GetPlayerAccountID(playerid));
							mysql_query(mysql, fmt_str, false);
							
							SendClientMessage(playerid, 0x3399FFFF, "�� ������� ������ ���������");
							
							format(fmt_str, sizeof fmt_str, "��������� ���� ���������� 20 ��������� �� ��� ��������� {FF9900}(%d ���)", percent);
							SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
							
							format(fmt_str, sizeof fmt_str, "�� �������� ���������� ���� ���������� {FFFF00}%d ���", price);
							SendClientMessage(playerid, 0x66CC00FF, fmt_str);
							
							format(fmt_str, sizeof fmt_str, "~g~+%d rub", price);
							GameTextForPlayer(playerid, fmt_str, 4000, 1);
						}
					}
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_VEHICLE_TRUNK:
			{
				new vehicleid = GetPlayerUseTrunk(playerid);
				
				if(response && vehicleid != INVALID_VEHICLE_ID)
				{
					if(0 <= listitem <= MAX_VEHICLE_TRUNK_SLOTS)
					{
						new TODO_THIS_NOW_________;
					}
				}
			}
			case DIALOG_VEHICLE_TRUNK_PUT:
			{
				new vehicleid = GetPlayerUseTrunk(playerid);
				
				if(response && vehicleid != INVALID_VEHICLE_ID)
				{
					new TODO_THIS_NOW_________;
					
					ShowTrunkDialog(playerid, vehicleid, false);
				}
			}
			// -----------------------------------------------------------------
		}
	}
	return 1;
}

stock DestroyOwnableCar(vehicleid)
{
	if(IsAOwnableCar(vehicleid))
	{
		new query[64];
		new index = GetVehicleData(vehicleid, V_ACTION_ID);
		
		format(query, sizeof query, "DELETE FROM ownable_cars WHERE id=%d LIMIT 1", GetOwnableCarData(index, OC_SQL_ID));
		mysql_query(mysql, query, false);
		
		if(!mysql_errno())
		{
			SetOwnableCarData(index, OC_SQL_ID, 	0);
			SetOwnableCarData(index, OC_OWNER_ID, 	0);
			
			DestroyVehicle(vehicleid);
			return 1;
		}
		else printf("[Error]: [OwnableCars]: ������ �������� ������� ��: %d", GetOwnableCarData(index, OC_SQL_ID));
	}
	return 0;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if(IsPlayerLogged(playerid))
	{
		if(GetPlayerPhone(playerid))
		{
			new fmt_str[5];
			
			valstr(fmt_str, clickedplayerid);
			cmd::add(playerid, fmt_str);
		}
	}
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	/*
    new fmt_str[64];
	format(fmt_str, sizeof fmt_str, "%f, %f, %f", fX, fY, fZ);
	SendClientMessage(playerid, -1, fmt_str);
	*/
    return 1;
}

/*
	���������� ����� ���������� �������. � ��� ����� ������� ������� ���������� �������.
	��� ���� � ������� return 1/0 ����� ���������/��������� ���������� �������.
*/
public OnPlayerCommandReceived(playerid, cmdtext[])
{
	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, FLOOD_RATE_INC);
	
	if(!IsPlayerLogged(playerid)) return 0;
	if(GetPlayerAntiFloodData(playerid, AF_RATE) >= MAX_FLOOD_RATE)
	{
		SendClientMessage(playerid, 0x6B6B6BFF, "�� �������");

		if(GetPlayerAntiFloodData(playerid, AF_RATE) >= MAX_FLOOD_RATE + 500)
			SendClientMessage(playerid, 0x6B6B6BFF, "����������, ��������� ��������� ������...");

		return 0;
	}
	
	/*
    if(PlayerInfo[playerid][pMute] == 1) // ���� � ������ ������� (/mute)
    {
        SendClientMessage(playerid, -1, "��������� ��������� �������� ��������!");
        return 0; // �������� �������, ����� �� �� �������� �������
    }
	*/
    return 1; // ��������� ���������� �������
}  

/*
	���������� ����� ���������� �������.
	��� ���� ���� success = 1 - ������� ����������� �������, success = 0 - � �������, success = -1 - ������� �� �������.
	����� ������� ����� �������������� ������� ��������� ����������� ������:
*/
public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	if(success == -1)
	{
		CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, FLOOD_RATE_INC);
	
		if(GetPlayerAntiFloodData(playerid, AF_RATE) >= MAX_FLOOD_RATE)
		{
			SendClientMessage(playerid, 0x6B6B6BFF, "�� �������");

			if(GetPlayerAntiFloodData(playerid, AF_RATE) >= MAX_FLOOD_RATE + 500)
				SendClientMessage(playerid, 0x6B6B6BFF, "����������, ��������� ��������� ������...");

			return 0;
		}	
	}
	
	/*
    if(success == -1) // ���� ������� �� �������
    {
        return OnPlayerCommandText(playerid, cmdtext);
    }
	*/
    return 1; // ��������� ���������� �������
}  

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == Text:INVALID_TEXT_DRAW)
	{
		if(GetPlayerPinCodeState(playerid) != PIN_CODE_STATE_NONE)
		{
			HidePlayerPinCodePTD(playerid);
			if(!IsPlayerLogged(playerid))
			{
				Kick:(playerid);
			}
		}
		switch(GetPlayerData(playerid, P_USE_SELECT_PANEL))
		{
			case SELECT_PANEL_TYPE_CLOTHING:
			{
				ExitPlayerClothingShopPanel(playerid);
			}
			case SELECT_PANEL_TYPE_REG_SKIN:
			{
				if(!IsPlayerLogged(playerid))
				{
					if(GetPlayerData(playerid, P_ACCOUNT_STATE) == ACCOUNT_STATE_REG_SKIN)
					{
						SelectTextDraw(playerid, 0x009900FF);
					}
				}
			}
		}
	}
	if(select_TD[0] <= clickedid <= select_TD[3])
	{
		new use_type = GetPlayerData(playerid, P_USE_SELECT_PANEL);
		if(use_type != SELECT_PANEL_TYPE_NONE)
		{
			new buffer = 0;
			new index = _:(clickedid - select_TD[0]);
			
			switch(index)
			{
				case 0: // �������
				{
					switch(use_type)
					{
						case SELECT_PANEL_TYPE_CLOTHING:
						{
							buffer = GetPlayerSelectSkin(playerid);
							if(buffer != -1)
							{
								Dialog
								(
									playerid, DIALOG_BIZ_CLOTHING_BUY, DIALOG_STYLE_MSGBOX,
									"{FFCD00}������� ������", 
									"{FFFFFF}�� ������������� ������ ���������� ���� ����� ������?",
									"��", "���"
								);
							}
						}
						case SELECT_PANEL_TYPE_REG_SKIN:
						{
							if(!IsPlayerLogged(playerid))
							{
								if(GetPlayerData(playerid, P_ACCOUNT_STATE) == ACCOUNT_STATE_REG_SKIN)
								{
									new sex = GetPlayerSex(playerid);
									buffer = GetPlayerSelectSkin(playerid);
									
									if(buffer != -1)
									{
										SetPlayerData(playerid, P_SKIN, reg_skin_data[sex][buffer]);
									
										new query[90];
										format(query, sizeof query, "UPDATE accounts SET skin=%d,last_login=%d WHERE id=%d LIMIT 1", GetPlayerSkinEx(playerid), gettime(), GetPlayerAccountID(playerid));
										mysql_query(mysql, query, false);
										
										if(!mysql_errno())
										{
											SetPlayerData(playerid, P_MONEY, 500);
											SetPlayerData(playerid, P_SELECT_SKIN, -1);
											
											HidePlayerSelectPanel(playerid);
											HidePlayerSelectPanelPrice(playerid);
											
											SetPlayerSpawnInit(playerid);
											SpawnPlayer(playerid);
									
											RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_FOREARM);
											SetPlayerInit(playerid);
										
											SendClientMessage(playerid, 0xFFFF00FF, "����������� ��������� ������ {FF3300}������ �� ����.{FFFF00} �� ��������� ������ �� ���");
											SendClientMessage(playerid, 0xFFFF00FF, "� ��� �� ������� ��� ������������ ��� ����������. ����� � �������� ����!");
											
											return 1;
										}
										else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 01)");
									}
								}
							}
						}
					}
				}
				case 1: // ������
				{
					switch(use_type)
					{
						case SELECT_PANEL_TYPE_CLOTHING:
						{
							buffer = GetPlayerSelectSkin(playerid);
							if(!(0 <= ++buffer <= sizeof g_business_clothing_skins[] - 1))
							{
								buffer = 0;
							}
							SetPlayerSelectClothingSkin(playerid, buffer);
						}
						case SELECT_PANEL_TYPE_REG_SKIN:
						{
							if(!IsPlayerLogged(playerid))
							{
								if(GetPlayerData(playerid, P_ACCOUNT_STATE) == ACCOUNT_STATE_REG_SKIN)
								{
									new sex = GetPlayerSex(playerid);
									buffer = GetPlayerSelectSkin(playerid);
									
									if(!(0 <= ++buffer <= sizeof(reg_skin_data[])-1))
									{
										buffer = 0;
									}
									else if(!reg_skin_data[sex][buffer])
									{
										buffer = 0;
									}
									SetPlayerSelectSkin(playerid, buffer, reg_skin_data[sex][buffer]);
								}
							}
						}
					}
				}
				case 2: // �����
				{
					switch(use_type)
					{
						case SELECT_PANEL_TYPE_CLOTHING:
						{
							buffer = GetPlayerSelectSkin(playerid);
							if(!(0 <= --buffer <= sizeof g_business_clothing_skins[] - 1))
							{
								buffer = sizeof g_business_clothing_skins[] - 1;
							}
							SetPlayerSelectClothingSkin(playerid, buffer);
						}
						case SELECT_PANEL_TYPE_REG_SKIN:
						{
							if(!IsPlayerLogged(playerid))
							{
								if(GetPlayerData(playerid, P_ACCOUNT_STATE) == ACCOUNT_STATE_REG_SKIN)
								{
									new sex = GetPlayerSex(playerid);
									buffer = GetPlayerSelectSkin(playerid);
									
									if(!(0 <= --buffer <= sizeof(reg_skin_data[])-1))
									{
										buffer = sizeof(reg_skin_data[])-1;
										if(!sex)
											buffer -= 2;
									}
									SetPlayerSelectSkin(playerid, buffer, reg_skin_data[sex][buffer]);
								}
							}
						}
					}
				}
				case 3: // �������
				{
					switch(use_type)
					{
						case SELECT_PANEL_TYPE_CLOTHING:
						{
							ExitPlayerClothingShopPanel(playerid);
						}
					}
				}
			}
		}
	}
	
    return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if(pin_code_PTD[playerid][0] <= playertextid <= pin_code_PTD[playerid][9])
	{
		new pc_state = GetPlayerPinCodeState(playerid);
		new index = _:(playertextid - pin_code_PTD[playerid][0]);
		
		if(pc_state != PIN_CODE_STATE_NONE && 0 <= index <= 9)
		{
			new ch[2];
			valstr(ch, GetPlayerPinCodeValue(playerid, index));
			strcat(pin_code_input[playerid], ch);
			
			if(strlen(pin_code_input[playerid]) >= 4)
			{
				if(pc_state == PIN_CODE_STATE_CHECK)
				{
					HidePlayerPinCodePTD(playerid, false);
				}
				else HidePlayerPinCodePTD(playerid);
				
				switch(pc_state)
				{
					case PIN_CODE_STATE_SET,PIN_CODE_STATE_CHANGE:
					{
						new query[75];
						
						mysql_format(mysql, query, sizeof query, "UPDATE accounts SET setting_pin_code='%e' WHERE id=%d LIMIT 1", pin_code_input[playerid], GetPlayerAccountID(playerid));
						mysql_query(mysql, query, false);
						
						if(!mysql_errno())
						{
							format(g_player[playerid][P_SETTING_PIN], 5, "%s", pin_code_input[playerid]);
							
							format(query, sizeof query, "PIN-��� %s: {FFFF00}%s", pc_state == PIN_CODE_STATE_SET ? ("������� ����������") : ("������� ��"), GetPlayerData(playerid, P_SETTING_PIN));
							
							SendClientMessage(playerid, 0x66CC00FF, query);
							SendClientMessage(playerid, 0x66CC00FF, "��������� ��� �������� ��� �����");
							
							ShowPlayerSecuritySettings(playerid);
						}
						else 
						{
							SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 04)");
							ShowPlayerPinCodePTD(playerid, pc_state);
						}
					}
					case PIN_CODE_STATE_CHECK:
					{
						if(strcmp(pin_code_input[playerid], GetPlayerData(playerid, P_SETTING_PIN)) != 0)
						{
							SendClientMessage(playerid, 0xFF6600FF, "PIN-��� ������ �������");
							ShowPlayerSecuritySettings(playerid);
						}
						else ShowPlayerPinCodePTD(playerid, PIN_CODE_STATE_CHANGE);
					}
					case PIN_CODE_STATE_LOGIN_CHECK:
					{
						if(!IsPlayerLogged(playerid))
						{
							if(GetPlayerData(playerid, P_ACCOUNT_STATE) == ACCOUNT_STATE_LOGIN)
							{
								new step = GetPlayerData(playerid, P_ACCOUNT_STEP_STATE);
								new bool: wrong_pass = false;
								
								if
								(
									!strlen(GetPlayerData(playerid, P_SETTING_PIN))
									|| strcmp(GetPlayerData(playerid, P_SETTING_PIN), pin_code_input[playerid]) != 0
								)
								{
									wrong_pass = true;
									step --;
								}					
								ShowPlayerLoginDialog(playerid, step + 1, wrong_pass);
							}
						}
					}
				}
				pin_code_input[playerid][0] = 0;
			}
		}
	}
    return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	//if(help_info_CP[0] <= checkpointid <= help_info_CP[sizeof help_info_CP - 1])
	if(checkpointid == help_info_CP)
	{
		cmd::help(playerid, "");
	}
	else if(checkpointid == driving_exam_CP)
	{
		Dialog
		(
			playerid, DIALOG_DRIVING_EXAM_INFO, DIALOG_STYLE_MSGBOX,
			"{FFCD00}������� �� ��������",
			"{FFFFFF}������������!\n"\
			"�� ������ ���������� � ��������? ����� ������.\n"\
			"������� ����� �������� �� ������������� � ������������ �����\n"\
			"� ������ ��� ����� ����� �������� �� ������� �� ������ ���������������� ������,\n"\
			"� � �������� ��������� ���������� ������ �� ����� �������� ����������.\n\n"\
			"{CC9900}����� �� ����� ����� 600 ������ � � ������ ������� ������ �� ����� ����������!\n"\
			"������� ����� ������ ����������� ���������� ��������� ������",
			"������", "������"
		);
	}
	else if(factory_desk[0][FD_CHEK_ID] <= checkpointid <= factory_desk[sizeof(factory_desk)-1][FD_CHEK_ID])
	{
		new index = checkpointid - factory_desk[0][FD_CHEK_ID];
		SetPlayerFactoryDeskUse(playerid, index, true);
	}
	else if(checkpointid == join_to_job_CP)
	{
		if(IsPlayerInJob(playerid) || GetPlayerTempJob(playerid) != TEMP_JOB_NONE) 
			return SendClientMessage(playerid, 0xCECECEFF, "� ������ ������ �� �� ������ ���������� �� ������");
	
		Dialog
		(
			playerid, DIALOG_VIEV_JOBS_LIST, DIALOG_STYLE_MSGBOX,
			"{FFCD00}����� �� ������",
			"{FFFFFF}�� ������ ����������� ������ ��������� �����?", 
			"��", "���"
		);
	}
	else if(checkpointid == GetBusinessInteriorInfo(BUSINESS_INTERIOR_CLUB, BT_BUY_CHECK_ID))
	{
		new businessid = GetPlayerInBiz(playerid);
		if(businessid != -1)
		{
			new type = GetBusinessData(businessid, B_TYPE);
			if(type == BUSINESS_TYPE_CLUB)
			{
				if(IsPlayerInJob(playerid) || GetPlayerTempJob(playerid) != TEMP_JOB_NONE) 
					return SendClientMessage(playerid, 0xCECECEFF, "����� ���������� ���� ���������� ��������� ������� ����");
					
				Dialog
				(
					playerid, DIALOG_BIZ_CLUB, DIALOG_STYLE_LIST,
					GetBusinessData(businessid, B_NAME),
					"1. �������\t\t{00CC00}60 ���\n"\
					"2. ����\t\t\t{00CC00}100 ���\n"\
					"3. ����\t\t\t{00CC00}200 ���\n"\
					"4. ����������\t\t{00CC00}270 ���\n"\
					"5. �����\t\t{00CC00}300 ���\n"\
					"6. ������\t\t{00CC00}450 ���\n"\
					"7. �����\t\t{00CC00}630 ���\n"\
					"8. ������\t\t{00CC00}750 ���\n"\
					"{CC9900}9. �������\t\t{00CC00}50 ���\n"\
					"{CC9900}10. ������\t\t{00CC00}80 ���",
					"������", "������"
				);	
			}
		}
	}
	else if(checkpointid == GetBusinessInteriorInfo(BUSINESS_INTERIOR_REALTOR_BIZ, BT_BUY_CHECK_ID))
	{
		new businessid = GetPlayerInBiz(playerid);
		if(businessid != -1)
		{
			new type = GetBusinessData(businessid, B_TYPE);
			if(type == BUSINESS_TYPE_REALTOR_BIZ)
			{
				Dialog
				(
					playerid, DIALOG_BIZ_REALTOR_BIZ_LIST, DIALOG_STYLE_LIST,
					"{66FF99}������ ��������� ��������",
					g_business_realtor_list, 
					"���� 70�", "�������"
				);
			}
		}
	}
	else if(checkpointid == GetBusinessInteriorInfo(BUSINESS_INTERIOR_REALTOR_HOME, BT_BUY_CHECK_ID))
	{
		new businessid = GetPlayerInBiz(playerid);
		if(businessid != -1)
		{
			new type = GetBusinessData(businessid, B_TYPE);
			if(type == BUSINESS_TYPE_REALTOR_HOME)
			{
				ShowPlayerRealtorHomeDialog(playerid);
			}
		}
	}
	else if(checkpointid == GetBusinessInteriorInfo(BUSINESS_INTERIOR_HOTEL, BT_BUY_CHECK_ID))
	{
		ShowPlayerHotelDialog(playerid);
	}
	else if(g_hotel_lift_CP[0] <= checkpointid <= g_hotel_lift_CP[1])
	{
		new hotel_id = GetPlayerInHotelID(playerid);
		if(hotel_id != -1)
		{
			new floor_id = GetPlayerData(playerid, P_IN_HOTEL_FLOOR);
			ShowPlayerHotelFloorsLift(playerid, hotel_id, floor_id);
		}
	}
	return 1;
}

public: CreateFactoryProd(playerid)
{
	if(GetPlayerTempJob(playerid) == TEMP_JOB_FACTORY)
	{
		if(GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_FACTORY_CREATED)
		{
			RemovePlayerAttachedObjectEx(playerid, A_OBJECT_SLOT_HAND, A_OBJECT_SLOT_HAND + 1);
			
			new skill = GetPVarInt(playerid, "factory_skill");
			if(!(random(5) + skill == 1))
			{
				if(random(6) == 1) 
				{
					new fmt_str[80];
				
					SetPVarInt(playerid, "factory_skill", skill + 1);
					
					format(fmt_str, sizeof fmt_str, "������� ����� ��������. ������ ���� ������� ���������� ������� 1 �� %d", skill + 5);
					SendClientMessage(playerid, 0x66CC00FF, fmt_str);
				}

				ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 0, USE_ANIM_TYPE_NONE - 1);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
				
				SetPlayerChatBubble(playerid, "+ 1 �������", 0x66CC00FF, 10.0, 1500);
				
				SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_FOREARM, 1279, A_OBJECT_BONE_LEFT_FOREARM, 0.4, -0.09, -0.2, 85.0, 0.0, 90.0, 1.0, 1.0, 1.0, 0);
				GameTextForPlayer(playerid, "~g~~h~SUCCESS", 4000, 1);
				
				SetPlayerTempJobState(playerid, TEMP_JOB_STATE_FACTORY_PUT_PROD);
				SetPlayerTempJobCheckAnim(playerid, true);
			}
			else FactoryPlayerDrop(playerid);
			
			SetPlayerFactoryDeskUse(playerid, GetPlayerData(playerid, P_FACTORY_USE_DESK), false);
		}
	}
}

public OnPlayerLeaveDynamicCP(playerid, checkpointid)
{
	return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(GetFuelStationData(0, FS_AREA) <= areaid <= GetFuelStationData(g_fuel_station_loaded - 1, FS_AREA))
	{
		SetPVarInt(playerid, "buy_fuel_count", 	0);
		SetPVarInt(playerid, "buy_fuel_pay_j",	0);
		SetPVarInt(playerid, "buy_fuel_pay", 	0);
	}
	else if(areaid == factory_put_zone)
	{
		if(GetPlayerTempJob(playerid) == TEMP_JOB_FACTORY)
		{
			if(GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_FACTORY_PUT_PROD)
			{
				new objectid;
				new items = GetPlayerJobLoadItems(playerid);
				new Float: x, Float: y, Float: z, Float: angle;
				
				SetPlayerTempJobCheckAnim(playerid, false);
				
				ApplyAnimationEx(playerid, "CARRY", "PUTDWN", 4.0, 0, 0, 0, 0, 0, 0, USE_ANIM_TYPE_NONE);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				
				TogglePlayerFactoryCP(playerid, true);
				SetPlayerJobLoadItems(playerid, items + 1);
				
				AddPlayerData(playerid, P_JOB_WAGE, +, random(20)+40);
				SendClientMessage(playerid, 0xFFFF00FF, "������� ��������� �� �����");
				
				RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_FOREARM);
				SetPlayerTempJobState(playerid, TEMP_JOB_STATE_FACTORY_TAKE_MET);
				
				GetPlayerPos(playerid, x, y, z);
				GetPlayerFacingAngle(playerid, angle);
				
				objectid = CreateDynamicObject(1279, x, -2213.85, 3044.31, 0.0, 0.0, angle);
				MoveDynamicObject(objectid, 263.8, -2254.65, 3044.31, 0.0, 0.0, 0.0, angle);
				
				Streamer_SetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, OBJECT_TYPE_FACTORY);
			}
		}
	}
	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	if(!GetPlayerData(playerid, P_BLOCK_LEAVE_AREA))
	{
		if(areaid == loader_job_area)
		{
			EndPlayerTempJob(playerid, TEMP_JOB_LOADER, true);
		}
		else if(areaid == miner_job_area)
		{
			EndPlayerTempJob(playerid, TEMP_JOB_MINER, true);
		}
		else if(areaid == factory_job_area)
		{
			EndPlayerTempJob(playerid, TEMP_JOB_FACTORY, true);
		}
		else if(GetFuelStationData(0, FS_AREA) <= areaid <= GetFuelStationData(g_fuel_station_loaded - 1, FS_AREA))
		{
			new buy_fuel_pay = GetPVarInt(playerid, "buy_fuel_pay") + GetPVarInt(playerid, "buy_fuel_pay_j");
			
			DeletePVar(playerid, "buy_fuel_count");
			DeletePVar(playerid, "buy_fuel_pay_j");
			DeletePVar(playerid, "buy_fuel_pay");
			
			new stationid = areaid - GetFuelStationData(0, FS_AREA);
			if(buy_fuel_pay > 0)
			{
				new query[155];
				
				mysql_format(mysql, query, sizeof query, "INSERT INTO fuel_stations_profit (fid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetFuelStationData(stationid, FS_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), buy_fuel_pay, IsFuelStationOwned(stationid) ? 1 : 0);
				mysql_query(mysql, query, false);
			}
		}
	}
	else SetPlayerData(playerid, P_BLOCK_LEAVE_AREA, false);
	
	return 1;
}

public OnDynamicObjectMoved(objectid)
{
	new type = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID);
	switch(type)
	{
		case OBJECT_TYPE_FACTORY:
		{
			DestroyDynamicObject(objectid);
			type = GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_PROD, R_AMOUNT);
	
			SetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_PROD, R_AMOUNT, type + 1);
			UpdateRepository(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_PROD);
		}
	}
	
	return 1;
}

public Streamer_OnPluginError(error[])
{
	print("- Streamer_OnPluginError -");
	print(error);
	print("- Streamer_OnPluginError -\n");
	
	return 1;
}

public OnPlayerPressButton(playerid, buttonid)
{	
	if(IsGateButtonID(buttonid))
	{
		new index = buttonid - g_gate_button[0][0];
		new gateid = g_gate_button[index][1];
		
		new bool: gate_status = GetGateData(gateid, G_STATUS);
		if(gate_status == GATE_STATUS_CLOSE)
		{
			SetPlayerChatBubble(playerid, "��������� ��������", 0x00CC00FF, 15.0, 2000);
		}
		else SetPlayerChatBubble(playerid, "��������� ��������", 0xFF3333FF, 15.0, 2000);
		
		SetGateStatus(gateid, gate_status ^ GATE_STATUS_OPEN, -1);
	}
	return 0;
}

// ------------------------------------------
public: LoadEntrances()
{
	new idx, j, k;
	new query[85], buffer[2];
	new Cache: result, rows;
	
	result = mysql_query(mysql, "SELECT * FROM entrances", true);
	rows = cache_num_rows();
	
	if(rows > MAX_ENTRANCES)
	{
		rows = MAX_ENTRANCES;
		print("[Entrances]: DB rows > MAX_ENTRANCES");
	}
	
	for(idx = 0; idx < rows; idx ++)
	{
		SetEntranceData(idx, E_SQL_ID, 	cache_get_field_content_int(idx, "id"));
		
		SetEntranceData(idx, E_CITY, 	cache_get_field_content_int(idx, "city"));
		SetEntranceData(idx, E_ZONE, 	cache_get_field_content_int(idx, "zone"));	
		SetEntranceData(idx, E_FLOORS,	cache_get_field_content_int(idx, "floors"));
		
		SetEntranceData(idx, E_POS_X, 	cache_get_field_content_float(idx, "pos_x"));
		SetEntranceData(idx, E_POS_Y, 	cache_get_field_content_float(idx, "pos_y"));
		SetEntranceData(idx, E_POS_Z, 	cache_get_field_content_float(idx, "pos_z"));
		
		SetEntranceData(idx, E_EXIT_POS_X, 	cache_get_field_content_float(idx, "exit_x"));
		SetEntranceData(idx, E_EXIT_POS_Y, 	cache_get_field_content_float(idx, "exit_y"));
		SetEntranceData(idx, E_EXIT_POS_Z, 	cache_get_field_content_float(idx, "exit_z"));
		SetEntranceData(idx, E_EXIT_ANGLE, 	cache_get_field_content_float(idx, "exit_angle"));
		
		// ----------------------------------------------------------------------------------
		SetEntranceData(idx, E_STATUS, -1);
		
		if(GetEntranceData(idx, E_CITY) == -1 || GetEntranceData(idx, E_ZONE) == -1)
		{
			buffer[0] = Get2DCity(GetEntranceData(idx, E_POS_X), GetEntranceData(idx, E_POS_Y));
			buffer[1] = Get2DZone(GetEntranceData(idx, E_POS_X), GetEntranceData(idx, E_POS_Y));
			
			SetEntranceData(idx, E_CITY, buffer[0]);
			SetEntranceData(idx, E_ZONE, buffer[1]);
			
			format(query, sizeof query, "UPDATE entrances SET city=%d,zone=%d WHERE id=%d", buffer[0], buffer[1], GetEntranceData(idx, E_SQL_ID));
			mysql_query(mysql, query, false);
		}
		//SetEntranceData(idx, E_PICKUP_ID, CreatePickup(1273, 23, GetEntranceData(idx, E_POS_X), GetEntranceData(idx, E_POS_Y), GetEntranceData(idx, E_POS_Z), 0, PICKUP_ACTION_TYPE_ENTRANCE_ENT, idx));
		//SetEntranceData(idx, E_MAP_ICON, CreateDynamicMapIcon(GetEntranceData(idx, E_POS_X), GetEntranceData(idx, E_POS_Y), GetEntranceData(idx, E_POS_Z), 31, 0, 0, 0, -1, STREAMER_MAP_ICON_SD, MAPICON_LOCAL));
		
		format(query, sizeof query, "- ������� -\n{FFFFFF}����� ��������: %d", idx + 1);
		SetEntranceData(idx, E_LABEL, CreateDynamic3DTextLabel(query, 0x3399FFFF, GetEntranceData(idx, E_POS_X), GetEntranceData(idx, E_POS_Y), GetEntranceData(idx, E_POS_Z) + 1.0, 15.0));
	
		for(j = 0; j < MAX_ENTRANCE_FLOORS; j ++)
		{
			for(k = 0; k < 4; k ++)
			{
				g_entrance_flat[idx][j][k] = -1;
			}
		}
	}
	g_entrance_loaded = rows;
	cache_delete(result);
	
	// ������������� ���� ��������
	CreatePickup(1318, 23, 20.4902, 1410.7935, 1508.4100, -1, PICKUP_ACTION_TYPE_ENTRANCE_EXI); // ����� �� ��������
	
	CreatePickup(19134, 2, 30.5405, 1403.6593, 1508.4163, -1, PICKUP_ACTION_TYPE_ENTRANCE_LIF); // ���� �� 0 �����
	CreatePickup(19134, 2, 11.1776, 1377.5216, 1508.4163, -1, PICKUP_ACTION_TYPE_ENTRANCE_LIF); // ���� �� ����� ���� 0
	
	CreateDynamic3DTextLabel("- ������� -\n{FFFFFF}�����������: {FF9900}/lift", 0x3399FFFF, 30.5405, 1403.6593, 1508.4163 + 1.0, 8.0); // ����
	CreateDynamic3DTextLabel("- ������� -\n{FFFFFF}�����������: {FF9900}/lift", 0x3399FFFF, 11.1776, 1377.5216, 1508.4163 + 1.0, 8.0); // ����
	
	for(idx = 0, k = 0; idx < MAX_ENTRANCE_FLOORS; idx ++)
	{
		format(query, sizeof query, "����: %d", idx + 1);
		CreateDynamic3DTextLabel(query, 0xFFCD00FFF, 9.6966, 1376.0, 1508.4100 + 0.7, 8.0, _, _, _, _, idx + 2);
		
		for(j = 0; j < 4; j ++)
		{
			format(query, sizeof query, "��������\n{FFFFFF}�����: %d", k + 1);
			CreateDynamic3DTextLabel(query, 0x3399FFFF, g_entrance_flat_pos[j][0], g_entrance_flat_pos[j][1], g_entrance_flat_pos[j][2] + 1.6, 6.0, _, _, _, _, idx + 2);
			
			k ++;
		}
	}
	for(idx = 0; idx < 4; idx ++)
	{
		CreatePickup(19198, 23, g_entrance_flat_pos[idx][0], g_entrance_flat_pos[idx][1], g_entrance_flat_pos[idx][2], -1, PICKUP_ACTION_TYPE_ENTRANCE_FLA, idx);
	}
	printf("[Entrances]: ��������� ���������: %d", g_entrance_loaded);
}

public: EntranceStatusInit(entranceid)
{
	new e_houses = 0;
	for(new idx; idx < g_house_loaded; idx ++)
	{
		if(GetHouseData(idx, H_ENTRACE) != entranceid) continue;
		if(!IsHouseOwned(idx)) continue;
		
		e_houses ++;
	}
	UpdateEntrance(entranceid, e_houses);
}

public: LoadOwnableCars()
{
	new rows, vehicleid;
	new Cache: result;
	
	result = mysql_query(mysql, "SELECT oc.*, IFNULL(a.name, 'None') AS owner_name FROM ownable_cars oc LEFT JOIN accounts a ON a.id = oc.owner_id", true);
	rows = cache_num_rows();
	
	if(rows > MAX_OWNABLE_CARS)
	{
		rows = MAX_OWNABLE_CARS;
		print("[OwnableCars]: DB rows > MAX_OWNABLE_CARS");
	}
	for(new idx; idx < rows; idx ++)
	{
		SetOwnableCarData(idx, OC_SQL_ID, 		cache_get_field_content_int(idx, "id"));
		SetOwnableCarData(idx, OC_OWNER_ID, 	cache_get_field_content_int(idx, "owner_id"));
		
		SetOwnableCarData(idx, OC_MODEL_ID, 	cache_get_field_content_int(idx, "model_id"));
		SetOwnableCarData(idx, OC_COLOR_1, 		cache_get_field_content_int(idx, "color_1"));
		SetOwnableCarData(idx, OC_COLOR_2, 		cache_get_field_content_int(idx, "color_2"));
		
		SetOwnableCarData(idx, OC_POS_X, 		cache_get_field_content_float(idx, "pos_x"));
		SetOwnableCarData(idx, OC_POS_Y, 		cache_get_field_content_float(idx, "pos_y"));
		SetOwnableCarData(idx, OC_POS_Z, 		cache_get_field_content_float(idx, "pos_z"));
		SetOwnableCarData(idx, OC_ANGLE, 		cache_get_field_content_float(idx, "angle"));
		
		cache_get_field_content(0, "number", g_ownable_car[idx][OC_NUMBER], mysql, 8);

		SetOwnableCarData(idx, OC_ALARM, 		bool: cache_get_field_content_int(idx, "alarm"));
		SetOwnableCarData(idx, OC_KEY_IN, 		bool: cache_get_field_content_int(idx, "key_in"));
	
		SetOwnableCarData(idx, OC_CREATE, 		cache_get_field_content_int(idx, "create_time"));
		
		cache_get_field_content(0, "owner_name", g_ownable_car[idx][OC_OWNER_NAME], mysql, 21);
		// ----------------------------------------------------------------------------------------
		
		if(strlen(GetOwnableCarData(idx, OC_NUMBER)) != 6)
			strmid(g_ownable_car[idx][OC_NUMBER], "------", 0, 8, 8);
			
		vehicleid = CreateVehicle
		(
			GetOwnableCarData(idx, OC_MODEL_ID), 
			GetOwnableCarData(idx, OC_POS_X), 
			GetOwnableCarData(idx, OC_POS_Y), 
			GetOwnableCarData(idx, OC_POS_Z), 
			GetOwnableCarData(idx, OC_ANGLE), 
			GetOwnableCarData(idx, OC_COLOR_1), 
			GetOwnableCarData(idx, OC_COLOR_2),
			-1, 
			0, 
			VEHICLE_ACTION_TYPE_OWNABLE_CAR,
			idx
		);
		if(vehicleid != INVALID_VEHICLE_ID)
		{
			CreateVehicleLabel(vehicleid, GetOwnableCarData(idx, OC_NUMBER), 0xFFFF00EE, 0.0, 0.0, 1.3, 20.0);
			SetVehicleParam(vehicleid, V_LOCK, bool: cache_get_field_content_int(idx, "status"));
			
			SetVehicleData(vehicleid, V_MILEAGE, cache_get_field_content_float(idx, "mileage"));
		}
	}
	g_ownable_car_loaded = rows;
	cache_delete(result);
	
	printf("[OwnableCars]: ������ ���� ���������: %d", g_ownable_car_loaded);
}

public: LoadTrunks()
{
	new Cache: result, rows;
	new vehicleid, slot, buffer;
	
	result = mysql_query(mysql, "SELECT * FROM trunks ORDER BY owner_id ASC, id ASC", true);
	rows = cache_num_rows();
	
	for(new idx; idx < rows; idx ++)
	{
		vehicleid = GetOwnableCarBySqlID(cache_get_field_content_int(idx, "owner_id"));
		if(vehicleid != INVALID_VEHICLE_ID)
		{
			for(slot = 0; slot < MAX_VEHICLE_TRUNK_SLOTS; slot ++)
			{
				if(GetTrunkData(vehicleid, slot, VT_SQL_ID)) continue;
				
				SetTrunkData(vehicleid, slot, VT_SQL_ID,		cache_get_field_content_int(idx, "id"));
				SetTrunkData(vehicleid, slot, VT_ITEM_TYPE, 	cache_get_field_content_int(idx, "item_id"));
				SetTrunkData(vehicleid, slot, VT_ITEM_AMOUNT, 	cache_get_field_content_int(idx, "amount"));
				SetTrunkData(vehicleid, slot, VT_ITEM_VALUE,	cache_get_field_content_int(idx, "value"));
			}
			buffer ++;
		}
	}
	
	cache_delete(result);
	printf("[Trunks]: ��������� ���������: %d", buffer);
}

public: LoadHotels()
{
	new query[64], idx;
	new Cache: result, rows;
	new hotel_id, room_id;
	
	result = mysql_query(mysql, "SELECT h.*, IFNULL(a.name, 'None') AS owner_name FROM hotels h LEFT JOIN accounts a ON a.id = h.owner_id ORDER BY h.hotel_id ASC, h.id ASC", true);
	rows = cache_num_rows();
	
	if(rows > MAX_HOTELS * MAX_HOTEL_ROOMS)
	{
		rows = MAX_HOTELS * MAX_HOTEL_ROOMS;
		print("[Hotels]: DB rows > MAX_HOTELS * MAX_HOTEL_ROOMS");
	}
	
	for(idx = 0; idx < rows; idx ++)
	{
		hotel_id = cache_get_field_content_int(idx, "hotel_id");
		if(0 <= hotel_id <= MAX_HOTELS-1)
		{
			room_id = g_hotel_rooms_loaded[hotel_id];
			if(0 <= room_id <= MAX_HOTEL_ROOMS-1)
			{
				SetHotelData(hotel_id, room_id, H_SQL_ID, 		cache_get_field_content_int(idx, "id"));
				SetHotelData(hotel_id, room_id, H_OWNER_ID, 	cache_get_field_content_int(idx, "owner_id"));
				SetHotelData(hotel_id, room_id, H_RENT_DATE, 	cache_get_field_content_int(idx, "rent_time"));
				SetHotelData(hotel_id, room_id, H_STATUS, 		bool: cache_get_field_content_int(idx, "status"));
				
				cache_get_field_content(idx, "owner_name", g_hotel[hotel_id][room_id][H_OWNER_NAME], mysql, 21);
				
				// ----------------------------------------------------------------------------------------------
				if(IsHotelRoomOwned(hotel_id, room_id) && !strcmp(GetHotelData(hotel_id, room_id, H_OWNER_NAME), "None", true))
				{
					SetHotelData(hotel_id, room_id, H_OWNER_ID, 0);
					
					format(query, sizeof query, "UPDATE hotels SET owner_id=0 WHERE id=%d LIMIT 1", GetHotelData(hotel_id, room_id, H_SQL_ID));
					mysql_query(mysql, query, false);
				}
				
				if(!IsHotelRoomOwned(hotel_id, room_id))
				{
					SetHotelData(hotel_id, room_id, H_STATUS, false);
				}
				g_hotel_rooms_loaded[hotel_id] ++;
			}
		}
	}
	cache_delete(result);
	
	// ----------------------------------
	CreatePickup(1318, 23, 733.0804, 599.6274, 1002.9598, -1);
	CreatePickup(1318, 23, 1276.0054, -776.3987, 1202.7220, -1);
	
	g_hotel_lift_CP[0] = CreateDynamicCP(733.0804, 599.6274, 1002.9598, 1.0, _, _, _, 5.0);
	g_hotel_lift_CP[1] = CreateDynamicCP(1276.0054, -776.3987, 1202.722, 1.0, _, _, _, 5.0);
	
	// ----------------------------------
	new 
		Float: p_pos_x = 1273.2, 
		Float: p_pos_y = -778.3146,
		Float: p_pos_z = 1202.7220;
	
	for(idx = 0; idx < 12; idx ++)
	{
		if(!(idx & 1))
		{
			p_pos_y += 4.0,
			p_pos_x += 5.7;
		}
		else p_pos_x -= 5.7;
	
		CreatePickup(19197, 23, p_pos_x, p_pos_y, p_pos_z, -1, PICKUP_ACTION_TYPE_HOTEL_ROOM, idx);
		
		format(query, sizeof query, "�������\n{FFFFFF}�����: %d", idx + 1);
		CreateDynamic3DTextLabel(query, 0x3399FFFF, p_pos_x, p_pos_y, p_pos_z + 1.4, 6.0);
	}
	
	for(idx = 0; idx < MAX_HOTEL_FLOORS; idx ++)
	{
		format(query, sizeof query, "����: %d", idx + 1);
		CreateDynamic3DTextLabel(query, 0xFFCD00FF, 1276.0054, -776.3987, 1202.722 + 1.7, 8.0, _, _, _, _, idx + 1);
	}
	
	// ----------------------------------
	for(idx = 0; idx < MAX_HOTELS; idx ++)
	{
		if(g_hotel_rooms_loaded[idx])
		{
			g_hotel_loaded ++;
		}
	}
	printf("[Hotels]: ������ ���������: %d / �������: %d", g_hotel_loaded, rows);
}

public: LoadHouses()
{
	new idx;
	new query[85], buffer[2];
	new Cache: result, rows;

	// result = mysql_query(mysql, "SELECT h.*, IFNULL(a.name, 'None') owner_name FROM houses h LEFT JOIN accounts a ON a.id = h.owner_id ORDER BY h.id ASC, h.entrance ASC", true);
	result = mysql_query(mysql, "SELECT h.*, IFNULL(a.name, 'None') owner_name FROM houses h LEFT JOIN accounts a ON a.id=h.owner_id", true);
	rows = cache_num_rows();
	
	if(rows > MAX_HOUSES)
	{
		rows = MAX_HOUSES;
		print("[Houses]: DB rows > MAX_HOUSES");
	}
	
	for(idx = 0; idx < rows; idx ++)
	{
		SetHouseData(idx, H_SQL_ID, 		cache_get_field_content_int(idx, "id"));
		SetHouseData(idx, H_OWNER_ID, 		cache_get_field_content_int(idx, "owner_id"));
		
		cache_get_field_content(idx, "name", g_house[idx][H_NAME], mysql, 20);
		
		SetHouseData(idx, H_CITY,			cache_get_field_content_int(idx, "city"));
		SetHouseData(idx, H_ZONE,			cache_get_field_content_int(idx, "zone"));
		SetHouseData(idx, H_IMPROVEMENTS,	cache_get_field_content_int(idx, "improvements"));
		
		SetHouseData(idx, H_RENT_DATE,		cache_get_field_content_int(idx, "rent_time"));
		SetHouseData(idx, H_PRICE,			cache_get_field_content_int(idx, "price"));
		SetHouseData(idx, H_RENT_PRICE,		cache_get_field_content_int(idx, "rent_price"));
		SetHouseData(idx, H_TYPE,			cache_get_field_content_int(idx, "type"));
		SetHouseData(idx, H_ENTRACE,		cache_get_field_content_int(idx, "entrance"));
		SetHouseData(idx, H_LOCK_STATUS,	bool: cache_get_field_content_int(idx, "lock"));
		
		SetHouseData(idx, H_POS_X,			cache_get_field_content_float(idx, "x"));
		SetHouseData(idx, H_POS_Y,			cache_get_field_content_float(idx, "y"));
		SetHouseData(idx, H_POS_Z,			cache_get_field_content_float(idx, "z"));
		
		SetHouseData(idx, H_EXIT_POS_X,		cache_get_field_content_float(idx, "exit_x"));
		SetHouseData(idx, H_EXIT_POS_Y,		cache_get_field_content_float(idx, "exit_y"));
		SetHouseData(idx, H_EXIT_POS_Z,		cache_get_field_content_float(idx, "exit_z"));
		SetHouseData(idx, H_EXIT_ANGLE,		cache_get_field_content_float(idx, "exit_angle"));
		
		SetHouseData(idx, H_CAR_POS_X,		cache_get_field_content_float(idx, "car_x"));
		SetHouseData(idx, H_CAR_POS_Y,		cache_get_field_content_float(idx, "car_y"));
		SetHouseData(idx, H_CAR_POS_Z,		cache_get_field_content_float(idx, "car_z"));
		SetHouseData(idx, H_CAR_ANGLE,		cache_get_field_content_float(idx, "car_angle"));
		
		SetHouseData(idx, H_STORE_X,		cache_get_field_content_float(idx, "store_x"));
		SetHouseData(idx, H_STORE_Y,		cache_get_field_content_float(idx, "store_y"));
		SetHouseData(idx, H_STORE_Z,		cache_get_field_content_float(idx, "store_z"));
		
		cache_get_field_content(idx, "owner_name", g_house[idx][H_OWNER_NAME], mysql, 21);
		
		// -------------------------
		SetHouseData(idx, H_STORE_LABEL, Text3D:-1);
	
		buffer[0] = GetHouseData(idx, H_TYPE);
		if(!strlen(GetHouseData(idx, H_NAME)))
			format(g_house[idx][H_NAME], 20, GetHouseTypeInfo(buffer[0], HT_NAME), 0);
		
		if(GetHouseData(idx, H_ENTRACE) == -1)
		{
			if(GetHouseData(idx, H_CITY) == -1 || GetHouseData(idx, H_ZONE) == -1)
			{
				buffer[0] = Get2DCity(GetHouseData(idx, H_POS_X), GetHouseData(idx, H_POS_Y));
				buffer[1] = Get2DZone(GetHouseData(idx, H_POS_X), GetHouseData(idx, H_POS_Y));
				
				SetHouseData(idx, H_CITY, buffer[0]);
				SetHouseData(idx, H_ZONE, buffer[1]);
				
				format(query, sizeof query, "UPDATE houses SET city=%d,zone=%d WHERE id=%d", buffer[0], buffer[1], GetHouseData(idx, H_SQL_ID));
				mysql_query(mysql, query, false);
			}
		}
		if(IsHouseOwned(idx) && !strcmp(GetHouseData(idx, H_OWNER_NAME), "None", true))
		{
			SetHouseData(idx, H_OWNER_ID, 0);
			
			format(query, sizeof query, "UPDATE houses SET owner_id=0,improvements=0 WHERE id=%d", GetHouseData(idx, H_SQL_ID));
			mysql_query(mysql, query, false);
		}
		
		if(!IsHouseOwned(idx))
		{
			SetHouseData(idx, H_IMPROVEMENTS, 	0);
			SetHouseData(idx, H_LOCK_STATUS, 	false);
		}
		UpdateHouse(idx);
		
		HouseHealthInit(idx);
		HouseStoreInit(idx);
		
		buffer[0] = GetHouseData(idx, H_ENTRACE);
		if(buffer[0] != -1)
		{	
			buffer[1] = g_entrance_flats_loaded[buffer[0]];
			
			g_entrance_flats_loaded[buffer[0]] ++;
			g_entrance_flat[buffer[0]][buffer[1] / 4][buffer[1] % 4] = idx;
			
			SetHouseData(idx, H_FLAT_ID, buffer[1]);
		}
	}
	g_house_loaded = rows;
	cache_delete(result);
	
	printf("[Houses]: ����� ���������: %d", g_house_loaded);
}

public: LoadHousesRenters()
{
	new sql_id;
	new owner_id;
	new house_id;
	new room_id;
	new rent_time;
	new time;
	new owner_name[21];
	
	new Cache: result, rows;
	
	result = mysql_query(mysql, "SELECT h.*, IFNULL(a.name, 'None') owner_name FROM houses_renters h LEFT JOIN accounts a ON a.id=h.owner_id", true);
	rows = cache_num_rows();
	
	for(new idx; idx < rows; idx ++)
	{
		sql_id = 	cache_get_field_content_int(idx, "id");
		
		owner_id = 	cache_get_field_content_int(idx, "owner_id");
		house_id = 	cache_get_field_content_int(idx, "house_id");
		room_id =	cache_get_field_content_int(idx, "room_id");
		rent_time =	cache_get_field_content_int(idx, "rent_time");
		time = 		cache_get_field_content_int(idx, "time");
		
		cache_get_field_content(idx, "owner_name", owner_name, mysql, 21);
		if(!strlen(owner_name))
			owner_name[0] = '\1';
		
		CallLocalFunction("HouseRenterInit", "iiiiiis", sql_id, owner_id, house_id, room_id, rent_time, time, owner_name);
	}
	cache_delete(result);
	
	printf("[Houses]: ����������� ���������: %d", rows);
}

public: HouseRenterInit(id, owner_id, house_id, room_id, rent_time, time, owner_name[])
{
	new houseid = GetHouseIndexBySQLID(house_id);
	if(houseid != -1)
	{
		if(0 <= room_id <= MAX_HOUSE_ROOMS-1)
		{
			SetHouseRenterInfo(houseid, room_id, HR_SQL_ID, id);
			SetHouseRenterInfo(houseid, room_id, HR_OWNER_ID, owner_id);
			SetHouseRenterInfo(houseid, room_id, HR_RENT_DATE, rent_time);
			SetHouseRenterInfo(houseid, room_id, HR_RENT_TIME, time);
			
			format(g_house_renters[houseid][room_id][HR_OWNER_NAME], 21, owner_name, 0);
			
			AddHouseRentersCount(houseid, +, 1);
		}
	}
}

public: ShowPlayerHouseInfo(playerid, houseid)
{
	if(0 <= houseid <= g_house_loaded-1)
	{
		if(GetPlayerInHouse(playerid) == -1)
		{
			SetPlayerUseListitem(playerid, houseid);
		
			new fmt_str[40];
			new string[256];
			new type = GetHouseData(houseid, H_TYPE);
			
			if(IsHouseOwned(houseid))
			{
				format(fmt_str, sizeof fmt_str, "{FFFFFF}��������:\t\t\t{33CCFF}%s\n\n", GetHouseData(houseid, H_OWNER_NAME));
				strcat(string, fmt_str);	
			}
			
			format(fmt_str, sizeof fmt_str, "{FFFFFF}���:\t\t\t\t%s\n", GetHouseData(houseid, H_NAME));
			strcat(string, fmt_str);
			
			if(GetHouseData(houseid, H_ENTRACE) != -1)
			{
				//format(fmt_str, sizeof fmt_str, "����:\t\t\t\t%d\n", GetHouseData(houseid, H_FLAT_ID) / 4 + 1);
				//strcat(string, fmt_str);
				
				format(fmt_str, sizeof fmt_str, "����� ��������:\t\t%d\n", GetHouseData(houseid, H_FLAT_ID) + 1);
				strcat(string, fmt_str);
				
				if(!IsHouseOwned(houseid)) strcat(string, "\n");
				
				format(fmt_str, sizeof fmt_str, "����� ��������:\t\t%d\n", GetHouseData(houseid, H_ENTRACE) + 1);
				strcat(string, fmt_str);
			}
			else 
			{
				format(fmt_str, sizeof fmt_str, "����� ����:\t\t\t%d\n", houseid);
				strcat(string, fmt_str);
				
				if(!IsHouseOwned(houseid)) strcat(string, "\n");
			}
			
			format(fmt_str, sizeof fmt_str, "���������� ������:\t\t%d\n", GetHouseTypeInfo(type, HT_ROOMS));
			strcat(string, fmt_str);
			
			format(fmt_str, sizeof fmt_str, "���������:\t\t\t%d ���\n", GetHouseData(houseid, H_PRICE));
			strcat(string, fmt_str);
			
			format(fmt_str, sizeof fmt_str, "���������� ����������:\t%d ���", GetHouseData(houseid, H_RENT_PRICE));
			strcat(string, fmt_str);
			
			if(IsHouseOwned(houseid))
			{
				if(GetHouseData(houseid, H_IMPROVEMENTS) >= 4)
				{
					format(fmt_str, sizeof fmt_str, " {33CC99}(%d ���)", GetHouseData(houseid, H_RENT_PRICE) / 2);
					strcat(string, fmt_str);
				}
				Dialog(playerid, DIALOG_HOUSE_ENTER, DIALOG_STYLE_MSGBOX, "{FF9900}��� �����", string, "�����", "������");
			}
			else Dialog(playerid, DIALOG_HOUSE_BUY, DIALOG_STYLE_MSGBOX, "{33CC00}��� ��������", string, "������", "������");
		}
	}
	return 1;
}

public: ShowPlayerHouseDialog(playerid, operationid)
{
	new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
	if(houseid != -1)
	{
		if(GetHouseData(houseid, H_ENTRACE) != -1)
		{
			if(operationid >= HOUSE_OPERATION_CAR_DELIVERY)
			{
				operationid ++;
			}
		}
		switch(operationid)
		{
			case HOUSE_OPERATION_PARAMS:
			{
				if(GetHouseData(houseid, H_ENTRACE) != -1)
				{
					Dialog
					(
						playerid, DIALOG_HOUSE_PARAMS, DIALOG_STYLE_LIST,
						"{33AACC}��������� ���������� ����",
						"1. {669966}������� {FFFFFF}��� {CC3333}������� {FFFFFF}���\n"\
						"2. �������� ���\n"\
						"3. �������� ��������� �� GPS\n"\
						"4. ������ �����������",
						"�������", "�����"
					);
				}
				else 
				{
					Dialog
					(
						playerid, DIALOG_HOUSE_PARAMS, DIALOG_STYLE_LIST,
						"{33AACC}��������� ���������� ����",
						"1. {669966}������� {FFFFFF}��� {CC3333}������� {FFFFFF}���\n"\
						"2. �������� ���\n"\
						"3. ��������� ��������� � ���� {FF6600}(550 ���)\n"\
						"4. �������� ��������� �� GPS\n"\
						"5. ������ �����������",
						"�������", "�����"
					);
				}
			}
			case HOUSE_OPERATION_LOCK:
			{
				if(GetHouseData(houseid, H_LOCK_STATUS))
				{
					SetHouseData(houseid, H_LOCK_STATUS, false);
					SendClientMessage(playerid, 0x66CC00FF, "��� ������");					
				}
				else 
				{
					SetHouseData(houseid, H_LOCK_STATUS, true);
					SendClientMessage(playerid, 0xFF6600FF, "��� ������");				
				}

				new query[75];
				format(query, sizeof query, "UPDATE `houses` SET `lock`=%d WHERE `id`=%d LIMIT 1", GetHouseData(houseid, H_LOCK_STATUS), GetHouseData(houseid, H_SQL_ID));
				mysql_query(mysql, query, false);
				
				CallLocalFunction("ShowPlayerHouseDialog", "ii", playerid, HOUSE_OPERATION_PARAMS);
			}
			case HOUSE_OPERATION_IMPROVEMENTS:
			{
				new fmt_str[75];
				new string[512];
				
				new str_numeric[14 + 1];
				new i_level = GetHouseData(houseid, H_IMPROVEMENTS);
				
				for(new idx; idx < sizeof(g_house_improvements); idx ++)
				{
					format(fmt_str, sizeof fmt_str, "%d �������:\t%s\t\t", idx + 1, g_house_improvements[idx][I_NAME]);
	
					switch(idx)
					{
						case 1,4,5:
							strcat(fmt_str, "\t");
						
						case 6:
							strcat(fmt_str, "\t\t");
					}
	
					if(i_level > idx)
					{
						strins(fmt_str, "{2277AA}", 0, sizeof fmt_str);
						strcat(fmt_str, "�������");
					}
					else
					{
						if(i_level < idx)
						{
							strins(fmt_str, "{CC3344}", 0, sizeof fmt_str);
						}
						strcat(string, fmt_str);
						
						valfmt(str_numeric, g_house_improvements[idx][I_PRICE]);
						format(fmt_str, sizeof fmt_str, "%s ���", str_numeric);
						
						if(i_level == idx)
							strins(fmt_str, "{66CC33}", 0, sizeof fmt_str);
					}
					strcat(fmt_str, "\n");
					strcat(string, fmt_str);
				}
				Dialog(playerid, DIALOG_HOUSE_IMPROVEMENTS, DIALOG_STYLE_LIST, "{33AADD}��������� ��� ����", string, "������", "�����");
			}
			case HOUSE_OPERATION_CAR_DELIVERY:
			{
				if(GetHouseData(houseid, H_ENTRACE) == -1)
				{
					new vehicleid = GetPlayerOwnableCar(playerid);
					if(vehicleid != INVALID_VEHICLE_ID)
					{
						new price = 550;
						if(GetPlayerMoneyEx(playerid) >= price)
						{
							GivePlayerMoneyEx(playerid, -price, "�������� �� � ���� (/home)", true, true);
							
							SetVehiclePos
							(
								vehicleid, 
								GetHouseData(houseid, H_CAR_POS_X),
								GetHouseData(houseid, H_CAR_POS_Y),
								GetHouseData(houseid, H_CAR_POS_Z)
							);
							SetVehicleZAngle(vehicleid, GetHouseData(houseid, H_CAR_ANGLE));
							SetVehicleParam(vehicleid, V_ENGINE, IsABike(vehicleid) ? VEHICLE_PARAM_ON : VEHICLE_PARAM_OFF);

							return SendClientMessage(playerid, 0x3399FFFF, "��������� ��� ��������� � ������ ����");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "������������ �����");
					}
					else SendClientMessage(playerid, 0x999999FF, "� ��� ��� ������� ����������");
				}
				else SendClientMessage(playerid, 0xCECECEFF, "������� �������� ���������� �����");
				
				CallLocalFunction("ShowPlayerHouseDialog", "ii", playerid, HOUSE_OPERATION_PARAMS);
			}
			case HOUSE_OPERATION_CAR_GPS:
			{
				if(!cmd::getmycar(playerid, ""))
				{
					CallLocalFunction("ShowPlayerHouseDialog", "ii", playerid, HOUSE_OPERATION_PARAMS);
				}
			}
			case HOUSE_OPERATION_RENTERS:
			{
				if(GetHouseRentersCount(houseid) > 0)
				{
					new type = GetHouseData(houseid, H_TYPE);
					new rooms = GetHouseTypeInfo(type, HT_ROOMS);
				
					new fmt_str[21 + 1];
					new string[MAX_HOUSE_ROOMS * (sizeof fmt_str) + 1];
					
					for(new idx, count; idx < rooms; idx ++)
					{
						if(!IsHouseRoomOwned(houseid, idx)) continue;
						
						format(fmt_str, sizeof fmt_str, "%s\n", GetHouseRenterInfo(houseid, idx, HR_OWNER_NAME));
						strcat(string, fmt_str);
						
						SetPlayerListitemValue(playerid, count ++, idx);
					}
					Dialog(playerid, DIALOG_HOUSE_RENTERS, DIALOG_STYLE_LIST, "{33AACC}������ �����������", string, "�������", "�����");
				}
				else 
				{
					Dialog
					(
						playerid, DIALOG_HOUSE_INFO, DIALOG_STYLE_MSGBOX, 
						"{33AACC}������ �����������",
						"{FFFFFF}� ����� ����, ����� ���, ������ ����� �� ���������", 
						"�����", ""
					);
				}
			}
		}
	}
	return 1;
}

public: UpdateRealtorHomeInfo()
{
	new count = -1;
	new fmt_str[128];
	new free_houses = GetFreeHousesCount();
	
	new new_line = floatround((float(free_houses) / 10) + 2, floatround_ceil);
	if(new_line > 28)
	{
		new_line = 28;
	}
	
	g_house_realtor_list = "{FFFFFF}";
	for(new idx; idx < g_house_loaded; idx ++)
	{
		if(IsHouseOwned(idx)) continue;
		if(++count > new_line)
		{
			count = -1;
		}
		
		format(fmt_str, sizeof fmt_str, "%d%s", idx, count != -1 ? ("\t") : ("\n"));
		strcat(g_house_realtor_list, fmt_str);
	}
	
	format
	(
		fmt_str, sizeof fmt_str, 
		"��������� ������������\n"\
		"(����������� ������ ���)\n\n"\
		"{FF6633}������� �����: %d\n"\
		"{99FF33}�������� �����: %d",
		g_house_loaded - free_houses,
		free_houses
	);
	UpdateDynamic3DTextLabelText(g_house_realtor_label, 0xCCFF66FF, fmt_str);
}

public: UpdateHouseStore(houseid)
{
	if(GetHouseData(houseid, H_STORE_LABEL) != Text3D:-1)
	{
		new fmt_str[256];
		
		format
		(
			fmt_str, sizeof fmt_str,
			"����\n"\
			"{FFFFFF}������: {6699FF}%d �� 700 ��\n"\
			"{FFFFFF}���������: {6699FF}%d �� 2000 �\n"\
			"{FFFFFF}������: {6699FF}%s\n"\
			"{FFFFFF}�������: {6699FF}%d �� 3000 ��\n"\
			"{FFFFFF}������: {FF6600}%s",	
			0,
			0,
			("���"),
			0,
			("���")
		);
		UpdateDynamic3DTextLabelText(GetHouseData(houseid, H_STORE_LABEL), 0xFFFF00FF, fmt_str);
	}
}

public: EvictHouseRentersAll(houseid)
{
	new query[128];
	
	format(query, sizeof query, "UPDATE accounts SET house_type=-1,house_room=-1,house=-1 WHERE house=%d AND house_type=%d", houseid, HOUSE_TYPE_ROOM);
	mysql_tquery(mysql, query, "", "");
	
	format(query, sizeof query, "DELETE FROM houses_renters WHERE house_id=%d", GetHouseData(houseid, H_SQL_ID));
	mysql_tquery(mysql, query, "", "");
	
	for(new idx; idx < MAX_HOUSE_ROOMS; idx ++)
	{
		if(!IsHouseRoomOwned(houseid, idx)) continue;
		
		SetHouseRenterInfo(houseid, idx, HR_SQL_ID, 	0);
		SetHouseRenterInfo(houseid, idx, HR_OWNER_ID, 	0);
	}
	
	foreach(new playerid : Player)
	{
		if(!IsPlayerLogged(playerid)) continue;
		if(GetPlayerHouse(playerid, HOUSE_TYPE_ROOM) != houseid) continue;
		
		SetPlayerData(playerid, P_HOUSE, -1);
		SetPlayerData(playerid, P_HOUSE_ROOM, -1);
		SetPlayerData(playerid, P_HOUSE_TYPE, -1);
		
		SendClientMessage(playerid, 0x3399FFFF, "�� ���� �������� �� ����");
	}
}

public: LoadBusinesses()
{
	new query[85], buffer[2];
	new Cache: result, rows;

	result = mysql_query(mysql, "SELECT b.*, IFNULL(a.name, 'None') AS owner_name FROM business b LEFT JOIN accounts a ON a.id=b.owner_id", true);
	rows = cache_num_rows();
	
	if(rows > MAX_BUSINESS)
	{
		rows = MAX_BUSINESS;
		print("[Business]: DB rows > MAX_BUSINESS");
	}
	for(new idx; idx < rows; idx ++)
	{
		SetBusinessData(idx, B_SQL_ID, 		cache_get_field_content_int(idx, "id"));
		SetBusinessData(idx, B_OWNER_ID, 	cache_get_field_content_int(idx, "owner_id"));
		
		cache_get_field_content(idx, "name", g_business[idx][B_NAME], mysql, 24);
		
		SetBusinessData(idx, B_CITY,			cache_get_field_content_int(idx, "city"));
		SetBusinessData(idx, B_ZONE,			cache_get_field_content_int(idx, "zone"));
		SetBusinessData(idx, B_IMPROVEMENTS,	cache_get_field_content_int(idx, "improvements"));
		SetBusinessData(idx, B_PRODS,			cache_get_field_content_int(idx, "products"));
		SetBusinessData(idx, B_PROD_PRICE,		cache_get_field_content_int(idx, "prod_price"));
		SetBusinessData(idx, B_BALANCE,			cache_get_field_content_int(idx, "balance"));
		SetBusinessData(idx, B_RENT_DATE,		cache_get_field_content_int(idx, "rent_time"));
		SetBusinessData(idx, B_PRICE,			cache_get_field_content_int(idx, "price"));
		SetBusinessData(idx, B_RENT_PRICE,		cache_get_field_content_int(idx, "rent_price"));
		
		SetBusinessData(idx, B_TYPE,			cache_get_field_content_int(idx, "type"));
		SetBusinessData(idx, B_INTERIOR,		cache_get_field_content_int(idx, "interior"));
		
		SetBusinessData(idx, B_ENTER_PRICE,		cache_get_field_content_int(idx, "enter_price"));
		SetBusinessData(idx, B_ENTER_MUSIC,		cache_get_field_content_int(idx, "enter_music"));
		
		SetBusinessData(idx, B_LOCK_STATUS,		bool: cache_get_field_content_int(idx, "lock"));
		
		SetBusinessData(idx, B_POS_X,			cache_get_field_content_float(idx, "x"));
		SetBusinessData(idx, B_POS_Y,			cache_get_field_content_float(idx, "y"));
		SetBusinessData(idx, B_POS_Z,			cache_get_field_content_float(idx, "z"));
		
		SetBusinessData(idx, B_EXIT_POS_X,		cache_get_field_content_float(idx, "exit_x"));
		SetBusinessData(idx, B_EXIT_POS_Y,		cache_get_field_content_float(idx, "exit_y"));
		SetBusinessData(idx, B_EXIT_POS_Z,		cache_get_field_content_float(idx, "exit_z"));
		SetBusinessData(idx, B_EXIT_ANGLE,		cache_get_field_content_float(idx, "exit_angle"));
	
		cache_get_field_content(idx, "owner_name", g_business[idx][B_OWNER_NAME], mysql, 21);
		// -------------------------
		
		SetBusinessData(idx, B_ORDER_ID, -1);
		SetBusinessData(idx, B_LABEL, CreateDynamic3DTextLabel(GetBusinessData(idx, B_NAME), 0xFFFF00FF, GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y), GetBusinessData(idx, B_POS_Z) + 1.0, 6.50));
	
		if(GetBusinessData(idx, B_CITY) == -1 || GetBusinessData(idx, B_ZONE) == -1)
		{
			buffer[0] = Get2DCity(GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y));
			buffer[1] = Get2DZone(GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y));
			
			SetBusinessData(idx, B_CITY, buffer[0]);
			SetBusinessData(idx, B_ZONE, buffer[1]);
			
			format(query, sizeof query, "UPDATE business SET city=%d,zone=%d WHERE id=%d", buffer[0], buffer[1], GetBusinessData(idx, B_SQL_ID));
			mysql_query(mysql, query, false);
		}
	
		if(IsBusinessOwned(idx) && !strcmp(GetBusinessData(idx, B_OWNER_NAME), "None", true))
		{
			SetBusinessData(idx, B_OWNER_ID, 0);
			
			format(query, sizeof query, "UPDATE business SET owner_id=0,improvements=0 WHERE id=%d", GetBusinessData(idx, B_SQL_ID));
			mysql_query(mysql, query, false);
		}
		
		if(!IsBusinessOwned(idx))
		{
			SetBusinessData(idx, B_PRODS,		0);
			SetBusinessData(idx, B_PROD_PRICE, 	0);
			SetBusinessData(idx, B_LOCK_STATUS, false);
			
			SetBusinessData(idx, B_ENTER_MUSIC, 0);
			SetBusinessData(idx, B_ENTER_PRICE, 0);
			
			if(GetBusinessData(idx, B_IMPROVEMENTS) >= 6)
			{			
				format(query, sizeof query, "DELETE FROM business_gps WHERE bid=%d", idx);
				mysql_query(mysql, query, false);
			}
		}
		CallLocalFunction("UpdateBusinessLabel", "i", idx);
	
		CreatePickup(19132, 23, GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y), GetBusinessData(idx, B_POS_Z), 0, PICKUP_ACTION_TYPE_BIZ_ENTER, idx);
		//CreateDynamicMapIcon(GetFuelStationData(idx, FS_POS_X), GetFuelStationData(idx, FS_POS_Y), GetFuelStationData(idx, FS_POS_Z), 47, 0, 0, 0, -1, STREAMER_MAP_ICON_SD, MAPICON_LOCAL);
	
		BusinessHealthPickupInit(idx);
	}
	g_business_loaded = rows;
	cache_delete(result);
	
	for(new idx; idx < sizeof g_business_interiors; idx ++)
	{
		CreatePickup(19132, 23, GetBusinessInteriorInfo(idx, BT_EXIT_POS_X), GetBusinessInteriorInfo(idx, BT_EXIT_POS_Y), GetBusinessInteriorInfo(idx, BT_EXIT_POS_Z), -1, PICKUP_ACTION_TYPE_BIZ_EXIT, idx);
		buffer[0] = -1;
	
		switch(idx)
		{
			case BUSINESS_INTERIOR_SHOP_24_7:
			{
				CreateDynamic3DTextLabel
				(
					"������\n"\
					"�������\n"\
					"{FFCD00}������� /buy",
					0x00CC00EE, 
					GetBusinessInteriorInfo(idx, BT_BUY_POS_X),
					GetBusinessInteriorInfo(idx, BT_BUY_POS_Y),
					GetBusinessInteriorInfo(idx, BT_BUY_POS_Z) + 0.8, 
					8.0
				);
				CreatePickup(10270, 2, GetBusinessInteriorInfo(idx, BT_BUY_POS_X), GetBusinessInteriorInfo(idx, BT_BUY_POS_Y), GetBusinessInteriorInfo(idx, BT_BUY_POS_Z), -1, PICKUP_ACTION_TYPE_BIZ_SHOP_247, idx);
			}
			case BUSINESS_INTERIOR_CLUB:
			{
				CreateDynamic3DTextLabel
				(
					"���� ����:\n\n"\
					"{6699FF}1. �������\n"\
					"2. ����\n"\
					"3. ����\n"\
					"4. ����������\n"\
					"5. �����\n"\
					"6. ������\n"\
					"7. �����\n"\
					"8. ������\n"\
					"{00CC66}9. �������\n"\
					"10. ������", 
					0xFFFFFFCC, 
					GetBusinessInteriorInfo(idx, BT_LABEL_POS_X),
					GetBusinessInteriorInfo(idx, BT_LABEL_POS_Y),
					GetBusinessInteriorInfo(idx, BT_LABEL_POS_Z), 
					9.0
				);
				buffer[0] = CreateDynamicCP(GetBusinessInteriorInfo(idx, BT_BUY_POS_X), GetBusinessInteriorInfo(idx, BT_BUY_POS_Y), GetBusinessInteriorInfo(idx, BT_BUY_POS_Z), 1.0, _, _, _, 8.0);
			}
			case BUSINESS_INTERIOR_REALTOR_BIZ:
			{
				g_business_realtor_label = CreateDynamic3DTextLabel
				(
					"��������� �������", 
					0xCCFF66FF, 
					GetBusinessInteriorInfo(idx, BT_LABEL_POS_X),
					GetBusinessInteriorInfo(idx, BT_LABEL_POS_Y),
					GetBusinessInteriorInfo(idx, BT_LABEL_POS_Z), 
					10.0
				);
				//CreatePickup(1239, 23, GetBusinessInteriorInfo(idx, BT_BUY_POS_X), GetBusinessInteriorInfo(idx, BT_BUY_POS_Y), GetBusinessInteriorInfo(idx, BT_BUY_POS_Z), -1);
				buffer[0] = CreateDynamicCP(GetBusinessInteriorInfo(idx, BT_BUY_POS_X), GetBusinessInteriorInfo(idx, BT_BUY_POS_Y), GetBusinessInteriorInfo(idx, BT_BUY_POS_Z) - 1.0, 1.2, _, _, _, 10.0);
				
				CallLocalFunction("UpdateRealtorBizInfo", "");
			}
			case BUSINESS_INTERIOR_REALTOR_HOME:
			{
				g_house_realtor_label = CreateDynamic3DTextLabel
				(
					"��������� ������������",
					0xCCFF66FF, 
					GetBusinessInteriorInfo(idx, BT_LABEL_POS_X),
					GetBusinessInteriorInfo(idx, BT_LABEL_POS_Y),
					GetBusinessInteriorInfo(idx, BT_LABEL_POS_Z), 
					10.0
				);
				CreatePickup(1273, 2, 158.4875, 745.8184, 25.8272, -1, PICKUP_ACTION_TYPE_REALTOR_HOME, idx);
				CreatePickup(1272, 2, 156.3270, 746.5958, 25.8272, -1, PICKUP_ACTION_TYPE_REALTOR_HOME, idx);
				
				CreatePickup(1239, 23, GetBusinessInteriorInfo(idx, BT_BUY_POS_X), GetBusinessInteriorInfo(idx, BT_BUY_POS_Y), GetBusinessInteriorInfo(idx, BT_BUY_POS_Z), -1);
				buffer[0] = CreateDynamicCP(GetBusinessInteriorInfo(idx, BT_BUY_POS_X), GetBusinessInteriorInfo(idx, BT_BUY_POS_Y), GetBusinessInteriorInfo(idx, BT_BUY_POS_Z), 0.7, _, _, _, 5.0);
			
				CallLocalFunction("UpdateRealtorHomeInfo", "");
			}
			case BUSINESS_INTERIOR_CLOTHING_SHOP:
			{
				CreatePickup(1275, 23, GetBusinessInteriorInfo(idx, BT_BUY_POS_X), GetBusinessInteriorInfo(idx, BT_BUY_POS_Y), GetBusinessInteriorInfo(idx, BT_BUY_POS_Z), -1, PICKUP_ACTION_TYPE_BIZ_CLOTHING, idx);
			}
			case BUSINESS_INTERIOR_HOTEL:
			{
				CreatePickup(1277, 23, GetBusinessInteriorInfo(idx, BT_BUY_POS_X), GetBusinessInteriorInfo(idx, BT_BUY_POS_Y), GetBusinessInteriorInfo(idx, BT_BUY_POS_Z), -1);
				
				CreateDynamic3DTextLabel("������\n{FFFFFF}����. ���������", 0x3399FFFF, GetBusinessInteriorInfo(idx, BT_BUY_POS_X), GetBusinessInteriorInfo(idx, BT_BUY_POS_Y), GetBusinessInteriorInfo(idx, BT_BUY_POS_Z) + 0.8, 5.0);
				buffer[0] = CreateDynamicCP(GetBusinessInteriorInfo(idx, BT_BUY_POS_X), GetBusinessInteriorInfo(idx, BT_BUY_POS_Y), GetBusinessInteriorInfo(idx, BT_BUY_POS_Z), 1.2, _, _, _, 20.0);
			}
		}
		SetBusinessInteriorInfo(idx, BT_BUY_CHECK_ID, buffer[0]);
	}
	BusinesGPSListInit();
	
	printf("[Business]: �������� ���������: %d", g_business_loaded);
}

public: UpdateBusinessLabel(businessid)
{
	new fmt_str[129 + 1];

	if(!IsBusinessOwned(businessid))
	{
		format
		(
			fmt_str, sizeof fmt_str, 
			"%s\n"\
			"{66CC00}������ ���������\n"\
			"����������� /buybiz\n"\
			"����: %d ���", 
			GetBusinessData(businessid, B_NAME), 
			GetBusinessData(businessid, B_PRICE)
		);
	}
	else 
	{
		format
		(
			fmt_str, sizeof fmt_str, 
			"%s\n"\
			"{FFFFFF}��������: {0099FF}%s\n",
			GetBusinessData(businessid, B_NAME), 
			GetBusinessData(businessid, B_OWNER_NAME) 
		);
		
		if(!GetBusinessData(businessid, B_LOCK_STATUS))
		{
			if(GetBusinessData(businessid, B_ENTER_PRICE) > 0)
			{
				format(fmt_str, sizeof fmt_str, "%s{66CC00}����: {FF9900}%d ���", fmt_str, GetBusinessData(businessid, B_ENTER_PRICE));
			}
			else strcat(fmt_str, "{66CC00}���� ���������");
		}
		else strcat(fmt_str, "{FF6600}�������");
	}
	UpdateDynamic3DTextLabelText(GetBusinessData(businessid, B_LABEL), 0xFFFF00FF, fmt_str);
}

public: UpdateRealtorBizInfo()
{
	new count = 0;
	new fmt_str[128];
	
	g_business_realtor_list = "";
	for(new idx; idx < g_business_loaded; idx ++)
	{
		if(IsBusinessOwned(idx)) continue;
		g_business_realtor_list_idx[count ++] = idx;
		
		format(fmt_str, sizeof fmt_str, "%d\n", idx);
		strcat(g_business_realtor_list, fmt_str);
	}
	
	count = GetFreeBusinessCount();
	format
	(
		fmt_str, sizeof fmt_str,
		"��������� �������\n"\
		"(����������� ������ ���)\n\n"\
		"{FF6633}������� ��������: %d\n"\
		"{99FF33}�������� ��������: %d", 
		g_business_loaded - count, 
		count
	);
	UpdateDynamic3DTextLabelText(g_business_realtor_label, 0xCCFF66FF, fmt_str);
}

public: SetRealtorMakePhoto(playerid, type, index)
{
	if(GetPlayerData(playerid, P_REALTOR_TYPE) == type) 
	{
		new Float: angle;
		new Float: pos_x, Float: pos_y, Float: pos_z;
		new Float: exit_x, Float: exit_y, Float:cam_x, Float:cam_y;
		
		switch(type)
		{
			case REALTOR_TYPE_HOUSE:
			{
				new entranceid = GetHouseData(index, H_ENTRACE);
				if(entranceid != -1)
				{
					pos_x = GetEntranceData(entranceid, E_POS_X);
					pos_y = GetEntranceData(entranceid, E_POS_Y);
					pos_z = GetEntranceData(entranceid, E_POS_Z);
					
					exit_x = GetEntranceData(entranceid, E_EXIT_POS_X);
					exit_y = GetEntranceData(entranceid, E_EXIT_POS_Y);
				
					new fmt_str[32];
					format(fmt_str, sizeof fmt_str, "����� ��������: %d", entranceid + 1);
					SendClientMessage(playerid, 0x999999FF, fmt_str);
				}
				else
				{
					pos_x = GetHouseData(index, H_POS_X);
					pos_y = GetHouseData(index, H_POS_Y);
					pos_z = GetHouseData(index, H_POS_Z);
					
					exit_x = GetHouseData(index, H_EXIT_POS_X);
					exit_y = GetHouseData(index, H_EXIT_POS_Y);
				}
			}
			case REALTOR_TYPE_BIZ:
			{
				pos_x = GetBusinessData(index, B_POS_X);
				pos_y = GetBusinessData(index, B_POS_Y);
				pos_z = GetBusinessData(index, B_POS_Z);
				
				exit_x = GetBusinessData(index, B_EXIT_POS_X);
				exit_y = GetBusinessData(index, B_EXIT_POS_Y);
			}
		}
		angle = GetAngleToPoint(exit_x, exit_y, pos_x, pos_y);
		SetPlayerPos(playerid, pos_x, pos_y, pos_z);
		
		cam_x = pos_x + 15.0 * -floatsin(angle, degrees); 
		cam_y = pos_y + 15.0 * floatcos(angle, degrees);
		
		SetPlayerCameraPos(playerid, cam_x, cam_y, pos_z + 10.0);
		SetPlayerCameraLookAt(playerid, pos_x, pos_y, pos_z);
		
		HidePlayerWaitPanel(playerid);
		SetPlayerData(playerid, P_REALTOR_TYPE, type);
	}
}

public:	LoadFuelStations()
{
	new query[85], buffer[2];
	new Cache: result, rows;
	
	result = mysql_query(mysql, "SELECT fs.*, IFNULL(a.name, 'None') AS owner_name FROM fuel_stations fs LEFT JOIN accounts a ON a.id=fs.owner_id", true);
	rows = cache_num_rows();
	
	if(rows > MAX_FUEL_STATIONS)
	{
		rows = MAX_FUEL_STATIONS;
		print("[FuelST]: DB rows > MAX_FUEL_STATIONS");
	}
	
	for(new idx; idx < rows; idx ++)
	{
		SetFuelStationData(idx, FS_SQL_ID,		cache_get_field_content_int(idx, "id"));
		SetFuelStationData(idx, FS_OWNER_ID, 	cache_get_field_content_int(idx, "owner_id"));
		
		cache_get_field_content(idx, "name", g_fuel_station[idx][FS_NAME], mysql, 20);
	
		SetFuelStationData(idx, FS_CITY, 			cache_get_field_content_int(idx, "city"));
		SetFuelStationData(idx, FS_ZONE, 			cache_get_field_content_int(idx, "zone"));
		SetFuelStationData(idx, FS_IMPROVEMENTS, 	cache_get_field_content_int(idx, "improvements"));
		SetFuelStationData(idx, FS_FUELS, 			cache_get_field_content_int(idx, "fuels"));
		SetFuelStationData(idx, FS_FUEL_PRICE,		cache_get_field_content_int(idx, "fuel_price"));
		SetFuelStationData(idx, FS_BUY_FUEL_PRICE,	cache_get_field_content_int(idx, "buy_fuel_price"));
		SetFuelStationData(idx, FS_BALANCE,			cache_get_field_content_int(idx, "balance"));
		SetFuelStationData(idx, FS_RENT_DATE,		cache_get_field_content_int(idx, "rent_time"));
		
		SetFuelStationData(idx, FS_PRICE,			cache_get_field_content_int(idx, "price"));
		SetFuelStationData(idx, FS_RENT_PRICE,		cache_get_field_content_int(idx, "rent_price"));
		
		SetFuelStationData(idx, FS_LOCK_STATUS,		bool: cache_get_field_content_int(idx, "lock"));
		
		SetFuelStationData(idx, FS_POS_X,			cache_get_field_content_float(idx, "x"));
		SetFuelStationData(idx, FS_POS_Y,			cache_get_field_content_float(idx, "y"));
		SetFuelStationData(idx, FS_POS_Z,			cache_get_field_content_float(idx, "z"));
	
		cache_get_field_content(idx, "owner_name", g_fuel_station[idx][FS_OWNER_NAME], mysql, 21);
		// -------------------------
		
		SetFuelStationData(idx, FS_LABEL, CreateDynamic3DTextLabel(GetFuelStationData(idx, FS_NAME), 0x3399FFFF, GetFuelStationData(idx, FS_POS_X), GetFuelStationData(idx, FS_POS_Y), GetFuelStationData(idx, FS_POS_Z) + 0.5, 15.0));
		SetFuelStationData(idx, FS_AREA, CreateDynamicSphere(GetFuelStationData(idx, FS_POS_X), GetFuelStationData(idx, FS_POS_Y), GetFuelStationData(idx, FS_POS_Z), 15.0));
		
		SetFuelStationData(idx, FS_ORDER_ID, -1);
		
		if(GetFuelStationData(idx, FS_CITY) == -1 || GetFuelStationData(idx, FS_ZONE) == -1)
		{
			buffer[0] = Get2DCity(GetFuelStationData(idx, FS_POS_X), GetFuelStationData(idx, FS_POS_Y));
			buffer[1] = Get2DZone(GetFuelStationData(idx, FS_POS_X), GetFuelStationData(idx, FS_POS_Y));
			
			SetFuelStationData(idx, FS_CITY, buffer[0]);
			SetFuelStationData(idx, FS_ZONE, buffer[1]);
			
			format(query, sizeof query, "UPDATE fuel_stations SET city=%d,zone=%d WHERE id=%d", buffer[0], buffer[1], GetFuelStationData(idx, FS_SQL_ID));
			mysql_query(mysql, query, false);
		}
	
		if(IsFuelStationOwned(idx) && !strcmp(GetFuelStationData(idx, FS_OWNER_NAME), "None", true))
		{
			SetFuelStationData(idx, FS_OWNER_ID, 0);
			
			format(query, sizeof query, "UPDATE fuel_stations SET owner_id=0 WHERE id=%d", GetFuelStationData(idx, FS_SQL_ID));
			mysql_query(mysql, query, false);
		}
		
		if(!IsFuelStationOwned(idx))
		{
			SetFuelStationData(idx, FS_FUELS, 1000);
			SetFuelStationData(idx, FS_FUEL_PRICE, 3);
			
			SetFuelStationData(idx, FS_LOCK_STATUS, false);
		}
		CallLocalFunction("UpdateFuelStationLabel", "i", idx);
	
		#if defined FUEL_ST_CREATED_PICKUP
			CreatePickup(1650, 2, GetFuelStationData(idx, FS_POS_X), GetFuelStationData(idx, FS_POS_Y), GetFuelStationData(idx, FS_POS_Z), 0, PICKUP_ACTION_TYPE_FUEL_STATION, idx);
		#endif
		
		CreateDynamicMapIcon(GetFuelStationData(idx, FS_POS_X), GetFuelStationData(idx, FS_POS_Y), GetFuelStationData(idx, FS_POS_Z), 47, 0, 0, 0, -1, STREAMER_MAP_ICON_SD, MAPICON_LOCAL);
	}
	g_fuel_station_loaded = rows;
	cache_delete(result);
	
	printf("[FuelST]: �������� ���������: %d", g_fuel_station_loaded);
}

public: UpdateFuelStationLabel(stationid)
{
	new fmt_str[128 + 1];

	if(!IsFuelStationOwned(stationid))
	{
		format
		(
			fmt_str, sizeof fmt_str, 
			"%s\n"\
			"{FFFFFF}���� �� 10 ������: {FFCD00}%d ���\n\n"\
			"{CC9900}�������� ���������\n"\
			"����������� /buyfuelst\n"\
			"����: %d ���", 
			GetFuelStationData(stationid, FS_NAME),
			GetFuelStationData(stationid, FS_FUEL_PRICE) * 10,
			GetFuelStationData(stationid, FS_PRICE)
		);
		
	}
	else 
	{
		format
		(
			fmt_str, sizeof fmt_str, 
			"%s\n"\
			"{FFFFFF}��������: {66CC00}%s\n", 
			GetFuelStationData(stationid, FS_NAME),
			GetFuelStationData(stationid, FS_OWNER_NAME),
			GetFuelStationData(stationid, FS_FUEL_PRICE) * 10
		);
		
		if(GetFuelStationData(stationid, FS_LOCK_STATUS))
		{
			strcat(fmt_str, "{FF6600}������� �������");
		}
		else format(fmt_str, sizeof fmt_str, "%s{FFFFFF}���� �� 10 ������: {FFCD00}%d ���", fmt_str, GetFuelStationData(stationid, FS_FUEL_PRICE) * 10);
	}
	UpdateDynamic3DTextLabelText(GetFuelStationData(stationid, FS_LABEL), 0x3399FFFF, fmt_str);
}

public: OnGiveReferBonus(refer_id)
{
	new fmt_str[155];
	new playerid = GetPlayerIDBySqlID(refer_id);
	
	if(playerid != INVALID_PLAYER_ID)
	{
		GivePlayerMoneyEx(playerid, REFER_BONUS_MONEY, "����������� ��������� '�������� �����'", true, false);
		
		format(fmt_str, sizeof fmt_str, "�����������! ������������ ���� ����� ������ 5 ������, �� ��������� %d ������", REFER_BONUS_MONEY);
		SendClientMessage(playerid, 0x66CC00FF, fmt_str);
	}
	else
	{
		format(fmt_str, sizeof fmt_str, "INSERT INTO money_log (uid,uip,time,money,description) VALUES (%d,'%s',%d,%d,'%s')", refer_id, "system", gettime(), REFER_BONUS_MONEY, "����������� ��������� '�������� �����'");
		mysql_query(mysql, fmt_str, false);
	
		format(fmt_str, sizeof fmt_str, "UPDATE accounts SET money=money+%d WHERE id=%d LIMIT 1", REFER_BONUS_MONEY, refer_id);
		mysql_query(mysql, fmt_str, false);
		
		if(mysql_errno() != 0)
			printf("[Referal System]: ��������� ������ ��� ������ ������ ������ �%d", refer_id);
	}
}

public: OnSecondTimer()
{
	new minute;
	gettime(_, minute);

	new time = gettime();
	if(!minute)
	{
		if(GetElapsedTime(time, g_last_m_timer_time, CONVERT_TIME_TO_MINUTES) >= 1)
		{
			OnMinuteTimer(bool: GetElapsedTime(time, g_last_m_timer_time, CONVERT_TIME_TO_DAYS));
		}
	}

	foreach(new playerid : Player)
	{
		CallLocalFunction("OnPlayerTimer", "i", playerid);
	}
}

public: OnMinuteTimer(bool: new_day)
{
	new time;
	new hour, minute, second;

	time = gettime();
	gettime(hour, minute, second);
	
	switch(minute)
	{
		case 0:
		{
			if(GetElapsedTime(time, g_last_pay_day_time) >= 1)
			{
				OnPayDay();
			}			
		}
		case 2:
		{
			if(GetElapsedTime(time, g_last_lottery_time) >= 1)
			{
				OnLottery();
			}	
		}
	}
	
	if(new_day)
	{
		SetTimer("ClearBanList", 15_000, false);
	}

	SetWorldTime(hour);
	OnPlayersWorldTimeInit(hour, minute);
	
	g_last_m_timer_time = time;
}

public: OnPlayersWorldTimeInit(hour, minute)
{
	foreach(new playerid : Player)
	{
		SetPlayerTime(playerid, hour, minute);
	}
}

public: OnLottery()
{
	new fmt_str[85];
	new buffer[4];
	
	new lottery_str[4];
	new lottery_number;
	new buy_tickets_count;
	new hour, count;
	
	gettime(hour);
	lottery_number = random(900) + 100;
	
	valstr(lottery_str, lottery_number);
	buy_tickets_count = LotteryBuyTicketCount();
	
	static const
		lottery_pay[3] = {2000, 15_000, 50_000};
		
	foreach(new playerid : Player)
	{
		if(IsPlayerLogged(playerid))
		{
			if(GetPlayerData(playerid, P_LOTTERY))
			{
				format(fmt_str, sizeof fmt_str, "������ %d:02! �������� ���������� ��������. ���� ���������� �����: %d", hour, GetPlayerData(playerid, P_LOTTERY));
				SendClientMessage(playerid, 0xFFFF00FF, fmt_str);
				
				format(fmt_str, sizeof fmt_str, "�� ���� ��� ���� ������� %d �������. ���������� ����� ����� ����: {FF9900}%d", buy_tickets_count, lottery_number);
				SendClientMessage(playerid, 0x66CC00FF, fmt_str);
				
				valfmt(buffer, GetPlayerData(playerid, P_LOTTERY));
				
				for(count = 0; count < 3; count ++)
					if(lottery_str[count] != buffer[count]) break;
			
				switch(count)
				{
					case 0:
					{
						SendClientMessage(playerid, 0xFFFFFFFF, "� ��������� � ����� ������ �� ������� ������ �����");
						SendClientMessage(playerid, 0xFFFFFFFF, "�� ���������������. � ��������� ��� ��� ����������� ������");			
					}
					case 1..3:
					{
						GivePlayerMoneyEx(playerid, lottery_pay[count-1], "������� � �������", true, true);
					
						format(fmt_str, sizeof fmt_str, "� ����� ������ ������� %d �����! �������: %d ������", count, lottery_pay[count-1]);
						SendClientMessage(playerid, 0x3399FFFF, fmt_str);
					}
				}
				SetPlayerData(playerid, P_LOTTERY, 0);
			}
		}
	}
	g_last_lottery_time = gettime();
}

public: OnPayDay()
{
	new fmt_str[144];
	new level, cur_time;
	new hour, minute, second;

	cur_time = gettime();
	gettime(hour, minute, second);
	
	SetWorldTime(hour);
	
	format(fmt_str, sizeof fmt_str, "������� �����: {3399FF}%02d:00", hour);
	SendClientMessageToAll(0xFFFFFFFF, fmt_str);	
	
	foreach(new playerid : Player)
	{
		if(IsPlayerLogged(playerid))
		{
			SendClientMessage(playerid, 0xFFFFFFFF, "   ���������� ���");
			SendClientMessage(playerid, 0xFFFFFFFF, "______________________");
			SendClientMessage(playerid, 0xFFFFFFFF, " ");
			
			level = GetPlayerLevel(playerid);
			if(!IsPlayerAFK(playerid))
			{
				if(ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_HOUR), CONVERT_TIME_TO_MINUTES) >= 20)
				{
					AddPlayerData(playerid, P_BANK, +, GetPlayerData(playerid, P_WAGE));
				
					format(fmt_str, sizeof fmt_str, "��������: {66CC00}%d ���", GetPlayerData(playerid, P_WAGE));
					SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
					
					format(fmt_str, sizeof fmt_str, "������� ������ �����: {%s}%d ���", GetPlayerBankMoney(playerid) > 0 ? ("00CC00") : ("FF3300"), GetPlayerBankMoney(playerid));
					SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
					
					SetPlayerData(playerid, P_WAGE, 0);
					AddPlayerData(playerid, P_EXP, +, 1);
					
					//if(!IsPlayerAfk(i))
					//{
					if(GetPlayerExp(playerid) > GetExpToNextLevel(playerid))
					{
						SetPlayerData(playerid, P_EXP, 0);
						AddPlayerData(playerid, P_LEVEL, +, 1);
						
						SetPlayerLevelInit(playerid);
					}
					//}
				}
				else SendClientMessage(playerid, 0xFFBB00FF, "��� ��������� �������� ���������� ���������� � ���� ������� 20 �����");
			}
			else SendClientMessage(playerid, 0xFFBB00FF, "�� �� ������ ���������� �� ����� ��� ��������� ��������");
		
			SendClientMessage(playerid, 0xFFFFFFFF, "______________________");
			if(GetPlayerLevel(playerid) > level)
			{
				SendClientMessage(playerid, 0x3399FFFF, "�����������! ��� ������� �������");
				switch(GetPlayerLevel(playerid))
				{
					case 2:
					{
						SendClientMessage(playerid, 0x66CC00FF, "�� ������ ������ ��� ����� ����� � ����� ������");
						SendClientMessage(playerid, 0x66CC00FF, "�������� ����� ������ �������� ��������");
					}
					case 5:
					{
						CallLocalFunction("OnGiveReferBonus", "i", GetPlayerData(playerid, P_REFER));
					}
					/*
					case 3: 
						SendClientMessage(playerid, 0x66CC00FF, "�������� ����� ������ ��������");
						
					case 4: 
						SendClientMessage(playerid, 0x66CC00FF, "�������� ����� ������ �������������");
						
					case 5: 
						SendClientMessage(playerid, 0x66CC00FF, "�������� ����� ������ �������������");
						
					case 6: 
						SendClientMessage(playerid, 0x66CC00FF, "�������� ����� ������ �������� ��������");
						
					case 7: 
						SendClientMessage(playerid, 0x66CC00FF, "�������� ����� ������ ���������� ���");
					*/
				}
			}
			format(fmt_str, sizeof fmt_str, "UPDATE accounts SET level=%d,exp=%d,bank=%d,wage=0,last_login=%d,game_for_hour=0 WHERE id=%d LIMIT 1", GetPlayerLevel(playerid), GetPlayerExp(playerid), GetPlayerBankMoney(playerid), cur_time, GetPlayerAccountID(playerid));
			mysql_query(mysql, fmt_str, false);
			
			if(mysql_errno() != 0)
				SendClientMessage(playerid, 0xFF6600FF, "������ ���������� �������� {FF0000}(equ-code 100)");
		}
		SetPlayerData(playerid, P_GAME_FOR_HOUR, 0);
	}
	
	/*
	SellDebtorsProperty();

	*/
	#if defined RAND_WEATHER
	SetTimer("SetRandomWeather", (random(60) + 60) * 1000, false);
	#endif
	
	CallLocalFunction("UpdateRealtorHomeInfo", "");
	CallLocalFunction("UpdateRealtorBizInfo", "");
	
	g_last_pay_day_time = cur_time;
	return 1;
}

public: OnPlayerTimer(playerid)
{
	if(IsPlayerLogged(playerid))
	{
		new fmt_str[128];
		new speed = GetPlayerSpeed(playerid);
	
		AddPlayerData(playerid, P_AFK_TIME, +, 1);
		if(IsPlayerAFK(playerid))
		{
			new afk_minutes = ConvertUnixTime(GetPlayerAFKTime(playerid), CONVERT_TIME_TO_MINUTES);
			new afk_seconds = ConvertUnixTime(GetPlayerAFKTime(playerid));
			
			if(afk_minutes > 0)
			{
				format(fmt_str, sizeof fmt_str, "�� ����� %d:%02d", afk_minutes, afk_seconds);
			}
			else format(fmt_str, sizeof fmt_str, "�� ����� %d ���.", afk_seconds);
			
			SetPlayerChatBubble(playerid, fmt_str, 0xFF0000FF, 7.0, 1500);
		
			if(afk_minutes >= MAX_AFK_TIME)
				Kick:(playerid, "��������� ����������� ���������� ����� �����");
		}
		else 
		{
			AddPlayerData(playerid, P_GAME_FOR_HOUR, +, 1);
			AddPlayerData(playerid, P_GAME_FOR_DAY, +, 1);
		}
		
		if(GetPlayerData(playerid, P_MASK) >= 2)
		{
			AddPlayerData(playerid, P_MASK, -, 1);
			if(GetPlayerData(playerid, P_MASK) <= 2)
			{
				GameTextForPlayer(playerid, "~y~invisible off", 2500, 4);
				
				SetPlayerColorInit(playerid);
				SetPlayerData(playerid, P_MASK, 0);
			}
		}
		
		if(GetPlayerGPSInfo(playerid, G_ENABLED) == GPS_STATUS_ON)
		{
			if(IsPlayerInRangeOfPoint(playerid, 30.0, GetPlayerGPSInfo(playerid, G_POS_X), GetPlayerGPSInfo(playerid, G_POS_Y), GetPlayerGPSInfo(playerid, G_POS_Z)))
			{
				DisablePlayerGPS(playerid);
			}
		}
		
		if(IsPlayerDriver(playerid))
		{
			//new Float: health;
			new vehicleid = GetPlayerVehicleID(playerid);
			if(!IsABike(vehicleid))
			{
				new	Float: fuels = GetVehicleData(vehicleid, V_FUEL);
				
				//GetVehicleHealth(vehicleid, health);
				SetVehicleParamsInit(vehicleid);
				SetVehicleData(vehicleid, V_MILEAGE, GetVehicleData(vehicleid, V_MILEAGE) + (float(speed) / 3600.0));
				
				if(GetVehicleParamEx(vehicleid, V_ENGINE) == VEHICLE_PARAM_ON)
				{
					if(fuels <= 0.0)
					{
						SetVehicleParam(vehicleid, V_ENGINE, false);
						GameTextForPlayer(playerid, "~r~no fuel", 4000, 1);
					}
					else SetVehicleData(vehicleid, V_FUEL, fuels - 0.05);
				}
				
				format(fmt_str, sizeof fmt_str, "%d_~b~~h~~h~~h~:km/h", speed);
				PlayerTextDrawSetString(playerid, speedometr_PTD[playerid][0], fmt_str);
				
				format(fmt_str, sizeof fmt_str, "%07i", floatround(GetVehicleData(vehicleid, V_MILEAGE)));
				PlayerTextDrawSetString(playerid, speedometr_PTD[playerid][1], fmt_str);
				
				format(fmt_str, sizeof fmt_str, "Fuel:_~y~%d~n~~w~limit:_%s", floatround(fuels), GetVehicleData(vehicleid, V_LIMIT) == VEHICLE_PARAM_ON ? ("~g~ON") : ("~r~off"));
				PlayerTextDrawSetString(playerid, speedometr_PTD[playerid][2], fmt_str);
				
				format
				(
					fmt_str, sizeof fmt_str, 
					"%sM__%sL__%sB",
					GetVehicleParamEx(vehicleid, V_ENGINE) == VEHICLE_PARAM_ON ? ("~g~") : ("~w~"),
					GetVehicleParamEx(vehicleid, V_LIGHTS) == VEHICLE_PARAM_ON ? ("~g~") : ("~w~"),
					(GetVehicleParamEx(vehicleid, V_BONNET) == VEHICLE_PARAM_ON 
					|| GetVehicleParamEx(vehicleid, V_BOOT) == VEHICLE_PARAM_ON) ? ("~r~~h~") : ("~w~")
				);
				PlayerTextDrawSetString(playerid, speedometr_PTD[playerid][3], fmt_str);
				
				format(fmt_str, sizeof fmt_str, "%s", GetVehicleParamEx(vehicleid, V_LOCK) == VEHICLE_PARAM_ON ? ("~r~~h~close") : ("~g~~h~open"));
				PlayerTextDrawSetString(playerid, speedometr_PTD[playerid][4], fmt_str);
				
				/*
				format
				(
					fmt_str, sizeof fmt_str, 
					"%d_km/h__~h~Fuel_%d__~b~%d~n~"\
					"%s___%smax___%sE_%sS__%sM_%sL_%sB",
					GetPlayerSpeed(playerid),
					floatround(fuels),
					floatround(health),
					GetVehicleParamEx(vehicleid, V_LOCK) == VEHICLE_PARAM_ON ? ("~r~~h~Close") : ("~g~~h~Open"),
					GetVehicleData(vehicleid, V_LIMIT) == VEHICLE_PARAM_ON ? ("~r~~h~") : ("~w~"),
					floatround(fuels) < 15 ? ("~r~") : ("~w~"),
					GetVehicleData(vehicleid, V_ALARM) == VEHICLE_PARAM_ON ? ("~p~") : ("~w~"),
					GetVehicleParamEx(vehicleid, V_ENGINE) == VEHICLE_PARAM_ON ? ("~g~") : ("~w~"),
					GetVehicleParamEx(vehicleid, V_LIGHTS) == VEHICLE_PARAM_ON ? ("~g~") : ("~w~"),
					(GetVehicleParamEx(vehicleid, V_BOOT) == VEHICLE_PARAM_ON
					|| GetVehicleParamEx(vehicleid, V_BOOT) == VEHICLE_PARAM_ON) ? ("~r~") : ("~w~")
				);
				TextDrawSetString(speedometr_TD[playerid], fmt_str);
				*/
			}
		}
		else if(IsPlayerPassenger(playerid))
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			new driver = GetVehicleData(vehicleid, V_DRIVER_ID);
			
			if(driver != INVALID_PLAYER_ID && IsPlayerInJob(driver) && IsPlayerDriver(driver))
			{
				if(GetPlayerJobCar(driver) == vehicleid && IsPlayerInVehicle(driver, vehicleid))
				{
					g_taxi_mileage[playerid] += (float(speed) / 3600.0);
					if(g_taxi_mileage[playerid] > 0.1)
					{
						g_taxi_mileage[playerid] = 0.0;
					
						new tariff = GetPlayerData(driver, P_JOB_TARIFF);
						if(GetPlayerMoneyEx(playerid) >= tariff)
						{
							//GivePlayerMoneyEx(playerid, tariff, "+ ������ ������ �����", false, true);
							AddPlayerData(playerid, P_JOB_WAGE, +, tariff);
							
							format(fmt_str, sizeof fmt_str, "~r~-%d rub~n~~b~+100 m", tariff);
							GameTextForPlayer(playerid, fmt_str, 4000, 1);
							
							format(fmt_str, sizeof fmt_str, "~g~+%d rub~n~~b~+100 m", tariff);
							GameTextForPlayer(driver, fmt_str, 4000, 1);
						}
						else 
						{
							RemovePlayerFromVehicle(playerid);
							SendClientMessage(playerid, 0xFF6600FF, "������������ ����� ��� ���������� ������ ������");
						}
					}
				}
			}
		}
		
		if(GetPlayerTempJob(playerid) != TEMP_JOB_NONE)
		{
			CheckPlayerTempJobState(playerid);
		}
	}
	else 
	{
		if(GetPlayerData(playerid, P_AUTH_TIME) >= 0)
		{
			if(GetPlayerData(playerid, P_AUTH_TIME) >= MAX_AUTHORIZATION_TIME)
			{
				HidePlayerDialog(playerid);
				
				SendClientMessage(playerid, 0xFF6600FF, "����� �� ����������� ����������");
				Kick:(playerid);
			}
			else AddPlayerData(playerid, P_AUTH_TIME, +, 1);
		}
	}
}

public: CheckPlayerAccount(playerid, race)
{
	if(race == mysql_race[playerid])
	{
		new query[64];
		new Cache: result, is_account_exist;
		
		SendClientMessage(playerid, 0x3399FFFF, "����� ���������� �� "SERVER_NAME" RolePlay!");
		
		//SetPlayerPos(playerid, 1690.419189, -1950.881835, 13.5666);
		//TogglePlayerControllable(playerid, false);
		
		SetPlayerCameraPos(playerid, AUTH_CAMERA_POS);
		SetPlayerCameraLookAt(playerid, AUTH_CAMERA_LOOK);
		
		mysql_format(mysql, query, sizeof query, "SELECT * FROM accounts WHERE name='%e' LIMIT 1", GetPlayerNameEx(playerid));
		result = mysql_query(mysql, query);
		
		if(!mysql_errno())
		{
			is_account_exist = bool: cache_num_rows();
			SetPlayerData(playerid, P_ACCOUNT_STATE, is_account_exist + 1);
			
			if(is_account_exist)
			{
				SetPlayerData(playerid, P_ACCOUNT_ID, cache_get_field_content_int(0, "id"));
				
				cache_get_field_content(0, "password", g_player[playerid][P_PASSWORD], mysql, 16);
				cache_get_field_content(0, "last_ip", g_player[playerid][P_LAST_IP], mysql, 16);

				cache_get_field_content(0, "setting_phone", g_player[playerid][P_SETTING_PHONE], mysql, 13);
				cache_get_field_content(0, "setting_pin_code", g_player[playerid][P_SETTING_PIN], mysql, 5);
				
				SetPlayerData(playerid, P_REQUEST_PHONE, cache_get_field_content_int(0, "request_phone"));
				SetPlayerData(playerid, P_REQUEST_PIN, cache_get_field_content_int(0, "request_pin"));
				
				SetPlayerData(playerid, P_AUTH_TIME, 0);
				ShowPlayerLoginDialog(playerid, LOGIN_STATE_CHECK_BAN, false);
			}
			else ShowPlayerRegDialog(playerid, REGISTER_STATE_PASSWORD);
		}
		else 
		{
			Dialog
			(
				playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
				"{FF9900}����������� ������",
				"{FFFFFF}���������� ������������ � ������� ��-�� ���� ��������� ��������\n"\
				"���� �������� �� �������� � ������� ���������� ����� ���������� � �������������",
				"�����", ""
			);
			Kick:(playerid, "������ ����������. ������� /q (/quit) ����� �����", 3000);
		}
		cache_delete(result);

		Object:Remove(playerid);
	}
}

public: LoadPlayerData(playerid)
{
	new query[128];
	new Cache: result;
	
	format(query, sizeof query, "SELECT * FROM accounts WHERE id=%d LIMIT 1", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query);
	
	if(cache_num_rows())
	{
		new 
			buffer = 0, 
			time = gettime();
		
		cache_get_field_content(0, "email", g_player[playerid][P_EMAIL], mysql, 61);
		SetPlayerData(playerid, P_CONFIRM_EMAIL, bool: cache_get_field_content_int(0, "confirm_email"));
		
		SetPlayerData(playerid, P_LEVEL, 	cache_get_field_content_int(0, "level"));
		SetPlayerData(playerid, P_EXP, 		cache_get_field_content_int(0, "exp"));
		
		SetPlayerData(playerid, P_REFER, 	cache_get_field_content_int(0, "refer"));
		SetPlayerData(playerid, P_SEX, 		bool: cache_get_field_content_int(0, "sex"));
		SetPlayerData(playerid, P_SKIN, 	cache_get_field_content_int(0, "skin"));
		SetPlayerData(playerid, P_MONEY, 	cache_get_field_content_int(0, "money"));
		SetPlayerData(playerid, P_BANK, 	cache_get_field_content_int(0, "bank"));
		SetPlayerData(playerid, P_ADMIN, 	cache_get_field_content_int(0, "admin"));
		
		SetPlayerData(playerid, P_DRIVING_LIC, 	cache_get_field_content_int(0, "driving_lic"));
		SetPlayerData(playerid, P_WEAPON_LIC, 	cache_get_field_content_int(0, "weapon_lic"));
		
		SetPlayerData(playerid, P_SUSPECT, 		cache_get_field_content_int(0, "suspect"));
		SetPlayerData(playerid, P_PHONE, 		cache_get_field_content_int(0, "phone"));
		SetPlayerData(playerid, P_PHONE_BALANCE,cache_get_field_content_int(0, "phone_balance"));
		SetPlayerData(playerid, P_PHONE_COLOR,	cache_get_field_content_int(0, "phone_color"));
		
		SetPlayerData(playerid, P_LAW_ABIDING,	cache_get_field_content_int(0, "law_abiding"));
		SetPlayerData(playerid, P_IMPROVEMENTS, cache_get_field_content_int(0, "improvements"));
		SetPlayerData(playerid, P_POWER, 		cache_get_field_content_int(0, "power"));
		
		SetPlayerData(playerid, P_DRUGS, 		cache_get_field_content_int(0, "drugs"));
		SetPlayerData(playerid, P_AMMO, 		cache_get_field_content_int(0, "ammo"));
		SetPlayerData(playerid, P_METALL, 		cache_get_field_content_int(0, "metall"));
		SetPlayerData(playerid, P_WIFE, 		cache_get_field_content_int(0, "wife"));
		SetPlayerData(playerid, P_TEAM, 		cache_get_field_content_int(0, "team"));
		SetPlayerData(playerid, P_SUBDIVISON,	cache_get_field_content_int(0, "subdivison"));
		SetPlayerData(playerid, P_WAGE,			cache_get_field_content_int(0, "wage"));
		SetPlayerData(playerid, P_JOB, 			cache_get_field_content_int(0, "job"));
		
		SetPlayerData(playerid, P_HOUSE_TYPE,	cache_get_field_content_int(0, "house_type"));
		SetPlayerData(playerid, P_HOUSE_ROOM,	cache_get_field_content_int(0, "house_room"));
		SetPlayerData(playerid, P_HOUSE, 		cache_get_field_content_int(0, "house"));
		SetPlayerData(playerid, P_BUSINESS,		cache_get_field_content_int(0, "business"));
		SetPlayerData(playerid, P_FUEL_ST,		cache_get_field_content_int(0, "fuel_st"));
		
		SetPlayerData(playerid, P_REG_TIME, 	cache_get_field_content_int(0, "reg_time"));
		cache_get_field_content(0, "reg_ip", g_player[playerid][P_REG_IP], mysql, 16);
	
		buffer = SetPlayerData(playerid, P_LAST_LOGIN_TIME,	cache_get_field_content_int(0, "last_login"));
		if(GetElapsedTime(time, buffer) < 1)
		{
			if(GetElapsedTime(time, g_last_pay_day_time) < 1)
				SetPlayerData(playerid, P_GAME_FOR_HOUR,	cache_get_field_content_int(0, "game_for_hour"));
		}
		SetPlayerData(playerid, P_GAME_FOR_DAY,			cache_get_field_content_int(0, "game_for_day"));
		SetPlayerData(playerid, P_GAME_FOR_DAY_PREV,	cache_get_field_content_int(0, "game_for_day_prev"));
		
		buffer = GetElapsedTime(time, buffer, CONVERT_TIME_TO_DAYS);
		if(buffer == 1)
		{
			SetPlayerData(playerid, P_GAME_FOR_DAY_PREV, GetPlayerData(playerid, P_GAME_FOR_DAY));
			SetPlayerData(playerid, P_GAME_FOR_DAY, 0);
		}
		else if(buffer > 1)
		{
			SetPlayerData(playerid, P_GAME_FOR_DAY, 0);
			SetPlayerData(playerid, P_GAME_FOR_DAY_PREV, 0);
		}
		
		SetPlayerSettingData(playerid, S_CHAT_TYPE, 	cache_get_field_content_int(0, "setting1"));
		SetPlayerSettingData(playerid, S_TEAM_CHAT, 	cache_get_field_content_int(0, "setting2"));
		SetPlayerSettingData(playerid, S_NICK_IN_CHAT, 	cache_get_field_content_int(0, "setting4"));
		SetPlayerSettingData(playerid, S_ID_IN_CHAT, 	cache_get_field_content_int(0, "setting5"));
		SetPlayerSettingData(playerid, S_VEH_CONTROL, 	cache_get_field_content_int(0, "setting6"));
		
		// -------------------------------------------------------------------------
		
		SetPlayerSpawnInit(playerid);
		SpawnPlayer(playerid);
		
		if(GetPlayerData(playerid, P_SKIN))
		{
			mysql_format(mysql, query, sizeof query, "UPDATE accounts SET last_ip='%e',last_login=%d WHERE id=%d LIMIT 1", GetPlayerIpEx(playerid), time, GetPlayerAccountID(playerid));
			mysql_tquery(mysql, query, "", "");
		
			format(query, sizeof query, "~y~Welcome ~n~~b~%s", GetPlayerNameEx(playerid));
			GameTextForPlayer(playerid, query, 3000, 1);
			
			if(!GetPlayerData(playerid, P_CONFIRM_EMAIL))
			{
				SendClientMessage(playerid, 0xFFA040FF, "��� ����������� �� ������� Email, �� �� ����������� ���");
				SendClientMessage(playerid, 0xFFA040FF, "�� ������ ������� ��� ����� ������, ����� /menu > ��������� ������������");
				SendClientMessage(playerid, 0xFFA040FF, "��� ������������� Email ������������ ������ � �������� ����� ����������");
			}
			
			if((buffer = GetPlayerHouse(playerid, HOUSE_TYPE_HOME)) != -1)
			{
				if(GetElapsedTime(GetHouseData(buffer, H_RENT_DATE), time, CONVERT_TIME_TO_DAYS) < 5)
				{
					SendClientMessage(playerid, 0xFFB500FF, "���� ������ ������ ���� ����� �������������");
				}	
			}
			if((buffer = GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL)) != -1)
			{
				new room_id = GetPlayerData(playerid, P_HOUSE_ROOM);
				if(GetElapsedTime(GetHotelData(buffer, room_id, H_RENT_DATE), time, CONVERT_TIME_TO_DAYS) < 5)
				{
					SendClientMessage(playerid, 0xFFB500FF, "� ��� �������� ���� ���������� ���� � ���������");
				}	
			}
			if((buffer = GetPlayerBusiness(playerid)) != -1)
			{
				if(GetElapsedTime(GetBusinessData(buffer, B_RENT_DATE), time, CONVERT_TIME_TO_DAYS) < 5)
				{
					SendClientMessage(playerid, 0xFFB500FF, "���� ������ ������ ������� ����� �������������");
				}	
			}
			if((buffer = GetPlayerFuelStation(playerid)) != -1)
			{
				if(GetElapsedTime(GetFuelStationData(buffer, FS_RENT_DATE), time, CONVERT_TIME_TO_DAYS) < 5)
				{
					SendClientMessage(playerid, 0xFFB500FF, "���� ������ ����� ��� ����� �������������");
				}
			}
			SetPlayerInit(playerid);
			SetTimerEx("PlayerOwnableCarInit", 250, false, "i", playerid);
		
			//CallLocalFunction("PlayerOwnableCarInit", "i", playerid);
		}
		else 
		{
			SetPlayerData(playerid, P_ACCOUNT_STATE, ACCOUNT_STATE_REG_SKIN);
			SendClientMessage(playerid, 0x66CC00FF, "�������� ��������� ������ ���������");
		}
	}
	cache_delete(result);
}

public: ShowPlayerLoginDialog(playerid, step, wrong_pass)
{
	if(GetPlayerData(playerid, P_ACCOUNT_STATE) != ACCOUNT_STATE_LOGIN) return 0;
	
	/*
	new request_type = REQUEST_TYPE_OFF;
	if(strcmp(GetPlayerIpEx(playerid), GetPlayerData(playerid, P_LAST_IP)) != 0)
	{
		request_type = REQUEST_TYPE_IP;
	}
	else
	{
		new subnet_last_ip[16], subnet_cur_ip[16];
		
		GetSubnet(subnet_cur_ip, GetPlayerIpEx(playerid));
		GetSubnet(subnet_last_ip, GetPlayerData(playerid, P_LAST_IP));
		
		if(strcmp(subnet_cur_ip, subnet_last_ip) != 0)
		{
			request_type = REQUEST_TYPE_SUBNET;
		}
	}
	*/
	
	new fmt_str[256];
	switch(step)
	{
		case LOGIN_STATE_CHECK_BAN:
		{
			new Cache: result;
		
			format(fmt_str, sizeof fmt_str, "SELECT * FROM ban_list WHERE user_id=%d LIMIT 1", GetPlayerAccountID(playerid));
			result = mysql_query(mysql, fmt_str, true);
			
			if(cache_num_rows())
			{
				new unban_time = cache_get_field_content_int(0, "ban_time");
				new ban_days = GetElapsedTime(unban_time, gettime(), CONVERT_TIME_TO_DAYS);
				
				if(ban_days)
				{
					new reason[32];
					new admin_name[21];

					new year, month, day;
					new hour, minute, second;
					new ban_time = cache_get_field_content_int(0, "time");
				
					cache_get_field_content(0, "description", reason);
					cache_get_field_content(0, "admin", admin_name);
					
					timestamp_to_date(ban_time, year, month, day, hour, minute, second);
					format
					(
						fmt_str, sizeof fmt_str, 
						"{FFFFFF}���� ������� ������������ �� {FF3333}%d ����\n\n"\
						"{FFFFFF}��� ��������������: %s\n"\
						"������� ����������: %s\n"\
						"���� � �����: %d-%02d-%02d %02d:%02d:%02d\n\n"\
						"������� {FFCD00}/q (/quit) {FFFFFF}����� �����",
						ban_days,
						admin_name,
						reason,
						year, month, day, hour, minute, second
					);
					Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{3399FF}"SERVER_NAME" RolePlay", fmt_str, "�������", "");
				
					Kick:(playerid, " ", 3000);
				}
				else 
				{
					format(fmt_str, sizeof fmt_str, "DELETE FROM ban_list WHERE user_id=%d LIMIT 1", GetPlayerAccountID(playerid));
					mysql_tquery(mysql, fmt_str, "", "");
				
					CallLocalFunction("ShowPlayerLoginDialog", "iii", playerid, step + 1, false);
				}
			}
			else CallLocalFunction("ShowPlayerLoginDialog", "iii", playerid, step + 1, false);
		
			return cache_delete(result);
		}
		case LOGIN_STATE_PASSWORD:
		{
			format
			(
				fmt_str, sizeof fmt_str, 
				"{FFFFFF}����� ���������� �� ������ "SERVER_NAME" RolePlay\n"\
				"������� � ����� ����� ���������������\n\n"\
				"�����: {66CC66}%s\n",
				GetPlayerNameEx(playerid)
			);
			if(wrong_pass)
			{
				new ch[3];
				new attemps = GetPlayerData(playerid, P_PASS_ATTEMPS);
				
				valstr(ch, attemps);

				strcat(fmt_str, "{FF3300}�������� ������! �������� �������: ");
				strcat(fmt_str, ch);
				
				AddPlayerData(playerid, P_PASS_ATTEMPS, -, 1);
				switch(attemps)
				{
					case 0:
					{
						Dialog
						(
							playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
							"{FF9933}����� ������� �����������",
							"{FFFFFF}�� ����� ������������ ������ 3 ���� ������. ��� IP ����� ������� �� �����",
							"�������", ""
						);
						Kick:(playerid, " ");
						
						BanEx(playerid, "����� ������� �����������");
						return AddBan(0, gettime(), 1, GetPlayerIpEx(playerid), "����� ������� �����������", "������� ������������");
					}
					case 1:
					{
						SendClientMessage(playerid, 0xFF6600FF, "��� ������������ ����� ������ �� ������ ��������");
					}
				}
				PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
			}
			else strcat(fmt_str, "{FFFFFF}������� ������ �� ��������:");
			
			Dialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "{66CCFF}�����������", fmt_str, "�����", "������");
		}
		case LOGIN_STATE_PHONE: // ���� 5 ������. ���� ��������
		{
			if(GetPlayerData(playerid, P_REQUEST_PHONE))
			{
				if(!wrong_pass)
				{
					new phone[13];
					
					strmid(phone, GetPlayerData(playerid, P_SETTING_PHONE), 0, strlen(GetPlayerData(playerid, P_SETTING_PHONE)) - 5);
					strcat(phone, "*****");
					
					format
					(
						fmt_str, sizeof fmt_str, 
						"{FFFFFF}������� ������������ ����������� ����\n"\
						"������ ���������� ��������\n\n{FFCD00}%s\n\n"\
						"{FFFFFF}������� ��������� 5 ���� ������:",
						phone
					);
					Dialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "{66CCFF}��������� �������", fmt_str, "������", "�����");
				}
				else 
				{
					SendClientMessage(playerid, 0xFF0000FF, "����� ���������� �������� ������ �������. ������ ��������");
					Kick:(playerid);
				}
			}
			else 
			{
				return CallLocalFunction("ShowPlayerLoginDialog", "iii", playerid, step + 1, false);
			}
		}
		case LOGIN_STATE_PIN_CODE: // ���� ��� ����
		{
			if(GetPlayerData(playerid, P_REQUEST_PIN))
			{
				if(wrong_pass)
				{
					SendClientMessage(playerid, 0xFF0000FF, "PIN-��� ������ �������. ������ ��������");
					Kick:(playerid);
				}
				else ShowPlayerPinCodePTD(playerid, PIN_CODE_STATE_LOGIN_CHECK);
			}
			else 
			{
				return CallLocalFunction("ShowPlayerLoginDialog", "iii", playerid, step + 1, false);
			}
		}
		case LOGIN_STATE_LOAD_ACC:
		{
			SetPlayerData(playerid, P_AUTH_TIME, -1);
			LoadPlayerData(playerid);
		}
	}
	SetPlayerData(playerid, P_ACCOUNT_STEP_STATE, step);
	
	return 1;
}

public: ClearPlayerAnim(playerid)
{
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 0);
}


public: ClearPlayerChatAnim(playerid)
{
	if(GetPlayerData(playerid, P_USE_ANIM_TYPE) == USE_ANIM_TYPE_CHAT)
	{
		ClearPlayerAnim(playerid);
		SetPlayerData(playerid, P_USE_ANIM_TYPE, USE_ANIM_TYPE_NONE);
	}
}

public: SetPlayerLoaderJobLoad(playerid) // ����� ����
{
	if(GetPlayerTempJob(playerid) == TEMP_JOB_LOADER)
	{
		if(GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_LOADER_LOAD)
		{
			new rand = random(sizeof loader_job_attach_obj);
		
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 0);			
			SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_FOREARM, loader_job_attach_obj[rand][L_OBJECT], A_OBJECT_BONE_LEFT_FOREARM, loader_job_attach_obj[rand][L_POS_X], loader_job_attach_obj[rand][L_POS_Y], loader_job_attach_obj[rand][L_POS_Z], loader_job_attach_obj[rand][L_ROT_X], 0.0, loader_job_attach_obj[rand][L_ROT_Z], 1.0, 1.0, 1.0, 0);
			
			SetPlayerLoaderJobUnLoadCP(playerid);
			
			if(!random(6))
				SetPlayerTempJobState(playerid, TEMP_JOB_STATE_LOADER_DROP_LOAD);
		}
	}
}

public: SetPlayerMinerJobTakeOre(playerid, step)
{
	if(GetPlayerTempJob(playerid) == TEMP_JOB_MINER)
	{
		new time = 1000;
		
		switch(step)
		{
			case 1:
			{
				RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND);
				
				ClearAnimations(playerid);
				ApplyAnimation(playerid, "CARRY", "liftup", 8.0, 0, 0, 0, 0, 0, 0);
			
				SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 3931, A_OBJECT_BONE_LEFT_HAND, 0.1, 0.05, -0.1, 0.0, 90.0, 0.0, 0.2, 0.2, 0.2, 0);
				SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND + 1, 2936, A_OBJECT_BONE_RIGHT_HAND, 0.1, 0.05, 0.1, 0.0, 90.0, 0.0, 0.2, 0.2, 0.2, 0);
			}
			case 2:
			{
				ApplyAnimation(playerid, "GHANDS", "gsign3LH", 4.1, 0, 1, 1, 1, 2250, 0);
				
				time = 2500;
			}
			case 3:
			{
				RemovePlayerAttachedObjectEx(playerid, A_OBJECT_SLOT_HAND, A_OBJECT_SLOT_HAND + 1);
				
				SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_SPINE, 1458, A_OBJECT_BONE_SPINE, -0.9, 0.7, 0.02, 0.0, 90.0, 0.0, 0.58, 0.6, 0.4, 0);
				SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_SPINE + 1, 816, A_OBJECT_BONE_SPINE, -0.63, 1.3, 0.0, 270.0, 75.0, 0.0, 0.5, 0.4, 0.8, 0);
				
				SetPlayerMinerJobUnLoadCP(playerid);
				return ;
			}
			default:
				return ;
		}
		SetTimerEx("SetPlayerMinerJobTakeOre", time, false, "ii", playerid, step + 1);
	}
}

public: MinerCarriageMove(carriageid)
{
	new bool: status = miner_carriage[carriageid][MC_STATUS];
	if(status)
	{
		MoveDynamicObject(miner_carriage[carriageid][MC_OBJECT_ID], miner_carriage[carriageid][MC_START_POS_X], miner_carriage[carriageid][MC_START_POS_Y], miner_carriage[carriageid][MC_START_POS_Z], 10.0, 0.0, 0.0, 0.0);
	}
	else MoveDynamicObject(miner_carriage[carriageid][MC_OBJECT_ID], miner_carriage[carriageid][MC_END_POS_X], miner_carriage[carriageid][MC_END_POS_Y], miner_carriage[carriageid][MC_END_POS_Z], 10.0, 0.0, 0.0, 0.0);
	
	miner_carriage[carriageid][MC_STATUS] = (status ^ true);
}

public: NextBusRouteCP(playerid)
{
	if(GetPlayerJob(playerid) == JOB_BUS_DRIVER)
	{
		if(IsPlayerInJob(playerid))
		{
			new route_id = GetPlayerData(playerid, P_BUS_ROUTE);	
			new route_step = GetPlayerData(playerid, P_BUS_ROUTE_STEP);	
			new next_cp = route_step + 1;
	
			if(g_bus_route[route_id][next_cp][BRS_POS_X] == 0.0)
			{
				next_cp = 0;
			}

			SetPlayerRaceCheckpoint
			(
				playerid,
				g_bus_route[route_id][route_step][BRS_STOP],
				g_bus_route[route_id][route_step][BRS_POS_X],
				g_bus_route[route_id][route_step][BRS_POS_Y],
				g_bus_route[route_id][route_step][BRS_POS_Z],
				g_bus_route[route_id][next_cp][BRS_POS_X],
				g_bus_route[route_id][next_cp][BRS_POS_Y],
				g_bus_route[route_id][next_cp][BRS_POS_Z],
				4.0,
				RCP_ACTION_TYPE_BUS_ROUTE
			);
			AddPlayerData(playerid, P_BUS_ROUTE_STEP, +, 1);
		}
	}
}

public: StartPlayerJob(playerid, jobid)
{
	if(GetPlayerJob(playerid) == jobid)
	{
		if(!IsPlayerInJob(playerid))
		{
			new job_car = GetPlayerJobCar(playerid);
			if(IsPlayerInVehicle(playerid, job_car)) 
			{
				new action_type = GetVehicleData(job_car, V_ACTION_TYPE);
				new car_type = (action_type - VEHICLE_ACTION_TYPE_BUS_DRIVER) + 1; 
				
				if(jobid == car_type)
				{
					SetPlayerJobLoadItems(playerid, 0);
					
					SetPlayerData(playerid, P_JOB_WAGE, 0);
					SetPlayerData(playerid, P_IN_JOB, true);
					SetVehicleData(job_car, V_ACTION_ID, true);
				
					new fmt_str[128];
					
					switch(jobid)
					{
						case JOB_BUS_DRIVER:
						{
							new route_id = GetPlayerData(playerid, P_BUS_ROUTE);

							format(fmt_str, sizeof fmt_str, "%s\n{FFFFFF}��������� �������: {FF9900}%d ���", g_bus_routes[route_id][BR_NAME], GetPlayerData(playerid, P_JOB_TARIFF));
							CreateVehicleLabel(job_car, fmt_str, g_bus_routes[route_id][BR_COLOR], 0.0, 0.0, 2.6, 45.0);
						
							format(fmt_str, sizeof fmt_str, "����� ������ �������� �������� �� �������� %s", g_bus_routes[route_id][BR_NAME]);
							Action(playerid, fmt_str, _, false);

							NextBusRouteCP(playerid);
							
							SetPVarFloat(playerid, "car_damage", 1000.0);
						}
						case JOB_TAXI_DRIVER:
						{
							format(fmt_str, sizeof fmt_str, "%s{FFFF00}�����: %d ���", GetPlayerData(playerid, P_JOB_SERVICE_NAME), GetPlayerData(playerid, P_JOB_TARIFF));
							CreateVehicleLabel(job_car, fmt_str, 0x3399FFFF, 0.0, 0.0, 1.4, 25.0);
							
							Action(playerid, "����� ������ ��������", _, false);
						}
						case JOB_MECHANIC:
						{
							SetPlayerData(playerid, P_MECHANIC_FILL_PAY, 0);
							SetPlayerData(playerid, P_MECHANIC_REPAIR_PAY, 0);
						
							format(fmt_str, sizeof fmt_str, "%s{FFFFFF}�����������\n{999999}��� �������", GetPlayerData(playerid, P_JOB_SERVICE_NAME));
							CreateVehicleLabel(job_car, fmt_str, 0xCC9900FF, 0.0, 0.0, 2.0, 25.0);

							Action(playerid, "����� ������ ������������", _, false);							
						}
						/*
						case JOB_TRUCKER:
						{
							DeletePVar(playerid, "trucker_salary");
						
							if(job_car[TRUCKER_CAR][0] <= vehicleid <= (job_car[TRUCKER_CAR][0] + 5))
							{
								fmt_str = "������\n{FFFFFF}�������� ���������";
								
								Send(playerid, 0x66CC00FF, "����������� {3399FF}/bizlist {66CC00}����� ���������� ������ �� ���������� ��������");
								CallLocalFunction("Action", "isi", playerid, "����� ������ ���������� ���������", false);
							}
							else if((job_car[TRUCKER_CAR][0] + 6) <= vehicleid <= job_car[TRUCKER_CAR][1])
							{
								fmt_str = "������\n{FFFFFF}�������� �������";
								
								Send(playerid, 0x66CC00FF, "����������� {3399FF}/fuellist {66CC00}��� ��������� ������� �� ���������� ���");
								CallLocalFunction("Action", "isi", playerid, "����� ������ ���������� �������", false);
							}
							
							if(!IsValidDynamic3DTextLabel(vehicle[vehicleid][veh_label])) 
								vehicle[vehicleid][veh_label] = CreateDynamic3DTextLabel(fmt_str, 0x3399FFFF, 0.0, 2.1, 2.1, 20.0, _, vehicleid);	
							
						}
						*/
					}
				}
			}
		}
	}
	return 1;
}

public: EndPlayerJob(playerid)
{
	if(IsPlayerInJob(playerid))
	{
		new vehicleid = GetPlayerJobCar(playerid);
		if(vehicleid != INVALID_VEHICLE_ID)
		{
			SetVehicleToRespawn(vehicleid);
			SetPlayerData(playerid, P_JOB_CAR, INVALID_VEHICLE_ID);
		}
	}
	KillEndJobTimer(playerid);
	
	new fmt_str[128];
	new wage = GetPlayerJobWage(playerid);
	new items = GetPlayerJobLoadItems(playerid);
	
	SetPlayerData(playerid, P_JOB_WAGE, 0);
	SendClientMessage(playerid, 0xFFFF00FF, "������� ���� ��������!");
	
	SetPlayerData(playerid, P_IN_JOB, false);
	switch(GetPlayerData(playerid, P_JOB))
	{
		case JOB_BUS_DRIVER:
		{
			new Float: health = GetPVarFloat(playerid, "car_damage");
			new repair_sum;

			if(health < 1000.0)
				repair_sum = (floatround((1000.0 - health) + float(random(100)+10))) / 3;
			
			DisablePlayerRaceCheckpoint(playerid);
		
			format(fmt_str, sizeof fmt_str, "����������: {00FF00}%d ���", wage + (items * GetPlayerData(playerid, P_JOB_TARIFF)));
			SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
		
			format(fmt_str, sizeof fmt_str, "���������� ����������: {00FF00}%d{FFFFFF}. ������� ������� �� {00FF00}%d ���", items, items * GetPlayerData(playerid, P_JOB_TARIFF));
			SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
			
			format(fmt_str, sizeof fmt_str, "�� ������ ��������: {FF6600}-%d ���", repair_sum); 
			SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
		
			if(repair_sum < wage)
				wage -= repair_sum;
			
			//GiveMoney(playerid, salary, "�������� �������� ���������", true, true);
		}
		case JOB_TAXI_DRIVER:
		{
			DisablePlayerRaceCheckpoint(playerid);
			wage = items * GetPlayerData(playerid, P_JOB_TARIFF);
			
			format(fmt_str, sizeof fmt_str, "����������: {00FF00}%d ���", wage);
			SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
			
			format(fmt_str, sizeof fmt_str, "���������� ����������: {00FF00}%d", items);
			SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
		}
		case JOB_MECHANIC:
		{
			DisablePlayerRaceCheckpoint(playerid);
			wage = GetPlayerData(playerid, P_MECHANIC_FILL_PAY) + GetPlayerData(playerid, P_MECHANIC_REPAIR_PAY);
	
			format(fmt_str, sizeof fmt_str, "�������� �� ������: {00FF00}%d ���", GetPlayerData(playerid, P_MECHANIC_REPAIR_PAY));
			SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
			
			format(fmt_str, sizeof fmt_str, "�������� �� ��������: {00FF00}%d ���", GetPlayerData(playerid, P_MECHANIC_FILL_PAY));
			SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
			
			format(fmt_str, sizeof fmt_str, "����� ����������: {FFCD00}%d ���", wage);
			SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
		}
		
		/*
		case JOB_TRUCKER:
		{
			DisablePlayerRaceCheckpoint(playerid);
			
			salary = GetPVarInt(playerid, "trucker_salary");
			
			format(fmt_str, sizeof fmt_str, "���� ����� ������ ������� ���������� {00CC00}%d ���", salary);
			Send(playerid, -1, fmt_str);
			
			if(trucker_take_order[playerid] != -1)
				biz_orders[trucker_take_order[playerid]][bo_order_used] = false;
				
			return 1;
		}

		case JOB_PITCHMAN:
		{
			new marketid = player_use_market[playerid];
			player_use_market[playerid] = -1;
			
			if(marketid != -1)
			{
				market_status[marketid] = false;
				UpdateMarket(marketid);
			}
		
			salary = player_job_load_items[playerid];
		
			format(fmt_str, sizeof fmt_str, "����� ���������� �����������: {00FF00}%d", market_buyers_count[playerid]);
			Send(playerid, -1, fmt_str);
			
			format(fmt_str, sizeof fmt_str, "����� ������� ������� �� {00FF00}%d ���", salary);
			Send(playerid, -1, fmt_str);
		}
		
		case JOB_FIREFIGHTER:
		{	
			check_extinguish_the_fire{playerid} = false;

			DisablePlayerRaceCheckpoint(playerid);
			TextDrawHideForPlayer(playerid, time_to_fire_TD);
		
			salary = player_job_load_items[playerid];
		
			format(fmt_str, sizeof fmt_str, "�������� ������ ����������: {FF3333}%d", extinguished_fires_count[playerid]);
			Send(playerid, -1, fmt_str);
			
			format(fmt_str, sizeof fmt_str, "���������� {0099CC}%d ���", salary);
			Send(playerid, -1, fmt_str);
		}
		*/
		default: 
		{
			switch(GetPlayerTempJob(playerid))
			{
				case TEMP_JOB_FACTORY_TRUCKER:
				{
					RemovePlayerAttachedObjects(playerid);
					SetPlayerSkinInit(playerid);
					
					format(fmt_str, sizeof fmt_str, "���� ����� ������ ������� ���������� {00CC00}%d ���", wage);
					SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
					
					SetPlayerJobLoadItems(playerid, 0);
					SetPlayerTempJob(playerid, TEMP_JOB_NONE);
				}
			}
			return 1;
		}
	}
	SendClientMessage(playerid, 0x66CC00FF, "������ ����� ����������� �� ��� ���� �� ����� ��������");
	
	AddPlayerData(playerid, P_WAGE, +, wage);
	
	format(fmt_str, sizeof fmt_str, "UPDATE accounts SET wage=%d WHERE id=%d LIMIT 1", GetPlayerData(playerid, P_WAGE), GetPlayerAccountID(playerid));
	mysql_query(mysql, fmt_str, false);
	
	return 1;
}

public: ShowChangeNameHistory(playerid, name[])
{
	new fmt_str[64];
	new rows = cache_num_rows();
	
	if(!rows)
	{
		format(fmt_str, sizeof fmt_str, "{FFCD00}������� ����� %s", name);
		return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, fmt_str, "{FFFFFF}������� ��������� ���� ��������� �����", "�������", "");
	}
	
	new text[1024] = "{FFFFFF}";
	for(new idx; idx < rows; idx ++)
	{
		cache_get_row(idx, 0, fmt_str);
		strcat(fmt_str, "\n");
		
		strcat(text, fmt_str);
	}
	format(fmt_str, sizeof fmt_str, "{FFCD00}������� ����� %s", name);
	return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, fmt_str, text, "�������", "");
}

public: ShowPlayerPhoneBook(playerid)
{
	if(IsPlayerPhoneBookInit(playerid))
	{
		if(GetPlayerPhoneBookContacts(playerid) > 0)
		{
			new fmt_str[37];
			new string[((sizeof fmt_str) * MAX_PHONE_BOOK_CONTACTS) + 1];	
	
			for(new idx, count; idx < MAX_PHONE_BOOK_CONTACTS; idx ++)
			{
				if(!GetPlayerPhoneBook(playerid, idx, PB_SQL_ID)) continue;
				SetPlayerListitemValue(playerid, count ++, idx);
				
				format(fmt_str, sizeof fmt_str, "%s - tel.%s\n", GetPlayerPhoneBook(playerid, idx, PB_NAME), GetPlayerPhoneBook(playerid, idx, PB_NUMBER));
				strcat(string, fmt_str);
			}
			Dialog(playerid, DIALOG_PHONE_BOOK, DIALOG_STYLE_LIST, "{FFCD00}���������� �����", string, "��������", "������");
		}
		else 
		{
			SendClientMessage(playerid, 0xCECECEFF, "� ���������� ����� ��� �������");
			SendClientMessage(playerid, 0xCECECEFF, "����� �������� ����� ������� ������� {FFFF00}/add [id ������]");
		}
	}
	else
	{
		InitPlayerPhoneBook(playerid);
		CallLocalFunction("ShowPlayerPhoneBook", "i", playerid);
	}
	return 1;
}

public: BusinesGPSListInit()
{
	new rows;
	new query[64 + 1];
	new Cache: result;
	
	format(query, sizeof query, "SELECT * FROM business_gps ORDER BY pos DESC, time ASC LIMIT %d", MAX_BUSINESS_GPS);
	result = mysql_query(mysql, query, true);
	
	rows = cache_num_rows();
	for(new idx; idx < rows; idx ++)
	{
		SetBusinessGPSInfo(idx, BG_SQL_ID, 	cache_get_row_int(idx, 0));
		SetBusinessGPSInfo(idx, BG_BIZ_ID, 	cache_get_row_int(idx, 1));
		SetBusinessGPSInfo(idx, BG_POS, 	cache_get_row_int(idx, 2));
		SetBusinessGPSInfo(idx, BG_TIME, 	cache_get_row_int(idx, 3));
	}
	g_business_gps_count = rows;
	g_business_gps_init = true;
	
	cache_delete(result);
}

public: ShowPlayerGPSBusinessList(playerid)
{
	if(g_business_gps_init)
	{
		new businessid;
		
		new fmt_str[44];
		new string[(sizeof fmt_str) * MAX_BUSINESS_GPS];
		
		if(!g_business_gps_count)
			string = "� ������ ������ � ������ ��� ��������";
			
		for(new idx, count; idx < g_business_gps_count; idx ++)
		{
			businessid = GetBusinessGPSInfo(idx, BG_BIZ_ID);
			
			format(fmt_str, sizeof fmt_str, "%d. %s (%s)\n", idx + 1, GetBusinessData(businessid, B_NAME), GetCityName(GetBusinessData(businessid, B_CITY)));
			strcat(string, fmt_str);
			
			SetPlayerListitemValue(playerid, count ++, idx);
		}
		Dialog(playerid, DIALOG_GPS_BUSINESS, DIALOG_STYLE_LIST, "{FFCD00}������� �������", string, "��������", "�����");		
	}
	else 
	{
		BusinesGPSListInit();
		CallLocalFunction("ShowPlayerGPSBusinessList", "i", playerid);
	}
}

public: ShowPlayerBusinessDialog(playerid, operationid)
{
	new businessid = GetPlayerBusiness(playerid);
	if(businessid != -1)
	{
		switch(operationid)
		{
			case BIZ_OPERATION_PARAMS: // ���������� ���������
			{
				Dialog
				(
					playerid, DIALOG_BIZ_PARAMS, DIALOG_STYLE_LIST,
					"{33AACC}��������� ���������� �������",
					"1. {669966}������� {FFFFFF}��� {CC3333}������� {FFFFFF}������\n"\
					"2. ���������� ���� �� ����\n"\
					"3. �������� ��������� ��������\n"\
					"4. �������� ��������\n"\
					"5. �������� �����\n"\
					"6. ���������� ����������\n"\
					"7. �������� ������",
					"�������", "�����"
				);
			}
			case BIZ_OPERATION_LOCK: // ������� / �������
			{
				if(GetBusinessData(businessid, B_LOCK_STATUS))
				{
					SetBusinessData(businessid, B_LOCK_STATUS, false);
					SendClientMessage(playerid, 0x66CC00FF, "������ ������");					
				}
				else 
				{
					SetBusinessData(businessid, B_LOCK_STATUS, true);
					SendClientMessage(playerid, 0xFF6600FF, "������ ������");					
				}
				UpdateBusinessLabel(businessid);
				
				new query[75];
				format(query, sizeof query, "UPDATE business SET `lock`=%d WHERE `id`=%d LIMIT 1", GetBusinessData(businessid, B_LOCK_STATUS), GetBusinessData(businessid, B_SQL_ID));
				mysql_query(mysql, query, false);
				
				CallLocalFunction("ShowPlayerBusinessDialog", "ii", playerid, BIZ_OPERATION_PARAMS);
			}
			case BIZ_OPERATION_ENTER_PRICE: // ���������� ���� �� ����
			{
				Dialog
				(
					playerid, DIALOG_BIZ_ENTER_PRICE, DIALOG_STYLE_INPUT,
					"{33AACC}���� �� ����",
					"{FFFFFF}������� ������� ������ ������� �������\n"\
					"����� ����� � ��� ������\n\n"\
					"{669966}������ ���: �� 0 �� 5000 ������\n"\
					"��������� ���� �� ���� ����� ��������� ���� ������,\n"\
					"������ �������� ���������� ��������\n"\
					"{CC3333}��������� ���� ������� �� ��������� ����������� ����� �����", 
					"�������", "�����"
				);
			}
			case BIZ_OPERATION_PROD_PRICE: // ���������� ��������� ��������
			{
				Dialog
				(
					playerid, DIALOG_BIZ_PROD_PRICE, DIALOG_STYLE_INPUT,
					"{33AACC}��������� ��������",
					"{FFFFFF}��� �� ������ �������� ��������� �������� ��� �������\n"\
					"������� ���� � �������� �� 25 �� 200 ������\n\n"\
					"��������� �������� ���������� �����������������\n"\
					"������ ������� ��� ����������� ���������\n"\
					"��� ���� ����, ��� ������� ��� �������� ��� ���� �����\n"\
					"������ �������, ��� �������� ������� ����\n"\
					"����� �������� ��� � �����������", 
					"�������", "�����"
				);		
			}
			case BIZ_OPERATION_PROD_ORDER: // �������� ��������
			{
				Dialog
				(
					playerid, DIALOG_BIZ_ORDER_PRODS, DIALOG_STYLE_INPUT, 
					"{33AACC}����� ���������", 
					"{FFFFFF}������� ��������� �� ������ ��������?", 
					"��������", "�����"
				);
			}
			case BIZ_OPERATION_PROD_ORDER_CANCEL: // �������� �����
			{
				new order_id = GetBusinessData(businessid, B_ORDER_ID);
				if(order_id != -1)
				{
					new fmt_str[128];
					format
					(
						fmt_str, sizeof fmt_str, 
						"{FFFFFF}�� ������������� ������ �������� �����?\n"\
						"�� ���� ������� ����� ���������� {FFCD00}%d ���",
						GetOrderData(order_id, O_AMOUNT) * GetOrderData(order_id, O_PRICE)
					);
					Dialog(playerid, DIALOG_BIZ_ORDER_CANCEL, DIALOG_STYLE_MSGBOX, "{33AADD}������ ������", fmt_str, "��", "���");
				}
				else 
				{
					SendClientMessage(playerid, 0xFF6600FF, "�� �� ��������� ����� ��������� ��� ������ �������");
					CallLocalFunction("ShowPlayerBusinessDialog", "ii", playerid, BIZ_OPERATION_PARAMS);
				}
			}
			case BIZ_OPERATION_PROFIT_STATS: // ���������� ����������
			{
				new query[256];
				
				new time = gettime();
				new cur_day = time - (time % 86400);
				new start_day = cur_day - (86400 * 20);
				
				format(query, sizeof query, "SELECT FROM_UNIXTIME(time, '%%Y-%%m-%%d') AS date, SUM(money) as total FROM business_profit WHERE bid=%d AND view=1 AND time >= %d AND time < %d GROUP BY time ORDER BY time DESC LIMIT 20", GetBusinessData(businessid, B_SQL_ID), start_day, cur_day);
				mysql_tquery(mysql, query, "ShowBusinessProfit", "ii", playerid, ++ mysql_race[playerid]);
			}
			case BIZ_OPERATION_IMPROVEMENTS: // ���������	
			{
				new fmt_str[80];
				new string[512];
				
				new buffer[14 + 1];
				new i_level = GetBusinessData(businessid, B_IMPROVEMENTS);

				for(new idx; idx < sizeof(g_business_improvements); idx ++)
				{
					format(fmt_str, sizeof fmt_str, "%d �������:\t%s\t", idx + 1, g_business_improvements[idx][I_NAME]);
					
					switch(idx)
					{
						case 0,1,4: 
							buffer = "\t"; 
						
						case 5:
							buffer = "\t\t";
						
						default:
							buffer[0] = 0;
					}
					if(buffer[0] != EOS)
						strcat(fmt_str, buffer);
				
					if(i_level > idx)
					{
						strins(fmt_str, "{2277AA}", 0, sizeof fmt_str);
						strcat(fmt_str, "�������");
					}
					else 
					{
						if(i_level < idx)
						{
							strins(fmt_str, "{CC3344}", 0, sizeof fmt_str);
						}
						strcat(string, fmt_str);
						
						valfmt(buffer, g_business_improvements[idx][I_PRICE]);
						format(fmt_str, sizeof fmt_str, "%s ���", buffer);
						
						if(i_level == idx)
							strins(fmt_str, "{66CC33}", 0, sizeof fmt_str);
					}
					strcat(fmt_str, "\n");
					strcat(string, fmt_str);
				}
				Dialog(playerid, DIALOG_BIZ_IMPROVEMENT, DIALOG_STYLE_LIST, "{33AADD}��������� ���������", string, "������", "�����");
			}
		}
	}
	
	return 1;
}

public: ShowBusinessProfit(playerid, race)
{
	if(race != mysql_race[playerid])
	{
		new string[600];
		new fmt_str[32];
		new rows = cache_num_rows();
		
		if(rows)
		{		
			string = "����\t\t\t�������\n\n{FFFFFF}";
		}
		else string = "{FFFFFF}���������� ���������� ������ ������� ��� �� ������������";
		
		for(new idx; idx < rows; idx ++)
		{
			cache_get_row(idx, 0, fmt_str, mysql, sizeof fmt_str);
			strcat(string, fmt_str);
			
			format(fmt_str, sizeof fmt_str, "\t\t%d ���\n", cache_get_row_int(idx, 1));
			strcat(string, fmt_str);
		}
		Dialog(playerid, DIALOG_BIZ_INFO, DIALOG_STYLE_MSGBOX, "{33AADD}����� ������� �� 20 ����", string, "<< �����", "�������");
	}
}

public: ShowPlayerFuelStationDialog(playerid, operationid)
{
	new stationid = GetPlayerFuelStation(playerid);
	if(stationid != -1)
	{
		switch(operationid)
		{
			case FUEL_ST_OPERATION_PARAMS:
			{
				Dialog
				(
					playerid, DIALOG_FUEL_STATION_PARAMS, DIALOG_STYLE_LIST,
					"{33AACC}��������� ����������� �������",
					"1. {669966}������� {FFFFFF}��� {CC3333}������� {FFFFFF}����������� �������\n"\
					"2. ����� ��������\n"\
					"3. �������� ���� �� �������\n"\
					"4. ���������� ���������� ����\n"\
					"5. �������� �������\n"\
					"6. �������� �����\n"\
					"7. ���������� ����������\n"\
					"8. �������� ����������� �������",
					"�������", "�����"
				);
			}
			case FUEL_ST_OPERATION_LOCK:
			{
				if(GetFuelStationData(stationid, FS_LOCK_STATUS))
				{
					SetFuelStationData(stationid, FS_LOCK_STATUS, false);
					SendClientMessage(playerid, 0x66CC00FF, "����������� ������� �������");					
				}
				else 
				{
					SetFuelStationData(stationid, FS_LOCK_STATUS, true);
					SendClientMessage(playerid, 0xFF6600FF, "����������� ������� �������");					
				}
				UpdateFuelStationLabel(stationid);
				
				new query[75];
				format(query, sizeof query, "UPDATE `fuel_stations` SET `lock`=%d WHERE `id`=%d LIMIT 1", GetFuelStationData(stationid, FS_LOCK_STATUS), GetFuelStationData(stationid, FS_SQL_ID));
				mysql_query(mysql, query, false);
				
				CallLocalFunction("ShowPlayerFuelStationDialog", "ii", playerid, FUEL_ST_OPERATION_PARAMS);
			}
			case FUEL_ST_OPERATION_NEW_NAME:
			{
				Dialog
				(
					playerid, DIALOG_FUEL_STATION_NAME, DIALOG_STYLE_INPUT,
					"{33AACC}����� ��������",
					"{FFFFFF}������� ����� �������� ��� ����������� �������\n\n"\
					"����������:\n"\
					"- ����� �� 3-� �� 15-�� ��������\n"\
					"- �������� �� ������ ������������� �������� �������\n"\
					"- �������� ������ ��������������� � ������������ ���������\n\n"\
					"{CC3333}����������: ����� �������� �� ���������� ����� �������� �������",
					"�������", "�����"
				);
			}
			case FUEL_ST_OPERATION_FUEL_PRICE:
			{
				Dialog
				(
					playerid, DIALOG_FUEL_STATION_PRICE_FUEL, DIALOG_STYLE_INPUT,
					"{33AACC}���� �������",
					"{FFFFFF}������� ��������� ���� �� 1 ����\n"\
					"������� � �������� �� 2 �� 15 ������",
					"������", "�����"
				);
			}
			case FUEL_ST_OPERATION_BUY_FUEL_PRIC:
			{
				Dialog
				(
					playerid, DIALOG_FUEL_STATION_BUY_FUEL_PR, DIALOG_STYLE_INPUT,
					"{33AACC}���������� ����",
					"{FFFFFF}���������� ���� ���������� ����������������� �����\n"\
					"�������� ��� ����������� �������. ��� ���� ��� ����,\n"\
					"��� ������� ���������� ����� ��������� ���� ������\n\n"\
					"{669966}������� �������� �� 2 �� 10 ������",
					"��������", "�����"
				);
			}
			case FUEL_ST_OPERATION_FUEL_ORDER:
			{
				Dialog
				(
					playerid, DIALOG_FUEL_STATION_ORDER_FUELS, DIALOG_STYLE_INPUT,
					"{33AACC}����� �������",
					"{FFFFFF}������� ������ ������� �� ������ ��������?",
					"��������", "�����"
				);
			}
			case FUEL_ST_OPERATION_FUEL_ORDER_CA:
			{
				new order_id = GetFuelStationData(stationid, FS_ORDER_ID);
				
				if(order_id != -1)
				{
					new fmt_str[128];
					format
					(
						fmt_str, sizeof fmt_str, 
						"{FFFFFF}�� ������������� ������ �������� �����?\n"\
						"�� ���� ����������� ������� ����� ���������� {FFCD00}%d ���",
						GetOrderData(order_id, O_AMOUNT) * GetOrderData(order_id, O_PRICE)
					);
					Dialog(playerid, DIALOG_FUEL_STATION_ORDER_CANCE, DIALOG_STYLE_MSGBOX, "{33AADD}������ ������", fmt_str, "��", "���");
				}
				else 
				{
					SendClientMessage(playerid, 0xFF6600FF, "�� �� ��������� ����� ������� ��� ����� ���");
					CallLocalFunction("ShowPlayerFuelStationDialog", "ii", playerid, FUEL_ST_OPERATION_PARAMS);
				}
			}
			case FUEL_ST_OPERATION_PROFIT_STATS:
			{
				new query[256];
				
				new time = gettime();
				new cur_day = time - (time % 86400);
				new start_day = cur_day - (86400 * 20);
				
				format(query, sizeof query, "SELECT FROM_UNIXTIME(time, '%%Y-%%m-%%d') AS date, SUM(money) as total FROM fuel_stations_profit WHERE fid=%d AND view=1 AND time >= %d AND time < %d GROUP BY time ORDER BY time DESC LIMIT 20", GetFuelStationData(stationid, FS_SQL_ID), start_day, cur_day);
				mysql_tquery(mysql, query, "ShowFuelStationProfit", "ii", playerid, ++ mysql_race[playerid]);
			}
			case FUEL_ST_OPERATION_IMPROVEMENTS:
			{
				new fmt_str[75];
				new string[300];
				
				new str_numeric[14 + 1];
				new i_level = GetFuelStationData(stationid, FS_IMPROVEMENTS);

				for(new idx; idx < sizeof(g_fuel_station_improvements); idx ++)
				{
					format(fmt_str, sizeof fmt_str, "%d �������:\t%s\t", idx + 1, g_fuel_station_improvements[idx][I_NAME]);
	
					if(idx != 2)
						strcat(fmt_str, "\t");
						
					if(i_level > idx)
					{
						strins(fmt_str, "{2277AA}", 0, sizeof fmt_str);
						strcat(fmt_str, "�������");
					}
					else 
					{
						if(i_level < idx)
						{
							strins(fmt_str, "{CC3344}", 0, sizeof fmt_str);
						}
						strcat(string, fmt_str);
						
						valfmt(str_numeric, g_fuel_station_improvements[idx][I_PRICE]);
						format(fmt_str, sizeof fmt_str, "%s ���", str_numeric);
						
						if(i_level == idx)
							strins(fmt_str, "{66CC33}", 0, sizeof fmt_str);
					}
					strcat(fmt_str, "\n");
					strcat(string, fmt_str);
				}
				Dialog(playerid, DIALOG_FUEL_STATION_IMPROVEMENT, DIALOG_STYLE_LIST, "{33AADD}��������� ��� ����������� �������", string, "������", "�����");
			}
		}
	}
	return 1;
}

public: ShowFuelStationProfit(playerid, race)
{
	if(race != mysql_race[playerid])
	{
		new string[600];
		new fmt_str[32];
		new rows = cache_num_rows();
		
		if(rows)
		{		
			string = "����\t\t\t�������\n\n{FFFFFF}";
		}
		else string = "{FFFFFF}���������� ���������� ����� ����������� ������� ��� �� ������������";
		
		for(new idx; idx < rows; idx ++)
		{
			cache_get_row(idx, 0, fmt_str, mysql, sizeof fmt_str);
			strcat(string, fmt_str);
			
			format(fmt_str, sizeof fmt_str, "\t\t%d ���\n", cache_get_row_int(idx, 1));
			strcat(string, fmt_str);
		}
		Dialog(playerid, DIALOG_FUEL_STATION_INFO, DIALOG_STYLE_MSGBOX, "{33AADD}����� ��� �� 20 ����", string, "<< �����", "�������");
	}
}

public: PresentFlowersToPlayer(playerid, to_player)
{
	SetPlayerAmmo(playerid, WEAPON_FLOWER, 0);
	GivePlayerWeapon(to_player, WEAPON_FLOWER, 1);
}

public: ShowPlayerLotteryDialog(playerid)
{
	if(GetPlayerData(playerid, P_LOTTERY) >= 100)
	{
		new hour;
		new fmt_str[632];
	
		gettime(hour);
		format
		(
			fmt_str, sizeof fmt_str, 
			"���� ���������� �����: {FFCD00}%d\n\n"\
			"{FFFFFF}�� ���������������� � �������, ��������� ����� �������� ��\n"\
			"����� ���������� ���������, ������� ������ � %d:02\n"\
			"�� �������� �� ���� ����� ������� � ��� �������.\n\n"\
			"������� ����� �������� �� ����, ������� ����� ������� �\n"\
			"����� ���������� ����� � � �����, ������� ������� ��\n"\
			"����� ��������� (�� ������� ����� �������):\n\n"\
			"��� ����������:\t{FF6633}0 ���\n"\
			"{FFFFFF}1 �����:\t\t{66FF00}2000 ���\n"\
			"{FFFFFF}2 �����:\t\t{66FF00}15000 ���\n"\
			"{FFFFFF}��� �����:\t\t{66FF00}50000 ���\n\n"\
			"{FFFFFF}���� �� ������ �������� ���������� �����, ������� �����\n"\
			"3 �����. � ��������� ������ ������ ������� \"��\"",
			GetPlayerData(playerid, P_LOTTERY),
			GetElapsedTime(gettime(), g_last_lottery_time) >= 1 ? hour : hour+1
		);
		Dialog(playerid, DIALOG_BIZ_LOTTERY, DIALOG_STYLE_INPUT, "{66CC00}�������", fmt_str, "��", "");
	}
}

public: SetGateStatus(gateid, bool: status, open_time)
{
	if(open_time != -1)
		SetTimerEx("SetGateStatus", open_time * 1000, false, "iii", gateid, status ^ GATE_STATUS_OPEN, -1);
		
	switch(GetGateData(gateid, G_TYPE))
	{
		case 
			GATE_TYPE_BARRIER, 
			GATE_TYPE_BARRIER_MSG,
			GATE_TYPE_BARRIER_BUTTON:
		{
			MoveDynamicObject(g_gate[gateid][G_OBJECT_ID][1], GetGateData(gateid, G_POS_X) + (status == GATE_STATUS_CLOSE ? 0.01 : -0.01), GetGateData(gateid, G_POS_Y), GetGateData(gateid, G_POS_Z) + 0.8, 0.005, 0.0, status == GATE_STATUS_CLOSE ? -90.0 : -10.0, GetGateData(gateid, G_ANGLE));
		}	
		case GATE_TYPE_NORMAL:
		{
		
		}
	}
	SetGateData(gateid, G_STATUS, status);
}

public: CheckNearestGate(playerid)
{
	new gateid = GetNearestGate(playerid, 10.0);
	if(gateid != -1)
	{
		new open_time = 8;
		new bool: access = false;
		
		switch(gateid)
		{
			case GATE_ID_DRIVING_SCHOOL:
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				new type = GetVehicleData(vehicleid, V_ACTION_TYPE);
				
				if(type == VEHICLE_ACTION_TYPE_DRIVING_SCH)
				{
					if(GetPlayerDrivingExamInfo(playerid, DE_POINTS) >= 9)
					{
						access = true;
					}
				}
			}
			default:
				access = true;
		}
		
		if(access)
		{
			OnGateOpened(playerid, gateid, open_time);
		}
		return 1;
	}
	return 0;
}

public: OnGateOpened(playerid, gateid, open_time)
{
	new type = GetGateData(gateid, G_TYPE);
	new bool: status = GetGateData(gateid, G_STATUS);
	
	switch(type)
	{
		case GATE_TYPE_BARRIER, GATE_TYPE_BARRIER_MSG:
		{
			if(status == GATE_STATUS_OPEN) return 0;
			
			if(type == GATE_TYPE_BARRIER_MSG)
			{
				new fmt_str[64];
				
				if(strlen(GetGateData(gateid, G_DESCRIPTION)))
				{
					format(fmt_str, sizeof fmt_str, "[%s] �������� ��������� ����� %d ������", GetGateData(gateid, G_DESCRIPTION), open_time - 3);
				}
				else format(fmt_str, sizeof fmt_str, "�������� ��������� ����� %d ������", open_time - 3);
				SendClientMessage(playerid, 0x66CC00FF, fmt_str);
			}
		}
		case GATE_TYPE_BARRIER_BUTTON:
		{
			open_time = -1;
		}
		case GATE_TYPE_NORMAL:
		{
			
		}
	}
	SetGateStatus(gateid, status ^ GATE_STATUS_OPEN, open_time);
	
	return 1;
}

public: UpdateFactoryDesk(deskid)
{
	new fmt_str[64];
	
	format(fmt_str, sizeof fmt_str, "������� ����� �%d\n%s", deskid + 1, factory_desk[deskid][FD_USED] ? ("{FF6600}������") : ("{33CC00}��������"));
	UpdateDynamic3DTextLabelText(factory_desk[deskid][FD_LABEl], 0xFFFFFFEE, fmt_str);
}

public: T_RemovePlayerAttachedObject(playerid, slot)
{
	if(IsPlayerAttachedObjectSlotUsed(playerid, slot))
	{
		RemovePlayerAttachedObject(playerid, slot);
	}
}

#if defined RAND_WEATHER
public: SetRandomWeather()
{
	new fmt_str[64];
	new rand = random(sizeof g_weather);
	
	SendClientMessageToAll(0x3399FFFF, "[������� ������]");
	
	format(fmt_str, sizeof fmt_str, "� ������� ��������� %s {99CC00}(+%d *�)", g_weather[rand][W_NAME], g_weather[rand][W_DEGREES]);
	SendClientMessageToAll(0xFFFFFFFF, fmt_str);
	
	SetWeather(g_weather[rand][W_ID]);
}
#endif

public: ClearBanList()
{
	new query[64];
	new time = gettime();

	format(query, sizeof query, "SELECT ip FROM ban_list WHERE ban_time <= %d", time);
	mysql_tquery(mysql, query, "UnBanIPs", "i", time);
	
	return 1;
}

public: UnBanIPs(time)
{
	new ip[16];
	new query[64];
	new rows = cache_num_rows();
	
	if(rows)
	{
		for(new idx; idx < rows; idx ++)
		{
			cache_get_row(idx, 0, ip);
			
			format(query, sizeof query, "unbanip %s", ip);
			SendRconCommand(query);
		}
		SendRconCommand("reloadbans");
		
		format(query, sizeof query, "DELETE FROM ban_list WHERE ban_time <= %d", time);
		mysql_query(mysql, query, false);
	}
	return 1;
}

public: PlayerOwnableCarInit(playerid)
{
	new index;
	new vehicleid = -1;
	
	while(vehicleid < MAX_VEHICLES)
	{
		vehicleid ++;
		index = GetVehicleData(vehicleid, V_ACTION_ID);
		
		if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_OWNABLE_CAR) continue;
		if(GetOwnableCarData(index, OC_OWNER_ID) != GetPlayerAccountID(playerid)) continue;
		
		SetPlayerData(playerid, P_OWNABLE_CAR, vehicleid);
		break;
	}
}

public: SaveOwnableCar(vehicleid)
{
	if(IsAOwnableCar(vehicleid))
	{
		new query[256];
		new index = GetVehicleData(vehicleid, V_ACTION_ID);
		
		new Float: x, Float: y, Float: z;
		new Float: angle, Float: health;
		
		GetVehiclePos(vehicleid, x, y, z);
		
		GetVehicleZAngle(vehicleid, angle);
		GetVehicleHealth(vehicleid, health);
		
		SetOwnableCarData(index, OC_POS_X, x);
		SetOwnableCarData(index, OC_POS_Y, y);
		SetOwnableCarData(index, OC_POS_Z, z);
		SetOwnableCarData(index, OC_ANGLE, angle);
		
		format
		(
			query, sizeof query, 
			"UPDATE ownable_cars SET "\
			"pos_x=%f,"\
			"pos_y=%f,"\
			"pos_z=%f,"\
			"angle=%f,"\
			"status=%d,"\
			"alarm=%d,"\
			"key_in=%d,"\
			"mileage=%f "\
			"WHERE id=%d LIMIT 1",
			GetOwnableCarData(index, OC_POS_X),
			GetOwnableCarData(index, OC_POS_Y),
			GetOwnableCarData(index, OC_POS_Z),
			GetOwnableCarData(index, OC_ANGLE),
			GetVehicleParam(vehicleid, V_LOCK),
			GetVehicleParam(vehicleid, V_ALARM),
			GetOwnableCarData(index, OC_KEY_IN),
			GetVehicleData(vehicleid, V_MILEAGE),
			GetOwnableCarData(index, OC_SQL_ID)
		);
		mysql_query(mysql, query, false);
		
		return mysql_errno();
	}
	return -1;
}

public: ShowTrunkDialog(playerid, vehicleid, view)
{	
	new count, type;
	
	new fmt_str[36];
	new string[(sizeof fmt_str) * MAX_VEHICLE_TRUNK_SLOTS + 1];
	
	ClearPlayerListitemValues(playerid);
	for(new idx; idx < MAX_VEHICLE_TRUNK_SLOTS; idx ++)
	{
		if(IsTrunkFreeSlot(vehicleid, idx)) continue;
		type = GetTrunkData(vehicleid, idx, VT_ITEM_TYPE);
		
		format(fmt_str, sizeof fmt_str, "%d. %s:\t{66CC00}%d %s\n", count + 1, GetItemInfo(type, I_NAME), GetTrunkData(vehicleid, idx, VT_ITEM_AMOUNT), GetItemInfo(type, I_NAME_COUNT));
		strcat(string, fmt_str);
		
		SetPlayerListitemValue(playerid, count ++, idx);
	}
	
	if(!view)
	{
		SetPlayerListitemValue(playerid, count, -1);
		SetPlayerUseTrunk(playerid, vehicleid);
		
		format(fmt_str, sizeof fmt_str, "{888888}%d. ��������", count + 1);
		strcat(string, fmt_str);
		
		Dialog(playerid, DIALOG_VEHICLE_TRUNK, DIALOG_STYLE_LIST, "{0099FF}���������� ���������", string, "�������", "�������");
	}
	else 
	{
		if(!count)
			strcat(string, "{888888}�����");
			
		SetPlayerUseTrunk(playerid, INVALID_VEHICLE_ID);
		Dialog(playerid, DIALOG_VEHICLE_TRUNK, DIALOG_STYLE_LIST, "{0099FF}���������� ���������", string, "�������", "");
	}
	return 1;
}

// ------------------------------------------
stock GetTrunkFreeSlot(vehicleid, item_type)
{
	new free_slot = -1, comb_slot = -1;
	new bool: comb = GetItemInfo(item_type, I_COMBINATION);
	
	for(new idx; idx < MAX_VEHICLE_TRUNK_SLOTS; idx ++)
	{
		if(GetTrunkData(vehicleid, idx, VT_ITEM_TYPE) == item_type && comb)
		{
			comb_slot = idx;
		}
		else if(free_slot == -1 && IsTrunkFreeSlot(vehicleid, idx))
		{
			free_slot = idx;
		}
		else continue;
	}
	return comb_slot != -1 ? comb_slot : free_slot;
}

stock AddTrunkItem(vehicleid, item_id, amount, value = 0)
{
	if(0 <= item_id <= sizeof(g_item_type)-1)
	{
		new free_slot = GetTrunkFreeSlot(vehicleid, item_id);
		if(free_slot != -1)
		{
			if(!IsTrunkFreeSlot(vehicleid, free_slot))
			{
				SendClientMessageToAll(-1, "+AddItem");
			}
			else SendClientMessageToAll(-1, "+InsertItem");
			
			SetTrunkData(vehicleid, free_slot, VT_SQL_ID, 1);
			
			SetTrunkData(vehicleid, free_slot, VT_ITEM_TYPE, item_id);
			SetTrunkData(vehicleid, free_slot, VT_ITEM_AMOUNT, amount);
			SetTrunkData(vehicleid, free_slot, VT_ITEM_VALUE, value);
			
			return 1;
		}
		return -1;
	}
	return 0;
}

stock RemoveTrunkItem(vehicleid, item_slot)
{
	if(!IsTrunkFreeSlot(vehicleid, item_slot))
	{
		SetTrunkData(vehicleid, item_slot, VT_SQL_ID,	0);
		
		SetTrunkData(vehicleid, item_slot, VT_ITEM_TYPE, 	0);
		SetTrunkData(vehicleid, item_slot, VT_ITEM_AMOUNT, 	0);
		SetTrunkData(vehicleid, item_slot, VT_ITEM_VALUE, 	0);
		
		return 1;
	}
	return 0;
}

stock GetCoordVehicle(vehicleid, type, &Float:x, &Float:y, &Float:z, &Float:angle, &Float:distance) // by Essle (�������� / �����)
{		
    GetVehicleModelInfo(GetVehicleData(vehicleid, V_MODELID), 1, x, distance, z); // ������ ����� ������
    distance = distance / 2 + 0.1; // ���������� ����� ����� �� ���
	
    GetVehiclePos(vehicleid, x, y, z); // ������ ���������� ����
    GetVehicleZAngle(vehicleid, angle); // ������ ���� �������� ����
	
	switch(type)
	{
		case VEHICLE_COORD_TYPE_BOOT: // ��������
		{
			x += (distance * floatsin(-angle+180, degrees)); // �������� ���������� x �a�������
			y += (distance * floatcos(-angle+180, degrees)); // �������� ���������� y �a�������
		}
		case VEHICLE_COORD_TYPE_BONNET: // �����
		{
			x -= (distance * floatsin(-angle+180, degrees)); // �������� ���������� x ������
			y -= (distance * floatcos(-angle+180, degrees)); // �������� ���������� y ������
		}
		default:
		{
			return 0;
		}
	}
	return 1;
}   

stock SetVehicleToHotelRespawn(hotelid, vehicleid)
{
	if(IsValidVehicle(vehicleid))
	{
		new free_slot = GetHotelFreePark(hotelid);
		if(free_slot != -1)
		{
			g_hotel_car_park_pos[hotelid][free_slot][HC_VEHICLE_ID] = vehicleid;
			
			SetVehiclePos(vehicleid, g_hotel_car_park_pos[hotelid][free_slot][HC_POS_X], g_hotel_car_park_pos[hotelid][free_slot][HC_POS_Y], g_hotel_car_park_pos[hotelid][free_slot][HC_POS_Z]);
			SetVehicleZAngle(vehicleid, g_hotel_car_park_pos[hotelid][free_slot][HC_ANGLE]);
			
			return 1;
		}
	}
	return 0;
}

stock GetHotelFreePark(hotelid)
{
	new vehicleid, slot = -1;
	
	for(new idx; idx < sizeof(g_hotel_car_park_pos[]); idx ++)
	{
		vehicleid = g_hotel_car_park_pos[hotelid][idx][HC_VEHICLE_ID];
		if(GetVehicleDistanceFromPoint(vehicleid, g_hotel_car_park_pos[hotelid][idx][HC_POS_X], g_hotel_car_park_pos[hotelid][idx][HC_POS_Y], g_hotel_car_park_pos[hotelid][idx][HC_POS_Z]) >= 8.0) continue;
	
		slot = idx;
		break;
	}
	return slot;
}

stock ShowOwnableCarPass(playerid, vehicleid)
{
	new model_id = GetVehicleData(vehicleid, V_MODELID);

	if(model_id && IsAOwnableCar(vehicleid))
	{
		new fmt_str[256];
		new Float: health;
		new index = GetVehicleData(vehicleid, V_ACTION_ID);
		
		GetVehicleHealth(vehicleid, health);
		
		format
		(
			fmt_str, sizeof fmt_str,
			"{FFFFFF}��������:\t\t{3399FF}%s\n\n"\
			"{FFFFFF}������:\t\t{3399FF}%d\n"\
			"{FFFFFF}���������:\t\t{3399FF}%d\n"\
			"{FFFFFF}������:\t\t{3399FF}%07i\n"\
			"{FFFFFF}����:\t\t\t{3399FF}ID %d, %d\n"\
			"{FFFFFF}���. ���������:\t{3399FF}%d ���",
			GetVehicleInfo(model_id-400, VI_NAME),
			model_id,
			floatround(health),
			floatround(GetVehicleData(vehicleid, V_MILEAGE), floatround_ceil),
			GetOwnableCarData(index, OC_COLOR_1),
			GetOwnableCarData(index, OC_COLOR_2),
			GetVehicleInfo(model_id-400, VI_PRICE)
		);
		Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{0099FF}���������", fmt_str, "�������", "");
		
		return 1;
	}
	return 0;
}

stock SpeedometrKeyStatusInit(playerid, vehicleid)
{
	if(IsAOwnableCar(vehicleid))
	{
		new index = GetVehicleData(vehicleid, V_ACTION_ID);
		if(GetOwnableCarData(index, OC_KEY_IN))
		{
			PlayerTextDrawSetString(playerid, speedometr_PTD[playerid][5], "~y~.");
		}
		else PlayerTextDrawSetString(playerid, speedometr_PTD[playerid][5], ".");
	}
	else PlayerTextDrawSetString(playerid, speedometr_PTD[playerid][5], "~y~.");
}

stock IsAOwnableCar(vehicleid)
{
	if(IsValidVehicleID(vehicleid))
	{
		if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
		{
			return 1;
		}
	}
	return 0;
}

stock ShowPlayerHotelRoomPayForRent(playerid)
{
	new hotel_id = GetPlayerInHotelID(playerid);
	new room_id = GetPlayerData(playerid, P_HOUSE_ROOM);
	
	if(GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL) == hotel_id)
	{
		new rent_days = GetElapsedTime(GetHotelData(hotel_id, room_id, H_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS);
		if(rent_days < 0)
		{
			rent_days = 0;
		}
		
		new fmt_str[128];
		format
		(
			fmt_str, sizeof fmt_str, 
			"{FFFFFF}���������� ����:\t\t%d �� 30\n"\
			"���������� �����:\t\t1000 ���\n\n"\
			"�� ������� ���� �� ������ �������� �����?",
			rent_days
		);
		Dialog(playerid, DIALOG_HOTEL_PAY_FOR_ROOM, DIALOG_STYLE_INPUT, "{66CC99}������ ���������� � �����", fmt_str, "��������", "�����");
	}
}

stock ShowPlayerHotelClientMenu(playerid, hotel_id)
{
	if(GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL) == hotel_id)
	{
		Dialog
		(
			playerid, DIALOG_HOTEL_CLIENT_MENU, DIALOG_STYLE_LIST,
			"{66CC99}���� �������",
			"1. �������� ����������\n"\
			"2. ���������� � ����������\n"\
			"3. �������� ��������� �� GPS\n"\
			"4. ��������� ��������� � ����� (1000 ���)\n"\
			"5. ������� ���������\n"\
			"6. ���������� �� �����", 
			"�������", "�����"
		);
	}
	else 
	{
		SendClientMessage(playerid, 0xCECECEFF, "�� �� ���������� � ���� ���������");
		ShowPlayerHotelDialog(playerid);
	}
}

stock GetHotelFreeRoom(hotelid)
{
	new free_room = -1;
	if(0 <= hotelid <= MAX_HOTELS-1)
	{
		new max_rooms = g_hotel_rooms_loaded[hotelid] / 12;
		
		for(new idx; idx < max_rooms; idx ++)
		{
			if(IsHotelRoomOwned(hotelid, idx)) continue;
			
			free_room = idx;
			break;
		}
	}
	return free_room;
}

stock ExitPlayerFromHotelRoom(playerid)
{
	new room_id = GetPlayerData(playerid, P_IN_HOTEL_ROOM);
	if(room_id != -1)
	{
		new hotel_id = GetPlayerInHotelID(playerid);
		if(hotel_id != -1)
		{
			if(IsPlayerInRangeOfPoint(playerid, 1.0, 301.7391,-139.9879,989.0823))
			{
				new floor = (room_id / 12) + 1;
				new index = (room_id % 12) / 5;
				
				SetPlayerPosEx
				(
					playerid, 
					g_hotel_room_exit_pos[index][0],
					g_hotel_room_exit_pos[index][1],
					g_hotel_room_exit_pos[index][2],
					180.0, 
					floor,
					((hotel_id + 1) * 200) + (floor + 1000)
				);
				SetPlayerData(playerid, P_IN_HOTEL_ROOM, -1);
			}				
		}
	}
}

stock EnterPlayerToHotelRoom(playerid, hotel_id, room_id)
{
	if(GetPlayerData(playerid, P_IN_HOTEL_ROOM) == -1)
	{
		if(!GetHotelData(hotel_id, room_id, H_STATUS) || GetPlayerAccountID(playerid) == GetHotelData(hotel_id, room_id, H_OWNER_ID))
		{
			SetPlayerPosEx(playerid, 301.7836, -138.7689, 989.0823, 0.0, 6, ((hotel_id + 1) * 400) + (room_id + 2000));
			SetPlayerData(playerid, P_IN_HOTEL_ROOM, room_id);
			
			SetPlayerData(playerid, P_IN_HOTEL_FLOOR, (room_id / 12) + 1);
		}
		else GameTextForPlayer(playerid, "~r~Closed", 2500, 1);
	}
	return 1;
}

stock ShowPlayerHotelFloorsInfo(playerid, hotel_id)
{
	new fmt_str[8 + 1];
	new string[(sizeof fmt_str - 1) * MAX_HOTEL_FLOORS];
	
	new max_floors = g_hotel_rooms_loaded[hotel_id] / 12;
	for(new idx; idx < max_floors; idx ++)
	{
		format(fmt_str, sizeof fmt_str, "%d ����\n", idx + 1);
		strcat(string, fmt_str);
	}
	Dialog(playerid, DIALOG_HOTEL_FLOOR_SELECT, DIALOG_STYLE_LIST, "{FFCD00}�������� ����", string, "�������", "������");
}

stock ShowPlayerHotelFloorsLift(playerid, hotel_id, floor_id)
{
	new fmt_str[8 + 1];
	new string[(sizeof fmt_str - 1) * MAX_HOTEL_FLOORS];
	
	new max_floors = g_hotel_rooms_loaded[hotel_id] / 12;
	for(new idx, count; idx <= max_floors; idx ++)
	{
		if(idx == floor_id) continue;
		if(idx)
		{
			format(fmt_str, sizeof fmt_str, "%d ����\n", idx);
			strcat(string, fmt_str);
		}
		else strcat(string, "�����\n");
		
		SetPlayerListitemValue(playerid, count ++, idx);
	}
	Dialog(playerid, DIALOG_HOTEL_FLOOR_LIFT, DIALOG_STYLE_LIST, "{FFCD00}�������� ����", string, "�������", "������");
}

stock ShowPlayerHotelFloorInfo(playerid, hotel_id, floor_id)
{
	if(0 <= hotel_id <= MAX_HOTELS-1)
	{
		if(0 <= floor_id <= MAX_HOTEL_FLOORS-1)
		{
			new string[512];
			new fmt_str[45 + 1];
			
			new rent_time;
			new time = gettime();
			
			new s_idx = floor_id * 12;
			new e_idx = s_idx + 12;
			
			string = "�����\t\t������\t\t���������� ���\t���������\n\n{FFFFFF}";
			while(s_idx < e_idx)
			{
				if(IsHotelRoomOwned(hotel_id, s_idx))
				{
					rent_time = GetElapsedTime(GetHotelData(hotel_id, s_idx, H_RENT_DATE), time, CONVERT_TIME_TO_DAYS);
					if(rent_time < 0)
						rent_time = 0;
					
					format(fmt_str, sizeof fmt_str, "%d\t\t%s\t\t%d\t\t%s\n", (s_idx % 12) + 1, rent_time > 0 ? ("�����\t") : ("���������"), rent_time, GetHotelData(hotel_id, s_idx, H_OWNER_NAME));
				}
				else format(fmt_str, sizeof fmt_str, "%d\t\t��������\n", (s_idx % 12) + 1);
				strcat(string, fmt_str);
			
				s_idx ++;
			}
			
			format(fmt_str, sizeof fmt_str, "{66CC99}������ ������� �� %d �����", floor_id + 1);
			Dialog(playerid, DIALOG_HOTEL_FLOOR_INFO, DIALOG_STYLE_MSGBOX, fmt_str, string, "�����", "�������");
		}
	}
}

stock ShowPlayerHotelDialog(playerid)
{
	if(GetPlayerInHotelID(playerid) != -1)
	{
		new businessid = GetPlayerInBiz(playerid);
		
		Dialog
		(
			playerid, DIALOG_HOTEL, DIALOG_STYLE_LIST,
			GetBusinessData(businessid, B_NAME),
			"1. ������ �������\n"\
			"2. �����������\n"\
			"3. ���� �������",
			"�������", "�������"
		);
	}
}

stock GetPlayerInHotelID(playerid)
{
	new hotel_id = -1;
	new businessid = GetPlayerInBiz(playerid);
	
	if(businessid != -1)
	{
		if(GetBusinessData(businessid, B_TYPE) == BUSINESS_TYPE_HOTEL)
		{
			switch(businessid)
			{
				case 30:
					hotel_id = 0;
					
				case 31:
					hotel_id = 1;
					
				case 32:
					hotel_id = 2;
					
				default:
					hotel_id = -1;
			}
		}
	}
	return hotel_id;
}

stock EntranceStatusInitAll()
{
	for(new idx; idx < g_entrance_loaded; idx ++)
	{
		CallLocalFunction("EntranceStatusInit", "i", idx);
	}
}

stock UpdateEntrance(entranceid, houses)
{
	new status = (houses >= GetEntranceData(entranceid, E_FLOORS) * 4);
	
	if(GetEntranceData(entranceid, E_STATUS) != status)
	{
		if(GetEntranceData(entranceid, E_PICKUP_ID))
			DestroyPickup(GetEntranceData(entranceid, E_PICKUP_ID));
			
		if(IsValidDynamicMapIcon(GetEntranceData(entranceid, E_MAP_ICON)))
			DestroyDynamicMapIcon(GetEntranceData(entranceid, E_MAP_ICON));

		SetEntranceData(entranceid, E_PICKUP_ID, CreatePickup((status ? 1272 : 1273), 2, GetEntranceData(entranceid, E_POS_X), GetEntranceData(entranceid, E_POS_Y), GetEntranceData(entranceid, E_POS_Z), 0, PICKUP_ACTION_TYPE_ENTRANCE_ENT, entranceid));
		SetEntranceData(entranceid, E_MAP_ICON, CreateDynamicMapIcon(GetEntranceData(entranceid, E_POS_X), GetEntranceData(entranceid, E_POS_Y), GetEntranceData(entranceid, E_POS_Z), (status ? 32 : 31), 0, 0, 0, -1, STREAMER_MAP_ICON_SD, MAPICON_LOCAL));

		SetEntranceData(entranceid, E_STATUS, status);
	}
}

stock ShowPlayerEntranceFloorsLift(playerid, entranceid, floor)
{
	new fmt_str[10];
	new string[(sizeof fmt_str) * MAX_ENTRANCE_FLOORS];
	
	new max_floors = GetEntranceData(entranceid, E_FLOORS) + 1;
	
	for(new idx, count; idx < max_floors; idx ++)
	{
		if(idx == floor) continue;
		if(idx)
		{
			format(fmt_str, sizeof fmt_str, "%d ����\n", idx);
			strcat(string, fmt_str);
		}
		else strcat(string, "�������\n");
		
		SetPlayerListitemValue(playerid, count ++, idx);
	}
	Dialog(playerid, DIALOG_ENTRANCE_LIFT, DIALOG_STYLE_LIST, "{FFCD00}�������� ����", string, "�������", "������");
}

stock EnterPlayerToEntrance(playerid, entranceid)
{
	if(GetPlayerInEntrance(playerid) == -1)
	{
		SetPlayerPosEx(playerid, 20.5351, 1407.1962, 1508.4100, 180.0, 1, entranceid + 2500);
		
		SetPlayerInEntranceFloor(playerid, 0);
		SetPlayerInEntrance(playerid, entranceid);
	}
}

stock SetPlayerFactoryDeskUse(playerid, deskid, bool: status)
{
	if(!(0 <= deskid <= sizeof factory_desk-1)) return ;
	
	if(GetPlayerTempJob(playerid) == TEMP_JOB_FACTORY)
	{
		if(status)
		{
			if(!factory_desk[deskid][FD_USED] && GetPlayerData(playerid, P_FACTORY_USE_DESK) == -1)
			{
				if(GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_FACTORY_CREATE_P)
				{
					factory_desk[deskid][FD_USED] = true;

					// static const 
					//	p_object_id[3] = {1954, 2926, 1718};
						
					// static const 
					//	Float: p_object_z[3] = {0.09, 0.0, 0.06};
			
					// new rand = random(sizeof(p_object_id));
					// new Float: x, Float: y, Float: z;
					// GetPlayerPos(playerid, x, y, z);
					
					new Float: angle; 
					
					new take_metall = GetPVarInt(playerid, "factory_take_metall");
					new factory_fuel = GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL, R_AMOUNT);
					
					SetPlayerData(playerid, P_FACTORY_USE_DESK, deskid);
					TogglePlayerFactoryCP(playerid, false);
					
					if(!((deskid / 4) % 2))
					{
						angle = 180.0;
					}
					else angle = 0.0;
					SetPlayerFacingAngle(playerid, angle);	
					
					//factory_object[playerid] = CreateDynamicObject(p_object_id[rand], x, y, 1044.08 + p_object_z[rand], 0.0, 0.0, angle + 180.0);
					ApplyAnimationEx(playerid, "OTB", "betslp_loop", 4.1, 1, 0, 0, 1, 20_000, 0, USE_ANIM_TYPE_NONE - 1);
					
					SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 18644, A_OBJECT_BONE_RIGHT_HAND, 0.06, 0.02, 0.0, 30.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0);
					SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND + 1, 18635, A_OBJECT_BONE_LEFT_HAND, 0.1, 0.06, -0.1, 180.0, 80.0, 0.0, 1.0, 1.0, 1.0, 0);
					
					SetPlayerTempJobState(playerid, TEMP_JOB_STATE_FACTORY_CREATED);
					SetTimerEx("CreateFactoryProd", 18_000, false, "i", playerid);
					
					SetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL, R_AMOUNT, factory_fuel - (take_metall * 6));
					UpdateRepository(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL);
				}
				else 
				{
					if(GetPlayerTempJobState(playerid) != TEMP_JOB_STATE_FACTORY_PUT_PROD)
						SendClientMessage(playerid, 0x999999FF, "�������� ������ � ������������ �����");
				}
			}
		}
		else 
		{
			if(factory_desk[deskid][FD_USED])
			{
				if(GetPlayerData(playerid, P_FACTORY_USE_DESK) == deskid)
				{
					TogglePlayerFactoryCP(playerid, true);
					SetPlayerData(playerid, P_FACTORY_USE_DESK, -1);
					
					/*
					if(IsValidDynamicObject(factory_object[playerid]))
					{
						DestroyDynamicObject(factory_object[playerid]);
						factory_object[playerid] = -1;
					}
					*/
					factory_desk[deskid][FD_USED] = false;
				}
			}
		}
		UpdateFactoryDesk(deskid);
	}
}

stock AddBan(user_id, time, days, ip[], description[], admin_name[])
{
	new query[200];
	new c_time = time-(time % 86400);

	mysql_format(mysql, query, sizeof query, "INSERT INTO ban_list (user_id,time,ban_time,ip,description,admin) VALUES (%d,%d,%d,'%e','%e','%e')", user_id, c_time, c_time + (days * 86400), ip, description, admin_name);
	mysql_query(mysql, query, false);
	
	return !mysql_errno();
}

stock GivePlayerDrinkItem(playerid, itemid)
{
	new action_id = -1;
	switch(itemid+1)
	{
		case 1: // �������
		{
			action_id = 23;
		}
		case 2, 6..7: // ����, ������, �����
		{
			action_id = 20;
		}
		case 3..5, 8: // ����, ����������, �����, ������
		{
			action_id = 22;
		}
		case 9: // �������
		{
			if(GetPlayerData(playerid, P_DRINK_STEP))
			{
				SetPlayerData(playerid, P_DRINK_STEP, 0);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			}
		
			SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 10213, A_OBJECT_BONE_RIGHT_HAND, 0.08, 0.05, 0.06, 180.0, 270.0, -30.0, 1.0, 1.0, 1.0, 0, 0);
			SetPlayerData(playerid, P_SNACK, true);
		}
		case 10: // ������
		{
			action_id = 21;
		}
	}
	if(action_id != -1)
	{
		if(GetPlayerData(playerid, P_SNACK))
		{
			SetPlayerData(playerid, P_SNACK, false);
			T_RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND);
		}
		
		SetPlayerData(playerid, P_DRINK_STEP, 7);
		SetPlayerSpecialAction(playerid, action_id);
	}
	return 1;
}

stock FactoryPlayerDrop(playerid, bool: reject = true)
{
	if(GetPlayerTempJob(playerid) == TEMP_JOB_FACTORY)
	{
		if(reject)
		{
			if(GetPlayerTempJobState(playerid) != TEMP_JOB_STATE_FACTORY_CREATED) return ;
			
			SetPlayerChatBubble(playerid, "����", 0xFF0000FF, 10.0, 1500);
			ApplyAnimationEx(playerid, "OTB", "WTCHRACE_LOSE", 4.1, 0, 0, 0, 0, 0, 0, USE_ANIM_TYPE_NONE);
		}
		else 
		{
			if(GetPlayerTempJobState(playerid) != TEMP_JOB_STATE_FACTORY_DROP_P) return ;
			SetPlayerTempJobCheckAnim(playerid, false);
			
			RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_FOREARM);
			SetPlayerFactoryDeskUse(playerid, GetPlayerData(playerid, P_FACTORY_USE_DESK), false);
			
			ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 1, 0, USE_ANIM_TYPE_NONE);
			SendClientMessage(playerid, 0xFF6600FF, "�� ������� �������");
		}
		
		new bad_prods = GetPVarInt(playerid, "factory_bad_prods") + 1;
		SetPVarInt(playerid, "factory_bad_prods", bad_prods);
		
		GameTextForPlayer(playerid, "~r~~h~fail", 4000, 1);
		SetPlayerTempJobState(playerid, TEMP_JOB_STATE_FACTORY_TAKE_MET);
	}
}

stock ShowPlayerClothingShopPanel(playerid)
{
	new businessid = GetPlayerInBiz(playerid);
	if(businessid != -1)
	{
		if(GetPlayerTeamEx(playerid) <= 0)
		{
			new select_skin = GetPlayerSelectSkin(playerid);
			if(select_skin == -1)
			{
				new type = GetBusinessData(businessid, B_INTERIOR);
				new interior = GetBusinessInteriorInfo(type, BT_ENTER_INTERIOR);
				new 
					Float: cam_x, Float: cam_y, Float: cam_z,
					Float: v_cam_x, Float: v_cam_y, Float: v_cam_z;
				
				GetPlayerCameraPos(playerid, cam_x, cam_y, cam_z);
				GetPlayerCameraFrontVector(playerid, v_cam_x, v_cam_y, v_cam_z);
	
				TogglePlayerControllable(playerid, false);
				SetPlayerPosEx(playerid, 332.2033, -174.1066, 999.6743, 1.0, interior, playerid + 32);
				
				InterpolateCameraPos(playerid, cam_x, cam_y, cam_z, 335.067718, -170.856231, 1000.424804, 4000, CAMERA_MOVE);	
				InterpolateCameraLookAt(playerid, cam_x + floatmul(v_cam_x, 5.0), cam_y + floatmul(v_cam_y, 5.0), cam_z + floatmul(v_cam_z, 5.0), 332.006469, -174.727508, 999.623596, 5000, CAMERA_MOVE);
	
				ShowPlayerSelectPanel(playerid, SELECT_PANEL_TYPE_CLOTHING);
				SetPlayerSelectClothingSkin(playerid, 0);

				SendClientMessage(playerid, 0x9C9C9CFF, "����������� {33CC00}������ ����� {9C9C9C}��� ��������� �� ����");
			}
		}
		else SendClientMessage(playerid, 0xCECECEFF, "�� �������� � �����������, ������ ����� ��������� ������");
	}
}

stock ExitPlayerClothingShopPanel(playerid)
{
	new businessid = GetPlayerInBiz(playerid);
	if(businessid != -1)
	{
		if(GetPlayerData(playerid, P_USE_SELECT_PANEL) == SELECT_PANEL_TYPE_CLOTHING)
		{
			HidePlayerSelectPanel(playerid);
			
			SetPlayerSkinInit(playerid);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);
			
			SetPlayerVirtualWorld(playerid, businessid + 255);
			SetPlayerData(playerid, P_USE_SELECT_PANEL, SELECT_PANEL_TYPE_NONE);
			
			PlayerTextDrawSetString(playerid, price_select_TD[playerid][1], "exit...");
			SetTimerEx("HidePlayerSelectPanelPriceTimer", 1000, false, "i", playerid);
			
			SetPlayerData(playerid, P_SELECT_SKIN, -1);
		}
	}
}

stock ShowPlayerSelectPanelPrice(playerid, price = 0)
{
	if(price_select_TD[playerid][0] == PlayerText:-1)
	{
		price_select_TD[playerid][0] = CreatePlayerTextDraw(playerid, 276.000, 431.000, "Price");
		PlayerTextDrawLetterSize(playerid, price_select_TD[playerid][0], 0.500, 2.000);
		PlayerTextDrawTextSize(playerid, price_select_TD[playerid][0], 364.000, 42.000);
		PlayerTextDrawAlignment(playerid, price_select_TD[playerid][0], 1);
		PlayerTextDrawBoxColor(playerid, price_select_TD[playerid][0], 0x0000060);
		PlayerTextDrawColor(playerid, price_select_TD[playerid][0], 0xFFFFFFFF);
		PlayerTextDrawFont(playerid, price_select_TD[playerid][0], 5);
		PlayerTextDrawSetOutline(playerid, price_select_TD[playerid][0], 0);
		PlayerTextDrawSetProportional(playerid, price_select_TD[playerid][0], 1);
		PlayerTextDrawSetShadow(playerid, price_select_TD[playerid][0], 1);
		PlayerTextDrawUseBox(playerid, price_select_TD[playerid][0], 1);

		price_select_TD[playerid][1] = CreatePlayerTextDraw(playerid, 320.000, 435.000, "_");
		PlayerTextDrawLetterSize(playerid, price_select_TD[playerid][1], 0.320, 0.800);
		PlayerTextDrawAlignment(playerid, price_select_TD[playerid][1], 2);
		PlayerTextDrawBackgroundColor(playerid, price_select_TD[playerid][1], 0x000000FF);
		PlayerTextDrawColor(playerid, price_select_TD[playerid][1], 0xFFFFFFFF);
		PlayerTextDrawFont(playerid, price_select_TD[playerid][1], 2);
		PlayerTextDrawSetOutline(playerid, price_select_TD[playerid][1], 0);
		PlayerTextDrawSetProportional(playerid, price_select_TD[playerid][1], 1);
		PlayerTextDrawSetShadow(playerid, price_select_TD[playerid][1], 0);
		PlayerTextDrawUseBox(playerid, price_select_TD[playerid][1], 0);
	}
	
	if(price != -1)
	{
		new fmt_str[32];
		
		format(fmt_str, sizeof fmt_str, "%d rub", price);
		PlayerTextDrawSetString(playerid, price_select_TD[playerid][1], fmt_str);
	}
	PlayerTextDrawShow(playerid, price_select_TD[playerid][0]);
	PlayerTextDrawShow(playerid, price_select_TD[playerid][1]);
}

stock HidePlayerSelectPanelPrice(playerid)
{
	for(new idx; idx < sizeof price_select_TD[]; idx ++)
	{
		if(price_select_TD[playerid][idx] != PlayerText: -1)
		{
			PlayerTextDrawHide(playerid, price_select_TD[playerid][idx]);
			PlayerTextDrawDestroy(playerid, price_select_TD[playerid][idx]);
			
			price_select_TD[playerid][idx] = PlayerText: -1;
		}
	}
}

stock SetPlayerSelectClothingSkin(playerid, index = 0)
{
	new sex = GetPlayerSex(playerid);
	
	SetPlayerSelectSkin(playerid, index, g_business_clothing_skins[sex][index][0]);
	ShowPlayerSelectPanelPrice(playerid, g_business_clothing_skins[sex][index][1]);
}

stock CreateTeleportObjects(playerid)
{
	for(new idx; idx < 2; idx ++)
	{
		if(g_teleport_object[playerid][idx] == -1)
		{
			g_teleport_object[playerid][idx] = CreatePlayerObject(playerid, 3034, 0.0, 0.0, -2000.0, 0.0, 0.0, 0.0);
		}
	}
}

stock DestroyTeleportObjects(playerid)
{
	for(new idx; idx < 2; idx ++)
	{
		if(g_teleport_object[playerid][idx] != -1)
		{
			DestroyPlayerObject(playerid, g_teleport_object[playerid][idx]);
			g_teleport_object[playerid][idx] = -1;
		}
	}
}

stock PlayerTeleportInit(playerid, Float: x, Float: y, Float: z, Float: angle)
{
	new Float: dist = -0.862;
	angle += 90.0; //����������� ����; ����� � ��������
	
	for(new idx = 2; idx --; )
	{
		SetPlayerObjectPos(playerid, g_teleport_object[playerid][idx], x + dist * -floatsin(angle, degrees), y + dist * floatcos(angle, degrees), z - 1.02);	
		SetPlayerObjectRot(playerid, g_teleport_object[playerid][idx], 90.0, 90.0, angle - 90.0);
		
		dist = floatabs(dist);
	}
}

stock GetOwnableCarBySqlID(sql_id, buffer[] = {0, 0, 0})
{
	buffer[2] = INVALID_VEHICLE_ID;
	for(buffer[0] = 1; buffer[0] < MAX_VEHICLES; buffer[0] ++)
	{
		if(!IsAOwnableCar(buffer[0])) continue;
		buffer[1] = GetVehicleData(buffer[0], V_ACTION_ID);
		
		if(GetOwnableCarData(buffer[1], OC_SQL_ID) != sql_id) continue;
		
		buffer[2] = buffer[0];
		break;
	}
	return buffer[2];
}

stock GetPlayerIDBySqlID(sql_id)
{
	new playerid = INVALID_PLAYER_ID;
	
	foreach(new idx : Player)
	{
		if(!IsPlayerLogged(idx)) continue;
		if(GetPlayerAccountID(idx) != sql_id) continue;
		
		playerid = idx;
		break;
	}
	return playerid;
}

stock GetPlayerID(name[], playerid=INVALID_PLAYER_ID)
{
	sscanf(name, "u", playerid);
	
	return playerid;
}

stock UpdateHouse(houseid)
{
	if(GetHouseData(houseid, H_ENTRACE) == -1)
	{
		if(GetHouseData(houseid, H_ENTER_PICKUP))
			DestroyPickup(GetHouseData(houseid, H_ENTER_PICKUP));
		
		if(IsValidDynamicMapIcon(GetHouseData(houseid, H_MAP_ICON)))
			DestroyDynamicMapIcon(GetHouseData(houseid, H_MAP_ICON));
		
		SetHouseData(houseid, H_ENTER_PICKUP, CreatePickup((IsHouseOwned(houseid) ? 1272 : 1273), 2, GetHouseData(houseid, H_POS_X), GetHouseData(houseid, H_POS_Y), GetHouseData(houseid, H_POS_Z), 0, PICKUP_ACTION_TYPE_HOUSE, houseid));
		SetHouseData(houseid, H_MAP_ICON, CreateDynamicMapIcon(GetHouseData(houseid, H_POS_X), GetHouseData(houseid, H_POS_Y), GetHouseData(houseid, H_POS_Z), (IsHouseOwned(houseid) ? 32 : 31), 0, 0, 0, -1, STREAMER_MAP_ICON_SD, MAPICON_LOCAL));
	}
}

stock HouseHealthInit(houseid, type = -1)
{
	if(GetHouseData(houseid, H_IMPROVEMENTS) >= 2)
	{
		if(!GetHouseData(houseid, H_HEALTH_PICKUP))
		{
			type = GetHouseData(houseid, H_TYPE);
			SetHouseData(houseid, H_HEALTH_PICKUP, CreatePickup(1240, 2, GetHouseTypeInfo(type, HT_HEALTH_POS_X), GetHouseTypeInfo(type, HT_HEALTH_POS_Y), GetHouseTypeInfo(type, HT_HEALTH_POS_Z), houseid + 2000, PICKUP_ACTION_TYPE_HOUSE_HEALTH, houseid));
		}
	}
	else 
	{
		if(GetHouseData(houseid, H_HEALTH_PICKUP))
		{
			DestroyPickup(GetHouseData(houseid, H_HEALTH_PICKUP));
			SetHouseData(houseid, H_HEALTH_PICKUP, 0);
		}
	}
}

stock HouseStoreInit(houseid, type = -1)
{
	if(GetHouseData(houseid, H_IMPROVEMENTS) >= 5)
	{
		if(GetHouseData(houseid, H_STORE_LABEL) == Text3D:-1)
		{
			if(GetHouseData(houseid, H_STORE_X) == 0.0 && GetHouseData(houseid, H_STORE_Y) == 0.0 && GetHouseData(houseid, H_STORE_Z) == 0.0)
			{
				type = GetHouseData(houseid, H_TYPE);
				
				SetHouseData(houseid, H_STORE_X, GetHouseTypeInfo(type, HT_STORE_POS_X));
				SetHouseData(houseid, H_STORE_Y, GetHouseTypeInfo(type, HT_STORE_POS_Y));
				SetHouseData(houseid, H_STORE_Z, GetHouseTypeInfo(type, HT_STORE_POS_Z));
			}
			SetHouseData(houseid, H_STORE_LABEL, CreateDynamic3DTextLabel("����", 0xFFFF00FF, GetHouseData(houseid, H_STORE_X), GetHouseData(houseid, H_STORE_Y), GetHouseData(houseid, H_STORE_Z) + 0.5, 6.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, houseid + 2000, -1, -1, 50.0));
			
			CallLocalFunction("UpdateHouseStore", "i", houseid);
		}
	}
	else 
	{
		if(GetHouseData(houseid, H_STORE_LABEL) != Text3D:-1)
		{
			if(IsValidDynamic3DTextLabel(GetHouseData(houseid, H_STORE_LABEL)))
			{
				DestroyDynamic3DTextLabel(GetHouseData(houseid, H_STORE_LABEL));
				SetHouseData(houseid, H_STORE_LABEL, Text3D:-1);
			}
		}
	}
}

stock SellHouse(playerid, to_player = INVALID_PLAYER_ID, price = 0)
{
	new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
	if(houseid != -1)
	{
		new house_price = GetHouseData(houseid, H_PRICE);
		new house_percent = (house_price * 30) / 100;
		new house_improvemnts_price = HouseImprovementsPrice(houseid);
		
		if(house_improvemnts_price)
			house_improvemnts_price = (house_improvemnts_price * 60) / 100;
			
		new query[200];
		new return_money = (house_price - house_percent) + house_improvemnts_price;
		
		CallLocalFunction("EvictHouseRentersAll", "i", houseid);
		
		SetPlayerData(playerid, P_HOUSE, -1);
		SetPlayerData(playerid, P_HOUSE_TYPE, HOUSE_TYPE_NONE);
		
		if(to_player == INVALID_PLAYER_ID)
		{
			AddPlayerData(playerid, P_BANK, +, return_money);
		
			SetHouseData(houseid, H_OWNER_ID,		0);
			SetHouseData(houseid, H_IMPROVEMENTS,	0);

			SetHouseData(houseid, H_RENT_DATE,		0);
			SetHouseData(houseid, H_LOCK_STATUS,	false);
			
			format(query, sizeof query, "UPDATE accounts a,houses h SET a.bank=%d,a.house_type=-1,a.house=-1,h.owner_id=0,h.lock=0 WHERE a.id=%d AND h.id=%d", GetPlayerData(playerid, P_BANK), GetPlayerAccountID(playerid), GetHouseData(houseid, H_SQL_ID));
			mysql_query(mysql, query, false);
			
			UpdateHouse(houseid);
			
			HouseHealthInit(houseid);
			HouseStoreInit(houseid);
			
			GivePlayerMoneyEx(playerid, 0, "������� ���� �����������", false, false);
			SendClientMessage(playerid, 0x66CC00FF, "�� ������� ���� ���!");
			
			format(query, sizeof query, "����� �� ������� ���� �������� 30 ��������� �� ��� ��������� {99CC00}(%d ���)", house_percent);
			SendClientMessage(playerid, 0xCECECEFF, query);
			
			format(query, sizeof query, "��� ���� ���������� 60 ��������� �� ��������� ��������� ���������: {CCFF00}%d ���", house_improvemnts_price);
			SendClientMessage(playerid, 0xCECECEFF, query);
			
			format(query, sizeof query, "����� �� ���������� ���� �����������: {3399FF}%d ���", return_money);
			SendClientMessage(playerid, 0xFFFFFFFF, query);
			
			new entranceid = GetHouseData(houseid, H_ENTRACE);
			if(entranceid != -1)
			{
				CallLocalFunction("EntranceStatusInit", "i", entranceid);
			}
		}
		else 
		{
			if(BuyPlayerHouse(to_player, houseid, true, price) == 1)
			{
				new total_price = price + house_improvemnts_price;
				
				format(query, sizeof query, "��� ���� ���������� 60 ��������� �� ��������� ��������� ���������: {CCFF00}%d ���", house_improvemnts_price);
				SendClientMessage(playerid, 0xCECECEFF, query);
				
				format(query, sizeof query, "UPDATE accounts SET money=%d,house=-1 WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)+total_price, GetPlayerAccountID(playerid));
				mysql_query(mysql, query, false);
				
				GivePlayerMoneyEx(playerid, total_price, "������� ���� ������", false, false);
				
				house_price = price;
				house_percent = 0;
			}
			else return ;
		}
		format(query, sizeof query, "~g~+%d rub~n~+%d rub", (house_price - house_percent), house_improvemnts_price);
		GameTextForPlayer(playerid, query, 4000, 1); 
	}
}

stock BuyPlayerHouse(playerid, houseid, bool: buy_from_owner = false, price = -1)
{
	if(!IsHouseOwned(houseid) && GetPlayerHouse(playerid) == -1)
	{
		if(price <= 0)
			price = GetHouseData(houseid, H_PRICE);
			
		if(GetPlayerMoneyEx(playerid) >= price)
		{
			new query[256];
			
			format(query, sizeof query, "UPDATE accounts a, houses h SET a.money=%d,a.house_type=%d,a.house=%d,h.owner_id=%d WHERE a.id=%d AND h.id=%d", GetPlayerMoneyEx(playerid)-price, HOUSE_TYPE_HOME, houseid, GetPlayerAccountID(playerid), GetPlayerAccountID(playerid), GetHouseData(houseid, H_SQL_ID));
			mysql_query(mysql, query, false);
			
			if(!mysql_errno())
			{
				SetPlayerData(playerid, P_HOUSE, 		houseid);
				SetPlayerData(playerid, P_HOUSE_TYPE, 	HOUSE_TYPE_HOME);
				
				SetHouseData(houseid, H_OWNER_ID, 		GetPlayerAccountID(playerid));
				SetHouseData(houseid, H_IMPROVEMENTS, 	0);
				
				SetHouseData(houseid, H_STORE_X, 0.0);
				SetHouseData(houseid, H_STORE_Y, 0.0);
				SetHouseData(houseid, H_STORE_Z, 0.0);
				
				new time = gettime();
				new rent_time = (time - (time % 86400)) + 86400;
				
				if(!buy_from_owner)
				{
					SetHouseData(houseid,	H_RENT_DATE,	rent_time);
					SetHouseData(houseid,	H_LOCK_STATUS,	false);
					
					new entranceid = GetHouseData(houseid, H_ENTRACE);
					if(entranceid != -1)
					{
						CallLocalFunction("EntranceStatusInit", "i", entranceid);
					}			
				}
				else 
				{
					if(GetElapsedTime(GetHouseData(houseid, H_RENT_DATE), time, CONVERT_TIME_TO_DAYS) <= 0)
					{
						SetHouseData(houseid, H_RENT_DATE, rent_time);
					}
				}
				format(g_house[houseid][H_OWNER_NAME], 21, GetPlayerNameEx(playerid), 0);
				
				UpdateHouse(houseid);
				
				HouseHealthInit(houseid);
				HouseStoreInit(houseid);
				
				GivePlayerMoneyEx(playerid, -price, "������� ����", false, true);
				SendClientMessage(playerid, 0x66CC00FF, "�������� {3399FF}/home {66CC00}����� ������ � ������������");

				format(query, sizeof query, "UPDATE houses SET improvements=0,rent_time=%d,`lock`=%d,store_x=0.0,store_y=0.0,store_z=0.0 WHERE id=%d LIMIT 1", GetHouseData(houseid, H_RENT_DATE), GetHouseData(houseid, H_LOCK_STATUS), GetHouseData(houseid, H_SQL_ID));
				mysql_query(mysql, query, false);

				return 1;
			}
			else SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 34)");
			
			return 0;
		}
		return 0;
	}
	return -1;
}

stock EnterPlayerToHouse(playerid, houseid)
{
	if(GetPlayerInHouse(playerid) == -1)
	{
		new type = GetHouseData(houseid, H_TYPE);

		SetPlayerPosEx
		(
			playerid,
			GetHouseTypeInfo(type, HT_ENTER_POS_X),
			GetHouseTypeInfo(type, HT_ENTER_POS_Y),
			GetHouseTypeInfo(type, HT_ENTER_POS_Z),
			GetHouseTypeInfo(type, HT_ENTER_POS_ANGLE),
			GetHouseTypeInfo(type, HT_INTERIOR),
			houseid + 2000
		);
		SetPlayerInHouse(playerid, houseid);
	}
}

stock ExitPlayerFromHouse(playerid, Float: radius = 3.0)
{
	new houseid = GetPlayerInHouse(playerid);
	if(houseid != -1)
	{
		new type = GetHouseData(houseid, H_TYPE);
		if(IsPlayerInRangeOfPoint(playerid, radius, GetHouseTypeInfo(type, HT_ENTER_POS_X), GetHouseTypeInfo(type, HT_ENTER_POS_Y), GetHouseTypeInfo(type, HT_ENTER_POS_Z)))
		{
			SetPlayerInHouse(playerid, -1);
		
			new entranceid = GetHouseData(houseid, H_ENTRACE);
			if(entranceid != -1)
			{
				new floor = GetHouseData(houseid, H_FLAT_ID) / 4 + 1;
				type = GetHouseData(houseid, H_FLAT_ID) % 4;
				
				SetPlayerInEntrance(playerid, entranceid);
				SetPlayerInEntranceFloor(playerid, floor);
				
				SetPlayerPosEx
				(
					playerid, 
					g_entrance_flat_pos[type][3],
					g_entrance_flat_pos[type][4],
					g_entrance_flat_pos[type][2],
					g_entrance_flat_pos[type][5],
					floor + 1,
					(entranceid * 100) + floor
				);
			}
			else
			{
				SetPlayerPosEx
				(
					playerid, 
					GetHouseData(houseid, H_EXIT_POS_X),
					GetHouseData(houseid, H_EXIT_POS_Y),
					GetHouseData(houseid, H_EXIT_POS_Z),
					GetHouseData(houseid, H_EXIT_ANGLE),
					0,
					0				
				);
			}
			return 1;
		}
	}
	return 0;
}

stock GetPlayerHouse(playerid, type = -1)
{
	new houseid = GetPlayerData(playerid, P_HOUSE);
	if(houseid != -1)
	{
		switch(type)
		{
			case HOUSE_TYPE_HOME:
			{
				if(GetPlayerData(playerid, P_HOUSE_TYPE) == HOUSE_TYPE_HOME)
				{
					if(GetHouseData(houseid, H_OWNER_ID) == GetPlayerAccountID(playerid))
					{
						return houseid;
					}
				}
			}
			case HOUSE_TYPE_ROOM:
			{	
				if(GetPlayerData(playerid, P_HOUSE_TYPE) == HOUSE_TYPE_ROOM)
				{
					new room = GetPlayerData(playerid, P_HOUSE_ROOM);
					if(room != -1)
					{
						if(GetHouseRenterInfo(houseid, room, HR_OWNER_ID) == GetPlayerAccountID(playerid))
						{
							return houseid;
						}		
					}
				}
			}
			case HOUSE_TYPE_HOTEL:
			{
				if(GetPlayerData(playerid, P_HOUSE_TYPE) == HOUSE_TYPE_HOTEL)
				{
					new room = GetPlayerData(playerid, P_HOUSE_ROOM);
					if(room != -1)
					{
						if(GetHotelData(houseid, room, H_OWNER_ID) == GetPlayerAccountID(playerid))
						{
							return houseid;
						}
					}
				}
			}
			default:
				return houseid;
		}
	}
	return -1;
}

stock HouseImprovementsPrice(houseid)
{
	new price;
	new level = GetHouseData(houseid, H_IMPROVEMENTS);
	
	if(1 <= level <= sizeof g_house_improvements)
	{
		for(new idx; idx < level; idx ++)
		{
			price += g_house_improvements[idx][I_PRICE];
		}
	}
	return price;
}

stock IsPlayerInRangeOfHouse(playerid, houseid, Float: radius = 10.0)
{
	new result;
	if(GetHouseData(houseid, H_ENTRACE) != -1)
	{
		new flatid = GetHouseData(houseid, H_FLAT_ID) % 4;
		result = IsPlayerInRangeOfPoint(playerid, radius, g_entrance_flat_pos[flatid][0], g_entrance_flat_pos[flatid][1], g_entrance_flat_pos[flatid][2]);
	}
	else result = IsPlayerInRangeOfPoint(playerid, radius, GetHouseData(houseid, H_POS_X), GetHouseData(houseid, H_POS_Y), GetHouseData(houseid, H_POS_Z));

	return result;
}

stock GetFreeHousesCount()
{
	new count;	
	for(new idx; idx < g_house_loaded; idx ++)
	{
		if(IsHouseOwned(idx)) continue;
		
		count ++;
	}
	return count;
}

stock ShowHouseRenterInfo(playerid, houseid, roomid)
{
	if(GetPlayerHouse(playerid, HOUSE_TYPE_HOME) == houseid)
	{
		if(0 <= roomid <= MAX_HOUSE_ROOMS-1)
		{
			if(IsHouseRoomOwned(houseid, roomid))
			{
				SetPlayerUseListitem(playerid, roomid);
			
				new string[144];
				new time = gettime();

				new s_year, s_month, s_day; // ��������� 
				timestamp_to_date(GetHouseRenterInfo(houseid, roomid, HR_RENT_TIME), s_year, s_month, s_day);
				
				//new e_year, e_month, e_day;	// ���������
				//timestamp_to_date(GetHouseRoomInfo(houseid, roomid, HR_RENT_DATE), e_year, e_month, e_day);
				
				format
				(
					string, sizeof string, 
					"1. ���������\t\t\t{CCCC00}%s\n"\
					"2. ���������\t\t\t%02d-%02d-%d\n"\
					"3. ���������\t\t\t{66BB33}%d ����\n"\
					"{888888}4. ��������",
					GetHouseRenterInfo(houseid, roomid, HR_OWNER_NAME),
					s_day, s_month, s_year,
					GetElapsedTime(time, GetHouseRenterInfo(houseid, roomid, HR_RENT_TIME), CONVERT_TIME_TO_DAYS)
				);
				Dialog(playerid, DIALOG_HOUSE_RENTER_INFO, DIALOG_STYLE_LIST, "{33AACC}���������� � ����������", string, "��������", "�����");
			}
			else SendClientMessage(playerid, 0x999999FF, "� ���� ������� ��� ����� �� ���������");
		}
	}
}

stock AddHouseRenter(houseid, roomid, playerid)
{
	if(!IsHouseRoomOwned(houseid, roomid))
	{
		new query[128];
		new Cache: result;
		
		new time = gettime();
		
		format(query, sizeof query, "UPDATE accounts SET house_type=%d,house_room=%d,house=%d WHERE id=%d LIMIT 1", HOUSE_TYPE_ROOM, roomid, houseid, GetPlayerAccountID(playerid));
		mysql_query(mysql, query, false);
		
		format(query, sizeof query, "INSERT INTO houses_renters (owner_id,house_id,room_id,rent_time,time) VALUES (%d,%d,%d,%d,%d)", GetPlayerAccountID(playerid), GetHouseData(houseid, H_SQL_ID), roomid, 0, time);
		result = mysql_query(mysql, query, true);
		
		SetHouseRenterInfo(houseid, roomid, HR_SQL_ID, 		cache_insert_id());
		SetHouseRenterInfo(houseid, roomid, HR_OWNER_ID,	GetPlayerAccountID(playerid));
		SetHouseRenterInfo(houseid, roomid, HR_RENT_DATE,	0);
		SetHouseRenterInfo(houseid, roomid, HR_RENT_TIME,	time);
		
		AddHouseRentersCount(houseid, +, 1);
		
		cache_delete(result);
	}
}

stock EvictHouseRenter(houseid, roomid, renter_id = INVALID_PLAYER_ID, ownerid = INVALID_PLAYER_ID)
{
	if(IsHouseRoomOwned(houseid, roomid))
	{
		new query[90];
		
		format(query, sizeof query, "DELETE FROM houses_renters WHERE owner_id=%d AND house_id=%d", GetHouseRenterInfo(houseid, roomid, HR_OWNER_ID), GetHouseData(houseid, H_SQL_ID));
		mysql_query(mysql, query, false);
		
		format(query, sizeof query, "UPDATE accounts SET house_type=-1,house_room=-1,house=-1 WHERE id=%d LIMIT 1", GetHouseRenterInfo(houseid, roomid, HR_OWNER_ID));
		mysql_query(mysql, query, false);
		
		if(!mysql_errno())
		{
			if(renter_id == INVALID_PLAYER_ID)
				renter_id = GetPlayerID(GetHouseRenterInfo(houseid, roomid, HR_OWNER_NAME));
			
			if(renter_id != INVALID_PLAYER_ID)
			{
				if(GetPlayerHouse(renter_id, HOUSE_TYPE_ROOM) == houseid)
				{
					if(ownerid != INVALID_PLAYER_ID)
					{
						format(query, sizeof query, "%s ������� ��� �� ������ ����", GetPlayerNameEx(ownerid));
						SendClientMessage(renter_id, 0x3399FFFF, query);
					}
					
					SetPlayerData(renter_id, P_HOUSE, -1);
					SetPlayerData(renter_id, P_HOUSE_TYPE, -1);
					SetPlayerData(renter_id, P_HOUSE_ROOM, -1);
				}
			}
			
			SetHouseRenterInfo(houseid, roomid, HR_SQL_ID, 	0);
			SetHouseRenterInfo(houseid, roomid, HR_OWNER_ID,	0);
			SetHouseRenterInfo(houseid, roomid, HR_RENT_DATE,	0);
			SetHouseRenterInfo(houseid, roomid, HR_RENT_TIME,	0);
		
			AddHouseRentersCount(houseid, -, 1);
			return 1;
		}
		return -1;
	}
	return 0;
}

stock GetHouseIndexBySQLID(sql_id)
{
	new index = -1;
	
	for(new idx; idx < MAX_HOUSES; idx ++)
	{
		if(GetHouseData(idx, H_SQL_ID) != sql_id) continue;
		
		index = idx;
		break;
	}
	return index;
}

stock GetHouseFreeRoom(houseid)
{
	new roomid = -1;
	
	for(new idx; idx < MAX_HOUSE_ROOMS; idx ++)
	{
		if(IsHouseRoomOwned(houseid, idx)) continue;
		
		roomid = idx;
		break;
	}
	return roomid;
}

stock LotteryBuyTicketCount()
{
	new count;
	foreach(new playerid : Player)
	{
		if(!IsPlayerLogged(playerid)) continue;
		if(!GetPlayerData(playerid, P_LOTTERY)) continue;
		
		count ++;
	}
	return count;
}

stock ShowPlayerWaitPanel(playerid)
{
	for(new idx; idx < sizeof wait_panel_TD; idx ++)
	{
		TextDrawShowForPlayer(playerid, wait_panel_TD[idx]);
	}
}

stock HidePlayerWaitPanel(playerid)
{
	for(new idx; idx < sizeof wait_panel_TD; idx ++)
	{
		TextDrawHideForPlayer(playerid, wait_panel_TD[idx]);
	}
}

stock ShowPlayerSelectPanel(playerid, type)
{
	if(GetPlayerData(playerid, P_USE_SELECT_PANEL) == SELECT_PANEL_TYPE_NONE)
	{
		for(new idx; idx < sizeof select_TD; idx ++)
		{
			TextDrawShowForPlayer(playerid, select_TD[idx]);
		}
		SetPlayerData(playerid, P_USE_SELECT_PANEL, type);
		
		SelectTextDraw(playerid, 0x009900FF);
	}
}

stock HidePlayerSelectPanel(playerid)
{
	if(GetPlayerData(playerid, P_USE_SELECT_PANEL) != SELECT_PANEL_TYPE_NONE)
	{
		CancelSelectTextDraw(playerid);
		
		for(new idx; idx < sizeof select_TD; idx ++)
		{
			TextDrawHideForPlayer(playerid, select_TD[idx]);
		}
		SetPlayerData(playerid, P_USE_SELECT_PANEL, SELECT_PANEL_TYPE_NONE);
	}
}

stock IsPlayerHaveWeapon(playerid, weaponid)
{
	new weapon, ammo;
	new bool: is_have = false;
	
	for(new idx; idx <= 12; idx ++)
	{
		GetPlayerWeaponData(playerid, idx, weapon, ammo);
		if(weapon != weaponid) continue;
		
		is_have = true;
		break;
	}
	return is_have;
}

stock IsAJobCar(vehicleid)
{
	switch(GetVehicleData(vehicleid, V_ACTION_TYPE))
	{
		case
			VEHICLE_ACTION_TYPE_BUS_DRIVER,
			VEHICLE_ACTION_TYPE_TAXI_DRIVER,	
			VEHICLE_ACTION_TYPE_MECHANIC,		
			VEHICLE_ACTION_TYPE_TRUCKER:
		{
			return 1;
		}
	}
	return 0;
}

stock GetNearestVehicleID(playerid, Float: radius = 0.0)
{
	if(radius == 0.0)
		radius = FLOAT_INFINITY;
		
	new vehicleid = INVALID_VEHICLE_ID;

	new Float: dist;
	new Float: pos_x, Float: pos_y, Float: pos_z;
	
	GetPlayerPos(playerid, pos_x, pos_y, pos_z);
	for(new idx; idx < MAX_VEHICLES; idx ++)
	{
		if(!IsValidVehicle(idx)) continue;
		if(!IsVehicleStreamedIn(idx, playerid)) continue;
		
		dist = GetVehicleDistanceFromPoint(idx, pos_x, pos_y, pos_z);
		if(dist < radius)
		{
			radius = dist,
			vehicleid = idx;
		}
	}
	return vehicleid;
}

stock ShowPlayerBuyJerricanDialog(playerid, stationid)
{
	if(stationid != -1)
	{
		SetPVarInt(playerid, "buy_jerrican_in_fuelst", stationid);
		
		new fmt_str[70];
		format
		(	
			fmt_str, sizeof fmt_str, 
			"{FFFFFF}�������� �� ���� �������� ����� %d ���\n"\
			"�� ������ ������ ��?", 
			GetFuelStationData(stationid, FS_FUEL_PRICE) * 15
		);
		Dialog(playerid, DIALOG_FUEL_STATION_BUY_JERRICA, DIALOG_STYLE_MSGBOX, "{FFCD00}������� ��������", fmt_str, "��", "���");
	}
	else SendClientMessage(playerid, 0xCECECEFF, "�������� � �������� ����� ������ �� ����� ���");
}

stock LoadOrders()
{
	new Cache: result, rows;
	
	result = mysql_query(mysql, "SELECT * FROM orders");
	rows = cache_num_rows();
	
	if(rows > sizeof g_order)
		rows = sizeof g_order;
	
	new buffer;
	for(new idx; idx < rows; idx ++)
	{
		SetOrderData(idx, O_SQL_ID,	cache_get_row_int(idx, 0));
		SetOrderData(idx, O_TYPE, 	cache_get_row_int(idx, 1));
		
		SetOrderData(idx, O_COMPANY_ID, cache_get_row_int(idx, 2));
		SetOrderData(idx, O_AMOUNT, 	cache_get_row_int(idx, 3));
		SetOrderData(idx, O_PRICE, 		cache_get_row_int(idx, 4));
		SetOrderData(idx, O_TIME, 		cache_get_row_int(idx, 5));
		SetOrderData(idx, O_USED, 		false);
		
		buffer = GetOrderData(idx, O_COMPANY_ID);
		switch(GetOrderData(idx, O_TYPE))
		{
			case ORDER_TYPE_FUEL_STATION:
			{
				SetFuelStationData(buffer, FS_ORDER_ID, idx);
			}
			case ORDER_TYPE_BUSINESS:
			{
				SetBusinessData(buffer, B_ORDER_ID, idx);
			}
		}
	}
	cache_delete(result);
	
	printf("[Orders]: ������� ���������: %d", rows);
}

stock CreateOrder(type, company, amount, price, description[] = "")
{
	#pragma unused description // TODO;

	new order_id = GetOrderFreeSlot();
	if(order_id != -1)
	{
		new query[128];
		new Cache: result;
		new time = gettime();
	
		format(query, sizeof query, "INSERT INTO orders (type,company,amount,price,time) VALUES (%d,%d,%d,%d,%d)", type, company, amount, price, time);
		result = mysql_query(mysql, query, true);
	
		if(!mysql_errno())
		{
			new year, month, day;
			getdate(year, month, day);
			
			SetOrderData(order_id, O_TYPE, type);
			SetOrderData(order_id, O_COMPANY_ID, company);
			SetOrderData(order_id, O_AMOUNT, amount);
			SetOrderData(order_id, O_PRICE, price);
			SetOrderData(order_id, O_TIME, time);
			SetOrderData(order_id, O_USED, false);
			
			SetOrderData(order_id, O_SQL_ID, cache_insert_id());
			
			switch(type)
			{
				case ORDER_TYPE_FUEL_STATION:
				{
					SetFuelStationData(company, FS_ORDER_ID, order_id);
				}
				case ORDER_TYPE_BUSINESS:
				{
					SetBusinessData(company, B_ORDER_ID, order_id);
				}
			}
		}
		else order_id = -1;
		
		cache_delete(result);
	}
	return order_id;
}

stock DeleteOrder(orderid)
{
	if(GetOrderData(orderid, O_SQL_ID) > 0)
	{
		new query[64];
		new company = GetOrderData(orderid, O_COMPANY_ID);
		
		switch(GetOrderData(orderid, O_TYPE))
		{
			case ORDER_TYPE_FUEL_STATION:
			{
				SetFuelStationData(company, FS_ORDER_ID, -1);
			}
			case ORDER_TYPE_BUSINESS:
			{
				SetBusinessData(company, B_ORDER_ID, -1);
			}
		}
		
		format(query, sizeof query, "DELETE FROM orders WHERE type=%d AND company=%d", GetOrderData(orderid, O_TYPE), GetOrderData(orderid, O_COMPANY_ID));
		mysql_query(mysql, query, false);
		
		SetOrderData(orderid, O_SQL_ID, 0);
		SetOrderData(orderid, O_PRICE,  0);
		SetOrderData(orderid, O_AMOUNT, 0);
	}
}

stock GetOrderFreeSlot()
{
	new slot = -1;
	
	for(new idx; idx < sizeof g_order; idx ++)
	{
		if(GetOrderData(idx, O_SQL_ID) > 0) continue;
		
		slot = idx;
		break;
	}
	return slot;
}

stock SellFuelStation(playerid, to_player = INVALID_PLAYER_ID, price = 0)
{
	new stationid = GetPlayerFuelStation(playerid);
	if(stationid != -1)
	{
		new fuel_st_price = GetFuelStationData(stationid, FS_PRICE);
		new fuel_st_percent = (fuel_st_price * 30) / 100;
		new fuel_st_improvemnts_price = FuelStationImprovementsPrice(stationid);
		
		if(fuel_st_improvemnts_price)
			fuel_st_improvemnts_price = (fuel_st_improvemnts_price * 60) / 100;
			
		new query[170];
		new return_money = (fuel_st_price - fuel_st_percent) + fuel_st_improvemnts_price;
		
		SetPlayerData(playerid, P_FUEL_ST, -1);
		
		if(to_player == INVALID_PLAYER_ID)
		{
			AddPlayerData(playerid, P_BANK, +, return_money);
		
			SetFuelStationData(stationid, FS_OWNER_ID, 0);
			SetFuelStationData(stationid, FS_IMPROVEMENTS, 	0);

			SetFuelStationData(stationid, FS_FUELS, 		1000);
			SetFuelStationData(stationid, FS_FUEL_PRICE,	3);
			SetFuelStationData(stationid, FS_BUY_FUEL_PRICE,0);
			
			SetFuelStationData(stationid, FS_BALANCE,		0);
			SetFuelStationData(stationid, FS_RENT_DATE,		0);
			SetFuelStationData(stationid, FS_LOCK_STATUS,	false);
			
			format(query, sizeof query, "UPDATE accounts a,fuel_stations f SET a.bank=%d,a.fuel_st=-1,f.owner_id=0,f.fuels=1000,f.fuel_price=3,f.lock=0 WHERE a.id=%d AND f.id=%d", GetPlayerData(playerid, P_BANK), GetPlayerAccountID(playerid), GetFuelStationData(stationid, FS_SQL_ID));
			mysql_query(mysql, query, false);
			
			//format(query, sizeof query, "UPDATE fuel_stations_profit SET view=0 WHERE fid=%d AND view=1",  GetFuelStationData(stationid, FS_SQL_ID));
			//mysql_query(mysql, query, false);
			
			GivePlayerMoneyEx(playerid, 0, "������� ����������� ������� �����������", false, false);
			CallLocalFunction("UpdateFuelStationLabel", "i", stationid);
			
			SendClientMessage(playerid, 0x66CC00FF, "�� ������� ���� ����������� �������!");
			
			format(query, sizeof query, "����� �� ������� ����������� ������� �������� 30 ��������� �� �� ��������� {99CC00}(%d ���)", fuel_st_percent);
			SendClientMessage(playerid, 0xCECECEFF, query);
			
			format(query, sizeof query, "��� ���� ���������� 60 ��������� �� ��������� ��������� ���������: {CCFF00}%d ���", fuel_st_improvemnts_price);
			SendClientMessage(playerid, 0xCECECEFF, query);
			
			format(query, sizeof query, "����� �� ���������� ���� �����������: {3399FF}%d ���", return_money);
			SendClientMessage(playerid, 0xFFFFFFFF, query);
			
		}
		else 
		{
			if(BuyPlayerFuelStation(to_player, stationid, true, price) == 1)
			{
				new total_price = price + fuel_st_improvemnts_price;
				
				format(query, sizeof query, "��� ���� ���������� 60 ��������� �� ��������� ��������� ���������: {CCFF00}%d ���", fuel_st_improvemnts_price);
				SendClientMessage(playerid, 0xCECECEFF, query);
				
				format(query, sizeof query, "UPDATE accounts SET money=%d,fuel_st=-1 WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)+total_price, GetPlayerAccountID(playerid));
				mysql_query(mysql, query, false);
				
				GivePlayerMoneyEx(playerid, total_price, "������� ����������� ������� ������", false, false);
				
				fuel_st_price = price;
				fuel_st_percent = 0;
			}
			else return ;
		}
		format(query, sizeof query, "~g~+%d rub~n~+%d rub", (fuel_st_price - fuel_st_percent), fuel_st_improvemnts_price);
		GameTextForPlayer(playerid, query, 4000, 1); 
	}
}

stock BuyPlayerFuelStation(playerid, stationid, bool: buy_from_owner = false, price = -1)
{
	if(!IsFuelStationOwned(stationid) && GetPlayerFuelStation(playerid) == -1)
	{
		if(price <= 0)
			price = GetFuelStationData(stationid, FS_PRICE);
			
		if(GetPlayerMoneyEx(playerid) >= price)
		{
			new query[256];
			
			format(query, sizeof query, "UPDATE accounts a, fuel_stations f SET a.money=%d,a.fuel_st=%d,f.owner_id=%d WHERE a.id=%d AND f.id=%d", GetPlayerMoneyEx(playerid)-price, stationid, GetPlayerAccountID(playerid), GetPlayerAccountID(playerid), GetFuelStationData(stationid, FS_SQL_ID));
			mysql_query(mysql, query, false);
			
			if(!mysql_errno())
			{
				SetPlayerData(playerid, P_FUEL_ST, stationid);
			
				SetFuelStationData(stationid, FS_OWNER_ID, 		GetPlayerAccountID(playerid));
				SetFuelStationData(stationid, FS_IMPROVEMENTS, 	0);
				
				new time = gettime();
				new rent_time = (time - (time % 86400)) + 86400;
				
				if(!buy_from_owner)
				{
					SetFuelStationData(stationid, FS_FUELS, 		50);
					SetFuelStationData(stationid, FS_FUEL_PRICE,	3);
					SetFuelStationData(stationid, FS_BUY_FUEL_PRICE,0);
					
					SetFuelStationData(stationid, FS_BALANCE,		0);
					SetFuelStationData(stationid, FS_RENT_DATE,		rent_time);
					SetFuelStationData(stationid, FS_LOCK_STATUS,	false);
				}
				else 
				{
					if(GetElapsedTime(GetFuelStationData(stationid, FS_RENT_DATE), time, CONVERT_TIME_TO_DAYS) <= 0)
					{
						SetFuelStationData(stationid, FS_RENT_DATE, rent_time);
					}
				}
				format(g_fuel_station[stationid][FS_OWNER_NAME], 21, GetPlayerNameEx(playerid), 0);
				CallLocalFunction("UpdateFuelStationLabel", "i", stationid);
				
				GivePlayerMoneyEx(playerid, -price, "������� ����������� �������", false, true);
				SendClientMessage(playerid, 0x66CC00FF, "�������� {3399FF}/fuelst {66CC00}����� ������ � ������������");

				format(query, sizeof query, "UPDATE fuel_stations SET improvements=0,fuels=%d,fuel_price=%d,buy_fuel_price=%d,balance=%d,rent_time=%d,`lock`=%d WHERE id=%d LIMIT 1", GetFuelStationData(stationid, FS_FUELS), GetFuelStationData(stationid, FS_FUEL_PRICE), GetFuelStationData(stationid, FS_BUY_FUEL_PRICE), GetFuelStationData(stationid, FS_BALANCE), GetFuelStationData(stationid, FS_RENT_DATE), GetFuelStationData(stationid, FS_LOCK_STATUS), GetFuelStationData(stationid, FS_SQL_ID));
				mysql_query(mysql, query, false);
				
				format(query, sizeof query, "UPDATE fuel_stations_profit SET view=0 WHERE fid=%d AND view=1",  GetFuelStationData(stationid, FS_SQL_ID));
				mysql_query(mysql, query, false);
				
				return 1;
			}
			
			SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 16)");
			return 0;
		}
		return 0;
	}
	return -1;
}

stock FuelStationFillCar(playerid, vehicleid, stationid)
{
	if(IsPlayerDriver(playerid) && IsPlayerInVehicle(playerid, vehicleid))
	{
		if(0 <= stationid <= g_fuel_station_loaded)
		{
			if(!GetFuelStationData(stationid, FS_LOCK_STATUS))
			{
				new fmt_str[150];
				
				new buy_fuel_pay = GetPVarInt(playerid, "buy_fuel_pay");
				new buy_fuel_count = GetPVarInt(playerid, "buy_fuel_count");
				
				new price = GetFuelStationData(stationid, FS_FUEL_PRICE) * 10;
				
				if(GetPlayerMoneyEx(playerid) >= price)
				{
					if((GetVehicleData(vehicleid, V_FUEL) + 10.0) <= 150.0)
					{
						if(GetFuelStationData(stationid, FS_FUELS) >= 10)
						{
							if(IsFuelStationOwned(stationid))
							{						
								AddFuelStationData(stationid, FS_FUELS, -, 10);
								AddFuelStationData(stationid, FS_BALANCE, +, price);
							}
							SetVehicleData(vehicleid, V_FUEL, GetVehicleData(vehicleid, V_FUEL) + 10);
							
							buy_fuel_count += 10;
							buy_fuel_pay += price;
							
							SetPVarInt(playerid, "buy_fuel_pay", buy_fuel_pay);
							SetPVarInt(playerid, "buy_fuel_count", buy_fuel_count);
							
							format(fmt_str, sizeof fmt_str, "UPDATE accounts a,fuel_stations f SET a.money=%d,f.fuels=%d,f.balance=%d WHERE a.id=%d AND f.id=%d", GetPlayerMoneyEx(playerid)-price, GetFuelStationData(stationid, FS_FUELS), GetFuelStationData(stationid, FS_BALANCE), GetPlayerAccountID(playerid), GetFuelStationData(stationid, FS_SQL_ID));
							mysql_query(mysql, fmt_str, false);
							
							fmt_str = "";
							GivePlayerMoneyEx(playerid, -price, "������� ������� �� ��������", false, false);
						} 
						else strcat(fmt_str, "~n~~r~~h~no fuel");
					}
					else strcat(fmt_str, "~n~~r~~h~benzobak full");
					
					format(fmt_str, sizeof fmt_str, "~w~summa: ~g~~h~%d rub~n~~w~litres: ~b~%d%s", buy_fuel_pay, buy_fuel_count, fmt_str);
					GameTextForPlayer(playerid, fmt_str, 3000, 4);
				}
				else SendClientMessage(playerid, 0xCECECEFF, "������������ ����� ��� ��������");
			}
			else 
			{
				GameTextForPlayer(playerid, "~w~fuel station~n~~r~~h~is closed", 3000, 4);
				//SendClientMessage(playerid, 0xFF6600FF, "����������� ������� �������");
			}
		}
	}
}

stock GetFuelStationMaxFuel(stationid)
{
	new max_fuels = 2500; 
	new i_level = GetFuelStationData(stationid, FS_IMPROVEMENTS);

	if(i_level > 3)
		i_level = 3;
	
	max_fuels += i_level * 2500;
	return max_fuels;
}

stock GetNearestFuelStation(playerid, Float: dist = 15.0)
{
	if(dist == 0.0)
		dist = FLOAT_INFINITY;
		
	new stationid = -1;
	new Float: my_dist;
	
	for(new idx; idx < g_fuel_station_loaded; idx ++)
	{
		my_dist = GetPlayerDistanceFromPoint(playerid, GetFuelStationData(idx, FS_POS_X), GetFuelStationData(idx, FS_POS_Y), GetFuelStationData(idx, FS_POS_Z));
		if(my_dist < dist)
		{
			dist = my_dist,
			stationid = idx;
		}
	}
	return stationid;
}

stock GetPlayerFuelStation(playerid)
{
	new stationid = GetPlayerData(playerid, P_FUEL_ST);
	
	if(stationid != -1)
	{
		if(GetFuelStationData(stationid, FS_OWNER_ID) == GetPlayerAccountID(playerid))
		{
			return stationid;
		}
	}
	return -1;
}

stock FuelStationImprovementsPrice(stationid)
{
	new price;
	new level = GetFuelStationData(stationid, FS_IMPROVEMENTS);
	
	if(1 <= level <= sizeof g_fuel_station_improvements)
	{
		for(new idx; idx < level; idx ++)
		{
			price += g_fuel_station_improvements[idx][I_PRICE];
		}
	}
	return price;
}

stock ShowPlayerFuelStationPayForRent(playerid)
{
	new stationid = GetPlayerFuelStation(playerid);
	if(stationid != -1)
	{
		new fmt_str[256];
		
		format
		(
			fmt_str, sizeof fmt_str, 
			"{FFFFFF}����������� �������:\t\t�%d (%s)\n"\
			"���������� ���� �������:\t\t%d �� 30\n"\
			"���������� �������� �����:\t%d ���\n"\
			"��� ������:\t\t\t\t%s\n\n"\
			"�� ������� ���� �� ������ ���������� ����������� �������?",
			stationid,
			GetFuelStationData(stationid, FS_NAME),
			GetElapsedTime(GetFuelStationData(stationid, FS_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS),
			GetFuelStationData(stationid, FS_IMPROVEMENTS) < 4 ? GetFuelStationData(stationid, FS_RENT_PRICE) : GetFuelStationData(stationid, FS_RENT_PRICE) / 2,
			GetFuelStationData(stationid, FS_IMPROVEMENTS) < 4 ? ("������") : ("����������")
		);	
		Dialog(playerid, DIALOG_PAY_FOR_RENT_FUEL_ST, DIALOG_STYLE_INPUT, "{66CC00}������ ����������� �������", fmt_str, "��������", "�����");
	}
}

stock ShowPlayerBusinessPayForRent(playerid)
{
	new businessid = GetPlayerBusiness(playerid);
	if(businessid != -1)
	{
		new fmt_str[256];
		
		format
		(
			fmt_str, sizeof fmt_str, 
			"{FFFFFF}������:\t\t\t\t�%d (%s)\n"\
			"���������� ���� �������:\t\t%d �� 30\n"\
			"���������� �������� �����:\t%d ���\n"\
			"��� ������:\t\t\t\t%s\n\n"\
			"�� ������� ���� �� ������ ���������� ������?",
			businessid,
			GetBusinessData(businessid, B_NAME),
			GetElapsedTime(GetBusinessData(businessid, B_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS),
			GetBusinessData(businessid, B_IMPROVEMENTS) < 3 ? GetBusinessData(businessid, B_RENT_PRICE) : GetBusinessData(businessid, B_RENT_PRICE) / 2,
			GetBusinessData(businessid, B_IMPROVEMENTS) < 3 ? ("������") : ("����������")
		);	
		Dialog(playerid, DIALOG_PAY_FOR_RENT_BIZ, DIALOG_STYLE_INPUT, "{66CC00}������ �������", fmt_str, "��������", "�����");
	}
}

stock ShowPlayerHousePayForRent(playerid)
{
	new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
	if(houseid != -1)
	{
		new fmt_str[256];
		
		format
		(
			fmt_str, sizeof fmt_str, 
			"{FFFFFF}���:\t\t\t\t\t�%d (%s)\n"\
			"���������� ���� �������:\t\t%d �� 30\n"\
			"���������� ����������:\t\t%d ���\n"\
			"��������:\t\t\t\t%s\n\n"\
			"�� ������� ���� �� ������ �������� ���?",
			houseid,
			GetHouseData(houseid, H_NAME),
			GetElapsedTime(GetHouseData(houseid, H_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS),
			GetHouseData(houseid, H_IMPROVEMENTS) < 4 ? GetHouseData(houseid, H_RENT_PRICE) : GetHouseData(houseid, H_RENT_PRICE) / 2,
			GetHouseData(houseid, H_IMPROVEMENTS) < 4 ? ("���") : ("����")
		);	
		Dialog(playerid, DIALOG_PAY_FOR_RENT_HOUSE, DIALOG_STYLE_INPUT, "{66CC00}������ ����", fmt_str, "��������", "�����");
	}
}

stock SellBusiness(playerid, to_player = INVALID_PLAYER_ID, price = 0)
{
	new businessid = GetPlayerBusiness(playerid);
	if(businessid != -1)
	{
		new biz_price = GetBusinessData(businessid, B_PRICE);
		new biz_percent = (biz_price * 30) / 100;
		new biz_improvemnts_price = BusinessImprovementsPrice(businessid);
		
		if(biz_improvemnts_price)
			biz_improvemnts_price = (biz_improvemnts_price * 60) / 100;
		
		new query[200];
		new return_money = (biz_price - biz_percent) + biz_improvemnts_price;
		
		SetPlayerData(playerid, P_BUSINESS, -1);
		
		if(to_player == INVALID_PLAYER_ID)
		{
			AddPlayerData(playerid, P_BANK, +, return_money);
			
			SetBusinessData(businessid, B_OWNER_ID, 		0);
			SetBusinessData(businessid, B_IMPROVEMENTS, 	0);

			SetBusinessData(businessid, B_PRODS, 			0);
			SetBusinessData(businessid, B_PROD_PRICE,		0);
			
			SetBusinessData(businessid, B_BALANCE,			0);
			SetBusinessData(businessid, B_RENT_DATE,		0);
			SetBusinessData(businessid, B_ENTER_MUSIC,		0);
			SetBusinessData(businessid, B_LOCK_STATUS,	false);
			
			BusinessHealthPickupInit(businessid);
			
			format(query, sizeof query, "UPDATE accounts a,business b SET a.bank=%d,a.fuel_st=-1,b.owner_id=0,b.products=0,b.prod_price=0,b.lock=0 WHERE a.id=%d AND b.id=%d", GetPlayerData(playerid, P_BANK), GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
			mysql_query(mysql, query, false);
			
			format(query, sizeof query, "DELETE FROM business_gps WHERE bid=%d", businessid);
			mysql_query(mysql, query, false);
			
			g_business_gps_init = false;
			
			//format(query, sizeof query, "UPDATE business_profit SET view=0 WHERE bid=%d AND view=1", GetBusinessData(businessid, B_SQL_ID));
			//mysql_query(mysql, query, false);
			
			GivePlayerMoneyEx(playerid, 0, "������� ������� �����������", false, false);
			CallLocalFunction("UpdateBusinessLabel", "i", businessid);
			
			SendClientMessage(playerid, 0x66CC00FF, "�� ������� ���� ������!");
			
			format(query, sizeof query, "����� �� ������� ������� �������� 30 ��������� �� ��� ��������� {99CC00}(%d ���)", biz_percent);
			SendClientMessage(playerid, 0xCECECEFF, query);
			
			format(query, sizeof query, "��� ���� ���������� 60 ��������� �� ��������� ��������� ���������: {CCFF00}%d ���", biz_improvemnts_price);
			SendClientMessage(playerid, 0xCECECEFF, query);
			
			format(query, sizeof query, "����� �� ���������� ���� �����������: {3399FF}%d ���", return_money);
			SendClientMessage(playerid, 0xFFFFFFFF, query);
		}
		else 
		{
			if(BuyPlayerBusiness(to_player, businessid, true, price) == 1)
			{
				new total_price = price + biz_improvemnts_price;
				
				format(query, sizeof query, "��� ���� ���������� 60 ��������� �� ��������� ��������� ���������: {CCFF00}%d ���", biz_improvemnts_price);
				SendClientMessage(playerid, 0xCECECEFF, query);
				
				format(query, sizeof query, "UPDATE accounts SET money=%d,business=-1 WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)+total_price, GetPlayerAccountID(playerid));
				mysql_query(mysql, query, false);
				
				format(query, sizeof query, "DELETE FROM business_gps WHERE bid=%d", businessid);
				mysql_query(mysql, query, false);
				
				g_business_gps_init = false;
				GivePlayerMoneyEx(playerid, total_price, "������� ������� ������", false, false);
				
				biz_price = price;
				biz_percent = 0;
			}
			else return ;
		}
		format(query, sizeof query, "~g~+%d rub~n~+%d rub", (biz_price - biz_percent), biz_improvemnts_price);
		GameTextForPlayer(playerid, query, 4000, 1); 
	}
}

stock BuyPlayerBusiness(playerid, businessid, bool: buy_from_owner = false, price = -1)
{
	if(!IsBusinessOwned(businessid) && GetPlayerBusiness(playerid) == -1)
	{
		if(price <= 0)
			price = GetBusinessData(businessid, B_PRICE);
			
		if(GetPlayerMoneyEx(playerid) >= price)
		{
			new query[256];
			
			format(query, sizeof query, "UPDATE accounts a, business b SET a.money=%d,a.business=%d,b.owner_id=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, businessid, GetPlayerAccountID(playerid), GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
			mysql_query(mysql, query, false);
			
			if(!mysql_errno())
			{
				SetPlayerData(playerid, P_BUSINESS, businessid);
				
				SetBusinessData(businessid, B_OWNER_ID, 		GetPlayerAccountID(playerid));
				SetBusinessData(businessid, B_IMPROVEMENTS, 	0);
				
				new time = gettime();
				new rent_time = (time - (time % 86400)) + 86400;
				
				if(!buy_from_owner)
				{
					SetBusinessData(businessid,	B_PRODS, 		20);
					SetBusinessData(businessid,	B_PROD_PRICE, 	0);
					
					SetBusinessData(businessid,	B_ENTER_MUSIC, 	0);
					SetBusinessData(businessid,	B_ENTER_PRICE, 	0);
					
					SetBusinessData(businessid,	B_BALANCE, 		0);
					SetBusinessData(businessid,	B_RENT_DATE,	rent_time);
					SetBusinessData(businessid,	B_LOCK_STATUS,	false);
				}
				else 
				{
					if(GetElapsedTime(GetBusinessData(businessid, B_RENT_DATE), time, CONVERT_TIME_TO_DAYS) <= 0)
					{
						SetBusinessData(businessid, B_RENT_DATE, rent_time);
					}
				}
				format(g_business[businessid][B_OWNER_NAME], 21, GetPlayerNameEx(playerid), 0);
				CallLocalFunction("UpdateBusinessLabel", "i", businessid);
				
				GivePlayerMoneyEx(playerid, -price, "������� �������", false, true);
				SendClientMessage(playerid, 0x66CC00FF, "�������� {0099FF}/business {66CC00}����� ������ � ������������");

				format(query, sizeof query, "UPDATE business SET improvements=0,products=%d,prod_price=%d,balance=%d,rent_time=%d,`lock`=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_PRODS), GetBusinessData(businessid, B_PROD_PRICE), GetBusinessData(businessid, B_BALANCE), GetBusinessData(businessid, B_RENT_DATE), GetBusinessData(businessid, B_LOCK_STATUS), GetBusinessData(businessid, B_SQL_ID));
				mysql_query(mysql, query, false);
				
				format(query, sizeof query, "UPDATE business_profit SET view=0 WHERE bid=%d AND view=1", GetBusinessData(businessid, B_SQL_ID));
				mysql_query(mysql, query, false);
				
				return 1;
			}
			
			SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 21)");
			return 0;
		}
		return 0;
	}
	return -1;
}

stock BusinessHealthPickupInit(businessid)
{
	if(GetBusinessData(businessid, B_IMPROVEMENTS) >= 2)
	{
		if(!GetBusinessData(businessid, B_HEALTH_PICKUP))
		{
			new interior = GetBusinessData(businessid, B_INTERIOR);
			SetBusinessData(businessid, B_HEALTH_PICKUP, CreatePickup(1240, 2, GetBusinessInteriorInfo(interior, BT_HEALTH_POS_X), GetBusinessInteriorInfo(interior, BT_HEALTH_POS_Y), GetBusinessInteriorInfo(interior, BT_HEALTH_POS_Z), businessid + 255, PICKUP_ACTION_TYPE_BIZ_HEALTH, businessid));
		}
	}
	else
	{
		if(GetBusinessData(businessid, B_HEALTH_PICKUP))
		{
			DestroyPickup(GetBusinessData(businessid, B_HEALTH_PICKUP));
			SetBusinessData(businessid, B_HEALTH_PICKUP, 0);
		}
	}
}

stock GetBusinessEnterProdCount(businessid)
{
	new take_prods = 0;
	new enter_price = GetBusinessData(businessid, B_ENTER_PRICE);
	
	if(enter_price > 0)
	{
		if(enter_price < 150)
		{
			take_prods = 1;
		}
		else if(enter_price < 500)
		{
			take_prods = 2;
		}
		else take_prods = 3;
	}
	return take_prods;
}

stock GetBusinessMaxProd(businessid)
{
	new max_prods = 500;
	new i_level = GetBusinessData(businessid, B_IMPROVEMENTS);
	
	if(i_level >= 5)
	{
		max_prods = 10_000;
	}
	else if(i_level >= 1)
	{
		max_prods = 3_000;
	}
	else max_prods = 500;

	return max_prods;
}

stock GetNearestBusiness(playerid, Float: dist = 10.0)
{
	if(dist == 0.0)
		dist = FLOAT_INFINITY;
		
	new businessid = -1;
	new Float: my_dist;
	
	for(new idx; idx < g_business_loaded; idx ++)
	{
		my_dist = GetPlayerDistanceFromPoint(playerid, GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y), GetBusinessData(idx, B_POS_Z));
		if(my_dist < dist)
		{
			dist = my_dist,
			businessid = idx;
		}
	}
	return businessid;
}

stock BusinessImprovementsPrice(businessid)
{
	new price;
	new level = GetBusinessData(businessid, B_IMPROVEMENTS);
	
	if(1 <= level <= sizeof g_business_improvements)
	{
		for(new idx; idx < level; idx ++)
		{
			price += g_business_improvements[idx][I_PRICE];
		}
	}
	return price;
}

stock EnterPlayerToBiz(playerid, businessid)
{
	if(GetPlayerInBiz(playerid) == -1)
	{
		new buffer = GetBusinessData(businessid, B_INTERIOR);
		SetPlayerPosEx
		(
			playerid, 
			GetBusinessInteriorInfo(buffer, BT_ENTER_POS_X), 
			GetBusinessInteriorInfo(buffer, BT_ENTER_POS_Y), 
			GetBusinessInteriorInfo(buffer, BT_ENTER_POS_Z),
			GetBusinessInteriorInfo(buffer, BT_ENTER_ANGLE),
			GetBusinessInteriorInfo(buffer, BT_ENTER_INTERIOR),
			businessid + 255
		);
		SetPlayerInBiz(playerid, businessid);
		
		buffer = GetBusinessData(businessid, B_ENTER_MUSIC);
		if(1 <= buffer <= sizeof g_business_sound)
		{
			PlayerPlaySound(playerid, g_business_sound[buffer - 1], 0.0, 0.0, 0.0);
		}
	}
	return 1;
}

stock GetPlayerBusiness(playerid)
{
	new businessid = GetPlayerData(playerid, P_BUSINESS);
	
	if(businessid != -1)
	{
		if(GetBusinessData(businessid, B_OWNER_ID) == GetPlayerAccountID(playerid))
		{
			return businessid;
		}
	}
	return -1;
}

stock GetFreeBusinessCount()
{
	new count;	
	for(new idx; idx < g_business_loaded; idx ++)
	{
		if(IsBusinessOwned(idx)) continue;
		
		count ++;
	}
	return count;
}

stock IsPlayerInBuyPosBiz(playerid, businessid, type, Float: radius = 50.0)
{
	if(GetBusinessData(businessid, B_TYPE) == type)
	{
		new interior = GetBusinessData(businessid, B_INTERIOR);
		if(IsPlayerInRangeOfPoint(playerid, radius, GetBusinessInteriorInfo(interior, BT_BUY_POS_X), GetBusinessInteriorInfo(interior, BT_BUY_POS_Y), GetBusinessInteriorInfo(interior, BT_BUY_POS_Z)))	
		{
			return 1;
		}
	}
	return 0;
}

stock ShowPlayerRealtorHomeDialog(playerid)
{
	Dialog
	(
		playerid, DIALOG_BIZ_REALTOR_HOME_GET, DIALOG_STYLE_INPUT,
		"{99CC00}���������� � ����", 
		"{FFFFFF}������� ����� ����, ����������\n"\
		"� ������� �� ������ ��������\n\n"\
		"{FFCD00}��������� ������ 50 ������",
		"�����", "������"
	);
}

stock IsABike(vehicleid)
{
	switch(GetVehicleData(vehicleid, V_MODELID))
	{
		case 481, 509, 510:
		{
			return 1;
		}
	}
	return 0;
}

stock SetPlayerPhoneUseState(playerid, bool: use = true, bool: bubble = true)
{
	if(use)
	{
		SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, GetPlayerData(playerid, P_PHONE_COLOR) + 18865, A_OBJECT_BONE_RIGHT_HAND, 0.1, 0.001, 0.0, 280.0, 0.0, 200.0, 1.0, 1.0, 1.0);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
		
		SetPlayerData(playerid, P_USE_ANIM_TYPE, USE_ANIM_TYPE_NONE - 1);
		
		if(bubble)
			Action(playerid, "������ �������", _, false);
	}
	else 
	{
		RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND);
		SetPlayerData(playerid, P_USE_ANIM_TYPE, USE_ANIM_TYPE_NONE);
		
		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USECELLPHONE)
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
	}
}

stock GetElapsedTime(time, to_time, type = CONVERT_TIME_TO_HOURS)
{
	new result;
	
	switch(type)
	{
		case CONVERT_TIME_TO_MINUTES:
		{
			result = ((time - (time % 60)) - (to_time - (to_time % 60))) / 60;
		}
		case CONVERT_TIME_TO_HOURS:
		{
			result = ((time - (time % 3600)) - (to_time - (to_time % 3600))) / 3600;
		}
		case CONVERT_TIME_TO_DAYS:
		{
			result = ((time - (time % 86400)) - (to_time - (to_time % 86400))) / 86400;
		}
		default: 
			result = -1;
	}
	return result;
}

stock ConvertUnixTime(unix_time, type = CONVERT_TIME_TO_SECONDS)
{
	switch(type)
	{
		case CONVERT_TIME_TO_SECONDS:
		{
			unix_time %= 60;
		}
		case CONVERT_TIME_TO_MINUTES:
		{
			unix_time = (unix_time / 60) % 60;
		}
		case CONVERT_TIME_TO_HOURS:
		{
			unix_time = (unix_time / 3600) % 24;
		}
		default:
			unix_time %= 60;
	}
	return unix_time;
}

stock CheckPlayerFlood(playerid, bool:inc = true, max_rate = MAX_FLOOD_RATE, rate_inc = FLOOD_RATE_INC, kick_rate = FLOOD_RATE_KICK)
{
	new tick = GetTickCount();
	
	AddPlayerAntiFloodData(playerid, AF_RATE, +, inc ? rate_inc : 0);
	AddPlayerAntiFloodData(playerid, AF_RATE, -, (GetTickCount() - GetPlayerAntiFloodData(playerid, AF_LAST_TICK)));
	SetPlayerAntiFloodData(playerid, AF_LAST_TICK, tick);
	
	if(GetPlayerAntiFloodData(playerid, AF_RATE) < 0)
		SetPlayerAntiFloodData(playerid, AF_RATE, 0);
	
	if(GetPlayerAntiFloodData(playerid, AF_RATE) >= max_rate)
	{
		if(GetPlayerAntiFloodData(playerid, AF_RATE) >= kick_rate)
		{
			Kick(playerid);
		}
		return 1;
	}
	return 0;
}

stock ShowPhoneBookOperation(playerid, operationid, contactid=0)
{
	switch(operationid)
	{
		case PHONE_BOOK_OPERATION_OPTIONS:
		{
			SetPlayerPhoneBookSelectContact(playerid, GetPlayerListitemValue(playerid, contactid));
			
			Dialog
			(
				playerid, DIALOG_PHONE_BOOK_OPTION, DIALOG_STYLE_LIST,
				"{FFCD00}��������", 
				"1. ���������\n"\
				"2. ��������� SMS ���������\n"\
				"3. �������� ��� ��������\n"\
				"4. �������� ����� ��������\n"\
				"5. ������� �������",
				"�������", "�����"
			);
		}
		case PHONE_BOOK_OPERATION_CALL:
		{
			new number[11]; // TODO
			format(number, sizeof number, "%d", GetPlayerPhoneBook(playerid, contactid, PB_NUMBER));
			cmd::c(playerid, number);
		}
		case PHONE_BOOK_OPERATION_SEND_SMS:
		{
			Dialog
			(
				playerid, DIALOG_PHONE_BOOK_SEND_SMS, DIALOG_STYLE_INPUT,
				"{FFCD00}�������� SMS ���������", 
				"{FFFFFF}-\t\t\t������� ����� SMS ���������:\t\t-", 
				"���������", "�����"
			);
		}
		case PHONE_BOOK_OPERATION_CHANGE_NAM:
		{
			Dialog
			(
				playerid, DIALOG_PHONE_BOOK_CHANGE_NAME, DIALOG_STYLE_INPUT, 
				"{FFCD00}��������� ����� ��������", 
				"{FFFFFF}������� ����� ��� ��� ��������:", 
				"��������", "�����"
			);
		}
		case PHONE_BOOK_OPERATION_CHANGE_NUM:
		{
			Dialog
			(
				playerid, DIALOG_PHONE_BOOK_CHANGE_NUMBER, DIALOG_STYLE_INPUT, 
				"{FFCD00}��������� ������ ��������", 
				"{FFFFFF}������� ����� ����� ��� ��������:",
				"��������", "�����"
			);
		}
		case PHONE_BOOK_OPERATION_DELETE_CON:
		{
			if(GetPlayerPhoneBook(playerid, contactid, PB_SQL_ID))
			{
				new query[80];
			
				format(query, sizeof query, "DELETE FROM phone_books WHERE id=%d LIMIT 1", GetPlayerPhoneBook(playerid, contactid, PB_SQL_ID));
				mysql_query(mysql, query, false);
				
				SetPlayerPhoneBookInitStatus(playerid, false);
				SendClientMessage(playerid, 0xFF9030FF, "������� ������ � ������ ��������");
			}
		}
	}
}

stock AddPhoneBookContact(playerid, name[], number[])
{
	if(!IsPlayerPhoneBookInit(playerid))
	{
		InitPlayerPhoneBook(playerid);
	}
	if(GetPlayerPhoneBookContacts(playerid) < MAX_PHONE_BOOK_CONTACTS)
	{
		if(!CheckPhoneBookUsedNumber(playerid, number))
		{
			new fmt_str[128];
			SetPlayerPhoneBookInitStatus(playerid, false);
			
			format(fmt_str, sizeof fmt_str, "�� �������� %s (���. %s) � ���� ������ ���������", name, number);
			SendClientMessage(playerid, 0x33FF66FF, fmt_str);
			
			mysql_format(mysql, fmt_str, sizeof fmt_str, "INSERT INTO phone_books (owner_id,name,number,time) VALUES (%d,'%e','%e',%d)", GetPlayerAccountID(playerid), name, number, gettime());
			mysql_query(mysql, fmt_str, false);
		}
	}
	return 1;
}

stock CheckPhoneBookUsedNumber(playerid, number[])
{
	for(new idx, len; idx < MAX_PHONE_BOOK_CONTACTS; idx ++)
	{
		if(!GetPlayerPhoneBook(playerid, idx, PB_SQL_ID)) continue;
		
		len = strlen(GetPlayerPhoneBook(playerid, idx, PB_NUMBER));
		if(len && !strcmp(GetPlayerPhoneBook(playerid, idx, PB_NUMBER), number, true))
		{
			new fmt_str[64];
			format(fmt_str, sizeof fmt_str, "{FFFFFF}����� %s ��� ������� ��� �������� %s", number, GetPlayerPhoneBook(playerid, idx, PB_NAME));
			Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FF6633}������", fmt_str, "�������", "");
			
			return 1;
		}
	}
	return 0;
}

stock InitPlayerPhoneBook(playerid)
{
	if(!IsPlayerPhoneBookInit(playerid))
	{
		new query[80];
		new Cache: result, rows;
		
		format(query, sizeof query, "SELECT * FROM phone_books WHERE owner_id=%d ORDER BY id DESC LIMIT %d", GetPlayerAccountID(playerid), MAX_PHONE_BOOK_CONTACTS);
		result = mysql_query(mysql, query);
		
		rows = cache_num_rows();
		for(new idx; idx < MAX_PHONE_BOOK_CONTACTS; idx ++)
		{
			if(idx < rows)
			{
				SetPlayerPhoneBook(playerid, idx, PB_SQL_ID, cache_get_row_int(idx, 0));
				
				cache_get_row(idx, 2, g_player_phone_book[playerid][idx][PB_NAME], mysql, 21);
				cache_get_row(idx, 3, g_player_phone_book[playerid][idx][PB_NUMBER], mysql, 9);
				
				SetPlayerPhoneBook(playerid, idx, PB_TIME, cache_get_row_int(idx, 4));
				continue;
			}
			ClearPlayerPhoneBookContact(playerid, idx);
		}
		cache_delete(result);
		
		SetPlayerPhoneBookContacts(playerid, rows);
		SetPlayerPhoneBookInitStatus(playerid, true);
	}
	return 1;
}

stock ClearPlayerPhoneBookContact(playerid, contactid)
{
	SetPlayerPhoneBook(playerid, contactid, PB_SQL_ID, 	0);
	SetPlayerPhoneBook(playerid, contactid, PB_NAME, 	0);
	SetPlayerPhoneBook(playerid, contactid, PB_NUMBER, 	0);
	SetPlayerPhoneBook(playerid, contactid, PB_TIME, 	0);
}

stock GetPlayerIDByPhone(number)
{	
	new playerid = INVALID_PLAYER_ID;
	
	if(100000 <= number <= 9999999)
	{
		foreach(new i : Player)
		{
			if(!IsPlayerLogged(i)) continue;
			if(number != GetPlayerPhone(i)) continue;
			
			playerid = i;
			break;
		}
	}
	return playerid;
}

stock CheckPlayerTempJobState(playerid)
{
	new job = GetPlayerTempJob(playerid);
	new j_state = GetPlayerTempJobState(playerid);
	
	//new s_action = GetPlayerSpecialAction(playerid);
	
	switch(job)
	{
		case TEMP_JOB_LOADER:
		{
			if(j_state == TEMP_JOB_STATE_LOADER_DROP_LOAD)
			{
				SetPlayerTempJobCheckAnim(playerid, false);
				SetPlayerTempJobState(playerid, TEMP_JOB_STATE_LOADER_LOAD);
				
				RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_FOREARM);
				ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 1, 0);
				
				SetPlayerData(playerid, P_USE_ANIM_TYPE, USE_ANIM_TYPE_NONE);
				
				DisablePlayerCheckpoint(playerid);
				SetTimerEx("SetPlayerLoaderJobLoadCP", 1000, false, "i", playerid);
				
				SendClientMessage(playerid, 0xFF6600FF, "�� ������� ����");
			}
		}
		case TEMP_JOB_MINER:
		{
			if(j_state == TEMP_JOB_STATE_MINER_DROP_LOAD) // || s_action != SPECIAL_ACTION_NONE
			{
				SetPlayerTempJobCheckAnim(playerid, false);
				SetPlayerTempJobState(playerid, TEMP_JOB_STATE_MINER_LOAD);
			
				RemovePlayerAttachedObjects(playerid);
				ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 1, 0);
				
				SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 18634, A_OBJECT_BONE_RIGHT_HAND, 0.07, 0.03, 0.04, 0.0, 270.0, 270.0, 1.5, 2.1, 1.8, 0);
				
				SetPlayerData(playerid, P_USE_ANIM_TYPE, USE_ANIM_TYPE_NONE);
				SetPlayerMinerJobLoadCP(playerid);
				
				SendClientMessage(playerid, 0xFF6600FF, "�� ������� �������");
			}
		}
		case TEMP_JOB_FACTORY:
		{
			if(j_state == TEMP_JOB_STATE_FACTORY_DROP_P)
			{
				FactoryPlayerDrop(playerid, false);
			}
		}
	}
}

stock ChangePlayerName(playerid, name[], bool: non_rp_nick = false)
{
	new query[128];
	new Cache: result, rows;
	
	mysql_format(mysql, query, sizeof query, "SELECT id FROM accounts WHERE name='%e' LIMIT 1", name);
	result = mysql_query(mysql, query);
	
	rows = cache_num_rows();
	cache_delete(result);
	
	if(3 <= strlen(name) <= 20 && !rows)
	{
		mysql_format(mysql, query, sizeof query, "UPDATE accounts SET name='%e' WHERE id=%d LIMIT 1", name, GetPlayerAccountID(playerid));
		mysql_query(mysql, query, false);
		
		if(!mysql_errno())
		{
			mysql_format(mysql, query, sizeof query, "INSERT INTO change_names (owner_id,name,time,ip) VALUES (%d,'%e',%d,'%e')", GetPlayerAccountID(playerid), GetPlayerNameEx(playerid), gettime(), GetPlayerIpEx(playerid));
			mysql_query(mysql, query, false);	
			
			if(non_rp_nick)
				format(query, sizeof query, "%s ������ ���-�� ��� �� %s", GetPlayerNameEx(playerid), name);
			
			format(g_player[playerid][P_NAME], 21, "%s", name);
			SetPlayerName(playerid, GetPlayerNameEx(playerid));
			
			SendClientMessageToAll(0xCCFF00FF, query);
			UpdateCharity();
		 
			new buffer;
			if((buffer = GetPlayerFuelStation(playerid)) != -1)
			{
				format(g_fuel_station[buffer][FS_OWNER_NAME], 21, GetPlayerNameEx(playerid), 0);
				CallLocalFunction("UpdateFuelStationLabel", "i", buffer);
			}
			if((buffer = GetPlayerBusiness(playerid)) != -1)
			{
				format(g_business[buffer][B_OWNER_NAME], 21, GetPlayerNameEx(playerid), 0);
				CallLocalFunction("UpdateBusinessLabel", "i", buffer);
			}
			if((buffer = GetPlayerHouse(playerid, HOUSE_TYPE_HOME)) != -1)
			{
				format(g_house[buffer][H_OWNER_NAME], 21, GetPlayerNameEx(playerid), 0);
			}
			if((buffer = GetPlayerHouse(playerid, HOUSE_TYPE_ROOM)) != -1)
			{
				new room = GetPlayerData(playerid, P_HOUSE_ROOM);
				format(g_house_renters[buffer][room][HR_OWNER_NAME], 21, GetPlayerNameEx(playerid), 0);
			}
			if((buffer = GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL)) != -1)
			{
				new room = GetPlayerData(playerid, P_HOUSE_ROOM);
				format(g_hotel[buffer][room][H_OWNER_NAME], 21, GetPlayerNameEx(playerid), 0);
			}
			return 1;
		}
	}
	return 0;
}

stock SpeedometrLineInit(playerid)
{
	new tick = GetTickCount();
	if((tick - g_speed_line_update[playerid]) > 50)
	{
		if(IsPlayerDriver(playerid) && !IsABike(GetPlayerLastVehicle(playerid)))
		{
			new index = 0;
			new Float: speed = float(GetPlayerSpeed(playerid));
			
			if(speed > 100.0)
				speed = 100.0;
				
			speed /= 3.3;
			index = (sizeof(speedometr_line)-1) - floatround(speed, floatround_ceil);
			
			PlayerTextDrawSetString(playerid, speedometr_PTD[playerid][6], speedometr_line[index]);
		}
		g_speed_line_update[playerid] = tick;
	}
}

stock EndPlayerTempJob(playerid, job, bool:annul = false)
{
	if(GetPlayerTempJob(playerid) == job)
	{
		SetPlayerTempJobCheckAnim(playerid, false);
		
		RemovePlayerAttachedObjects(playerid);
		SetPlayerSkinInit(playerid);
		
		new items = GetPlayerJobLoadItems(playerid);
		new pay_sum = items * GetTempJobInfo(job, TJ_PAY_FOR_LOAD);

		new fmt_str[128];
		switch(job)
		{
			case TEMP_JOB_LOADER:
			{
				DisablePlayerCheckpoint(playerid);
				DisablePlayerRaceCheckpoint(playerid);
				
				TogglePlayerDynamicCP(playerid, help_info_CP, true);
				
				if(!annul)
				{
					new ts_pay = false;
					if(pay_sum > 0)
						format(fmt_str, sizeof fmt_str, ". ���������� {FFFF00}%d ���", pay_sum);
					
					strins(fmt_str, "������� ���� ��������", 0, sizeof fmt_str);
					SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			
					if(ts_pay)
					{
						format(fmt_str, sizeof fmt_str, "%d ��� {3399FF}�� ������ �� ����������", pay_sum);
						SendClientMessage(playerid, 0xFFFF00FF, fmt_str);
					}
					
					if(pay_sum > 0)
						GivePlayerMoneyEx(playerid, pay_sum, "�������� �� ������ ��������", true, false);
					
					format(fmt_str, sizeof fmt_str, "~b~~h~+%d rub", pay_sum);
					GameTextForPlayer(playerid, fmt_str, 4000, 1);
				}
				else SendClientMessage(playerid, 0xFF6600FF, "�� �������� ���������� ������. ��������� ��� �����������");
				
				items = GetPlayerVehicleID(playerid); // � items �������� �������� �� ����
				if(GetVehicleData(items, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_LOADER)
				{
					SetVehicleToRespawn(items);
				}
				ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 1, 0, USE_ANIM_TYPE_NONE);
			}
			case TEMP_JOB_MINER:
			{
				DisablePlayerCheckpoint(playerid);
				
				if(!annul)
				{
					if(items > 0)
					{
						format(fmt_str, sizeof fmt_str, "������� ���� ��������. �� ������ %d �� ����", items);
						SendClientMessage(playerid, 0x3399FFFF, fmt_str);
						
						format(fmt_str, sizeof fmt_str, "����� ���������� %d ���", pay_sum);
						SendClientMessage(playerid, 0x3399FFFF, fmt_str);
						
						GivePlayerMoneyEx(playerid, pay_sum, "�������� �� ������ �������", true, false);
					
						format(fmt_str, sizeof fmt_str, "~b~~h~+%d rub", pay_sum);
						GameTextForPlayer(playerid, fmt_str, 4000, 1);
					}
					else SendClientMessage(playerid, 0x3399FFFF, "������� ���� ��������");
				}
				else SendClientMessage(playerid, 0xFF6600FF, "�� �������� ���������� �����. ��������� ��� �����������");

				ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 1, 0, USE_ANIM_TYPE_NONE);
			}
			case TEMP_JOB_FACTORY:
			{
				pay_sum = GetPlayerJobWage(playerid);
				
				new bad_items = GetPVarInt(playerid, "factory_bad_prods");
				new skill = GetPVarInt(playerid, "factory_skill");
				new waste_sum = bad_items * (random(16) + 5);
				
				if(!annul)
				{
					SendClientMessage(playerid, 0x3399FFFF, "������� ���� ��������");
					if(pay_sum > 0 && waste_sum < pay_sum)
					{
						format(fmt_str, sizeof fmt_str, "����� ������� {FFFF00}%d {66CC00}���������, ������������ {FFFF00}%d ��.", items, bad_items) ;
						SendClientMessage(playerid, 0x66CC00FF, fmt_str);

						if(skill > 0)
						{
							format(fmt_str, sizeof fmt_str, "������� ����� ���������� {66CCFF}�� %d ������(�)", skill);
						}
						else fmt_str = "������� ����� �� ���������";
						SendClientMessage(playerid, 0x66CC00FF, fmt_str);
						
						format(fmt_str, sizeof fmt_str, "���������� {00CC00}%d ���, {FFFFFF}�� ��� {FF6600}%d ��� {FFFFFF}- ����� �� ���� ���������", pay_sum, waste_sum);
						SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

						pay_sum -= waste_sum;
						format(fmt_str, sizeof fmt_str, "~b~~h~+%d rub", pay_sum);
						GameTextForPlayer(playerid, fmt_str, 4000, 1);
						
						GivePlayerMoneyEx(playerid, pay_sum, "�������� �� ������ � ���� (�����)", true, false);
					}
				}
				else SendClientMessage(playerid, 0xFF6600FF, "�� �������� ���������� ������. ������� ���� ������������");
				
				skill = GetPlayerData(playerid, P_FACTORY_USE_DESK);
				SetPlayerFactoryDeskUse(playerid, skill, false);
			}
		}
		
		SetPlayerJobLoadItems(playerid, 0);
		SetPlayerData(playerid, P_JOB_WAGE, 0);
		SetPlayerTempJob(playerid, TEMP_JOB_NONE);
	}
}

stock TogglePlayerFactoryCP(playerid, toggle)
{
	for(new idx; idx < sizeof factory_desk; idx ++)
	{
		TogglePlayerDynamicCP(playerid, factory_desk[idx][FD_CHEK_ID], toggle);
	}
}

stock KillEndJobTimer(playerid)
{
	KillTimer(GetPlayerData(playerid, P_END_JOB_TIMER));
	SetPlayerData(playerid, P_END_JOB_TIMER, -1);
}

stock StartEndJobTimer(playerid, time = 15_000)
{
	if(GetPlayerData(playerid, P_END_JOB_TIMER) == -1)
		SetPlayerData(playerid, P_END_JOB_TIMER, SetTimerEx("EndPlayerJob", time, false, "i", playerid));
}

stock ShowPlayerBuyMetalDialog(playerid)
{
	Dialog
	(
		playerid, DIALOG_MINER_BUY_METALL, DIALOG_STYLE_INPUT,
		"{FFCD00}������� �������",
		"{FFFFFF}������� �� ������� �� ������ ������?\n"\
		"{00CC00}���� �� ��: 15 ������",
		"������", "������"
	);
}

stock SetPlayerMinerJobLoadCP(playerid)
{
	if(GetPlayerTempJob(playerid) == TEMP_JOB_MINER)
	{
		new rand = random(sizeof miner_job_load_cp);
		
		SetPlayerCheckpoint(playerid, miner_job_load_cp[rand][0], miner_job_load_cp[rand][1], miner_job_load_cp[rand][2], 2.0, CP_ACTION_TYPE_MINER_JOB_TAKE);
		SetPlayerTempJobState(playerid, TEMP_JOB_STATE_MINER_LOAD);
	}
}

stock SetPlayerMinerJobUnLoadCP(playerid)
{
	if(GetPlayerTempJob(playerid) == TEMP_JOB_MINER)
	{
		SetPlayerCheckpoint(playerid, 2712.590332, -1551.885620, 1401.908935, 2.0, CP_ACTION_TYPE_MINER_JOB_PUT);
		SetPlayerTempJobState(playerid, TEMP_JOB_STATE_MINER_UNLOAD);
	}
}

stock SetPlayerLoaderJobUnLoadCP(playerid) // ���������� �������� ��� ������ ����
{
	if(GetPlayerTempJob(playerid) == TEMP_JOB_LOADER)
	{
		new rand = random(sizeof loader_job_unload_cp);
		
		SetPlayerCheckpoint(playerid, loader_job_unload_cp[rand][0], loader_job_unload_cp[rand][1], loader_job_unload_cp[rand][2], 2.0, CP_ACTION_TYPE_LOADER_JOB_PUT);
		SetPlayerTempJobState(playerid, TEMP_JOB_STATE_LOADER_UNLOAD);
		
		SetPlayerTempJobCheckAnim(playerid, true);
	}
}

public: SetPlayerLoaderJobLoadCP(playerid) // ���������� �������� ��� ����� ����
{
	if(GetPlayerTempJob(playerid) == TEMP_JOB_LOADER)
	{
		SetPlayerTempJobCheckAnim(playerid, false);
		
		SetPlayerTempJobState(playerid, TEMP_JOB_STATE_LOADER_LOAD);
		SetPlayerCheckpoint(playerid, 528.8989, 1641.3206, 12.5027, 2.0, CP_ACTION_TYPE_LOADER_JOB_TAKE);
	}
}

stock ShowPlayerDrivingTutorial(playerid)
{
	Dialog
	(
		playerid, DIALOG_DRIVING_TUTORIAL_START, DIALOG_STYLE_MSGBOX,
		"{0099FF}��������",
		"{FFFFFF}��� ������� ������� ��� ������ �������������\n"\
		"� �������� �� ��������\n\n"\
		"{CC9900}��� ����, ����� ������ �������� ������� \"�����\"",
		"�����", "������"
	);
	return 1;
}

stock ShowDrivingTutorialSection(playerid, step)
{
	if(0 <= step <= sizeof driving_tutorial-1)
	{
		Dialog
		(
			playerid, DIALOG_DRIVING_TUTORIAL, DIALOG_STYLE_MSGBOX,
			driving_tutorial[step][DT_TITLE],
			driving_tutorial[step][DT_INFO],
			"�����", "�����"
		);
		SetPVarInt(playerid, "driving_tutorial_step", step);
	}
}

stock ShowPlayerDrivingExam(playerid, step)
{
	if(0 <= step <= sizeof driving_exam - 1)
	{
		Dialog
		(
			playerid, DIALOG_DRIVING_EXAM, DIALOG_STYLE_LIST,
			driving_exam[step][DE_TITLE],
			driving_exam[step][DE_LIST_ITEMS],
			"��������", ""
		);
		SetPlayerDrivingExamInfo(playerid, DE_EXAM_STEP, step);	
	}
	else if(step >= sizeof driving_exam)
	{
		new points = GetPlayerDrivingExamInfo(playerid, DE_POINTS);
		SetPlayerDrivingExamInfo(playerid, DE_EXAM_STEP, 0);
		SetPlayerDrivingExamInfo(playerid, DE_ROUTE_STEP, 0);
		
		if(points >= 9)
			SetPlayerData(playerid, P_DRIVING_LIC, 1);
		
		new fmt_str[256];
		format(fmt_str, sizeof fmt_str, "{FFFFFF}���������� ���������� �������: {66CC00}%d\n\n", points);
		
		if(points == 9)
		{
			strcat
			(
				fmt_str, 
				"{6699FF}�����������!\n"\
				"�� ������� ����������� ���������� ������, ����� ���������� �� ������ ����� ��������!"
			);
		}
		else if(points >= 10)
		{
			static const 
				medal_name[3][12] = {"���������", "�����������", "�������"};
				
			format(fmt_str, sizeof fmt_str, "%s{6699FF}�����������!\n�� ��������� %s ������ �� ������������� ����� ��������!", fmt_str, medal_name[points - 10]);
		}
		else
		{
			ClearPlayerDrivingExamInfo(playerid);
			strcat
			(
				fmt_str, 
				"{FF6600}� ��������� �� �� ������� ������������ ���������� ������\n"\
				"� ��������� ��� ����������� ���������� ��������� ������\n"\
				"���� ��� �� ���������!"
			);
		}
		
		Dialog
		(
			playerid, DIALOG_DRIVING_EXAM_RESULT, DIALOG_STYLE_MSGBOX,
			"{FFFF00}���������� ������������� �����", 
			fmt_str,
			"��", ""
		);	
	}
	return 1;
}

stock NextDrivingExamRouteCP(playerid)
{
	new step = GetPlayerDrivingExamInfo(playerid, DE_ROUTE_STEP);
	
	SetPlayerRaceCheckpoint
	(
		playerid,
		0,
		driving_exam_route[step][0],
		driving_exam_route[step][1],
		driving_exam_route[step][2],
		driving_exam_route[step + 1][0],
		driving_exam_route[step + 1][1],
		driving_exam_route[step + 1][2],
		4.0,
		RCP_ACTION_TYPE_DRIVING_EXAM
	);
	SetPlayerDrivingExamInfo(playerid, DE_ROUTE_STEP, step + 1);
}

stock GetPlayerSpeed(playerid)
{
	new Float: x, Float: y, Float: z;
	if(IsPlayerInAnyVehicle(playerid))
	{
		GetVehicleVelocity(GetPlayerVehicleID(playerid), x, y, z);
	}
	else GetPlayerVelocity(playerid, x, y, z);
	
	return floatround(floatsqroot(x*x+y*y+z*z)*100);
}

stock IsPlayerDriver(playerid) // ����� �� ����� �� ����� ��
{
	return (IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER);
}

stock IsPlayerPassenger(playerid) // ����� �� ����� ��� ��������
{
	return (IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_PASSENGER);
}

stock SpeedometrShowForPlayer(playerid, vehicleid = INVALID_VEHICLE_ID)
{
	TextDrawShowForPlayer(playerid, speedometr_TD[0]);
	TextDrawShowForPlayer(playerid, speedometr_TD[1]);
	
	SpeedometrKeyStatusInit(playerid, vehicleid);
	
	for(new idx; idx < sizeof speedometr_PTD[]; idx ++)
		PlayerTextDrawShow(playerid, speedometr_PTD[playerid][idx]);
}

stock SpeedometrHideForPlayer(playerid)
{
	for(new idx; idx < sizeof speedometr_PTD[]; idx ++)
		PlayerTextDrawHide(playerid, speedometr_PTD[playerid][idx]);
	
	TextDrawHideForPlayer(playerid, speedometr_TD[0]);
	TextDrawHideForPlayer(playerid, speedometr_TD[1]);
}

stock CreateSpeedometrForPlayer(playerid)
{
	speedometr_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 451.200164, 366.613281, "0_~b~~h~~h~~h~:km/h");
	PlayerTextDrawLetterSize(playerid, speedometr_PTD[playerid][0], 0.354799, 1.764266);
	PlayerTextDrawAlignment(playerid, speedometr_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, speedometr_PTD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, speedometr_PTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, speedometr_PTD[playerid][0], 1);
	PlayerTextDrawBackgroundColor(playerid, speedometr_PTD[playerid][0], 51);
	PlayerTextDrawFont(playerid, speedometr_PTD[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid, speedometr_PTD[playerid][0], 1);

	speedometr_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 522.5, 366.613281, "0000000");
	PlayerTextDrawLetterSize(playerid, speedometr_PTD[playerid][1], 0.273346, 1.764266);
	PlayerTextDrawAlignment(playerid, speedometr_PTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, speedometr_PTD[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, speedometr_PTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, speedometr_PTD[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, speedometr_PTD[playerid][1], 51);
	PlayerTextDrawFont(playerid, speedometr_PTD[playerid][1], 2);

	speedometr_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 450.400085, 394.986785, "Fuel:_~y~50~n~~w~limit:_~r~off");
	PlayerTextDrawLetterSize(playerid, speedometr_PTD[playerid][2], 0.313199, 1.663698);
	PlayerTextDrawAlignment(playerid, speedometr_PTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, speedometr_PTD[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, speedometr_PTD[playerid][2], 1);
	PlayerTextDrawSetOutline(playerid, speedometr_PTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, speedometr_PTD[playerid][2], 59);
	PlayerTextDrawFont(playerid, speedometr_PTD[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, speedometr_PTD[playerid][2], 1);

	speedometr_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 517.5, 393.653259, "E__L__B");
	PlayerTextDrawLetterSize(playerid, speedometr_PTD[playerid][3], 0.437357, 2.124531);
	PlayerTextDrawAlignment(playerid, speedometr_PTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, speedometr_PTD[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, speedometr_PTD[playerid][3], 1);
	PlayerTextDrawSetOutline(playerid, speedometr_PTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, speedometr_PTD[playerid][3], 59);
	PlayerTextDrawFont(playerid, speedometr_PTD[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, speedometr_PTD[playerid][3], 1);

	speedometr_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 543.068115, 410.499603, "~r~close");
	PlayerTextDrawLetterSize(playerid, speedometr_PTD[playerid][4], 0.309199, 1.659733);
	PlayerTextDrawAlignment(playerid, speedometr_PTD[playerid][4], 2);
	PlayerTextDrawColor(playerid, speedometr_PTD[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, speedometr_PTD[playerid][4], 1);
	PlayerTextDrawSetOutline(playerid, speedometr_PTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, speedometr_PTD[playerid][4], 51);
	PlayerTextDrawFont(playerid, speedometr_PTD[playerid][4], 2);
	PlayerTextDrawSetProportional(playerid, speedometr_PTD[playerid][4], 1);

	speedometr_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 567.199645, 387.427215, "~y~.");
	PlayerTextDrawLetterSize(playerid, speedometr_PTD[playerid][5], 1.000398, 4.579195);
	PlayerTextDrawAlignment(playerid, speedometr_PTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, speedometr_PTD[playerid][5], 0xCECECEFF);
	PlayerTextDrawSetShadow(playerid, speedometr_PTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, speedometr_PTD[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, speedometr_PTD[playerid][5], 51);
	PlayerTextDrawFont(playerid, speedometr_PTD[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, speedometr_PTD[playerid][5], 1);
	
	speedometr_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 450.400115, 378.560241, "_");
	PlayerTextDrawLetterSize(playerid, speedometr_PTD[playerid][6], 0.463600, 2.100265);
	PlayerTextDrawAlignment(playerid, speedometr_PTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, speedometr_PTD[playerid][6], 0xFF9933AA);
	PlayerTextDrawSetShadow(playerid, speedometr_PTD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, speedometr_PTD[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, speedometr_PTD[playerid][6], 51);
	PlayerTextDrawFont(playerid, speedometr_PTD[playerid][6], 2);
	PlayerTextDrawSetProportional(playerid, speedometr_PTD[playerid][6], 1);
}

stock SendMessageInChat(playerid, text[], Float: radius = 30.0)
{
	new Float: dist, type;
	new Float: x, Float: y, Float: z;
	
	GetPlayerPos(playerid, x, y, z);
	SetPlayerChatBubble(playerid, text, 0x00CCFFFF, 30.0, 8000);

	ChatMessageInit(playerid, text);
	foreach(new idx : Player)
	{
		if(!IsPlayerLogged(idx)) continue;
		dist = GetPlayerDistanceFromPoint(idx, x, y, z);
		
		if(dist > radius) continue;
		type = GetPlayerChatType(idx);
		
		switch(GetPlayerSettingData(idx, S_CHAT_TYPE))
		{
			case SETTING_CHAT_ADVANCE:
			{
				if(dist < (radius / 4))
				{		
					SendClientMessage(idx, 0xCECECEFF, chat_message[type]); 
				}	
				else if(dist < (radius / 2))
				{
					SendClientMessage(idx, 0x999999FF, chat_message[type]); 
				}
				else
				{
					SendClientMessage(idx, 0x6B6B6BFF, chat_message[type]);
				}
			}
			case SETTING_CHAT_STANDART:
			{
				if(GetPlayerSettingData(idx, S_NICK_IN_CHAT))
				{
					SendPlayerMessageToPlayer(idx, playerid, chat_message[type]);
				}
				else SendClientMessage(idx, 0xCECECEFF, text);
			}
			default: continue;
		}
	}
	if(!IsPlayerDriver(playerid))
	{
		if(GetPlayerData(playerid, P_USE_ANIM_TYPE) == USE_ANIM_TYPE_NONE)
		{
			ApplyAnimationEx(playerid, "PED", "IDLE_chat", 4.100, 0, 1, 1, 1, 1, 0, USE_ANIM_TYPE_CHAT);
			SetTimerEx("ClearPlayerChatAnim", 3500, false, "i", playerid);
		}
	}
	return 1;
}

stock ChatMessageInit(playerid, text[])
{
	format(chat_message[0], 129, "- %s {%06x}(%s)[%d]", text, GetPlayerColorEx(playerid) >>> 8, GetPlayerNameEx(playerid), playerid);
	format(chat_message[1], 129, "- %s {%06x}(%s)", text, GetPlayerColorEx(playerid) >>> 8, GetPlayerNameEx(playerid));
	format(chat_message[2], 129, "- %s", text);
	
	format(chat_message[3], 129, "(%d): %s", playerid, text);
	format(chat_message[4], 129, "%s", text);
}

stock SetPlayerChatInit(playerid)
{
	new type = 0;
	switch(GetPlayerSettingData(playerid, S_CHAT_TYPE))
	{
		case SETTING_CHAT_ADVANCE:
		{
			if(GetPlayerSettingData(playerid, S_NICK_IN_CHAT) == SETTING_TYPE_ON)
			{
				if(GetPlayerSettingData(playerid, S_ID_IN_CHAT) == SETTING_TYPE_ON)
				{
					type = 0;
				}
				else type = 1;
			}
			else type = 2;
		}
		case SETTING_CHAT_STANDART:
		{
			if(GetPlayerSettingData(playerid, S_ID_IN_CHAT) == SETTING_TYPE_ON)
			{
				type = 3;
			}
			else type = 4;
		}
		default: type = 0;
	}
	SetPlayerChatType(playerid, type);
}

stock SetPlayerSpawnInit(playerid)
{
	new spawn_id;
	if(GetPlayerLevel(playerid) >= 10)
	{
		spawn_id = 3;
	}
	else if(GetPlayerLevel(playerid) >= 5)
	{
		spawn_id = 2;
	}
	else if(GetPlayerLevel(playerid) >= 3)
	{
		spawn_id = 1;
	}
	else spawn_id = 0;

	SetSpawnInfo
	(
		playerid, 
		0,
		GetPlayerSkinEx(playerid),
		spawn_pos_data[spawn_id][0] + random(3),
		spawn_pos_data[spawn_id][1] + random(3), 
		spawn_pos_data[spawn_id][2],
		spawn_pos_data[spawn_id][3],
		0, 0, 0, 0, 0, 0
	);
	return 1;
}

stock SetPlayerInit(playerid)
{
	SetPlayerLevelInit(playerid);
	SetPlayerColorInit(playerid);
	SetPlayerSuspectInit(playerid);
	SetPlayerSkinInit(playerid);
	SetPlayerChatInit(playerid);
	SetPlayerMoneyInit(playerid);

	CreateTeleportObjects(playerid);
	CreateSpeedometrForPlayer(playerid);
	
	SetPlayerLogged(playerid, true);
}

stock PreLoadPlayerAnims(playerid)
{
	for(new idx; idx < sizeof g_anim_libs; idx ++)
	{
		PreloadAnimLib(playerid, g_anim_libs[idx]);
	}
}

stock PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid, animlib, "null", 0.0, 0, 0, 0, 0, 0, 0);
}

stock SetPlayerMoneyInit(playerid)
{
	ResetPlayerMoney(playerid);
	return GivePlayerMoney(playerid, GetPlayerMoneyEx(playerid));
}

stock SetPlayerColorInit(playerid)
{
	return SetPlayerColorEx(playerid, GetPlayerTeamColor(playerid));
}

stock SetPlayerColorEx(playerid, color)
{
	SetPlayerData(playerid, P_COLOR, color);
	return SetPlayerColor(playerid, color);
}

stock SetPlayerHealthEx(playerid, Float: health, bool: inc_health = false)
{
	if(inc_health)
	{
		AddPlayerData(playerid, P_HEALTH, +, health);
	}
	else SetPlayerData(playerid, P_HEALTH, health);
	
	if(GetPlayerData(playerid, P_HEALTH) > 100.0)
		SetPlayerData(playerid, P_HEALTH, 100.0);
	
	return SetPlayerHealth(playerid, GetPlayerData(playerid, P_HEALTH));
}

stock GetPlayerHealthEx(playerid)
{
	return GetPlayerData(playerid, P_HEALTH);
}

stock GetPlayerTeamColor(playerid)
{
	#pragma unused playerid

	return team_colors[0];
}

stock SetPlayerSuspectInit(playerid)
{
	return SetPlayerWantedLevel(playerid, GetPlayerSuspect(playerid));
}

stock SetPlayerSkinInit(playerid)
{
	return SetPlayerSkin(playerid, GetPlayerSkinEx(playerid));
}

stock SetPlayerLevelInit(playerid)
{
	return SetPlayerScore(playerid, GetPlayerLevel(playerid));
}

stock SetPlayerSelectSkin(playerid, select_skin, skinid)
{
	SetPlayerData(playerid, P_SELECT_SKIN, select_skin);
	SetPlayerSkin(playerid, skinid);
}

stock SetPlayerPosEx(playerid, Float: x, Float: y, Float: z, Float: angle, interior = -1, virtual_world = -1)
{
	if(interior > 0)
		PlayerTeleportInit(playerid, x, y,  z, angle);

	SetPlayerPos(playerid, x, y, z);
	SetPlayerFacingAngle(playerid, angle);
	SetCameraBehindPlayer(playerid);
	
	if(interior != -1 && GetPlayerInterior(playerid) != interior)
	{
		SetPlayerInterior(playerid, interior);
	}
	if(virtual_world != -1 && GetPlayerVirtualWorld(playerid) != virtual_world)
	{
		SetPlayerVirtualWorld(playerid, virtual_world);
	}
	return 1;
}

stock PlayerKick(playerid, message[] = "������� /q (/quit) ����� �����", time_ms = 500)
{
	if(strlen(message) > 1)
		SendClientMessage(playerid, 0xFF6600FF, message);
	
	SetTimerEx("OnPlayerDelayKick", time_ms, false, "i", playerid);
	
	return 1;
}

public: OnPlayerDelayKick(playerid)
{
	return Kick(playerid);
}

stock ClearPlayerInfo(playerid)
{
	g_player[playerid] = g_player_default_values;
	g_player_gps[playerid] = g_gps_default_values;
	g_player_setting[playerid] = g_settings_default_values;
	g_player_driving_exam[playerid] = g_driving_exam_default_values;
	
	g_pickup_flood[playerid] = 0;
	g_speed_line_update[playerid] = -1;
	g_teleport_object[playerid] = {-1, -1};
	
	price_select_TD[playerid] = PlayerText:{-1, -1}; 
	
	SetPlayerPhoneBookInitStatus(playerid, false);
	SetPlayerPhoneBookContacts(playerid, 0);

	ClearPlayerOffer(playerid);
	ClearPlayerListitemValues(playerid);
	ClearPlayerPhoneCall(playerid);
	
	AntiFloodPlayerInit(playerid);
	// ClearBankAccountsData(playerid);
	
	DestroyTeleportObjects(playerid);
	
	#if defined _SYSTEM_CP
	ClearPlayerCPInfo(playerid);
	#endif
	
	#if defined _SYSTEM_RACE_CP
	ClearPlayerRCPInfo(playerid);
	#endif
	
	SetPlayerPinCodeState(playerid, PIN_CODE_STATE_NONE);
	
	mysql_race[playerid] ++;
}

stock CreatePlayerAccount(playerid)
{
	new query[256];
	new Cache: result;
	
	new time = gettime();
	
	SetPlayerData(playerid, P_REG_TIME, time);
	SetPlayerData(playerid, P_LAST_LOGIN_TIME, time);
	
	format(g_player[playerid][P_REG_IP], 16, "%s", GetPlayerIpEx(playerid));
	format(g_player[playerid][P_LAST_IP], 16, "%s", GetPlayerIpEx(playerid));
	
	mysql_format
	(
		mysql, query, sizeof query,
		"INSERT INTO accounts "\
			"(name,password,email,refer,sex,reg_time,reg_ip,last_ip,last_login) "\
			"VALUES "\
			"('%e','%e','%e',%d,%d,%d,'%e','%e',%d)",
		GetPlayerNameEx(playerid),
		GetPlayerData(playerid, P_PASSWORD),
		GetPlayerData(playerid, P_EMAIL),
		GetPlayerData(playerid, P_REFER),
		GetPlayerData(playerid, P_SEX),
		GetPlayerData(playerid, P_REG_TIME),
		GetPlayerData(playerid, P_REG_IP),
		GetPlayerData(playerid, P_LAST_IP),
		GetPlayerData(playerid, P_LAST_LOGIN_TIME)
	);
	result = mysql_query(mysql, query);
	
	SetPlayerData(playerid, P_ACCOUNT_ID, cache_insert_id());
	cache_delete(result);
	
	return GetPlayerAccountID(playerid);
}

stock CreateTextDraws()
{
	server_logo_TD = TextDrawCreate(554.0, 3.0, "RADMIR ROLEPLAY");
	TextDrawLetterSize(server_logo_TD, 0.44, 1.6);
	TextDrawAlignment(server_logo_TD, 2);
	TextDrawColor(server_logo_TD, -1);
	TextDrawSetShadow(server_logo_TD, 0);
	TextDrawSetOutline(server_logo_TD, -1);
	TextDrawBackgroundColor(server_logo_TD, 51);
	TextDrawFont(server_logo_TD, 1);
	TextDrawSetProportional(server_logo_TD, 1);
	
	
	gps_TD = TextDrawCreate(70.000, 320.000, "GPS_On");
	TextDrawLetterSize(gps_TD, 0.300, 1.300);
	TextDrawAlignment(gps_TD, 1);
	TextDrawBackgroundColor(gps_TD, 0x000000FF);
	TextDrawColor(gps_TD, 0x66CC00FF);
	TextDrawFont(gps_TD, 1);
	TextDrawSetOutline(gps_TD, 1);
	TextDrawSetProportional(gps_TD, 1);
	TextDrawSetShadow(gps_TD, 2);

	anim_TD = TextDrawCreate(630.000, 430.000, "~k~~PED_SPRINT~_~w~to_stop_the_animation");
	TextDrawLetterSize(anim_TD, 0.300, 1.100);
	TextDrawAlignment(anim_TD, 3);
	TextDrawBackgroundColor(anim_TD, 0x000000FF);
	TextDrawColor(anim_TD, 0x00CC00FF);
	TextDrawFont(anim_TD, 2);
	TextDrawSetOutline(anim_TD, 1);
	TextDrawSetProportional(anim_TD, 1);
	TextDrawSetShadow(anim_TD, 2);

	
	speedometr_TD[0] = TextDrawCreate(580.399902, 368.113159, "_");
	TextDrawLetterSize(speedometr_TD[0], 0.000000, 6.320374);
	TextDrawTextSize(speedometr_TD[0], 445.474060, 0.000000);
	TextDrawAlignment(speedometr_TD[0], 1);
	TextDrawColor(speedometr_TD[0], -1);
	TextDrawUseBox(speedometr_TD[0], true);
	TextDrawBoxColor(speedometr_TD[0], 132);
	TextDrawSetShadow(speedometr_TD[0], 0);
	TextDrawSetOutline(speedometr_TD[0], -55);
	TextDrawFont(speedometr_TD[0], 0);

	speedometr_TD[1] = TextDrawCreate(450.400115, 378.560241, "IIIIIIIIIIIIIIIIIIIIIIIIIIIIII");
	TextDrawLetterSize(speedometr_TD[1], 0.463600, 2.100265);
	TextDrawAlignment(speedometr_TD[1], 1);
	TextDrawColor(speedometr_TD[1], -2139062017);
	TextDrawSetShadow(speedometr_TD[1], 0);
	TextDrawSetOutline(speedometr_TD[1], 0);
	TextDrawBackgroundColor(speedometr_TD[1], 51);
	TextDrawFont(speedometr_TD[1], 2);
	TextDrawSetProportional(speedometr_TD[1], 1);

	wait_panel_TD[0] = TextDrawCreate(405.000000, 182.333358, "usebox");
	TextDrawLetterSize(wait_panel_TD[0], 0.000000, 8.433333);
	TextDrawTextSize(wait_panel_TD[0], 236.000000, 0.000000);
	TextDrawAlignment(wait_panel_TD[0], 1);
	TextDrawColor(wait_panel_TD[0], 0);
	TextDrawUseBox(wait_panel_TD[0], true);
	TextDrawBoxColor(wait_panel_TD[0], 102);
	TextDrawSetShadow(wait_panel_TD[0], 0);
	TextDrawSetOutline(wait_panel_TD[0], 0);
	TextDrawFont(wait_panel_TD[0], 0);

	wait_panel_TD[1] = TextDrawCreate(251.500000, 186.666549, "Please wait...");
	TextDrawLetterSize(wait_panel_TD[1], 0.792499, 2.270833);
	TextDrawAlignment(wait_panel_TD[1], 1);
	TextDrawColor(wait_panel_TD[1], -1);
	TextDrawSetShadow(wait_panel_TD[1], 0);
	TextDrawSetOutline(wait_panel_TD[1], 1);
	TextDrawBackgroundColor(wait_panel_TD[1], 51);
	TextDrawFont(wait_panel_TD[1], 0);
	TextDrawSetProportional(wait_panel_TD[1], 1);
	
	wait_panel_TD[2] = TextDrawCreate(320.000000, 239.749984, "radmir roleplay~n~RM-RP.RU");
	TextDrawLetterSize(wait_panel_TD[2], 0.150500, 0.905833);
	TextDrawAlignment(wait_panel_TD[2], 2);
	TextDrawColor(wait_panel_TD[2], -1);
	TextDrawSetShadow(wait_panel_TD[2], 0);
	TextDrawSetOutline(wait_panel_TD[2], 1);
	TextDrawBackgroundColor(wait_panel_TD[2], 51);
	TextDrawFont(wait_panel_TD[2], 2);
	TextDrawSetProportional(wait_panel_TD[2], 1);	
	
	wait_panel_TD[3] = TextDrawCreate(305.0, 205.0, "ld_grav:timer");
	TextDrawLetterSize(wait_panel_TD[3], 0.0, 0.0);
	TextDrawTextSize(wait_panel_TD[3], 30.0, 30.0);
	TextDrawAlignment(wait_panel_TD[3], 1);
	TextDrawColor(wait_panel_TD[3], -1);
	TextDrawSetShadow(wait_panel_TD[3], 0);
	TextDrawSetOutline(wait_panel_TD[3], 0);
	TextDrawBackgroundColor(wait_panel_TD[3], 0x0);
	TextDrawFont(wait_panel_TD[3], 4);
	
	
	select_TD[0] = TextDrawCreate(227.000, 386.000, "Select-BOX");
	TextDrawLetterSize(select_TD[0], 0.500, 2.000);
	TextDrawTextSize(select_TD[0], 315.000, 20.000);
	TextDrawAlignment(select_TD[0], 1);
	TextDrawBoxColor(select_TD[0], 0x32CD3270);
	TextDrawColor(select_TD[0], 0xFFFFFFFF);
	TextDrawFont(select_TD[0], 5);
	TextDrawSetOutline(select_TD[0], 0);
	TextDrawSetProportional(select_TD[0], 1);
	TextDrawSetShadow(select_TD[0], 1);
	TextDrawUseBox(select_TD[0], 1);
	TextDrawSetSelectable(select_TD[0], true);

	select_TD[1] = TextDrawCreate(415.000, 386.700, "right");
	TextDrawLetterSize(select_TD[1], 0.500, 1.800);
	TextDrawTextSize(select_TD[1], 435.000, 18.000);
	TextDrawAlignment(select_TD[1], 1);
	TextDrawBoxColor(select_TD[1], 0x00000060);
	TextDrawColor(select_TD[1], 0xFFFFFFFF);
	TextDrawFont(select_TD[1], 5);
	TextDrawSetOutline(select_TD[1], 0);
	TextDrawSetProportional(select_TD[1], 1);
	TextDrawSetShadow(select_TD[1], 1);
	TextDrawUseBox(select_TD[1], 1);
	TextDrawSetSelectable(select_TD[1], true);

	select_TD[2] = TextDrawCreate(200.000, 386.700, "left");
	TextDrawLetterSize(select_TD[2], 0.500, 1.800);
	TextDrawTextSize(select_TD[2], 220.000, 18.000);
	TextDrawAlignment(select_TD[2], 1);
	TextDrawBoxColor(select_TD[2], 0x00000060);
	TextDrawColor(select_TD[2], 0xFFFFFFFF);
	TextDrawFont(select_TD[2], 5);
	TextDrawSetOutline(select_TD[2], 0);
	TextDrawSetProportional(select_TD[2], 1);
	TextDrawSetShadow(select_TD[2], 1);
	TextDrawUseBox(select_TD[2], 1);
	TextDrawSetSelectable(select_TD[2], true);

	select_TD[3] = TextDrawCreate(321.000, 386.000, "Close-BOX");
	TextDrawLetterSize(select_TD[3], 0.500, 2.000);
	TextDrawTextSize(select_TD[3], 409.000, 20.000);
	TextDrawAlignment(select_TD[3], 1);
	TextDrawBoxColor(select_TD[3], 0xEE2C2C70);
	TextDrawFont(select_TD[3], 5);
	TextDrawSetOutline(select_TD[3], 0);
	TextDrawSetProportional(select_TD[3], 1);
	TextDrawSetShadow(select_TD[3], 1);
	TextDrawUseBox(select_TD[3], 1);
	TextDrawSetSelectable(select_TD[3], true);
	
	select_TD[4] = TextDrawCreate(246.000, 392.000, "Select");
	TextDrawLetterSize(select_TD[4], 0.320, 0.800);
	TextDrawAlignment(select_TD[4], 1);
	TextDrawBackgroundColor(select_TD[4], 0xFF000000); // FF000000
	TextDrawColor(select_TD[4], 0xFFFFFFFF); // FFFFFFFF
	TextDrawFont(select_TD[4], 2);
	TextDrawSetOutline(select_TD[4], 0);
	TextDrawSetProportional(select_TD[4], 1);
	TextDrawSetShadow(select_TD[4], 0);
	TextDrawUseBox(select_TD[4], 0);

	select_TD[5] = TextDrawCreate(421.000, 390.000, ">");
	TextDrawLetterSize(select_TD[5], 0.320, 1.300);
	TextDrawAlignment(select_TD[5], 1);
	TextDrawBackgroundColor(select_TD[5], 0xFF000000); // FF000000
	TextDrawColor(select_TD[5], 0xFFFFFFFF); // FFFFFFFF
	TextDrawFont(select_TD[5], 2);
	TextDrawSetOutline(select_TD[5], 0);
	TextDrawSetProportional(select_TD[5], 1);
	TextDrawSetShadow(select_TD[5], 0);

	select_TD[6] = TextDrawCreate(205.000, 390.000, "<");
	TextDrawLetterSize(select_TD[6], 0.320, 1.300);
	TextDrawAlignment(select_TD[6], 1);
	TextDrawBackgroundColor(select_TD[6], 0xFF000000);
	TextDrawColor(select_TD[6], 0xFFFFFFFF);
	TextDrawFont(select_TD[6], 2);
	TextDrawSetOutline(select_TD[6], 0);
	TextDrawSetProportional(select_TD[6], 1);
	TextDrawSetShadow(select_TD[6], 0);

	select_TD[7] = TextDrawCreate(345.000, 392.000, "Close");
	TextDrawLetterSize(select_TD[7], 0.320, 0.800);
	TextDrawAlignment(select_TD[7], 1);
	TextDrawBackgroundColor(select_TD[7], 0xFF000000);
	TextDrawColor(select_TD[7], 0xFFFFFFFF); 
	TextDrawFont(select_TD[7], 2);
	TextDrawSetOutline(select_TD[7], 0);
	TextDrawSetProportional(select_TD[7], 1);
	TextDrawSetShadow(select_TD[7], 0);
	
	print("[TextDraw]: ��� ���������� �������");
}

stock CreateMenus()
{
	/*
	reg_select_skin_menu = CreateMenu("Skin", 1, 150.0, 250.0, 60.0, 60.0);
	AddMenuItem(reg_select_skin_menu, 0, "Next >>");
    AddMenuItem(reg_select_skin_menu, 0, "<< Prev");
    AddMenuItem(reg_select_skin_menu, 0, "OK");
	*/
	print("[Menu]: ��� ���� �������");
}

stock CreateVehicles()
{
	new spawn_time = 60 * 5; // 5 �����
	
	// --------------- ��������
	AddStaticVehicleEx(418,758.8998,723.5314,12.2439,248.7655,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_BUS_DRIVER); // ��������� 1
	AddStaticVehicleEx(418,757.3745,719.7014,12.1885,249.3062,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_BUS_DRIVER); // ��������� 2
	AddStaticVehicleEx(418,755.6907,715.4114,12.1333,248.9229,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_BUS_DRIVER); // ��������� 3
	AddStaticVehicleEx(418,754.1324,711.1880,12.0992,249.3299,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_BUS_DRIVER); // ��������� 4
	AddStaticVehicleEx(418,752.6511,707.2150,12.0903,248.8002,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_BUS_DRIVER); // ��������� 5
	AddStaticVehicleEx(418,750.8207,702.5714,12.0930,248.1884,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_BUS_DRIVER); // ��������� 6
	AddStaticVehicleEx(418,749.1871,698.3358,12.0932,249.0095,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_BUS_DRIVER); // ��������� 7
	AddStaticVehicleEx(418,747.5515,694.0026,12.0930,249.3973,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_BUS_DRIVER); // ��������� 8
	AddStaticVehicleEx(418,745.9255,689.8022,12.0931,249.8988,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_BUS_DRIVER); // ��������� 9
	AddStaticVehicleEx(418,744.3026,685.6509,12.0931,249.3905,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_BUS_DRIVER); // ��������� 10
	AddStaticVehicleEx(418,742.6512,681.3754,12.0930,249.4450,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_BUS_DRIVER); // ��������� 11
	AddStaticVehicleEx(418,741.0107,677.0425,12.0931,249.4603,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_BUS_DRIVER); // ��������� 12
	AddStaticVehicleEx(418,739.3386,672.7777,12.0929,249.4026,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_BUS_DRIVER); // ��������� 13
	AddStaticVehicleEx(418,737.7796,668.5155,12.0930,249.2589,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_BUS_DRIVER); // ��������� 14
	AddStaticVehicleEx(418,736.0520,663.8519,12.0930,250.1295,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_BUS_DRIVER); // ��������� 15
	AddStaticVehicleEx(418,734.3118,659.4240,12.0928,249.0372,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_BUS_DRIVER); // ��������� 16
	AddStaticVehicleEx(418,732.4960,654.7409,12.0930,249.3797,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_BUS_DRIVER); // ��������� 17
	AddStaticVehicleEx(418,730.8508,650.4247,12.0930,249.0664,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_BUS_DRIVER); // ��������� 18
	AddStaticVehicleEx(418,729.2156,645.9833,12.0930,249.3153,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_BUS_DRIVER); // ��������� 19
	AddStaticVehicleEx(418,727.4211,641.1423,12.0930,249.6270,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_BUS_DRIVER); // ��������� 20
	
	// --------------- �����
	AddStaticVehicleEx(438,501.6323,1757.9569,11.8938,176.2031,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // �/� ������, ����� 1
	AddStaticVehicleEx(438,505.0952,1757.6876,11.8931,175.8430,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // �/� ������, ����� 2
	AddStaticVehicleEx(420,508.3364,1757.6006,11.8818,175.8649,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // �/� ������, ����� 3
	AddStaticVehicleEx(420,511.7741,1757.2988,11.8811,176.4038,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // �/� ������, ����� 4
	AddStaticVehicleEx(420,515.0672,1757.0718,11.8793,175.5950,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // �/� ������, ����� 5
	AddStaticVehicleEx(420,518.3334,1756.8132,11.8793,175.4676,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // �/� ������, ����� 6
	AddStaticVehicleEx(420,521.7852,1756.5070,11.8793,175.7498,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // �/� ������, ����� 7

	AddStaticVehicleEx(438,1872.5802,2260.5298,15.1562,90.4024,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // ���������, ����� 1
	AddStaticVehicleEx(438,1872.5099,2264.3132,15.1572,90.1363,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // ���������, ����� 2
	AddStaticVehicleEx(420,1872.5029,2267.6094,15.1456,90.0060,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // ���������, ����� 3
	AddStaticVehicleEx(420,1872.4307,2270.8154,15.1490,90.4211,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // ���������, ����� 4
	AddStaticVehicleEx(420,1872.4064,2273.9580,15.1511,90.3450,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // ���������, ����� 5

	AddStaticVehicleEx(438,-2490.6890,2846.5657,37.5173,89.6803,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // �����, ����� 1
	AddStaticVehicleEx(438,-2490.6812,2842.3467,37.5189,89.4857,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // �����, ����� 2
	AddStaticVehicleEx(420,-2490.6860,2838.0046,37.5068,90.3039,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // �����, ����� 3
	AddStaticVehicleEx(420,-2490.7419,2833.7920,37.5068,90.2202,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // �����, ����� 4
	AddStaticVehicleEx(420,-2490.8013,2829.9333,37.5071,89.7149,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // �����, ����� 5

	AddStaticVehicleEx(420,-245.0356,453.3494,12.7324,73.8823,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // ��������, ����� 1
	AddStaticVehicleEx(420,-246.2037,449.3405,12.7325,74.0256,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // ��������, ����� 2
	AddStaticVehicleEx(420,-247.3436,445.4543,12.7325,73.9557,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // ��������, ����� 3
	AddStaticVehicleEx(438,-248.5921,441.2789,12.7437,73.4070,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // ��������, ����� 4
	AddStaticVehicleEx(438,-249.6691,437.3716,12.7437,73.7906,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // ��������, ����� 5

	AddStaticVehicleEx(420,-2399.8335,197.4634,21.0467,258.4910,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // ���������, ����� 1
	AddStaticVehicleEx(420,-2400.6265,193.7770,21.0451,258.1457,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // ���������, ����� 2
	AddStaticVehicleEx(420,-2401.4087,189.9429,21.0426,258.7071,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // ���������, ����� 3
	AddStaticVehicleEx(438,-2402.0530,186.2944,21.0539,259.4415,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // ���������, ����� 4
	AddStaticVehicleEx(438,-2402.9199,182.1572,21.0538,259.6259,6,1, spawn_time, 0, VEHICLE_ACTION_TYPE_TAXI_DRIVER); // ���������, ����� 5
	
	// --------------- ���������� ����
	CreateVehicle(609,-210.8739,234.8200,12.2369,359.4061,7,7, spawn_time, 0, VEHICLE_ACTION_TYPE_TRUCKER); // 
	CreateVehicle(609,-218.8448,234.7702,12.2403,0.090900,7,7, spawn_time, 0, VEHICLE_ACTION_TYPE_TRUCKER); // 
	CreateVehicle(609,-226.0548,234.6511,12.2406,0.548500,7,7, spawn_time, 0, VEHICLE_ACTION_TYPE_TRUCKER); // 
	CreateVehicle(609,-234.0121,234.5447,12.2436,0.488800,7,7, spawn_time, 0, VEHICLE_ACTION_TYPE_TRUCKER); // 
	CreateVehicle(609,-242.3295,234.5451,12.2436,359.8156,7,7, spawn_time, 0, VEHICLE_ACTION_TYPE_TRUCKER); // 
	CreateVehicle(609,-250.4456,234.5418,12.2335,0.303100,7,7, spawn_time, 0, VEHICLE_ACTION_TYPE_TRUCKER); //	
	
	// --------------- ���������� �������
	CreateVehicle(584, 354.4533, -444.6721, 5.1695, 90.0000, -1, -1, spawn_time, 0, VEHICLE_ACTION_TYPE_TRUCKER);
	CreateVehicle(584, 330.1744, -444.4918, 5.1695, 90.0000, -1, -1, spawn_time, 0, VEHICLE_ACTION_TYPE_TRUCKER);
	CreateVehicle(584, 306.3080, -444.5778, 5.1695, 90.0000, -1, -1, spawn_time, 0, VEHICLE_ACTION_TYPE_TRUCKER);

	CreateVehicle(514, 327.4969, -468.1053, 4.5210, 0.0000, -1, -1, spawn_time, 0, VEHICLE_ACTION_TYPE_TRUCKER);
	CreateVehicle(514, 331.9969, -468.1053, 4.5210, 0.0000, -1, -1, spawn_time, 0, VEHICLE_ACTION_TYPE_TRUCKER);
	CreateVehicle(514, 336.4969, -468.1053, 4.5210, 0.0000, -1, -1, spawn_time, 0, VEHICLE_ACTION_TYPE_TRUCKER);
	
	// --------------- ��������
	CreateVehicle(525,1142.9878,2486.9973,12.3509,301.8680,1,6, spawn_time, 0, VEHICLE_ACTION_TYPE_MECHANIC); // �������� 1
	CreateVehicle(525,1141.0784,2490.1216,12.3592,301.2564,1,6, spawn_time, 0, VEHICLE_ACTION_TYPE_MECHANIC); // �������� 2
	CreateVehicle(525,1201.8059,2502.0313,12.1630,31.30580,1,6, spawn_time, 0, VEHICLE_ACTION_TYPE_MECHANIC); // �������� 3
	CreateVehicle(525,1205.4995,2504.3215,12.1629,30.81340,1,6, spawn_time, 0, VEHICLE_ACTION_TYPE_MECHANIC); // �������� 4
	CreateVehicle(525,1209.2325,2506.6006,12.1630,31.90060,1,6, spawn_time, 0, VEHICLE_ACTION_TYPE_MECHANIC); // �������� 5
	CreateVehicle(525,1212.8977,2508.8955,12.1630,31.02640,1,6, spawn_time, 0, VEHICLE_ACTION_TYPE_MECHANIC); // �������� 6
	CreateVehicle(525,1208.6957,2527.5200,12.1629,122.4859,1,6, spawn_time, 0, VEHICLE_ACTION_TYPE_MECHANIC); // �������� 7
	CreateVehicle(525,1206.5468,2530.8984,12.1629,122.8413,1,6, spawn_time, 0, VEHICLE_ACTION_TYPE_MECHANIC); // �������� 8
	CreateVehicle(525,1203.7800,2534.8557,12.3507,122.1955,1,6, spawn_time, 0, VEHICLE_ACTION_TYPE_MECHANIC); // �������� 9
	CreateVehicle(525,1201.6656,2538.2449,12.3544,122.2750,1,6, spawn_time, 0, VEHICLE_ACTION_TYPE_MECHANIC); // �������� 10
	CreateVehicle(525,1139.1326,2493.2759,12.3495,302.2898,1,6, spawn_time, 0, VEHICLE_ACTION_TYPE_MECHANIC); // �������� 11
	CreateVehicle(525,1137.2019,2496.4790,12.3578,302.6617,1,6, spawn_time, 0, VEHICLE_ACTION_TYPE_MECHANIC); // �������� 12

	// --------------- ��� (��������)
	
	// ��������
	CreateVehicle(544,1833.9083,2522.2378,15.8410,126.4627,3,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	CreateVehicle(544,1830.9589,2526.5569,15.8433,125.1378,3,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	CreateVehicle(407,1839.2209,2506.0569,15.8813,123.6029,3,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	CreateVehicle(407,1842.2141,2501.6240,15.8911,125.9585,3,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	CreateVehicle(407,1836.1093,2510.9060,15.8818,124.8976,3,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	
	// �����������
	CreateVehicle(544,1577.5398,-287.9251,4.1764,88.8271,3,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	CreateVehicle(544,1577.6602,-282.3537,4.1783,88.0708,3,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	CreateVehicle(407,1574.9150,-267.0268,4.2169,88.4024,3,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	CreateVehicle(407,1573.9773,-302.7855,4.2166,88.7209,3,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	
	// --------------- ��������� �� ������
	/*
	for(new i; i < sizeof rent_cars_data; i ++)
	{
		rent_cars_data[i][rent_car_tenant_id] = INVALID_PLAYER_ID;
		rent_car_id[i] = CreateVehicle(rent_cars_data[i][rent_car_modelid], rent_cars_data[i][rent_car_pos_x], rent_cars_data[i][rent_car_pos_y], rent_cars_data[i][rent_car_pos_z], rent_cars_data[i][rent_car_angle], -1, -1, 600);
	}
	*/
	
	// --------------- �������������
	CreateVehicle(475,-103.0350,-260.8059,4.1691,279.0488,1,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // �������������. ������� (�) 1
	CreateVehicle(426,-111.2283,-262.0719,4.3041,279.8651,1,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // �������������. ������� (�) 1
	CreateVehicle(475,-119.3636,-263.5043,4.1695,278.7228,1,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // �������������. ������� (�) 2
	CreateVehicle(475,-192.7565,-265.7835,4.1478,189.5820,1,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // �������������. ������� 3
	CreateVehicle(475,-196.1176,-266.3530,4.1494,189.0426,1,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // �������������. ������� 4
	CreateVehicle(475,-207.3455,-273.6015,4.1477,279.4680,1,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // �������������. ������� 5
	CreateVehicle(426,-201.2916,-283.0370,4.2789,279.0004,1,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // �������������. ������� 2
	CreateVehicle(426,-192.3694,-281.5222,4.2775,279.8237,1,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // �������������. ������� 3
	CreateVehicle(487,-94.62410,-348.5245,4.4318,279.5082,1,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // �������������, ��������
	
	// --------------- ����� 
	CreateVehicle(433,1156.7839,-315.7548,4.0657,269.7149,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	CreateVehicle(433,1156.7582,-310.3722,4.0653,270.7051,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	CreateVehicle(433,1156.7754,-304.4783,4.0654,270.8091,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	CreateVehicle(433,1156.7952,-299.0881,4.0656,271.3176,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	CreateVehicle(578,1156.1288,-290.2753,4.1566,269.1052,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	CreateVehicle(578,1156.1384,-284.6878,4.1565,269.6847,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	CreateVehicle(433,1156.7737,-278.9651,4.0659,268.7352,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	CreateVehicle(433,1156.7626,-273.6026,4.0655,270.4865,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	CreateVehicle(551,1234.2112,-393.4836,3.9303,89.54020,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	CreateVehicle(551,1234.1979,-396.9344,3.9314,89.33490,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	CreateVehicle(470,1233.8148,-400.9222,4.0629,89.68860,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	CreateVehicle(470,1233.8270,-404.9666,4.0607,89.11960,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	CreateVehicle(470,1233.7650,-409.2629,4.0587,90.34210,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE);
	CreateVehicle(539,1211.8688,-325.3603,3.5158,89.90260,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); 	// ��������� ������� ��� �����
	CreateVehicle(539,1211.9418,-313.4679,3.5158,88.45440,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); 	// ��������� ������� ��� �����
	CreateVehicle(471,1177.6888,-313.0419,3.6359,180.0603,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); 	// ���������� ��� �����
	CreateVehicle(471,1177.6407,-325.9603,3.6373,359.3870,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); 	// ���������� ��� �����
	CreateVehicle(432,1153.8374,-339.3727,4.0109,270.9231,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); 	// ���� ��� �����
	CreateVehicle(432,1153.9091,-332.5274,4.0119,270.1491, 1, 1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); 	// ���� ��� �����
	CreateVehicle(432,1153.9709,-325.6381,4.0124,269.9100,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); 	// ���� ��� �����
	CreateVehicle(508,1242.4823,-415.2211,4.3139,89.70100,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); 	// ���� ��� �����	
	
	CreateVehicle(515,1249.9360,-282.2376,4.6363,179.8160,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); 	// �� ����
	CreateVehicle(515,1245.0769,-282.4388,4.6387,179.9166,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); 	// �� ����
	CreateVehicle(582,1240.8258,-282.4004,4.0606,179.4684,99,99, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); 	// �� ����
	
	// --------------- �������� 
	CreateVehicle(416,-238.7698,550.8733,12.8994,172.9392,1,3, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ������ 1
	CreateVehicle(416,-242.7097,551.2446,12.8732,172.6469,1,3, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ������ 2
	CreateVehicle(416,-246.4461,551.7439,12.8284,173.2092,1,3, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ������ 3
	CreateVehicle(416,-250.5226,552.2697,12.7723,173.1097,1,3, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ������ 4
	CreateVehicle(416,-254.7837,552.7803,12.7358,172.8184,1,3, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ������ 5
	CreateVehicle(416,-259.3213,553.0524,12.7474,173.1399,1,3, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ������ 6
	CreateVehicle(416,-263.5467,553.6649,12.7380,172.5578,1,3, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ������ 7
	CreateVehicle(551,-268.3803,554.4357,12.2997,173.0043,3,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ����� 1
	CreateVehicle(551,-272.1465,554.9032,12.2546,173.1070,3,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ����� 2
	CreateVehicle(487,-215.8927,548.0470,12.6525,170.4808,1,3, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ��������	

	// --------------- ����� ��� ���� 
	CreateVehicle(488,-2071.9351,-227.7029,34.3738,350.3357,7,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, ���������, ��������
	CreateVehicle(582,-2023.0909,-154.7924,25.7265,169.5153,7,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, ���������, ������ 1
	CreateVehicle(582,-2027.0698,-154.0206,25.7269,169.4299,7,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, ���������, ������ 2
	CreateVehicle(582,-2031.0341,-153.3923,25.7263,169.1252,7,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, ���������, ������ 3
	CreateVehicle(582,-2034.9696,-152.8096,25.7336,169.3665,7,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, ���������, ������ 4
	CreateVehicle(582,-2038.8690,-152.1637,25.7428,169.2028,7,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, ���������, ������ 5
	CreateVehicle(436,-2042.6635,-151.3722,25.7618,169.8739,7,1, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, ���������, ���� 2		

	// --------------- ���
	CreateVehicle(497,231.0099,1476.9618,20.9156,347.8531,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, ????
	CreateVehicle(598,217.8206,1511.0735,11.9601,167.6630,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, 2114 (1)
	CreateVehicle(598,221.3322,1510.3225,11.9578,169.5956,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, 2114 (2)
	CreateVehicle(598,224.7700,1509.5897,11.9615,169.6560,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, 2114 (3)
	CreateVehicle(598,228.4079,1508.7455,11.9613,168.0535,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, 2114 (4)
	CreateVehicle(598,231.9449,1507.9738,11.9591,169.9643,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, 2114 (5)
	CreateVehicle(405,235.4960,1507.0621,12.0754,169.5155,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, Lancer (1)
	CreateVehicle(405,239.1409,1506.2278,12.0752,169.7900,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, Lancer (2)
	CreateVehicle(427,246.2852,1505.1682,12.6179,166.7336,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, ??? (1)
	CreateVehicle(427,242.6277,1505.9247,12.6154,167.9913,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, ??? (2)
	CreateVehicle(523,251.6668,1497.8969,11.9817,79.9695,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, ?? (1)
	CreateVehicle(523,250.3617,1491.7239,11.9828,78.4213,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, ?? (2)
	CreateVehicle(523,248.8794,1485.7477,11.9819,77.7901,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, ?? (3)
	CreateVehicle(523,247.5661,1479.4058,11.9795,76.4383,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, ?? (4)
	
	// --------------- ���
	CreateVehicle(599,43.7741,314.4717,12.3043,158.0665,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, ��� 1
	CreateVehicle(599,47.0117,313.1432,12.3052,159.0299,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, ��� 2
	CreateVehicle(599,50.3530,311.7809,12.3051,158.5672,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, ��� 3
	CreateVehicle(599,53.7616,310.4499,12.3045,158.9264,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, ��� 4
	CreateVehicle(599,57.0600,309.0200,12.3043,157.7294,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, ��� 5
	CreateVehicle(601,63.6441,268.5136,11.8541,338.0997,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ��������� 1
	CreateVehicle(601,59.6313,270.1782,11.8551,338.1539,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ��������� 2
	CreateVehicle(483,66.9540,304.2593,12.2626,158.4921,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ��� 1
	CreateVehicle(483,60.2165,306.9345,12.2633,157.6622,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ��� 2
	CreateVehicle(497,47.6793,279.7089,20.9092,337.0798,1,7, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ORP, ��������
	
	// --------------- ���
	CreateVehicle(436,-429.4131,949.5490,11.9645,269.5054,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ���� 2 (1)
	CreateVehicle(436,-429.4118,945.7587,11.9645,270.8111,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ���� 2 (2)
	CreateVehicle(482,-429.3771,941.8729,12.2697,270.9898,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ������� 1
	CreateVehicle(482,-429.4834,937.7449,12.2674,270.5646,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ������� 2
	CreateVehicle(490,-429.0381,933.5400,12.2794,270.4852,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ������ 1
	CreateVehicle(490,-429.1058,928.2256,12.2789,270.0279,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ������ 2
	CreateVehicle(490,-429.1569,923.2666,12.2794,269.8669,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ������ 3
	CreateVehicle(490,-429.2524,918.7321,12.2800,270.6324,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ������ 4
	CreateVehicle(497,-425.3671,897.8140,12.3065,178.9797,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ���, ��������
	
	CreateVehicle(582,-419.5389,918.5320,12.2050,0.2424,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // �� ����
	
	// --------------- ��� �����������
	CreateVehicle(492, 1641.0050, -301.7708, 4.0192, 357.3890, 0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ���� ����������� ���
	CreateVehicle(492, 1636.9392, -301.7030, 4.0172, 359.0896, 0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ���� ����������� ���
	CreateVehicle(482, 1621.3461, -280.7383, 4.1451, 268.5416, 0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ���� ����������� ���
	CreateVehicle(482, 1621.3427, -284.7936, 4.0778, 268.8133, 0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ���� ����������� ���
	CreateVehicle(404, 1641.9578, -289.9147, 3.9477, 38.56050, 0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ���� ����������� ���
	CreateVehicle(404, 1642.1459, -284.9109, 3.9486, 37.45260, 0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ���� ����������� ���
	
	// --------------- ��� ��������
	CreateVehicle(463,1948.7590,2167.8774,15.2449,89.2575,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ��� ��������, ���� 1
	CreateVehicle(463,1948.6904,2164.2683,15.2448,89.8878,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ��� ��������, ���� 2
	CreateVehicle(463,1948.6851,2160.5647,15.2423,91.4960,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ��� ��������, ���� 3
	CreateVehicle(463,1948.7839,2156.7493,15.2449,89.4765,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ��� ��������, ���� 4
	CreateVehicle(482,1932.6991,2170.4280,15.8223,269.8936,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ��� ��������, ������� 1
	CreateVehicle(482,1932.6681,2174.2288,15.8255,270.3850,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ��� �������� ������� 2
	
	CreateVehicle(461,1938.2802,2166.0913,15.2826,272.8900,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // 
	CreateVehicle(461,1938.1625,2163.5066,15.2761,270.5090,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); //
	
	// --------------- ������������ ���
	CreateVehicle(551,-2340.2644,104.5932,20.4217,259.5525,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ����� 1 (1)
	CreateVehicle(551,-2341.0471,100.8282,20.4220,258.7062,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ����� 1 (2)
	CreateVehicle(445,-2341.6548,97.2001,20.8720,259.0891,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ����� 2 (1)
	CreateVehicle(445,-2342.4653,93.2930,20.8720,258.3354,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ����� 2 (2)
	CreateVehicle(482,-2343.4084,89.1208,21.1174,258.7979,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ������� 1
	CreateVehicle(482,-2344.3076,84.8594,21.1200,258.6470,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // ������� 2
	
	CreateVehicle(489,-2345.0205,80.8984,21.0643,258.3234,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); // 
	CreateVehicle(516,-2345.7017,77.4525,20.7411,258.9327,0,0, spawn_time, 0, VEHICLE_ACTION_TYPE_NONE); //
	
	// --------------- ������ �� �������
	CreateVehicle(510, 524.6428, 1672.6086, 11.7703, -216.7200, -1, -1, 100);
	CreateVehicle(510, 525.9127, 1672.4463, 11.7703, -216.7200, -1, -1, 100);
	CreateVehicle(510, 527.1146, 1672.3667, 11.7703, -216.7200, -1, -1, 100);
	CreateVehicle(510, 528.3008, 1672.4495, 11.7703, -216.7200, -1, -1, 100);
	CreateVehicle(510, 529.5106, 1672.3778, 11.7703, -216.7200, -1, -1, 100);
	CreateVehicle(510, 530.7240, 1672.2489, 11.7703, -216.7200, -1, -1, 100);
	CreateVehicle(510, 531.7532, 1672.0746, 11.7703, -216.7200, -1, -1, 100);
	CreateVehicle(510, 523.3896, 1672.9454, 11.7703, -216.7200, -1, -1, 100);
	CreateVehicle(510, -1108.7395, 2169.7300, 37.6036, 0.0000, -1, -1, 100);
	CreateVehicle(510, -1109.7124, 2169.9663, 37.6036, 0.0000, -1, -1, 100);
	CreateVehicle(510, -1110.7065, 2170.0657, 37.6036, 0.0000, -1, -1, 100);
	CreateVehicle(510, -1111.6620, 2170.2090, 37.6036, 0.0000, -1, -1, 100);
	CreateVehicle(510, -1112.5703, 2170.3350, 37.6036, 0.0000, -1, -1, 100);
	CreateVehicle(510, 950.3660, -274.0046, 3.7284, 90.0000, -1, -1, 100);
	CreateVehicle(510, 950.3660, -275.0046, 3.7284, 90.0000, -1, -1, 100);
	CreateVehicle(510, 950.3660, -276.0046, 3.7284, 90.0000, -1, -1, 100);
	CreateVehicle(510, 950.3660, -277.0046, 3.7284, 90.0000, -1, -1, 100);
	CreateVehicle(510, 950.3660, -278.0046, 3.7284, 90.0000, -1, -1, 100);
	
	AddStaticVehicle(510,2423.1360,-625.8669,11.9763,0.5518,46,46); // ��������� �� ���������
	AddStaticVehicle(510,2421.3872,-625.8600,11.9769,359.8800,2,2); // ��������� �� ���������
	AddStaticVehicle(510,2424.8699,-625.8561,11.9772,0.6112,43,43); // ��������� �� ���������
	AddStaticVehicle(510,2426.8066,-625.8909,11.9762,3.3079,28,28); // ��������� �� ���������
	AddStaticVehicle(510,2419.5664,-625.7858,11.9769,1.0366,39,39); // ��������� �� ���������
	
	CreateVehicle(510, 1847.7469, 2241.4727, 14.8344, -90.0000, -1, -1, 100);
	CreateVehicle(510, 1847.7469, 2240.4727, 14.8344, -90.0000, -1, -1, 100);
	CreateVehicle(510, 1847.7469, 2239.4727, 14.8344, -90.0000, -1, -1, 100);
	CreateVehicle(510, 1847.7469, 2238.4727, 14.8344, -90.0000, -1, -1, 100);
	CreateVehicle(510, 1847.7469, 2237.4727, 14.8344, -90.0000, -1, -1, 100);
	CreateVehicle(510, 522.1014, 1672.9890, 11.7703, -216.7200, -1, -1, 100);
	CreateVehicle(510, 520.7606, 1673.0159, 11.7703, -216.7200, -1, -1, 100);
	CreateVehicle(510, -88.6147, 298.3748, 11.7671, 0.0000, -1, -1, 100);
	CreateVehicle(510, -87.6147, 298.2998, 11.7671, 0.0000, -1, -1, 100);
	CreateVehicle(510, -86.6147, 298.1498, 11.7671, 0.0000, -1, -1, 100);
	CreateVehicle(510, -85.6147, 297.9998, 11.7671, 0.0000, -1, -1, 100);
	CreateVehicle(510, -84.6147, 297.8748, 11.7671, 0.0000, -1, -1, 100);
	CreateVehicle(510, -103.4119, 300.4464, 11.7671, 0.0000, -1, -1, 100);
	CreateVehicle(510, -102.4787, 300.3738, 11.7671, 0.0000, -1, -1, 100);
	CreateVehicle(510, -101.5577, 300.2741, 11.7671, 0.0000, -1, -1, 100);
	CreateVehicle(510, -100.6291, 300.1696, 11.7671, 0.0000, -1, -1, 100);
	CreateVehicle(510, -99.8420, 300.0519, 11.7671, 0.0000, -1, -1, 100);
	
	CreateVehicle(510,2367.7622,1783.5487,-0.4643,275.4319, -1, -1, 100); // ��������� � ����� id 510
	CreateVehicle(510,2367.8992,1782.1235,-0.6421,275.3601, -1, -1, 100); // ��������� � ����� id 510
	CreateVehicle(510,2368.1394,1780.4094,-0.8601,273.0810, -1, -1, 100); // ��������� � ����� id 510
	CreateVehicle(510,2368.1377,1778.9650,-1.0353,264.0700, -1, -1, 100); // ��������� � ����� id 510
	CreateVehicle(510,2368.2961,1776.7134,-1.3138,274.9945, -1, -1, 100); // ��������� � ����� id 510
	// ---------------	
	
	print("[Vehicle]: ��� ������������ �������� �������");
}

stock ShowPlayerPayForRentDialog(playerid)
{
	Dialog
	(
		playerid, DIALOG_PAY_FOR_RENT, DIALOG_STYLE_LIST,
		"{66CC00}������",
		"1. ��������� �� ���\n"\
		"2. �������� ������ �������\n"\
		"3. �������� ������ ���",
		"�����", "������"
	);
	return 1;
}

stock ClearBankAccountInfo(playerid, accountid)
{
	strmid(g_bank_account[playerid][accountid][BA_NAME], "None", 0, 21, 21);
	
	SetBankAccountData(playerid, accountid, BA_ID, 0);
	SetBankAccountData(playerid, accountid, BA_PIN_CODE, 0);
	
	SetBankAccountData(playerid, accountid, BA_BALANCE, 0);
	SetBankAccountData(playerid, accountid, BA_REG_TIME, 0);
}

stock ClearBankAccountsData(playerid)
{
	for(new idx; idx < MAX_BANK_ACCOUNTS; idx ++)
	{
		ClearBankAccountInfo(playerid, idx);
	}
}

stock ShowPlayerBankDialog(playerid)
{
	Dialog
	(
		playerid, DIALOG_BANK, DIALOG_STYLE_LIST,
		"{00CC00}����",
		"��� �����\n"\
		"������� ����� ����",
		"�������", "������"
	);
}

stock ShowPlayerBankAccounts(playerid)
{
	new query[64];
	new Cache: result;
	new rows; 
	new bank_accounts_list[(37 * MAX_BANK_ACCOUNTS) + 22 + 1];
	
	format(query, sizeof query, "SELECT * FROM bank_accounts WHERE uid=%d LIMIT %d", GetPlayerAccountID(playerid), MAX_BANK_ACCOUNTS);
	result = mysql_query(mysql, query);
	rows = cache_num_rows();

	bank_accounts_list = "{99CC00}�������� ����\n";
	for(new idx, count; idx < MAX_BANK_ACCOUNTS; idx ++)
	{
		ClearBankAccountInfo(playerid, idx);
		
		if(idx < rows)
		{
			SetBankAccountData(playerid, idx, BA_ID, cache_get_row_int(idx, 0));
			
			cache_get_row(idx, 2, g_bank_account[playerid][idx][BA_NAME], mysql, 21);
			cache_get_row(idx, 4, g_bank_account[playerid][idx][BA_PIN_CODE], mysql, 9);
			
			SetBankAccountData(playerid, idx, BA_BALANCE, cache_get_row_int(idx, 3));
			SetBankAccountData(playerid, idx, BA_REG_TIME, cache_get_row_int(idx, 5));
			
			format(query, sizeof query, "%s - �%d\n", GetBankAccountData(playerid, idx, BA_NAME), GetBankAccountData(playerid, idx, BA_ID));
			strcat(bank_accounts_list, query);
			
			SetPlayerListitemValue(playerid, count ++, idx);
		}
	}
	cache_delete(result);
	
	return Dialog(playerid, DIALOG_BANK_ACCOUNTS, DIALOG_STYLE_LIST, "{FFCD00}���� �����", bank_accounts_list, "��������", "�����");
}

stock IsValidBankAccount(playerid, accountid)
{
	if(0 <= accountid <= MAX_BANK_ACCOUNTS-1)
	{
		if(GetBankAccountData(playerid, accountid, BA_ID) > 0)
		{
			return 1;
		}
	}
	return 0;
}

stock UpdateBankAccountData(playerid, accountid)
{
	if(IsValidBankAccount(playerid, accountid))
	{
		new query[64];
		new Cache: result;
		
		format(query, sizeof query, "SELECT balance FROM bank_accounts WHERE id=%d LIMIT 1", GetBankAccountData(playerid, accountid, BA_ID));
		result = mysql_query(mysql, query);
		
		if(cache_num_rows())
			SetBankAccountData(playerid, accountid, BA_BALANCE, cache_get_row_int(0, 0));
		
		cache_delete(result);
	}
}

stock ShowPlayerBankAccountOperation(playerid)
{
	Dialog
	(
		playerid, DIALOG_BANK_ACCOUNT_OPERATION, DIALOG_STYLE_LIST,
		"{0099FF}������ ��������",
		"1. ���������� � �����\n"\
		"2. ������� ��������\n"\
		"3. ����� ������\n"\
		"4. �������� ������\n"\
		"5. ��������� �� ������ ����\n"\
		"6. ������������� ����\n"\
		"7. �������� PIN-���",
		"�������", "�����"
	);
	return 1;
}

stock ShowPlayerBankAccountTransfer(playerid, accountid)
{
	if(IsValidBankAccount(playerid, accountid))
	{
		new fmt_str[128];
		format
		(
			fmt_str, sizeof fmt_str, 
			"{FFFFFF}�������� ����:\t%d\n"\
			"����������:\t\t\"%s\", �%d\n\n"\
			"������� ����� ��� ��������:",
			GetBankAccountData(playerid, accountid, BA_ID),
			GetPlayerBankTransfer(playerid, BT_NAME),
			GetPlayerBankTransfer(playerid, BT_ID)
		);
		Dialog(playerid, DIALOG_BANK_ACCOUNT_TRANSFER_2, DIALOG_STYLE_INPUT, "{FFCD00}������� �������", fmt_str, "���������", "������");
	}
	return 1;
}

stock ShowPlayerATMTransfer(playerid)
{
	new transfer_id = GetPlayerBankTransfer(playerid, BT_ID);
	if(transfer_id)
	{
		new fmt_str[64 + 1];
		
		format
		(
			fmt_str, sizeof fmt_str, 
			"{FFFFFF}�� ���������� ������� �� ���� �%d\n"\
			"������� �����:",			
			transfer_id
		);
		Dialog(playerid, DIALOG_ATM_TRANSFER_MONEY_2, DIALOG_STYLE_INPUT, "{FFCD00}����������� �������", fmt_str, "���������", "������");
	}
	return 1;
}

stock IsABadBankAccountName(dest[], pos=0)
{
	new is_bad_name = false;
	do
	{
		switch(dest[pos])
		{
			case 
				'a'..'z', 'A'..'Z', '�'..'�', '�'..'�', '0'..'9': continue;
				
			default:
				is_bad_name = true;
				
		}
	}
	while(dest[++pos]);
	
	return is_bad_name;
}

stock BankAccountLog(playerid, accountid, description[])
{
	new query[180 + 1];
	
	mysql_format(mysql, query, sizeof query, "INSERT INTO bank_accounts_log (acc_id,uip,time,description) VALUES (%d,'%e',%d,'%e')", accountid, GetPlayerIpEx(playerid), gettime(), description);
	mysql_query(mysql, query, false);
	
	return 1;
}

stock ShowPlayerBankAccountLog(playerid, accountid)
{
	new fmt_str[128];
	new Cache: result;
	new rows;
	
	format(fmt_str, sizeof fmt_str, "SELECT FROM_UNIXTIME(time,'%%Y-%%m-%%d') AS date,description FROM bank_accounts_log WHERE acc_id=%d ORDER BY id DESC LIMIT 10", accountid);
	result = mysql_query(mysql, fmt_str);

	rows = cache_num_rows();
	
	if(rows)
	{
		new text[900] = "{FFFFFF}";
		new day, month, year;
		
		for(new idx; idx < rows; idx ++)
		{
			cache_get_row(idx, 0, fmt_str);
			sscanf(fmt_str, "P<->ddd", year, month, day);
			
			cache_get_row(idx, 1, fmt_str);

			format(fmt_str, sizeof fmt_str, "%d %s %d �.\t\t%s\n", day, GetMonthName(month), year, fmt_str);
			strcat(text, fmt_str);
		}
		Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{FFCD00}��������� 10 ��������", text, "���������", "");
	}
	else Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{FFCD00}�������", "{FFFFFF}������� �������� �����", "���������", "");
	
	cache_delete(result);
	return 1;
}

stock RemovePlayerAttachedObjects(playerid)
{
	for(new idx; idx < MAX_PLAYER_ATTACHED_OBJECTS; idx ++)
	{
		if(IsPlayerAttachedObjectSlotUsed(playerid, idx))
		{
			RemovePlayerAttachedObject(playerid, idx);
		}
	}
}

stock RemovePlayerAttachedObjectEx(playerid, ...)
{
	new args = numargs()-1;
	for(new idx; idx < args; idx ++)
		RemovePlayerAttachedObject(playerid, getarg(idx + 1));
}

stock HelpInfoInit()
{
	new fmt_str[64];
	
	for(new idx; idx < sizeof help_info; idx ++)
	{
		format(fmt_str, sizeof fmt_str, "%d. %s\n", idx + 1, help_info[idx][H_TITLE]);
		strcat(help_info_items, fmt_str);
		
		format(fmt_str, sizeof fmt_str, "{FFCD00}%d. ", idx + 1);
		strins(help_info[idx][H_TITLE], fmt_str, 0, 64);
		
		//strins(help_info[idx][H_INFO], "{FFFFFF}", 0, 1024);
	}
	
	help_info_CP = CreateDynamicCP(529.6985, 1675.3622, 12.0097, 1.9, _, _, _, 5.0); // ������� (�����)
	CreateDynamic3DTextLabel("������ ��� ��������\n{FFFF00}������ �� ����", 0x3399FFFF, 529.6985, 1675.3622, 12.0097 + 0.66, 15.0, _, _, _, 0, 0);

	//help_info_CP[1] = CreateDynamicCP(1763.693, -1885.828, 13.555, 2.1, _, _, _, 23.0); // ��-������ ��
	//CreateDynamic3DTextLabel("������ ��� ��������\n{FFFF00}������ �� ����", 0x3399FFFF, 1763.693, -1885.828, 13.555 + 0.66, 26.0, _, _, _, 0, 0);
}

stock ShowPlayerHelpSection(playerid, sectionid)
{
	new next_buttom[9] = "����� >>";
	if(sectionid >= sizeof help_info - 1)
	{
		next_buttom[0] = '\0';
	}
	
	Dialog
	(
		playerid, DIALOG_HELP_SECTION, DIALOG_STYLE_MSGBOX,
		GetHelpInfoData(sectionid, H_TITLE),
		GetHelpInfoData(sectionid, H_INFO),
		"<< ����", next_buttom
	);
	SetPVarInt(playerid, "help_section", sectionid);
}

stock ServerRadioInit()
{
	new fmt_str[64];
	
	for(new idx; idx < sizeof g_server_radio; idx ++)
	{
		format(fmt_str, sizeof fmt_str, "%d. %s\n", idx + 1, GetServerRadioData(idx, SR_CHANNEL_NAME));
		strcat(g_server_radio_items, fmt_str);
	}
}

stock MapIconsInit()
{
	for(new idx; idx < sizeof map_icons; idx ++)
	{
		CreateDynamicMapIcon
		(
			GetMapIconsData(idx, MI_POS_X),
			GetMapIconsData(idx, MI_POS_Y), 
			GetMapIconsData(idx, MI_POS_Z), 
			GetMapIconsData(idx, MI_TYPE), 
			0, 
			0,
			0, 
			-1,
			MAP_ICON_STREAM_DISTANCE,
			MAPICON_LOCAL
		);
	}
}

stock TeleportPickupsInit()
{
	new Text3D:buffer;
	for(new idx; idx < sizeof g_teleport; idx ++)
	{
		if(strlen(GetTeleportData(idx, T_NAME)) && !GetTeleportData(idx, T_PICKUP_VIRTUAL_WORLD))
		{
			buffer = CreateDynamic3DTextLabel
			(
				GetTeleportData(idx, T_NAME), 
				0x3399FFEE, 
				GetTeleportData(idx, T_PICKUP_POS_X),
				GetTeleportData(idx, T_PICKUP_POS_Y),
				GetTeleportData(idx, T_PICKUP_POS_Z) + 0.8,
				5.0,
				INVALID_PLAYER_ID,
				INVALID_VEHICLE_ID, 
				0,
				0,
				0, 
				-1,
				STREAMER_3D_TEXT_LABEL_SD
			);
			SetTeleportData(idx, T_LABEL, buffer);
		}
		CreatePickup(1318, 23, GetTeleportData(idx, T_PICKUP_POS_X), GetTeleportData(idx, T_PICKUP_POS_Y), GetTeleportData(idx, T_PICKUP_POS_Z), GetTeleportData(idx, T_PICKUP_VIRTUAL_WORLD), PICKUP_ACTION_TYPE_TELEPORT, idx);
	}
	print("[TP]: ��� �����/������ �������");
}

stock DrivingSchoolInit()
{
	new buffer[2];
	
	driving_exam_CP = CreateDynamicCP(1911.2469, 2237.3105, 16.2557, 1.5, 0, 0, -1, 15.0); // ���������
	CreateDynamic3DTextLabel("�����\n��������", 0x99CC00BB, 1911.2469, 2237.3105, 16.2557, 7.0);
	
	CreatePickup(2894, 2, 1917.3297, 2237.8137, 16.2557, 0, PICKUP_ACTION_TYPE_DRIVING_TUTO); // ��������� ��������� ������
	CreateDynamic3DTextLabel("���������\n������", 0xCC9900BB, 1917.3297, 2237.8137, 16.2557 + 0.2, 5.0);
	
	buffer[0] = AddStaticVehicleEx(565, 1928.5189, 2225.2505, 15.7314, 360.0, 17, 17, 300, 0, VEHICLE_ACTION_TYPE_DRIVING_SCH); // ������� 1
	AddStaticVehicleEx(565, 1932.1473, 2225.2505, 15.7304, 360.0, 17, 17, 300, 0, VEHICLE_ACTION_TYPE_DRIVING_SCH); 			// ������� 2
	buffer[1] = AddStaticVehicleEx(565, 1936.1224, 2225.2505, 15.7313, 360.0, 17, 17, 300, 0, VEHICLE_ACTION_TYPE_DRIVING_SCH); // ������� 3
	
	for(new idx = buffer[0]; idx <= buffer[1]; idx ++)
		CreateDynamic3DTextLabel("�������", 0xFF0000FF, 0.0, 0.0, 1.2, 16.0, INVALID_PLAYER_ID, idx);
	
	new fmt_str[64];
	for(new idx; idx < sizeof driving_tutorial; idx ++)
	{
		format(fmt_str, sizeof fmt_str, "{CC9900}������ %d: ", idx + 1);
		strins(driving_tutorial[idx][DT_TITLE], fmt_str, 0, 64);
	}
	
	for(new idx; idx < sizeof driving_exam; idx ++)
	{
		strins(driving_exam[idx][DE_TITLE], "{00CC66}", 0, 64);
	}
}

stock GatesInit()
{
	new type;
	new Float: x, Float: y, Float: z;
	new Float: angle, Float: dist = 3.5;
	
	for(new idx; idx < sizeof g_gate; idx ++)
	{
		type = GetGateData(idx, G_TYPE);
	
		x = GetGateData(idx, G_POS_X);
		y = GetGateData(idx, G_POS_Y);
		z = GetGateData(idx, G_POS_Z);
		angle = GetGateData(idx, G_ANGLE);
	
		switch(type)
		{
			case 
				GATE_TYPE_BARRIER, 
				GATE_TYPE_BARRIER_MSG, 
				GATE_TYPE_BARRIER_BUTTON:
			{
				g_gate[idx][G_OBJECT_ID][0] = CreateDynamicObject(966, x, y, z, 0.0, 0.0, angle, -1, -1, -1, 300.0, 200.0);
				g_gate[idx][G_OBJECT_ID][1] = CreateDynamicObject(968, x, y, z + 0.8, 0.0, 0.0, angle, -1, -1, -1, 300.0, 200.0);				
			
				if(type != GATE_TYPE_BARRIER_BUTTON)
				{
					angle += 90.0;
				
					SetGateData(idx, G_OPEN_POS_X, x + (dist * floatsin(-angle, degrees)));
					SetGateData(idx, G_OPEN_POS_Y, y + (dist * floatcos(-angle, degrees)));
					SetGateData(idx, G_OPEN_POS_Z, z);
				}
				else 
				{
					type = g_gate_buttons_count;
					
					g_gate_button[type][1] = idx;
					g_gate_button[type][0] = CreateButton(GetGateData(idx, G_OPEN_POS_X), GetGateData(idx, G_OPEN_POS_Y), GetGateData(idx, G_OPEN_POS_Z), GetGateData(idx, G_OPEN_ANGLE));
			
					g_gate_buttons_count ++;
				}
				//CreateDynamic3DTextLabel("��������", 0xFF6600FF, GetGateData(idx, G_OPEN_POS_X), GetGateData(idx, G_OPEN_POS_Y), GetGateData(idx, G_OPEN_POS_Z), 10.0);
			}
			case GATE_TYPE_NORMAL:
			{
				
			}
		}
		SetGateStatus(idx, GetGateData(idx, G_STATUS), -1);
	}
	print("[Gates]: ��� ��������� �������");
}

stock IsGateButtonID(buttonid)
{
	return (g_gate_button[0][0] <= buttonid <= g_gate_button[g_gate_buttons_count - 1][0]);
}

stock GetNearestGate(playerid, Float: dist = 10.0)
{
	if(!(0.0 <= dist <= 20.0))
	{
		dist = 10.0;
	}
	//if(dist == 0.0)
	//	dist = FLOAT_INFINITY;
		
	new gateid = -1;
	new Float: my_dist;
	
	for(new idx; idx < sizeof g_gate; idx ++)
	{
		if(GetGateData(idx, G_TYPE) == GATE_TYPE_BARRIER_BUTTON) continue;
		
		my_dist = GetPlayerDistanceFromPoint(playerid, GetGateData(idx, G_OPEN_POS_X), GetGateData(idx, G_OPEN_POS_Y), GetGateData(idx, G_OPEN_POS_Z));
		if(my_dist < dist)
		{
			dist = my_dist,
			gateid = idx;
		}
	}
	return gateid;
}

stock AtmsInit()
{
	new Float: x, Float: y, Float: z, Float: rot_z;
	new Float: dist = 0.6; // ��������� ������ �� ���������

	for(new idx; idx < sizeof g_atm; idx ++)
	{
		x = GetATMInfo(idx, A_POS_X);
		y = GetATMInfo(idx, A_POS_Y);
		z = GetATMInfo(idx, A_POS_Z);
		rot_z = GetATMInfo(idx, A_ROT_Z);
		
		CreateDynamicObject(2942, x, y, z, 0.0, 0.0, rot_z, 0, 0, -1, STREAMER_OBJECT_SD, 100.0);
		//SetDynamicObjectMaterialText(buffer, 2, "��������\n\n\n\n\n", OBJECT_MATERIAL_SIZE_256x256, "Tahoma", 48, 1, 0xFF000000, 0xFFFF9966, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
		
		CreateDynamic3DTextLabel("��������\n{FFCC33}������� ~k~~SNEAK_ABOUT~", 0x00CC00FE, x, y, z + 0.7, 3.0); // 0x00CC00EE
		
		#if defined ATM_CREATED_PICKUP
		rot_z += 180.0;
		CreatePickup(1212, 2, x + dist * -floatsin(rot_z, degrees), y + dist * floatcos(rot_z, degrees), z, -1, PICKUP_ACTION_TYPE_ATM, idx);
		#endif
	}
	print("[ATM]: ��� ��������� �������");
}

stock GetPlayerNearestATM(playerid, Float: dist = 1.3)
{
	if(dist == 0.0)
		dist = FLOAT_INFINITY;
		
	new atmid = -1;
	new Float: my_dist;

	for(new idx; idx < sizeof g_atm; idx ++)
	{
		my_dist = GetPlayerDistanceFromPoint(playerid, GetATMInfo(idx, A_POS_X), GetATMInfo(idx, A_POS_Y), GetATMInfo(idx, A_POS_Z));
		if(my_dist < dist)
		{
			dist = my_dist,
			atmid = idx;
		}
	}
	return atmid;
}

stock ShowPlayerATMDialog(playerid)
{
	Dialog
	(
		playerid, DIALOG_ATM, DIALOG_STYLE_LIST,
		"{FFCD00}��������",
		"1. ����� � ����������� �����\n"\
		"2. �������� �� ���������� ����\n"\
		"3. ������ ����������� �����\n"\
		"4. ����� �� ����� �����������\n"\
		"5. �������� �� ���� �����������\n"\
		"6. ��������� ��������� �������\n"\
		"7. ����������� �������\n"\
		"8. �������������������",
		"�������", "�����"
	);
	return 1;
}

stock ShowPlayerATMSelectSumDialog(playerid, bool:take)
{
	Dialog
	(
		playerid, take ? DIALOG_ATM_TAKE_MONEY : DIALOG_ATM_PUT_MONEY, DIALOG_STYLE_LIST,
		"�������� �����",
		"100 ���\n"\
		"200 ���\n"\
		"500 ���\n"\
		"1000 ���\n"\
		"2000 ���\n"\
		"5000 ���\n"\
		"10000 ���\n"\
		"������ �����...",
		take ? ("�����") : ("��������"), "�����"
	);
	return 1;
}

stock ShowPlayerATMSelectOtherSum(playerid, bool:take)
{
	Dialog
	(
		playerid, take ? DIALOG_ATM_TAKE_OTHER_MONEY : DIALOG_ATM_PUT_OTHER_MONEY, DIALOG_STYLE_INPUT,
		"{FFCD00}������ �����",
		"{FFFFFF}������� �����:",
		take ? ("�����") : ("��������"), "�����"
	);
	return 1;
}

stock ShowPlayerATMCharityDialog(playerid)
{
	Dialog
	(
		playerid, DIALOG_ATM_CHARITY, DIALOG_STYLE_INPUT,
		"{FFCD00}�������������������",
		"{FFFFFF}�� ���������� ��� ����������� �����\n"\
		"����� �� ����������������� ����\n"\
		"�����������. ��� �������� ������ ��\n"\
		"�������� ����� ������ � ��������\n"\
		"���������.\n\n"\
		"������ �����, � ������ ����� �� �������\n"\
		"����� ������������� ������ ���, ���\n"\
		"������ ���������� ������.\n\n"\
		"���� ������ ����� ����������� ��������\n"\
		"/charity. ��� �� ����� ������ �����\n"\
		"����� ��������� ���� �������������.",
		"������", "�������"
	);
	return 1;
}

stock ShowPlayerATMCompanyDialog(playerid, bool: take)
{
	new stationid = GetPlayerFuelStation(playerid);
	new businessid = GetPlayerBusiness(playerid);
	
	if(stationid != -1 && businessid != -1)
	{
		new fmt_str[64 + 1];
		
		format
		(
			fmt_str, sizeof fmt_str, 
			"1. %s (�%d)\n"\
			"2. %s (�%d)", 
			GetBusinessData(businessid, B_NAME), businessid,
			GetFuelStationData(stationid, FS_NAME), stationid
		);
		Dialog(playerid, take ? DIALOG_ATM_SELECT_COMPANY_TAKE : DIALOG_ATM_SELECT_COMPANY_PUT, DIALOG_STYLE_LIST, "{FFCD00}�������� �����������", fmt_str, "�������", "�����");
	}
	else if(stationid != -1)
	{
		ShowPlayerATMFuelStationDialog(playerid, take);
	}
	else if(businessid != -1)
	{
		ShowPlayerATMBusinessDialog(playerid, take);
	}
}

stock ShowPlayerATMFuelStationDialog(playerid, bool:take)
{
	new stationid = GetPlayerFuelStation(playerid);
	if(stationid != -1)
	{
		Dialog
		(
			playerid, take ? DIALOG_ATM_FUEL_ST_TAKE_MONEY : DIALOG_ATM_FUEL_ST_PUT_MONEY, DIALOG_STYLE_INPUT,
			GetFuelStationData(stationid, FS_NAME), 
			"{FFFFFF}������� �����:",
			take ? ("�����") : ("��������"), "�����"
		);
	}
}

stock ShowPlayerATMBusinessDialog(playerid, bool:take)
{
	new businessid = GetPlayerBusiness(playerid);
	if(businessid != -1)
	{
		Dialog
		(
			playerid, take ? DIALOG_ATM_BIZ_TAKE_MONEY : DIALOG_ATM_BIZ_PUT_MONEY, DIALOG_STYLE_INPUT,
			GetBusinessData(businessid, B_NAME), 
			"{FFFFFF}������� �����:",
			take ? ("�����") : ("��������"), "�����"
		);
	}
}

stock BanksInit()
{
	CreatePickup(1274, 2, 904.8345, -787.6771, 1000.5416, -1, PICKUP_ACTION_TYPE_BANK, true);
	CreateDynamic3DTextLabel("/bank", 0x00CC00FF, 904.8345, -787.6771, 1000.5416 + 0.8, 8.0);
	
	CreatePickup(1274, 2, 904.8353, -784.4731, 1000.5416, -1, PICKUP_ACTION_TYPE_BANK, false);
	CreateDynamic3DTextLabel("������\n{CCCC00}����\n�������\n���", 0x66CC66FF, 904.8353, -784.4731, 1000.5416 + 0.8, 8.0);
}

stock TempJobsInit()
{	
	new idx;
	for(idx = 0; idx < sizeof g_temp_jobs-1; idx ++)
	{
		CreatePickup(1275, 23, GetTempJobInfo(idx, TJ_POS_X), GetTempJobInfo(idx, TJ_POS_Y), GetTempJobInfo(idx, TJ_POS_Z), -1, PICKUP_ACTION_TYPE_TEMP_JOB, idx);
	}
	loader_job_area = CreateDynamicRectangle(591.4026, 1781.0015, 482.7329, 1534.9045, 0, 0);
	
	AddStaticVehicleEx(530, 494.4254, 1639.0137, 11.9525, 266.6, 6, 1, 5, 0, VEHICLE_ACTION_TYPE_LOADER); // ��������� � �����
	AddStaticVehicleEx(530, 494.4254, 1641.4299, 11.9525, 266.6, 6, 1, 5, 0, VEHICLE_ACTION_TYPE_LOADER); // ��������� � �����
	AddStaticVehicleEx(530, 494.4254, 1643.8461, 11.9525, 266.6, 6, 1, 5, 0, VEHICLE_ACTION_TYPE_LOADER); // ��������� � �����
	
	// �����
	for(idx = 0; idx < sizeof miner_carriage; idx ++)
	{
		miner_carriage[idx][MC_STATUS] = false;
		miner_carriage[idx][MC_OBJECT_ID] = CreateDynamicObject(3585, miner_carriage[idx][MC_START_POS_X], miner_carriage[idx][MC_START_POS_Y], miner_carriage[idx][MC_START_POS_Z], 0.0, 0.0, 0.0);
		
		SetTimerEx("MinerCarriageMove", 21_000, true, "i", idx);
	}
	miner_job_area = CreateDynamicRectangle(2447.1799,1697.9985, 2279.3557,1806.0872, 0, 0);
	
	CreatePickup(19134, 2, 2305.8884, 1738.6920, 1.7285, 0, PICKUP_ACTION_TYPE_MINER_SELL_M);
	CreateDynamic3DTextLabel("������� �������\n{00CC00}15 ������ {FFFFFF}�� 1 ��", 0x9966FFBB,  2305.8884, 1738.6920, 1.7285 + 1.2, 10.0);

	CreateDynamic3DTextLabel("�����\n\n{3399CC}1. ������ ������������\n2. ��������� ��������", 0x009933FF, GetTempJobInfo(TEMP_JOB_MINER, TJ_POS_X), GetTempJobInfo(TEMP_JOB_MINER, TJ_POS_Y), GetTempJobInfo(TEMP_JOB_MINER, TJ_POS_Z) + 0.82, 5.0);
	
	// �����
	for(idx = 0; idx < 3; idx ++)
	{
		CreatePickup(1275, 3, 264.4713, -217.2706 + float(idx * 2), 1006.5694, -1, PICKUP_ACTION_TYPE_TEMP_JOB, TEMP_JOB_FACTORY);
	}
	for(idx = 0; idx < sizeof factory_take_metall_pos; idx ++)
	{	
		CreatePickup(19135, 2, factory_take_metall_pos[idx][0], factory_take_metall_pos[idx][1], factory_take_metall_pos[idx][2] - 0.4, -1, PICKUP_ACTION_TYPE_FACTORY_MET);
	}
	
	new Float: x = 311.6580, Float: y = -207.6711, Float: z = 1006.5694;
	for(idx = 0; idx < sizeof factory_desk; idx ++)
	{
		if(idx && !(idx % 4))
			y -= (idx != 8 ? 2.9917 : 3.0085);
	
		factory_desk[idx][FD_POS_X] = x - (float(idx % 4) * 5.5003);
		factory_desk[idx][FD_POS_Y] = y;
		factory_desk[idx][FD_POS_Z] = z;
		
		factory_desk[idx][FD_USED] = false;
		factory_desk[idx][FD_OBJECT_ID] = -1;
	
		factory_desk[idx][FD_CHEK_ID] = CreateDynamicCP(factory_desk[idx][FD_POS_X], factory_desk[idx][FD_POS_Y], factory_desk[idx][FD_POS_Z], 0.3, _, _, _, 0.3);
		factory_desk[idx][FD_LABEl] = CreateDynamic3DTextLabel("������� �����", 0xFFFFFFEE, factory_desk[idx][FD_POS_X], factory_desk[idx][FD_POS_Y], factory_desk[idx][FD_POS_Z] + 1.0, 5.0);
	
		CallLocalFunction("UpdateFactoryDesk", "i", idx);
	}
	factory_put_zone = CreateDynamicRectangle(264.8033, -199.8648, 296.8693, -202.0421);
	factory_job_area = CreateDynamicRectangle(-981.2298, 2098.1736, -1170.6591, 2263.3167, 0, 0);
	
	// --------------- �����
	AddStaticVehicleEx(406, -1076.2706, 2204.9490, 38.4303, 180.0, 125, 1, 20, 0, VEHICLE_ACTION_TYPE_FACTORY); // ������ ��� �������� �������
	AddStaticVehicleEx(406, -1081.3639, 2204.7727, 38.4130, 180.0, 125, 1, 20, 0, VEHICLE_ACTION_TYPE_FACTORY); // ������ ��� �������� �������
	AddStaticVehicleEx(406, -1086.3571, 2204.7319, 38.3786, 180.0, 125, 1, 20, 0, VEHICLE_ACTION_TYPE_FACTORY); // ������ ��� �������� �������
	AddStaticVehicleEx(406, -1090.8806, 2204.7322, 38.3446, 180.0, 125, 1, 20, 0, VEHICLE_ACTION_TYPE_FACTORY); // ������ ��� �������� �������
	
	AddStaticVehicleEx(514, -1116.3119, 2205.5913, 38.2890, 179.9556, 6, 6, 20, 0, VEHICLE_ACTION_TYPE_FACTORY); // ���� ��� ��������� �������
	AddStaticVehicleEx(514, -1107.9980, 2205.7349, 38.1867, 180.4830, 6, 6, 20, 0, VEHICLE_ACTION_TYPE_FACTORY); // ���� ��� ��������� �������
	
	AddStaticVehicleEx(584,-1121.6831, 2190.3965, 38.0457, 263.2740, 1, 1, 180, 0, VEHICLE_ACTION_TYPE_FACTORY, true); // ��������
	AddStaticVehicleEx(584,-1121.6831, 2181.3005, 38.0457, 263.2740, 1, 1, 180, 0, VEHICLE_ACTION_TYPE_FACTORY, true); // ��������	
}

stock InfoPickupsInit()
{
	new title_color[16];
	for(new idx; idx < sizeof info_pickup; idx ++)
	{
		CreatePickup(1239, 2, GetInfoPickupData(idx, IP_POS_X), GetInfoPickupData(idx, IP_POS_Y), GetInfoPickupData(idx, IP_POS_Z), -1, PICKUP_ACTION_TYPE_INFO_PICKUP, idx);
		
		format(title_color, sizeof title_color, "{%06x}", GetInfoPickupData(idx, IP_TITLE_COLOR) >>> 8);
		strins(GetInfoPickupData(idx, IP_TITLE), title_color, 0, 64);
		
		strins(GetInfoPickupData(idx, IP_INFO), "{FFFFFF}", 0, 1024);
		if(strlen(GetInfoPickupData(idx, IP_LABEL_INFO)) > 3)
			CreateDynamic3DTextLabel(GetInfoPickupData(idx, IP_LABEL_INFO), 0x99CC00DD, GetInfoPickupData(idx, IP_POS_X), GetInfoPickupData(idx, IP_POS_Y), GetInfoPickupData(idx, IP_POS_Z) + 0.7, 9.5);
	}
}

stock BusRoutesInit()
{
	new fmt_str[64];
	
	for(new idx; idx < sizeof g_bus_routes; idx ++)
	{
		format(fmt_str, sizeof fmt_str, "%d.  %s\n", idx + 1, g_bus_routes[idx][BR_NAME]);
		strcat(g_bus_routes_list, fmt_str);
		
		if(g_bus_routes[idx][BR_COLOR] > 0)
		{
			g_bus_routes[idx][BR_COLOR] = 0x66CC00FF;
		}
		else g_bus_routes[idx][BR_COLOR] = 0x3399FFFF;		
	}
}

stock AnimListInit()
{
	new fmt_str[64];
	for(new idx; idx < sizeof anim_list; idx ++)
	{	
		format(fmt_str, sizeof fmt_str, "%d. %s\n", idx + 1, GetAnimListData(idx, AL_DESCRIPTION));
		strcat(anim_list_items, fmt_str);
	
		if(GetAnimListData(idx, AL_LOOP) > 2)
			anim_list[idx][AL_DESCRIPTION] = 2;
	}
	strcat(anim_list_items, "{33CC00}����������");
}

stock RepositoriesLoad()
{
	new Cache: result; 
	new type, action_id;
	
	result = mysql_query(mysql, "SELECT * FROM repositories ORDER BY type,action_id ASC");
	new rows = cache_num_rows();
	
	for(new idx; idx < rows; idx ++)
	{
		type = cache_get_row_int(idx, 1);
		action_id = cache_get_row_int(idx, 2);
		
		if(0 <= type <= sizeof g_repository-1)
		{
			if(0 <= action_id <= sizeof g_repository[]-1)
			{
				SetRepositoryData(type, action_id, R_AMOUNT, cache_get_row_int(idx, 3));
			}
		}
	}
	cache_delete(result);
	
	RepositoriesInit();
}

stock RepositoriesInit()
{
	// �����
	
	SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL, R_LABEL, CreateDynamic3DTextLabel("-No Init-", 0xFFFFFFFF, 2387.6606, 1757.4240, -1.8463 + 1.0, 20.0));
	SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL, R_LABEL_2, CreateDynamic3DTextLabel("-No Init-", 0xFFFFFFFF, 2317.1355, 1738.4092, 5.0, 25.0));
	
	UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL);
	
	// ----------------------
	SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE, R_LABEL, CreateDynamic3DTextLabel("-No Init-", 0xFFFFFFFF, -2568.2881, 297.3934, -15.7620 + 2.5, 15.0));
	SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE, R_LABEL_2, CreateDynamic3DTextLabel("-No Init-", 0xFFFFFFFF, 2382.7622, 1720.6998, 4.0, 30.0));
	
	UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE);

	// ----------------------
	SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_REMELTI, R_LABEL, CreateDynamic3DTextLabel("-No Init-", 0xFFFFFFFF, 2387.6606, 1752.0416, -1.8463 + 1.0, 20.0));
	UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_REMELTI);

	SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_REMELTI, R_NOT_SAVE, true);
	SetTimer("UpdateMinerRemelting", 10_000, false);
	
	// �����
	SetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL, R_LABEL, CreateDynamic3DTextLabel("-No Init-", 0xFFFFFFFF, -1046.6550,2208.5771, 41.0, 20.0));
	SetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL, R_LABEL_2, CreateDynamic3DTextLabel("-No Init-", 0xFFFFFFFF, 263.7803, -203.8183, 1010.0, 15.0));
	
	factory_store_label[0] = CreateDynamic3DTextLabel("�� ������:\n{FF9900}�������: 0 / 1000000 �\n\n{6699FF}/sellf", 0xFFFFFFFF, -1112.0723,2167.1243, 42.0, 20.0); // �������
	factory_store_label[1] = CreateDynamic3DTextLabel("�� ������:\n{FF9900}������: 0 / 1000000 ��\n\n{6699FF}/sellm", 0xFFFFFFFF, -1042.4534,2170.3594, 42.0, 20.0); // �����
	
	CreateDynamic3DTextLabel("�����\n�����������������\n����\n\n{6699FF}/sellf\n/sellm\n{33CC00}/buyprod", 0xFFFFFFFF, -1046.6550, 2208.5771, 42.0, 25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, _, _, _, _, 50.0);
	UpdateRepository(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL);
	
	// ����������	
	CreateDynamic3DTextLabel("�����\n\n{FFFFFF}������� ������� ��� ���", 0xFF6600FF, 977.3191, 630.5245, 12.1154 - 0.5, 20.0);
	CreateDynamic3DTextLabel("�������\n\n{FFFFFF}������� ������� ��� ������", 0xFF6600FF, 977.3191, 635.4105, 12.1154 - 0.5, 20.0);
	
	SetRepositoryData(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F, R_LABEL, CreateDynamic3DTextLabel("-No Init-", 0xFFFFFFFF, 935.9503, 662.1276, 12.0029 + 5.0, 35.0)); // ��� ���
	SetRepositoryData(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F, R_LABEL_2, CreateDynamic3DTextLabel("-No Init-", 0xFFFFFFFF, 1002.7327, 679.4678, 12.0029 + 5.0, 35.0)); // ��� ������
	
	UpdateRepository(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F);
	SetTimer("UpdateOilFactory", 30_000, false);
	
	print("[Repositories]: ��� ������ ����������");
}

stock UpdateRepository(type, actionid)
{
	new fmt_str[128];
	new amount = GetRepositoryData(type, actionid, R_AMOUNT);
	new Text3D: label = GetRepositoryData(type, actionid, R_LABEL);
	new Text3D: label_2 = GetRepositoryData(type, actionid, R_LABEL_2);
	
	switch(type)
	{
		case REPOSITORY_TYPE_MINER:
		{
			switch(actionid)
			{
				case REPOSITORY_ACTION_MINER_METAL:
				{
					format(fmt_str, sizeof fmt_str, "������� �������\n(��� �����������)\n\n{FFCD00}�� ������ %d ��\n������: /buym", amount);
					UpdateDynamic3DTextLabelText(label_2, 0xFFFFFFFF, fmt_str);
					
					format(fmt_str, sizeof fmt_str, "������\n{0099CC}�� ������:\n%d ��", amount);
					UpdateDynamic3DTextLabelText(label, 0xFFFFFFFF, fmt_str);
				}
				case REPOSITORY_ACTION_MINER_ORE:
				{
					format(fmt_str, sizeof fmt_str, "����\n{00CC00}�� ������:\n%d ��", amount);
					UpdateDynamic3DTextLabelText(label, 0xFFFFFFFF, fmt_str);
					
					UpdateDynamic3DTextLabelText(label_2, 0xFFFFFFFF, fmt_str);
				}
				case REPOSITORY_ACTION_MINER_REMELTI:
				{
					format(fmt_str, sizeof fmt_str, "�������\n{CC9900}%d �� ����\n�� ����������", amount);
					UpdateDynamic3DTextLabelText(label, 0xFFFFFFFF, fmt_str);
				}
			}
		}
		case REPOSITORY_TYPE_FACTORY:
		{
			switch(actionid)
			{
				case REPOSITORY_ACTION_FACTORY_METAL..REPOSITORY_ACTION_FACTORY_PROD:
				{
					if(actionid != REPOSITORY_ACTION_FACTORY_PROD)
					{
						format(fmt_str, sizeof fmt_str, "�� ������:\n{FF9900}�������: %d / 1000000 �\n\n{6699FF}/sellf", GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL, R_AMOUNT));
						UpdateDynamic3DTextLabelText(factory_store_label[0], 0xFFFFFFFF, fmt_str);
						
						format(fmt_str, sizeof fmt_str, "�� ������:\n{FF9900}������: %d / 1000000 �\n\n{6699FF}/sellm", GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL, R_AMOUNT));
						UpdateDynamic3DTextLabelText(factory_store_label[1], 0xFFFFFFFF, fmt_str);
					}
				
					label = GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL, R_LABEL);
					label_2 = GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL, R_LABEL_2);
					
					format
					(
						fmt_str, sizeof fmt_str, 
						"�������� ���������:\n"\
						"{FF9900}�������: %d / 1000000 �\n"\
						"������: %d / 1000000 ��\n"\
						"{33CC00}��������: %d ��.",
						GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL, R_AMOUNT), 
						GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL, R_AMOUNT), 
						GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_PROD, R_AMOUNT)
					);
					UpdateDynamic3DTextLabelText(label, 0xFFFFFFFF, fmt_str);
					UpdateDynamic3DTextLabelText(label_2, 0xFFFFFFFF, fmt_str);
				}
			}
		}
		case REPOSITORY_TYPE_OIL_FACTORY:
		{
			switch(actionid)
			{
				case REPOSITORY_ACTION_OIL_FACTORY_F:
				{
					format(fmt_str, sizeof fmt_str, "������� ��� ���\n\n{FFCD00}�� ������\n%d � �������\n{33FF00}������: /buyf", amount);
					UpdateDynamic3DTextLabelText(label, 0xFFFFFFFF, fmt_str);
					
					format(fmt_str, sizeof fmt_str, "������� ��� ������\n\n{FFCD00}�� ������\n%d � �������\n{33FF00}������: /buyf", amount);
					UpdateDynamic3DTextLabelText(label_2, 0xFFFFFFFF, fmt_str);
				}
			}
		}
	}
}

public: UpdateOilFactory()
{
	new add_fuels = (random(2500) + 500);
	new fuels = GetRepositoryData(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F, R_AMOUNT) + add_fuels;
	
	new time = (random(fuels <= 20_000 ? 1 : 180) + 60) * 1000;
	
	SetRepositoryData(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F, R_AMOUNT, fuels);
	UpdateRepository(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F);
	
	SetTimer("UpdateOilFactory", time, false);
}

public: UpdateMinerRemelting()
{
	new remelting = GetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_REMELTI, R_AMOUNT);
	new ore = GetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE, R_AMOUNT);
	new metall = GetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL, R_AMOUNT);
	new rand;
	
	// ����� � ���������� ����
	rand = random(40) + 11; // �� 10 �� 50;
	if(remelting > 0) // ���� �� ���������� ���� ����
	{	
		if(rand > remelting) // ���� ����� ������ ��� ����
			rand = remelting; // ����� ��� ��� ��������
		
		remelting -= rand;
		
		SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_REMELTI, R_AMOUNT, remelting); // ������� � ����������	
		SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL, R_AMOUNT, metall + rand); // �������� �� ����� ������		
	}
	
	// ����� �� ������ ����
	rand = random(50) + 11; // �� 10 �� 60;
	if(remelting < 100) // ���� �� ����������� ������ 100 ��
	{
		if(rand > ore) // ���� ����� ������ ��� �� ������
			rand = ore; // ����� ��� ��� ��������
		
		SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE, R_AMOUNT, ore - rand); // ����� �� ������
		SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_REMELTI, R_AMOUNT, remelting + rand); // �������� � ����������
	}
	
	UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_ORE);
	UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_REMELTI);
	
	UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL);
	
	SetTimer("UpdateMinerRemelting", (random(16)+15) * 1000, false);
}

stock SaveRepository(type = -1, actionid = -1)
{
	new fmt_str[128];
	
	if(type != -1 && actionid != -1)
	{
		format(fmt_str, sizeof fmt_str, "UPDATE repositories SET amount=%d WHERE type=%d AND action_id=%d LIMIT 1", GetRepositoryData(type, actionid, R_AMOUNT), type, actionid);
		mysql_query(mysql, fmt_str, false);
	}
	else 
	{
		for(new idx, idx_2; idx < sizeof g_repository; idx ++)
		{
			for(idx_2 = 0; idx_2 < sizeof g_repository[]; idx_2 ++)
			{
				if(GetRepositoryData(idx, idx_2, R_NOT_SAVE)) continue;
				
				format(fmt_str, sizeof fmt_str, "UPDATE repositories SET amount=%d WHERE type=%d AND action_id=%d LIMIT 1", GetRepositoryData(idx, idx_2, R_AMOUNT), idx, idx_2);
				mysql_query(mysql, fmt_str, false);				
			}
		}
	}
}

stock PreLoadPlayerAnimList(playerid)
{
	if(!GetPlayerData(playerid, P_ANIM_LIST_INIT))
	{
		PreLoadPlayerAnims(playerid);
		SetPlayerData(playerid, P_ANIM_LIST_INIT, true);
		
		return 1;
	}
	return 0;
}

stock SetPlayerAnimation(playerid, animid)
{
	if(0 <= animid <= sizeof anim_list-1)
	{
		if(!IsPlayerInAnyVehicle(playerid))
		{
			switch(animid+1)
			{
				case 1..4: 
				{
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1 + animid);
				}	
				default: 
				{
					new type = USE_ANIM_TYPE_NONE - 1;
					if(GetAnimListData(animid, AL_LOOP))
					{
						SetPlayerData(playerid, P_USE_ANIM, true);
						TextDrawShowForPlayer(playerid, anim_TD);
					}
					else
					{
						if(IsPlayerUseAnim(playerid))
						{
							SetPlayerData(playerid, P_USE_ANIM, false);
							TextDrawHideForPlayer(playerid, anim_TD);
						}
						type = USE_ANIM_TYPE_NONE;
					}
					ApplyAnimationEx(playerid, GetAnimListData(animid, AL_LIB), GetAnimListData(animid, AL_NAME), GetAnimListData(animid, AL_DELTA), (GetAnimListData(animid, AL_LOOP) % 2), GetAnimListData(animid, AL_LOCK_X), GetAnimListData(animid, AL_LOCK_Y), GetAnimListData(animid, AL_FREEZE), GetAnimListData(animid, AL_TIME), 0, type);
				}
			}
		}
		return 1;
	}
	return 0;
}

stock ClearPlayerUseAnim(playerid)
{
	if(IsPlayerUseAnim(playerid))
	{
		SetPlayerData(playerid, P_USE_ANIM_TYPE, USE_ANIM_TYPE_NONE);
		
		SetPlayerData(playerid, P_USE_ANIM, false);
		TextDrawHideForPlayer(playerid, anim_TD);
	
		ClearPlayerAnim(playerid);
	}
}

stock IsValidMail(email[], len = sizeof email)
{
    new count[2];
    if(!(5 <= len <= 60)) return 0;
    for(new i; i != len; i++)
    {
		switch(email[i])
		{
			case '@':
			{
				count[0]++;
				if(count[0] != 1 || i == len - 1 || i == 0) return 0;
			}
			case '.':
			{
				if(count[0] == 1 && count[1] == 0 && i != len - 1) 
				{
					count[1] = 1;
				}
			}
			case '0'..'9', 'a'..'z', 'A'..'Z', '_', '-':
			{
				continue;
			}
			default:
				return 0;
		}
    }
    if(count[1] == 0) return 0;
    return 1;
} 

stock ShowPlayerRegDialog(playerid, step)
{
	if(GetPlayerData(playerid, P_ACCOUNT_STATE) != ACCOUNT_STATE_REGISTER) return 0;
	
	switch(step)
	{
		case REGISTER_STATE_PASSWORD:
		{
			Dialog
			(
				playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT,
				"{66CCFF}�����������",
				"{FFFFFF}����� ���������� �� ������ "SERVER_NAME" RolePlay\n"\
				"����� ������ ���� ������� ���������� ������������������\n\n"\
				"���������� ������� ������ ��� ������ ��������\n"\
				"�� ����� ������������� ������ ���, ����� �� �������� �� ������\n\n"\
				"\t{66CC66}����������:\n"\
				"\t- ������ ����� �������� �� ������� � ��������� ��������\n"\
				"\t- ������ ������������ � ��������\n"\
				"\t- ����� ������ �� 6-�� �� 15-�� ��������",
				"�����", ""
			);
		}
		case REGISTER_STATE_EMAIL:
		{
			Dialog
			(
				playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT,
				"{66CCFF}Email",
				"{FFFFFF}������� ����� ����� ����������� �����\n"\
				"��������� ���, �� ������� ������������ ������ � ��������\n"\
				"� ������ ������ ��� ���� �������� ������.\n\n"\
				"�� email �� ������ ������. � ������� 14 ���� �� ������\n"\
				"������� �� ��� ��� ������������� �����.\n\n"\
				"��������� � ������������ ����� � ������� \"�����\"",
				"�����", ""
			);
		}
		case REGISTER_STATE_REFER:
		{
			Dialog
			(
				playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT,
				"{66CCFF}��� ������������� ������",
				"{FFFFFF}���� �� ������ � ����� ������� �� ������ �����\n"\
				"������� ��� ������, ������� ��� ��� � ���� ����\n\n"\
				"{66CC66}��� ���������� ���� 4-�� ������ �� ������� ��������������",
				"������", "����������"
			);
		}
		case REGISTER_STATE_SEX:
		{
			Dialog
			(
				playerid, DIALOG_REGISTER, DIALOG_STYLE_MSGBOX,
				"{66CCFF}���",
				"{FFFFFF}�������� ��� ������ ���������",
				"�������", "�������"
			);
		}
		case REGISTER_STATE_RULES:
		{
			ShowServerRules(playerid, true);
		}
		case REGISTER_STATE_CREATE_ACC:
		{
			if(CreatePlayerAccount(playerid))
			{
				SetPlayerData(playerid, P_ACCOUNT_STATE, ACCOUNT_STATE_REG_SKIN);
			
				SetSpawnInfo(playerid, 0, 0, 332.2033, -174.1066, 999.6743, 1.0, 0, 0, 0, 0, 0, 0);
				SpawnPlayer(playerid);
			
				SendClientMessage(playerid, 0xFFFFFFFF, " ");
				SendClientMessage(playerid, 0xFFFFFFFF, "����������� ���������!");
				SendClientMessage(playerid, 0x66CC00FF, "������ �������� ��������� ������ ���������");
				SendClientMessage(playerid, 0xCECECEFF, "���������: ����������� {FF6600}������ ����� {CECECE}��� ������ ���������");
			}
			else 
			{
				SendClientMessage(playerid, 0xFF6600FF, "������ �������� ��������, ����������� � ��������� �������");
				Kick:(playerid);
			}
		}
		default:
			return 1;
	}
	
	SetPlayerData(playerid, P_ACCOUNT_STEP_STATE, step);
	return 1;
}

stock ShowServerRules(playerid, bool: reg = false)
{
	Dialog
	(
		playerid, reg ? DIALOG_REGISTER : DIALOG_PLAYER_STATS, DIALOG_STYLE_MSGBOX,
		"{66CCFF}������� �������",
		"{FFCD00}1. ��������\n"\
		"{FFFFFF}- ��������� ������������ ����� ����, ��������, ���� ��� CLEO �������\n"\
		"- �������� DeathMatch (DM) - �������� � ��������� ����� ������� ��� �������\n"\
		"- ��������� ������� ������� �� ������ (�� �����, ��� ��� ���������� � ����)\n"\
		"- ��������� �������� ����� ������ �� ���� ��� �������� �� ����\n"\
		"- ��������� ������� �� ����� � ����� �������� �� ����������\n"\
		"- ��������� ������������� ������������ ������� ��� �������� ��������� ������ �������\n\n"\
		"{FFCD00}2. ������� �������\n"\
		"{FFFFFF}- �������� ���, ����������� ������ �������\n"\
		"- ��������� ������ ������ ������� (�� ����������� � �������� ��������)\n"\
		"- ��������� ������ ���������� (�������� \"ya zawel na server\")\n"\
		"- ��������� ����� ������� ��������� ��������\n"\
		"- ��������� ������� (����� ��������� ���������� �����, ��� ����� ��� ��������� ��������)\n\n"\
		"{FFCD00}3. �������������\n"\
		"{FFFFFF}- ���������� �������� ������������� ������� � ����� ������� ��������� ������ ������\n"\
		"- ������������� �������������� �������� �������� ������� ��� ������� ����������� ������\n"\
		"- ������� ����� ����������� ����� ����� ��������� ��� ����� ����� (��������, ������������ ����������� ������)\n"\
		"- ���� �������� ������� ���� ��������� � ��� ��������, ��������� � ��������������",
		"�������", "������"
	);
}

stock GetPlayerHouseName(playerid)
{
	new name[32];
	new houseid = GetPlayerHouse(playerid);

	if(houseid != -1)
	{
		switch(GetPlayerData(playerid, P_HOUSE_TYPE))
		{
			case HOUSE_TYPE_HOME:
			{
				if(GetHouseData(houseid, H_ENTRACE) != -1)
				{
					format(name, sizeof name, "������� %d (�%d �� %d �����)", GetHouseData(houseid, H_ENTRACE) + 1, GetHouseData(houseid, H_FLAT_ID) + 1, GetHouseData(houseid, H_FLAT_ID) / 4 + 1);
				}
				else format(name, sizeof name, "%s (�%d)", GetHouseData(houseid, H_NAME), houseid);
			}
			case HOUSE_TYPE_ROOM:
			{
				format(name, sizeof name, "� ������ (��� �%d)", houseid);
			}
			case HOUSE_TYPE_HOTEL:
			{
				format(name, sizeof name, "��������� (�%d �� %d �����)", (GetPlayerData(playerid, P_HOUSE_ROOM) % 12) + 1, (GetPlayerData(playerid, P_HOUSE_ROOM) / 12) + 1);
			}
		}
	}
	else name = "���������";
	
	return name;
}

stock GetPlayerBizName(playerid)
{
	new name[32];
	new businessid = GetPlayerBusiness(playerid);
	
	if(businessid != -1)
	{
		format(name, sizeof name, "%s (�%d)", GetBusinessData(businessid, B_NAME),  businessid);
	}
	else name = "���";

	return name;
}

stock ShowPlayerStats(playerid, to_player = -1)
{
	if(to_player < 0)
		to_player = playerid;
		
	new fmt_str[1024];
	format
	(
		fmt_str, sizeof fmt_str, 
		"{FFFFFF}���:\t\t\t\t{0099FF}%s\n"\
		"{FFFFFF}�������:\t\t\t%d\n"\
		"���� �����:\t\t\t%d �� %d\n"\
		"����� ��������:\t\t%d\n"\
		"�� ����� ��������:\t\t%d ���\n"\
		"�����������������:\t\t%d\n"\
		"������� �������:\t\t%d\n"\
		"������� ���������:\t\t%d\n"\
		"����:\t\t\t\t%d\n"\
		"���������:\t\t\t%d\n"\
		"�������:\t\t\t%d\n"\
		"������:\t\t\t%d\n"\
		"���:\t\t\t\t%s\n"\
		"%s:\t\t\t%s\n\n"\
		"�����������:\t\t\t%s\n"\
		"������ / ���������:\t\t%s\n"\
		"����:\t\t\t\t%s\n\n"\
		"����������:\t\t\t%s\n"\
		"������:\t\t\t%s\n"\
		"������� ������:\t\t%s",
		GetPlayerNameEx(playerid),
		GetPlayerLevel(playerid),
		GetPlayerExp(playerid),
		GetExpToNextLevel(playerid),
		GetPlayerPhone(playerid),
		GetPlayerData(playerid, P_PHONE_BALANCE),
		GetPlayerData(playerid, P_LAW_ABIDING),
		GetPlayerSuspect(playerid),
		GetPlayerData(playerid, P_IMPROVEMENTS),
		GetPlayerData(playerid, P_POWER),
		GetPlayerData(playerid, P_DRUGS),
		GetPlayerData(playerid, P_AMMO),
		GetPlayerData(playerid, P_METALL),
		GetPlayerSexName(playerid),
		GetPlayerSex(playerid) ? ("������� ��") : ("����� ��"),
		GetPlayerData(playerid, P_WIFE_NAME),
		("���"), 		// P_TEAM | P_SUBDIVISON
		GetPlayerJobName(playerid),
		("�"), 			// P_JOB
		GetPlayerHouseName(playerid),
		GetPlayerBizName(playerid),
		("�������")
	);
	return Dialog(to_player, DIALOG_PLAYER_STATS, DIALOG_STYLE_MSGBOX, "{CC9900}���������� ������", fmt_str, "�����", "�������");
}

stock ShowPlayerCMDSDialog(playerid)
{
	Dialog
	(
		playerid, DIALOG_PLAYER_CMDS, DIALOG_STYLE_LIST,
		"{FFCD00}������ ������",
		"{99CC00}1. �������� ��������\n"\
		"2. ����� �������\n"\
		"3. �������\n"\
		"4. ����\n"\
		"5. ������ � ���\n"\
		"6. ������\n"\
		"7. ����� � �����\n"\
		"8. �������������\n"\
		"9. ������������ ���������� ���\n"\
		"10. ������������ �������\n"\
		"11. ���. ���������������\n"\
		"12. �� � �����\n"\
		"13. �������\n"\
		"14. ������",
		"�������", "�����"
	);
	return 1;
}

stock ShowPlayerSettings(playerid)
{	
	static const 
		chat_type_name[3][17] = {"{FF3333}��������", "{00CC00}��������", "{0099FF}RM-RP"};
	
	new s_info[256];
	format
	(
		s_info, sizeof s_info,
		"�������� ���\t\t%s\n"\
		"��� �����������\t%s\n"\
		"���� ��� ��������\t%s\n"\
		"���� � ����\t\t%s\n"\
		"ID ������� � ����\t%s\n"\
		"������. �����������\t%s\n"\
		"{888888}[��������� ���������]",
		chat_type_name[GetPlayerSettingData(playerid, S_CHAT_TYPE)],
		GetPlayerSettingData(playerid, S_TEAM_CHAT) 	? ("{00CC00}�������")  : ("{FF3333}��������"),
		GetPlayerSettingData(playerid, S_PLAYERS_NICK) 	? ("{00CC00}��������") : ("{FF3333}���������"),
		GetPlayerSettingData(playerid, S_NICK_IN_CHAT) 	? ("{00CC00}��������") : ("{FF3333}���������"),
		GetPlayerSettingData(playerid, S_ID_IN_CHAT) 	? ("{00CC00}��������") : ("{FF3333}���������"),
		GetPlayerSettingData(playerid, S_VEH_CONTROL) 	? ("{00CC00}������� � �������") : ("{FF9900}������ �������")
	);
	return Dialog(playerid, DIALOG_PLAYER_SETTINGS, DIALOG_STYLE_LIST, "{FFCD00}������ ���������", s_info, "���|����", "�����");
}

stock ShowPlayerSecuritySettings(playerid)
{
	Dialog
	(
		playerid, DIALOG_PLAYER_SECURITY_SETTINGS, DIALOG_STYLE_LIST,
		"{FFCD00}��������� ������������",
		"1. ���������� � ����������\n"\
		"2. ��������� �������\n"\
		"3. '���������' PIN-���\n"\
		"4. Google Authenticator\n"\
		"{00CC66}5. �������� ������\n"\
		"6. �������� '���������' PIN-���\n"\
		"{0099FF}7. ������ ������������\n"\
		"{999999}8. ����������� Email",
		"�������", "�����"
	);
}

stock ShowPlayerReportDialog(playerid)
{
	Dialog
	(
		playerid, DIALOG_REPORT, DIALOG_STYLE_INPUT,
		"{FFCD00}����� � ��������������",
		"{FFFFFF}������� ���� ��������� ��� ������������� �������\n"\
		"��� ������ ���� ������� � �����\n\n"\
		"{66CC66}���� �� ������ ������ ������ �� ������,\n"\
		"����������� ������� ��� ID � ������� ������",
		"���������", "�����"
	);
}

stock ShowPlayerChangeNameDialog(playerid)
{
	Dialog
	(
		playerid, DIALOG_CHANGE_NAME, DIALOG_STYLE_INPUT,
		"{FFCD00}��������� �����",
		"{FFFFFF}�� ������ �������� ��� ������ ���������, ���� ��� �� ������������� RP ��������\n"\
		"�� ���� ��������� ������� ����� ����� �������������� � {6699FF}/menu > �������������.\n\n"\
		"{FFFFFF}RP ��� ����� ������ ���_�������.\n"\
		"��������: Andrey_Ivanov, Nikolas_Ryan, Kate_Valente � �. �.\n\n"\
		"������� ����� ��� � ���� ����. ��������� ������ ��������� �������:",
		"��������", "�������"
	);
}

stock ShowPlayerImprovementsDialog(playerid)
{
	new fmt_str[67 + 1];
	new dest[((sizeof(fmt_str)-1) * (sizeof(g_player_improvements))) + 10 + 1];
	
	new str_numeric[14 + 1];
	new my_i_level = GetPlayerData(playerid, P_IMPROVEMENTS);
	
	for(new idx = 0; idx < sizeof g_player_improvements; idx ++)
	{
		format(fmt_str, sizeof fmt_str, "%d. %s\t\t", idx + 1, GetPlayerImprovementInfo(idx, I_NAME));
		if(idx == 2)
			strcat(fmt_str, "\t");
			
		if(my_i_level > idx)
		{
			strins(fmt_str, "{FFCD00}", 0);
			strcat(fmt_str, "�������\n");
			strcat(dest, fmt_str);
	
			continue;
		}
		else if(my_i_level < idx)
		{
			strins(fmt_str, "{FF3333}", 0);
		}
		else 
		{
			strcat(fmt_str, "{00CC00}");
		}
		strcat(dest, fmt_str);
		valfmt(str_numeric, GetPlayerImprovementInfo(idx, I_PRICE));
	
		format(fmt_str, sizeof fmt_str, "��������� %d ������� � %s ���\n", GetPlayerImprovementInfo(idx, I_LEVEL), str_numeric);
		strcat(dest, fmt_str);
	}
	strcat(dest, "����������");
	
	return Dialog(playerid, DIALOG_PLAYER_IMPROVEMENTS, DIALOG_STYLE_LIST, "{FFCD00}���������", dest, "�������", "�����");
}

stock SendMessageToAdmins(message[], color, a_level = 1)
{
	if(a_level < 1)
		a_level = 1;
	
	new count;
	foreach(new playerid : Player)
	{
		if(!IsPlayerLogged(playerid)) continue;
		if(GetPlayerAdminEx(playerid) < a_level) continue;
		
		SendClientMessage(playerid, color, message);
		count ++;
	}
	return count;
}

stock HidePlayerDialog(playerid)
{
	return Dialog(playerid, -1, DIALOG_STYLE_MSGBOX, "NULL", "NULL", "NULL", "NULL");
}

stock Shuffle(array[], size = sizeof array)
{
	new 
		index, 
		rand,
		buffer;
	
	for(index = 0; index < size; index ++)
	{
		rand = random(size);
		buffer = array[index];
		
		array[index] = array[rand];
		array[rand] = buffer;
	}
}

stock ShowPlayerPinCodePTD(playerid, s_state)
{
	if(GetPlayerPinCodeState(playerid) != PIN_CODE_STATE_NONE) return ;
	pin_code_input[playerid][0] = 0;
	
	switch(s_state)
	{
		case PIN_CODE_STATE_SET:
			SendClientMessage(playerid, 0x3399FFFF, "���������� ���� PIN-��� � �������� ���");
		
		case PIN_CODE_STATE_CHECK:
			SendClientMessage(playerid, 0xFFFF00FF, "�������� ��� ������� PIN-���");

		case PIN_CODE_STATE_CHANGE: 
			SendClientMessage(playerid, 0xFFFF00FF, "�������� ����� PIN-���");
		
		case PIN_CODE_STATE_LOGIN_CHECK:
			SendClientMessage(playerid, 0xFFFFFFFF, "������� ������������ ����������� ���� ������ ���������� PIN-����");
		
		default: 
			return ;
	
	}
	
	new values[10] = {0, 1, ...};
	new ch[2];
	Shuffle(values);
	
	new Float: add_pos_x, Float: add_pos_y;
	for(new idx = 0; idx < 10; idx ++)
	{
		add_pos_x = ((idx % 3) * 40.0);
		add_pos_y = ((idx / 3) * 40.0);
		
		if(idx == 9)
			add_pos_x += 40.0;
		
		valstr(ch, values[idx]);
		SetPlayerPinCodeValue(playerid, idx, values[idx]);
		
		pin_code_PTD[playerid][idx] = CreatePlayerTextDraw(playerid, 420.0 + add_pos_x, 170.0 + add_pos_y, ch);
		PlayerTextDrawTextSize(playerid, pin_code_PTD[playerid][idx], 445.0 + add_pos_x, 25.0);
		PlayerTextDrawLetterSize(playerid, pin_code_PTD[playerid][idx], 1.0, 3.0);
		PlayerTextDrawAlignment(playerid, pin_code_PTD[playerid][idx], 1);
		PlayerTextDrawBackgroundColor(playerid, pin_code_PTD[playerid][idx], 0x000000FF);
		PlayerTextDrawBoxColor(playerid, pin_code_PTD[playerid][idx], 0x80808080);
		PlayerTextDrawColor(playerid, pin_code_PTD[playerid][idx], 0xFFFFFFFF);
		PlayerTextDrawFont(playerid, pin_code_PTD[playerid][idx], 1);
		PlayerTextDrawSetOutline(playerid, pin_code_PTD[playerid][idx], 1);
		PlayerTextDrawSetProportional(playerid, pin_code_PTD[playerid][idx], 1);
		PlayerTextDrawSetShadow(playerid, pin_code_PTD[playerid][idx], 2);
		PlayerTextDrawUseBox(playerid, pin_code_PTD[playerid][idx], 1);
		PlayerTextDrawSetSelectable(playerid, pin_code_PTD[playerid][idx], 1);

		PlayerTextDrawShow(playerid, pin_code_PTD[playerid][idx]);
	}
	SelectTextDraw(playerid, 0x0066FFFF);

	SetPlayerPinCodeState(playerid, s_state);
}

stock HidePlayerPinCodePTD(playerid, bool: canel_select = true)
{
	if(GetPlayerPinCodeState(playerid) != PIN_CODE_STATE_NONE)
	{
		SetPlayerPinCodeState(playerid, PIN_CODE_STATE_NONE);
		
		if(canel_select)
			CancelSelectTextDraw(playerid);
		
		for(new idx = 0; idx < 10; idx ++)
		{
			PlayerTextDrawHide(playerid, pin_code_PTD[playerid][idx]);
			PlayerTextDrawDestroy(playerid, pin_code_PTD[playerid][idx]);
		}
	}
}

stock ShowCurrentTime(playerid)
{
	new 
		hour, minute, 
		year, month, day;
		
	gettime(hour, minute);
	getdate(year, month, day);
	
	SetPlayerChatBubble(playerid, "������ � ������ ������� �������...", 0xDD90FFFF, 25.0, 7000);
	if(!IsPlayerInAnyVehicle(playerid))
		ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_watch", 4.0, false, 0, 0, 0, 0, 0);
	
	new fmt_str[350];
	
	format(fmt_str, sizeof fmt_str, "~y~%d:%02d~n~~b~~h~%02d.%02d.%d", hour, minute, day, month, year);
	GameTextForPlayer(playerid, fmt_str, 3000, 1);
	
	format
	(
		fmt_str, sizeof fmt_str, 
		"{FFFFFF}������������!\n"\
		"�� ��������� � ������ ������� �������\n\n"\
		"����������� ����:\t\t{66CC00}%d %s %d �.\n"\
		"{FFFFFF}���� ������:\t\t\t{66CC00}%s\n"\
		"{FFFFFF}������� �����:\t\t{3399FF}%d:%02d\n\n"\
		"{FFFFFF}����� � ���� �� ���:\t\t{FF7000}%d ���\n"\
		"{FFFFFF}����� � ���� �������:\t\t{FF7000}%d � %d ���\n"\
		"{FFFFFF}����� � ���� �����:\t\t{FF7000}%d � %d ���",
		day,
		GetMonthName(month),
		year,
		GetDayName(GetDayOfWeek(year, month, day)),
		hour,
		minute,
		ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_HOUR), CONVERT_TIME_TO_MINUTES),
		ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_DAY), CONVERT_TIME_TO_HOURS),
		ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_DAY), CONVERT_TIME_TO_MINUTES),
		ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_DAY_PREV), CONVERT_TIME_TO_HOURS),
		ConvertUnixTime(GetPlayerData(playerid, P_GAME_FOR_DAY_PREV), CONVERT_TIME_TO_MINUTES)
	);
	SendClientMessage(playerid, 0x99CC00FF, "�� ��������� � ������ ������� �������");
	
	return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FFCD00}������ �����", fmt_str, "�������", "");
}

stock GetDayOfWeek(year, month, day)
{
    new a = (14 - month) / 12; 
    new y = year + 4800 - a; 
	new m = month + 12 * a - 3;
	new c_date = day + (153 * m + 2) / 5 + 365 * y + y / 4 - y / 100 + y / 400 - 32045;
	new day_of_week = c_date % 7 + 1;

    return day_of_week;
}

stock UpdateCharity()
{
	if(cache_is_valid(charity_cache_data))
	{
		cache_delete(charity_cache_data);
	}
	new Cache: result;
	
	result = mysql_query(mysql, "SELECT (SELECT a.name FROM accounts a WHERE a.id = c.uid) as name, SUM(c.money) as total FROM charity c GROUP BY c.uid ORDER BY total DESC LIMIT 25", true);
	charity_cache_data = result;
}

stock Dialog(playerid, dialogid, style, caption[], info[], button1[], button2[])
{
	SetPlayerData(playerid, P_LAST_DIALOG, dialogid);
	
	return ShowPlayerDialog(playerid, dialogid, style, caption, info, button1, button2);
}

stock IsNumeric(dest[], pos=0)
{
	new is_numeric = true;
	do
	{
		switch(dest[pos])
		{
			case '0'..'9': continue;
			default:
			{
				is_numeric = false;
				break;
			}
		}
	}
	while(dest[++pos]);
	
	return is_numeric;
}

stock valfmt(dest[], value, size = sizeof dest)
{	
	new buffer[15 + 1];
	valstr(buffer, value);
	
	new pos = strlen(buffer);
	while((pos -= 3) > 0)
	{
		strins(buffer, ".", pos);
	}
	format(dest, size, "%s", buffer);
}

stock GetSubnet(dest[], ip[], size = sizeof dest)
{
	new pos, dots;
	do
	{
		if(ip[pos] == '.')
		{
			if(++dots == 2) 
			{	
				ip[pos] = 0;
				break;
			}
		}
	}
	while(ip[++pos]);
	
	format(dest, size, "%s", ip);
}

stock GivePlayerMoneyEx(playerid, money, description[]="None", bool:save=true, bool:game_text=true)
{
	new fmt_str[185];
	AddPlayerData(playerid, P_MONEY, +, money);
	GivePlayerMoney(playerid, money);
	
	format(fmt_str, sizeof fmt_str, "INSERT INTO money_log (uid,uip,time,money,description) VALUES (%d,'%s',%d,%d,'%s')", GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), money, description);
	mysql_query(mysql, fmt_str, false);
	
	if(save)
	{
		format(fmt_str, sizeof fmt_str, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid), GetPlayerAccountID(playerid));
		mysql_query(mysql, fmt_str, false);
	}
	if(game_text)
	{
		format(fmt_str, sizeof fmt_str, "%s%d rub", money < 0 ? ("~r~") : ("~g~+"), money);
		GameTextForPlayer(playerid, fmt_str, 4000, 1);
	}
	return 1;
}

stock SendMessageInLocal(playerid, message[], color, Float: radius = 30.0)
{
	new virtual_world = GetPlayerVirtualWorld(playerid);
	new Float: x, Float: y, Float: z;
	GetPlayerPos(playerid, x, y, z);
	
	foreach(new idx : Player)
	{
		if(!IsPlayerLogged(idx)) continue;
		if(GetPlayerVirtualWorld(idx) != virtual_world) continue;
		if(!IsPlayerInRangeOfPoint(idx, radius, x, y, z)) continue;
		
		SendClientMessage(idx, color, message);
	}
	return 1;
}

stock Action(playerid, message[], Float:radius=25.0, bool:bubble=true)
{
	if(bubble)
		SetPlayerChatBubble(playerid, message, 0xDD90FFFF, radius, 7000);
		
	new fmt_str[128];

	format(fmt_str, sizeof fmt_str, "%s %s", GetPlayerNameEx(playerid), message);
	SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, radius);
	
	return 1;
}

stock EnablePlayerGPS(playerid, markertype, Float: x, Float: y, Float: z, message[] = "����� �������� � ��� �� GPS")
{
	SetPlayerGPSInfo(playerid, G_POS_X, x);
	SetPlayerGPSInfo(playerid, G_POS_Y, y);
	SetPlayerGPSInfo(playerid, G_POS_Z, z);
	
	SetPlayerMapIcon(playerid, 98, x, y, z, markertype, 0, MAPICON_GLOBAL);
	TextDrawShowForPlayer(playerid, gps_TD);
	
	if(strlen(message))
		SendClientMessage(playerid, 0xFFFF00FF, message);
		
	SetPlayerGPSInfo(playerid, G_ENABLED, GPS_STATUS_ON);
	
	return 1;
}

stock DisablePlayerGPS(playerid)
{
	if(GetPlayerGPSInfo(playerid, G_ENABLED) == GPS_STATUS_ON)
	{
		RemovePlayerMapIcon(playerid, 98);
		TextDrawHideForPlayer(playerid, gps_TD);
		
		SetPlayerGPSInfo(playerid, G_ENABLED, GPS_STATUS_OFF);
	}
	return 1;
}

stock IsPlayerInRangeOfPlayer(playerid, to_player, Float: distance)
{
	new Float: x, Float: y, Float: z;
	GetPlayerPos(to_player, x, y, z);
	
	return IsPlayerInRangeOfPoint(playerid, distance, x, y, z);
}

stock ApplyAnimationEx(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync, anim_type=USE_ANIM_TYPE_NONE)
{
	SetPlayerData(playerid, P_USE_ANIM_TYPE, anim_type);
	return ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);
}

stock SendPlayerOffer(playerid, to_player, type, value_1 = 0, value_2 = 0)
{
	if(GetPlayerOfferInfo(playerid, O_OUTCOMIG_PLAYER) == INVALID_PLAYER_ID)
	{
		new fmt_str[144];
		switch(type)
		{
			case OFFER_TYPE_HANDSHAKE:
			{
				format(fmt_str, sizeof fmt_str, "����� %s ���������� ������ ��� ����", GetPlayerNameEx(playerid));
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);
				
				SendClientMessage(to_player, 0xFFFFFFFF, "������� {00CC00}Y {FFFFFF}��� �������� ��� {FF6600}N {FFFFFF}��� ������");
				
				format(fmt_str, sizeof fmt_str, "�� ���������� %s ������ ����", GetPlayerNameEx(to_player));
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_SELL_FUEL_ST:
			{
				format(fmt_str, sizeof fmt_str, "%s ���������� ��� ������ ����������� ������� �%d \"%s\" �� ���� %d ���", GetPlayerNameEx(playerid), value_1, GetFuelStationData(value_1, FS_NAME), value_2);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);
				
				SendClientMessage(to_player, 0xFFFFFFFF, "������� {00CC00}Y {FFFFFF}����� ��������� ������ ��� {FF6600}N {FFFFFF}��� ������");
				
				format(fmt_str, sizeof fmt_str, "�� ���������� %s ������ ���� ����������� ������� \"%s\" �� %d ���", GetPlayerNameEx(to_player), GetFuelStationData(value_1, FS_NAME), value_2);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_FILL_CAR:
			{
				format(fmt_str, sizeof fmt_str, "%s ���������� ��������� ��� ��������� �� %d � �� %d ���", GetPlayerNameEx(playerid), value_1, value_2);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);
				
				SendClientMessage(to_player, 0xFFFFFFFF, "������� {00CC00}Y {FFFFFF}����� ����������� ��� {FF6600}N {FFFFFF}��� ������");
			
				format(fmt_str, sizeof fmt_str, "�� ���������� %s �������� ���������� �� %d � �� %d ���", GetPlayerNameEx(to_player), value_1, value_2);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);				
			}
			case OFFER_TYPE_REPAIR_CAR:
			{
				format(fmt_str, sizeof fmt_str, "%s ���������� �������� ��� ��������� �� %d ���", GetPlayerNameEx(playerid), value_1);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);
				
				SendClientMessage(to_player, 0xFFFFFFFF, "������� {00CC00}Y {FFFFFF}����� ����������� ��� {FF6600}N {FFFFFF}��� ������");
			
				format(fmt_str, sizeof fmt_str, "�� ���������� %s ������� ������ ���������� �� %d ���", GetPlayerNameEx(to_player), value_1);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);				
			}
			case OFFER_TYPE_SELL_BUSINESS:
			{
				format(fmt_str, sizeof fmt_str, "%s ���������� ��� ������ ������ �%d \"%s\" �� ���� %d ���", GetPlayerNameEx(playerid), value_1, GetBusinessData(value_1, B_NAME), value_2);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);
				
				SendClientMessage(to_player, 0xFFFFFFFF, "������� {00CC00}Y {FFFFFF}����� ��������� ������ ��� {FF6600}N {FFFFFF}��� ������");
				
				format(fmt_str, sizeof fmt_str, "�� ���������� %s ������ ��� ������ \"%s\" �� %d ���", GetPlayerNameEx(to_player), GetBusinessData(value_1, B_NAME), value_2);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_BUSINESS_MANAGER:
			{
				format(fmt_str, sizeof fmt_str, "%s ���������� ��� ����� ����������� ��� ����������� (%s)", GetPlayerNameEx(playerid), GetBusinessData(value_1, B_NAME));
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);
				
				SendClientMessage(to_player, 0xFFFFFFFF, "������� {00CC00}Y {FFFFFF}����� ����������� ��� {FF6600}N {FFFFFF}��� ������");
				
				format(fmt_str, sizeof fmt_str, "%s ������� ����������� ����� ����� �����������", GetPlayerNameEx(to_player));
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			case OFFER_TYPE_SELL_HOME:
			{
				format(fmt_str, sizeof fmt_str, "%s ���������� ��� ������ ��� �%d �� ���� %d ���", GetPlayerNameEx(playerid), value_1, value_2);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);
				
				SendClientMessage(to_player, 0xFFFFFFFF, "������� {00CC00}Y {FFFFFF}����� ��������� ������ ��� {FF6600}N {FFFFFF}��� ������");
			
				format(fmt_str, sizeof fmt_str, "�� ���������� %s ������ ��� ��� �� ���� %d ���", GetPlayerNameEx(to_player), value_2);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);	
			}
			case OFFER_TYPE_HOME_RENT_ROOM:
			{
				format(fmt_str, sizeof fmt_str, "%s ���������� ��� ���������� � ����� ���� �%d", GetPlayerNameEx(playerid), value_1);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);
	
				SendClientMessage(to_player, 0xFFFFFFFF, "������� {00CC00}Y {FFFFFF}����� ����������� ��� {FF6600}N {FFFFFF}��� ������");
			
				format(fmt_str, sizeof fmt_str, "�� ���������� %s ���������� � ����� ���� �%d", GetPlayerNameEx(to_player), value_1);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);			
			}
			case OFFER_TYPE_SELL_OWNABLE_CAR:
			{
				new model_id = GetVehicleData(value_2, V_MODELID);
			
				format(fmt_str, sizeof fmt_str, "%s ���������� ��� ������ ��������� {33FF66}\"%s\" {3399FF}�� ���� %d ���", GetPlayerNameEx(playerid), GetVehicleInfo(model_id-400, VI_NAME), value_1);
				SendClientMessage(to_player, 0x3399FFFF, fmt_str);
				
				SendClientMessage(to_player, 0xFFFFFFFF, "������� {00CC00}Y {FFFFFF}����� ������ ��� ��� {FF6600}N {FFFFFF}��� ������");
			
				format(fmt_str, sizeof fmt_str, "�� ���������� %s ������ ��� ��������� \"%s\" �� %d ���", GetPlayerNameEx(to_player), GetVehicleInfo(model_id-400, VI_NAME), value_1);
				SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			}
			/*
			case PROPOSITION_TYPE_SHOW_SKILL:
			{
				format(fmt_str, sizeof fmt_str, "%s ����� �������� ��� ���� ������ �������� �������", player_name[playerid]);
				Send(to_player, 0x3399FFFF, fmt_str);
				
				Send(to_player, -1, "������� {00CC00}Y {FFFFFF}��� ��������� ��� {FF6600}N {FFFFFF}��� ������");
				
				format(fmt_str, sizeof fmt_str, "�� ���������� %s ���������� �� ���� ������ �������� �������", player_name[to_player]);
				Send(playerid, 0x3399FFFF, fmt_str);
			}
			*/
			/*
			case PROPOSITION_TYPE_GIVE_CAR_KEY:
			{
				format(fmt_str, sizeof fmt_str, "%s ���������� ���� ��� ����� �� ������ ����������", player_name[playerid]);
				Send(to_player, 0x3399FFFF, fmt_str);
				
				Send(to_player, -1, "������� {00CC00}Y {FFFFFF}����� ����� �� ��� {FF6600}N {FFFFFF}��� ������");
			
				format(fmt_str, sizeof fmt_str, "�� ���������� ������ %s ����� ����� �� ������ ����������", player_name[to_player]);
				Send(playerid, 0x3399FFFF, fmt_str);			
			}
			case PROPOSITION_TYPE_SELL_GOODS:
			{
				new marketid = player_use_market[playerid];
			
				format(fmt_str, sizeof fmt_str, "%s ���������� ��� ������ %s �� ���� %d ���", player_name[playerid], market[marketid][m_name], value_1);
				Send(to_player, 0x3399FFFF, fmt_str);
				
				Send(to_player, -1, "������� {00CC00}Y {FFFFFF}����� ������� ������� ��� {FF6600}N {FFFFFF}��� ������");
			
				format(fmt_str, sizeof fmt_str, "�� ���������� %s ������ %s �� ���� %d ���", player_name[to_player], market[marketid][m_name], value_1);
				Send(playerid, 0x3399FFFF, fmt_str);	
			}
			case PROPOSITION_TYPE_INVITE:
			{	
				format(fmt_str, sizeof fmt_str, "%s ���������� ��� �������� � ����������� \"%s\"", player_name[playerid], GetPlayerTeamName(playerid));
				
				if(IsTeamSubdivision(g_player[playerid][org]))
					format(fmt_str, sizeof fmt_str, "%s, ������������� \"%s\"", fmt_str, GetPlayerSubdivisionName(playerid));
				Send(to_player, 0x3399FFFF, fmt_str);
			
				Send(to_player, -1, "������� {00CC00}Y {FFFFFF}����� ������� ����������� ��� {FF6600}N {FFFFFF}��� ������");
			
				format(fmt_str, sizeof fmt_str, "�� ���������� %s �������� � ����������� \"%s\"", player_name[to_player], GetPlayerTeamName(playerid));
				Send(playerid, 0x3399FFFF, fmt_str);
			}
			case PROPOSITION_TYPE_MEDHELP:
			{
				format(fmt_str, sizeof fmt_str, "%s ���������� ��� ������ ���� �������� ������� �� %d ���", player_name[playerid], value_1);
				Send(to_player, 0x3399FFFF, fmt_str);
				
				Send(to_player, -1, "������� {00CC00}Y {FFFFFF}����� ������ ��������-������� ��� {FF6600}N {FFFFFF}��� ������");
			
				format(fmt_str, sizeof fmt_str, "�� ���������� %s ������ � ��� ���� �������� ������� �� %d ���", player_name[to_player], value_1);
				Send(playerid, 0x3399FFFF, fmt_str);	
			}
			case PROPOSITION_TYPE_HEAL:
			{
				format(fmt_str, sizeof fmt_str, "%s ���������� ��� ������ ���� ������� �� %d ���", player_name[playerid], value_1);
				Send(to_player, 0x3399FFFF, fmt_str);
				
				Send(to_player, -1, "������� {00CC00}Y {FFFFFF}����� ����������� ��� {FF6600}N {FFFFFF}��� ������");
			
				format(fmt_str, sizeof fmt_str, "�� ���������� %s ������ � ��� ���� ������� �� %d ���", player_name[to_player], value_1);
				Send(playerid, 0x3399FFFF, fmt_str);	
			}
			case PROPOSITION_TYPE_CHANGE_SEX:
			{
				format(fmt_str, sizeof fmt_str, "%s ���������� ������� ��� �������� �� ����� ���� �� %d ���", player_name[playerid], value_1);
				Send(to_player, 0x3399FFFF, fmt_str);
				
				Send(to_player, -1, "������� {00CC00}Y {FFFFFF}����� ����������� ��� {FF6600}N {FFFFFF}��� ������");
			
				format(fmt_str, sizeof fmt_str, "�� ���������� %s �������� �� ����� ���� �� %d ���", player_name[to_player], value_1);
				Send(playerid, 0x3399FFFF, fmt_str);
			}
			*/
			default: return 1;
		}
		
		SetPlayerOfferInfo(playerid, O_OUTCOMIG_PLAYER, to_player);
		
		SetPlayerOfferInfo(to_player, O_INCOMING_PLAYER, playerid);
		SetPlayerOfferInfo(to_player, O_INCOMING_TYPE, type);
		
		SetPlayerOfferValue(to_player, 0, value_1);
		SetPlayerOfferValue(to_player, 1, value_2);
	}
	else SendClientMessage(playerid, 0xFFFFFFFF, "����������� {FF9900}/cancel {FFFFFF}����� �������� ���������� �����������");

	return 1;
}

// ------------------------------------------
CMD:yes(playerid, params[])
{
	new offer_id = GetPlayerOfferInfo(playerid, O_INCOMING_PLAYER);
	new offer_type = GetPlayerOfferInfo(playerid, O_INCOMING_TYPE);

	new value_1 = GetPlayerOfferInfo(playerid, O_INCOMING_VALUE)[0];
	new value_2 = GetPlayerOfferInfo(playerid, O_INCOMING_VALUE)[1];

	if(offer_id != INVALID_PLAYER_ID)
	{
		if(IsPlayerConnected(offer_id) && IsPlayerLogged(offer_id)) 
		{
			if(GetPlayerOfferInfo(offer_id, O_OUTCOMIG_PLAYER) == playerid)
			{
				ClearPlayerOffer(offer_id);
			}
			else offer_type = -1;
			
			new Float: x, Float: y, Float: z;
			new Float: dist;
			
			GetPlayerPos(offer_id, x, y, z);
			dist = GetPlayerDistanceFromPoint(playerid, x, y, z);
			
			if(dist <= 10.0)
			{
				new fmt_str[144];
				
				switch(offer_type)
				{
					/*
					case PROPOSITION_TYPE_SHOW_SKILL:
					{
						Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "test", "test", "test", "");
						Action(offer_id, "������� ���� ������ �������� �������", false);
					}
					*/
					
					case OFFER_TYPE_HANDSHAKE:
					{
						if(!(IsPlayerInAnyVehicle(playerid) && IsPlayerInAnyVehicle(offer_id)))
						{
							if(0.5 <= dist <= 1.5)
							{
								new Float: to_x, Float: to_y; 
								new Float: angle;
								
								GetPlayerPos(playerid, to_x, to_y, z);
								angle = GetAngleToPoint(x, y, to_x, to_y);
								
								SetPlayerFacingAngle(playerid, angle);
								SetPlayerFacingAngle(offer_id, angle + 180.0);
								
								format(fmt_str, sizeof fmt_str, "�����(�) ���� %s", GetPlayerNameEx(offer_id));
								Action(playerid, fmt_str, _, false);
								
								ApplyAnimation(playerid, "GANGS", "hndshkfa", 4.1, 0, 1, 1, 0, 0, 1);
								ApplyAnimation(offer_id, "GANGS", "hndshkfa", 4.1, 0, 1, 1, 0, 0, 1);
							}
							else 
							{
								valstr(fmt_str, offer_id);
								cmd::hi(playerid, fmt_str);
							}
						}
						else SendClientMessage(playerid, 0xCECECEFF, "�� ���� ����� �� ������ ���������� � ����������");
					}
					case OFFER_TYPE_SELL_FUEL_ST:
					{
						if(GetPlayerFuelStation(offer_id) == value_1 && GetPlayerFuelStation(playerid) == -1)
						{
							if(GetPlayerMoneyEx(playerid) >= value_2)
							{
								new Float: f_pos_x = GetFuelStationData(value_1, FS_POS_X);
								new Float: f_pos_y = GetFuelStationData(value_1, FS_POS_Y);
								new Float: f_pos_z = GetFuelStationData(value_1, FS_POS_Z);
								
								if(IsPlayerInRangeOfPoint(playerid, 10.0, f_pos_x, f_pos_y, f_pos_z) && IsPlayerInRangeOfPoint(offer_id, 10.0, f_pos_x, f_pos_y, f_pos_z))
								{
									format(fmt_str, sizeof fmt_str, "�� ������� ���� ��� ������ %s �� %d ���", GetPlayerNameEx(playerid), value_2);
									SendClientMessage(offer_id, 0x66CC00FF, fmt_str);	
									
									format(fmt_str, sizeof fmt_str, "%s ������ ��� ����������� ������� \"%s\" �� %d ���", GetPlayerNameEx(offer_id), GetFuelStationData(value_1, FS_NAME), value_2);
									SendClientMessage(playerid, 0x66CC00FF, fmt_str);		
									
									SellFuelStation(offer_id, playerid, value_2);
									SendClientMessage(playerid, 0xFFCD00FF, "��������� ���������� ���������� ���� ������, ��� ������������� �������� �� ����� � �����");
								}
								else SendClientMessage(playerid, 0xCECECEFF, "�� � �������� ������ ��������� ����� � ��������� ������� ������ ������");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "� ��� ������������ ����� ��� ���������� ������");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "��� ���������� ������ ��������� ������");
					}
					case OFFER_TYPE_FILL_CAR:
					{
						new vehicleid = GetPlayerVehicleID(playerid);
						new offer_vehicleid = GetPlayerVehicleID(offer_id);
						
						if(IsPlayerDriver(playerid)) 
						{
							if(GetPlayerJob(offer_id) == JOB_MECHANIC && IsPlayerInJob(offer_id) && IsPlayerInVehicle(offer_id, GetPlayerJobCar(offer_id)))
							{
								if((GetVehicleData(vehicleid, V_FUEL) + float(value_1)) <= 150.0)
								{
									if(GetPlayerMoneyEx(playerid) >= value_2)
									{
										if(GetPlayerJobLoadItems(offer_id) >= value_1)
										{
											GivePlayerMoneyEx(playerid, -value_2, "�������� ���������� �� ��������", true, true);
										
											SetVehicleData(vehicleid, V_FUEL, GetVehicleData(vehicleid, V_FUEL) + float(value_1));
											SetPlayerJobLoadItems(offer_id, GetPlayerJobLoadItems(offer_id) - value_1);
											
											AddPlayerData(offer_id, P_MECHANIC_FILL_PAY, +, value_2);
		
											format(fmt_str, sizeof fmt_str, "����������� %s �������� ��� ��������� �� %d �", GetPlayerNameEx(offer_id), value_1);
											SendClientMessage(playerid, 0x66CC00FF, fmt_str);	
											
											format(fmt_str, sizeof fmt_str, "�� ��������� ��������� %s �� %d �", GetPlayerNameEx(playerid), value_1);
											SendClientMessage(offer_id, 0x66CC00FF, fmt_str);

											format(fmt_str, sizeof fmt_str, "~g~+%d rub", value_2);
											GameTextForPlayer(offer_id, fmt_str, 4000, 1);
											
											format(fmt_str, sizeof fmt_str, "%s{FFFFFF}�����������\n{999999}�������: %d �", GetPlayerData(offer_id, P_JOB_SERVICE_NAME), GetPlayerJobLoadItems(offer_id));
											UpdateVehicleLabel(offer_vehicleid, 0xCC9900FF, fmt_str);
										}
										else SendClientMessage(playerid, 0xCECECEFF, "��� �������� ��������� ������");
									}
									else SendClientMessage(playerid, 0x999999FF, "� ��� ������������ ����� ����� ��������� ������������");
								}
								else SendClientMessage(playerid, 0xCECECEFF, "� �������� ����� ���������� ������� �� ����������");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "����������� ������ ��������� � ������� ����������");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "�� ������ ��������� � ���������� �� �����");
					}
					case OFFER_TYPE_REPAIR_CAR:
					{
						new vehicleid = GetPlayerVehicleID(playerid);

						if(IsPlayerDriver(playerid)) 
						{
							if(GetPlayerJob(offer_id) == JOB_MECHANIC && IsPlayerInJob(offer_id) && IsPlayerInVehicle(offer_id, GetPlayerJobCar(offer_id)))
							{
								if(GetPlayerMoneyEx(playerid) >= value_1)
								{
									GivePlayerMoneyEx(playerid, -value_1, "������� ���������� �� ��������", true, true);
									AddPlayerData(offer_id, P_MECHANIC_REPAIR_PAY, +, value_1);
									
									RepairVehicle(vehicleid);
									
									SetPlayerChatBubble(playerid, "Repair", 0x3399FFFF, 10.0, 2000);
									SetPlayerChatBubble(offer_id, "Repair", 0x3399FFFF, 10.0, 2000);
									
									format(fmt_str, sizeof fmt_str, "����������� %s ������� ��� ��������� �� %d ���", GetPlayerNameEx(offer_id), value_1);
									SendClientMessage(playerid, 0x66CC00FF, fmt_str);	
									
									format(fmt_str, sizeof fmt_str, "�� �������� ��������� %s �� %d ���", GetPlayerNameEx(playerid), value_1);
									SendClientMessage(offer_id, 0x66CC00FF, fmt_str);

									format(fmt_str, sizeof fmt_str, "~g~+%d rub", value_1);
									GameTextForPlayer(offer_id, fmt_str, 4000, 1);
								}
								else SendClientMessage(playerid, 0x999999FF, "� ��� ������������ ����� ����� ��������� ������������");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "����������� ������ ��������� � ������� ����������");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "�� ������ ��������� � ���������� �� �����");
					}
					case OFFER_TYPE_SELL_BUSINESS:
					{
						if(GetPlayerBusiness(offer_id) == value_1 && GetPlayerBusiness(playerid) == -1)
						{
							if(GetPlayerMoneyEx(playerid) >= value_2)
							{
								new Float: b_pos_x = GetBusinessData(value_1, B_POS_X);
								new Float: b_pos_y = GetBusinessData(value_1, B_POS_Y);
								new Float: b_pos_z = GetBusinessData(value_1, B_POS_Z);
								
								if(IsPlayerInRangeOfPoint(playerid, 7.0, b_pos_x, b_pos_y, b_pos_z) && IsPlayerInRangeOfPoint(offer_id, 7.0, b_pos_x, b_pos_y, b_pos_z))
								{
									format(fmt_str, sizeof fmt_str, "�� ������� ���� ������ ������ %s �� %d ���", GetPlayerNameEx(playerid), value_2);
									SendClientMessage(offer_id, 0x66CC00FF, fmt_str);	
									
									format(fmt_str, sizeof fmt_str, "%s ������ ��� ������ \"%s\" �� %d ���", GetPlayerNameEx(offer_id), GetFuelStationData(value_1, FS_NAME), value_2);
									SendClientMessage(playerid, 0x66CC00FF, fmt_str);		
									
									SellBusiness(offer_id, playerid, value_2);
									SendClientMessage(playerid, 0xFFCD00FF, "��������� ���������� ���������� ���� ������, ��� ������������� �������� �� ����� � �����");
								}
								else SendClientMessage(playerid, 0xCECECEFF, "�� � �������� ������ ��������� ����� � �������� ������� ������ ������");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "� ��� ������������ ����� ��� ���������� ������");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "��� ���������� ������ ��������� ������");
					}
					case OFFER_TYPE_BUSINESS_MANAGER:
					{
						if(GetPlayerBusiness(offer_id) == value_1)
						{
							SetPVarInt(playerid, "biz_worker", value_1 + 1);
						
							format(fmt_str, sizeof fmt_str, "�� ������� ����������� �� %s", GetPlayerNameEx(offer_id));
							SendClientMessage(playerid, 0x66CC00FF, fmt_str);	
							
							format(fmt_str, sizeof fmt_str, "%s ������ ���� �����������", GetPlayerNameEx(playerid));
							SendClientMessage(offer_id, 0x66CC00FF, fmt_str);
						}
					}
					case OFFER_TYPE_SELL_HOME:
					{
						if(GetPlayerHouse(offer_id, HOUSE_TYPE_HOME) == value_1 && GetPlayerHouse(playerid) == -1)
						{
							if(GetPlayerMoneyEx(playerid) >= value_2)
							{
								if(IsPlayerInRangeOfHouse(playerid, value_1, 10.0) && IsPlayerInRangeOfHouse(offer_id, value_1, 10.0))
								{
									format(fmt_str, sizeof fmt_str, "�� ������� ���� ��� ������ %s �� %d ���", GetPlayerNameEx(playerid), value_2);
									SendClientMessage(offer_id, 0x66CC00FF, fmt_str);	
									
									format(fmt_str, sizeof fmt_str, "%s ������ ��� c��� ��� �� %d ���", GetPlayerNameEx(offer_id), value_2);
									SendClientMessage(playerid, 0x66CC00FF, fmt_str);		
									
									SellHouse(offer_id, playerid, value_2);
									SendClientMessage(playerid, 0xFFCD00FF, "������������ ����������� ��������� ����������, ��� ������������� ��������� �� ��� � �����");
								}
								else SendClientMessage(playerid, 0xCECECEFF, "�� � �������� ������ ��������� ����� � ����� ������� ������ ������");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "� ��� ������������ ����� ��� ���������� ������");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "��� ���������� ������ ��������� ������");
					}
					case OFFER_TYPE_HOME_RENT_ROOM:
					{
						if(GetPlayerHouse(offer_id, HOUSE_TYPE_HOME) == value_1 && GetPlayerHouse(playerid) == -1)
						{
							if(IsPlayerInRangeOfHouse(playerid, value_1, 10.0) && IsPlayerInRangeOfHouse(offer_id, value_1, 10.0))
							{
								new free_room = GetHouseFreeRoom(value_1);
								if(free_room != -1)
								{
									AddHouseRenter(value_1, free_room, playerid);
		
									format(fmt_str, sizeof fmt_str, "�� �������� %s � ����� ����", GetPlayerNameEx(playerid));
									SendClientMessage(offer_id, 0x66CC00FF, fmt_str);	
									
									format(fmt_str, sizeof fmt_str, "%s ������� ��� � ����� ����", GetPlayerNameEx(offer_id));
									SendClientMessage(playerid, 0x66CC00FF, fmt_str);		
									
									GameTextForPlayer(offer_id, "~b~~h~Welcome", 4000, 1);
								}
								else SendClientMessage(playerid, 0x999999FF, "��� ������� ����� ���� ��� ������");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "�� � ������������ ������ ��������� ����� � ����� � ������� ������ ����� �������");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "��������� ������");
					}
					case OFFER_TYPE_SELL_OWNABLE_CAR:
					{
						if(GetPlayerOwnableCar(offer_id) == value_2 && GetPlayerOwnableCar(playerid) == INVALID_VEHICLE_ID)
						{
							new  Float: car_x, Float: car_y, Float: car_z; 
							GetVehiclePos(value_2, car_x, car_y, car_z);
							
							if(IsPlayerInRangeOfPoint(playerid, 15.0, car_x, car_y, car_z) && IsPlayerInRangeOfPoint(offer_id, 15.0, car_x, car_y, car_z))
							{
								if(GetPlayerMoneyEx(playerid) >= value_1)
								{
									new index = GetVehicleData(value_2, V_ACTION_ID);

									format(fmt_str, sizeof fmt_str, "UPDATE accounts a, ownable_cars oc SET a.money=%d, oc.owner_id=%d WHERE a.id=%d AND oc.id=%d", GetPlayerMoneyEx(playerid)-value_1, GetPlayerAccountID(playerid), GetPlayerAccountID(playerid), GetOwnableCarData(index, OC_SQL_ID));
									mysql_query(mysql, fmt_str, false);
									
									if(!mysql_errno())
									{
										GivePlayerMoneyEx(playerid, -value_1, "������� ���� � ���", false, true);
									
										GivePlayerMoneyEx(offer_id, value_1, "������� ���� � ���", true, true);
										SetPlayerData(offer_id, P_OWNABLE_CAR, INVALID_VEHICLE_ID);
										
										SetOwnableCarData(index, OC_OWNER_ID, GetPlayerAccountID(playerid));
										SetPlayerData(playerid, P_OWNABLE_CAR, value_2);
									
										format(fmt_str, sizeof fmt_str, "%s ������ ��� ���� ��������� �� %d ���", GetPlayerNameEx(offer_id), value_1);
										SendClientMessage(playerid, 0x66CC00FF, fmt_str);	
										
										SendClientMessage(playerid, 0x66CC00FF, "�������� {0099FF}/car {66CC00}����� ������ � ������������");	
										SendClientMessage(playerid, 0xFFFFFFFF, "��� ���� �������� ����� �� ����������. ����������� {BBBB00}/lock 1");
										
										format(fmt_str, sizeof fmt_str, "�� ������� ���� ��������� ������ %s �� %d ���", GetPlayerNameEx(playerid), value_1);
										SendClientMessage(offer_id, 0x66CC00FF, fmt_str);
									}
									else SendClientMessage(playerid, 0xFF6600FF, "��������� ������ � ���� ������");	
								}
								else SendClientMessage(playerid, 0xCECECEFF, "� ��� ������������ ����� ��� �������");
							}
							else SendClientMessage(playerid, 0xCECECEFF, "�� � �������� ������ ��������� ����� � ����������� ������� ������ ������");
						}
						else SendClientMessage(playerid, 0xCECECEFF, "��������� ������");
					}
					default:
						SendClientMessage(playerid, 0x999999FF, "� ������ ������ ��� ������ �� ����������");
				}
			}
			else SendClientMessage(playerid, 0x999999FF, "����� ������� ������");
		}
		else SendClientMessage(playerid, 0x999999FF, "����� ����� �� ����");
		
		ClearPlayerOffer(playerid);
	}
	else SendClientMessage(playerid, 0x999999FF, "� ������ ������ ��� ������ �� ����������"); 
	
	return 1;
}

CMD:no(playerid, params[])
{
	new offer_id = GetPlayerOfferInfo(playerid, O_INCOMING_PLAYER);
	
	if(offer_id != INVALID_PLAYER_ID) 
	{	
		if(GetPlayerOfferInfo(offer_id, O_OUTCOMIG_PLAYER) == playerid)
		{
			ClearPlayerOffer(offer_id);
			
			new fmt_str[64];
			format(fmt_str, sizeof fmt_str, "%s ��������� �� ������ �����������", GetPlayerNameEx(playerid));
			SendClientMessage(offer_id, 0xFF6600FF, fmt_str);
			
			format(fmt_str, sizeof fmt_str, "�� ���������� �� ����������� ������ %s", GetPlayerNameEx(offer_id));
			SendClientMessage(playerid, 0xFF6600FF, fmt_str);
			
			GameTextForPlayer(offer_id, "~r~no", 4000, 1);
		}
		else SendClientMessage(playerid, 0xFF6600FF, "�� ���������� �� ����������� ������");
	}
	else SendClientMessage(playerid, 0x999999FF, "� ������ ������ ��� ������ �� ����������"); 
	
	ClearPlayerOffer(playerid);
	return 1;
}

CMD:cancel(playerid, params[])
{
	new offer_id = GetPlayerOfferInfo(playerid, O_OUTCOMIG_PLAYER);
	
	if(offer_id != INVALID_PLAYER_ID) 
	{
		if(GetPlayerOfferInfo(offer_id, O_INCOMING_PLAYER) == playerid)
		{
			ClearPlayerOffer(offer_id);
			
			new fmt_str[64];
			format(fmt_str, sizeof fmt_str, "%s ������� ���� �����������", GetPlayerNameEx(playerid));
			SendClientMessage(offer_id, 0xFF6600FF, fmt_str);
			
			format(fmt_str, sizeof fmt_str, "�� �������� ���� ����������� ��� %s", GetPlayerNameEx(offer_id));
			SendClientMessage(playerid, 0xFF6600FF, fmt_str);
		}
		else SendClientMessage(playerid, 0xFF6600FF, "�� �������� ���� ��������� �����������");
		
		ClearPlayerOffer(playerid);
	}
	else SendClientMessage(playerid, 0xCECECEFF, "� ��� ��� �������� �����������");
	
	return 1;
}

CMD:hi(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) 
		return SendClientMessage(playerid, 0x999999FF, "������ ������������ � ������");
	
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "�����������: /hi [id ������]");
	
	extract params -> new to_player;
	
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) 
		return SendClientMessage(playerid, 0x999999FF, "������ ������ ���");

	new Float: to_x, Float: to_y, Float: z;
	GetPlayerPos(to_player, to_x, to_y, z);

	new Float: dist = GetPlayerDistanceFromPoint(playerid, to_x, to_y, z);
	if(0.5 <= dist <= 1.5)
	{
		SendPlayerOffer(playerid, to_player, OFFER_TYPE_HANDSHAKE);
	}
	else if(dist < 20.0)
	{
		new fmt_str[35];
		
		new Float: x, Float: y;
		new Float: angle;
		
		GetPlayerPos(playerid, x, y, z);
		angle = GetAngleToPoint(to_x, to_y, x, y);
		
		SetPlayerFacingAngle(playerid, angle);
		
		format(fmt_str, sizeof fmt_str,"����� ����� %s", GetPlayerNameEx(to_player));
		Action(playerid, fmt_str, _, false);

		ApplyAnimation(playerid, "PED", "endchat_03", 4.1, 0, 1, 1, 0, 0, 1);
	}
	else SendClientMessage(playerid, 0x999999FF, "�� ���������� ������� ������ �� ������");
	
	return 1;
}

CMD:me(playerid, params[])
{
	//if(IsPlayerMuted(playerid))
	//	return SendClientMessage(playerid, 0xFF6600FF, "�� �� ������ ������������ ���");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "�����������: /me [�����]");
	
	return Action(playerid, params);
}

CMD:do(playerid, params[])
{
	//if(IsPlayerMuted(playerid))
	//	return SendClientMessage(playerid, 0xFF6600FF, "�� �� ������ ������������ ���");
	
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "�����������: /do [�����]");
	
	new fmt_str[128];
	SetPlayerChatBubble(playerid, params, 0xDD90FFFF, 25.0, 5000);
	
	format(fmt_str, sizeof fmt_str, "%s (%s)", params, GetPlayerNameEx(playerid));
	SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);
	
	return 1;
}

CMD:try(playerid, params[])
{
	//if(IsPlayerMuted(playerid))
	//	return SendClientMessage(playerid, 0xFF6600FF, "�� �� ������ ������������ ���");
	
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "�����������: /try [�����]");
	
	new fmt_str[128];
	
	format(fmt_str, sizeof fmt_str, "%s %s %s", GetPlayerNameEx(playerid), params, !random(3) ? ("{66CC00}| ������") : ("{FF6600}| ��������"));
	SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);
	
	return 1;
}

CMD:w(playerid, params[])
{
	//if(IsPlayerMuted(playerid))
	//	return SendClientMessage(playerid, 0xFF6600FF, "�� �� ������ ������������ ���");
	
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "�����������: /w [�����]");
	
	new fmt_str[128];
	SetPlayerChatBubble(playerid, params, 0xACCE90FF, 3.0, 5000);
	
	format(fmt_str, sizeof fmt_str, "%s ������: %s", GetPlayerNameEx(playerid), params);
	SendMessageInLocal(playerid, fmt_str, 0xACCE90FF, 3.0);

	return 1;
}

CMD:s(playerid, params[])
{
	if(GetPlayerLevel(playerid) >= 2)
		return SendClientMessage(playerid, 0xCECECEFF, "���� ����� ������������ �� 2 ������");
		
	//if(IsPlayerMuted(playerid))
	//	return SendClientMessage(playerid, 0xFF6600FF, "�� �� ������ ������������ ���");
	
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "�����������: /s [�����]");
	
	new fmt_str[128];
	SetPlayerChatBubble(playerid, params, 0xFFFFFFFF, 37.0, 5000);
	
	format(fmt_str, sizeof fmt_str, "%s[%d] �������: %s", GetPlayerNameEx(playerid), playerid, params);
	SendMessageInLocal(playerid, fmt_str, 0xFFFFFFFF, 37.0);
	
	ApplyAnimation(playerid, "ON_LOOKERS", "shout_01", 4.0, 0, 0, 0, 0, 0, 0);
	return 1;
}

CMD:n(playerid, params[])
{
	//if(IsPlayerMuted(playerid))
	//	return SendClientMessage(playerid, 0xFF6600FF, "�� �� ������ ������������ ���");
	
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "�����������: /n [���-�� ���������]");
	
	new fmt_str[128];
	SetPlayerChatBubble(playerid, params, 0x999999FF, 30.0, 5000);
	
	format(fmt_str, sizeof fmt_str, "(( %s[%d]: %s ))", GetPlayerNameEx(playerid), playerid, params);
	SendMessageInLocal(playerid, fmt_str, 0xCCCC99FF, 30.0);
	
	return 1;
}

CMD:lic(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, 0x999999FF, "�����������: /lic [id ������]");
	
	extract params -> new to_player;
	
	if(!IsPlayerConnected(to_player))
		return SendClientMessage(playerid, 0x999999FF, "������ ������ ���");
		
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 4.0))
		return SendClientMessage(playerid, 0x999999FF, "����� ��������� ������� ������");
	
	static const
		lic_names[3][32 + 1] = {"{FF9900}�����������", "{00CC33}������� �������", "{6699CC}���������������� �������"};
		
	new fmt_str[64];
	Action(playerid, "������� ���� ��������", _, false);
	
	format(fmt_str, sizeof fmt_str, "�������� %s:", GetPlayerNameEx(playerid));
	SendClientMessage(to_player, 0xFFFF00FF, fmt_str);
	
	format(fmt_str, sizeof fmt_str, "�� ���������: %s", lic_names[ GetPlayerData(playerid, P_DRIVING_LIC) ]);
	SendClientMessage(to_player, 0xFFFFFFFF, fmt_str);
	
	format(fmt_str, sizeof fmt_str, "�� ������:     %s", GetPlayerData(playerid, P_WEAPON_LIC) >= 1 ? ("{00CC33}����") : ("{FF9900}�����������"));
	SendClientMessage(to_player, 0xFFFFFFFF, fmt_str);

	return 1;
}

CMD:pass(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, 0x999999FF, "�����������: /pass [id ������]");
		
	extract params -> new to_player; 
	
	if(!IsPlayerConnected(to_player))
		return SendClientMessage(playerid, 0x999999FF, "������ ������ ���");
		
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0x999999FF, "����� ��������� ������� ������");
		
	new fmt_str[128];
	Action(playerid, "������� ���� �������", _, false);
	
	format(fmt_str, sizeof fmt_str, "���: %s  |  �������: %d  |  ���: %s  |  ����������: %s", GetPlayerNameEx(playerid), GetPlayerLevel(playerid), GetPlayerSexName(playerid), GetPlayerHouseName(playerid));
	SendClientMessage(to_player, 0xFFFFFFFF, fmt_str);
	
	format(fmt_str, sizeof fmt_str, "������: %s  |  ����������� � �������������: %s / %s", GetPlayerJobName(playerid), ("���"), ("���"));
	SendClientMessage(to_player, 0xFFFFFFFF, fmt_str);
	
	format(fmt_str, sizeof fmt_str, "�������: %d  |  ������� �������: %d  |  �����������������: %d", GetPlayerPhone(playerid), GetPlayerSuspect(playerid), GetPlayerData(playerid, P_LAW_ABIDING));
	SendClientMessage(to_player, 0xFFFFFFFF, fmt_str);
	
	return 1;
}

CMD:gmx(playerid, params[])
{
	return GameModeExit();
}

CMD:menu(playerid, params[])
{
	Dialog
	(
		playerid, DIALOG_PLAYER_MENU, DIALOG_STYLE_LIST,
		"{0099CC}���� ������",
		"1. ����������\n"\
		"2. ������ ������\n"\
		"3. ������ ���������\n"\
		"4. ��������� ������������\n"\
		"5. ����� � ��������������\n"\
		"6. ���������\n"\
		"7. ������� �������\n"\
		"8. �������� ���\n"\
		"9. �������������",
		"�������", "�������"
	);
	return 1;
}
ALT:menu:mn;

CMD:gps(playerid, params[])
{
	DisablePlayerGPS(playerid);
	
	Dialog
	(
		playerid, DIALOG_GPS, DIALOG_STYLE_LIST,
		"{FFCD00}GPS",
		"1. ������������ �����\n"\
		"2. ������������ ����\n"\
		"3. ��������������� �����������\n"\
		"4. ���� ���� � �����\n"\
		"5. �� ������\n"\
		"6. �����\n"\
		"7. �����������\n"\
		"8. ������\n"\
		"9. ����� ��������� ���",
		"�������", "�������"
	);
	return 1;
}

CMD:help(playerid, params[])
{
	Dialog
	(
		playerid, DIALOG_HELP, DIALOG_STYLE_LIST, 
		"{00CC33}������ �� ����", 
		help_info_items, 
		"�������", "�������"
	);
	
	return 1;
}

CMD:play(playerid, params[])
{
	if(GetPVarInt(playerid, "server_radio_enabled") == 1)
	{
		StopAudioStreamForPlayer(playerid);
		DeletePVar(playerid, "server_radio_enabled");
		
		SendClientMessage(playerid, 0xFF6600FF, "����� ���������");
	}

	Dialog
	(
		playerid, DIALOG_SERVER_RADIO, DIALOG_STYLE_LIST,
		"{FFCD00}������ �����",
		g_server_radio_items,
		"�������", "�������"
	);
	return 1;
}

CMD:anim(playerid, params[])
{	
	if(IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "�������� ������ ������������ � ����������");
	
	if(PreLoadPlayerAnimList(playerid))
		return SendClientMessage(playerid, 0xFFFF00FF, "������ �������� ��������. ������� ������� ��� ���");

	if(!strlen(params))
	{
		Dialog
		(
			playerid, DIALOG_ANIM_LIST, DIALOG_STYLE_LIST, 
			"{9966FF}��������",
			anim_list_items, 
			"�������", "�������"
		);
	}
	else 
	{
		extract params -> new anim_id;
		
		if(!SetPlayerAnimation(playerid, anim_id-1))
			return SendClientMessage(playerid, 0xCECECEFF, "����������� /anim(list) [����� �������� �� ������]");
	}
	return 1;
}
ALT:anim:animlist;

CMD:e(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	
	if(!IsABike(vehicleid))
	{
		if(!IsPlayerDriver(playerid))
			return SendClientMessage(playerid, 0xCECECEFF, "�� �� �� �����");
		
		if(IsAOwnableCar(vehicleid))
		{
			new index = GetVehicleData(vehicleid, V_ACTION_ID);		
			if(!GetOwnableCarData(index, OC_KEY_IN))
			{
				return GameTextForPlayer(playerid, "~n~~n~~n~~r~~h~K��� �E BC�AB�E�", 1200, 5);
			}
		}
		else if(IsAJobCar(vehicleid))
		{
			if(GetPlayerJobCar(playerid) != vehicleid)
			{
				return RemovePlayerFromVehicle(playerid);
			}
		}
		
		if(GetVehicleData(vehicleid, V_FUEL) <= 0.0)
			return GameTextForPlayer(playerid, "~r~no fuel", 4000, 1);
		
		new engine = (GetVehicleParam(vehicleid, V_ENGINE) ^ VEHICLE_PARAM_ON);
		SetVehicleParam(vehicleid, V_ENGINE, engine);
	}
	return 1;
}

CMD:l(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	
	if(!IsABike(vehicleid))
	{
		if(!IsPlayerDriver(playerid))
			return SendClientMessage(playerid, 0xCECECEFF, "�� �� �� �����");
	
		new lights = (GetVehicleParam(vehicleid, V_LIGHTS) ^ VEHICLE_PARAM_ON);
		SetVehicleParam(vehicleid, V_LIGHTS, lights);
	}
	return 1;
}

CMD:sl(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	
	if(!IsABike(vehicleid))
	{
		if(!IsPlayerDriver(playerid))
			return SendClientMessage(playerid, 0xCECECEFF, "�� �� �� �����");
		
		new limit = (GetVehicleData(vehicleid, V_LIMIT) ^ VEHICLE_PARAM_ON);
		SetVehicleData(vehicleid, V_LIMIT, limit);
	}
	return 1;
}

CMD:b(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	
	if(!IsABike(vehicleid))
	{
		if(!IsPlayerDriver(playerid))
			return SendClientMessage(playerid, 0xCECECEFF, "�� �� �� �����");
	
		Dialog
		(
			playerid, DIALOG_OPEN_HOOD_OR_TRUNK, DIALOG_STYLE_MSGBOX, 
			" ", 
			"\t{CC9900}���������� ����", 
			"�����", "��������"
		);	
	}
	return 1;
}

CMD:i(playerid, params[])
{	
	new vehicleid = GetPlayerVehicleID(playerid);
	
	if(!IsABike(vehicleid))
	{
		if(!IsPlayerDriver(playerid))
			return SendClientMessage(playerid, 0xCECECEFF, "�� �� �� �����");
	
		new stationid = GetNearestFuelStation(playerid, 10.0);
		if(stationid != -1) 
		{
			FuelStationFillCar(playerid, vehicleid, stationid);
		}
		else SendClientMessage(playerid, 0xCECECEFF, "���������� ��� ����������� �������");
	}
	return 1;
}

CMD:alarm(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	
	if(!IsABike(vehicleid))
	{
		if(!IsPlayerDriver(playerid))
			return SendClientMessage(playerid, 0xCECECEFF, "�� �� �� �����");
		
		new alarm = (GetVehicleData(vehicleid, V_ALARM) ^ VEHICLE_PARAM_ON);
		SetVehicleData(vehicleid, V_ALARM, alarm);	
	}
	return 1;
}

CMD:charity(playerid, params[])
{
	new Cache: result;
	new rows; 
	new money;
	new fmt_str[75];
	new string[1024];
	
	cache_set_active(charity_cache_data);
	rows = cache_num_rows();
	
	string = "�����\t\t���\n\n{FFFFFF}";
	for(new idx; idx < rows; idx ++)
	{
		cache_get_row(idx, 0, fmt_str);
		money = cache_get_row_int(idx, 1);
		
		format(fmt_str, sizeof fmt_str, "%d ���\t\t%s\n", money, fmt_str);
		strcat(string, fmt_str);
	}
	cache_set_active(Cache:0); //unset active cache
	
	format(fmt_str, sizeof fmt_str, "SELECT SUM(money) as money FROM charity WHERE uid=%d LIMIT 1", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, fmt_str, true);

	money = cache_get_row_int(0, 0);
	cache_delete(result);
	
	format(fmt_str, sizeof fmt_str, "\n{999999}����� ����� �������������: %d ���", money);
	strcat(string, fmt_str);
	
	return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{00CC00}��� 25 ���������������", string, "�������", "");
}

CMD:bank(playerid, params[])
{
	//if(GetPlayerLevel(playerid) < 4)
	//	return SendClientMessage(playerid, 0x999999FF, "������������ ���������������� ������� ����� � 4 ������");

	if(IsPlayerInRangeOfPoint(playerid, 35.0, 909.5200, -785.9926, 1000.5416))
	{
		ShowPlayerBankDialog(playerid);
	}
	else SendClientMessage(playerid, 0xCECECEFF, "�� �� � �����");
	
	return 1;
}

CMD:time(playerid, params[])
{
	new TODO; // ����� � �����, ���
	
	return SendClientMessage(playerid, 0xFFFFFFFF, "����������� {6699FF}/c 060 {FFFFFF}(������ ������� �������)");
}

CMD:take(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetPlayerTempJob(playerid) == TEMP_JOB_LOADER)
	{
		if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_LOADER)
		{
			new TODO;
			
			return 1;
		}
	}
	return SendClientMessage(playerid, 0x999999FF, "�� ������ �������� �� ����������");
}

CMD:id(playerid, params[])
{
	if(!strlen(params)) 
		return SendClientMessage(playerid, 0xCECECEFF, "�����������: /id [��� ��� ����� ����� ������]");
	
	new fmt_str[64];
	new count;
	
	foreach(new idx : Player)
	{
		if(!IsPlayerLogged(idx)) continue;
		
		if(strfind(GetPlayerNameEx(idx), params, true) != -1)
		{
			count ++;
			
			format(fmt_str, sizeof fmt_str, "%d. %s {66CC66}id %d", count, GetPlayerNameEx(idx), idx);
			SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
	
			if(count >= 5)
			{
				SendClientMessage(playerid, 0x999999FF, "�������� ������ 5 ����������");
				break;
			}
		}
	}
	if(!count) 
		SendClientMessage(playerid, 0x999999FF, "���������� �� �������");
		
	return 1;
}

CMD:buyf(playerid, params[])
{	
	new factory_fuels = GetRepositoryData(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F, R_AMOUNT);
	
	if(!IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, 0x999999FF, "�� ������ ���������� �� ����������� � ������� ����������");

	new modelid; 
	new vehicleid = GetPlayerJobCar(playerid);
	
	if(vehicleid != INVALID_VEHICLE_ID)
		modelid = GetVehicleData(vehicleid, V_MODELID);
	
	if(IsPlayerInRangeOfPoint(playerid, 20.0, 994.1306, 679.8422, 12.0653))  // ��� ������
	{
		if(GetPlayerTempJob(playerid) != TEMP_JOB_FACTORY_TRUCKER || modelid != 514)
			return SendClientMessage(playerid, 0xCECECEFF, "�� �� ��������� � ������ �������� ������ ��� ������ �� �� �����");
	}
	else if(IsPlayerInRangeOfPoint(playerid, 25.0, 935.9503, 662.1276, 12.0029))  // ��� ���
	{
		if(GetPlayerJob(playerid) != JOB_TRUCKER || modelid != 514)
			return SendClientMessage(playerid, 0xCECECEFF, "�� �� ��������� ����������� ������� ��� ������ �� �� �����");
	}
	else 
		return SendClientMessage(playerid, 0x999999FF, "�� ������ ���������� �� �����������");
	
	new total_litres = GetPlayerJobLoadItems(playerid);

	if(!IsPlayerInVehicle(playerid, vehicleid))
		return SendClientMessage(playerid, 0x999999FF, "�� ������ ���������� �� ����������� � ������� ����������");
	
	if(!strlen(params))
		return SendClientMessage(playerid, 0x999999FF, "�����������: /buyf [���-�� � ������]");
	
	if(!IsTrailerAttachedToVehicle(vehicleid))
		return SendClientMessage(playerid, 0xCECECEFF, "� ������ ���������� ����������� �������� ��� �������"); 
		
	extract params -> new load_fuel;
	
	if(!(1 <= load_fuel <= 8000))
		return SendClientMessage(playerid, 0x999999FF, "����� ��������� �� 1 �� 8000 � �������");
	
	if(factory_fuels < load_fuel)
		return SendClientMessage(playerid, 0x999999FF, "�� ����������� ��� ������ ���������� �������");
		
	if((total_litres + load_fuel) > 8000) 
		return SendClientMessage(playerid, 0xCECECEFF, "� �������� ������� �� ����������");
		
	if(GetPlayerMoneyEx(playerid) < (load_fuel * 10))
		return SendClientMessage(playerid, 0x999999FF, "������������ ����� ��� ������� ������ ���������� �������");
	
	GivePlayerMoneyEx(playerid, -(load_fuel * 10), "������� ������� (����������)", true, false);
	
	SetRepositoryData(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F, R_AMOUNT, factory_fuels - load_fuel);
	UpdateRepository(REPOSITORY_TYPE_OIL_FACTORY, REPOSITORY_ACTION_OIL_FACTORY_F);
	
	SetPlayerJobLoadItems(playerid, total_litres + load_fuel);
	
	new fmt_str[64];
	
	format(fmt_str, sizeof fmt_str, "�� ��������� %d � ������� ����� ���������� %d ���", load_fuel, load_fuel * 10);
	SendClientMessage(playerid, 0xFFFF00FF, fmt_str);
	
	format(fmt_str, sizeof fmt_str, "~g~+ %d litres~n~~b~total %d litres", load_fuel, total_litres + load_fuel);
	GameTextForPlayer(playerid, fmt_str, 2000, 6);
	
	format(fmt_str, sizeof fmt_str, "�������� �������\n{FFFFFF}�������� %d / 8000 �", total_litres + load_fuel);
	UpdateVehicleLabel(vehicleid, 0xFF6600FF, fmt_str);
	
	return 1;
}

CMD:sellf(playerid, params[])
{
	new modelid; 
	new vehicleid = GetPlayerJobCar(playerid);
	
	if(vehicleid != INVALID_VEHICLE_ID)
		modelid = GetVehicleData(vehicleid, V_MODELID);
	
	if(GetPlayerTempJob(playerid) != TEMP_JOB_FACTORY_TRUCKER || modelid != 514)
		return SendClientMessage(playerid, 0xCECECEFF, "�� �� ��������� � ������ �������� ������");
	
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, -1111.9989, 2169.4163, 38.0353)) 
		return SendClientMessage(playerid, 0xCECECEFF, "�� ������ ���������� � ������ ������� ������");
	
	new total_litres = GetPlayerJobLoadItems(playerid);
	
	new factory_fuels = GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL, R_AMOUNT);
	
	if(!strlen(params))
		return SendClientMessage(playerid, 0x999999FF, "�����������: /sellf [���-�� � ������]");
		
	extract params -> new sell_fuels;
	
	if(!(1 <= sell_fuels <= 8000)) 
		return SendClientMessage(playerid, 0x999999FF, "����� ������� �� 1 �� 8000 � �������");
	
	if(vehicleid == INVALID_VEHICLE_ID || !IsTrailerAttachedToVehicle(vehicleid) || total_litres < sell_fuels) 
		return SendClientMessage(playerid, 0x999999FF, "� ����� ���� ��� ������ ���������� ������� ��� �������� �� ����������");
	
	if((factory_fuels + sell_fuels) > 1000000) 
		return SendClientMessage(playerid, 0x999999FF, "����� ������� ������ ��������");

	GivePlayerMoneyEx(playerid, (sell_fuels * 12), "������� ������� (�����)", true, true);

	SetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL, R_AMOUNT, factory_fuels + sell_fuels);
	UpdateRepository(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL);
	
	SetPlayerJobLoadItems(playerid, total_litres - sell_fuels);
	AddPlayerData(playerid, P_JOB_WAGE, +, sell_fuels * 2);
	
	new fmt_str[64];

	format(fmt_str, sizeof fmt_str, "�� ������� ������ %d � ������� �� ����� %d ���", sell_fuels, sell_fuels * 12);
	SendClientMessage(playerid, 0x66CC00FF, fmt_str);
	
	format(fmt_str, sizeof fmt_str, "���� ������ ������� ���������� {FF9900}%d ���", sell_fuels * 2);
	SendClientMessage(playerid, 0x66CC00FF, fmt_str);
	
	format(fmt_str, sizeof fmt_str, "�������� �������\n{FFFFFF}�������� %d / 8000 �", total_litres - sell_fuels);
	UpdateVehicleLabel(vehicleid, 0xFF6600FF, fmt_str);
	
	return 1;
}

CMD:buym(playerid, params[])
{
	new modelid; 
	new vehicleid = GetPlayerJobCar(playerid);
	
	if(vehicleid != INVALID_VEHICLE_ID)
		modelid = GetVehicleData(vehicleid, V_MODELID);
	
	if(GetPlayerTempJob(playerid) != TEMP_JOB_FACTORY_TRUCKER || modelid != 406)
		return SendClientMessage(playerid, 0xCECECEFF, "�� �� �������� ������ �������� ������");
		
	if(!strlen(params))
		return SendClientMessage(playerid, 0x999999FF, "�����������: /buym [���-�� � ��]");	
		
	extract params -> new buy_metal_count;
	
	new metall_loaded_count = GetPlayerJobLoadItems(playerid);
	new miner_metal = GetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL, R_AMOUNT);
	
	if(!IsPlayerInRangeOfPoint(playerid, 15.0, 2317.2356, 1741.5924, 1.2725) || !IsPlayerInVehicle(playerid, vehicleid)) 
		return SendClientMessage(playerid, 0x999999FF, "�� ������ ���������� � ������ ����� � ������� ����������");
		
	if(!(1 <= buy_metal_count <= 500)) 
		return SendClientMessage(playerid, 0x999999FF, "����� ��������� �� 1 �� 500 �� �������");
		
	if(miner_metal < buy_metal_count) 
		return SendClientMessage(playerid, 0x999999FF, "�� ������ ����� ��� ������ ���������� �������");
	
	if((metall_loaded_count + buy_metal_count) > 500) 
		return SendClientMessage(playerid, 0xCECECEFF, "� ������ ������� �� ����������");
		
	if(GetPlayerMoneyEx(playerid) < (buy_metal_count * 15))
		return SendClientMessage(playerid, 0x999999FF, "������������ ����� ��� ������� ������ ���������� �������");

	GivePlayerMoneyEx(playerid, -(buy_metal_count * 15), "������� ������� (���������)", true, true);

	SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL, R_AMOUNT, miner_metal - buy_metal_count);
	UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL);

	SetPlayerJobLoadItems(playerid, metall_loaded_count + buy_metal_count);
	
	new fmt_str[64];
	
	format(fmt_str, sizeof fmt_str, "�� ��������� %d �� ������� ����� ���������� %d ���", buy_metal_count, buy_metal_count * 15);
	SendClientMessage(playerid, 0xFFFF00FF, fmt_str);
	
	format(fmt_str, sizeof fmt_str, "�������� �������\n{FFFFFF}�������� %d / 500 ��", metall_loaded_count + buy_metal_count);
	UpdateVehicleLabel(vehicleid, 0x3399FFFF, fmt_str);
	
	return 1;
}

CMD:sellm(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, 0x999999FF, "�����������: /sellm [���-�� � ��]");
		
	extract params -> new sell_metal_count;
	
	if(!IsPlayerInRangeOfPoint(playerid, 20.0, -1042.5638, 2170.3940, 38.3904))
		return SendClientMessage(playerid, 0xCECECEFF, "�� ������ ���������� � ������ ������� ������");
	
	if(!(1 <= sell_metal_count <= 500)) 
		return SendClientMessage(playerid, 0x999999FF, "����� ������� �� 1 �� 500 �� �������");
	
	new factory_metal = GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL, R_AMOUNT);
	
	if((factory_metal + sell_metal_count) > 1_000_000) 
		return SendClientMessage(playerid, 0xCECECEFF, "����� ������� ������ ��������");
	
	new fmt_str[90];
	
	new modelid; 
	new vehicleid = GetPlayerJobCar(playerid);
	
	if(vehicleid != INVALID_VEHICLE_ID)
		modelid = GetVehicleData(vehicleid, V_MODELID);
	
	if(GetPlayerTempJob(playerid) == TEMP_JOB_FACTORY_TRUCKER && IsPlayerInVehicle(playerid, vehicleid) && modelid == 406)
	{
		new metall_loaded_count = GetPlayerJobLoadItems(playerid);
		
		if(metall_loaded_count < sell_metal_count) 
			return SendClientMessage(playerid, 0x999999FF, "� ����� ������� ��� ������ ���������� �������");
		
		metall_loaded_count -= sell_metal_count;
		SetPlayerJobLoadItems(playerid, metall_loaded_count);
	
		format(fmt_str, sizeof fmt_str, "�������� �������\n{FFFFFF}�������� %d / 500 ��", metall_loaded_count);
		UpdateVehicleLabel(vehicleid, 0x3399FFFF, fmt_str);
		
		AddPlayerData(playerid, P_JOB_WAGE, +, sell_metal_count * 3);
		GivePlayerMoneyEx(playerid, (sell_metal_count * 18), "������� ������� ������ (���������)", true, true);
	}
	else 
	{
		if(GetPlayerData(playerid, P_METALL) < sell_metal_count) 
			return SendClientMessage(playerid, 0x999999FF, "� ��� � ����� ��� ������ ���������� �������");
	
		format(fmt_str, sizeof fmt_str, "UPDATE accounts SET money=%d,metall=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid) + (sell_metal_count * 18), GetPlayerData(playerid, P_METALL), GetPlayerAccountID(playerid));
		mysql_query(mysql, fmt_str, false);
		
		if(!mysql_errno())
		{
			AddPlayerData(playerid, P_METALL, -, sell_metal_count);
			GivePlayerMoneyEx(playerid, (sell_metal_count * 18), "������� ������� ������", false, true);
		}
		else 
			return SendClientMessage(playerid, 0xFF6600FF, "������ ����������, ��������� ������� {FF0000}(equ-code 13)");

	}
	format(fmt_str, sizeof fmt_str, "�� ������� ������ %d �� ������� �� ����� %d ���", sell_metal_count, sell_metal_count * 18);
	SendClientMessage(playerid, 0x66CC00FF, fmt_str);
	
	format(fmt_str, sizeof fmt_str, "���� ������ ������� ���������� {FF9900}%d ���", sell_metal_count * 3);
	SendClientMessage(playerid, 0x66CC00FF, fmt_str);
	
	SetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL, R_AMOUNT, factory_metal + sell_metal_count);
	UpdateRepository(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL);
	
	return 1;
}

CMD:a(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) >= 1)
	{
		if(!strlen(params)) 
			return SendClientMessage(playerid, 0xCECECEFF, "�����������: /a [�����]");
		
		new fmt_str[128];
		
		format(fmt_str, sizeof fmt_str, "[A] %s[%d]: %s", GetPlayerNameEx(playerid), playerid, params);
		SendMessageToAdmins(fmt_str, 0x99CC00FF);
	}
	return 1;
}

CMD:msg(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) >= 4)
	{
		if(!strlen(params)) 
			return SendClientMessage(playerid, 0xCECECEFF, "�����������: /msg [�����]");
		
		new fmt_str[128];
		
		format(fmt_str, sizeof fmt_str, "������������� %s: %s", GetPlayerNameEx(playerid), params);
		SendClientMessageToAll(0xFFCD00FF, fmt_str);
	}
	return 1;
}
ALT:msg:o;

CMD:ans(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) >= 1)
	{
		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "�����������: /ans [id ������] [�����]");
		
		extract params -> new to_player, string: message[64 + 1];
		
		if(!IsPlayerConnected(to_player)) 
			return SendClientMessage(playerid, 0x999999FF, "������ ������ ���");
		
		if(!strlen(message))
			return SendClientMessage(playerid, 0x999999FF, "������� ���������");
			
		new fmt_str[128];
		
		format(fmt_str, sizeof fmt_str, "������������� %s[%d] ��� %s[%d]: %s", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, message);
		SendClientMessage(to_player, 0xFF9945FF, fmt_str);
		PlayerPlaySound(to_player, 1085, 0.0, 0.0, 0.0);
		
		SendMessageToAdmins(fmt_str, 0xFF9945FF);
	}
	return 1;
}

CMD:okay(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) >= 1)
	{
		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "���������: /okay [id ������]");
	
		extract params -> new to_player;
		
		if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) 
			return SendClientMessage(playerid, 0xCECECEFF, "������ ������ ���");
			
		if(!GetPVarInt(to_player, "change_name_status")) 
			return SendClientMessage(playerid, 0xCECECEFF, "����� �� ������� ������ �� ����� ����");
		
		new player_name[20 + 1];
		GetPVarString(to_player, "change_name", player_name, sizeof(player_name));

		if(ChangePlayerName(to_player, player_name, true))
		{
			Dialog
			(
				to_player, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, 
				"{FFCD00}��� ��������",
				"{66FF00}������ �� ��������� ����� ��������, ����� ��� �����������.\n\n"\
				"{FFFFFF}� ��������� ��� ��� ����� � ���� ����������� ���� ����� ���. ���\n"\
				"����� ����� �������� ��� � ���� ������� SAMP. ����������� �����\n"\
				"������ �������� ���� � ������� ���.",
				"��", ""
			);
		}
		else SendClientMessage(playerid, 0xFF6600FF, "��� ����� ���� ��������� ������");

		DeletePVar(to_player, "change_name");
		DeletePVar(to_player, "change_name_status");
	}
	
	return 1;
}

CMD:history(playerid, params[])
{
	if(!strlen(params)) 
		return SendClientMessage(playerid, 0xCECECEFF, "�����������: /history [��� ������]");
		
	if(!(3 <= strlen(params) <= 20)) 
		return SendClientMessage(playerid, 0x999999FF, "����� � ����� ������ �� ������");
	
	extract params -> new string: name[21];
	
	new query[128];
	new Cache: result, user_id;
	
	mysql_format(mysql, query, sizeof query, "SELECT id FROM accounts WHERE name='%e' LIMIT 1", name);
	result = mysql_query(mysql, query);
	
	if(cache_num_rows())
		user_id = cache_get_row_int(0, 0);
		
	cache_delete(result);
	
	if(!user_id)
		return SendClientMessage(playerid, 0x999999FF, "����� � ����� ������ �� ������");
	
	format(query, sizeof query, "SELECT name FROM change_names WHERE owner_id=%d ORDER BY id DESC LIMIT 45", user_id);
	mysql_tquery(mysql, query, "ShowChangeNameHistory", "is", playerid, name);

	return 1;
}

CMD:call(playerid, params[])
{
	if(!GetPlayerPhone(playerid)) 
		return SendClientMessage(playerid, 0x999999FF, "� ��� ��� ��������. ��� ����� ������ � �������� 24/7"); 
	
	if(GetPlayerPhoneCall(playerid, PC_INCOMING_PLAYER) != INVALID_PLAYER_ID || GetPlayerPhoneCall(playerid, PC_OUTCOMING_PLAYER) != INVALID_PLAYER_ID) 
		return SendClientMessage(playerid, 0x999999FF, "��������� ������� ��������");
	
	if(!GetPlayerPhoneCall(playerid, PC_ENABLED)) 
		return SendClientMessage(playerid, 0x999999FF, "��� ������� ��������");

	if(GetPlayerData(playerid, P_PHONE_BALANCE) >= 5)
	{
		new number;
		if(sscanf(params, "d", number))
		{
			Dialog
			(
				playerid, DIALOG_PHONE_CALL, DIALOG_STYLE_INPUT,
				"{FFCD00}�������� �����",
				"{6699CC}������ ��������������� �����:\n\n\
				{FFFFFF}�������\t\t\t{66CC00}02\n\
				{FFFFFF}������ ������\t\t{66CC00}03\n\
				{FFFFFF}�����\t\t\t\t{66CC00}555\n\
				{FFFFFF}�������\t\t\t{66CC00}090\n\
				{FFFFFF}�����\t\t\t\t{66CC00}022\n\
				{FFFFFF}������ ������� �������\t{66CC00}060\n\
				{FFFFFF}�������� �����\t\t{66CC00}111",
				"���������", "������"
			);
			return 1; // (TODO)
		}
		
		switch(number)
		{
			case 02: return 1;
			case 03: return 1;
			case 555: return 1;
			case 090: return 1;
			case 022: return 1;
			
			case 060: 
			{
				ShowCurrentTime(playerid);
			}
			case 111:
			{
				new fmt_str[175];
				SetPlayerPhoneUseState(playerid, true);
				
				format
				(
					fmt_str, sizeof fmt_str, 
					"{FFFFFF}������������! �� ��������� ���������.\n"\
					"�� ����� ������ ���������� �������� {00FF00}%d ���\n\n"\
					"{FFFFFF}��������� ��� ����� � ����� ���������.\n"\
					"����� �������!",
					GetPlayerData(playerid, P_PHONE_BALANCE)
				);
				Dialog(playerid, DIALOG_PHONE_CALL_BALANCE, DIALOG_STYLE_MSGBOX, "{FFCD00}�������� ������� �����", fmt_str, "��", "������");
			}
			
			default:
			{
				new subscriber = GetPlayerIDByPhone(number);
				
				if(number < 1) 
					return SendClientMessage(playerid, 0x999999FF, "������ ����� �� �������������");
					
				if(subscriber == INVALID_PLAYER_ID) 
					return SendClientMessage(playerid, 0xCECECEFF, "��������� ���� ����� �� �������������");
					
				if(subscriber == playerid || GetPlayerPhoneCall(subscriber, PC_INCOMING_PLAYER) != INVALID_PLAYER_ID || GetPlayerPhoneCall(subscriber, PC_OUTCOMING_PLAYER) != INVALID_PLAYER_ID) 
					return SendClientMessage(playerid, 0x999999FF, "������� �����");
				
				if(!GetPlayerPhoneCall(subscriber, PC_ENABLED))
					return SendClientMessage(playerid, 0x999999FF, "������� �������� ��� ���� �������");	

				SetPlayerPhoneCall(playerid, PC_OUTCOMING_PLAYER, subscriber);
				SetPlayerPhoneCall(subscriber, PC_INCOMING_PLAYER, playerid);
				
				new fmt_str[90];
				
				format(fmt_str, sizeof fmt_str, "��������� ������ | �����: %d {FFCD00}| �������� ������ �� %s...", number, GetPlayerNameEx(subscriber));
				SendClientMessage(playerid, 0x66CC00FF, fmt_str);
				
				format(fmt_str, sizeof fmt_str, "�������� ������ | �����: %d {FFCD00}| �������� %s", GetPlayerPhone(playerid), GetPlayerNameEx(playerid));
				SendClientMessage(subscriber, 0x3399FFFF, fmt_str);
				
				SendClientMessage(subscriber, 0xFFFFFFFF, "����������� {00CC00}/p {FFFFFF}����� �������� ��� {FF6600}/h {FFFFFF}����� ��������� �����");				
				SetPlayerPhoneUseState(playerid, true);
			}
		}
	}
	else 
	{
		SendClientMessage(playerid, 0xCECECEFF, "�� ����� ������������ �������");
		SendClientMessage(playerid, 0xCECECEFF, "��������� ��������� ������� ����� � ����� ���������");	
	}
	
	return 1;
}
ALT:call:c;

CMD:p(playerid, params[])
{
	if(GetPlayerPhoneCall(playerid, PC_TIME) != -1) return 1;
	
	new caller = GetPlayerPhoneCall(playerid, PC_INCOMING_PLAYER);
	if(caller != INVALID_PLAYER_ID) 
	{
		SetPlayerPhoneCall(caller, PC_TIME, 0);
		SetPlayerPhoneCall(playerid, PC_TIME, 0);

		new fmt_str[64];
		format(fmt_str, sizeof fmt_str, "�� �������� �� ������ %s", GetPlayerNameEx(caller));
		SendClientMessage(playerid, 0xDD90FFFF, fmt_str);
		
		format(fmt_str, sizeof fmt_str, "%s ������� �� ��� ������", GetPlayerNameEx(playerid));
		SendClientMessage(caller, 0xDD90FFFF, fmt_str);
		
		SetPlayerPhoneUseState(playerid, true, false);
	}
	else SendClientMessage(playerid, 0xCECECEFF, "��� �������� �������");
	
	return 1;
}

CMD:h(playerid, params[])
{
	new caller = GetPlayerPhoneCall(playerid, PC_INCOMING_PLAYER);
	new call_to = GetPlayerPhoneCall(playerid, PC_OUTCOMING_PLAYER);
	
	if(call_to != INVALID_PLAYER_ID)
	{
		if(GetPlayerPhoneCall(call_to, PC_INCOMING_PLAYER) == playerid)
		{
			ClearPlayerPhoneCall(call_to);
			SendClientMessage(call_to, 0xFF9944FF, "������ �������");

			SetPlayerPhoneUseState(call_to, false);
		}
		SendClientMessage(playerid, 0xFF9944FF, "������ �������");
	}
	else if(caller != INVALID_PLAYER_ID)
	{
		if(GetPlayerPhoneCall(caller, PC_OUTCOMING_PLAYER) == playerid)
		{
			ClearPlayerPhoneCall(caller);
			SendClientMessage(caller, 0xFF9944FF, "������ �������");

			SetPlayerPhoneUseState(caller, false);
		}
		if(GetPlayerPhoneCall(playerid, PC_TIME) != -1)
		{
			SendClientMessage(playerid, 0xFF9944FF, "������ �������");
		}
		else SendClientMessage(playerid, 0xFF9944FF, "�� ��������� �������� �����");
	}
	else return 1;
	
	ClearPlayerPhoneCall(playerid);
	SetPlayerPhoneUseState(playerid, false);

	return 1;
}
	
CMD:sms(playerid, params[])
{
	if(!GetPlayerPhone(playerid)) 
		return SendClientMessage(playerid, 0x999999FF, "� ��� ��� ��������. ��� ����� ������ � �������� 24/7"); 
		
	if(!GetPlayerPhoneCall(playerid, PC_ENABLED))
		return SendClientMessage(playerid, 0x999999FF, "��� ������� ��������");
	
	if(GetPlayerData(playerid, P_PHONE_BALANCE) >= 5)
	{
		if(!strlen(params)) 
			return SendClientMessage(playerid, 0xCECECEFF, "�����������: /sms [����� ��������] [���������]");
		
		extract params -> new number, string:message[66];
		
		if(number < 550)
			return SendClientMessage(playerid, 0x999999FF, "������ ����� �� �������������"); 
		
		new subscriber = GetPlayerIDByPhone(number);
		
		if(subscriber != INVALID_PLAYER_ID) 
		{
			if(!GetPlayerPhoneCall(subscriber, PC_ENABLED)) 
				return SendClientMessage(playerid, 0x999999FF, "�� ������� ��������� ���������. ������� �������� ����������");
			
			if(!strlen(message)) 	
				return SendClientMessage(playerid, 0xCECECEFF, "������� ��������� ��� ��������");
				
			if(strlen(message) > 64)
				return SendClientMessage(playerid, 0xCECECEFF, "������� ������� ���������");
			
			AddPlayerData(playerid, P_PHONE_BALANCE, -, 5);
			GameTextForPlayer(playerid, "SMS ~n~~y~-5 rub", 4000, 1);

			new fmt_str[128];
			
			format(fmt_str, sizeof fmt_str, "SMS: %s | �����������: %s [�.%d]", message, GetPlayerNameEx(playerid), GetPlayerPhone(playerid));
			SendClientMessage(subscriber, 0xFFFF00FF, fmt_str);
			SetPlayerChatBubble(subscriber, "SMS <<", 0xFFFF00FF, 5.0, 1500);
		
			format(fmt_str, sizeof fmt_str, "SMS: %s | ����������: %s [�.%d]", message, GetPlayerNameEx(subscriber), GetPlayerPhone(subscriber));
			SendClientMessage(playerid, 0xFFFF00FF, fmt_str);
			SetPlayerChatBubble(playerid, "SMS >>", 0xFFFF00FF, 5.0, 1500);
			
			format(fmt_str, sizeof fmt_str, "UPDATE accounts SET phone_balance=%d WHERE id=%d LIMIT 1", GetPlayerData(playerid, P_PHONE_BALANCE), GetPlayerAccountID(playerid));
			mysql_tquery(mysql, fmt_str, "", "");
		}
		else SendClientMessage(playerid, 0x999999FF, "������� ��������� ��� ���� �������");
	}
	else 
	{
		SendClientMessage(playerid, 0xCECECEFF, "�� ����� ������������ �������");
		SendClientMessage(playerid, 0xCECECEFF, "��������� ��������� ������� ����� � ����� ���������");
	}
	return 1;
}

CMD:togphone(playerid, params[])
{
	if(!GetPlayerPhone(playerid)) 
		return SendClientMessage(playerid, 0x999999FF, "� ��� ��� ��������. ��� ����� ������ � �������� 24/7"); 
	
	if(GetPlayerPhoneCall(playerid, PC_INCOMING_PLAYER) != INVALID_PLAYER_ID || GetPlayerPhoneCall(playerid, PC_OUTCOMING_PLAYER) != INVALID_PLAYER_ID) 
		return SendClientMessage(playerid, 0xCECECEFF, "��������� ������� ��������");	
	
	if(GetPlayerPhoneCall(playerid, PC_ENABLED))
	{
		SetPlayerPhoneCall(playerid, PC_ENABLED, false);
		SendClientMessage(playerid, 0xFF6600FF, "������� ��������");
	}
	else
	{
		SetPlayerPhoneCall(playerid, PC_ENABLED, true);
		SendClientMessage(playerid, 0x66CC00FF, "������� �������");
	}
	return 1;
}

CMD:eject(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid || !IsPlayerDriver(playerid))
		return SendClientMessage(playerid, 0x999999FF, "�� ������ ������ �� ����� ����������");
	
	if(!strlen(params))
		return SendClientMessage(playerid, 0x999999FF, "�����������: /eject [id ������]");
	
	extract params -> new to_player;
	
	if(vehicleid != GetPlayerVehicleID(to_player) || playerid == to_player)
		return SendClientMessage(playerid, 0x999999FF, "����� ������ ������ � ����� ����������");
	
	RemovePlayerFromVehicle(to_player);
	
	new fmt_str[64];
	format(fmt_str, sizeof fmt_str, "%s ������� ��� �� ������ ����������", GetPlayerNameEx(playerid));
	SendClientMessage(to_player, 0x3399FFFF, fmt_str);
	
	format(fmt_str, sizeof fmt_str, "�� �������� %s �� ������ ����������", GetPlayerNameEx(to_player));
	SendClientMessage(playerid, 0x3399FFFF, fmt_str);
	
	return 1;
}

CMD:book(playerid, params[])
{
	if(!GetPlayerPhone(playerid))
		return SendClientMessage(playerid, 0x999999FF, "� ��� ��� ��������. ��� ����� ������ � �������� 24/7"); 
		
	return ShowPlayerPhoneBook(playerid);
}

CMD:add(playerid, params[])
{
	if(!GetPlayerPhone(playerid)) 
		return SendClientMessage(playerid, 0x999999FF, "� ��� ��� ��������. ��� ����� ������ � �������� 24/7"); 

	if(!strlen(params))
		return SendClientMessage(playerid, 0x999999FF, "�����������: /add [id ������] [����� ��������]");
		
	extract params -> new to_player, string: number[10];
	
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) 
		return SendClientMessage(playerid, 0x999999FF, "������ ������ ���");
	
	if(!IsPlayerPhoneBookInit(playerid))
		InitPlayerPhoneBook(playerid);
	
	if(GetPlayerPhoneBookContacts(playerid) >= MAX_PHONE_BOOK_CONTACTS)
		return SendClientMessage(playerid, 0xCECECEFF, "�������� ������ ���������. ������� �������� ��������");
	
	if((3 <= strlen(number) <= 9) && IsNumeric(number) && strval(number) > 0)
		return AddPhoneBookContact(playerid, GetPlayerNameEx(to_player), number);
	
	SetPVarString(playerid, "add_contact_name", GetPlayerNameEx(to_player));
	new fmt_str[64 + 1];
	
	format(fmt_str, sizeof fmt_str, "{FFFFFF}������� ����� �������� ��� �������� %s", GetPlayerNameEx(to_player));
	return Dialog(playerid, DIALOG_PHONE_BOOK_ADD_CONTACT, DIALOG_STYLE_INPUT, "{FFCD00}���������� ������ ��������", fmt_str, "��������", "������");
}

CMD:buyfuelst(playerid, params[])
{
	if(GetPlayerFuelStation(playerid) != -1)  
		return SendClientMessage(playerid, 0xCECECEFF, "� ��� ��� ���� ��������. ����� ������ ������ ���������� ������� ������");
	
	new stationid = GetNearestFuelStation(playerid, 10.0);
	if(stationid != -1)
	{
		SetPVarInt(playerid, "buy_fuel_st", stationid);
		
		new fmt_str[256];
		format
		(
			fmt_str, sizeof fmt_str, 
			"{FFFFFF}��������:\t\t\t{339999}%s\n"\
			"{FFFFFF}���������:\t\t\t{6699FF}%d ���\n"\
			"{FFFFFF}����� �� ������:\t\t{6699FF}%d ��� � ����\n\n"\
			"{669966}�� ������� ��� ������ ������ ��� ��������?",
			GetFuelStationData(stationid, FS_NAME),
			GetFuelStationData(stationid, FS_PRICE),
			GetFuelStationData(stationid, FS_RENT_PRICE)
		);
		Dialog(playerid, DIALOG_FUEL_STATION_BUY, DIALOG_STYLE_MSGBOX, "{33AACC}������� ����������� �������", fmt_str, "��", "���");
	}
	else SendClientMessage(playerid, 0xCECECEFF, "�� ������ ���� ����� � ���������, ������� ������ ������");
	
	return 1;
}

CMD:fuelst(playerid, params[])
{
	new stationid = GetPlayerFuelStation(playerid);
	if(stationid != -1)
	{
		new fmt_str[1024];
		format
		(
			fmt_str, sizeof fmt_str, 
			"{FFFFFF}��������:\t\t\t\t{339999}%s\n"\
			"{FFFFFF}����� ��������:\t\t\t%d\n"\
			"��������:\t\t\t\t%s\n"\
			"����� / �������:\t\t\t%s\n"\
			"�����:\t\t\t\t\t%s\n"\
			"������� ���������:\t\t\t%d\n"\
			"���������� �������:\t\t\t%d �� %d\n"\
			"���� �������:\t\t\t%d ��� �� 1 �\n"\
			"���������� ����:\t\t\t%d ��� �� 1 �\n"\
			"������ ��������:\t\t\t%d ���\n"\
			"��� ���������� ��:\t\t\t%d/30 ����\n"\
			"���. ���������:\t\t\t%d ���\n"\
			"������ ����������:\t\t\t%d ��� � ����\n"\
			"�������� ����:\t\t\t%s\n"\
			"������:\t\t\t\t\t%s\n\n"\
			"{669966}��� �������� ������ ���������� ����������� ��������\n"\
			"������� ������ \"��������\"",
			GetFuelStationData(stationid, FS_NAME),
			stationid,
			GetFuelStationData(stationid, FS_OWNER_NAME),
			GetCityName(GetFuelStationData(stationid, FS_CITY)),
			GetZoneName(GetFuelStationData(stationid, FS_ZONE)),
			GetFuelStationData(stationid, FS_IMPROVEMENTS),
			GetFuelStationData(stationid, FS_FUELS),
			GetFuelStationMaxFuel(stationid),
			GetFuelStationData(stationid, FS_FUEL_PRICE),
			GetFuelStationData(stationid, FS_BUY_FUEL_PRICE),
			GetFuelStationData(stationid, FS_BALANCE),
			GetElapsedTime(GetFuelStationData(stationid, FS_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS),
			GetFuelStationData(stationid, FS_PRICE),
			GetFuelStationData(stationid, FS_IMPROVEMENTS) < 4 ? GetFuelStationData(stationid, FS_RENT_PRICE) : GetFuelStationData(stationid, FS_RENT_PRICE) / 2,
			GetFuelStationData(stationid, FS_IMPROVEMENTS) < 4 ? ("���������") : ("�� ���������"),
			GetFuelStationData(stationid, FS_LOCK_STATUS) ? ("{CC3333}������� �������") : ("{66CC33}������� �������")
		);
		Dialog(playerid, DIALOG_FUEL_STATION_INFO, DIALOG_STYLE_MSGBOX, "{33AACC}���������� � ��������", fmt_str, "��������", "������");
	}
	else SendClientMessage(playerid, 0x999999FF, "� ��� ��� ��������");

	return 1;
}

CMD:sellfuelst(playerid, params[])
{
	new stationid = GetPlayerFuelStation(playerid);
	if(stationid != -1)
	{
		Dialog
		(
			playerid, DIALOG_FUEL_STATION_SELL, DIALOG_STYLE_MSGBOX,
			"{FFCD00}������� ����������� �������",
			"{FFFFFF}�� ������� ��� ������ ������� ���� ����������� ������� �����������?\n\n"\
			"��� ����� ���������� �� ��������� �� ������� 30%\n"\
			"����� ����� ���������� 60% �� ��������� ��������� ���������\n\n"\
			"���� �� ������ ������� ����������� ������� ������� ������,\n"\
			"����������� ������� /sellmyfuelst",
			"��", "���"
		);
	}
	else SendClientMessage(playerid, 0x999999FF, "� ��� ��� ��������");
	
	return 1;
}

CMD:sellmyfuelst(playerid, params[])
{	
	new stationid = GetPlayerFuelStation(playerid);
	if(stationid != -1)
	{
		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "�����������: /sellmyfuelst [id ������] [���������]");
			
		extract params -> new to_player, price;
		
		if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
			return SendClientMessage(playerid, 0xCECECEFF, "������ ������ ���");
		
		if(price < 1)
			return SendClientMessage(playerid, 0xCECECEFF, "������� ��������� �������");
		
		new Float: f_pos_x = GetFuelStationData(stationid, FS_POS_X);
		new Float: f_pos_y = GetFuelStationData(stationid, FS_POS_Y);
		new Float: f_pos_z = GetFuelStationData(stationid, FS_POS_Z);
		
		if(GetPlayerMoneyEx(to_player) < price)
			return SendClientMessage(playerid, 0xCECECEFF, "� ���������� ��� ������ ���������� �������");
			
		if(!(IsPlayerInRangeOfPoint(playerid, 10.0, f_pos_x, f_pos_y, f_pos_z) && IsPlayerInRangeOfPoint(to_player, 10.0, f_pos_x, f_pos_y, f_pos_z)))
			SendClientMessage(playerid, 0xCECECEFF, "�� � ���������� ������ ��������� ����� � ��������� ������� ������ �������");
	
		SendPlayerOffer(playerid, to_player, OFFER_TYPE_SELL_FUEL_ST, stationid);
	}
	else SendClientMessage(playerid, 0x999999FF, "� ��� ��� ��������");
	
	return 1;
}

CMD:fuel(playerid, params[])
{
	new fmt_str[41];
	new string[40 * (MAX_FUEL_STATIONS+2) + 1] = "� ���\t\t��������� 1 �\t\t� �������\t\t�������� ���\n\n{FFFFFF}";

	for(new idx; idx < g_fuel_station_loaded; idx ++)
	{
		format(fmt_str, sizeof fmt_str, "%d\t\t\t%d ���\t\t%d �\t\t%s\n", idx, GetFuelStationData(idx, FS_FUEL_PRICE), GetFuelStationData(idx, FS_FUELS), GetFuelStationData(idx, FS_NAME));
		strcat(string, fmt_str);
	}
	return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FFCD00}����������� �������", string, "�������", "");
}

CMD:buyfuel(playerid, params[])
{
	ShowPlayerBuyJerricanDialog(playerid, GetNearestFuelStation(playerid, 10.0));
	
	return 1;
}

CMD:fill(playerid, params[])
{
	if(GetPlayerJob(playerid) != JOB_MECHANIC)
		return SendClientMessage(playerid, 0xCECECEFF, "�� �� �����������");
	
	if(!IsPlayerInJob(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "�� ������ �������� �������������");
	
	new job_car = GetPlayerJobCar(playerid);
	if(!IsPlayerInVehicle(playerid, job_car) || GetVehicleData(job_car, V_ACTION_ID) == VEHICLE_ACTION_ID_NONE)
		return SendClientMessage(playerid, 0xCECECEFF, "�� ������ �������� ������������� � ��������� � ������� ����������");
	
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "�������������: /fill [id ������] [���-�� �������] [���������]");
		
	extract params -> new to_player, fill_fuel_count, fill_price;

	if(!IsPlayerConnected(to_player)) 
		return SendClientMessage(playerid, 0xCECECEFF, "������ ������ ���");
		
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 15.0)) 
		return SendClientMessage(playerid, 0x999999FF, "����� ��������� ������� ������");
		
	if(!IsPlayerDriver(to_player)) 
		return SendClientMessage(playerid, 0x999999FF, "������ ������ ��������� �� �����");
		
	if(1 <= GetPlayerJobLoadItems(playerid) <= fill_fuel_count)
		return SendClientMessage(playerid, 0xCECECEFF, "� ��� ��� ������ ���������� �������");
	
	if(!(1 <= fill_price <= 1500)) 
		return SendClientMessage(playerid, 0xCECECEFF, "��������� ������ ���� �� 1500 ������");
		
	if(GetPlayerMoneyEx(to_player) < fill_price) 
		return SendClientMessage(playerid, 0xCECECEFF, "� ������� ��� � ����� ������� �����");
	
	SendPlayerOffer(playerid, to_player, OFFER_TYPE_FILL_CAR, fill_fuel_count, fill_price);
	return 1;
}

CMD:repair(playerid, params[])
{
	if(GetPlayerJob(playerid) != JOB_MECHANIC)
		return SendClientMessage(playerid, 0xCECECEFF, "�� �� �����������");
	
	if(!IsPlayerInJob(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "�� ������ �������� �������������");
	
	new job_car = GetPlayerJobCar(playerid);
	if(!IsPlayerInVehicle(playerid, job_car) || GetVehicleData(job_car, V_ACTION_ID) == VEHICLE_ACTION_ID_NONE)
		return SendClientMessage(playerid, 0xCECECEFF, "�� ������ �������� ������������� � ��������� � ������� ����������");
	
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "�������������: /repair [id ������] [���������]");
		
	extract params -> new to_player, repair_price;

	if(!IsPlayerConnected(to_player)) 
		return SendClientMessage(playerid, 0xCECECEFF, "������ ������ ���");
		
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 15.0)) 
		return SendClientMessage(playerid, 0x999999FF, "����� ��������� ������� ������");
		
	if(!IsPlayerDriver(to_player)) 
		return SendClientMessage(playerid, 0x999999FF, "������ ������ ��������� �� �����");
		
	//new Float: vehicle_health;
	//GetVehicleHealth(GetPlayerVehicleID(to_player), vehicle_health);
	//if(vehicle_health < 350.0 && !IsPlayerInRangeOfPoint(playerid, 80.0, 1180.0962,2500.5166,12.4769)) return Send(playerid, 0xCECECEFF, "��������� ������� ����� ������ ���������, �������� ��� �� ������� ������������� {CCCC00}(/gps)");
	
	if(!(1 <= repair_price <= 1500)) 
		return SendClientMessage(playerid, 0xCECECEFF, "��������� ������ ���� �� 1500 ������");
	
	if(GetPlayerMoneyEx(to_player) < repair_price) 
		return SendClientMessage(playerid, 0xCECECEFF, "� ������� ��� � ����� ������� �����");
	
	SendPlayerOffer(playerid, to_player, OFFER_TYPE_REPAIR_CAR, repair_price);
	return 1;
}

CMD:getfuel(playerid, params[])
{
	if(GetPlayerJob(playerid) != JOB_MECHANIC)
		return SendClientMessage(playerid, 0xCECECEFF, "�� �� �����������");
	
	if(!IsPlayerInJob(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "�� ������ �������� �������������");
	
	new job_car = GetPlayerJobCar(playerid);
	if(!IsPlayerInVehicle(playerid, job_car) || GetVehicleData(job_car, V_ACTION_ID) == VEHICLE_ACTION_ID_NONE)
		return SendClientMessage(playerid, 0xCECECEFF, "�� ������ �������� ������������� � ��������� � ������� ����������");
	
	new stationid = GetNearestFuelStation(playerid, 10.0);
	if(stationid != -1) 
	{
		SetPVarInt(playerid, "nearest_fuel_st", stationid);
		
		if(IsFuelStationOwned(stationid))
		{
			if(GetFuelStationData(stationid, FS_FUELS) < 10)
				return SendClientMessage(playerid, 0xFF6600FF, "��������� ���� ��� �����");
		}

		new fmt_str[150];
		format
		(
			fmt_str, sizeof fmt_str, 
			"{FFFFFF}������� �� ���:\t\t%d/10000 �\n"\
			"��������� 1 �����:\t%d ���\n\n"\
			"������� ���-�� �������, ������� ������ ��������\n"\
			"(����� ������ ���� ������� 10)",
			GetFuelStationData(stationid, FS_FUELS),
			GetFuelStationData(stationid, FS_FUEL_PRICE)
		);
		Dialog(playerid, DIALOG_FUEL_STATION_BUY_FUEL_M, DIALOG_STYLE_INPUT, "{FFCD00}������� �������", fmt_str, "������", "������");
	}
	else SendClientMessage(playerid, 0xCECECEFF, "���������� ��� ����������� �������");

	return 1;
}

CMD:business(playerid, params[])
{
	new businessid = GetPlayerBusiness(playerid);
	if(businessid != -1)
	{
		static const 
			music_name[6][9] = {"��������", "���� 1", "���� 2", "���� 3", "���� 4", "���� 5"};
		
		if(GetBusinessData(businessid, B_ENTER_MUSIC) > sizeof music_name - 1)
		{
			SetBusinessData(businessid, B_ENTER_MUSIC, sizeof music_name - 1);
		}
		
		new fmt_str[1024];
		format
		(
			fmt_str, sizeof fmt_str, 
			"{FFFFFF}��������:\t\t\t\t{339999}%s\n"\
			"{FFFFFF}����� �������:\t\t\t%d\n"\
			"��������:\t\t\t\t%s\n"\
			"����� / �������:\t\t\t%s\n"\
			"�����:\t\t\t\t\t%s\n"\
			"����� �� ����:\t\t\t\t%d ���\n"\
			"���������� ���������:\t\t%d �� %d\n"\
			"��������� 1 ��������:\t\t%d ���\n"\
			"������� ���������:\t\t\t%d\n"\
			"������ �����������:\t\t\t%d ���\n"\
			"������ ��������� ��:\t\t%d/30 ����\n"\
			"���� ��� �����:\t\t\t{%s}%s\n"\
			"{FFFFFF}���. ���������:\t\t\t%d ���\n"\
			"������ ���������:\t\t\t%d ��� � ����\n"\
			"��� ������:\t\t\t\t%s\n"\
			"������:\t\t\t\t\t%s\n\n"\
			"{669966}��� �������� ������ ���������� ����� ��������\n"\
			"������� ������ \"��������\"",
			GetBusinessData(businessid, B_NAME),
			businessid,
			GetBusinessData(businessid, B_OWNER_NAME),
			GetCityName(GetBusinessData(businessid, B_CITY)),
			GetZoneName(GetBusinessData(businessid, B_ZONE)),
			GetBusinessData(businessid, B_ENTER_PRICE),
			GetBusinessData(businessid, B_PRODS),
			GetBusinessMaxProd(businessid),
			GetBusinessData(businessid, B_PROD_PRICE),
			GetBusinessData(businessid, B_IMPROVEMENTS),
			GetBusinessData(businessid, B_BALANCE),
			GetElapsedTime(GetBusinessData(businessid, B_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS),
			!GetBusinessData(businessid, B_ENTER_MUSIC) ? ("FF3333") : ("33CC00"),
			music_name[GetBusinessData(businessid, B_ENTER_MUSIC)],
			GetBusinessData(businessid, B_PRICE),
			GetBusinessData(businessid, B_IMPROVEMENTS) < 3 ? (GetBusinessData(businessid, B_RENT_PRICE)) : (GetBusinessData(businessid, B_RENT_PRICE) / 2),
			GetBusinessData(businessid, B_IMPROVEMENTS) < 3 ? ("������") : ("��������"), 
			GetBusinessData(businessid, B_LOCK_STATUS) ? ("{CC3333}������ ������") : ("{66CC33}������ ������") 
		);
		Dialog(playerid, DIALOG_BIZ_INFO, DIALOG_STYLE_MSGBOX, "{33AACC}���������� � �������", fmt_str, "��������", "������");	
	}
	else SendClientMessage(playerid, 0x999999FF, "� ��� ��� �������");
	
	return 1;
}

CMD:buybiz(playerid, params[])
{
	if(GetPlayerBusiness(playerid) != -1)
		return SendClientMessage(playerid, 0xCECECEFF, "� ��� ��� ���� ������. ����� ������ ������ ���������� ������� ������");
	
	new businessid = GetNearestBusiness(playerid, 4.0);
	if(businessid != -1)
	{
		SetPVarInt(playerid, "buy_biz_id", businessid);
	
		new fmt_str[256];
		format
		(
			fmt_str, sizeof fmt_str,
			"{FFFFFF}��������:\t\t\t{339999}%s\n"\
			"{FFFFFF}���������:\t\t\t{6699FF}%d ���\n"\
			"{FFFFFF}����� �� ������:\t\t{6699FF}%d ��� � ����\n\n"\
			"{669966}�� ������� ��� ������ ������ ���� ������?",
			GetBusinessData(businessid, B_NAME),
			GetBusinessData(businessid, B_PRICE),
			GetBusinessData(businessid, B_RENT_PRICE)
		);
		Dialog(playerid, DIALOG_BIZ_BUY, DIALOG_STYLE_MSGBOX, "{33AACC}������� ������ �������", fmt_str, "��", "���");
	}
	else SendClientMessage(playerid, 0xCECECEFF, "�� ������ ���� ����� � ��������, ������� ������ ������");
	
	return 1;
}

CMD:sellbiz(playerid, params[])
{
	new businessid = GetPlayerBusiness(playerid);
	if(businessid != -1)
	{
		Dialog
		(
			playerid, DIALOG_BIZ_SELL, DIALOG_STYLE_MSGBOX,
			"{FFCD00}������� �������",
			"{FFFFFF}�� ������� ��� ������ ������� ���� ������ �����������?\n\n"\
			"��� ����� ���������� ��� ��������� �� ������� 30%\n"\
			"����� ����� ���������� 60% �� ��������� ��������� ���������\n\n"\
			"���� �� ������ ������� ������ ������� ������,\n"\
			"����������� ������� /sellmybiz", 
			"��", "���"
		);
	}
	else SendClientMessage(playerid, 0x999999FF, "� ��� ��� �������");
	
	return 1;
}

CMD:sellmybiz(playerid, params[])
{
	new businessid = GetPlayerBusiness(playerid);
	if(businessid != -1)
	{
		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "�����������: /sellmybiz [id ������] [���������]");
			
		extract params -> new to_player, price;
		
		if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
			return SendClientMessage(playerid, 0xCECECEFF, "������ ������ ���");
		
		if(price < 1)
			return SendClientMessage(playerid, 0xCECECEFF, "������� ��������� �������");
		
		new Float: b_pos_x = GetBusinessData(businessid, B_POS_X);
		new Float: b_pos_y = GetBusinessData(businessid, B_POS_Y);
		new Float: b_pos_z = GetBusinessData(businessid, B_POS_Z);
		
		if(GetPlayerMoneyEx(to_player) < price)
			return SendClientMessage(playerid, 0xCECECEFF, "� ���������� ��� ������ ���������� �������");
			
		if(!(IsPlayerInRangeOfPoint(playerid, 7.0, b_pos_x, b_pos_y, b_pos_z) && IsPlayerInRangeOfPoint(to_player, 7.0, b_pos_x, b_pos_y, b_pos_z)))
			SendClientMessage(playerid, 0xCECECEFF, "�� � ���������� ������ ��������� ����� � �������� ������� ������ �������");
	
		SendPlayerOffer(playerid, to_player, OFFER_TYPE_SELL_BUSINESS, businessid);
	}
	else SendClientMessage(playerid, 0x999999FF, "� ��� ��� �������");
	
	return 1;
}

CMD:bizmusic(playerid, params[])
{
	new businessid = GetPlayerBusiness(playerid);
	if(businessid != -1)
	{
		if(GetBusinessData(businessid, B_IMPROVEMENTS) >= 4)
		{
			new fmt_str[13 + 1];
			new string[(sizeof fmt_str - 1) * (sizeof g_business_sound) + 1];
			
			string = "1. ��������\n";
			for(new idx = 1; idx <= sizeof g_business_sound; idx ++)
			{
				format(fmt_str, sizeof fmt_str, "%d. ���� �%d\n", idx + 1, idx);	
				strcat(string, fmt_str);
			}
			Dialog(playerid, DIALOG_BIZ_ENTER_MUSIC, DIALOG_STYLE_LIST, "{FFCD00}���� ��� ����� � ������", string, "�������", "�������");
		}
		else SendClientMessage(playerid, 0xCECECEFF, "��� ������������� ���� ������� ��������� 4 ������� ��������� �������");
	}
	else SendClientMessage(playerid, 0xCECECEFF, "� ��� ��� �������");
	
	return 1;
}
  
CMD:manager(playerid, params[])
{
	new businessid = GetPlayerBusiness(playerid);
	if(businessid != -1)
	{
		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "�����������: /manager [id ������]");
			
		extract params -> new to_player;
		
		if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
			return SendClientMessage(playerid, 0xCECECEFF, "������ ������ ���");
			
		if(!IsPlayerInRangeOfPlayer(playerid, to_player, 10.0)) 
			return SendClientMessage(playerid, 0xCECECEFF, "����� ��������� ������� ������");
		
		SendPlayerOffer(playerid, to_player, OFFER_TYPE_BUSINESS_MANAGER, businessid);
	}
	else SendClientMessage(playerid, 0xCECECEFF, "� ��� ��� �������");
	
	return 1;
}

CMD:buy(playerid, params[])
{
	new businessid = GetPlayerInBiz(playerid);
	if(businessid != -1)
	{
		if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_SHOP_24_7))
		{
			Dialog
			(
				playerid, DIALOG_BIZ_SHOP_24_7, DIALOG_STYLE_LIST,
				"{0099FF}������� 24/7",
				"1. ��������� �������\t{00CC00}170 ���\n"\
				"2. �������� �����\t\t{00CC00}450 ���\n"\
				"3. �������� ���� ��������\t{00CC00}200 ���\n"\
				"4. ������� (2 ��)\t\t{00CC00}300 ���\n"\
				"5. ����������� (15 �������)\t{00CC00}200 ���\n"\
				"6. ����� ������\t\t{00CC00}150 ���\n"\
				"7. ������\t\t\t{00CC00}600 ���\n"\
				"8. �������\t\t\t{00CC00}800 ���\n"\
				"9. ���������� �����\t\t{00CC00}400 ���\n"\
				"10. �����\t\t\t{00CC00}110 ���",
				"������", "������"
			);
		}
		else SendClientMessage(playerid, 0xCECECEFF, "�� ������ ���� � ����������� ��������");
	}
	else SendClientMessage(playerid, 0xCECECEFF, "�� ������ ���� � ����������� ��������");
	
	return 1;
}

CMD:healme(playerid, params[])
{
	if(GetPlayerData(playerid, P_MED_CHEST) <= 0) 
		return SendClientMessage(playerid, 0xCECECEFF, "� ��� ��� � ����� �������");
	
	AddPlayerData(playerid, P_MED_CHEST, -, 1);
	SetPlayerHealthEx(playerid, 60.0, true);

	GameTextForPlayer(playerid, "~b~+60 hp", 4000, 1);
	SendClientMessage(playerid, 0x3399FFFF, "�� ������������ �������. �������� ��������� �� 60 ������");
	
	ApplyAnimation(playerid, "ped", "gum_eat", 4.0, 0, 0, 0, 0, 0, 0);
	
	return 1;
}

CMD:present(playerid, params[])
{
	if(!IsPlayerHaveWeapon(playerid, WEAPON_FLOWER))
		return SendClientMessage(playerid, 0xCECECEFF, "� ��� ��� ������");
	
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "�����������: /present [id ������]");
	
	extract params -> new to_player;
	
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "������ ������ ���");
	
	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 3.0))
		return SendClientMessage(playerid, 0xCECECEFF, "����� ������� ������");
	
	if(IsPlayerHaveWeapon(to_player, WEAPON_FLOWER))
		return SendClientMessage(playerid, 0xCECECEFF, "� ����� ������ ��� ���� ����� ������");
	
	new fmt_str[64];
	
	new Float: angle;
	new Float: to_x, Float: to_y;
	new Float: x, Float: y, Float: z;
	
	GetPlayerPos(playerid, x, y, z);
	GetPlayerPos(to_player, to_x, to_y, z);
	
	angle = GetAngleToPoint(to_x, to_y, x, y);
	
	SetPlayerFacingAngle(playerid, angle);
	SetPlayerFacingAngle(to_player, angle + 180.0);
	
	ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0, 0);
	ApplyAnimation(to_player, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0, 0);
	
	format(fmt_str, sizeof fmt_str, "%s �������(�) �� ��� �����", GetPlayerNameEx(to_player));
	SendClientMessage(playerid, 0x3399FFFF, fmt_str);
	
	format(fmt_str, sizeof fmt_str, "%s �������(�) ��� �����", GetPlayerNameEx(playerid));
	SendClientMessage(to_player, 0x3399FFFF, fmt_str);
	
	SetTimerEx("PresentFlowersToPlayer", 1500, false, "ii", playerid, to_player);
	return 1;
}

CMD:mask(playerid, params[])
{
	if(GetPlayerData(playerid, P_MASK) != 1)
		return SendClientMessage(playerid, 0xCECECEFF, "� ��� ��� � ����� �����");
	
	SetPlayerData(playerid, P_MASK, 600 + 1);
	SetPlayerColorEx(playerid, 0x00000000);
	
	ApplyAnimation(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0, 0);
	SetPlayerChatBubble(playerid, "�������� �����", 0xFF9900FF, 15.0, 5000);
	
	GameTextForPlayer(playerid, "~b~~h~invisible on", 2500, 4);
	SendClientMessage(playerid, 0x3399FFFF, "���� ����������������� �� GPS ������ �� 10 �����");
	
	return 1;
}

CMD:gate(playerid, params[])
{
	if(!CheckNearestGate(playerid))
	{
		CallRemoteFunction("FS_PlayerUseButton", "i", playerid);
	}
	return 1;
}

CMD:home(playerid, params[])
{
	new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
	if(houseid != -1)
	{
		new fmt_str[1024];
		new entranceid = GetHouseData(houseid, H_ENTRACE);
		
		format(fmt_str, sizeof fmt_str, "{FFFFFF}��� / ��������:\t\t\t{339999}%s\n", GetHouseData(houseid, H_NAME));
		if(entranceid != -1)
		{
			format
			(
				fmt_str, sizeof fmt_str,
				"%s{FFFFFF}����� ��������:\t\t\t%d\n"\
				"����� ��������:\t\t\t%d\n"\
				"����� / �������:\t\t\t%s\n"\
				"�����:\t\t\t\t\t%s\n", 
				fmt_str,
				entranceid + 1,
				GetHouseData(houseid, H_FLAT_ID) + 1,
				GetCityName(GetEntranceData(entranceid, E_CITY)),
				GetZoneName(GetEntranceData(entranceid, E_ZONE))
			);
		}
		else 
		{
			format
			(
				fmt_str, sizeof fmt_str,
				"%s{FFFFFF}����� ����:\t\t\t\t%d\n"\
				"����� / �������:\t\t\t%s\n"\
				"�����:\t\t\t\t\t%s\n",
				fmt_str,
				houseid,
				GetCityName(GetHouseData(houseid, H_CITY)),
				GetZoneName(GetHouseData(houseid, H_ZONE))
			);
		}
		
		format
		(
			fmt_str, sizeof fmt_str, 
			"%s���������:\t\t\t\t%d ���\n"\
			"��� ������� ��:\t\t\t%d/30 ����\n"\
			"���������� ������:\t\t\t%d\n"\
			"������� ���������:\t\t\t%d\n"\
			"������ ��������� ����:\t\t{FF3333}���\n"\
			"{FFFFFF}����������:\t\t\t\t%d ��� � ����\n"\
			"��� ����������:\t\t\t%s\n"\
			"������:\t\t\t\t\t%s\n\n"\
			"{669966}��� �������� ������ ���������� ����� �����\n"\
			"������� ������ \"��������\"",
			fmt_str,
			GetHouseData(houseid, H_PRICE),
			GetElapsedTime(GetHouseData(houseid, H_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS),
			GetHouseTypeInfo(GetHouseData(houseid, H_TYPE), HT_ROOMS),
			GetHouseData(houseid, H_IMPROVEMENTS),
			GetHouseData(houseid, H_IMPROVEMENTS) < 4 ? (GetHouseData(houseid, H_RENT_PRICE)) : (GetHouseData(houseid, H_RENT_PRICE) / 2),
			GetHouseData(houseid, H_IMPROVEMENTS) < 4 ? ("�������") : ("����������"),
			GetHouseData(houseid, H_LOCK_STATUS) ? ("{CC3333}��� ������") : ("{66CC33}��� ������")
		);
		Dialog(playerid, DIALOG_HOUSE_INFO, DIALOG_STYLE_MSGBOX, "{33AACC}���������� � ����", fmt_str, "��������", "������");	
	}
	else SendClientMessage(playerid, 0x999999FF, "� ��� ��� ����");
	
	return 1;
}

CMD:sellhome(playerid, params[])
{
	new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
	if(houseid != -1)
	{
		Dialog
		(
			playerid, DIALOG_HOUSE_SELL, DIALOG_STYLE_MSGBOX,
			"{FFCD00}������� ����",
			"{FFFFFF}�� ������� ��� ������ ������� ���� ��� �����������?\n\n"\
			"��� ����� ���������� �� ��������� �� ������� 30%\n"\
			"����� ����� ���������� 60% �� ��������� ��������� ���������\n\n"\
			"���� �� ������ ������� ��� ������� ������,\n"\
			"����������� ������� /sellmyhome",
			"��", "���"
		);	
	}
	else SendClientMessage(playerid, 0x999999FF, "� ��� ��� ����");
	
	return 1;
}

CMD:sellmyhome(playerid, params[])
{
	new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
	if(houseid != -1)
	{
		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "�����������: /sellmyhome [id ������] [���������]");
			
		extract params -> new to_player, price;
		
		new house_price = GetHouseData(houseid, H_PRICE);
		
		if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) 
			return SendClientMessage(playerid, 0xCECECEFF, "������ ������ ���");
			
		if(GetPlayerHouse(to_player) != -1) 
			return SendClientMessage(playerid, 0xCECECEFF, "� ����� ������ ��� ���� ���");
			
		if(!((house_price / 3) <= price <= (house_price * 3))) 
			return SendClientMessage(playerid, 0xCECECEFF, "��������� �� ������ ���� ������ ��� ������� � 3 ���� �� ��������� ����");
		
		if(GetPlayerMoneyEx(to_player) < price) 
			return SendClientMessage(playerid, 0xCECECEFF, "� ����� ������ ��� ����� �����");
			
		if(!(IsPlayerInRangeOfHouse(playerid, houseid, 10.0) && IsPlayerInRangeOfHouse(to_player, houseid, 10.0)))
			return SendClientMessage(playerid, 0xCECECEFF, "�� � ���������� ������ ���������� ����� ���� ������� ������ �������");
		
		SendPlayerOffer(playerid, to_player, OFFER_TYPE_SELL_HOME, houseid, price);
	}
	else SendClientMessage(playerid, 0x999999FF, "� ��� ��� ����");
	
	return 1;
}

CMD:live(playerid, params[])
{
	new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
	if(houseid != -1)
	{
		new type = GetHouseData(houseid, H_TYPE);
		new rooms = GetHouseTypeInfo(type, HT_ROOMS);
		
		if(GetHouseRentersCount(houseid) >= rooms)
			return SendClientMessage(playerid, 0x999999FF, "��� ������� ������ ���� ��� ������");
		
		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "�����������: /live [id ������]"); // [���-�� ����] [���� (�������������)]
		
		extract params -> new to_player, days, price;
		
		if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) 
			return SendClientMessage(playerid, 0xCECECEFF, "������ ������ ���");
		
		if(GetPlayerHouse(to_player) != -1) 
			return SendClientMessage(playerid, 0xCECECEFF, "� ����� ������ ��� ���� ���");
		
		/*
		if(!(300 <= price <= 10_000))
			return SendClientMessage(playerid, 0xCECECEFF, "���� ������ ������ ���� �� 300 �� 10000 ���");
		
		else if(!(1 <= days <= 30))
			return SendClientMessage(playerid, 0xCECECEFF, "���-�� ���� ������ ������ ���� �� 0 �� 30");
		
		if(GetPlayerMoneyEx(to_player) < price) 
			return SendClientMessage(playerid, 0xCECECEFF, "� ����� ������ ��� ����� �����");
		*/
		
		if(!(IsPlayerInRangeOfHouse(playerid, houseid, 10.0) && IsPlayerInRangeOfHouse(to_player, houseid, 10.0)))
			return SendClientMessage(playerid, 0xCECECEFF, "�� � ��������� ������ ���������� ����� ���� ������� ������ ����� � ������");
	
		SendPlayerOffer(playerid, to_player, OFFER_TYPE_HOME_RENT_ROOM, houseid);
	}
	else SendClientMessage(playerid, 0x999999FF, "� ��� ��� ����");
	
	return 1;
}

CMD:liveout(playerid, params[])
{
	new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_ROOM);
	if(houseid != -1)
	{
		Dialog
		(
			playerid, DIALOG_HOUSE_EVICT, DIALOG_STYLE_MSGBOX,
			"{FF9900}��������� �� ����",
			"{FFFFFF}�� ������������� ������ ���������� �� ����?", 
			"��", "���"
		);
	}
	else SendClientMessage(playerid, 0x999999FF, "�� ����� �� ����������");
	
	return 1;
}

CMD:makestore(playerid, params[])
{
	new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
	if(houseid != -1)
	{	
		if(GetHouseData(houseid, H_IMPROVEMENTS) >= 5)
		{
			if(GetPlayerInHouse(playerid) == houseid)
			{
				new type = GetHouseData(houseid, H_TYPE);
				if(IsPlayerInRangeOfPoint(playerid, 50.0, GetHouseTypeInfo(type, HT_ENTER_POS_X), GetHouseTypeInfo(type, HT_ENTER_POS_Y), GetHouseTypeInfo(type, HT_ENTER_POS_Z)))
				{
					Dialog
					(
						playerid, DIALOG_HOUSE_MOVE_STORE, DIALOG_STYLE_MSGBOX, 
						"{FFCD00}����", 
						"{FFFFFF}�� ������ ���������� ���� � ���� �����?",
						"��", "���"
					);
				}
				else SendClientMessage(playerid, 0x999999FF, "�� ������ ��������� � ���� � ����");
			}
			else SendClientMessage(playerid, 0x999999FF, "�� ������ ��������� � ���� � ����");
		}
		else SendClientMessage(playerid, 0x999999FF, "��������� 5 ������� ��������� ��� ����");
	}
	else SendClientMessage(playerid, 0x999999FF, "������� �������� ���������� ������������");
	
	return 1;
}

CMD:use(playerid, params[])
{
	new TODO_THIS; // ���������� ������� �����

	return 1;
}

CMD:tv(playerid, params[])
{	
	new TODO_THIS; // ���������� TV (������� �� � �����)
	
	return 1;
}

CMD:homelock(playerid, params[])
{
	new hotel_id = GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL);
	new room_id = GetPlayerData(playerid, P_HOUSE_ROOM);
	
	if(hotel_id != -1)
	{
		if(GetHotelData(hotel_id, room_id, H_STATUS))
		{
			SetHotelData(hotel_id, room_id, H_STATUS, false);
			
			GameTextForPlayer(playerid, "~g~~h~O�KP��O", 2000, 4);
			SendClientMessage(playerid, 0x66CC00FF, "����� ������");
		}
		else 
		{
			SetHotelData(hotel_id, room_id, H_STATUS, true);
			
			GameTextForPlayer(playerid, "~r~~h~�AKP��O", 2000, 4);
			SendClientMessage(playerid, 0xFF6600FF, "����� ������");
		}
		
		new query[64];
		format(query, sizeof query, "UPDATE hotels SET status=%d WHERE id=%d LIMIT 1", GetHotelData(hotel_id, room_id, H_STATUS), GetHotelData(hotel_id, room_id, H_SQL_ID));
		mysql_query(mysql, query, false);
	}
	else SendClientMessage(playerid, 0x999999FF, "�� �� �������� ����� � ���������");
	
	return 1;
}

CMD:exit(playerid, params[])
{
	if(GetPlayerInHouse(playerid) != -1)
	{
		ExitPlayerFromHouse(playerid, 3.0);
	}
	else if(GetPlayerData(playerid, P_IN_HOTEL_ROOM) != -1)
	{
		ExitPlayerFromHotelRoom(playerid);
	}
	else if(!GetPlayerInterior(playerid))
	{
		SendClientMessage(playerid, 0xCECECEFF, "�� �� � ���������");
	}

	return 1;
}

CMD:lift(playerid, params[])
{
	new entranceid = GetPlayerInEntrance(playerid);
	if(entranceid != -1)
	{
		new floor = GetPlayerInEntranceFloor(playerid);
		if(floor != -1)
		{
			if(!floor)
			{
				if(!IsPlayerInRangeOfPoint(playerid, 1.5, 30.5405, 1403.6593, 1508.4163))
					return SendClientMessage(playerid, 0xCECECEFF, "�� ������ ��������� ����� �����");
			}
			else
			{
				if(!IsPlayerInRangeOfPoint(playerid, 1.5, 11.1776, 1377.5216, 1508.4163))
					return SendClientMessage(playerid, 0xCECECEFF, "�� ������ ��������� ����� �����");		
			}
			ShowPlayerEntranceFloorsLift(playerid, entranceid, floor);
		}
	}
	else SendClientMessage(playerid, 0xCECECEFF, "�� �� � ��������");
	
	return 1;
}

CMD:lock(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, 0x999999FF, "�����������: /lock [���] (1-������ ��������� 2-������������ ������ 3-������� ��������� 4-���������� ���������)");
	
	extract params -> new type;
	
	new Float: radius = 20.0;
	new vehicleid = INVALID_VEHICLE_ID;
	
	switch(type)
	{
		case 1:
		{
			vehicleid = GetPlayerOwnableCar(playerid);
			
			if(vehicleid == INVALID_VEHICLE_ID)
				return SendClientMessage(playerid, 0x999999FF, "� ��� ��� ������� ����������");
		}
		case 2:
		{
			new TODO_THIS_NOW___;
	
			if(vehicleid == INVALID_VEHICLE_ID)
				return SendClientMessage(playerid, 0x999999FF, "� ��� ��� ������������ ������");
		}
		case 3:
		{
			vehicleid = GetPlayerJobCar(playerid);
			
			if(vehicleid == INVALID_VEHICLE_ID)
				return SendClientMessage(playerid, 0x999999FF, "�� �� ������ ������������ ��� �������");
		}
		case 4:
		{
			if(vehicleid == INVALID_VEHICLE_ID)
				return SendClientMessage(playerid, 0x999999FF, "� ��� ��� ����������� ����������");
		}
		default:
			return SendClientMessage(playerid, 0xCECECEFF, "�����������: /lock [���] (1-������ ��������� 2-������������ ������ 3-������� ��������� 4-���������� ���������)");
	}
	
	new Float: x, Float: y, Float: z;
	GetVehiclePos(vehicleid, x, y, z);

	if(IsPlayerInRangeOfPoint(playerid, radius, x, y, z))
	{
		new status = GetVehicleParam(vehicleid, V_LOCK);
		if(status)
		{
			if(type == 1)
			{
				Action(playerid, "������ ������ ���������", _, true);
			}
			GameTextForPlayer(playerid,"~w~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~�PA�C�OP�~g~ O�KP��", 3000, 3);
		}
		else 
		{
			if(type == 1)
			{
				Action(playerid, "������ ������ ���������", _, true);
			}				
			GameTextForPlayer(playerid,"~w~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~�PA�C�OP�~r~ �AKP��", 3000, 3);
		}
		SetVehicleParam(vehicleid, V_LOCK, status ^ VEHICLE_PARAM_ON);
	}
	else SendClientMessage(playerid, 0x999999FF, "�� ������ ������ ����� � �����������");

	return 1;
}

CMD:key(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
	{
		if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(!IsABike(vehicleid))
			{
				if(vehicleid == GetPlayerOwnableCar(playerid))
				{
					new index = GetVehicleData(vehicleid, V_ACTION_ID);
					new bool: status = GetOwnableCarData(index, OC_KEY_IN);
					
					if(status)
					{
						if(GetVehicleParam(vehicleid, V_ENGINE) == VEHICLE_PARAM_ON)
						{
							SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_OFF);
						}
						Action(playerid, "������� ���� �� ����� ���������", _, false);
					}
					else Action(playerid, "������� ���� � ����� ���������", _, false);
					
					SetOwnableCarData(index, OC_KEY_IN, status ^ true);
					SpeedometrKeyStatusInit(playerid, vehicleid);
				}
				else SendClientMessage(playerid, 0xCECECEFF, "�� ������ ��������� � ������ ����������");
			}
		}
		else SendClientMessage(playerid, 0x999999FF, "� ��� ��� ������� ����������");
	}
	else SendClientMessage(playerid, 0xCECECEFF, "�� ������ ��������� � ����������");
	
	return 1;
}

CMD:getmycar(playerid, params[])
{
	new vehicleid = GetPlayerOwnableCar(playerid);
	if(vehicleid != INVALID_VEHICLE_ID)
	{
		new price = 300;
		new i_have_home = (GetPlayerHouse(playerid, HOUSE_TYPE_HOME) != -1 || GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL) != -1); 
		
		if(GetPlayerGPSInfo(playerid, G_ENABLED) == GPS_STATUS_OFF)
		{
			if(GetPlayerMoneyEx(playerid) >= price || i_have_home)
			{
				if(!i_have_home)
					GivePlayerMoneyEx(playerid, -price, "����� �� �� GPS", true, true);
				
				new Float: x, Float: y, Float: z;
				GetVehiclePos(vehicleid, x, y, z);
				
				EnablePlayerGPS(playerid, 55, x, y, z, "�������������� ������ ���������� �������� �� GPS");
				return 1;
			}
			else SendClientMessage(playerid, 0x999999FF, "������������ �����");
		}
		else SendClientMessage(playerid, 0xCECECEFF, "�� ����� GPS ��� �������� �����");
	}
	else SendClientMessage(playerid, 0x999999FF, "� ��� ��� ������� ����������");
	
	return 0;
}

CMD:sellcar(playerid, params[])
{
	new vehicleid = GetPlayerOwnableCar(playerid);
	if(vehicleid != INVALID_VEHICLE_ID)
	{
		new model_id = GetVehicleData(vehicleid, V_MODELID);
		if(model_id)
		{
			new fmt_str[256];
			
			new price = GetVehicleInfo(model_id-400, VI_PRICE);
			new percent = price * 20 / 100;
			
			format
			(
				fmt_str, sizeof fmt_str,
				"{FFFFFF}������:\t%s (�%d)\n"\
				"���������:\t%d ���\n\n"\
				"�� ������� ��� ������ ������� ���������?\n"\
				"�� ��� ���������� ���� ����� ��������� %d ���\n\n"\
				"���� �� ������ ������� ��� ������� ������,\n"\
				"����������� ������� /sellmycar",	
				GetVehicleName(vehicleid),
				model_id,
				price,
				price - percent
			);
			Dialog(playerid, DIALOG_OWNABLE_CAR_SELL, DIALOG_STYLE_MSGBOX, "{FFCD00}������� ������� ����������", fmt_str, "��", "���");				
		}
	}
	else SendClientMessage(playerid, 0x999999FF, "� ��� ��� ������� ����������");

	return 1;
}

CMD:sellmycar(playerid, params[])
{
	new vehicleid = GetPlayerOwnableCar(playerid);
	if(vehicleid != INVALID_VEHICLE_ID)
	{
		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "�����������: /sellmycar [id ������] [���������]");
		
		extract params -> new to_player, price;
		
		new model_id = GetVehicleData(vehicleid, V_MODELID);
		if(model_id)
		{
			new car_price = GetVehicleInfo(model_id-400, VI_PRICE);
			
			if(!IsPlayerConnected(to_player) || to_player == playerid) 
				return SendClientMessage(playerid, 0xCECECEFF, "������ ������ ���");
				
			if(GetPlayerOwnableCar(to_player) != INVALID_VEHICLE_ID) 
				return SendClientMessage(playerid, 0xCECECEFF, "� ����� ������ ��� ���� ������ ���������");
				
			if(!(3000 <= price <= (car_price * 2)))
				return SendClientMessage(playerid, 0xCECECEFF, "��������� ����� ���� �� 3000 ������ � �� ������ � 2 ���� ���. ��������� ��");
			
			if(GetPlayerMoneyEx(to_player) < price) 
				return SendClientMessage(playerid, 0xCECECEFF, "� ����� ������ ��� ����� �����");
			
			new  Float: car_x, Float: car_y, Float: car_z; 
			GetVehiclePos(vehicleid, car_x, car_y, car_z);
			
			if(IsPlayerInRangeOfPoint(playerid, 15.0, car_x, car_y, car_z) && IsPlayerInRangeOfPoint(to_player, 15.0, car_x, car_y, car_z))
			{
				SendPlayerOffer(playerid, to_player, OFFER_TYPE_SELL_OWNABLE_CAR, price, vehicleid);	
			}
			else SendClientMessage(playerid, 0xCECECEFF, "�� � ���������� ������ ���������� ����� ��");	
		}
	}
	else SendClientMessage(playerid, 0x999999FF, "� ��� ��� ������� ����������"); 
	
	return 1;
}

CMD:allow(playerid, params[])
{
	new TODO_THIS; // ������ ����������� �����

	return 1;
}

CMD:park(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid)) 
		return SendClientMessage(playerid, 0xCECECEFF, "�� ������ ��������� � ����������");
	
	new vehicleid = GetPlayerOwnableCar(playerid);
	if(vehicleid == INVALID_VEHICLE_ID)
		return SendClientMessage(playerid, 0x999999FF, "� ��� ��� ������� ����������"); 
	
	if(vehicleid != GetPlayerVehicleID(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "�� ������ ��������� � ������ ����������");

	SaveOwnableCar(vehicleid);
	return SendClientMessage(playerid, 0x66CC00FF, "��������� �����������");
}

CMD:car(playerid, params[])
{
	if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
	{
		Dialog
		(
			playerid, DIALOG_OWNABLE_CAR, DIALOG_STYLE_LIST, 
			"{FFCD00}������� ���������� �����������",
			"1. {669900}������� {FFFFFF}��� {FF3300}������� {FFFFFF}���������\n"\
			"2. �������� / �������� �����\n"\
			"3. �������� ��������� �� GPS {FF6600}(300 ���)\n"\
			"4. ���������� ���������\n"\
			"5. ��������� �� ���������\n"\
			"{888888}6. ������������ ���������", 
			"�������", "�������"
		);
	}
	else SendClientMessage(playerid, 0x999999FF, "� ��� ��� ������� ����������");
	
	return 1;
}

CMD:trunk(playerid, params[])
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		new vehicleid;
		new Float: x, Float: y, Float: z;
		new Float: angle, Float: distance; 
	
		while((++vehicleid) < MAX_VEHICLES)
		{
			if(!GetVehicleData(vehicleid, V_MODELID)) continue;
			
			GetCoordVehicle(vehicleid, VEHICLE_COORD_TYPE_BOOT, x, y, z, angle, distance);
			if(!IsPlayerInRangeOfPoint(playerid, 1.0, x, y, z)) continue;

			ShowTrunkDialog(playerid, vehicleid, false);
			break;
		}
	}
	return 1;
}

/*
CMD:ta(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "�����������: /ta [vehicleid] [item] [amount]");
		
	extract params -> new vehicleid, item, amount;
	
	if(AddTrunkItem(vehicleid, item, amount))
	{
		new fmt_str[128];
		
		format(fmt_str, sizeof fmt_str, "�� �������� \"%s\" � ��������, ���-��: %d %s", GetItemInfo(item, I_NAME), amount, GetItemInfo(item, I_NAME_COUNT));
		SendClientMessage(playerid, 0x3399FFFF, fmt_str);
	}
	else SendClientMessage(playerid, 0x999999FF, "�������� ��� ��������");
	
	return 1;
}
*/

/*
CMD:finit(playerid, params[])
{
	new query[128];
	
	new floor, flat;
	for(new idx; idx < 46; idx ++)
	{
		for(floor = 0; floor < GetEntranceData(idx, E_FLOORS); floor ++)
		{
			for(flat = 0; flat < 4; flat ++)
			{				
				format(query, sizeof query, "INSERT INTO houses (price,rent_price,type,entrance) VALUES (%d,%d,%d,%d)", 400000 + (!random(3) ? 50000 : 100000), 500, 0, idx);
				mysql_query(mysql, query, false);
			}
		}
	}
	return 1;
}
*/

CMD:veh(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "�����������: /veh [������]");
	
	extract params -> new model;
	
	if(!(400 <= model <= 611))
		return SendClientMessage(playerid, 0xCECECEFF, "������ ���������� ������ ���� �� 400 �� 611");
		
	new Float: x, Float: y, Float: z;
	GetPlayerPos(playerid, x, y, z);
	
	return CreateVehicle(model, x + 1.5, y + 1.5, z, 0.0, -1, -1, -1, 0);
}

CMD:lics(playerid, params[])
{
	SetPlayerData(playerid, P_DRIVING_LIC, 1);
	
	return 1;
}

CMD:money(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "�����������: /money [���-��]");
		
	extract params -> new money;
	
	if(!(1 <= money <= 100_000))
		return SendClientMessage(playerid, 0xCECECEFF, "�� ��� ����� ����� �� 1 �� 100.000");

	return GivePlayerMoneyEx(playerid, money, "test", true, true);
}

CMD:test(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsAOwnableCar(vehicleid))
	{
		new index = GetVehicleData(vehicleid, V_ACTION_ID);
		new bool: param = GetOwnableCarData(index, OC_KEY_IN);
		
		SetOwnableCarData(index, OC_KEY_IN, param ^ true);
	}
	//SetRandomWeather();

	//new fmt_str[32];
	
	//format(fmt_str, sizeof fmt_str, "in_biz: %d", GetPlayerInBiz(playerid));
	//SendClientMessage(playerid, 0xCECECEFF, fmt_str);

	//new param = GetPVarInt(playerid, "test");
	//SetPVarInt(playerid, "test", param ^ 1);

	//extract params-> new itemid;
	//GivePlayerDrinkItem(playerid, itemid);
	
	/*
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "���������: /test [action id]");
		
	extract params -> new action_id;
	SetPlayerSpecialAction(playerid, action_id);
	*/
	
	return 1;
}

CMD:sex(playerid, params[])
{
	new sex = GetPlayerSex(playerid);
	SetPlayerData(playerid, P_SEX, sex ^ 1);
	
	return 1;
}

CMD:pos(playerid, params[])
{
	new Float: x, Float: y, Float: z, interior, virtual_world;
	
	if(sscanf(params, "P<,>fff", x, y, z))
		return SendClientMessage(playerid, 0xCECECEFF, "�����������: /pos [x y z]");
		
	sscanf(params, "P<,>{fff}dd", interior, virtual_world);
	
	return SetPlayerPosEx(playerid, x, y, z, interior, virtual_world);
}