#if defined _SYSTEM_VEHICLE
	#endinput
#endif
#define _SYSTEM_VEHICLE

// ------------------------------------
#define GetVehicleInfo(%0,%1)		g_vehicle_info[%0][%1]
#define GetVehicleName(%0)			GetVehicleInfo(GetVehicleData(%0, V_MODELID)-400, VI_NAME)

// ------------------------------------
#define GetVehicleData(%0,%1)		g_vehicle_data[%0][%1]
#define SetVehicleData(%0,%1,%2)	g_vehicle_data[%0][%1] = %2
#define ClearVehicleData(%0)		g_vehicle_data[%0] = g_vehicle_default_values
#define IsValidVehicleID(%0)		(1 <= %0 < MAX_VEHICLES)

// ------------------------------------
#define GetVehicleParamEx(%0,%1) g_vehicle_params[%0][%1]

// ------------------------------------
#define VEHICLE_ACTION_TYPE_NONE 	-1
#define VEHICLE_ACTION_ID_NONE 		-1

// ------------------------------------
#define VEHICLE_PARAM_ON	(1)
#define VEHICLE_PARAM_OFF	(0)

// ------------------------------------
native IsValidVehicle(vehicleid);

// ------------------------------------
enum E_VEHICLE_STRUCT
{
	V_MODELID,
	Float: V_SPAWN_X,
	Float: V_SPAWN_Y,
	Float: V_SPAWN_Z,
	Float: V_SPAWN_ANGLE,
	V_COLOR_1,
	V_COLOR_2,
	V_RESPAWN_DELAY,
	V_ADDSIREN,
	// -------------
	V_ACTION_TYPE,
	V_ACTION_ID,
	// -------------
	V_DRIVER_ID,
	// -------------
	V_LIMIT,
	V_ALARM,
	Float: V_FUEL,
	Float: V_MILEAGE,
	// -------------
	Text3D: V_LABEL
};

// ------------------------------------
enum E_VEHICLE_PARAMS_STRUCT
{
	V_ENGINE, 	// двигатель
	V_LIGHTS, 	// фары
	V_ALARM,	// сигнализация
	V_LOCK, 	// закрыто ли
	V_BONNET, 	// капот
	V_BOOT, 	// багажник
	V_OBJECTIVE // отображене стрелки над автоqa
};

// ------------------------------------
enum E_VEHICE_INFO_STRUCT
{
	VI_NAME[21],	// название
	VI_PRICE,		// гос. стоимость
	VT_RENT_PRICE,	// стоимость аренды
	VI_TYPE			// тип
};

// ------------------------------------
new g_vehicle_data[MAX_VEHICLES][E_VEHICLE_STRUCT];
new 
	g_vehicle_default_values[E_VEHICLE_STRUCT] = 
{
	0,
	0.0,
	0.0,
	0.0,
	0.0,
	0,
	0,
	0,
	0,
	VEHICLE_ACTION_TYPE_NONE,
	VEHICLE_ACTION_ID_NONE,
	INVALID_PLAYER_ID,
	false,
	false,
	40.0,
	0.0,
	Text3D:-1
};
new g_vehicle_params[MAX_VEHICLES][E_VEHICLE_PARAMS_STRUCT];

