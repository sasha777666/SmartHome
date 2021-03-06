﻿
// ПоставитьКомандыВОчередь - Записывает набор командр в регистры сведений COM и NET
// В массиве команд не должно быть несколько команд на один и тот же пин
// Возвращает: Массив - набор пинов для которых команды записаны небыли (в регистре есь другие с ожиданием выполнения).
// Если массив пустой, значит всё успешно записано. 
// Параметры:
// МассивКоманд - Массив - Массив со структурами, в структуре: НомерПина, Команда, Аргумент.
Функция ПоставитьКомандыВОчередь(МассивКоманд) // не должно быть 2-х команд на один и тот же пин одного контроллера
		
	Если ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM") Тогда // COM
		ОтветМассив = ЗаписатьКомандыВРегистрCOM(МассивКоманд); 
	Иначе // NET
		ОтветМассив = ЗаписатьКомандыВРегистрNET(МассивКоманд);
	КонецЕсли;		
			
	Возврат ОтветМассив;
	
КонецФункции
Функция ЗаписатьКомандыВРегистрCOM(МассивCOM)
	
	МассивПинов = Новый Массив();
	Для Каждого Строка Из МассивCOM Цикл
		МассивПинов.Добавить(Строка.НомерПина);	
	КонецЦикла;
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	COM.НомерПина КАК НомерПина
	               |ИЗ
	               |	РегистрСведений.COM КАК COM
	               |ГДЕ
	               |	COM.НомерCOMПорта = &НомерCOMПорта
	               |	И COM.НомерПина В(&МассивПинов)
	               |	И (НЕ COM.КомандаВыполнена
	               |			ИЛИ COM.ДатаВыполнения > &ТекущаяДатаМинус5Сек)
	               |	И (НЕ COM.Ошибка
	               |			ИЛИ COM.ДатаВыполнения > &ТекущаяДатаМинус5Сек)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерПина";
	Запрос.УстановитьПараметр("НомерCOMПорта", Оборудование.КонтроллерCOMNET.НомерCOMПорта);
	Запрос.УстановитьПараметр("МассивПинов", МассивПинов); 
	Запрос.УстановитьПараметр("ТекущаяДатаМинус5Сек", ТекущаяДата()-5); 
	// Запрос проверяет есть ли в очереди не выполненные задания 
	// или задания выполненные в течении последних 5 секунд	
	ЗанятыеПины = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("НомерПина");
	
	ОтветМассивКоманд = Новый Массив();

	Для Каждого Строка Из МассивCOM Цикл
		Если ЗанятыеПины.Найти(Строка.НомерПина) = Неопределено Тогда // невополненого задания в очереди нет
			Менеджер = РегистрыСведений.COM.СоздатьМенеджерЗаписи();
			Менеджер.НомерCOMПорта = Оборудование.КонтроллерCOMNET.НомерCOMПорта;
			Менеджер.НомерПина = Строка.НомерПина;
			Менеджер.Команда = Строка.Команда;
			Менеджер.Аргумент = Строка.Аргумент;	
			Менеджер.Записать(Истина);		
		Иначе
			ОтветМассивКоманд.Добавить(Строка);
		КонецЕсли;
	КонецЦикла;		
	
	Возврат ОтветМассивКоманд;
	
КонецФункции
Функция ЗаписатьКомандыВРегистрNET(МассивNET)

	МассивПинов = Новый Массив();
	Для Каждого Строка Из МассивNET Цикл
		МассивПинов.Добавить(Строка.НомерПина);	
	КонецЦикла;
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	NET.НомерПина КАК НомерПина
	               |ИЗ
	               |	РегистрСведений.NET КАК NET
	               |ГДЕ
	               |	NET.АдресПорт = &АдресПорт
	               |	И NET.НомерПина В(&МассивПинов)
	               |	И (НЕ NET.КомандаВыполнена
	               |			ИЛИ NET.ДатаВыполнения > &ТекущаяДатаМинус5Сек)
	               |	И (НЕ NET.Ошибка
	               |			ИЛИ NET.ДатаВыполнения > &ТекущаяДатаМинус5Сек)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерПина";
	Запрос.УстановитьПараметр("АдресПорт", Оборудование.КонтроллерCOMNET.НомерCOMПорта);
	Запрос.УстановитьПараметр("МассивПинов", МассивПинов); 
	Запрос.УстановитьПараметр("ТекущаяДатаМинус5Сек", ТекущаяДата()-5); 
	// Запрос проверяет есть ли в очереди не выполненные задания 
	// или задания выполненные в течении последних 5 секунд	
	ЗанятыеПины = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("НомерПина");
	
	ОтветМассивКоманд = Новый Массив();
	
	Для Каждого Строка Из МассивNET Цикл
		Если ЗанятыеПины.Найти(Строка.НомерПина) = Неопределено Тогда // невополненого задания в очереди нет
			Менеджер = РегистрыСведений.NET.СоздатьМенеджерЗаписи();
			Менеджер.АдресПорт = Оборудование.КонтроллерCOMNET.АдресПорт;
			Менеджер.НомерПина = Строка.НомерПина;
			Менеджер.Команда = Строка.Команда;
			Менеджер.Аргумент = Строка.Аргумент;	
			Менеджер.Записать(Истина);		
		Иначе
			ОтветМассивКоманд.Добавить(Строка);
		КонецЕсли;
	КонецЦикла;		
	
	Возврат ОтветМассивКоманд;
	
