//&НаСервереБезКонтекста 
//Процедура СозданиеДинамическогоСоединенияНаСервере()  Экспорт 
//	ВСОпределение = Новый WSОпределения("http://localhost/NASCTest/ws/Reports?wsdl"); 
//	//ВСервис = ВСОпределение.Сервисы.Получить("ФункцииДляРассчета","ФункцииДляРассчета"); 
//	//ВТочкаВхода = ВСервис.ТочкиПодключения.Получить("ФункцииДляРассчетаSoap"); 
//	//ВОперация = ВТочкаВхода.Интерфейс.Операции.Получить("ПолучитьСреднее"); 
//	////СтруктураДанных = ВСОпределение.ФабрикаXDTO.Создать(ВОперация.Параметры.Получить("СтруктураДанных").Тип); 
//	////СтруктураДанных.КоличествоЭлементовВМассиве = 2; 
//	////СтруктураДанных.Комментарий = "Тест"; 
//	////СтруктураДанных.МассивЧисел.Добавить(0.1); 
//	////СтруктураДанных.МассивЧисел.Добавить(4); 
//	////СтруктураДанных.Проверить(); 
//	//ВСПрокси = Новый WSПрокси(ВСОпределение, "ФункцииДляРассчета","ФункцииДляРассчета","ФункцииДляРассчетаSoap"); 
//	//Ответ = ВСПрокси.ПолучитьСреднее(СтруктураДанных);
//	
//	
//КонецПроцедуры	

Функция ИмеютсяБазы()
	   Запрос = Новый Запрос;
	   Запрос.Текст = "ВЫБРАТЬ
	                  |	ИнформационныеБазы.Ссылка КАК Ссылка
	                  |ИЗ
	                  |	Справочник.ИнформационныеБазы КАК ИнформационныеБазы";
	   Выборка = Запрос.Выполнить().Выгрузить();
	   
	   Возврат Выборка.Количество() > 0;
	   
КонецФункции	


&НаСервере
Функция ПроверкаДанныхПодключения() Экспорт 
//ИПАдрес = Константы.Адрес.Получить();
////Логин = Константы.Пользователь.Получить();
////Пароль = Константы.Пароль.Получить();

//МассивДанных = Новый Массив;
//МассивДанных.Добавить(ИПАдрес);
////МассивДанных.Добавить(Логин);
////МассивДанных.Добавить(Пароль);

//Для Каждого Стр Из МассивДанных Цикл 
//	Если Не ЗначениеЗаполнено(Стр) Тогда 
//		 Возврат Ложь;
//	КонецЕсли;	
//КонецЦикла;	

Возврат ИмеютсяБазы();
КонецФункции	