new const
	g_vehicle_info[212][E_VEHICE_INFO_STRUCT] = 
{
	{"BMW X5",				850000,		8500,	0},		// 400
	{"ИЖ 2715",				50000,		500,	0},		// 401
	{"Opel Omega",			600000,		6000,	0},		// 402
	{"ЗИЛ Тягач", 			0, 			0,		0},		// 403
	{"ВАЗ 2101",			80000,		800,	0},		// 404
	{"Mitsubishi Lancer",	800000,		8000,	0},		// 405
	{"ЗИЛ 131 Самосвал", 	0, 			0,		0},		// 406
	{"Пожарка", 			0,			0,		0},		// 407
	{"Мусоровоз", 			0,			0,		0},		// 408
	{"ГАЗ 14",				2000000,	15000,	0},		// 409
	{"Mitsubishi Eclipse",	600000,		6000,	0},		// 410
	{"Lada Kalina",			340000,		3400,	0},		// 411
	{"ИЖ Комби",			60000,		600,	0},		// 412
	{"ПАЗ 672",				0,			0,		0},		// 413
	{"Лиаз 5256", 			0,			0,		0},		// 414
	{"Cheetah",				1000000,	10000,	0},		// 415
	{"Скорая", 				0,			0,		0},		// 416
	{"Leviathn",			0,			0,		0},		// 417
	{"Moonbeam", 			0,			0,		0},		// 418
	{"Esperanto",			500000,		5000,	0},		// 419
	{"Такси", 				0,			0,		0},		// 420
	{"Washington",			800000,		8000,	0},		// 421
	{"УАЗ Буханка",			100000,		1000,	0},		// 422
	{"MrWhoop", 			0,			0,		0},		// 423
	{"CMЗ",					10000,		100,	0},		// 424
	{"Hunter", 				0,			0,		0},		// 425
	{"ЗИЛ 4101",			2000000,	15000,	0},		// 426
	{"Enforcer", 			0,			0,		0},		// 427
	{"Инкасатор", 			0,			0,		0},		// 428
	{"ГАЗ 21", 				0,			0,		0},		// 429
	{"Predator", 			0,			0,		0},		// 430
	{"Лиаз 677", 			0,			0,		0},		// 431
	{"Танк", 				0,			0,		0},		// 432
	{"ЗИЛ 131 Борт", 		0,			0,		0},		// 433
	{"Hotknife",			700000,		7000,	0},		// 434
	{"Прицеп", 				0,			0,		0},		// 435
	{"Toyota Mark",			650000,		6500,	0},		// 436
	{"Икарус", 				0,			0,		0},		// 437
	{"Такси", 				0,			0,		0},		// 438
	{"Москвич 412",			35000,		350,	0},		// 439
	{"Rumpo", 				0,			0,		0},		// 440
	{"RCcar", 				0,			0,		0},		// 441
	{"ГАЗ М1", 				60000,		100,	0},		// 442
	{"Автовоз", 			0,			0,		0},		// 443
	{"Монстр", 				0,			0,		0},		// 444
	{"ГАЗ 24",				240000,		2400,	0},		// 445
	{"Squalo", 				0,			0,		0},		// 446
	{"Водный верт", 		0,			0,		0},		// 447
	{"Pizzaboy", 			0,			0,		0},		// 448
	{"Цистенра", 			0,			0,		0},		// 449
	{"Прицеп", 				0,			0,		0},		// 450
	{"Turismo",				2000000,	20000,	0},		// 451
	{"Speeder", 			0,			0,		0},		// 452
	{"Reefer", 				0,			0,		0},		// 453
	{"Яхта", 				0,			0,		0},		// 454
	{"Грейдер", 			0,			0,		0},		// 455
	{"ГАЗ 3309", 			0,			0,		0},		// 456
	{"Гольф кар", 			0,			0,		0},		// 457
	{"ГАЗ 24-02",			240000,		2400,	0},		// 458
	{"Topfun", 				0,			0,		0},		// 459
	{"Водн самолет", 		0,			0,		0},		// 460
	{"Jawa 350",			70000,		700,	0},		// 461
	{"Мотороллер",			18000,		200,	0},		// 462
	{"Harley",				120000,		1200,	0},		// 463
	{"RCplane", 			0,			0,		0},		// 464
	{"RCheli", 				0,			0,		0},		// 465
	{"BMW 535",				800000,		8000,	0},		// 466
	{"ИЖ 412",				35000,		350,	0},		// 467
	{"CZ 125",				40000,		400,	0},		// 468
	{"Sparrow", 			0,			0,		0},		// 469
	{"Хамер", 				0,			0,		0},		// 470
	{"Квадроцикл",			120000,		1200,	0},		// 471
	{"Coastg", 				0,			0,		0},		// 472
	{"Dinghy",				0,			0,		0},		// 473
	{"ГАЗ 21",				60000,		600,	0},		// 474
	{"Mitsubishi Pajero",	450000,		4500,	0},		// 475
	{"Истрибитель", 		0,			0,		0},		// 476
	{"ZR 350",				900000,		9000,	0},		// 477
	{"ИЖ 27151",			45000,		450,	0},		// 478
	{"ГАЗ 24-02",			240000,		2400,	0},		// 479
	{"Comet",				2000000,	20000,	0},		// 480
	{"Велосипед Аист",		4000,		100,	0},		// 481
	{"Burrito", 			0,			0,		0},		// 482
	{"ПАЗ 3205", 			0,			0,		0},		// 483
	{"Теплоход", 			0,			0,		0},		// 484
	{"Газ Аэро", 			0,			0,		0},		// 485
	{"Бульдозер", 			0,			0,		0},		// 486
	{"Верт", 				0,			0,		0},		// 487
	{"News Верт", 			0,			0,		0},		// 488
	{"Chevrolet Niva",		400000,		4000,	0},		// 489
	{"ФСБ джип", 			0,			0,		0},		// 490
	{"Virgo",				500000,		5000,	0},		// 491
	{"ВАЗ 2109",			180000,		1800,	0},		// 492
	{"Jetmax", 				0,			0,		0},		// 493
	{"Гоночн кар", 			0,			0,		0},		// 494
	{"Трофи Джип", 			1500000,	15000,	0},		// 495
	{"Таврия",				70000,		700,	0},		// 496
	{"Пол Верт", 			0,			0,		0},		// 497
	{"ЛАЗ 695", 			0,			0,		0},		// 498
	{"ГАЗ 53", 				0,			0,		0},		// 499
	{"ГАЗ 69",				40000,		400,	0},		// 500
	{"RCgobl", 				0,			0,		0}, 	// 501
	{"Гоночн кар", 			0,			0,		0}, 	// 502
	{"Гоночн кар", 			0,			0,		0}, 	// 503
	{"Bloodra", 			0,			0,		0}, 	// 504
	{"Rnchlure",			1200000,	12000,	0},		// 505
	{"Super GT",			1700000,	17000,	0},		// 506
	{"ГАЗ 24",				240000,		2400,	0}, 	// 507
	{"УАЗ Буханка",			100000,		1000,	0}, 	// 508
	{"Велосипед 'Урал'",	6000,		150,	0}, 	// 509
	{"Горный Велосипед",	10000,		300,	0}, 	// 510
	{"Beagle", 				0,			0,		0}, 	// 511
	{"Cropdast", 			0,			0,		0}, 	// 512
	{"Stunt", 				0,			0,		0}, 	// 513
	{"Камаз 54115",			0,			0,		0}, 	// 514
	{"КАЗ", 				0,			0,		0}, 	// 515
	{"ВАЗ 21099",			180000,		1800,	0}, 	// 516
	{"РАФ Латвия",			150000,		1500,	0}, 	// 517
	{"ЕРАЗ 977",			100000,		1000,	0}, 	// 518
	{"Shamal", 				0,			0,		0}, 	// 519
	{"Истрибитель", 		0,			0,		0}, 	// 520
	{"ИЖ Планета-5",		35000,		350,	0}, 	// 521
	{"NRG 500",				600000,		6000,	0}, 	// 522
	{"Юпитер 5",			32000,		320,	0}, 	// 523
	{"Цементовоз", 			0,			0,		0}, 	// 524
	{"Эвакуатор", 			0,			0,		0}, 	// 525
	{"Fortune",				160000,		1600,	0}, 	// 526
	{"Cadrona",				150000,		1500,	0}, 	// 527
	{"Труповоз", 			0,			0,		0},		// 528
	{"Willard",				150000,		1500,	0},		// 529
	{"Погрузщик", 			0,			0,		0}, 	// 530
	{"Трактор", 			0,			0,		0}, 	// 531
	{"Комбайн", 			0,			0,		0}, 	// 532
	{"Feltzer",				200000,		2000,	0}, 	// 533
	{"Remington",			400000,		4000,	0}, 	// 534
	{"Slamvan",				400000,		4000,	0}, 	// 535
	{"Blade",				350000,		3500,	0}, 	// 536
	{"Поезд", 				0,			0,		0}, 	// 537
	{"Поезд", 				0,			0,		0}, 	// 538
	{"Возд Подушка", 		0,			0,		0}, 	// 539
	{"ГАЗ 3111",			180000,		1800,	0}, 	// 540
	{"Bullet",				3000000,	30000,	0}, 	// 541
	{"ВАЗ 2121",			130000,		1300,	0}, 	// 542
	{"Москвич 427", 		0,			0,		0}, 	// 543
	{"Пожарка", 			0,			0,		0}, 	// 544
	{"Москвич 400", 		60000, 		100,	0}, 	// 545
	{"ИЖ Комби",			60000,		600,	0}, 	// 546
	{"АЗЛК 2140",			60000,		600,	0}, 	// 547
	{"Воен Верт", 			0, 			0,		0},		// 548
	{"ЗАЗ 968",				20000,		50,		0},		// 549
	{"Sunrise",				140000,		1400,	0}, 	// 550
	{"ГАЗ 31105",			130000,		110,	0}, 	// 551
	{"Фургон уборщ", 		0,			0,		0}, 	// 552
	{"Кукурузник", 			0,			0,		0}, 	// 553
	{"УАЗ 3303", 			0,			0,		0}, 	// 554
	{"ЗАЗ 968",				20000,		50,		0}, 	// 555
	{"Монстр", 				0,			0,		0}, 	// 556
	{"Монстр", 				0,			0,		0}, 	// 557
	{"Uranus",				450000,		4500,	0}, 	// 558
	{"Tojota Celica",		600000,		6000,	0}, 	// 559
	{"Sultan",				650000,		6500,	0}, 	// 560
	{"Москвич 427",			60000,		600,	0},		// 561
	{"Elegy",				2500000,	25000,	0}, 	// 562
	{"Спас верт", 			0,			0,		0}, 	// 563
	{"RCtank", 				0,			0,		0}, 	// 564
	{"ВАЗ 2108",			170000,		1700,	0}, 	// 565
	{"ВАЗ 2104",			100000,		1000,	0}, 	// 566
	{"Savana",				200000,		2000,	0}, 	// 567
	{"Bandito",				50000,		500,	0},		// 568
	{"Вагон", 				0,			0,		0}, 	// 569
	{"Вагон", 				0,			0,		0}, 	// 570
	{"Карт", 				0,			0,		0}, 	// 571
	{"Газонокосилка", 		0,			0,		0}, 	// 572 
	{"Ралли Грузовки", 		2000000,	20000,	0}, 	// 573
	{"Уборш улиц", 			0,			0,		0},		// 574
	{"ГАЗ 20",				60000,		600,	0}, 	// 575
	{"АЗЛК 408",			60000,		600,	0}, 	// 576
	{"AT 400", 				0,			0,		0}, 	// 577
	{"ЗИЛ Борт", 			0,			0,		0}, 	// 578
	{"Huntley",				800000,		8000,	0},		// 579
	{"ГАЗ 13",				2000000,	15000,	0}, 	// 580
	{"BF 400",				70000,		700,	0}, 	// 581
	{"Новос Фург",			0,			0,		0}, 	// 582
	{"Tug", 				0,			0,		0}, 	// 583
	{"Цистерна", 			0,			0,		0}, 	// 584
	{"Emperor",				200000,		2000,	0}, 	// 585
	{"Мотоцикл 'Восток'",	40000,		400,	0}, 	// 586
	{"Euros",				400000,		4000,	0}, 	// 587
	{"Лиаз Кафе", 			0,			0,		0}, 	// 588
	{"Club",				240000,		2400,	0}, 	// 589
	{"Вагон", 				0,			0,		0}, 	// 590
	{"Прицеп", 				0,			0,		0}, 	// 591
	{"Androm", 				0,			0,		0}, 	// 592
	{"Dodo", 				0,			0,		0}, 	// 593
	{"RCcam", 				0,			0,		0}, 	// 594
	{"Launch", 				0,			0,		0}, 	// 595
	{"ГАЗ Мил", 			0,			0,		0}, 	// 596
	{"ВАЗ мил", 			0,			0,		0}, 	// 597
	{"ВАЗ мил", 			0,			0,		0}, 	// 598
	{"УАЗ мил", 			0,			0,		0}, 	// 599
	{"АЗЛК 2335",			80000,		800,	0}, 	// 600
	{"БДРМ", 				0,			0,		0}, 	// 601
	{"Аlpha",				300000,		3000,	0}, 	// 602
	{"Phoenix", 			700000,		7000,	0}, 	// 603
	{"Glenshit", 			0,			0,		0}, 	// 604
	{"Космоа вто", 			0,			0,		0},		// 605
	{"Прицеп ", 			0,			0,		0},		// 606
	{"Прицеп ", 			0,			0,		0},		// 607
	{"Лестница", 			0,			0,		0},		// 608
	{"Авиа", 				0,			0,		0},		// 609
	{"Плуг", 				0,			0,		0},		// 610
	{"Прицеп уборщ", 		0,			0,		0}		// 611
};
// ------------------------------------