КонецФункции

// ПолучитьРезультатыВыполненияКоманд - Получает результаты выполнения команд из регистров сведений COM и NET и очищает их
// В массиве команд не должно быть несколько команд на один и тот же пин
// Возвращает: Массив - Массив со структурами с результатами выполнения команд.
// Параметры:
// МассивКоманд - Массив - Массив со структурами, в структуре: НомерПина, Команда, Аргумент.
Функция ПолучитьРезультатыВыполненияКоманд(МассивКоманд)

	Если ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM") Тогда // COM
		ОтветМассив = ПолучитьРезультатыВыполненияКомандCOM(МассивКоманд); 
	Иначе // NET
		ОтветМассив = ПолучитьРезультатыВыполненияКомандNET(МассивКоманд);
	КонецЕсли;		

	Возврат ОтветМассив;
	
КонецФункции
Функция ПолучитьРезультатыВыполненияКомандCOM(МассивCOM)
	
	МассивПинов = Новый Массив();
	Для Каждого Строка Из МассивCOM Цикл
		МассивПинов.Добавить(Строка.НомерПина);	
	КонецЦикла;

	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	COM.НомерПина КАК НомерПина
	               |ИЗ
	               |	РегистрСведений.COM КАК COM
	               |ГДЕ
	               |	COM.НомерCOMПорта = &НомерCOMПорта
	               |	И COM.НомерПина В(&МассивПинов)
	               |	И (COM.КомандаВыполнена
	               |			ИЛИ COM.Ошибка)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерПина";
	Запрос.УстановитьПараметр("НомерCOMПорта", Оборудование.КонтроллерCOMNET.НомерCOMПорта);
	Запрос.УстановитьПараметр("МассивПинов", МассивПинов); 
	// Запрос Проверяет выполнена ли наше задание	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ОтветМассив = Новый Массив();
	
	Пока Выборка.Следующий() Цикл
		Менеджер = РегистрыСведений.COM.СоздатьМенеджерЗаписи();
		Менеджер.НомерCOMПорта = Оборудование.КонтроллерCOMNET.НомерCOMПорта;
		Менеджер.НомерПина = Выборка.НомерПина;
		Менеджер.Прочитать();	
		СтруктураОтвета = Новый Структура;
		СтруктураОтвета.Вставить("НомерПина", Менеджер.НомерПина); 
		СтруктураОтвета.Вставить("ОтветСтатус", Менеджер.ОтветСтатус);
		СтруктураОтвета.Вставить("ОтветАргумент1", Менеджер.ОтветАргумент1);
	    СтруктураОтвета.Вставить("ОтветАргумент2", Менеджер.ОтветАргумент2);
		СтруктураОтвета.Вставить("КомандаВыполнена", Менеджер.КомандаВыполнена);
		СтруктураОтвета.Вставить("Ошибка", Менеджер.Ошибка);
		ОтветМассив.Добавить(СтруктураОтвета);
		Менеджер.Удалить();		
	КонецЦикла;
			
	Возврат ОтветМассив;	
	
