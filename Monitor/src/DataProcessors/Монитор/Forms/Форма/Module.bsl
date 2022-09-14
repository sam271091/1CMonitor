&НаКлиенте
Процедура Проверить(Команда)
	СозданиеДинамическогоСоединенияНаСервере(ИБ);
КонецПроцедуры

&НаСервереБезКонтекста 
Процедура СозданиеДинамическогоСоединенияНаСервере(ИБ)  Экспорт 
	Сообщение = Новый СообщениеПользователю;
	Попытка
	ВСПрокси = ПодключитьСсылку(ИБ);	
	Ответ = ВСПрокси.CheckConnection();
	Сообщение.Текст = "Подключение установлено!";
	Исключение
	Сообщение.Текст = "Ошибка подключения!";	
	КонецПопытки;	
	Сообщение.Поле = "";
	Сообщение.Сообщить(); 
	
	
	
КонецПроцедуры	
&НаСервереБезКонтекста 
Функция ПодключитьСсылку(ИБ)
	ВСОпределение = Новый WSОпределения("http://" + СокрЛП(ИБ.Адрес) +"/" + СокрЛП(ИБ.НаименованиеВебСервера) +"/ws/Reports?wsdl",СокрЛП(ИБ.Пользователь),СокрЛП(ИБ.Пароль)); 
	ВСервис = ВСОпределение.Сервисы.Получить("UriReports","Reports"); 
	ВСПрокси = Новый WSПрокси(ВСОпределение, "UriReports","Reports","ReportsSoap"); 
	ВСПрокси.Пользователь = СокрЛП(ИБ.Пользователь);
	ВСПрокси.Пароль =  СокрЛП(ИБ.Пароль);
	Возврат ВСПрокси;
КонецФункции	
&НаСервереБезКонтекста 
Функция ПолучитьСписокотчетов(ИБ)
	ВСПрокси = ПодключитьСсылку(ИБ);
	Ответ = ВСПрокси.GetReportsList();
	Возврат Ответ.Получить();
КонецФункции	

&НаСервереБезКонтекста 
Функция ДостаточноПрав(ИБ)
	ВСПрокси = ПодключитьСсылку(ИБ);
	Ответ = ВСПрокси.PermissionsCheck();
	Возврат Ответ.Получить();
КонецФункции

&НаСервереБезКонтекста 
Функция ПолучитьСписокНастроек(ИмяОтчета,ИБ)
	ВСПрокси = ПодключитьСсылку(ИБ);
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ИмяОтчета",ИмяОтчета);
	
	Ответ = ВСПрокси.GetSettingslist(Новый ХранилищеЗначения(СтруктураНастроек,новый СжатиеДанных(9)));
	Возврат Ответ.Получить();
КонецФункции	


&НаКлиенте
Процедура ОтчетыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	//СписокОтчетов = ПолучитьСписокотчетов();
	//
	//Для Каждого Стр Из СписокОтчетов Цикл 
	//	Элементы.Отчеты.СписокВыбора.Добавить(Стр.Значение,Стр.Представление);
	//КонецЦикла;	

	
	ВыбранныйЭлемент = ЭтаФорма.ВыбратьИзСписка(Элементы.Отчеты.СписокВыбора, Элемент);	
	
	Если ВыбранныйЭлемент <> Неопределено Тогда 
	Отчет =   ВыбранныйЭлемент.Представление;
	Объект.ОтчетЗначение =  ВыбранныйЭлемент.Значение;
	
	
    СписокНастроек = ПолучитьСписокНастроек(ВыбранныйЭлемент.Значение,ИБ);
	
	
	Элементы.Настройка.СписокВыбора.Очистить();
	
	Настройка = Неопределено;
	
	Для Каждого Стр Из СписокНастроек Цикл 
		Элементы.Настройка.СписокВыбора.Добавить(Стр,Стр);
	КонецЦикла;

	
	
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОтчеты(Команда)
	

	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИБ = Параметры.ИБ;
	
	Если Не ДостаточноПрав(ИБ) Тогда 
		Сообщить("Недостаточно прав! За дополнительной информацией обратитесь к администратору базы 1С");
		Отказ = Истина; 
	КонецЕсли;	
	
	
	СписокОтчетов = ПолучитьСписокотчетов(ИБ);
	
	Для Каждого Стр Из СписокОтчетов Цикл 
		Элементы.Отчеты.СписокВыбора.Добавить(Стр.Значение,Стр.Представление);
	КонецЦикла;
	 
КонецПроцедуры



&НаСервере
Функция ПолучитьОсновнуюБазу()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ИнформационныеБазы.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.ИнформационныеБазы КАК ИнформационныеБазы
	               |ГДЕ
	               |	ИнформационныеБазы.Основная";
  Выборка = Запрос.Выполнить().Выбрать();
  
  Если Запрос.Выполнить().Пустой() Тогда 
	 Возврат Справочники.ИнформационныеБазы.ПустаяСсылка(); 
  КонецЕсли;	  
  
  Выборка.Следующий();
  
  Возврат Выборка.Ссылка;
	
КонецФункции	

&НаКлиенте
Процедура Сформировать(Команда)
	
	Если Не ЗначениеЗаполнено(Отчет) Тогда 
		Сообщить("Выберите Отчет!");
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Настройка) Тогда 
		Сообщить("Выберите настройку!");
		Возврат;
	КонецЕсли;	
	
	ТабДок = Элементы.ТабДок;
	ТабДок.АвтоМасштаб = истина;
	ПолучитьМакет(ТабДок);

КонецПроцедуры

&НаСервере
Процедура ПолучитьМакет(ТабДокумент)
	ВСПрокси = ПодключитьСсылку(ИБ);
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ИмяОтчета",Объект.ОтчетЗначение);
	СтруктураНастроек.Вставить("Настройка",Объект.НастройкаЗначение);
	СтруктураНастроек.Вставить("Период",Объект.Период);
	
	
	Ответ =  ВСПрокси.GenerateReport(Новый ХранилищеЗначения(СтруктураНастроек,новый СжатиеДанных(9)));
	
	ТабДокумент =  Ответ.Получить();
	
КонецПроцедуры	

&НаКлиенте
Процедура НастройкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ВыбранныйЭлемент = ЭтаФорма.ВыбратьИзСписка(Элементы.Настройка.СписокВыбора, Элемент);	
	
	Если ВыбранныйЭлемент <> Неопределено Тогда 
	Настройка =   ВыбранныйЭлемент.Представление;
	Объект.НастройкаЗначение =  ВыбранныйЭлемент.Значение;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Свернуть(Команда)
	Если Элементы.Группа1.Видимость = Истина Тогда 
		Элементы.Группа1.Видимость = Ложь;
		Элементы.Группа2.Видимость = Ложь;
		
		Элементы.Свернуть.Заголовок = "Развернуть";
	Иначе 
		Элементы.Группа1.Видимость = Истина;
		Элементы.Группа2.Видимость = Истина;
		
		Элементы.Свернуть.Заголовок = "Свернуть";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетыПриИзменении(Элемент)
	//Объект.ОтчетЗначение
КонецПроцедуры