stock SetVehicleDataAll(vehicleid, modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, respawn_delay, addsiren=0, action_type, action_id)
{
	if(IsValidVehicleID(vehicleid))
	{
		SetVehicleData(vehicleid, V_MODELID, modelid);
		
		SetVehicleData(vehicleid, V_SPAWN_X, 		x);
		SetVehicleData(vehicleid, V_SPAWN_Y, 		y);
		SetVehicleData(vehicleid, V_SPAWN_Z, 		z);
		SetVehicleData(vehicleid, V_SPAWN_ANGLE, 	angle);
		
		SetVehicleData(vehicleid, V_COLOR_1, 	color1);
		SetVehicleData(vehicleid, V_COLOR_2, 	color2);
		
		SetVehicleData(vehicleid, V_RESPAWN_DELAY, 	respawn_delay);
		SetVehicleData(vehicleid, V_ADDSIREN, 		addsiren);
		
		SetVehicleData(vehicleid, V_ACTION_TYPE, 	action_type);
		SetVehicleData(vehicleid, V_ACTION_ID, 		action_id);
		SetVehicleData(vehicleid, V_DRIVER_ID, 		INVALID_PLAYER_ID);
		
		SetVehicleData(vehicleid, V_FUEL, 40.0);
		SetVehicleData(vehicleid, V_MILEAGE, 0.0);
		SetVehicleData(vehicleid, V_LIMIT, true);
	
		SetVehicleParamsEx(vehicleid, IsABike(vehicleid) ? VEHICLE_PARAM_ON : VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF);
	}
}