КонецФункции
Функция ПолучитьРезультатыВыполненияКомандNET(МассивNET)
	
	МассивПинов = Новый Массив();
	Для Каждого Строка Из МассивNET Цикл
		МассивПинов.Добавить(Строка.НомерПина);	
	КонецЦикла;

	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	NET.НомерПина КАК НомерПина
	               |ИЗ
	               |	РегистрСведений.NET КАК NET
	               |ГДЕ
	               |	NET.АдресПорт = &АдресПорт
	               |	И NET.НомерПина В(&МассивПинов)
	               |	И (NET.КомандаВыполнена
	               |			ИЛИ NET.Ошибка)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерПина";
	Запрос.УстановитьПараметр("АдресПорт", Оборудование.КонтроллерCOMNET.АдресПорт);
	Запрос.УстановитьПараметр("МассивПинов", МассивПинов); 
	// Запрос Проверяет выполнена ли наше задание	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ОтветМассив = Новый Массив();
	
	Пока Выборка.Следующий() Цикл
		Менеджер = РегистрыСведений.NET.СоздатьМенеджерЗаписи();
		Менеджер.АдресПорт = Оборудование.КонтроллерCOMNET.АдресПорт;
		Менеджер.НомерПина = Выборка.НомерПина;
		Менеджер.Прочитать();	
		СтруктураОтвета = Новый Структура;
		СтруктураОтвета.Вставить("НомерПина", Менеджер.НомерПина); 
		СтруктураОтвета.Вставить("ОтветСтатус", Менеджер.ОтветСтатус);
		СтруктураОтвета.Вставить("ОтветАргумент1", Менеджер.ОтветАргумент1);
	    СтруктураОтвета.Вставить("ОтветАргумент2", Менеджер.ОтветАргумент2);
		СтруктураОтвета.Вставить("КомандаВыполнена", Менеджер.КомандаВыполнена);
		СтруктураОтвета.Вставить("Ошибка", Менеджер.Ошибка);
		ОтветМассив.Добавить(СтруктураОтвета);
		Менеджер.Удалить();		
	КонецЦикла;
			
	Возврат ОтветМассив;	
	
КонецФункции

 
Функция ЗаполнитьПины() Экспорт
	
	СообщениеСНенайденнымиПинами = "";
	
	СтрокаСНастройкой = Оборудование.Пины.Найти("ПинНапряжениеАКБ", "Наименование");
	Если СтрокаСНастройкой = Неопределено Тогда 
		СообщениеСНенайденнымиПинами = СообщениеСНенайденнымиПинами + "Не задан ПИН для ""ПинНапряжениеАКБ""; ";
	Иначе
		ПинНапряжениеАКБ = СтрокаСНастройкой.НомерПина;
	КонецЕсли;
	СтрокаСНастройкой = Оборудование.Пины.Найти("ПинТокАКБ", "Наименование");
	Если СтрокаСНастройкой = Неопределено Тогда 
		СообщениеСНенайденнымиПинами = СообщениеСНенайденнымиПинами + "Не задан ПИН для ""ПинТокАКБ""; ";
	Иначе
		ПинТокАКБ = СтрокаСНастройкой.НомерПина;
	КонецЕсли;
	СтрокаСНастройкой = Оборудование.Пины.Найти("ПинШимАКБ", "Наименование");
	Если СтрокаСНастройкой = Неопределено Тогда 
		СообщениеСНенайденнымиПинами = СообщениеСНенайденнымиПинами + "Не задан ПИН для ""ПинШимАКБ""; ";
	Иначе
		ПинШимАКБ = СтрокаСНастройкой.НомерПина;
	КонецЕсли;
	СтрокаСНастройкой = Оборудование.Пины.Найти("ПинРелеПотребителейАКБ", "Наименование");
	Если СтрокаСНастройкой = Неопределено Тогда 
		СообщениеСНенайденнымиПинами = СообщениеСНенайденнымиПинами + "Не задан ПИН для ""ПинРелеПотребителейАКБ""; ";
	Иначе
		ПинРелеПотребителейАКБ = СтрокаСНастройкой.НомерПина;
	КонецЕсли;

	Возврат СообщениеСНенайденнымиПинами;
	
