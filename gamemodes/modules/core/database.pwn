#define Database:%0(%1)                 Database_%0(%1)

new mysql; // �� ����������
new mysql_race[MAX_PLAYERS];

Database:Init()
{
    mysql_log(LOG_ERROR | LOG_WARNING, LOG_TYPE_HTML);
    mysql = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_BASE, MYSQL_PASS, 3306, true, 2);

    if(mysql_errno() != 0)
    {
        switch(mysql_errno())
        {
            case 1044: print("[������ ����������� � �� #1044] - ������� �������� ��� ������������");
            case 1045: print("[������ ����������� � �� #1045] - ������ �������� ������");
            case 1049: print("[������ ����������� � �� #1049] - ������� �������� ���� ������");
            case 2003: print("[������ ����������� � �� #2003] - ��� ����������� � �������� � ��");
            case 2005: print("[������ ����������� � �� #2005] - ����� �������� ������ �������");
            default: printf("[������ ����������� � �� #1045] - ����������� ������. ��� ������: %d", mysql_errno());
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