stock n_veh_AddStaticVehicleEx(modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, respawn_delay, addsiren=0, action_type=VEHICLE_ACTION_TYPE_NONE, action_id=VEHICLE_ACTION_ID_NONE)
{
	static n_veh_vehicleid = INVALID_VEHICLE_ID;
	
	n_veh_vehicleid = AddStaticVehicleEx(modelid, x, y, z, angle, color1, color2, respawn_delay);
	SetVehicleDataAll(n_veh_vehicleid, modelid, x, y, z, angle, color1, color2, respawn_delay, addsiren, action_type, action_id);

	return n_veh_vehicleid;
	
	// The vehicle ID of the vehicle created (1 - MAX_VEHICLES).
	// INVALID_VEHICLE_ID (65535) if vehicle was not created (vehicle limit reached or invalid vehicle model ID passed).
}
#if defined _ALS_AddStaticVehicleEx
    #undef AddStaticVehicleEx
#else
    #define _ALS_AddStaticVehicleEx
#endif
#define AddStaticVehicleEx n_veh_AddStaticVehicleEx

stock n_veh_AddStaticVehicle(modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, action_type=VEHICLE_ACTION_TYPE_NONE, action_id=VEHICLE_ACTION_ID_NONE)
{
	static n_veh_vehicleid = INVALID_VEHICLE_ID;
	
	n_veh_vehicleid = AddStaticVehicle(modelid, x, y, z, angle, color1, color2);
	SetVehicleDataAll(n_veh_vehicleid, modelid, x, y, z, angle, color1, color2, 0, 0, action_type, action_id);

	return n_veh_vehicleid;
	
	// The vehicle ID of the vehicle created (1 - MAX_VEHICLES).
	// INVALID_VEHICLE_ID (65535) if vehicle was not created (vehicle limit reached or invalid vehicle model ID passed).
}
#if defined _ALS_AddStaticVehicle
    #undef AddStaticVehicle