КонецФункции
Функция  ЗаполнитьНастройки() Экспорт
	
	СообщениеСНенайденнымиНастройками = "";
	
	// Настройки в реквизитах
	СтрокаСТабСНастройкамиРеквизитов = Оборудование.Настройки.Найти("Реквизиты",  "Наименование");
	Если СтрокаСТабСНастройкамиРеквизитов = Неопределено Тогда 
		СообщениеСНенайденнымиНастройками = СообщениеСНенайденнымиНастройками + "Не заполнена настройка ""Реквизиты"" (В справочнике оборудование); ";
	Иначе
		ТабСНастройкамиРеквизитов = СтрокаСТабСНастройкамиРеквизитов.Настройка.ТаблицаНастроек;
		
		СтрокаСПараметром = ТабСНастройкамиРеквизитов.Найти("НастройкаКодОпорногоНапряжения", "Параметр");
		Если СтрокаСПараметром = Неопределено Тогда 
			СообщениеСНенайденнымиНастройками = СообщениеСНенайденнымиНастройками + "Не указан параметр ""НастройкаКодОпорногоНапряжения""; ";
		Иначе
			НастройкаКодОпорногоНапряжения = СтрокаСПараметром.Значение;
		КонецЕсли;
		
		СтрокаСПараметром = ТабСНастройкамиРеквизитов.Найти("НастройкаОпорноеНапряжение", "Параметр");
		Если СтрокаСПараметром = Неопределено Тогда 
			СообщениеСНенайденнымиНастройками = СообщениеСНенайденнымиНастройками + "Не указан параметр ""НастройкаОпорноеНапряжение""; ";
		Иначе
			НастройкаОпорноеНапряжение = СтрокаСПараметром.Значение;
		КонецЕсли;
		
		СтрокаСПараметром = ТабСНастройкамиРеквизитов.Найти("НастройкаМинНапряжение", "Параметр");
		Если СтрокаСПараметром = Неопределено Тогда 
			СообщениеСНенайденнымиНастройками = СообщениеСНенайденнымиНастройками + "Не указан параметр ""НастройкаМинНапряжение""; ";
		Иначе
			НастройкаМинНапряжение = СтрокаСПараметром.Значение;
		КонецЕсли;

		СтрокаСПараметром = ТабСНастройкамиРеквизитов.Найти("НастройкаМаксТокЗаряда", "Параметр");
		Если СтрокаСПараметром = Неопределено Тогда 
			СообщениеСНенайденнымиНастройками = СообщениеСНенайденнымиНастройками + "Не указан параметр ""НастройкаМаксТок""; ";
		Иначе
			НастройкаМаксТокЗаряда = СтрокаСПараметром.Значение;
		КонецЕсли;

	КонецЕсли;
	
	// Настройки ЗависимостьТокаЗарядаОтНапряженияАКБ
	СтрокаСТабЗависимостьТокаЗарядаОтНапряженияАКБ = Оборудование.Настройки.Найти("ЗависимостьТокаЗарядаОтНапряженияАКБ",  "Наименование");
	Если СтрокаСТабЗависимостьТокаЗарядаОтНапряженияАКБ = Неопределено Тогда 
		СообщениеСНенайденнымиНастройками = СообщениеСНенайденнымиНастройками + "Не заполнена настройка ""ЗависимостьТокаЗарядаОтНапряженияАКБ"" (В справочнике оборудование); ";
	Иначе
		ТабЗависимостьТокаЗарядаОтНапряженияАКБ = СтрокаСТабЗависимостьТокаЗарядаОтНапряженияАКБ.Настройка.ТаблицаНастроек;
		ЗависимостьТокаЗарядаОтНапряженияАКБ.Очистить();
		Для Каждого Строка Из ТабЗависимостьТокаЗарядаОтНапряженияАКБ Цикл
			нСтрока = ЗависимостьТокаЗарядаОтНапряженияАКБ.Добавить();	
			нСтрока.Напряжение = Строка.Параметр;
			нСтрока.Ток = Строка.Значение;
		КонецЦикла;	
	КонецЕсли;
	
	
	Возврат СообщениеСНенайденнымиНастройками;
	

