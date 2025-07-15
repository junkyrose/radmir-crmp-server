#define Database:%0(%1)                 Database_%0(%1)

new mysql; // ид соединения
new mysql_race[MAX_PLAYERS];

Database:Init()
{
    mysql_log(LOG_ERROR | LOG_WARNING, LOG_TYPE_HTML);
    mysql = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_BASE, MYSQL_PASS, 3306, true, 2);

    if(mysql_errno() != 0)
    {
        switch(mysql_errno())
        {
            case 1044: print("[Ошибка подключения к БД #1044] - Указано неверное имя пользователя");
            case 1045: print("[Ошибка подключения к БД #1045] - Указан неверный пароль");
            case 1049: print("[Ошибка подключения к БД #1049] - Указана неверная база данных");
            case 2003: print("[Ошибка подключения к БД #2003] - Нет подключения к хостингу с БД");
            case 2005: print("[Ошибка подключения к БД #2005] - Адрес хостинга указан неверно");
            default: printf("[Ошибка подключения к БД #1045] - Неизвестная ошибка. Код ошибки: %d", mysql_errno());
        }

        return 0;
    }

    mysql_set_charset("cp1251");
	mysql_query(mysql, "SET NAMES cp1251;");
	mysql_query(mysql, "SET SESSION character_set_server = 'cp1251';");

    return 1;
}

Database:Shutdown()
{
    return mysql_close(mysql);
}