#define SERVER_NAME 				"RADMIR" 		// название мода
#define SERVER_SITE 				"radmir-rp.ru" 	// сайт сервера
#define SERVER_MAP_NAME 			"Russia"		// название карты

#define GAME_MODE_TEXT 				""SERVER_NAME" RP Russian" // Название мода в клиенте

#define LAN_MODE
#if defined LAN_MODE
	
	#define MYSQL_HOST				"127.0.0.1"
	#define MYSQL_USER				"root"
	#define MYSQL_BASE				"radmir_schema"
	#define MYSQL_PASS				"123123"

#else 

	#define MYSQL_HOST				""
	#define MYSQL_USER				""
	#define MYSQL_BASE				""
	#define MYSQL_PASS				""
	
#endif

#if !defined isnull
	#define isnull(%0)				((!(%0[0])) || (((%0[0]) == '\1') && (!(%0[1]))))
#endif

#define public:%0(%1)               forward %0(%1); public %0(%1)
				
#define Kick:(%0)                   PlayerKick(%0)

#define abs(%0)						(%0 < 0 ? -%0 : %0)

#define PRESSED(%0) 				(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define HOLDING(%0)             	((newkeys & (%0)) == (%0))
#define PRESSING(%0,%1)				(%0 & (%1))
#define RELEASED(%0)				(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))