КонецФункции
Функция ПроверитьОткрытьПортСвязь()
	
	Ответ = "";
	Если ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM") Тогда // COM
		ПроверкаСвязи = К.ПроверитьКомпонентуИСвязьCOMПорта(Оборудование.КонтроллерCOMNET.НомерCOMПорта, Истина);
		Если ПроверкаСвязи = Неопределено Тогда 
			Ответ = Ответ + "Сбой при выполнении проверки связи (Компоненты). Порт: " + Оборудование.КонтроллерCOMNET.НомерCOMПорта + " ;";	
		ИначеЕсли ПроверкаСвязи = 1 Тогда //Компонента есть, ком порт открыт и работает
			// Ничего не делаем всё ОК
		ИначеЕсли ПроверкаСвязи = 2 Тогда // Нет компоненты, нужно открыть ком порт
			ПортОткрыт = К.ОткрытьCOMПорт(Оборудование.КонтроллерCOMNET.НомерCOMПорта, Оборудование.КонтроллерCOMNET.СкоростьCOMПорта);
			Если ПортОткрыт = Неопределено или Не ПортОткрыт Тогда 
		    	Ответ = Ответ + "Не удалось открыть COM порт номер: " + Оборудование.КонтроллерCOMNET.НомерCOMПорта + " ;";
			КонецЕсли;
			ПроверкаСвязи = К.ВыполнитьКоманду(Оборудование.КонтроллерCOMNET.НомерCOMПорта, 0, 254, 77);
			Если ПроверкаСвязи.ОтветСтатус <> 254 или ПроверкаСвязи.ОтветАргумент1 <> 77 Тогда
				Ответ = Ответ + "Не пройдена проверка связи; ";	
			КонецЕсли;		
		ИначеЕсли ПроверкаСвязи = 3 Тогда // Не пройдена проверка связи, Пересоздаём компоненту и открываем порт
			ПортОткрыт = К.ПересоздатьКомпонентуИОткрытьCOMПорт(Оборудование.КонтроллерCOMNET.НомерCOMПорта, Оборудование.КонтроллерCOMNET.СкоростьCOMПорта);
			Если ПортОткрыт = Неопределено или Не ПортОткрыт Тогда 
		    	Ответ = Ответ + "Не удалось открыть COM порт номер: " + Оборудование.КонтроллерCOMNET.НомерCOMПорта + " ;";
			КонецЕсли;
			ПроверкаСвязи = К.ВыполнитьКоманду(Оборудование.КонтроллерCOMNET.НомерCOMПорта, 0, 254, 77);
			Если ПроверкаСвязи.ОтветСтатус <> 254 или ПроверкаСвязи.ОтветАргумент1 <> 77 Тогда
				Ответ = Ответ + "Не пройдена проверка связи; ";	
			КонецЕсли;	
		КонецЕсли;
	Иначе // NET
		ПроверкаСвязи = К.ВыполнитьКоманду(Оборудование.КонтроллерCOMNET.АдресПорт, 0, 254, 77);
		Если ПроверкаСвязи.ОтветСтатус <> 254 или ПроверкаСвязи.ОтветАргумент1 <> 77 Тогда
			Ответ = Ответ + "Не пройдена проверка связи; ";	
		КонецЕсли;		
	КонецЕсли;
	
	Возврат Ответ;
			
КонецФункции


Процедура ПроверитьНеобходимостьОтключитьВнешнююНагрузку()
	
	//Измеряем напряжение всей сети, отключать ШИМ не нужно, т.к.если источник вытягивает нагрузку то отключать АКБ не нужно
	Если ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM") Тогда // COM
		Ответ = К._analogRead_СреднееАрифметическое(Оборудование.КонтроллерCOMNET.НомерCOMПорта, ПинНапряжениеАКБ, 20);
	Иначе // NET
		Ответ = К._analogRead_СреднееАрифметическое(Оборудование.КонтроллерCOMNET.АдресПорт, ПинНапряжениеАКБ, 20);
	КонецЕсли;
	Если ТипЗнч(Ответ) = Тип("Число") Тогда
		НапряжениеАКБСУчётомШИМ = Конвертация.Напряжение(Ответ, НастройкаОпорноеНапряжение,50600, 900000);	
		Если НапряжениеАКБСУчётомШИМ >= НастройкаМинНапряжение Тогда // включаем либо оставляем включенным
			СостояниеРеле = 1;
		Иначе
			СостояниеРеле = 0; // Выключаем или оставляем выключенным
		КонецЕсли;			
	Иначе // Ошибка измерения, предпологаем худьшее, отключаем внешних потребителей
		СостояниеРеле = 0; // выключим
	КонецЕсли;

	//Задаём состояние
	Если ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM") Тогда // COM
		К._pinModeOUTPUT_digitalWrite(Оборудование.КонтроллерCOMNET.НомерCOMПорта, ПинРелеПотребителейАКБ, СостояниеРеле);
	Иначе // NET
		К._pinModeOUTPUT_digitalWrite(Оборудование.КонтроллерCOMNET.АдресПорт, ПинРелеПотребителейАКБ, СостояниеРеле);
	КонецЕсли;	
	