#else
    #define _ALS_AddStaticVehicle
#endif
#define AddStaticVehicle n_veh_AddStaticVehicle

stock n_veh_CreateVehicle(modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, respawn_delay, addsiren=0, action_type=VEHICLE_ACTION_TYPE_NONE, action_id=VEHICLE_ACTION_ID_NONE)
{
	static n_veh_vehicleid = INVALID_VEHICLE_ID;
	
	n_veh_vehicleid = CreateVehicle(modelid, x, y, z, angle, color1, color2, respawn_delay);
	SetVehicleDataAll(n_veh_vehicleid, modelid, x, y, z, angle, color1, color2, respawn_delay, addsiren, action_type, action_id);

	return n_veh_vehicleid;
	
	// The vehicle ID of the vehicle created (1 - MAX_VEHICLES).
	// INVALID_VEHICLE_ID (65535) if vehicle was not created (vehicle limit reached or invalid vehicle model ID passed).
}
#if defined _ALS_CreateVehicle
    #undef CreateVehicle
#else
    #define _ALS_CreateVehicle
#endif
#define CreateVehicle n_veh_CreateVehicle

stock n_veh_DestroyVehicle(vehicleid)
{
	if(IsValidVehicleID(vehicleid))
	{
		ClearVehicleData(vehicleid);
		DestroyVehicleLabel(vehicleid);
	}
	return DestroyVehicle(vehicleid);
}
#if defined _ALS_DestroyVehicle
    #undef DestroyVehicle