КонецПроцедуры
Функция ИзмеритьНапряжение();
	
	Если ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM") Тогда // COM
		Ответ = К._analogRead_СреднееАрифметическое(Оборудование.КонтроллерCOMNET.НомерCOMПорта, ПинНапряжениеАКБ, 20);
	Иначе // NET
		Ответ = К._analogRead_СреднееАрифметическое(Оборудование.КонтроллерCOMNET.АдресПорт, ПинНапряжениеАКБ, 20);
	КонецЕсли;
	Если ТипЗнч(Ответ) = Тип("Число") Тогда
		НапряжениеАКБ = Конвертация.Напряжение(Ответ, НастройкаОпорноеНапряжение,50600, 900000);	
		ДатаНапряжениеАКБ = ТекущаяДата();
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции
Функция ИзмеритьНапряжениеАКБСПодключеннымИсточником();
	
	Если ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM") Тогда // COM
		Ответ = К._analogRead_СреднееАрифметическое(Оборудование.КонтроллерCOMNET.НомерCOMПорта, ПинНапряжениеАКБ, 20);
	Иначе // NET
		Ответ = К._analogRead_СреднееАрифметическое(Оборудование.КонтроллерCOMNET.АдресПорт, ПинНапряжениеАКБ, 20);
	КонецЕсли;
	Если ТипЗнч(Ответ) = Тип("Число") Тогда
		НапряжениеАКБСПодключеннымИсточником = Конвертация.Напряжение(Ответ, НастройкаОпорноеНапряжение,50600, 900000);	
		ДатаНапряжениеАКБСПодключеннымИсточником = ТекущаяДата();
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции
Функция ИзмеритьТок();
	
	Если ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM") Тогда // COM
		Ответ = К._analogRead_СреднееАрифметическое(Оборудование.КонтроллерCOMNET.НомерCOMПорта, ПинТокАКБ, 20);
	Иначе // NET
		Ответ = К._analogRead_СреднееАрифметическое(Оборудование.КонтроллерCOMNET.АдресПорт, ПинТокАКБ, 20);
	КонецЕсли;
	Если ТипЗнч(Ответ) = Тип("Число") Тогда 
		ТокАКБ = (Ответ - 511) / 512 * 20;
		ДатаТокАКБ = ТекущаяДата();
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции
Процедура ЗадатьОпорноеНапряжение()
	
	Если ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM") Тогда // COM
		К.analogReference(Оборудование.КонтроллерCOMNET.НомерCOMПорта, НастройкаКодОпорногоНапряжения);
	Иначе // NET
		К.analogReference(Оборудование.КонтроллерCOMNET.АдресПорт, НастройкаКодОпорногоНапряжения);
	КонецЕсли;
	
	
КонецПроцедуры
Функция ЗадатьШИМ() Экспорт
	
	Если ТипЗнч(Оборудование.КонтроллерCOMNET) = Тип("СправочникСсылка.КонтроллерыCOM") Тогда // COM
		Ответ = К.analogWrite(Оборудование.КонтроллерCOMNET.НомерCOMПорта, ПинШимАКБ, ЗаполненностьШИМ);
	Иначе // NET
		Ответ = К.analogWrite(Оборудование.КонтроллерCOMNET.АдресПорт, ПинШимАКБ, ЗаполненностьШИМ);
	КонецЕсли;

	Возврат Ответ;
	
КонецФункции
 
Процедура ПолучитьТекущиеДанные() Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТекущиеДанныеОборудования.ОбъектДанных,
	               |	ТекущиеДанныеОборудования.Данные,
	               |	ТекущиеДанныеОборудования.Дата
	               |ИЗ
	               |	РегистрСведений.ТекущиеДанныеОборудования КАК ТекущиеДанныеОборудования
	               |ГДЕ
	               |	ТекущиеДанныеОборудования.Оборудование = &Оборудование";
	Запрос.УстановитьПараметр("Оборудование", Оборудование);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл		
		КодВыполнения = "" + СокрЛП(Выборка.ОбъектДанных) + " = Выборка.Данные;
		|Дата" + СокрЛП(Выборка.ОбъектДанных) + " = Выборка.Дата;"; 
		Попытка
			Выполнить(КодВыполнения);
		Исключение
			Сообщения = Сообщения + Символы.ПС + "Ошибка при заполнении реквизита = " + Выборка.ОбъектДанных + ". Ошибка = " + ОписаниеОшибки();		
		КонецПопытки;		
	КонецЦикла;
			   
КонецПроцедуры

Процедура ЗаписатьТекущиеДанные() Экспорт
	
	//НапряжениеАКБ
	Менеджер = РегистрыСведений.ТекущиеДанныеОборудования.СоздатьМенеджерЗаписи();
	Менеджер.Оборудование = Оборудование;
	Менеджер.ОбъектДанных = "НапряжениеАКБ";
	Менеджер.Данные = НапряжениеАКБ;
	Менеджер.Дата = ТекущаяДата();
	Менеджер.Записать(Истина);	
	
	//ТокАКБ
	Менеджер = РегистрыСведений.ТекущиеДанныеОборудования.СоздатьМенеджерЗаписи();
	Менеджер.Оборудование = Оборудование;
	Менеджер.ОбъектДанных = "ТокАКБ";
	Менеджер.Данные = ТокАКБ;
	Менеджер.Дата = ТекущаяДата();
	Менеджер.Записать(Истина);	
	
	//ЗаполненностьШИМ
	Менеджер = РегистрыСведений.ТекущиеДанныеОборудования.СоздатьМенеджерЗаписи();
	Менеджер.Оборудование = Оборудование;
	Менеджер.ОбъектДанных = "ЗаполненностьШИМ";
	Менеджер.Данные = ЗаполненностьШИМ;
	Менеджер.Дата = ТекущаяДата();
	Менеджер.Записать(Истина);	
	
	//НапряжениеАКБСПодключеннымИсточником
	Менеджер = РегистрыСведений.ТекущиеДанныеОборудования.СоздатьМенеджерЗаписи();
	Менеджер.Оборудование = Оборудование;
	Менеджер.ОбъектДанных = "НапряжениеАКБСПодключеннымИсточником";
	Менеджер.Данные = НапряжениеАКБСПодключеннымИсточником;
	Менеджер.Дата = ТекущаяДата();
	Менеджер.Записать(Истина);	
	
КонецПроцедуры


Процедура Инициализация() Экспорт
	
	Ответ = ЗаполнитьПины();
	Если ЗначениеЗаполнено(Ответ) Тогда 
		Сообщения = Сообщения + Символы.ПС + ТекущаяДата() + " " + Ответ;
	КонецЕсли;
	
	Ответ = ЗаполнитьНастройки();
	Если ЗначениеЗаполнено(Ответ) Тогда 
		Сообщения = Сообщения + Символы.ПС + ТекущаяДата() + " " + Ответ;
	КонецЕсли;
	
	Ответ = ПроверитьОткрытьПортСвязь();
	Если ЗначениеЗаполнено(Ответ) Тогда 
		Сообщения = Сообщения + Символы.ПС + ТекущаяДата() + " " + Ответ;
	КонецЕсли;
	
		
КонецПроцедуры