#else
    #define _ALS_DestroyVehicle
#endif
#define DestroyVehicle n_veh_DestroyVehicle

public OnGameModeInit()
{
    for(new idx = 0; idx < MAX_VEHICLES; idx ++)
	{
		ClearVehicleData(idx);
	}
	
#if defined n_veh_OnGameModeInit
    n_veh_OnGameModeInit();
#endif
    return 1;
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit n_veh_OnGameModeInit
#if defined n_veh_OnGameModeInit
forward n_veh_OnGameModeInit();
#endif  

// ---------------------------------------------------
stock SetVehicleParamsInit(vehicleid)
{	
	GetVehicleParamsEx
	(
		vehicleid, 
		g_vehicle_params[vehicleid][V_ENGINE],
		g_vehicle_params[vehicleid][V_LIGHTS],
		g_vehicle_params[vehicleid][V_ALARM],
		g_vehicle_params[vehicleid][V_LOCK],
		g_vehicle_params[vehicleid][V_BONNET],
		g_vehicle_params[vehicleid][V_BOOT],
		g_vehicle_params[vehicleid][V_OBJECTIVE]
	);
}

stock GetVehicleParam(vehicleid, E_VEHICLE_PARAMS_STRUCT:paramid)
{
	SetVehicleParamsInit(vehicleid);
	return g_vehicle_params[vehicleid][paramid];
}

stock SetVehicleParam(vehicleid, E_VEHICLE_PARAMS_STRUCT:paramid, set_value)
{
	SetVehicleParamsInit(vehicleid);
	g_vehicle_params[vehicleid][paramid] = bool: set_value;
	
	SetVehicleParamsEx
	(
		vehicleid,
		g_vehicle_params[vehicleid][V_ENGINE],
		g_vehicle_params[vehicleid][V_LIGHTS],
		g_vehicle_params[vehicleid][V_ALARM],
		g_vehicle_params[vehicleid][V_LOCK],
		g_vehicle_params[vehicleid][V_BONNET],
		g_vehicle_params[vehicleid][V_BOOT],
		g_vehicle_params[vehicleid][V_OBJECTIVE]
	);
}

stock CreateVehicleLabel(vehicleid, text[], color, Float:x, Float:y, Float:z, Float:drawdistance, testlos = 0, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_3D_TEXT_LABEL_SD)
{
	if(IsValidVehicle(vehicleid))
	{
		SetVehicleData(vehicleid, V_LABEL, CreateDynamic3DTextLabel(text, color, x, y, z, drawdistance, INVALID_PLAYER_ID, vehicleid, testlos, worldid, interiorid, playerid, streamdistance));
	}
	return 1;
}

stock UpdateVehicleLabel(vehicleid, color, text[])
{
	if(IsValidVehicleID(vehicleid))
	{
		if(IsValidDynamic3DTextLabel(GetVehicleData(vehicleid, V_LABEL)))
		{
			UpdateDynamic3DTextLabelText(GetVehicleData(vehicleid, V_LABEL), color, text);
		}
	}
	return 1;
}

stock DestroyVehicleLabel(vehicleid)
{
	if(IsValidVehicleID(vehicleid))
	{
		if(IsValidDynamic3DTextLabel(GetVehicleData(vehicleid, V_LABEL)))
		{
			DestroyDynamic3DTextLabel(GetVehicleData(vehicleid, V_LABEL));
			SetVehicleData(vehicleid, V_LABEL, Text3D: -1);
		}
	}
	return 1;
}