Процедура ВыполнитьИтерацию(NativeS) Экспорт
	
	// Похоже этот код более не нужен         
	//МассивКоманд = Новый Массив();
	//МассивКоманд.Добавить( Новый Структура("НомерПина, Команда, Аргумент", ПинНапряжениеАКБ, 104, 20));
	//МассивКоманд.Добавить( Новый Структура("НомерПина, Команда, Аргумент", ПинТокАКБ, 104, 20));
	//ПроизвестиИзмерения(МассивКоманд, NativeS);
	
	Компонента = К.NativeПодключитьКомпоненту();
	ЗадержкаПередИзмерениемТока = 200; // в миллисекундах
		
	ПроверитьНеобходимостьОтключитьВнешнююНагрузку();
	
	//регулируем ток согласно таблице
	Если ЗависимостьТокаЗарядаОтНапряженияАКБ.Количество() > 0 Тогда // настраиваем
		ТекущийШим = ЗаполненностьШИМ;
		ЗаполненностьШИМ = 0; // отключаем шим чтобы измерить напряжение акб
		ЗадатьШИМ();
		Если ИзмеритьНапряжение() = Истина Тогда 
			
			//Ищем ток для нашего напряжения
			ЗависимостьТокаЗарядаОтНапряженияАКБ.Сортировать("Напряжение"); 
		    НужныйТок = 0; // задаём на случай если в таблице не окажется нашего диапазона
			Для Каждого СтрокаТаб Из ЗависимостьТокаЗарядаОтНапряженияАКБ Цикл
				Если СтрокаТаб.Напряжение <= НапряжениеАКБ Тогда 
					НужныйТок = СтрокаТаб.Ток;
				КонецЕсли;
			КонецЦикла;
			
			Если НужныйТок > НастройкаМаксТокЗаряда Тогда // Проверяем что нужный ток не превышает органичение
				НужныйТок = НастройкаМаксТокЗаряда; // если превышает то уменьшаем до ограничения	
			КонецЕсли;
			
			Если НужныйТок = 0 Тогда // Выключаем ШИМ 
				ЗаполненностьШИМ = 0;
			Иначе // настраиваем Шим
				ЗаполненностьШИМ = ?(ТекущийШим = 0, 1, ТекущийШим);
				ЗадатьШИМ(); // Возвращаем значения ШИМ для измерения Тока
				Компонента.Задержка(ЗадержкаПередИзмерениемТока);
				Если ИзмеритьТок() = Истина Тогда // подбираем нужный шим для заданого тока  
					Если ТокАКБ > НужныйТок Тогда // Уменьшаем с шагом в 2 раза
						НижнийШИМ = 0;
						ВерхнийШИМ = ЗаполненностьШИМ; 
									
						Пока ВерхнийШИМ - НижнийШИМ > 1 Цикл
							ЗаполненностьШИМ = Окр((ВерхнийШИМ + НижнийШИМ)/2);
							ЗадатьШИМ();
							Компонента.Задержка(ЗадержкаПередИзмерениемТока);
							Если ИзмеритьТок() <> Истина Тогда //Ошибка, обнуляем ШИМ и прерываем
								НижнийШИМ = 0;
								Прервать;	
							КонецЕсли;
							Если ТокАКБ > НужныйТок Тогда                 
								ВерхнийШИМ = ЗаполненностьШИМ;
							Иначе 
			                	НижнийШИМ = ЗаполненностьШИМ;
							КонецЕсли;						
						КонецЦикла;           
				        ЗаполненностьШИМ = НижнийШИМ;	
					Иначе // Увеличиваем линейно
						Пока ТокАКБ <= НужныйТок Цикл // Увеличиваем до нужноеХначение+16, потом отнимем лишнее
							ЗаполненностьШИМ = ЗаполненностьШИМ + 16;
							Если ЗаполненностьШИМ > 255 Тогда  // выше некуда, цепь замкнута напрямую
								ЗаполненностьШИМ = 255; 
								Прервать;
							Иначе
								ЗадатьШИМ();
								Компонента.Задержка(ЗадержкаПередИзмерениемТока);
								Если ИзмеритьТок() <> Истина Тогда //Ошибка, обнуляем ШИМ и прерываем
		                       		ЗаполненностьШИМ = 0; 
									Прервать;	
								КонецЕсли;	
							КонецЕсли;	
						КонецЦикла;
						Пока ТокАКБ > НужныйТок Цикл
							ЗаполненностьШИМ = ЗаполненностьШИМ - 1;
	                        Если ЗаполненностьШИМ < 0 Тогда  // неже некуда, цепь разъеденена
								ЗаполненностьШИМ = 0; 
								Прервать;
							Иначе
								ЗадатьШИМ();
								Компонента.Задержка(ЗадержкаПередИзмерениемТока);
								Если ИзмеритьТок() <> Истина Тогда //Ошибка, обнуляем ШИМ и прерываем
		                       		ЗаполненностьШИМ = 0; 
									Прервать;	
								КонецЕсли;	
							КонецЕсли;	
						КонецЦикла;
					КонецЕсли;
					//////////////////////////////
				Иначе // Ошибка, обнуляем Шим
					ЗаполненностьШИМ = 0; 	
				КонецЕсли; 
			КонецЕсли;	
		Иначе // произошла ошибка, отключаем АКБ                    
			ЗаполненностьШИМ = 0; 
		КонецЕсли;		
	Иначе
		ЗаполненностьШИМ = 0;  // выключаем заряд АКБ
	КонецЕсли;
	ЗадатьШИМ();
	Компонента.Задержка(ЗадержкаПередИзмерениемТока);
	ИзмеритьТок();
	ИзмеритьНапряжениеАКБСПодключеннымИсточником();
	
КонецПроцедуры

Процедура ПроцессДляСервера() Экспорт // Записывается в процессы НазваниеПроцедуры
	
	NativeS = К.NativeПодключитьКомпоненту();
	Инициализация();
	ПолучитьТекущиеДанные();
	ВыполнитьИтерацию(NativeS);
	ЗаписатьТекущиеДанные();
	
КонецПроцедуры



